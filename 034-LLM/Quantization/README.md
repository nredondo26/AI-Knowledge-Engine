# Quantization de LLMs

## Introducción

La cuantización reduce la precisión numérica de los pesos (y ocasionalmente activaciones) de un LLM para disminuir el uso de memoria y acelerar inferencia. Un modelo de 70B en FP32 (280 GB) no cabe en ninguna GPU; en 4-bit ocupa ~35 GB y corre en una sola A100 80GB.

### Tipos de cuantización

| Tipo | Bits | Almacenamiento | Degradación típica |
|------|------|---------------|-------------------|
| FP32 (float32) | 32 bits | 4 bytes/param | — |
| FP16 (half) | 16 bits | 2 bytes/param | ~0.1% perplejidad |
| BF16 (bfloat16) | 16 bits | 2 bytes/param | ~0.05% perplejidad |
| INT8 (8-bit) | 8 bits | 1 byte/param | ~0.5-1% |
| INT4 (4-bit) | 4 bits | 0.5 bytes/param | ~1-3% |
| NF4 (NormalFloat4) | 4 bits | 0.5 bytes/param | ~0.5-1% |
| INT2 / Ternary | 2 bits | 0.25 bytes/param | ~5-15% |
| Binary (1-bit) | 1 bit | 0.125 bytes/param | ~15-30% |

```
Ejemplo: LLaMA 3 70B
  FP16 = 70B × 2B = 140 GB
  INT8 = 70B × 1B = 70 GB
  NF4  = 70B × 0.5B = 35 GB
  INT2 = 70B × 0.25B = 17.5 GB
```

## Arquitectura de métodos

### 1. Post-Training Quantization (PTQ)

Cuantiza pesos ya entrenados, sin re-entrenamiento.

**GPTQ** (Frantar et al., 2023):
- Cuantización óptima basada en Optimal Brain Quantization (OBQ).
- Procesa columnas de la matriz de pesos secuencialmente.
- Compensa el error de cuantización actualizando pesos no cuantizados.
- Soporta grupos de 128 canales (g=128).
- Resultado: modelo listo para GPU (GPU-only).

**AWQ** (Lin et al., 2024):
- Observa que no todos los canales son igualmente importantes.
- Escala los pesos por la importancia de sus canales (proporcional a las activaciones).
- Solo el 1% de los canales necesita protección especial.
- Más rápido que GPTQ manteniendo perplejidad similar.

**GGUF / llama.cpp**:
- Formato de archivo de cuantización para CPU (y GPU).
- implementación en C/C++ sin dependencias pesadas (PyTorch).
- Soporta múltiples tipos: Q2_K, Q3_K, Q4_K_M, Q5_K_M, Q6_K, Q8_0.
- `Q4_K_M` es el punto dulce calidad/rendimiento.

**HQQ** (Half-Quadratic Quantization):
- Método rápido de cuantización (segundos vs horas de GPTQ).
- Sin datos de calibración (data-free).
- Adecuado para despliegue rápido en entornos restringidos.

### 2. Quantization-Aware Training (QAT)

Entrena el modelo con cuantización simulada (fake quantization) en el forward pass. Los gradientes se propagan a través de las operaciones de cuantización usando **Straight-Through Estimator (STE)**.

```
Forward:  W_q = quantize(W)  →  compute(W_q, x)
Backward: ∂L/∂W ≈ ∂L/∂W_q    (STE: ignora cuantización en backward)
```

- **LLM-QAT** (Liu et al., 2024): QAT para LLMs con distilación de conocimiento del modelo original.
- 2-3× más costo de entrenamiento que PTQ pero mejor precisión, especialmente en 4-bit o menos.

## APIs y herramientas

### GPTQ con AutoGPTQ

```python
from transformers import AutoTokenizer, AutoModelForCausalLM
from auto_gptq import AutoGPTQForCausalLM, BaseQuantizeConfig

# Cuantizar modelo
model_name = "meta-llama/Meta-Llama-3.1-8B-Instruct"
quantize_config = BaseQuantizeConfig(
    bits=4,
    group_size=128,
    desc_act=False,           # quantize por fila (más rápido)
    damp_percent=0.01,
)

model = AutoGPTQForCausalLM.from_pretrained(
    model_name,
    quantize_config=quantize_config,
)
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Dataset de calibración (128-256 secuencias)
from datasets import load_dataset
calibration_data = load_dataset("wikitext", "wikitext-2-raw-v1", split="train")
examples = [tokenizer(text["text"]) for text in calibration_data.select(range(128))]

model.quantize(examples, batch_size=1)
model.save_quantized("./llama3-4bit-gptq")

# Inferencia cuantizada
model = AutoGPTQForCausalLM.from_quantized(
    "./llama3-4bit-gptq",
    device="cuda:0",
    use_triton=True,          # kernel Triton más rápido
)
inputs = tokenizer("La capital de Francia es", return_tensors="pt").to("cuda")
outputs = model.generate(**inputs, max_new_tokens=50)
print(tokenizer.decode(outputs[0]))
```

### AWQ con AutoAWQ

```python
from awq import AutoAWQForCausalLM
from transformers import AutoTokenizer

model_name = "mistralai/Mixtral-8x22B-Instruct-v0.1"

model = AutoAWQForCausalLM.from_pretrained(
    model_name,
    device_map="auto",
)
tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)

# Calibración
from datasets import load_dataset
data = load_dataset("wikitext", "wikitext-2-raw-v1", split="train")
calib = [text for text in data["text"][:256]]

# Cuantizar AWQ
model.quantize(
    tokenizer,
    calib,
    bits=4,
    group_size=128,
    zero_point=True,
    version="gemm",  # o "gemv" (más rápido)
)
model.save_quantized("./mixtral-awq-4bit")

# Inferencia
model = AutoAWQForCausalLM.from_quantized(
    "./mixtral-awq-4bit",
    device_map="auto",
)
```

### llama.cpp / GGUF

```python
# 1. Convertir modelo a GGUF desde Hugging Face
# (usar la herramienta convert_hf_to_gguf.py de llama.cpp)

# 2. Cuantizar con llama-quantize
# ./llama-quantize ./models/llama-8b-f16.gguf ./models/llama-8b-q4_k_m.gguf Q4_K_M

# 3. Inferencia con Python (llama-cpp-python)
from llama_cpp import Llama

llm = Llama(
    model_path="./models/llama-8b-q4_k_m.gguf",
    n_ctx=8192,
    n_gpu_layers=-1,  # todas las capas en GPU (si disponible)
    n_threads=8,
    verbose=False,
)
output = llm(
    "¿Qué es la cuantización de modelos?",
    max_tokens=256,
    temperature=0.3,
    stop=["\n\n"],
)
print(output["choices"][0]["text"])
```

## Comparativa de métodos

| Método | Velocidad cuantiz. | Velocidad inferencia | Pérdida (4-bit) | GPU/CPU | Uso recomendado |
|--------|-------------------|---------------------|-----------------|---------|----------------|
| GPTQ | Lento (horas) | Rápido | ~1% | GPU | Producción en GPU |
| AWQ | Medio (minutos) | Muy rápido | ~0.8% | GPU | Producción, mejor throughput |
| GGUF/Q4_K_M | Rápido | Medio (CPU) / Bueno (GPU) | ~1% | CPU+GPU | Uso local, portátil |
| HQQ | Muy rápido (s) | Rápido | ~1.5% | GPU | Despliegue rápido |
| BitsAndBytes | Instantáneo | Lento (dequant online) | ~1.2% | GPU | Fine-tuning (QLoRA) |

## Costos (hardware para inferencia, modelos 70B-8B)

| Configuración | VRAM | Modelo 70B | Modelo 8B | Costo cloud/hora |
|--------------|------|-----------|----------|-----------------|
| FP16 | 140 GB / 16 GB | 4× A100 (imposible 8B) | 1× A100 | $4-16 (70B) |
| INT8 | 70 GB / 8 GB | 1× A100 80GB (70B) | 1× RTX 3070 (8B) | $1-2 |
| NF4/INT4 | 35 GB / 4 GB | 1× A100 40GB (70B) | 1× RTX 3060 (8B) | $0.5-1 |
| GGUF Q4_K_M | CPU RAM | ~40 GB RAM | ~5 GB RAM | — |

## Mejores prácticas

1. **Para fine-tuning**: Usar NF4 de bitsandbytes (QLoRA). Es el único método que soporta backward pass.
2. **Para producción GPU**: AWQ (mejor throughput) o GPTQ (mejor calidad marginal).
3. **Para CPU/local**: GGUF Q4_K_M o Q5_K_M. Q8_0 si hay RAM suficiente.
4. **Group size 128 → 32**: Group size más pequeño mejora calidad pero reduce velocidad.
5. **Desc_act (act_order)**: En GPTQ, activarlo mejora calidad pero requiere Triton/transformers específicos.
6. **Calibration dataset**: Usar 128-256 ejemplos representativos del dominio objetivo (no genéricos).

## Relaciones

- [LLaMA](../LLaMA/README.md)
- [Mistral](../Mistral/README.md)
- [FineTuning](../FineTuning/README.md)
- [RLHF](../RLHF/README.md)
