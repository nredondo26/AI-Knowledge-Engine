# Milvus

## Descripción

Milvus es una base de datos vectorial de código abierto diseñada específicamente para búsqueda de similitud ANN a escala masiva (miles de millones de vectores). Creada por Zilliz, Milvus soporta múltiples tipos de índices (HNSW, IVF, DiskANN, GPU-IVF, etc.), aceleración por GPU, y una arquitectura de microservicios que separa el cómputo del almacenamiento para escalar horizontalmente. Milvus es el proyecto incubado de CNCF (Cloud Native Computing Foundation) y es ampliamente utilizado en producción para RAG, búsqueda multimodal, sistemas de recomendación y matching de imágenes. Ofrece SDKs en Python, Java, Go, Node.js y Rust. Su herramienta Attu proporciona una UI para gestión visual. Milvus también ofrece Milvus Lite (versión embebida) y Zilliz Cloud (versión SaaS gestionada).

## Características principales

- **Arquitectura de Microservicios**: Componentes separados y escalables: DataNode (escritura), QueryNode (lectura), IndexNode (indexación), Proxy (gateway), Coordinator (gestión). Escalado independiente por componente.
- **Múltiples Tipos de Índice**: IVF_FLAT, IVF_SQ8, IVF_PQ, HNSW, DiskANN, GPU_IVF_FLAT, GPU_IVF_SQ8, BIN_IVF_FLAT (binario).
- **Aceleración por GPU**: Índices GPU-IVF para búsqueda ultrarrápida usando NVIDIA CUDA. Reducción de latencia hasta 10x en datasets grandes.
- **DiskANN**: Índice basado en disco para datasets que no caben en RAM. Escalable a miles de millones de vectores con costo reducido.
- **Hybrid Search**: Combinación de búsqueda vectorial con filtrado escalar (pre-filter, post-filter) y búsqueda por texto (BM25 mediante índices invertidos).
- **Particionamiento (Partitions)**: División lógica de una colección en particiones para búsqueda segmentada. Mejora rendimiento al limitar el espacio de búsqueda.
- **Replicación**: Réplicas de QueryNode para alta disponibilidad y balanceo de carga.
- **Time Travel**: Capacidad de consultar datos en un punto específico en el tiempo usando timestamps.
- **Filtrado Expresivo**: Filtros complejos sobre metadatos con operadores de comparación, lógicos, de rango, array y JSON.
- **Milvus Lite**: Versión embebida que se ejecuta directamente en Python. Ideal para prototipado y pruebas sin infraestructura.

## Estructura de datos

- **Collection**: Tabla que contiene vectores y metadatos. Equivalente a `table` en SQL o `collection` en MongoDB.
- **Field**: Campo de un schema. Puede ser vectorial (FloatVector, BinaryVector) o escalar (int, float, string, bool, JSON, array).
- **Index**: Estructura de datos ANN construida sobre un campo vectorial. Diferentes tipos según el caso de uso y escala.
- **Partition**: Subdivisión de una collection para búsqueda restringida. Útil para multi-tenancy o filtrado por categoría.
- **Segment**: Unidad física de datos dentro de una partición. Milvus gestiona segmentos de manera automática.

## Ejemplo: Operaciones básicas

```python
from pymilvus import (
    connections, Collection, FieldSchema,
    CollectionSchema, DataType, utility
)

# Conectar
connections.connect("default", host="localhost", port="19530")

# Crear schema
fields = [
    FieldSchema(name="id", dtype=DataType.INT64, is_primary=True, auto_id=True),
    FieldSchema(name="title", dtype=DataType.VARCHAR, max_length=500),
    FieldSchema(name="content", dtype=DataType.VARCHAR, max_length=2000),
    FieldSchema(name="embedding", dtype=DataType.FLOAT_VECTOR, dim=1536),
    FieldSchema(name="year", dtype=DataType.INT64),
    FieldSchema(name="category", dtype=DataType.VARCHAR, max_length=100),
    FieldSchema(name="metadata", dtype=DataType.JSON)
]
schema = CollectionSchema(fields, description="Colección de documentos")
collection = Collection(name="documentos", schema=schema)

# Crear índice HNSW
index_params = {
    "metric_type": "IP",  # Inner Product (equivalente a coseno normalizado)
    "index_type": "HNSW",
    "params": {"M": 16, "efConstruction": 200}
}
collection.create_index(
    field_name="embedding",
    index_params=index_params
)
collection.load()

# Insertar datos
import numpy as np
data = [
    [1, 2, 3],  # id
    ["RAG Intro", "Embeddings avanzados"],  # title
    ["RAG combina...", "Los embeddings..."],  # content
    [np.random.randn(1536).tolist(), np.random.randn(1536).tolist()],  # embedding
    [2024, 2023],  # year
    ["IA", "IA"],  # category
    [{"tags": ["rag"]}, {"tags": ["embeddings"]}]  # metadata
]
insert_result = collection.insert(data)

# Búsqueda con filtro
collection.load()
result = collection.search(
    data=[np.random.randn(1536).tolist()],
    anns_field="embedding",
    param={"metric_type": "IP", "params": {"ef": 64}},
    limit=10,
    expr="year >= 2024 and category == 'IA'",
    output_fields=["title", "content", "year"]
)

for hits in result:
    for hit in hits:
        print(f"ID: {hit.id}, Title: {hit.entity.get('title')}, "
              f"Score: {hit.score:.4f}")
```

## Configuración

```yaml
# milvus.yaml (extracto)
proxy:
  port: 19530
  http:
    enabled: true
    port: 9091

rootCoord:
  port: 53100
  maxPartitionNum: 1024

queryNode:
  port: 21123
  replica:
    enable: true
    replicaNumber: 2

indexNode:
  port: 21121
  enableDisk: true  # Habilitar DiskANN
  buildParallel: 5

dataNode:
  port: 21124
  segment:
    maxSize: 512  # MB
```

## Relaciones con otros módulos

- `../Qdrant/`: Competidor con enfoque en rendimiento en Rust (no GPU).
- `../Weaviate/`: Competidor con módulos IA integrados vs. Milvus más crudo.
- `../Chroma/`: Alternativa embebida vs. Milvus distribuido.
- `../../035-RAG/`: Vector database para RAG a gran escala.
- `../../033-DeepLearning/`: Aceleración GPU para índices vectoriales.
- `../../037-AgenticAI/Memory/`: Memoria persistente escalable para agentes.

## Recursos recomendados

- **Documentación**: milvus.io/docs.
- **Repositorio**: milvus-io/milvus (GitHub).
- **Curso**: "Milvus Bootcamp" (github.com/milvus-io/bootcamp).
- **Herramienta**: Attu (GUI de Milvus).
- **Cloud**: zilliz.com/cloud (Zilliz Cloud, SaaS gestionado).
- **Video**: "Milvus Vector Database Explained" (Milvus YouTube).
