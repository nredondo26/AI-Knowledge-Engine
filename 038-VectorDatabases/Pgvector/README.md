# pgvector

## Descripción

pgvector es una extensión de código abierto para PostgreSQL que añade soporte para almacenamiento y búsqueda de vectores de alta dimensionalidad. Permite a PostgreSQL funcionar como una base de datos vectorial sin necesidad de infraestructura adicional, aprovechando toda la potencia del motor relacional más avanzado del mundo. pgvector soporta tipos de datos vectoriales (`vector(n)`), índices ANN (IVFFlat y HNSW), métricas de distancia (coseno, L2, producto punto), y filtrado combinado con consultas SQL tradicionales. Es la solución ideal para equipos que ya usan PostgreSQL y desean añadir capacidades vectoriales sin introducir un nuevo sistema, manteniendo transacciones ACID, joins, índices escalares y la madurez del ecosistema PostgreSQL.

## Características principales

- **Tipo de dato vectorial**: `vector(n)` donde n es la dimensionalidad (hasta 2000 por defecto, configurable hasta 16000).
- **Índices ANN**: `IVFFlat` (Inverted File with Flat compression) — rápido de construir, adecuado para precisión moderada. `HNSW` (Hierarchical Navigable Small World) — mejor precisión, más lento de construir, más rápido en búsqueda.
- **Métricas de Distancia**: Distancia L2 (Euclidiana, operador `<->`), producto punto (`<#>`), distancia coseno (`<=>`).
- **Filtrado SQL**: Combina búsqueda vectorial con cláusulas WHERE, JOIN, ORDER BY, GROUP BY. Pre-filter y post-filter.
- **Transacciones ACID**: Las operaciones vectoriales participan en transacciones PostgreSQL con rollback y aislamiento.
- **Integración con extensiones**: Funciona con PostGIS, pg_trgm, Full-Text Search, TimescaleDB, etc.
- **Replicación y Alta Disponibilidad**: Usa la replicación nativa de PostgreSQL (streaming replication, logical replication, Patroni).
- **Particionamiento**: Table partitioning nativo de PostgreSQL para escalar horizontalmente.
- **pgvector 0.7+**: Soporta halfvec (float16), esparso (sparsevec), e indexación HNSW con cuantización binaria.

## Ejemplo: Operaciones básicas

```sql
-- Habilitar la extensión
CREATE EXTENSION vector;

-- Crear tabla con campo vectorial
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    embedding vector(1536),  -- 1536 dimensiones (text-embedding-3-small)
    category TEXT,
    year INTEGER,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Crear índice HNSW (pgvector 0.5+)
CREATE INDEX idx_documents_embedding
ON documents
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 200);

-- Alternativa: índice IVFFlat
CREATE INDEX idx_documents_embedding_ivf
ON documents
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);
```

```python
import psycopg2
import numpy as np
from pgvector.psycopg2 import register_vector

conn = psycopg2.connect("dbname=vectordb user=user password=pass")
register_vector(conn)
cur = conn.cursor()

# Insertar documentos con embeddings
embedding = np.random.randn(1536).tolist()
cur.execute(
    "INSERT INTO documents (title, content, embedding, category, year) "
    "VALUES (%s, %s, %s, %s, %s)",
    ("Introducción a RAG", "RAG combina recuperación...",
     embedding, "IA", 2024)
)
conn.commit()

# Búsqueda por similitud coseno con filtro
query_embedding = np.random.randn(1536).tolist()
cur.execute(
    "SELECT id, title, content, category, year, "
    "1 - (embedding <=> %s::vector) AS similarity "
    "FROM documents "
    "WHERE category = 'IA' AND year >= 2024 "
    "ORDER BY embedding <=> %s::vector "
    "LIMIT 10",
    (query_embedding, query_embedding)
)

for row in cur.fetchall():
    print(f"{row[1]} (similarity: {row[5]:.4f})")
```

## Ejemplo: Búsqueda híbrida con Full-Text Search

```sql
-- Combinar vector search con FTS
WITH semantic_results AS (
    SELECT id, title, content,
           1 - (embedding <=> %(query_vector)s::vector) AS vector_score,
           ts_rank(to_tsvector('spanish', content),
                   plainto_tsquery('spanish', %(text_query)s)) AS text_score
    FROM documents
    WHERE category = 'IA'
),
ranked AS (
    SELECT *, 
           -- RRF (Reciprocal Rank Fusion) simple
           vector_score * 0.7 + text_score * 0.3 AS hybrid_score
    FROM semantic_results
    WHERE vector_score IS NOT NULL
)
SELECT id, title, content, hybrid_score
FROM ranked
ORDER BY hybrid_score DESC
LIMIT 10;
```

## Configuración y tuning

```ini
# postgresql.conf - Parámetros recomendados
shared_buffers = '4GB'          # 25% de RAM disponible
maintenance_work_mem = '2GB'    # Para construcción de índices
effective_cache_size = '12GB'   # 75% de RAM
work_mem = '64MB'               # Por operación de sorting

# pgvector específico
max_parallel_workers_per_gather = 4
```

```sql
-- Parámetros de índice HNSW
CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 200);
-- m = 16: Conexiones por nodo (valor típico 8-64)
-- ef_construction: Tamaño de lista dinámica durante construcción (valor típico 100-500)

-- Parámetros de búsqueda (por sesión o query)
SET hnsw.ef_search = 100;  -- Tamaño de lista dinámica durante búsqueda (mayor = más preciso, más lento)
```

## Relaciones con otros módulos

- `../Elasticsearch/`: Alternativa con búsqueda vectorial + texto combinada.
- `../MongoDBAtlas/`: Alternativa NoSQL con vectores vs. pgvector relacional.
- `../Chroma/`: Alternativa embebida vs. pgvector integrado en PostgreSQL.
- `../../035-RAG/`: Backend de almacenamiento para chunks y metadatos.
- `../../037-AgenticAI/Memory/`: Memoria persistente de agentes en PostgreSQL.
- `../../062-Search/`: Full-Text Search combinado con búsqueda vectorial.

## Recursos recomendados

- **Documentación**: github.com/pgvector/pgvector.
- **Guía**: "pgvector: Embeddings in PostgreSQL" (Supabase blog).
- **Benchmarks**: pgvector benchmark comparativo (github.com/pgvector/pgvector-benchmark).
- **Curso**: "Vector Search with PostgreSQL" (Timescale).
- **Video**: "pgvector: Vector Similarity Search in PostgreSQL" (PGConf).
- **Extensión**: pgvector 0.7+ soporta halfvec, sparsevec, HNSW con cuantización binaria.
