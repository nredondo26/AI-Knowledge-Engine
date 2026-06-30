# GPT (Generative Pre-trained Transformer)

## Arquitectura

GPT se basa en el **decoder-only Transformer**. A diferencia del encoder-decoder de Vaswani et al., GPT apila únicamente bloques decoder con **self-attention enmascarada** (causal mask) para garantizar que la predicción del token `t` solo dependa de los tokens `1..t-1`. Cada bloque contiene:

- **Multi-Head Causal Self-Attention**: Normalized dot-product attention con máscara causal. GPT-3 usa 96 cabezas en 96 capas.
- **Feed-Forward Network (FFN)**: Dos capas lineales con activación GELU. Dimensión interna `4 * d_model` (12,288 para GPT-3 175B).
- **Pre-Layer Normalization**: RMSNorm antes de cada subcapa (GPT-3 usa LayerNorm post-subcapa; GPT-4 adoptó pre-norm).
- **Residual Connections**: Conexiones residuales alrededor de cada subcapa.

```text
Input Tokens → Embedding + Positional Encoding → [Bloque Decoder × N] → LayerNorm → LM Head
Cada Bloque: Attn → Residual → FFN → Residual
```

La **atención dispersa** (Sparse Attention) y **FlashAttention** se usan en GPT-4 para reducir el costo cuadrático O(n²) a O(n log n) en ventanas largas.

Especificaciones clave de las versiones principales:

| Versión | Parámetros | Capas | d_model | Cabezas | Contexto | Entrenamiento |
|---------|-----------|-------|---------|---------|----------|---------------|
| GPT-1   | 117M      | 12    | 768     | 12      | 512      | BooksCorpus   |
| GPT-2   | 1.5B      | 48    | 1600    | 25      | 1024     | WebText       |
| GPT-3   | 175B      | 96    | 12288   | 96      | 2048     | Common Crawl  |
| GPT-4   | ~1.76T*   | ~120  | ~16384  | ~128    | 128K     | Multimodal    |

*Estimación no oficial; OpenAI no ha publicado el tamaño exacto.

## Capacidades

- **Razonamiento complejo**: GPT-4 supera el 90% en simulated bar exam y SAT.
- **Code generation**: Soporta +50 lenguajes; HumanEval pass@1 de 67% (GPT-3) a 87% (GPT-4).
- **Multimodalidad** (GPT-4V/4o): Procesa imágenes, audio y texto simultáneamente.
- **Function Calling**: Invoca APIs externas con formato estructurado JSON.
- **Ventana de contexto**: 128K tokens en GPT-4 Turbo/4o (equivalente a ~300 páginas).
- **System Prompting**: Instrucciones de sistema persistentes para control de comportamiento.

## API

### OpenAI Python API v1.x

```python
import os
from openai import OpenAI

client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

# Chat Completion
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "Eres un experto en PLN."},
        {"role": "user", "content": "Explica el concepto de atención en transformers."}
    ],
    temperature=0.3,
    max_tokens=1024,
    top_p=0.95,
    frequency_penalty=0.0,
    presence_penalty=0.0,
)
print(response.choices[0].message.content)

# Streaming
stream = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[{"role": "user", "content": "Cuenta un chiste"}],
    stream=True,
)
for chunk in stream:
    if chunk.choices[0].delta.content is not None:
        print(chunk.choices[0].delta.content, end="")

# Function Calling
tools = [
    {
        "type": "function",
        "function": {
            "name": "get_clima",
            "description": "Obtiene el clima de una ciudad",
            "parameters": {
                "type": "object",
                "properties": {
                    "ciudad": {"type": "string"},
                    "pais": {"type": "string"}
                },
                "required": ["ciudad"]
            }
        }
    }
]
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "¿Clima en Madrid?"}],
    tools=tools,
    tool_choice="auto"
)
tool_call = response.choices[0].message.tool_calls[0]
print(f"Función: {tool_call.function.name}")
print(f"Args: {tool_call.function.arguments}")

# Embeddings
emb = client.embeddings.create(
    model="text-embedding-3-small",
    input="Texto a embedder",
    dimensions=256  # text-embedding-3 permite reducir dimensiones
)
print(f"Vector: {emb.data[0].embedding[:5]}... (dim={len(emb.data[0].embedding)})")
```

## Costos (USD por 1K tokens, junio 2026)

| Modelo        | Input  | Output | Contexto |
|---------------|--------|--------|----------|
| GPT-4o        | $0.005 | $0.015 | 128K     |
| GPT-4o-mini   | $0.00015 | $0.0006 | 128K   |
| GPT-4 Turbo   | $0.01  | $0.03  | 128K     |
| o3 (razonamiento) | $0.01 | $0.04 | 200K  |
| text-embedding-3-small | $0.00002 | — | — |

**Estrategias de optimización:**
1. Usar **GPT-4o-mini** para tareas simples y GPT-4o solo para razonamiento crítico.
2. Reducir `max_tokens` al mínimo necesario.
3. Cachear respuestas idénticas (cache semántico con embeddings).
4. Comprimir historial de conversación con sumarización periódica.

## Mejores prácticas

1. **System prompt eficaz**: Instrucciones claras, formato definido, ejemplos (few-shot).
2. **Temperature baja** (0.0-0.3) para tareas determinísticas; alta (0.7-1.0) para creatividad.
3. **Retry con backoff exponencial** ante errores 429 (rate limit) o 500.
4. **Validación de salida**: Usar Pydantic para parsear JSON generado.
5. **Prompt caching**: Repetir bloques estáticos del prompt se cachea automáticamente en GPT-4o (gracias a prefix caching).
6. **Guardar `usage`** de cada response para auditoría de costos.

```python
# Validación estructurada con Pydantic
from pydantic import BaseModel

class Resumen(BaseModel):
    titulo: str
    puntos_clave: list[str]
    longitud_palabras: int

def generar_resumen(texto: str) -> Resumen:
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": f"Resume:\n{texto}\n\nJSON con: titulo, puntos_clave, longitud_palabras"}],
        response_format={"type": "json_object"},
        temperature=0.1
    )
    return Resumen.model_validate_json(response.choices[0].message.content)
```

## Relaciones

- [PromptEngineering](../../039-PromptEngineering/README.md)
- [RAG](../../035-RAG/README.md)
- [AgenticAI](../../037-AgenticAI/README.md)
- [FineTuning](../FineTuning/README.md)
- [RLHF](../RLHF/README.md)
