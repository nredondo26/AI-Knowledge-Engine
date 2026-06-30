# LLaMA (Meta AI)

## Arquitectura

LLaMA (Large Language Model Meta AI) es una familia de modelos **decoder-only** que prioriza la eficiencia computacional sobre el número de parámetros total. Su filosofía: entrenar más tokens con menos parámetros.

### Innovations arquitectónicas

- **Pre-normalization con RMSNorm**: Normalización de capas usando Root Mean Square Normalization (Zhang & Sennrich, 2019). Más estable que LayerNorm y más rápida en TPU/GPU.

- **SwiGLU activation**: En lugar de GELU o ReLU, LLaMA usa SwiGLU (Shazeer, 2020). Una FFN con SwiGLU es:
  `FFN(x) = (x · W_gate ⊙ Swish(x · W_1)) · W_2`
  donde `⊙` es multiplicación elemento a elemento y `dim_ff = 2/3 * 4 * d_model` (para compensar las 3 matrices de peso en lugar de 2).

- **Rotary Position Embedding (RoPE)**: Embeddings posicionales rotatorios (Su et al., 2021). Cada par de dimensiones `(2k, 2k+1)` se rota según la posición. RoPE permite extrapolación posicional y no requiere parámetros aprendidos.

- **Grouped-Query Attention (GQA)**: LLaMA 2 70B+ y LLaMA 3 usan GQA — múltiples cabezas de query comparten un mismo par de key/value cabezas. Reduce el caché KV en inferencia de ~30-50%.

- **Vocabularies grandes**: LLaMA 3 usa un tokenizer SentencePiece con **128K tokens** (vs 32K de LLaMA 2), mejorando la eficiencia de tokenización.

```
Input → Tokenizer (SentencePiece BPE) → Embedding → RoPE → [Decoder × N layers] → RMSNorm → Linear
Cada capa: RMSNorm → GQA/Self-Attn → Residual → RMSNorm → SwiGLU-FFN → Residual
                            ↑
                      RoPE aplicado a Q y K
```

| Modelo | Parámetros | Capas | d_model | Cabezas | GQA Groups | Contexto | Tokens entrenamiento |
|--------|-----------|-------|---------|---------|------------|----------|---------------------|
| LLaMA 1 (7B) | 6.7B | 32 | 4096 | 32 | — | 2K | 1T |
| LLaMA 1 (65B) | 65B | 80 | 8192 | 64 | — | 2K | 1.4T |
| LLaMA 2 (70B) | 70B | 80 | 8192 | 64 | 8 | 4K | 2T |
| LLaMA 3 (8B) | 8B | 32 | 4096 | 32 | 4 | 8K | 15T+ |
| LLaMA 3 (70B) | 70B | 80 | 8192 | 64 | 8 | 8K | 15T+ |
| LLaMA 3 (405B) | 405B | 126 | 16384 | 128 | 16 | 128K | 15T+ |

## Capacidades

- **Código abierto**: Pesos disponibles para investigación y uso comercial (LLaMA 3 Community License).
- **Rendimiento competitivo**: LLaMA 3 405B compite con GPT-4 en benchmarks (MMLU: 87.1%, HumanEval: 84.2%).
- **Multi-lenguaje**: Entrenado con datos en +30 idiomas, con rendimiento sólido en español.
- **Tool use nativo**: LLaMA 3.1+ soporta function calling en el formato de chat.
- **Contexto extensible**: LLaMA 3 405B soporta 128K tokens mediante interpolación posicional.
- **Fine-tuning abierto**: Sin restricciones de API — puedes descargar, afinar y desplegar en tu infraestructura.

## API

### Uso con transformers (Hugging Face)

```python
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

model_name = "meta-llama/Llama-3.1-8B-Instruct"

tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype=torch.bfloat16,
    device_map="auto",
    attn_implementation="flash_attention_2",
)

messages = [
    {"role": "system", "content": "Responde en español, sé conciso."},
    {"role": "user", "content": "Explica la diferencia entre SVM y Random Forest."}
]

inputs = tokenizer.apply_chat_template(
    messages,
    tokenize=True,
    add_generation_prompt=True,
    return_tensors="pt"
).to(model.device)

outputs = model.generate(
    inputs,
    max_new_tokens=512,
    temperature=0.3,
    top_p=0.9,
    do_sample=True,
    repetition_penalty=1.05,
)
response = tokenizer.decode(outputs[0][inputs.shape[1]:], skip_special_tokens=True)
print(response)

# Quantized inference con bitsandbytes
from transformers import BitsAndBytesConfig

bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_compute_dtype=torch.bfloat16,
    bnb_4bit_use_double_quant=True,
    bnb_4bit_quant_type="nf4",
)
model_4bit = AutoModelForCausalLM.from_pretrained(
    model_name,
    quantization_config=bnb_config,
    device_map="auto",
)

# API vía Together.ai / Groq / Replicate
import os, requests

response = requests.post(
    "https://api.groq.com/openai/v1/chat/completions",
    headers={"Authorization": f"Bearer {os.environ['GROQ_API_KEY']}"},
    json={
        "model": "llama-3.1-70b-versatile",
        "messages": [{"role": "user", "content": "Hola, ¿quién eres?"}],
    }
)
print(response.json()["choices"][0]["message"]["content"])
```

## Costos

LLaMA es **gratuito para descargar y usar** (pesos abiertos). Los costos asociados dependen de la infraestructura:

| Proveedor | Modelo | Input (por 1M tokens) | Output |
|-----------|--------|----------------------|--------|
 | Groq (LPU) | LLaMA 3 70B | $0.59 | $0.79 |
 | Together.ai | LLaMA 3 70B | $0.90 | $0.90 |
 | Replicate | LLaMA 3 70B | $0.65 | $2.75 |
 | AWS Bedrock | LLaMA 3 70B | $2.25 | $3.25 |
 | Self-hosted (A100 80GB) | LLaMA 3 8B | ~$0.10/hora | — |

**Self-hosting**: Una instancia p3.2xlarge (A100) puede servir LLaMA 3 8B a ~200 requests/s con vLLM.

## Mejores prácticas

1. **Template de chat correcto**: LLaMA usa un formato específico `<|begin_of_text|><|start_header_id|>system<|end_header_id|>...`. Usar `apply_chat_template()` de HuggingFace.
2. **Escalar contexto**: Para secuencias largas, usar interpolación posicional (Linear/PI-RoPE) o NTK-aware scaling.
3. **Sistema de prompting**: LLaMA 3 sigue mejor instrucciones de sistema que versiones anteriores.
4. **Fine-tuning eficiente**: Usar LoRA/QLoRA (ver FineTuning/README.md).
5. **FlashAttention 2**: Activar `attn_implementation="flash_attention_2"` para reducir memoria y acelerar.

```python
# Inferencia con vLLM (para producción)
from vllm import LLM, SamplingParams

llm = LLM(model="meta-llama/Meta-Llama-3.1-8B-Instruct", tensor_parallel_size=1)
sampling_params = SamplingParams(temperature=0.2, max_tokens=512)
outputs = llm.chat(
    messages=[{"role": "user", "content": "Explica RAG en 3 pasos."}],
    sampling_params=sampling_params,
)
print(outputs[0].outputs[0].text)
```

## Relaciones

- [FineTuning](../FineTuning/README.md)
- [Quantization](../Quantization/README.md)
- [RAG](../../035-RAG/README.md)
- [PromptEngineering](../../039-PromptEngineering/README.md)
- [Mistral](../Mistral/README.md)
