# Phi (Microsoft)

## Descripción del dominio

Phi es una familia de modelos de lenguaje pequeños (SLMs) desarrollados por Microsoft Research, diseñados para ofrecer rendimiento competitivo con modelos mucho más grandes pero con un costo computacional significativamente menor. La clave de Phi es el uso de datos sintéticos de alta calidad generados por modelos más grandes (como GPT-4) para el entrenamiento, junto con curaduría cuidadosa de datos de texto. Esto permite que modelos con tan solo 1.3B o 2.7B parámetros compitan con modelos de 7B o 13B en tareas de razonamiento, código y comprensión del lenguaje.

## Modelos de la familia Phi

- **Phi-1 (1.3B)**: Modelo especializado en código Python. Entrenado en datos sintéticos (textbooks) generados por GPT-3.5/4. Rendimiento comparable a GPT-3.5 en HumanEval.
- **Phi-1.5 (1.3B)**: Versión que extiende Phi-1 a lenguaje natural además de código. Entrenado con datos sintéticos y curados. Buen rendimiento en benchmarks de razonamiento.
- **Phi-2 (2.7B)**: Modelo más grande de la familia. Rendimiento superior a modelos de 7B (Mistral-7B, LLaMA-2-7B) en múltiples benchmarks. Entrenado con datos sintéticos de mayor calidad.
- **Phi-3 (3.8B)**: Modelo de próxima generación con context window de 128K tokens. Disponible en versiones mini (3.8B), small (7B) y medium (14B). Soporta fine-tuning eficiente con QLoRA.
- **Phi-3.5 (3.8B)**: Versión mejorada de Phi-3 con capacidades multi-lingües y multi-modales (visión + texto).

## Ejemplo: Cargar y usar Phi-2 con Hugging Face Transformers

```python
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

model_name = "microsoft/phi-2"
tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype=torch.float16,
    device_map="auto",
    trust_remote_code=True
)

prompt = "Write a Python function to check if a number is prime:"
inputs = tokenizer(prompt, return_tensors="pt").to("cuda")
outputs = model.generate(
    **inputs,
    max_new_tokens=200,
    temperature=0.0,
    do_sample=False
)
response = tokenizer.decode(outputs[0], skip_special_tokens=True)
print(response)
```

## Ejemplo: Fine-tuning de Phi-2 con QLoRA

```python
!pip install peft bitsandbytes transformers datasets

from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from transformers import AutoModelForCausalLM, BitsAndBytesConfig, TrainingArguments
from trl import SFTTrainer

bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_use_double_quant=True
)

model = AutoModelForCausalLM.from_pretrained(
    "microsoft/phi-2",
    quantization_config=bnb_config,
    device_map="auto",
    trust_remote_code=True
)
model = prepare_model_for_kbit_training(model)

lora_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "v_proj", "k_proj", "o_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)
model = get_peft_model(model, lora_config)

# Configurar trainer (dataset propio)
# training_args = TrainingArguments(...)
# trainer = SFTTrainer(model=model, args=training_args, ...)
# trainer.train()
```

## Tecnologías principales

- **Modelos**: Phi-1, Phi-1.5, Phi-2, Phi-3, Phi-3.5 (mini, small, medium).
- **Entrenamiento**: Datos sintéticos generados por GPT-4, curaduría de textbooks, filtrado de calidad.
- **Arquitectura**: Transformer decoder-only (similar a GPT/Llama). Phi-3 soporta 128K tokens.
- **Fine-tuning**: Compatible con PEFT/LoRA, QLoRA, transformers, TRL.
- **Despliegue**: ONNX Runtime, llama.cpp, Ollama, DirectML (Windows).
- **Licencia**: MIT (Phi-1, Phi-2, Phi-3 mini). Permisiva para uso comercial e investigación.

## Hoja de ruta

1. Probar Phi-2 en Hugging Face: carga, inferencia, exploración de capacidades.
2. Comparar rendimiento de Phi-2 vs. modelos de 7B en benchmarks (MMLU, GSM8K, HumanEval).
3. Fine-tuning de Phi-2 con QLoRA para una tarea específica (clasificación, generación).
4. Despliegue de Phi-2 en local con Ollama o llama.cpp (cuantizado GGUF).
5. Explorar Phi-3: context window de 128K, versiones mini/small/medium.
6. Phi-3.5: capacidades multi-modales (texto + imágenes).
7. Evaluar trade-off rendimiento/eficiencia de Phi vs. modelos más grandes.

## Relaciones con otros módulos

- `../Routing/`: Phi es ideal como modelo rápido/económico para consultas simples en un router.
- `../Caching/`: Phi responde rápido, reduce necesidad de cache.
- `../Evaluation/`: Evaluar rendimiento de Phi frente a benchmarks comparativos.
- `../../033-DeepLearning/ModelOptimization/`: Phi como ejemplo de modelo optimizado por diseño (pequeño y eficiente).

## Recursos recomendados

- **Paper**: "Textbooks Are All You Need" (Phi-1, 2023).
- **Paper**: "Phi-2: The Surprising Power of Small Language Models" (2023).
- **Paper**: "Phi-3 Technical Report" (2024).
- **Repositorio**: microsoft/phi-2 (Hugging Face), microsoft/Phi-3 (GitHub).
- **Blog**: "Phi-2: A Small Language Model that Packs a Punch" (Microsoft Research Blog).
