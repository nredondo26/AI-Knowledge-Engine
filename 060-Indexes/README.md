# 060-Indexes: Índices de Búsqueda

## Descripción del dominio

Los índices de búsqueda son estructuras de datos fundamentales que permiten localizar información de manera eficiente en grandes volúmenes de datos. Este módulo cubre los tres grandes tipos de índices utilizados en sistemas modernos: índices invertidos (la base de motores de búsqueda textual como Elasticsearch), índices de base de datos (B-tree, hash, bitmap — utilizados en motores relacionales y NoSQL) e índices vectoriales (ANN, HNSW, IVF — esenciales para búsqueda semántica y sistemas RAG). El catálogo de contenido organiza y describe los activos de información disponibles para búsqueda y recuperación.

## Conceptos clave

- **Índice invertido**: Estructura que mapea términos a documentos que los contienen; pilar de Elasticsearch, Lucene y motores de búsqueda textual — incluye posting lists, term frequency, positions
- **B-tree / B+tree**: Índice balanceado de búsqueda por rango; estándar en PostgreSQL, MySQL, Oracle — ideal para igualdad y rangos
- **Hash index**: Índice O(1) para búsquedas por igualdad exacta; usado en Memcached, Redis, algunas configuraciones de MySQL (MEMORY)
- **Bitmap index**: Índice comprimido basado en arrays de bits; óptimo para columnas con baja cardinalidad (género, estado) — usado en Oracle, Vertica, Druid
- **Índice espacial (R-tree)**: Estructura para datos geoespaciales (coordenadas, polígonos) — usado en PostGIS, MongoDB, Elasticsearch geo-queries
- **Índice vectorial (ANN)**: Aproximate Nearest Neighbor — HNSW (Hierarchical Navigable Small World), IVF (Inverted File Index), Product Quantization, Annoy
- **Catálogo de contenido**: Metadatos, esquemas, mapping de campos, análisis de relevancia, scoring (TF-IDF, BM25)
- **Índice compuesto**: Índice sobre múltiples columnas — orden y leftmost prefix rule en bases de datos relacionales
- **Partial index**: Índice sobre un subconjunto de filas (WHERE clause) — útil para reducir tamaño en PostgreSQL
- **Covering index**: Índice que incluye todas las columnas necesarias para una consulta — permite index-only scans
- **Reindexación y mantenimiento**: Rebuild, reorganize, estadísticas de actualización, fragmentación

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Motores de búsqueda textual | Elasticsearch (Lucene), Apache Solr, Meilisearch, Algolia, Typesense |
| Bases de datos relacionales | PostgreSQL (B-tree, hash, GiST, GIN, BRIN), MySQL (B-tree, hash, fulltext), Oracle (bitmap, function-based) |
| Bases de datos vectoriales | Pinecone, Weaviate, Qdrant, Chroma, Milvus |
| Índices en NoSQL | MongoDB (B-tree, compound, TTL, geo, text, hashed), Redis (hash, sorted set, geospatial) |
| Algoritmos ANN | HNSW (Hierarchical Navigable Small World), IVF (Inverted File), DiskANN, ScaNN (Google) |
| Formatos de índice | Lucene segments, SSTables (LSM-tree), Parquet índices min-max, Bloom filters |
| Herramientas de profiling | EXPLAIN (ANALYZE, BUFFERS) en PostgreSQL, EXPLAIN en MySQL, _search profiler en Elasticsearch |

## Hoja de ruta

1. **Principiante**: Comprender qué es un índice y por qué acelera búsquedas — CREATE INDEX en SQL — tipos básicos de índice (B-tree, hash) — uso de EXPLAIN para ver planes de ejecución
2. **Intermedio**: Índices compuestos y leftmost prefix — índices parciales y covering indexes — índices full-text en PostgreSQL/MySQL — concepto de índice invertido — TF-IDF y BM25 — introducción a Elasticsearch (mappings, queries básicas)
3. **Avanzado**: Optimización de consultas con índices — index-only scans — Bitmap Heap Scan en PostgreSQL — concurrencia y bloqueos en índices — LSM-tree vs B-tree — reindexación online — índices GIN/GiST/BRIN — configurar Elasticsearch a nivel producción (shards, replicas, segment merging)
4. **Experto**: Índices vectoriales — HNSW construction y search parameters — IVF + Product Quantization — índices híbridos (BM25 + vectorial) — índices distribuidos (Cassandra partitions, Elasticsearch routing) — Bloom filters como índice negativo — Adaptive indexing (Database Cracking) — índices en hardware especializado (GPU, TPU, FPGA)

## Relaciones con otros módulos

- [034-LLM](../034-LLM/) — Índices vectoriales como memoria externa para LLMs, RAG con búsqueda semántica
- [035-RAG](../035-RAG/) — Recuperación de documentos vía índices vectoriales e índices invertidos híbridos
- [038-VectorDatabases](../038-VectorDatabases/) — Implementaciones concretas de índices vectoriales: Pinecone HNSW, Qdrant, Chroma
- [062-Search](../062-Search/) — Sistemas de búsqueda completos que usan índices como componente central
- [061-Embeddings](../061-Embeddings/) — Vectores generados por modelos de embedding que alimentan índices vectoriales
- [003-Databases](../003-Databases/) — Índices en bases de datos relacionales y NoSQL
- [058-KnowledgeGraph](../058-KnowledgeGraph/) — Índices sobre grafos de conocimiento, triple stores indexadas
- [063-Examples](../063-Examples/) — Ejemplos prácticos de creación y uso de índices

## Recursos recomendados

- **Libros**: "Database Internals" (Alex Petrov) — capítulos sobre B-tree, LSM-tree, índices; "Elasticsearch: The Definitive Guide" (Gormley & Tong); "High Performance MySQL" (Baron Schwartz et al.)
- **Papers**: "The ubiquitous B-tree" (Comer, 1979); "HNSW: Efficient and robust approximate nearest neighbor search" (Malkov & Yashunin, 2016); "Building a Vector Index" (Bruch et al., 2023); "LSM-tree: The Log-Structured Merge-Tree" (O'Neil et al., 1996)
- **Documentación oficial**: PostgreSQL Index Types, MySQL Index Optimization, Elasticsearch Mapping Guide, Pinecone Documentation
- **Herramientas**: pg_index_size, Elasticsearch _cat/indices, Apache Lucene Sandbox, FAISS (Facebook AI Similarity Search)
