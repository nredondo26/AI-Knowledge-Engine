# Mistral AI

## Arquitectura

Mistral es una familia de modelos **decoder-only** desarrollada por Mistral AI (Francia), con un fuerte enfoque en eficiencia, apertura y rendimiento por parámetro. Su arquitectura incorpora todas las innovaciones modernas de transformers:

### Componentes clave

- **Sliding Window Attention (SWA)**: Mistral 7B introdujo atención con ventana deslizante de **8,192 tokens** combinada con atención global para los primeros tokens. Esto reduce el costo de memoria del caché KV de O(L²) a O(L · W) donde W es el tamaño de ventana. Cada token solo atiende a los W tokens anteriores, pero la información fluye a través de capas (profundidad efectiva de ~16W).

- **Rolling Buffer KV Cache**: Implementación que mantiene un buffer circular de tamaño fijo para el caché KV. Cuando se llena, los valores más antiguos se sobrescriben. Ideal para SWA.

- **Pre-fill and Decode separation**: Mistral separa las fases de pre-fill (procesamiento del prompt) y decode (generación autoregresiva) para optimizar el throughput.

- **Mixture of Experts (MoE)**: Mistral 8x22B usa 8 expertos con top-2 routing. Cada token activa solo 2 de 8 expertos FFN, dando acceso efectivo a ~141B parámetros con solo ~39B activos por token.

- **Tekken tokenizer**: Tokenizer basado en SentencePiece con 131K tokens, optimizado para código y multilingüe. Comprime ~30% mejor que el tokenizer de LLaMA 2.

```text
Input → Tekken Tokenizer → Embedding → [Decoder × N] → RMSNorm → LM Head
Cada capa: RMSNorm → GQA + SWA → Residual → RMSNorm → SwiGLU (FFN o MoE) → Residual
                                       ↑
                                Rolling Buffer KV Cache
```

| Modelo | Parámetros | Activos por token | Capas | d_model | Contexto | Ventana SWA |
|--------|-----------|-------------------|-------|---------|----------|-------------|
| Mistral 7B | 7.3B | 7.3B | 32 | 4096 | 32K | 8K |
| Mixtral 8x7B | 46.7B | 12.9B | 32 | 4096 | 32K | 8K |
| Mixtral 8x22B | 141B | 39B | 56 | 6144 | 64K | 8K |
| Mistral Large | ~70B* | ~70B | — | — | 128K | — |
| Mistral Small | ~22B* | ~22B | — | — | 32K | — |

*Estimaciones; Mistral no publica todos los detalles de sus modelos comerciales.

## Capacidades

- **Eficiencia paramétrica**: Mistral 7B supera a LLaMA 2 13B en la mayoría de benchmarks (MMLU 63.7% vs 64.1% con ~50% menos parámetros).
- **Multi-lenguaje natural**: Entrenado con datos multilingües (francés, alemán, español, italiano, inglés). Mistral Large destaca en tareas en español.
- **Function Calling nativo**: La API de Mistral soporta tool use con formato JSON nativo.
- **Código abierto selectivo**: Mistral 7B, Mixtral 8x7B y 8x22B son open-weight (Apache 2.0). Mistral Large/Small son propietarios.
- **Ventana de contexto larga**: Mistral Large ofrece 128K tokens de contexto.
- **Razonamiento matemático**: Mixtral 8x22B alcanza 84.4% en GSM8K.

## API

### Mistral Python SDK

```python
import os
from mistralai import Mistral

client = Mistral(api_key=os.environ["MISTRAL_API_KEY"])

# Chat completion
response = client.chat.complete(
    model="mistral-large-latest",
    messages=[
        {"role": "system", "content": "Responde como un experto en Python."},
        {"role": "user", "content": "Explica los generadores en Python con un ejemplo."}
    ],
    temperature=0.3,
    max_tokens=1024,
    top_p=0.9,
)
print(response.choices[0].message.content)

# Streaming
stream = client.chat.stream(
    model="mistral-large-latest",
    messages=[{"role": "user", "content": "Dime una curiosidad científica"}],
)
for chunk in stream:
    if chunk.data.choices[0].delta.content:
        print(chunk.data.choices[0].delta.content, end="")

# Function Calling
tools = [
    {
        "type": "function",
        "function": {
            "name": "calcular_imc",
            "description": "Calcula el Índice de Masa Corporal",
            "parameters": {
                "type": "object",
                "properties": {
                    "peso_kg": {"type": "number"},
                    "altura_m": {"type": "number"}
                },
                "required": ["peso_kg", "altura_m"]
            }
        }
    }
]
response = client.chat.complete(
    model="mistral-large-latest",
    messages=[{"role": "user", "content": "Mi peso es 70kg y mido 1.75m, ¿cuál es mi IMC?"}],
    tools=tools,
    tool_choice="auto",
)
if response.choices[0].message.tool_calls:
    tc = response.choices[0].message.tool_calls[0]
    print(f"Función: {tc.function.name}, argumentos: {tc.function.arguments}")

# Embeddings
emb = client.embeddings.create(
    model="mistral-embed",
    inputs=["El cielo es azul", "Machine learning es fascinante"],
)
for i, e in enumerate(emb.data):
    print(f"Embedding {i}: dim={len(e.embedding)}, primeros 3 valores={e.embedding[:3]}")

# Uso de Mistral con llama.cpp (modelos open-weight)
# (requiere descargar los pesos de Hugging Face)
import subprocess
result = subprocess.run(
    ["./main", "-m", "mixtral-8x22b-instruct-v0.1.Q4_K_M.gguf",
     "-p", "<s>[INST] ¿Qué es el aprendizaje por refuerzo? [/INST]",
     "-n", "256", "--temp", "0.3"],
    capture_output=True, text=True
)
print(result.stdout)
```

## Costos (USD por 1M tokens, junio 2026)

| Modelo | Input | Output | Contexto |
|--------|-------|--------|----------|
| Mistral Small | $0.20 | $0.60 | 32K |
| Mistral Medium | $0.55 | $1.55 | 32K |
| Mistral Large | $2.00 | $6.00 | 128K |
| Mistral Embed | $0.10 | — | — |

**Self-hosting**: Mixtral 8x22B en 4-bit (Q4_K_M) corre en 2× A100 80GB. Costo estimado: ~$2/hora en cloud.

## Mejores prácticas

1. **Prompt instructivo**: Mistral responde bien a formato `[INST] instrucción [/INST]` (modelos open) o system message (API).
2. **Sliding window aprovechada**: Para documentos largos, colocar la información crítica al inicio o final (los extremos tienen mejor atención global).
3. **Temperatura para código**: Usar temperature=0.0-0.2 para código; 0.5-0.7 para creatividad.
4. **Ventaja MoE**: Mixtral ofrece rendimiento de modelo denso grande con costo de inferencia mucho menor.
5. **Quantization-friendly**: Mistral y Mixtral se cuantizan excelentemente con GPTQ (sin pérdida significativa hasta 4-bit).

```python
# Optimización de inferencia con vLLM + Mistral
from vllm import LLM, SamplingParams

llm = LLM(
    model="mistralai/Mixtral-8x22B-Instruct-v0.1",
    tensor_parallel_size=2,
    max_model_len=32768,
    gpu_memory_utilization=0.95,
)
params = SamplingParams(temperature=0.0, max_tokens=2048)
output = llm.generate(["¿Cuáles son las 3 leyes de la robótica?"], params)
print(output[0].outputs[0].text)
```

## Relaciones

- [LLaMA](../LLaMA/README.md)
- [Quantization](../Quantization/README.md)
- [FineTuning](../FineTuning/README.md)
- [RAG](../../035-RAG/README.md)
- [PromptEngineering](../../039-PromptEngineering/README.md)
