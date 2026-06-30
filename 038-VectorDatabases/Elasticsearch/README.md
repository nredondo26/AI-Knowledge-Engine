# Elasticsearch Vector Search

## Descripción

Elasticsearch, el motor de búsqueda y análisis distribuido más popular, incorpora capacidades de búsqueda vectorial desde su versión 7.x (introducción de `dense_vector`) y las ha expandido significativamente en versiones recientes (8.x+) con soporte para índices ANN nativos (HNSW), búsqueda híbrida con RRF (Reciprocal Rank Fusion), y modelos de embeddings integrados (ELSER, E5, modelos de huggingface). Elasticsearch permite combinar búsqueda vectorial (semántica) con búsqueda por palabras clave (BM25) en una sola consulta, aprovechando su maduro motor de texto completo, filtrado estructurado, agregaciones, destacado de resultados y análisis. Con su arquitectura distribuida, Elasticsearch es ideal para aplicaciones de producción que requieren búsqueda híbrida a gran escala con alta disponibilidad, escalabilidad horizontal y un ecosistema rico (Kibana, Logstash, Beats, Elastic APM).

## Características principales

- **Dense Vector**: Campo de tipo `dense_vector` para almacenar vectores de embeddings (float, byte, signed byte). Hasta 4096 dimensiones por defecto (configurable hasta 2048 para índices ANN).
- **Índices ANN (HNSW)**: Índice vectorial basado en HNSW con parámetros `m`, `ef_construction`, `ef_search`. Soporta distancia coseno, producto punto y L2.
- **kNN Search**: Búsqueda de vecinos más cercanos usando `knn` query. Combinable con otros tipos de queries (match, term, range, bool).
- **Búsqueda Híbrida con RRF**: Desde ES 8.8, `rrf` retriever que fusiona rankings de búsqueda vectorial y por texto combinando con RRF.
- **ELSER (Elastic Learned Sparse EncodeR)**: Modelo de embeddings esparsos entrenado por Elastic para búsqueda semántica sin necesidad de modelos externos.
- **Modelos de Embeddings Integrados**: Soporte para modelos E5, modelos de Hugging Face vía `eland` o APIs de ML. Embedding inference en el pipeline de indexación.
- **Text Embedding Inference**: Pipeline de inferencia que genera embeddings automáticamente al indexar documentos (usando modelos configurados).
- **Query Rules**: Reglas de boosting, filtrado y reranking basadas en metadatos, comportamiento de usuario o contexto.
- **Aggregations**: Análisis y facetado de resultados vectoriales combinado con agregaciones tradicionales.
- **Kibana Dashboard**: Visualización de datos vectoriales, monitoreo de rendimiento de búsqueda, y herramientas de exploración.

## Estructura de datos

- **Index**: Equivalente a una colección de documentos. Define mappings (schema) con tipos de campos.
- **Mapping**: Definición del schema del índice. Incluye tipo `dense_vector` con `dims` y `similarity`.
- **Document**: Unidad de datos almacenada en Elasticsearch. JSON con campos vectoriales y escalares.
- **Pipeline de Ingesta**: Procesamiento antes de indexar: generar embeddings, enriquecer datos, transformar campos.
- **Inference Endpoint**: Configuración del modelo de embeddings (E5, OpenAI, Hugging Face) usado en el pipeline.

## Ejemplo: Operaciones básicas

```python
from elasticsearch import Elasticsearch
import numpy as np

es = Elasticsearch("http://localhost:9200")

# Crear índice con campo vectorial
mapping = {
    "mappings": {
        "properties": {
            "title": {"type": "text"},
            "content": {"type": "text"},
            "category": {"type": "keyword"},
            "year": {"type": "integer"},
            "embedding": {
                "type": "dense_vector",
                "dims": 1536,
                "index": True,
                "similarity": "cosine"
            }
        }
    },
    "settings": {
        "index": {
            "number_of_shards": 3,
            "number_of_replicas": 1
        }
    }
}
es.indices.create(index="documents", body=mapping)

# Indexar documentos con embeddings
doc = {
    "title": "Introducción a RAG",
    "content": "RAG combina recuperación y generación...",
    "category": "IA",
    "year": 2024,
    "embedding": np.random.randn(1536).tolist()
}
es.index(index="documents", body=doc, id=1)

# Búsqueda kNN con filtro
query_embedding = np.random.randn(1536).tolist()
response = es.search(
    index="documents",
    knn={
        "field": "embedding",
        "query_vector": query_embedding,
        "k": 10,
        "num_candidates": 100,
        "filter": {
            "bool": {
                "filter": [
                    {"term": {"category": "IA"}},
                    {"range": {"year": {"gte": 2024}}}
                ]
            }
        }
    },
    _source=["title", "content", "category", "year"]
)
```

## Ejemplo: Búsqueda híbrida con RRF

```python
# ES 8.8+ - Búsqueda híbrida con RRF
response = es.search(
    index="documents",
    retriever={
        "rrf": {
            "retrievers": [
                {
                    "standard": {
                        "query": {
                            "multi_match": {
                                "query": "sistemas de recuperación de información",
                                "fields": ["title^2", "content"]
                            }
                        }
                    }
                },
                {
                    "knn": {
                        "field": "embedding",
                        "query_vector": query_embedding,
                        "k": 10,
                        "num_candidates": 100
                    }
                }
            ],
            "rank_constant": 60,
            "window_size": 100
        }
    }
)
```

## Relaciones con otros módulos

- `../Pgvector/`: Alternativa PostgreSQL relacional vs. Elasticsearch como search engine.
- `../MongoDBAtlas/`: Alternativa MongoDB con vectores vs. Elasticsearch search-first.
- `../Milvus/`: BD vectorial especializada vs. Elasticsearch con search + vectors.
- `../../035-RAG/HybridSearch/`: Búsqueda híbrida con RRF implementada en Elasticsearch.
- `../../062-Search/`: Motores de búsqueda tradicional combinados con vectores.
- `../../035-RAG/`: Backend de búsqueda para sistemas RAG.

## Recursos recomendados

- **Documentación**: elastic.co/guide/en/elasticsearch/reference/current/vector-search.html.
- **Blog**: elastic.co/blog/category/vector-search.
- **Guía**: "Vector Search in Elasticsearch: Getting Started" (Elastic).
- **Curso**: "Elasticsearch Vector Search" (Elastic Training).
- **Repositorio**: elastic/elasticsearch (GitHub).
- **Video**: "Vector Search in Elasticsearch 8.x" (Elastic YouTube).
