# Claude (Anthropic)

## Arquitectura

Claude utiliza una arquitectura **Transformer decoder-only** con innovaciones propietarias desarrolladas por Anthropic. A diferencia de GPT, Claude incorpora **Constitutional AI (CAI)** directamente en el entrenamiento, no solo como post-procesamiento.

Componentes arquitectónicos clave:

- **Transformer decoder modificado**: Similar a GPT pero con capas de atención y FFN optimizadas.
- **Atención de contexto largo**: Claude 3.5 Sonnet y 4 Opus soportan hasta **200K tokens** con **ventana deslizante** y atención dispersa.
- **Constitutional AI**: El modelo se entrena mediante RL con un conjunto de principios constitucionales (respeto, honestidad, ayuda) en lugar de depender exclusivamente de feedback humano.
- **HHA (Helpful, Honest, Harmless)**: Marco de tres ejes que guía el comportamiento del modelo.
- **Multi-turn coherence**: Claude está específicamente entrenado para mantener coherencia en conversaciones largas mediante **memory consolidation** durante el fine-tuning.

```text
Input → Tokenizer (cl100k_base-like) → Embedding → [Decoder × N layers] → Unembedding → Logits
      └→ System Prompt (persistente en contexto) ← Constitutional Constraints →┘
```

Diferencias frente a GPT:

| Aspecto | Claude | GPT |
|---------|--------|-----|
| Entrenamiento | RL + CAI (constitutional) | RLHF (human feedback) |
| Ventana | 200K tokens | 128K tokens |
| System prompt | Siempre presente, muy influyente | Opcional |
| Alineación | Énfasis en rechazo seguro | Énfasis en utilidad |
| Multimodalidad | Texto + imágenes (Sonnet/Opus) | Texto + imágenes + audio |

### Versiones

| Modelo | Parámetros | Ventana | Lanzamiento |
|--------|-----------|---------|-------------|
| Claude 1 | ~52B* | 9K | 2023 |
| Claude 2 | ~137B* | 100K | 2023 |
| Claude 3 Haiku | ~20B* | 200K | 2024 |
| Claude 3 Sonnet | ~70B* | 200K | 2024 |
| Claude 3 Opus | ~500B* | 200K | 2024 |
| Claude 3.5 Sonnet | ~175B* | 200K | 2024 |
| Claude 4 Opus | ~1T* | 200K | 2026 |

*Estimaciones; Anthropic no publica tamaños exactos.

## Capacidades

- **Razonamiento profundo**: Claude 4 Opus alcanza ~90% en MMLU y destaca en matemáticas (GSM8K).
- **Análisis de documentos largos**: Lectura y síntesis de documentos de hasta 200K tokens (~150,000 palabras).
- **Code generation de alta calidad**: Claude 3.5 Sonnet lidera SWE-bench (resolución de issues reales de GitHub).
- **Procesamiento de imágenes**: OCR, descripción de diagramas, análisis de gráficos.
- **Tool Use / Function Calling**: Uso de herramientas externas definidas por el usuario.
- **Rechazo seguro**: Claude rechaza solicitudes peligrosas con explicación, no solo con negación.

## API

### Anthropic Python SDK

```python
import anthropic
import os

client = anthropic.Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])

# Mensaje básico
response = client.messages.create(
    model="claude-4-opus-20260514",
    max_tokens=1024,
    temperature=0.0,
    system="Eres un asistente experto en arquitectura de ML.",
    messages=[
        {
            "role": "user",
            "content": "Explica cómo funciona la atención multi-cabeza."
        }
    ]
)
print(response.content[0].text)

# Streaming
with client.messages.stream(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    system="Responde en español.",
    messages=[{"role": "user", "content": "Escribe un poema sobre IA"}]
) as stream:
    for text in stream.text_stream:
        print(text, end="")

# Tool Use (Function Calling)
tools = [
    {
        "name": "buscar_wikipedia",
        "description": "Busca artículos en Wikipedia",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {"type": "string"},
                "lang": {"type": "string", "default": "es"}
            },
            "required": ["query"]
        }
    }
]
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=2048,
    system="Usa herramientas cuando sea necesario.",
    messages=[{"role": "user", "content": "Busca información sobre transformers en Wikipedia"}],
    tools=tools,
)
# Claude devuelve tool_use en content
for block in response.content:
    if block.type == "tool_use":
        print(f"Llamar: {block.name}({block.input})")

# Procesamiento de imagen
import base64

with open("diagrama.png", "rb") as f:
    img_data = base64.b64encode(f.read()).decode("utf-8")

response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    messages=[{
        "role": "user",
        "content": [
            {"type": "image", "source": {"type": "base64", "media_type": "image/png", "data": img_data}},
            {"type": "text", "text": "Describe este diagrama en detalle."}
        ]
    }]
)
print(response.content[0].text)
```

## Costos (USD por 1M tokens de input / output, junio 2026)

| Modelo | Input | Output | Ventana |
|--------|-------|--------|---------|
| Claude 4 Opus | $15.00 | $75.00 | 200K |
| Claude 3.5 Sonnet | $3.00 | $15.00 | 200K |
| Claude 3 Haiku | $0.25 | $1.25 | 200K |
| Claude 3 Opus | $15.00 | $75.00 | 200K |

**Estrategias de optimización:**
1. **Prompt caching**: Claude cachea automáticamente prefijos largos (system prompt + ejemplos). El costo de input cacheado se reduce ~90%.
2. Usar **Haiku** para clasificación y extracción; **Sonnet** para razonamiento; **Opus** solo para tareas críticas.
3. **Batch API** para procesamiento asíncrono masivo (50% descuento).

```python
# Procesamiento batch
requests = [
    {"custom_id": f"req-{i}", "params": {"model": "claude-3-haiku-20240307", "max_tokens": 100, "messages": [{"role": "user", "content": f"Clasifica: {text}"}]}}
    for i, text in enumerate(textos)
]
client.beta.messages.batches.create(requests=requests)
```

## Mejores prácticas

1. **System prompt detallado**: Claude responde excepcionalmente bien a instrucciones de sistema largas y detalladas.
2. **Prefijo de asistencia**: Claude prefiere que el mensaje de usuario especifique el formato de salida esperado.
3. **Evitar jailbreaks**: Usar filtros de contenido en el lado del cliente para inputs/outputs.
4. **Tool use con descripciones claras**: Las descripciones de herramientas influyen en si Claude decide usarlas.
5. **Temperatura 0 para tareas factuales**: Para creatividad, usar 0.5-0.7.

```python
# Mejor práctica: especificar formato de salida
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=500,
    temperature=0.0,
    system="Eres un asistente que SOLO responde con JSON válido.",
    messages=[{
        "role": "user",
        "content": "Extrae entidades del texto: 'Apple compró OpenAI por $500B'\n\n{\"entidades\": [{\"nombre\": \"...\", \"tipo\": \"...\"}]}"
    }]
)
```

## Relaciones

- [PromptEngineering](../../039-PromptEngineering/README.md)
- [RAG](../../035-RAG/README.md)
- [AgenticAI](../../037-AgenticAI/README.md)
- [RLHF](../RLHF/README.md)
- [FineTuning](../FineTuning/README.md)
