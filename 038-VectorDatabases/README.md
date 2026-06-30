# 038-VectorDatabases: Bases de Datos Vectoriales

## Descripción ampliada del dominio

Las bases de datos vectoriales están diseñadas para almacenar, indexar y buscar embeddings (vectores numéricos de alta dimensionalidad) de manera eficiente. Son un componente crítico en sistemas de IA modernos: búsqueda semántica, RAG (Retrieval Augmented Generation), sistemas de recomendación, detección de anomalías, clustering y memoria para agentes de IA. A diferencia de las bases de datos tradicionales optimizadas para búsqueda exacta (SQL), las vector databases usan índices ANN (Approximate Nearest Neighbor) para encontrar vecinos cercanos en espacio vectorial, sacrificando algo de precisión por velocidad y escalabilidad. La evolución: búsqueda exacta (kNN, O(n), 1990s) → árboles espaciales (KD-tree, R-tree, VP-tree, 1990s-2000s) → LSH (2000s) → IVF, HNSW (2010s) → DiskANN, Product Quantization (2018+) → vector databases cloud-native (Pinecone, Weaviate, Qdrant, Milvus, 2020+). Las tendencias actuales incluyen: búsqueda híbrida (vector + keyword + metadata), filtrado pre/post-filtering, multi-vector (ColBERT, late interaction), streaming ingestion, indexación incremental, y vector databases especializadas para IA generativa.

## Tabla de conceptos clave

| Concepto | Descripción | Implementaciones |
|----------|-------------|-----------------|
| Embedding Vector | Representación numérica (float array) de un objeto (texto, imagen, audio) | text-embedding-3 (OpenAI), BGE, E5, CLIP (image) |
| Dimensión | Número de componentes del vector (768, 1024, 1536, 3072, etc.) | text-embedding-3-small: 512-1536, CLIP: 512 |
| Distancia/Métrica | Medida de similitud entre vectores | Cosine similarity, dot product, Euclidean (L2), Manhattan (L1) |
| ANN Index | Approximate Nearest Neighbor index for fast search | HNSW, IVF, DiskANN, LSH, PQ, Annoy |
| HNSW | Hierarchical Navigable Small World graph | Index más popular (Weaviate, Qdrant, Pinecone) |
| IVF | Inverted File Index (clusters + search) | FAISS IVF, Milvus IVF |
| Product Quantization (PQ) | Compresión de vectores para reducir memoria | FAISS IndexIVFPQ, DiskANN |
| Metadata Filtering | Filtrado por atributos (pre-filter, post-filter, hybrid) | payload (Qdrant), metadata (Weaviate), filters |
| Hybrid Search | Combinación de vector search + keyword search (BM25) | Puntaje combinado, RRF, weighted sum |
| CRUD | Create, Read, Update, Delete for vectors | upsert, delete, fetch vectors |
| Similarity Search | Encontrar vectores más cercanos a una query | query(vector, k), query(vector, filter, k) |
| Batch Ingestion | Inserción de vectores en lotes | parallel ingestion, streaming, async |

## Tecnologías principales

| Vector DB | Licencia | Lang | ANN Index | Cloud/Self | Hybrid | Multitenancy | Escalabilidad |
|-----------|----------|------|-----------|------------|--------|-------------|---------------|
| Pinecone | Proprietary SaaS | — | HNSW, PQ | Cloud (SaaS) | Sí (Sparse-Dense) | Sí (namespaces) | Alta (serverless) |
| Weaviate | Open Source (BSD) | Go | HNSW | Self + Cloud | Sí | Sí (multi-tenancy) | Alta (sharding) |
| Qdrant | Open Source (Apache) | Rust | HNSW | Self + Cloud | Sí (discrete) | Sí (collections) | Muy alta (Rust) |
| Milvus | Open Source (Apache) | Go/Java | IVF, HNSW, DiskANN y más | Self + Cloud (Zilliz) | Sí | Sí (collections) | Muy alta (distribuido) |
| Chroma | Open Source (Apache) | Python | HNSW (hnswlib) | Self (embedded) | No | No | Baja (embedded) |
| FAISS | Open Source (MIT) | C++/Python | IVF, HNSW, PQ y muchos más | Library (no server) | No | No | Alta (biblioteca) |
| pgvector | Open Source (PostgreSQL) | C | IVFFlat, HNSW | Self + Cloud | Sí (tsvector) | Sí (PostgreSQL) | Media (PostgreSQL) |
| LanceDB | Open Source (Apache) | Rust/Python | IVF, HNSW | Self (embedded) | No | No | Alta (columnar) |
| Vald | Open Source (Apache) | Go | HNSW, NGT | Self (K8s) | No | Sí | Alta (distribuido) |

## Hoja de ruta detallada

1. **Principiante (0-2 semanas)**: Conceptos: qué es un vector (embedding), dimensión, similitud coseno, vecinos cercanos (nearest neighbor). Pip install chromadb o pinecone-client. Crear colección, generar embeddings con OpenAI/Cohere API. Ingestar textos (chunk → embed → upsert). Query: buscar vectores similares, filtrar por metadata (score threshold, top_k). Visualizar embeddings con t-SNE/UMAP. Entender métricas de distancia: cosine, dot product, Euclidean. RAG básico con Chroma/Pinecone + LLM.
   - Práctica: RAG pipeline con Chroma + OpenAI Embeddings + LLM. Búsqueda semántica en documentos propios.
   - Lectura: Pinecone docs, Chroma docs, "What is a Vector Database?" (Pinecone blog).

2. **Intermedio (2-4 semanas)**: ANN indexes: HNSW (M: 16-64, ef_construction: 200-500, ef_search: 100-500), IVF (nlist: 100-1000, nprobe: 10-50). Index parameters tuning: trade-off recall vs latency vs memory. Metadata filtering: pre-filter (filtrar antes de search), post-filter (filtrar después), hybrid (combined), filtering performance optimization. Hybrid search: dense (vector) + sparse (BM25) → RRF (Reciprocal Rank Fusion). Integration with frameworks: LangChain (VectorStores, Retrivers, ScoreThreshold, MMR), LlamaIndex (VectorIndex, VectorRetriever). Upsert and delete: handling updates to vectors (re-index or overwrite). Collections management: multi-tenancy (namespaces/collections per tenant). Batch ingestion: optimizing throughput (parallel API calls, async, bulk endpoints). Distance metric selection: cosine (normalized, range [-1,1]), dot product (efficiency, magnitude-sensitive), L2 (euclidean distance). Embedding model selection: model dimension affects index size/recall, model quality affects search quality.
   - Proyecto: HNSW index tuning for optimal recall/latency. Hybrid search pipeline (dense + BM25 + RRF). Multi-tenant RAG with namespace isolation.
   - Lectura: "ANN Benchmarks" (github.com/erikbern/ann-benchmarks), Qdrant docs (filtering), Weaviate docs (hybrid search).

3. **Avanzado (4-8 semanas)**: Product Quantization (PQ): M subvectors, nbits each, trade-off compression ratio (4x-32x) vs accuracy. DiskANN: SSD-based index for billion-scale datasets (out-of-core). Scalability: sharding (horizontal), replication, distributed indexing. Index types comparison: HNSW (best recall, high memory), IVF+PQ (memory efficient, good recall), DiskANN (best for >100M vectors). Performance benchmarking: QPS (queries per second), recall@k, latency p99, index build time. Multi-vector search: ColBERT (late interaction, per-token embeddings), MRL (Matryoshka Representation Learning). Curse of dimensionality: high dimensions (>1024) reduce ANN effectiveness, need more data or dimensionality reduction. Near-real-time indexing: streaming ingestion (add vectors to index without rebuild). CRUD operations: vector updates, deletions (lazy deletion, tombstone), partial updates. Integration with RAG pipelines: recursive retrieval, parent-child retrieval, contextual retrieval.
   - Proyecto: Benchmarks de diferentes indexes/vector DBs. ColBERT-style multi-vector retrieval. Large-scale ingestion pipeline (millions of vectors).
   - Lectura: FAISS documentation, "DiskANN" paper (Subramanya, 2019), "ColBERT" paper (Khattab, 2020).

4. **Experto (2+ meses)**: Custom ANN index implementation: HNSW from scratch (layered graph, insertion, search), IVF from scratch (k-means clustering, inverted lists). GPU-accelerated search: RAFT (RAPIDS cuML for ANN), FAISS GPU (IVF, HNSW on GPU). Billion-scale vector search: DiskANN, SPANN (SSD-based), Deep 1B benchmark. Hybrid indexing: combining graph (HNSW) with quantization (PQ), trade-off analysis. Filtered search optimization: pre-filter with inverted index (fast metadata lookup), block filtering, multi-index with filter attributes. Vector compression: binary quantization (256x compression), scalar quantization (FP16 → INT8), product quantization. Security: encryption at rest, TLS in transit, access control per collection, audit logging. Observability: monitoring QPS, latency p50/p99/p999, recall, index size, memory usage, ingestion throughput. Cost optimization: tiered storage (hot vectors in memory, cold on SSD), instance sizing, index memory estimation. Emerging: learned indexes (neural approaches to ANN), relational + vector queries (SQL + vector search), serverless vector databases.
   - Proyecto: Implement HNSW from scratch with Python/C++. Billion-scale vector search evaluation. GPU-accelerated ANN with RAFT.
   - Lectura: FAISS paper (Johnson, 2019), "HNSW" paper (Malkov, 2016), ANN benchmarks paper, Milvus architecture docs.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | Vector databases como tipo especializado de base de datos |
| [034-LLM](../034-LLM/) | Embeddings de LLM almacenados como vectors |
| [035-RAG](../035-RAG/) | Vector DB como almacén de retrieval para RAG |
| [037-AgenticAI](../037-AgenticAI/) | Memoria a largo plazo para agentes en vector DB |
| [039-PromptEngineering](../039-PromptEngineering/) | Embeddings para few-shot selection dinámico |
| [031-AI](../031-AI/) | Búsqueda semántica como parte de sistemas IA |

## Recursos recomendados

- **Documentación**: Pinecone docs (docs.pinecone.io), Weaviate docs (weaviate.io/developers), Qdrant docs (qdrant.tech/documentation), Milvus docs (milvus.io/docs), Chroma docs (docs.trychroma.com).
- **Papers**: "HNSW" (Malkov, 2016), "DiskANN" (Subramanya, 2019), "FAISS" (Johnson, 2019), "Product Quantization" (Jegou, 2011), "ColBERT" (Khattab, 2020).
- **Benchmarks**: ANN Benchmarks (github.com/erikbern/ann-benchmarks), VectorDBBench (github.com/zilliztech/VectorDBBench).
- **Cursos**: DeepLearning.AI "Vector Databases: from Embeddings to Applications" (Weaviate), Pinecone Quickstart tutorials.
- **Herramientas**: FAISS (github.com/facebookresearch/faiss), Hugging Face Embeddings, Sentence Transformers.
- **Comunidad**: Weaviate Slack, Qdrant Discord, Milvus Community, Pinecone Community Forum.

## Notas adicionales

La elección de vector DB depende del caso de uso: Chroma para desarrollo/prototipado, Pinecone para producción SaaS (simplicidad), Weaviate/Qdrant para control (open source), Milvus para escala masiva (100M+ vectors). El índice HNSW es el más popular y recomendado (buen balance recall/velocidad/memoria). FAISS es la biblioteca de referencia, usada internamente por muchas vector databases. La dimensión del embedding afecta directamente el tamaño del índice y la velocidad (menor dimensión = más rápido). La calidad del embedding es más importante que el índice. Las búsquedas híbridas (vector + keyword) son esenciales para producción. El futuro: integración nativa vector en bases de datos relacionales (pgvector), serverless vector databases, y búsqueda multimodal (texto + imagen + código).
