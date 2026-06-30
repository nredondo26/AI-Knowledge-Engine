# RLHF (Reinforcement Learning from Human Feedback)

## Introducción

RLHF (Aprendizaje por Refuerzo con Retroalimentación Humana) es la técnica que alinea modelos de lenguaje con preferencias humanas. Fue introducido por OpenAI en 2020 (InstructGPT) y adoptado por todos los LLMs comerciales. Sin RLHF, los LLMs optimizados solo por loss de lenguaje generan texto fluido pero no necesariamente útil, honesto o seguro.

### Pipeline RLHF (3 fases)

```
Fase 1: SFT (Supervised Fine-Tuning)
  Dataset de demostraciones → Fine-tuning supervisado del modelo base

Fase 2: Reward Modeling (RM)
  Dataset de comparaciones humanas → Entrenar Reward Model

Fase 3: RL Optimization (PPO)
  Modelo SFT + Reward Model → Optimización con PPO
```

## Fase 1: SFT (Instruction Tuning)

Se fine-tunea el modelo pre-entrenado con pares (instrucción, respuesta deseada) escritos por humanos. Este paso convierte al modelo base en un asistente útil pero no necesariamente alineado en valores.

```text
Base: "¿Cómo hacer una bomba?" → salida insegura
SFT:  "¿Cómo hacer una bomba?" → "No puedo ayudar con eso."
```

## Fase 2: Reward Model

### Arquitectura

El Reward Model (RM) es un transformer (generalmente del mismo tamaño que el modelo a alinear o más pequeño) que recibe una respuesta y produce un **escalar** (reward score). La arquitectura típica:

- Base: modelo de lenguaje (e.g., GPT-2, LLaMA) sin LM head.
- Head: MLP de 2 capas (hidden dim → 1) con salida sigmoide o lineal.
- Se entrena con **comparaciones por pares** (A > B).

### Loss function (Bradley-Terry)

```
P(y_A > y_B | x) = σ(r(x, y_A) - r(x, y_B))
Loss = -log σ(r(x, y_A) - r(x, y_B))
```

Donde `y_A` es la respuesta preferida, `y_B` la no preferida, y `r` es la salida del Reward Model.

```python
import torch
import torch.nn as nn

class RewardModelLoss(nn.Module):
    def __init__(self):
        super().__init__()

    def forward(self, rewards_chosen: torch.Tensor, rewards_rejected: torch.Tensor) -> torch.Tensor:
        # Bradley-Terry pairwise loss
        # rewards_chosen: reward para la respuesta preferida
        # rewards_rejected: reward para la no preferida
        logits = rewards_chosen - rewards_rejected
        loss = -torch.nn.functional.logsigmoid(logits).mean()
        return loss
```

### Dataset de preferencias

Cada ejemplo tiene: `(prompt, respuesta_A, respuesta_B, preferencia)`. Formatos populares:

- **Anthropic Helpful & Harmless (HH-RLHF)**: ~170K comparaciones
- **Stanford SHP**: ~385K comparaciones en 18 categorías
- **OpenAI WebGPT Comparisons**: ~20K comparaciones
- **UltraFeedback**: ~64K prompts con 4 respuestas cada uno (Bootstrapped with GPT-4)

## Fase 3: PPO (Proximal Policy Optimization)

PPO optimiza el modelo SFT usando el Reward Model como señal de recompensa, con una **penalización KL** para no alejarse demasiado del modelo SFT (evitar reward hacking).

### Función objetivo PPO para RLHF

```
L(π_θ) = E_{x ~ D, y ~ π_θ(y|x)} [r(x, y)] - β · KL(π_θ(y|x) || π_SFT(y|x))
         ↑ recompensa del RM       ↑ penalización por divergencia
```

Donde:
- `π_θ`: modelo policy (lo que entrenamos)
- `π_SFT`: modelo SFT congelado (referencia)
- `β`: coeficiente de regularización KL (típicamente 0.01-0.1)
- `r(x, y)`: salida del Reward Model (puede incluir escalado)

## Implementación con TRL

```python
# TRL (Transformer Reinforcement Learning) simplifica RLHF enormemente
from trl import PPOConfig, PPOTrainer
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
import torch

# 1. Cargar modelo y tokenizer
model_name = "meta-llama/Llama-3.1-8B-Instruct"
model = AutoModelForCausalLM.from_pretrained(model_name, torch_dtype=torch.bfloat16)
ref_model = AutoModelForCausalLM.from_pretrained(model_name, torch_dtype=torch.bfloat16)
tokenizer = AutoTokenizer.from_pretrained(model_name)
tokenizer.pad_token = tokenizer.eos_token

# 2. Cargar Reward Model (fine-tuneado con pairwise loss)
reward_pipeline = pipeline(
    "text-classification",
    model="OpenAssistant/reward-model-deberta-v3-large-v2",
    device=0,
    torch_dtype=torch.bfloat16,
)

def reward_fn(prompts, responses, **kwargs):
    texts = [f"### Prompt:\n{p}\n### Response:\n{r}" for p, r in zip(prompts, responses)]
    outputs = reward_pipeline(texts, return_all_scores=False, truncation=True)
    return torch.tensor([o["score"] for o in outputs], dtype=torch.bfloat16)

# 3. Configurar PPO
ppo_config = PPOConfig(
    learning_rate=1e-5,
    batch_size=16,
    gradient_accumulation_steps=4,
    mini_batch_size=4,
    ppo_epochs=4,
    kl_penalty="kl",           # KL penalty adaptativa
    init_kl_coef=0.05,
    target=6,                   # KL target (adaptive KL controller)
    horizon=10000,
    gamma=0.99,
    lam=0.95,
    cliprange=0.2,
    cliprange_value=0.2,
    vf_coef=0.1,
    remove_unused_columns=False,
)

# 4. Preparar dataset
from datasets import load_dataset
dataset = load_dataset("Anthropic/hh-rlhf", split="train[:1000]")
dataset = dataset.map(lambda x: {"query": x["chosen"][:512]})  # truncar prompts

# 5. Entrenar PPO
ppo_trainer = PPOTrainer(
    config=ppo_config,
    model=model,
    ref_model=ref_model,
    tokenizer=tokenizer,
    dataset=dataset,
)

for epoch in range(3):
    for batch in ppo_trainer.dataloader:
        query_tensors = [tokenizer(q, return_tensors="pt").input_ids[0] for q in batch["query"]]

        # Generar respuesta con modelo actual
        response_tensors = ppo_trainer.generate(query_tensors, max_new_tokens=256)
        batch["response"] = [tokenizer.decode(r, skip_special_tokens=True) for r in response_tensors]

        # Calcular reward
        rewards = reward_fn(batch["query"], batch["response"])

        # Paso PPO
        stats = ppo_trainer.step(query_tensors, response_tensors, rewards)
        print(f"Epoch {epoch}, reward: {stats['objective/rewards']:.3f}, kl: {stats['objective/kl']:.4f}")

    # Guardar checkpoint
    ppo_trainer.save_model(f"./llama-rlhf-checkpoint-{epoch}")
```

## DPO (Direct Preference Optimization)

Alternativa a RLHF que elimina la necesidad de Reward Model explícito:

```python
from trl import DPOTrainer, DPOConfig

dpo_config = DPOConfig(beta=0.1, max_length=1024, max_prompt_length=512, learning_rate=5e-6)
dpo_trainer = DPOTrainer(model=model, ref_model=ref_model, args=dpo_config,
                         train_dataset=dataset_dpo, tokenizer=tokenizer)
dpo_trainer.train()
```

### RLHF vs DPO

| Aspecto | RLHF (PPO) | DPO |
|---------|-----------|-----|
| Reward Model | Necesario (entrenar por separado) | No necesario |
| Estabilidad | Inestable (PPO sensible a hparams) | Estable |
| Calidad de alineación | Generalmente mejor | Muy cercana |
| Costo computacional | Alto (RM + PPO + SFT) | Bajo (solo SFT-like) |
| Complejidad implementación | Alta | Baja |
| Muestreo online | Sí (genera respuestas durante entrenamiento) | No (dataset fijo) |

## Mejores prácticas

1. **Dataset de preferencias balanceado**: Igual proporción de respuestas chosen/rejected.
2. **Reward Model del mismo tamaño**: RM debe ser comparable al modelo a alinear.
3. **Normalización de rewards**: Normalizar rewards por batch (z-score) para estabilidad.
4. **KL penalty adaptativa**: Usar adaptive KL controller (target KL) para evitar divergencia.
5. **PPO epochs bajos**: 3-4 epochs de PPO para evitar over-optimization del reward.
6. **DPO para prototipos**: Usar DPO para experimentación rápida; RLHF para producción.
7. **Evaluación continua**: Monitorear reward, KL divergence, y calidad de salida humana.

## Relaciones

- [FineTuning](../FineTuning/README.md)
- [GPT](../GPT/README.md)
- [Claude](../Claude/README.md)
- [Quantization](../Quantization/README.md)
- [PromptEngineering](../../039-PromptEngineering/README.md)
