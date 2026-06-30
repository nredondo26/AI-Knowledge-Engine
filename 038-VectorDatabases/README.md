# Bases de Datos Vectoriales (038-VectorDatabases)

## Descripción del dominio

Las bases de datos vectoriales son sistemas de almacenamiento y búsqueda especializados en vectores densos de alta dimensionalidad (embeddings). A diferencia de las bases de datos tradicionales que buscan coincidencias exactas, las vector databases realizan búsquedas por similitud semántica utilizando índices ANN (Approximate Nearest Neighbor). Son el componente central de sistemas RAG, motores de búsqueda semántica, sistemas de recomendación y memoria a largo plazo de agentes de IA. Cada vector representa una entidad (documento, imagen, usuario, producto) como una representación numérica densa generada por un modelo de embeddings. Las operaciones fundamentales son búsqueda de vecinos más cercanos (k-NN), filtrado por metadatos (pre-filter, post-filter), indexación (HNSW, IVF, DiskANN) y particionamiento. Los principales proveedores incluyen Pinecone (gestionado), Weaviate (open source con graph), Chroma (embebido, simple), Qdrant (Rust, alto rendimiento), Milvus (escala masiva) y pgvector (PostgreSQL).

## Conceptos clave

- **Embeddings**: Vectores densos de números reales que representan significado semántico. Generados por modelos como text-embedding-3, BGE, E5.
- **Similitud**: Métrica de distancia entre vectores. Coseno (más común), producto punto, euclidiana (L2), Manhattan.
- **ANN (Approximate Nearest Neighbor)**: Algoritmos que encuentran vecinos cercanos con alta precisión pero sin garantía de exactitud, a cambio de velocidad extrema.
- **Índices ANN**: HNSW (Hierarchical Navigable Small World) — balance velocidad/precisión. IVF (Inverted File Index) — escalable, particiona el espacio. DiskANN — basado en disco, maneja datasets enormes. LSH (Locality-Sensitive Hashing) — hashing probabilístico.
- **k-NN**: Búsqueda de los k vectores más cercanos a un vector de consulta.
- **Filtrado por Metadatos**: Pre-filter (filtra antes de buscar) vs Post-filter (filtra resultados después de buscar). Híbrido combina ambos.
- **Hybrid Search**: Combina búsqueda vectorial (semántica) con búsqueda por palabras clave (BM25/TF-IDF). Usa RRF (Reciprocal Rank Fusion) o Dense-Sparse embeddings.
- **Particionamiento (Sharding)**: División del índice en múltiples particiones para distribuir carga y escalar horizontalmente.
- **Replicación**: Copias del índice para alta disponibilidad y balanceo de carga.
- **CRUD**: Operaciones de Create, Read, Update, Delete sobre vectores y sus metadatos asociados.
- **Upsert**: Operación combinada update + insert. Actualiza si existe, inserta si no.
- **Metadata Storage**: Almacenamiento de información estructurada asociada a cada vector (título, fecha, fuente, tags) para filtrado y enriquecimiento.

## Tecnologías principales

- **Pinecone**: SaaS totalmente gestionado. Escalable, alta disponibilidad, pods serverless. Ideal para producción sin ops.
- **Weaviate**: Open source, soporta graph + vectores nativo. Módulos para Q&A, generación, clasificación. Híbrido nativo.
- **Chroma**: Open source, embebido, fácil de usar. Ideal para prototipado, proyectos pequeños, LangChain integrado.
- **Qdrant**: Open source escrito en Rust. Rendimiento extremo, filtro avanzado, payload indexing, cuantización escalar.
- **Milvus**: Open source, escala masiva (miles de millones de vectores). GPU acceleration, múltiples índices, tool ecosystem.
- **pgvector**: Extensión PostgreSQL para vectores. Integración con bases de datos relacionales existentes.
- **Vald**: Cloud-native, diseño basado en CNCF. Escalado automático, alta disponibilidad.
- **Redis Stack**: Búsqueda vectorial en Redis con RediSearch + RedisJSON. Baja latencia, caché + vectores.
- **Elasticsearch / OpenSearch**: Búsqueda vectorial con dense_vector, kNN, hybrid search.
- **FAISS**: Biblioteca de índice ANN de Meta (no es BD pero subyace a muchas). GPU, CPU, clustering, cuantización.

## Hoja de ruta

**Principiante:**
1. Concepto de embeddings y similitud semántica vs. búsqueda por palabras clave.
2. Generar embeddings con OpenAI Embeddings o Sentence-Transformers.
3. Chroma: crear colección, insertar documentos, buscar por similitud.
4. pgvector: almacenar vectores en PostgreSQL, consultas k-NN con SQL.
5. Métricas de distancia: coseno, L2, producto punto — cuándo usar cada una.

**Intermedio:**
1. HNSW index: entender parámetros (M, ef_construction, ef_search), tuning para velocidad vs precisión.
2. Filtrado de metadatos: pre-filter vs post-filter, diferencias de rendimiento.
3. Hybrid search: BM25 + embeddings con RRF, Weaviate hybrid nativo.
4. Qdrant: payload indexing, filtros complejos, cuantización escalar para reducir memoria.
5. Evaluación: recall@k, latency@percentiles, throughput, comparación de vectores por query.

**Avanzado:**
1. Milvus a escala: sharding, replicación, balanceo de carga, rolling upgrades.
2. DiskANN: índices en disco para datasets que no caben en RAM.
3. Embeddings multimodal: texto + imagen + audio en un mismo espacio vectorial.
4. Fine-tuning de embeddings: ajustar modelos para mejorar retrieval en dominios específicos.
5. Producción: monitoreo de drift de embeddings, re-indexación periódica, backup/restore, disaster recovery.

## Relaciones con otros módulos

- `../035-RAG/`: Vector databases como almacén de conocimiento para RAG.
- `../034-LLM/`: Embeddings generados por LLMs para indexación semántica.
- `../037-AgenticAI/`: Memoria a largo plazo de agentes basada en vectores.
- `../033-DeepLearning/`: Modelos de embeddings basados en deep learning (BERT, SBERT).
- `../032-MachineLearning/`: Algoritmos de clustering y reducción de dimensionalidad para vectores.
- `../062-Search/`: Motores de búsqueda que integran búsqueda vectorial.
- `../061-Embeddings/`: Catálogo de modelos de embeddings y técnicas de vectorización.

## Recursos recomendados

- **Paper**: "Efficient and robust approximate nearest neighbor search using Hierarchical Navigable Small World graphs" (Malkov & Yashunin, 2016) — HNSW original.
- **Documentación**: Pinecone Docs, Weaviate Docs, Qdrant Docs, Milvus Docs, Chroma Docs.
- **Curso**: "Vector Databases for AI" (Pinecone Academy).
- **Comparativa**: "Vector Database Benchmarks" (qdrant.tech/benchmarks).
- **Repositorio**: "awesome-vector-database" (GitHub).
- **Video**: "Vector Databases: A Beginner's Guide!" (Fireship).
