# Qdrant

## Descripción

Qdrant es una base de datos vectorial de alto rendimiento escrita en Rust, diseñada para búsqueda de similitud ANN (Approximate Nearest Neighbor) con filtrado avanzado. Su enfoque en rendimiento, eficiencia de memoria y precisión de filtrado la convierte en una opción ideal para aplicaciones de producción que requieren baja latencia y alta concurrencia. Qdrant soporta índices HNSW optimizados, cuantización escalar (SCALAR) y producto (PQ) para reducir el uso de memoria hasta 4x, payload indexing para filtros rápidos, búsqueda híbrida con sparse vectors, y API REST + gRPC. Una característica distintiva es su sistema de payload indexing que permite filtros extremadamente rápidos sobre metadatos, comparable a una base de datos tradicional, combinado con búsqueda vectorial. Qdrant se distribuye como binario único, Docker, o servicio gestionado (Qdrant Cloud).

## Características principales

- **Rendimiento en Rust**: Escrito en Rust para máxima eficiencia de memoria y velocidad. Sin garbage collector, control fino de recursos.
- **Payload Indexing**: Indexación de metadatos (payload) para filtros rápidos sin escaneo completo. Soporta índices B-tree, hash, bool, geo, texto.
- **Cuantización Escalar (SCALAR)**: Reduce vectores float32 a int8, reduciendo memoria ~4x con pérdida mínima de precisión ( < 1% recall).
- **Cuantización por Producto (PQ)**: Compresión más agresiva. Divide vectores en sub-espacios y cuantifica cada sub-espacio por separado.
- **Sparse Vectors**: Soporte nativo para vectores esparsos (como SPLADE) para búsqueda híbrida dense + sparse sin necesidad de BM25 externo.
- **Filtros Condicionales**: Filtros complejos con anidamiento, operadores AND/OR/NOT, rangos, geolocalización, texto (match, full-text).
- **API REST + gRPC**: API REST para CRUD y búsqueda; gRPC para alto rendimiento.
- **WAL (Write-Ahead Log)**: Persistencia con WAL para durabilidad sin sacrificar rendimiento de escritura. Checkpoints periódicos para recuperación rápida.
- **Clustering Distribuido**: Sharding automático, replicación y balanceo de carga.

## Ejemplo: Operaciones básicas

```python
from qdrant_client import QdrantClient, models

client = QdrantClient(host="localhost", port=6333)

# Crear colección
client.create_collection(
    collection_name="documentos",
    vectors_config=models.VectorParams(
        size=1536,
        distance=models.Distance.COSINE,
        on_disk=False
    ),
    # Cuantización escalar para ahorrar memoria
    quantization_config=models.ScalarQuantization(
        scalar=models.ScalarQuantizationConfig(
            type=models.ScalarType.INT8,
            quantile=0.99,
            always_ram=True
        )
    )
)

# Crear índice de payload para filtros rápidos
client.create_payload_index(
    collection_name="documentos",
    field_name="category",
    field_type=models.PayloadSchemaType.KEYWORD
)

# Insertar puntos con payload
client.upsert(
    collection_name="documentos",
    points=[
        models.PointStruct(
            id=1,
            vector=[0.1, 0.2, ...],  # 1536 dimensiones
            payload={"title": "RAG Intro", "category": "IA", "year": 2024, "tags": ["rag", "llm"]}
        ),
        models.PointStruct(
            id=2,
            vector=[0.3, 0.4, ...],
            payload={"title": "Embeddings", "category": "IA", "year": 2023, "tags": ["embeddings"]}
        )
    ]
)

# Búsqueda con filtro
result = client.search(
    collection_name="documentos",
    query_vector=[0.1, 0.2, ...],
    query_filter=models.Filter(
        must=[
            models.FieldCondition(
                key="category",
                match=models.MatchValue(value="IA")
            ),
            models.FieldCondition(
                key="year",
                range=models.Range(gte=2024)
            ),
            models.FieldCondition(
                key="tags",
                match=models.MatchAny(any=["rag", "llm"])
            )
        ]
    ),
    limit=10,
    with_payload=True
)

# Búsqueda híbrida con sparse vectors
client.search(
    collection_name="documentos",
    query_vector=models.NamedVector(
        name="dense", vector=[0.1, 0.2, ...]
    ),
    sparse_vector=models.SparseVector(
        indices=[1, 5, 10],
        values=[0.5, 0.3, 0.2]
    ),
    limit=10
)

# Búsqueda por grupos (recomendación)
recommendations = client.recommend(
    collection_name="documentos",
    positive=[1],
    negative=[2],
    limit=5
)
```

## Configuración

```yaml
# config.yaml
storage:
  optimizers:
    default_segment_number: 2
    memmap_threshold: 20000  # KB
  wal:
    wal_capacity_mb: 32

cluster:
  enabled: true
  p2p:
    port: 6335
  # Replicación
  replication_factor: 2
  write_consistency_factor: 1
```

## Relaciones con otros módulos

- `../Weaviate/`: Competidor con soporte graph vs. Qdrant con filtros más rápidos.
- `../Milvus/`: Alternativa para escalas masivas vs. Qdrant de alto rendimiento medio.
- `../Pgvector/`: Alternativa PostgreSQL integrada vs. Qdrant especializado.
- `../../035-RAG/`: Almacén vectorial para chunks recuperados en RAG.
- `../../037-AgenticAI/Memory/`: Memoria persistente para agentes.
- `../../061-Embeddings/`: Formatos de vectores densos y esparsos.

## Recursos recomendados

- **Documentación**: qdrant.tech/documentation.
- **Repositorio**: qdrant/qdrant (GitHub).
- **Benchmarks**: qdrant.tech/benchmarks.
- **Blog**: qdrant.tech/blog.
- **Video**: "Qdrant Vector Database Tutorial" (Qdrant YouTube).
- **Cloud**: cloud.qdrant.io (servicio gestionado).
