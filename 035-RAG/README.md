# 035-RAG: Retrieval Augmented Generation

## Descripción ampliada del dominio

Retrieval Augmented Generation (RAG) es una arquitectura que combina sistemas de recuperación de información con modelos generativos (LLMs) para producir respuestas precisas y contextualmente relevantes basadas en una base de conocimiento externa. En lugar de depender únicamente del conocimiento interno del LLM, RAG recupera documentos relevantes de una fuente de datos (vector database, índice de búsqueda, conocimiento estructurado) y los inyecta en el contexto del prompt para que el modelo genere respuestas fundamentadas. RAG reduce alucinaciones, permite actualizar conocimiento sin re-entrenar, y proporciona trazabilidad a las fuentes. La evolución: RAG naïve (2020, Lewis) → RAG avanzado (chunking, indexing, retrieval, reranking) → modular RAG (multi-step, routing) → GraphRAG (2024, Microsoft) → Agentic RAG (agentes que deciden estrategia de recuperación) → RAG + multi-modal (imagen, tabla, video, código). Las variantes incluyen: RAG secuencial (retrieve → read), RAG iterativo (múltiples retrieves durante generación), RAG correctivo (corrige retrieved docs), RAG adaptativo (decide cuándo y qué recuperar).

## Tabla de conceptos clave

| Concepto | Descripción | Técnicas/Implementaciones |
|----------|-------------|--------------------------|
| Chunking | División del conocimiento en fragmentos manejables | Fixed-size (overlap), RecursiveCharacter, Semantic, Agentic, token-based |
| Embedding | Vectorización densa de texto para búsqueda semántica | text-embedding-3, BGE, E5, Jina, Instructor, Cohere |
| Vector Index | Estructura ANN para búsqueda de similitud | HNSW (Weaviate, Qdrant), IVF (Milvus, FAISS), DiskANN |
| Retrieval | Búsqueda de fragmentos relevantes | Similitud coseno, dot product, MMR (Maximum Marginal Relevance) |
| Hybrid Search | Combinación de semántica + keywords | BM25 + dense vectors → RRF (Reciprocal Rank Fusion) |
| Reranking | Segundo filtro con modelo cross-encoder | Cohere Rerank, BGE Reranker, BAAI BGE, sentence-transformers |
| Context Injection | Inserción de documentos recuperados en el prompt | Stuff, MapReduce, Refine, Map Re-rank |
| GraphRAG | RAG sobre knowledge graphs con entidades y relaciones | Microsoft GraphRAG, Neo4j + LLM, Amazon Neptune |
| Agentic RAG | Agente decide dinámicamente estrategia de recuperación | LangChain Agent, LlamaIndex Agent, yoom/bot |
| Multi-hop RAG | Recuperación multi-paso con razonamiento cruzado | Query decomposition, iterative retrieval, beam search |
| Evaluation (RAGAS) | Framework de evaluación de RAG | Faithfulness, relevance, context precision, recall, CRUD |

## Tecnologías principales

| Categoría | Herramientas | Propósito |
|-----------|-------------|-----------|
| Frameworks | LangChain, LlamaIndex, Haystack, Canopy (Pinecone), R2R | Orquestación del pipeline RAG |
| Vector Databases | Pinecone, Weaviate, Chroma, Qdrant, Milvus, FAISS | Almacenamiento y búsqueda de vectores |
| Embedding Models | OpenAI (text-embedding-3), Cohere (embed-english-v3), Voyage, BGE, E5, Jina | Vectorización de texto |
| Rerankers | Cohere Rerank, BGE Reranker, cross-encoders (Sentence Transformers) | Reordenamiento de resultados |
| Chunking | LangChain text splitters, LlamaIndex node parsers, semantic chunkers | División de documentos |
| Hybrid Search | Elasticsearch, Weaviate hybrid, Qdrant hybrid, PostgreSQL (pgvector + tsvector) | Búsqueda combinada |
| GraphRAG | Microsoft GraphRAG, Neo4j, NebulaGraph, Amazon Neptune | RAG con knowledge graphs |
| Evaluation | RAGAS, TruLens, LangSmith, Arize AI, DeepEval | Métricas de calidad de RAG |
| Monitoring | LangFuse, LangSmith, Weights & Biases, Arize | Observabilidad de pipelines RAG |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Concepto RAG: retrieve → augment → generate. Chunking: fixed-size split con overlap (LangChain RecursiveCharacterTextSplitter, chunk_size=1000, chunk_overlap=200). Embeddings: OpenAI Embeddings API (text-embedding-3-small), Sentence Transformers (all-MiniLM-L6-v2). Vector Store: Chroma (persistencia local, add documents, similarity_search). Pipeline básico: cargar PDF → chunk → embed → index → retrieve → LLM genera respuesta con contexto. Prompt template: "Use the following context to answer the question. Context: {context}. Question: {question}. Answer:". RAG con parámetros: k (3-10 chunks), score threshold.
   - Proyecto: RAG pipeline with PDF documents + LangChain + Chroma + OpenAI/Claude. Web UI con Streamlit.
   - Lectura: "Building RAG-based LLM Applications" (Anyscale), LangChain RAG docs, LlamaIndex starter.

2. **Intermedio (2-6 meses)**: Advanced chunking: SemanticChunker (split by sentence similarity), RecursiveCharacter with custom separators, hierarchical chunking (parent-child chunks). Advanced retrieval: hybrid search (BM25 + dense) con RRF fusion, MMR (diversidad en retrieved docs), compressed retrieval (LLM reranking). Reranking: BGE Reranker/cross-encoder para reordenar chunks después de retrieval inicial. Prompt engineering for RAG: contexto bien formateado (separación de chunks, fuentes, metadatos), few-shot examples. Multi-modal RAG: tablas (llamaindex TableRetriever), imágenes (multi-modal embeddings, CLIP), código (code chunking). Multi-document RAG: routing queries to correct document, metadata filtering (date, source, author). Evaluation: RAGAS (faithfulness, answer relevancy, context precision, context recall, answer correctness). Streaming: respuesta en streaming con Server-Sent Events. Response generation: summarizer vs extractor vs hybrid. Context window management: sliding window, truncation, summarization of context.
   - Proyecto: Multi-document RAG with hybrid search + reranking + metadata filtering. Evaluation pipeline with RAGAS. Multi-modal RAG with tables and images.
   - Certificación: DeepLearning.AI "LangChain: Chat with Your Data", "Advanced RAG" courses.
   - Lectura: "Advanced RAG" (TruEra), LlamaIndex advanced tutorials.

3. **Avanzado (6-12 meses)**: GraphRAG: Microsoft GraphRAG (entity extraction, community detection, local/global search), construcción de knowledge graph desde documentos (entidades, relaciones), retrieval basado en estructuras de grafo (entity expansion, path traversal). Agentic RAG: agentes LLM que deciden dinámicamente: qué fuentes consultar, cómo reformular queries, cuándo buscar información adicional (tool calling), cuándo detenerse. Multi-hop RAG: descomposición de pregunta compleja en sub-preguntas, retrieval iterativo, respuesta combinada contextualizada. Corrección de retrieved docs: autocorrección de documentos (tranformación, extracción de respuesta directa), reranking iterativo. Adaptive RAG: router que decide entre retrieval + QA, QA directa (sin retrieval), o resumir. Caching: embedding cache, vector search cache, response cache (semantic caching con GPTCache, Redis). Fine-tuning for RAG: embedding adapters (fine-tune embeddings en dominio específico), retrieval-augmented fine-tuning (RAFT). Data ingestion pipeline: document parsing (Unstructured, MarkItDown, LlamaParse), table extraction (Camelot, Tabula), cleaning, chunking optimization.
   - Proyecto: GraphRAG pipeline with Microsoft GraphRAG + Neo4j. Agentic RAG with LangChain Agent + tools. Multi-hop RAG for complex scientific questions.
   - Lectura: "GraphRAG: Unlocking LLM Discovery" (Microsoft), "RAFT: Adapting Language Model to Domain Specific RAG" papers.

4. **Experto (12+ meses)**: RAG a escala: sharding (índices vectoriales distribuidos), incremental indexing (update without full re-index), streaming ingestion. Storage optimization: data compression, tiered storage (hot/warm/cold), mmap (FAISS), product quantization for embeddings. Query optimization: query routing (NLP router, rule-based), multi-vector indexing, late interaction (ColBERT v2), contextual retrieval (Anthropic's contextual retrieval). Knowledge base management: versioning, deduplicación, refresh strategies, data quality metrics. Self-RAG: modelo genera tokens de reflexión para decidir si necesita retrieval, y evalúa retrieved docs. Long-context RAG: usar contextos largos (100K+) para evitar chunking, contextual retrieval embedding. Federated RAG: retrieval multi-source heterogéneo (databases, APIs, web, vector stores, graph). RAG security: data leakage prevention, access control (document-level permissions), PII redaction from retrieved context, prompt injection en contexto recuperado. RAG + RL: reinforcement learning para optimizar retrieval + generation policy conjunta.
   - Proyecto: Large-scale RAG system (millones de docs) with sharding and incremental indexing. Self-RAG implementation. Federated RAG con múltiples fuentes heterogéneas.
   - Lectura: ColBERT paper, Self-RAG paper, Anthropic "Contextual Retrieval" blog, RAG survey papers.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [031-AI](../031-AI/) | IA aplicada a recuperación y generación |
| [033-DeepLearning](../033-DeepLearning/) | Embeddings, cross-encoders basados en deep learning |
| [034-LLM](../034-LLM/) | LLM como generador, embeddings, y razonador en RAG |
| [036-MCP](../036-MCP/) | MCP puede conectar RAG a herramientas externas |
| [037-AgenticAI](../037-AgenticAI/) | Agentic RAG como variante de agentes |
| [038-VectorDatabases](../038-VectorDatabases/) | Vector DB como almacén de embeddings |
| [039-PromptEngineering](../039-PromptEngineering/) | Diseño de prompts para inyectar contexto recuperado |
| [040-Reasoning](../040-Reasoning/) | Multi-hop reasoning para retrieval complejo |

## Recursos recomendados

- **Papers**: "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020), "GraphRAG" (Microsoft, 2024), "RAFT" (2024), "REPLUG" (2023), "Self-RAG" (2023).
- **Cursos**: DeepLearning.AI "LangChain: Chat with Your Data", "Advanced RAG", "Building RAG Agents with LlamaIndex".
- **Documentación**: LangChain RAG docs (python.langchain.com), LlamaIndex docs (llamaindex.ai), Haystack docs (haystack.deepset.ai).
- **Herramientas**: LangChain, LlamaIndex, Haystack, Chroma, Weaviate, Qdrant, Pinecone, RAGAS, TruLens.
- **Blogs**: Anyscale "RAG at Scale", LlamaIndex blog, LangChain blog, Microsoft Research blog, Anthropic "Contextual Retrieval".

## Notas adicionales

RAG es la arquitectura más usada para aplicaciones empresariales con LLMs porque combina conocimiento actualizado con capacidades generativas. La elección de chunking y embedding es más importante que la elección del LLM. La evaluación con RAGAS es esencial para medir calidad. GraphRAG es superior para preguntas que requieren comprensión de relaciones entre entidades. La hibridación (BM25 + semántica) supera a solo semántica. RAG + fine-tuning son complementarios: RAG para conocimiento factual, fine-tuning para estilo y formato. El futuro: contextos largos reducen dependencia de RAG, pero RAG será necesario para conocimiento privado, actualizado y escalable.
