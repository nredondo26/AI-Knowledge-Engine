# Embedding — Vectorización Semántica

## Concepto

Un **embedding** es una representación densa de un texto (o imagen, audio, etc.) en un espacio vectorial de dimensión fija (típicamente 384, 768 o 1536 dimensiones). La propiedad fundamental es que textos semánticamente similares tienen embeddings cercanos según una métrica de distancia (coseno, euclidiana, dot product).

En RAG, los embeddings permiten convertir documentos y consultas en vectores para realizar búsqueda semántica en bases de datos vectoriales.

## Arquitectura del Pipeline de Embedding

```
Texto ──► Tokenizer ──► Transformer Encoder ──► Pooling ──► Embedding
  │          │                │                     │
  │    Subword tokens    Atención multicapa    Mean/CLS/Max
  │                     (BERT, SBERT, etc.)
  │
  └─► Modelos populares:
        - text-embedding-3-small (OpenAI, 1536d)
        - all-MiniLM-L6-v2 (SBERT, 384d)
        - multilingual-e5-large (intfloat, 1024d)
        - bge-large-en-v1.5 (BAAI, 1024d)
```

## Modelos de Embedding

### OpenAI Embeddings

```python
from openai import OpenAI

client = OpenAI()

def obtener_embedding(texto, modelo="text-embedding-3-small"):
    texto = texto.replace("\n", " ")
    resp = client.embeddings.create(input=[texto], model=modelo)
    return resp.data[0].embedding  # vector de 1536 dimensiones

# Uso
vector = obtener_embedding("¿Qué es RAG?")
print(f"Dimensionalidad: {len(vector)}")  # 1536
```

**Dimensiones:** 1536 (small), 3072 (large).
**Costo:** ~$0.02/1K tokens (small).
**Parámetro `dimensions`:** Permite reducir dimensionalidad (256-1536) sin perder calidad.

### Sentence Transformers (SBERT)

Modelos open-source para generar embeddings localmente.

```python
from sentence_transformers import SentenceTransformer

modelo = SentenceTransformer("all-MiniLM-L6-v2")  # 384 dimensiones

textos = [
    "Los embeddings capturan significado semántico",
    "Los vectores permiten búsqueda por similitud",
    "El clima está soleado hoy"
]
embeddings = modelo.encode(textos)

for t, v in zip(textos, embeddings):
    print(f"{t[:40]}... → dim={len(v)}")
```

### Modelos Multilingües

Soportan español y otros idiomas.

```python
from sentence_transformers import SentenceTransformer

modelo = SentenceTransformer("intfloat/multilingual-e5-large-instruct")

def embed_e5(texto, task="query"):
    prefix = "query: " if task == "query" else "passage: "
    return modelo.encode(prefix + texto)

emb_consulta = embed_e5("¿Cómo funciona RAG?", task="query")
emb_doc = embed_e5("RAG combina recuperación y generación", task="passage")
```

## Cálculo de Similitud

```python
import numpy as np

def similitud_coseno(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

def distancia_euclidiana(a, b):
    return np.linalg.norm(a - b)

# Ejemplo: encontrar el documento más similar a una consulta
consulta = modelo.encode("¿Qué es chunking?")
documentos = [
    "Técnica para dividir textos",
    "Método de fragmentación",
    "Recetas de cocina italiana"
]
emb_docs = modelo.encode(documentos)

similitudes = [similitud_coseno(consulta, d) for d in emb_docs]
idx = np.argmax(similitudes)
print(f"Más similar: '{documentos[idx]}' (score={similitudes[idx]:.3f})")
```

## Técnicas Avanzadas

### Matryoshka Embeddings

Un solo modelo produce embeddings que funcionan en múltiples dimensionalidades.

```python
resp = client.embeddings.create(
    input="Texto a vectorizar",
    model="text-embedding-3-small",
    dimensions=256  # reducir de 1536 a 256
)
```

**Ventaja:** Puedes ajustar dimensionalidad sin re-embedding.

### Late Interaction (ColBERT)

Modelo que preserva embeddings por token para match más preciso.

```python
# ColBERT v2 — late interaction sobre passage
# pip install colbert-ai
from colbert import Searcher

searcher = Searcher(index="ruta_indice", checkpoint="colbertv2.0")
resultados = searcher.search("consulta", k=5)
```

## Normalización y Preprocesamiento

```python
import re

def preprocesar(texto):
    texto = texto.strip()
    texto = re.sub(r"\s+", " ", texto)
    texto = texto[:8192]  # límite de tokens
    return texto

def normalizar_vector(v):
    norma = np.linalg.norm(v)
    return v / norma if norma > 0 else v
```

## Métricas de Evaluación

| Métrica | Descripción |
|---------|-------------|
| Recall@k | % de relevantes recuperados en top-k |
| MRR | Mean Reciprocal Rank |
| NDCG | Normalized Discounted Cumulative Gain |
| Spearman | Correlación entre scores y relevancia humana |

```python
# Evaluación simple: similitud vs juicios humanos
from scipy.stats import spearmanr

sims_modelo = [0.95, 0.80, 0.60, 0.40]
juicios = [1.0, 0.85, 0.55, 0.45]
rho, _ = spearmanr(sims_modelo, juicios)
print(f"Correlación de Spearman: {rho:.3f}")
```
