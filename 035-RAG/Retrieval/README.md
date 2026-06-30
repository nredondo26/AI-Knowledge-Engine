# Retrieval — Recuperación de Información Semántica

## Concepto

**Retrieval** es el proceso de recuperar fragmentos relevantes desde una base de conocimiento (típicamente una base de datos vectorial) dada una consulta del usuario. Es el corazón del pipeline RAG: una recuperación de alta calidad es condición necesaria para una generación precisa.

## Arquitectura del Sistema de Retrieval

```
Consulta
  │
  ├─► Query Understanding
  │     ├─ Reformulación (HyDE, Multi-Query)
  │     ├─ Descomposición (Sub-Query)
  │     └─ Expansión con contexto histórico
  │
  ├─► Indexación
  │     ├─ Vector Store (FAISS, Pinecone, Chroma)
  │     ├─ Índice invertido (BM25, TF-IDF)
  │     └─ Índice híbrido (vectorial + léxico)
  │
  └─► Búsqueda
        ├─ ANN (Approximate Nearest Neighbors)
        ├─ KNN exacto
        └─ Búsqueda híbrida ponderada
```

## Estrategias de Recuperación

### 1. Búsqueda Vectorial (ANN)

Recupera por similitud semántica usando vecinos más cercanos aproximados.

```python
import chromadb
from sentence_transformers import SentenceTransformer

# Inicializar
cliente = chromadb.PersistentClient(path="./chroma_db")
coleccion = cliente.get_or_create_collection("docs")
modelo = SentenceTransformer("all-MiniLM-L6-v2")

# Indexar documentos
docs = [
    "RAG significa Retrieval-Augmented Generation",
    "Los chunks son fragmentos de documentos",
    "Los embeddings capturan significado semántico"
]
ids = [f"doc_{i}" for i in range(len(docs))]
embeddings = modelo.encode(docs).tolist()
coleccion.add(ids=ids, embeddings=embeddings, documents=docs)

# Consulta
consulta = "¿Qué es RAG?"
emb_consulta = modelo.encode(consulta).tolist()
resultados = coleccion.query(query_embeddings=[emb_consulta], n_results=2)
print(resultados["documents"])  # [['RAG significa...'], ['Los chunks...']]
```

### 2. Búsqueda Híbrida (Vectorial + Léxica)

Combina semántica (embeddings) con coincidencia exacta de términos (BM25).

```python
from rank_bm25 import BM25Okapi
import numpy as np

class HybridRetriever:
    def __init__(self, alpha=0.5):
        self.alpha = alpha
        self.modelo = SentenceTransformer("all-MiniLM-L6-v2")
        self.docs = []
        self.embeddings = None
        self.bm25 = None

    def index(self, docs):
        self.docs = docs
        self.embeddings = self.modelo.encode(docs)
        tokenized = [doc.split() for doc in docs]
        self.bm25 = BM25Okapi(tokenized)

    def buscar(self, consulta, k=5):
        emb_q = self.modelo.encode([consulta])

        # Scores vectoriales
        vec_scores = np.dot(self.embeddings, emb_q.T).flatten()
        vec_scores = (vec_scores - vec_scores.min()) / (vec_scores.max() - vec_scores.min() + 1e-8)

        # Scores BM25
        bm25_scores = self.bm25.get_scores(consulta.split())
        bm25_scores = (bm25_scores - bm25_scores.min()) / (bm25_scores.max() - bm25_scores.min() + 1e-8)

        # Combinación ponderada
        hybrid = self.alpha * vec_scores + (1 - self.alpha) * bm25_scores
        indices = np.argsort(hybrid)[::-1][:k]

        return [(self.docs[i], hybrid[i]) for i in indices]
```

### 3. Multi-Query Retrieval

Genera múltiples reformulaciones de la consulta para cubrir más ángulos.

```python
from openai import OpenAI

client = OpenAI()

def multi_query_retrieval(consulta_original, retriever, n_queries=3):
    prompt = f"""Genera {n_queries} consultas alternativas para esta pregunta,
cada una reformulando el mismo concepto de manera diferente.

Pregunta original: {consulta_original}

Devuelve solo las consultas, una por línea."""

    resp = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}]
    )
    queries = [consulta_original] + resp.choices[0].message.content.strip().split("\n")

    resultados = {}
    for q in queries:
        for doc, score in retriever.buscar(q, k=3):
            resultados[doc] = max(resultados.get(doc, 0), score)

    return sorted(resultados.items(), key=lambda x: x[1], reverse=True)
```

### 4. HyDE (Hypothetical Document Embeddings)

Genera un documento hipotético como respuesta y usa su embedding para buscar.

```python
def hyde_retrieval(consulta, retriever):
    prompt = f"""Genera un párrafo hipotético que respondería a esta pregunta.
El párrafo debe ser informativo y factual.

Pregunta: {consulta}

Párrafo:"""
    resp = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}]
    )
    doc_hipotetico = resp.choices[0].message.content
    return retriever.buscar(doc_hipotetico, k=5)
```

### 5. Recuperación con Re-ranking

Fase adicional que reordena los resultados usando un modelo cross-encoder.

```python
from sentence_transformers import CrossEncoder

reranker = CrossEncoder("cross-encoder/ms-marco-MiniLM-L-6-v2")

def retrieve_and_rerank(consulta, retriever, k_initial=20, k_final=5):
    resultados_raw = retriever.buscar(consulta, k=k_initial)
    pairs = [[consulta, doc] for doc, _ in resultados_raw]
    scores = reranker.predict(pairs)
    ranked = sorted(zip(resultados_raw, scores), key=lambda x: x[1], reverse=True)
    return [doc for (doc, _), _ in ranked[:k_final]]
```

## Métricas de Retrieval

| Métrica | Definición | Cálculo |
|---------|------------|---------|
| Hit Rate | % de consultas con al menos 1 relevante | `hits / total_queries` |
| MRR | 1/rank del primer relevante | `mean(1/rank)` |
| NDCG | Ganancia acumulada normalizada | `DCG / IDCG` |
| MAP | Precisión promedio media | `mean(avg_precision)` |

```python
def hit_rate(resultados, relevantes, k=5):
    hits = 0
    for q_res, q_rel in zip(resultados, relevantes):
        if any(r in q_res[:k] for r in q_rel):
            hits += 1
    return hits / len(resultados)
```
