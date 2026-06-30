# Chunking — Fragmentación de Documentos para RAG

## Concepto

El **chunking** (fragmentación) es el proceso de dividir documentos largos en segmentos más pequeños llamados *chunks* o fragmentos, que son las unidades atómicas que se indexan en una base de datos vectorial y se recuperan durante la inferencia de un sistema RAG.

La calidad del chunking impacta directamente la precisión de la recuperación: fragmentos demasiado grandes introducen ruido semántico, mientras que fragmentos demasiado pequeños pierden contexto. Un buen chunking maximiza la densidad semántica de cada fragmento.

## Arquitectura del Pipeline de Chunking

```
Documento
  │
  ├─► Preprocesamiento (limpieza, normalización)
  │     ├─ Eliminar HTML/Markdown
  │     ├─ Normalizar Unicode
  │     └─ Segmentación en párrafos
  │
  ├─► Estrategia de Fragmentación
  │     ├─ Fixed-size (tamaño fijo con solapamiento)
  │     ├─ Recursive (divide recursivamente por separadores)
  │     ├─ Semantic (basado en fronteras semánticas)
  │     └─ Document-based (por estructura del documento)
  │
  └─► Post-procesamiento
        ├─ Filtrado de fragmentos vacíos o redundantes
        └─ Asignación de metadatos (source, índice, solapamiento)
```

## Estrategias de Chunking

### 1. Fixed-Size Chunking

Divide el texto en fragmentos de N tokens con solapamiento de M tokens.

```python
from langchain.text_splitter import TokenTextSplitter

splitter = TokenTextSplitter(
    chunk_size=512,
    chunk_overlap=128,
    encoding_name="cl100k_base"
)

texto = "..."  # documento largo
chunks = splitter.split_text(texto)
print(f"Fragmentos generados: {len(chunks)}")
```

**Ventajas:** Simple, rápido, determinista.
**Desventajas:** Puede cortar oraciones o párrafos por la mitad.

### 2. Recursive Character Text Splitter

Divide recursivamente usando una jerarquía de separadores: `\n\n`, `\n`, ` `, `""`.

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    separators=["\n\n", "\n", ".", " ", ""],
    length_function=len
)

with open("documento.md") as f:
    texto = f.read()

chunks = splitter.split_documents(texto)
```

**Ventajas:** Preserva unidades lingüísticas naturales.
**Desventajas:** No entiende semántica, solo sintaxis.

### 3. Semantic Chunking (basado en embeddings)

Detecta cambios de tema usando similitud coseno entre oraciones consecutivas.

```python
import numpy as np
from sentence_transformers import SentenceTransformer

model = SentenceTransformer("all-MiniLM-L6-v2")

def semantic_chunk(texto, umbral=0.7):
    oraciones = texto.split(". ")
    embeddings = model.encode(oraciones)

    puntos_corte = [0]
    for i in range(1, len(oraciones)):
        sim = np.dot(embeddings[i-1], embeddings[i]) / (
            np.linalg.norm(embeddings[i-1]) * np.linalg.norm(embeddings[i])
        )
        if sim < umbral:
            puntos_corte.append(i)

    puntos_corte.append(len(oraciones))
    return [" ".join(oraciones[puntos_corte[i]:puntos_corte[i+1]])
            for i in range(len(puntos_corte)-1)]

chunks = semantic_chunk("Primera oración... Segunda... Tercera...", umbral=0.65)
```

### 4. Chunking por Estructura de Documento

Aprovecha la jerarquía natural del documento (Markdown, HTML, PDF).

```python
from langchain.text_splitter import MarkdownHeaderTextSplitter

headers_to_split_on = [
    ("#", "Header_1"),
    ("##", "Header_2"),
    ("###", "Header_3"),
]

splitter = MarkdownHeaderTextSplitter(headers_to_split_on=headers_to_split_on)

md_texto = """
# Introducción
Texto intro...
## Contexto
Texto contexto...
# Método
Detalles método...
"""

chunks = splitter.split_text(md_texto)
for c in chunks:
    print(c.metadata, len(c.page_content))
```

### 5. Agentic Chunking (avanzado)

Usa un LLM para decidir dónde cortar basándose en el contenido.

```python
from openai import OpenAI

client = OpenAI()

def agentic_chunk(texto, modelo="gpt-4o-mini"):
    prompt = f"""Analiza el siguiente texto y divide en fragmentos semánticamente coherentes.
Devuelve una lista JSON con los índices de carácter donde debe cortarse.

Texto:
{texto[:4000]}"""
    resp = client.chat.completions.create(
        model=modelo,
        messages=[{"role": "user", "content": prompt}],
        response_format={"type": "json_object"}
    )
    return resp.choices[0].message.content
```

## Métricas de Calidad de Chunking

| Métrica | Descripción | Objetivo |
|---------|-------------|----------|
| Densidad semántica | Información útil por token | Maximizar |
| Fragmentación | % de oraciones cortadas | Minimizar |
| Recall de recuperación | Fragmentos relevantes recuperados | Maximizar |
| Cohesión intra-chunk | Similitud interna del fragmento | > 0.7 |

## Buenas Prácticas

1. **Ajusta el tamaño según el LLM**: Ventana de contexto del modelo (4K, 8K, 128K tokens).
2. **Solapamiento del 15-25%**: Recupera bordes de fragmentos adyacentes.
3. **Preserva metadatos**: Cada chunk debe saber su documento de origen y posición.
4. **Considera el idioma**: Tokenizadores como `cl100k_base` tokenizan distinto según el idioma.
5. **Testea con tu dominio**: No hay talla única — evalúa con datos reales.

```python
# Evaluación simple de chunking
def evaluate_chunks(chunks, ground_truth):
    from ragas.metrics import context_recall
    # Usa ragas o similar para medir recuperación
    pass
```
