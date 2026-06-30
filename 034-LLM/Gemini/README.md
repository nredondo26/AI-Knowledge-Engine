# Gemini (Google DeepMind)

## Arquitectura

Gemini es la familia de modelos multimodales de Google DeepMind, diseñada desde cero como **nativamente multimodal** (no como un modelo de texto con parches de visión). Su arquitectura se basa en un **Transformer decoder-only** con innovaciones clave:

- **Multi-modal encoder unificado**: Un solo encoder procesa texto, imágenes, audio y video simultáneamente. Los inputs visuales/audio se tokenizan mediante **ViT-like patching** + **Audio Spectrogram Encoding**.
- **Mixture-of-Experts (MoE)**: Gemini Ultra (~1T parámetros) usa capas FFN con routers MoE. Cada token activa solo un subconjunto de expertos, reduciendo el costo real de inferencia a ~200B parámetros por token.
- **Ventana de contexto**: Gemini 1.5 Pro soporta hasta **2M tokens** (la más larga disponible comercialmente) usando **atención dispersa con sliding window + global attention**.
- **FlashAttention optimizada para TPU**: Implementación en JAX/xla adaptada a las unidades de cómputo de Google TPU v5p.
- **Training con GSPMD (General Sparse Partitioning)**: Distribución de modelos masivos en pods de TPU.

```text
Input Multimodal → Tokenizadores separados (text: SentencePiece, img: ViT, audio: USM) → 
Proyección lineal común → [Transformer MoE × N] → Unembedding → Logits
                     └→ Router dinámico → top-k expertos activados
```

| Modelo | Parámetros | Ventana | MoE | Entrenamiento |
|--------|-----------|---------|-----|---------------|
| Gemini Nano | ~3.8B | 32K | No | Texto + código |
| Gemini Pro 1.5 | ~20B* | 2M | Limitado | Multimodal |
| Gemini Ultra 1.0 | ~1T* | 128K | Sí (64 expertos) | Multimodal |
| Gemini Ultra 2.0 | ~2T* | 2M | Sí | Multimodal + video |

*Estimaciones no oficiales.

## Capacidades

- **Multimodalidad nativa**: Procesa texto, imágenes, audio (16kHz), video (hasta 1h) y código en una sola invocación.
- **Contexto ultra-largo**: **2M tokens** en Gemini 1.5 Pro — puede procesar libros completos (Guerra y Paz, ~500K tokens) en una sola consulta.
- **Razonamiento multimodal**: Video Q&A — preguntas sobre contenido de video sin transcripción previa.
- **Code generation**: Gemini Ultra 2.0 supera el 90% en HumanEval y soporta generación de código con dependencias completas.
- **Function Calling declarativo**: Define funciones con esquemas OpenAPI-like.
- **Safety integrado**: Filtros de seguridad configurables por categoría (harassment, hate speech, sexually explicit, dangerous content).

## API

### Google AI Python SDK

```python
import os
import google.generativeai as genai

genai.configure(api_key=os.environ["GEMINI_API_KEY"])
model = genai.GenerativeModel("gemini-2.0-pro-exp")

# Generación de texto
response = model.generate_content(
    "Explica el teorema de Bayes con un ejemplo práctico.",
    generation_config=genai.types.GenerationConfig(
        temperature=0.2,
        max_output_tokens=2048,
        top_p=0.95,
        top_k=40,
    ),
    safety_settings={
        "HARASSMENT": "BLOCK_ONLY_HIGH",
        "HATE_SPEECH": "BLOCK_ONLY_HIGH",
    }
)
print(response.text)

# Streaming
response = model.generate_content(
    "Escribe un ensayo de 500 palabras sobre el futuro de la IA.",
    stream=True
)
for chunk in response:
    print(chunk.text, end="")

# Multimodal: imagen + texto
import PIL.Image

img = PIL.Image.open("grafico.png")
response = model.generate_content([
    "Analiza este gráfico de crecimiento económico.",
    img
])
print(response.text)

# Multimodal: audio/video
video_file = genai.upload_file("conferencia.mp4")
response = model.generate_content([
    video_file,
    "Extrae los 3 puntos principales de esta conferencia."
])
print(response.text)

# Function Calling
def obtener_tipo_cambio(moneda_base: str, moneda_destino: str) -> dict:
    # Implementación real con API externa
    return {"tasa": 17.50, "fecha": "2026-06-30"}

tool_cambio = genai.types.FunctionDeclaration(
    name="obtener_tipo_cambio",
    description="Obtiene el tipo de cambio entre dos monedas",
    parameters={
        "type": "object",
        "properties": {
            "moneda_base": {"type": "string", "description": "Código ISO de moneda base"},
            "moneda_destino": {"type": "string", "description": "Código ISO de moneda destino"}
        },
        "required": ["moneda_base", "moneda_destino"]
    }
)

model_with_tools = genai.GenerativeModel(
    "gemini-2.0-pro-exp",
    tools=[tool_cambio]
)
response = model_with_tools.generate_content("¿Cuál es el tipo de cambio de USD a MXN?")
if response.candidates[0].content.parts[0].function_call:
    fc = response.candidates[0].content.parts[0].function_call
    print(f"Llamada a {fc.name}({fc.args})")

# Embeddings
result = genai.embed_content(
    model="models/embedding-004",
    content="Texto para generar embedding",
    output_dimensionality=768
)
print(len(result["embedding"]))  # 768
print(result["embedding"][:5])
```

## Costos (USD, junio 2026)

| Modelo | Input (por carácter) | Output | Contexto |
|--------|---------------------|--------|----------|
| Gemini 1.5 Pro | $0.0035/1K chars | $0.0105/1K chars | 2M |
| Gemini 1.5 Flash | $0.0005/1K chars | $0.0015/1K chars | 1M |
| Gemini 2.0 Pro | $0.005/1K chars | $0.015/1K chars | 2M |
| Gemini 2.0 Flash | $0.0003/1K chars | $0.0009/1K chars | 1M |

**Nota**: Gemini cobra por caracteres, no por tokens. 1 token ≈ 4 caracteres en inglés.

**Optimización**: Gemini 1.5 Flash ofrece ~85% del rendimiento de Pro a ~10% del costo.

## Mejores prácticas

1. **Context caching**: Para documentos largos, usar `cached_content` — reduce costo de input en ~50%.
2. **System instructions**: Gemini soporta `system_instruction` que se comporta como system prompt persistente.
3. **Safety thresholds**: Ajustar `safety_settings` según el caso de uso (no usar BLOCK_LOW para tareas médicas/técnicas).
4. **Top-K**: A diferencia de GPT, Gemini expone `top_k` para control más fino de muestreo.
5. **Multimodal eficiente**: Subir imágenes en JPEG (no PNG) para reducir latencia y costo.

```python
# Sistema de caché de contexto
from google.generativeai import caching

content = caching.CachedContent(
    model="models/gemini-1.5-pro-002",
    system_instruction="Eres un analista financiero experto.",
    contents=[documento_largo],
    ttl=datetime.timedelta(hours=1)
)
model_cached = genai.GenerativeModel.from_cached_content(cached_content=content)
response = model_cached.generate_content("Pregunta sobre el documento...")
```

## Relaciones

- [PromptEngineering](../../039-PromptEngineering/README.md)
- [RAG](../../035-RAG/README.md)
- [AgenticAI](../../037-AgenticAI/README.md)
- [FineTuning](../FineTuning/README.md)
