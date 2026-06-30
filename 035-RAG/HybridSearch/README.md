# Búsqueda Híbrida en RAG (HybridSearch)

## Descripción del dominio

La búsqueda híbrida (Hybrid Search) combina dos paradigmas de recuperación de información: la búsqueda semántica (basada en embeddings vectoriales) y la búsqueda por palabras clave (basada en BM25, TF-IDF o similares). La motivación principal es que cada enfoque tiene fortalezas complementarias: la búsqueda semántica captura significado y contexto, mientras que la búsqueda por palabras clave es precisa para términos exactos, códigos, nombres propios y coincidencias literales. La fusión de ambos rankings se realiza típicamente mediante RRF (Reciprocal Rank Fusion), que asigna puntuaciones basadas en la posición relativa en cada ranking sin requerir normalización de scores. Otras estrategias incluyen la ponderación lineal de scores, fusión basada en aprendizaje (learning-to-rank), y el uso de modelos esparso-denso como SPLADE o ColBERT que unifican ambos enfoques en un solo modelo.

## Conceptos clave

- **Búsqueda Semántica**: Recupera documentos por similitud semántica usando embeddings densos. Captura sinónimos, paráfrasis y contexto. Requiere modelos de embeddings y aproximación ANN.
- **Búsqueda por Palabras Clave (Keyword Search)**: Recupera documentos por coincidencia exacta de términos. Usa BM25 (Okapi BM25), TF-IDF o algoritmos similares. Rápida y determinista.
- **BM25 (Okapi BM25)**: Algoritmo de ranking probabilístico que puntúa documentos basado en frecuencia de términos (TF) y frecuencia inversa de documentos (IDF), con normalización por longitud del documento.
- **RRF (Reciprocal Rank Fusion)**: Método de fusión que combina múltiples rankings ordenados. Para cada documento, calcula RRF_score = Σ(1 / (k + rank_i)), donde k es una constante (típicamente 60) y rank_i es la posición del documento en el ranking i.
- **Fusión Lineal (Weighted Sum)**: Combinación ponderada de scores normalizados de búsqueda semántica y keyword. Pesos ajustables según la importancia relativa de cada modalidad.
- **Dense + Sparse Embeddings**: Modelos como SPLADE, ColBERT, y BGE-M3 generan representaciones densas y esparsas simultáneamente, permitiendo búsqueda híbrida con un solo modelo.
- **ESL (Ensemble Search Layer)**: Capa de búsqueda que ejecuta múltiples retrievers en paralelo y combina resultados mediante estrategias configurables.
- **Normalización de Scores**: Técnicas como min-max, z-score o softmax para escalar scores de diferentes retrievers a rangos comparables antes de la fusión.
- **Retrieval con Filtros**: La búsqueda híbrida puede combinarse con filtros de metadatos (pre-filter o post-filter) para refinar resultados por categoría, fecha, fuente, etc.

## Implementaciones principales

- **Elasticsearch hybrid**: Usa `knn` query para vectores y `match`/`multi_match` para keywords, combinados con `rrf` retriever (ES 8.8+).
- **Weaviate hybrid**: Soporte nativo con `hybrid` search, combina vector search con BM25 y RRF integrado.
- **Qdrant hybrid**: Búsqueda híbrida con `prefetch` que ejecuta queries densas y esparsas en paralelo, fusionando resultados.
- **Milvus hybrid**: Combinación de vector search con scalar filtering y BM25 a través de índices invertidos.
- **Pinecone sparse-dense**: Soporte para sparse vectors (como SPLADE) junto con dense vectors para búsqueda híbrida.
- **LangChain Ensemble Retriever**: Retriever que combina múltiples retrievers con weights y RRF.
- **LlamaIndex Hybrid Retriever**: Router retriever que elige o combina keyword + vector según la consulta.

## Ejemplo: Búsqueda Híbrida con Weaviate

```python
import weaviate

client = weaviate.connect_to_local()
response = client.query.get(
    "Document", ["title", "content", "chunk_id"]
).with_hybrid(
    query="procedimiento de autenticación OAuth2",
    alpha=0.5,  # 0 = solo keyword, 1 = solo vector
    vector=embedding_model.encode("procedimiento de autenticación OAuth2"),
    properties=["title^2", "content"]  # pesos por campo
).with_limit(10).do()
```

## Ejemplo: RRF con LangChain

```python
from langchain.retrievers import EnsembleRetriever
from langchain_community.retrievers import BM25Retriever
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings

bm25_retriever = BM25Retriever.from_texts(documents)
bm25_retriever.k = 10

vector_retriever = Chroma.from_texts(
    documents, OpenAIEmbeddings()
).as_retriever(search_kwargs={"k": 10})

ensemble = EnsembleRetriever(
    retrievers=[bm25_retriever, vector_retriever],
    weights=[0.3, 0.7]
)

results = ensemble.invoke(
    "¿Cuáles son los requisitos del sistema?"
)
```

## Estrategias de fusión avanzadas

- **RRF con k variable**: Ajustar k según la confianza en cada retriever. k pequeño da más peso a los primeros resultados.
- **Score normalizado + weight**: Normalizar scores al rango [0,1] y combinar con pesos (ej. 0.3 * score_keyword + 0.7 * score_vector).
- **Learning-to-Rank**: Usar un modelo (LambdaMART, RankNet) entrenado para combinar señales de múltiples retrievers.
- **Cascading**: Ejecutar primero un retriever rápido (keyword) para preseleccionar, luego rerankear con el retriever vectorial.
- **Adaptive Hybrid**: El peso alpha se ajusta dinámicamente según la naturaleza de la consulta (términos raros → más keyword, consultas semánticas → más vector).

## Relaciones con otros módulos

- `../Retrieval/`: Estrategias de recuperación base sobre las que se construye la búsqueda híbrida.
- `../Reranking/`: Post-procesamiento de resultados híbridos con cross-encoders.
- `../Embedding/`: Modelos de embeddings densos y esparsos para representación de textos.
- `../Chunking/`: División de documentos que afecta la granularidad de la búsqueda.
- `../Evaluation/`: Métricas de evaluación para comparar rendimiento de búsqueda híbrida vs. pura.
- `../../038-VectorDatabases/`: Bases de datos vectoriales que soportan búsqueda híbrida nativa.
- `../../062-Search/`: Motores de búsqueda tradicionales con BM25 yTF-IDF.

## Recursos recomendados

- **Paper**: "Reciprocal Rank Fusion" (RRF) — Cormack et al., 2009.
- **Paper**: "SPLADE: Sparse Lexical and Expansion Model for First Stage Ranking" (Formal et al., 2021).
- **Paper**: "ColBERT: Efficient and Effective Passage Search via Contextualized Late Interaction over BERT" (Khattab & Zahir, 2020).
- **Documentación**: Weaviate Hybrid Search docs, Qdrant Hybrid Search docs, Elasticsearch RRF docs.
- **Blog**: "Hybrid Search: Combining Keyword and Semantic Search" (Pinecone).
- **Repositorio**: langchain-ai/langchain (EnsembleRetriever).
- **Video**: "Hybrid Search Explained" (Weaviate YouTube).
