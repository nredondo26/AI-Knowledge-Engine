# Fine-Tuning de LLMs

## Introducción

El fine-tuning (ajuste fino) adapta un LLM pre-entrenado a una tarea o dominio específico actualizando sus pesos con datos supervisados. Existen tres paradigmas principales:

1. **Full Fine-Tuning**: Actualiza todos los parámetros del modelo.
2. **Parameter-Efficient Fine-Tuning (PEFT)**: Actualiza un subconjunto mínimo de parámetros (LoRA, Adapters, Prefix Tuning).
3. **RLHF/DPO**: Ajuste por preferencias humanas (ver [RLHF](../RLHF/README.md)).

## Arquitectura de Fine-Tuning

### Full Fine-Tuning

Se propaga gradiente a través de todos los parámetros. Requiere memoria para: parámetros del modelo (FP16), gradientes, optimizer states (Adam: 2× parámetros), y activaciones.

```
Memoria total = 16 × P + 12 × P + 4 × P + activaciones ≈ 32×P + activaciones
     (modelo)    (grad)   (optimizer)
```

Para LLaMA 3 70B: ~70B × 32 bytes ≈ 2.24 TB de VRAM mínimo. Impráctico sin paralelismo masivo.

### LoRA (Low-Rank Adaptation)

LoRA congela los pesos originales e inyecta matrices de descomposición de rango bajo (rank r) en las capas de atención:

```
W' = W_0 + ΔW = W_0 + A × B
donde A ∈ ℝ^{d×r}, B ∈ ℝ^{r×k}, r << min(d, k)
```

- **r** típicamente 8-64. r=16 captura ~99% de la capacidad de fine-tuning.
- Memoria de entrenamiento se reduce de 32×P a ~8×P + 2×P_LoRA.
- Solo se guardan los adaptadores LoRA (tipicamente 1-10 MB vs 140 GB del modelo completo).

### QLoRA

QLoRA combina LoRA con cuantización de 4 bits (NormalFloat4) del modelo base:

1. El modelo base se carga en NF4 (4-bit).
2. Solo los adaptadores LoRA están en FP16/BF16 para entrenamiento.
3. **Double Quantization**: Los escalares de cuantización se cuantizan a 8-bit.
4. **Paged Optimizer**: Usa CPU RAM como swap para estados del optimizador.

```text
Modelo base (NF4 4-bit)  →  [Q]  →  dequant →  forward pass (BF16)
                                            ←  backward pass (BF16)
Adapters LoRA (BF16)     →  gradientes actualizan solo LoRA
```

Esto permite fine-tunear LLaMA 3 70B en una sola GPU A100 80GB.

## API y herramientas

### Fine-tuning con Hugging Face + PEFT + TRL

```python
import torch
from transformers import (
    AutoTokenizer, AutoModelForCausalLM, BitsAndBytesConfig,
    TrainingArguments, DataCollatorForSeq2Seq
)
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from trl import SFTTrainer
from datasets import load_dataset

# 1. Cargar modelo cuantizado
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_use_double_quant=True,
    bnb_4bit_compute_dtype=torch.bfloat16,
)

model_name = "meta-llama/Llama-3.1-8B-Instruct"
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    quantization_config=bnb_config,
    device_map="auto",
    use_cache=False,
)
model = prepare_model_for_kbit_training(model, use_gradient_checkpointing=True)

# 2. Configurar LoRA
lora_config = LoraConfig(
    r=16,
    lora_alpha=32,             # scaling = alpha / r
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM",
)
model = get_peft_model(model, lora_config)
print(f"Parámetros entrenables: {model.num_parameters(only_trainable=True):,} / {model.num_parameters():,}")

# 3. Preparar dataset
dataset = load_dataset("json", data_files="datos_instrucciones.jsonl", split="train")

def format_instruction(example):
    return {
        "text": f"### Instrucción:\n{example['instruction']}\n\n### Respuesta:\n{example['output']}<|end_of_text|>"
    }
dataset = dataset.map(format_instruction)

# 4. Entrenar con SFTTrainer
trainer = SFTTrainer(
    model=model,
    train_dataset=dataset,
    args=TrainingArguments(
        output_dir="./llama-lora-spanish",
        per_device_train_batch_size=4,
        gradient_accumulation_steps=4,
        warmup_steps=100,
        num_train_epochs=3,
        learning_rate=2e-4,
        fp16=True,
        logging_steps=25,
        save_strategy="epoch",
        report_to="none",
    ),
    tokenizer=AutoTokenizer.from_pretrained(model_name),
    max_seq_length=2048,
    dataset_text_field="text",
    data_collator=DataCollatorForSeq2Seq(tokenizer=AutoTokenizer.from_pretrained(model_name), padding=True),
)
trainer.train()
trainer.save_model("./llama-lora-spanish-final")

# 5. Cargar adaptador para inferencia
from peft import PeftModel

base_model = AutoModelForCausalLM.from_pretrained(model_name, device_map="auto", torch_dtype=torch.bfloat16)
model = PeftModel.from_pretrained(base_model, "./llama-lora-spanish-final")
model = model.merge_and_unload()  # fusiona LoRA en pesos base
```

## Hyperparámetros recomendados

| Parámetro | Rango | Recomendado |
|-----------|-------|-------------|
| LoRA rank (r) | 4-128 | 16-64 |
| LoRA alpha | 8-64 | 32 |
| Learning rate | 1e-5 - 5e-4 | 2e-4 (LoRA), 1e-5 (full) |
| Batch size | 4-128 (gradient accumulation) | 64 (efectivo) |
| Epochs | 1-10 | 3 (depende del dataset) |
| Warmup steps | 0-10% de steps | 100 |
| Weight decay | 0.0-0.1 | 0.01 |

## Costos

| Método | GPU | VRAM | Tiempo (LLaMA 8B, 1K ejemplos) | Costo cloud estimado |
|--------|-----|------|-------------------------------|---------------------|
| Full FT | 8× A100 80GB | ~160GB | ~30 min | ~$8 |
| LoRA | 1× A100 80GB (o 3090 24GB) | ~20GB | ~45 min | ~$2 |
| QLoRA | 1× RTX 4090 24GB | ~12GB | ~1h | ~$0.5 |
| OpenAI FT | — | — | ~2h (batch) | ~$25 + hosting |

## Mejores prácticas

1. **Datos de alta calidad > cantidad**: 1,000 ejemplos curados superan 100,000 ruidosos.
2. **Evaluación continua**: Reservar 5-10% del dataset para validación.
3. **Learning rate warmup**: Evita overshoot inicial en los adaptadores LoRA.
4. **Gradient checkpointing**: Reduce VRAM ~30% con ~10% slowdown.
5. **Overfitting watch**: Si loss de validación sube, detener entrenamiento.
6. **Merge adapters**: Después de entrenar, fusionar LoRA en el modelo base para inferencia sin overhead.

## Relaciones

- [LLaMA](../LLaMA/README.md)
- [Mistral](../Mistral/README.md)
- [RLHF](../RLHF/README.md)
- [Quantization](../Quantization/README.md)
- [GPT](../GPT/README.md)
