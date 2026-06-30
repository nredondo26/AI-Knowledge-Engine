# MongoDB Atlas Vector Search

## Descripción

MongoDB Atlas Vector Search es la funcionalidad de búsqueda vectorial integrada en MongoDB Atlas, la plataforma de base de datos como servicio (DBaaS) de MongoDB. A diferencia de las bases de datos vectoriales especializadas, MongoDB Atlas permite almacenar vectores junto con datos operacionales en la misma base de datos, eliminando la necesidad de sincronizar datos entre dos sistemas. Vector Search utiliza índices ANN basados en HNSW para búsqueda de similitud sobre campos de tipo `[number]` (arrays de números). Se integra nativamente con la aggregation pipeline de MongoDB, permitiendo combinar búsqueda vectorial con filtros, joins, proyecciones y transformaciones en una sola consulta. También soporta filtrado pre-filter y post-filter, búsqueda híbrida con índices de texto (Atlas Search), y embeddings generados por modelos como OpenAI, Cohere y Hugging Face.

## Características principales

- **Integración con MongoDB**: Los vectores se almacenan como campos normales en documentos JSON. No hay sistema externo ni sincronización.
- **Índices Vectoriales**: Usa HNSW con configuración de `numDimensions`, `similarity` (cosine, euclidean, dotProduct) y `m` / `efConstruction`.
- **Aggregation Pipeline**: La búsqueda vectorial es una etapa más del pipeline de agregación (`$vectorSearch`). Se combina con `$match`, `$sort`, `$lookup`, `$project`, etc.
- **Filtrado Pre-Filter y Post-Filter**: `filter` en `$vectorSearch` para pre-filter (filtra antes de buscar). Post-filter con `$match` después de buscar.
- **Hybrid Search**: Combinación con `$search` (Atlas Search, basado en Lucene) para búsqueda por texto + vectores.
- **Atlas Search**: Búsqueda de texto completo con índices Lucene: autocomplete, fuzzy, synonyms, facets, highlighting.
- **Multi-Cloud**: Disponible en AWS, GCP y Azure. Regiones globales.
- **Security**: Autenticación (SCRAM, LDAP, x.509), autorización (RBAC), cifrado en reposo y tránsito, VPC peering, PrivateLink.
- **Serverless**: Opción serverless para cargas de trabajo variables sin gestión de capacidad.

## Ejemplo: Operaciones básicas

```python
from pymongo import MongoClient
import numpy as np

client = MongoClient("mongodb+srv://user:pass@cluster.mongodb.net")
db = client["knowledge_base"]
collection = db["documents"]

# Crear índice vectorial (vía MongoDB Atlas UI o API)
# {
#   "type": "vectorSearch",
#   "fields": [{
#     "type": "vector",
#     "path": "embedding",
#     "numDimensions": 1536,
#     "similarity": "cosine",
#     "m": 16,
#     "efConstruction": 200
#   }]
# }

# Insertar documentos con embeddings
documents = [
    {
        "title": "Introducción a RAG",
        "content": "RAG combina recuperación y generación...",
        "embedding": np.random.randn(1536).tolist(),
        "category": "IA",
        "year": 2024,
        "tags": ["rag", "llm"],
        "metadata": {"author": "Juan", "lang": "es"}
    },
    {
        "title": "Embeddings densos",
        "content": "Los embeddings representan significado...",
        "embedding": np.random.randn(1536).tolist(),
        "category": "IA",
        "year": 2023,
        "tags": ["embeddings"],
        "metadata": {"author": "María", "lang": "es"}
    }
]
collection.insert_many(documents)

# Búsqueda vectorial con filtro pre-filter
pipeline = [
    {
        "$vectorSearch": {
            "index": "vector_index",
            "path": "embedding",
            "queryVector": np.random.randn(1536).tolist(),
            "numCandidates": 100,
            "limit": 10,
            "filter": {
                "$and": [
                    {"year": {"$gte": 2024}},
                    {"tags": {"$in": ["rag", "llm"]}}
                ]
            }
        }
    },
    {
        "$project": {
            "title": 1,
            "content": 1,
            "category": 1,
            "year": 1,
            "score": {"$meta": "vectorSearchScore"}
        }
    }
]

results = collection.aggregate(pipeline)
for doc in results:
    print(f"{doc['title']} (score: {doc['score']:.4f})")
```

## Ejemplo: Búsqueda híbrida (vector + texto)

```python
# Combinar $vectorSearch con $search (Atlas Search)
pipeline = [
    {
        "$vectorSearch": {
            "index": "vector_index",
            "path": "embedding",
            "queryVector": query_embedding,
            "numCandidates": 50,
            "limit": 20
        }
    },
    {
        "$search": {
            "index": "text_index",
            "text": {
                "query": "recuperación de información",
                "path": "content",
                "fuzzy": {"maxEdits": 1}
            }
        }
    },
    { "$addFields": { "score": {"$meta": "vectorSearchScore"} } },
    { "$sort": {"score": -1} },
    { "$limit": 10 }
]
```

## Relaciones con otros módulos

- `../Pgvector/`: Alternativa PostgreSQL para vectores + datos relacionales.
- `../Elasticsearch/`: Alternativa con búsqueda vectorial + texto combinada.
- `../Chroma/`: Alternativa open source embebida vs. MongoDB Atlas como DBaaS.
- `../../035-RAG/`: Almacén de documentos y vectores para RAG en un solo sistema.
- `../../037-AgenticAI/Memory/`: Memoria persistente de agentes con datos operacionales.

## Recursos recomendados

- **Documentación**: mongodb.com/docs/atlas/atlas-vector-search.
- **Guía**: "Build RAG with MongoDB Atlas" (mongodb.com/developer).
- **Repositorio**: mongodb-developer/vector-search-demo.
- **Curso**: "MongoDB Atlas Vector Search" (MongoDB University).
- **Blog**: mongodb.com/blog/category/vector-search.
- **Video**: "MongoDB Atlas Vector Search Explained" (MongoDB YouTube).
