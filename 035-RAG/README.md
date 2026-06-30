# Retrieval Augmented Generation (035-RAG)

## Descripción del dominio

Retrieval Augmented Generation (RAG) es una arquitectura que combina sistemas de recuperación de información con modelos generativos (LLMs) para producir respuestas precisas y contextualmente relevantes basadas en una base de conocimiento externa. En lugar de depender únicamente del conocimiento interno del LLM, RAG recupera documentos relevantes de una fuente de datos (vector database, índice de búsqueda) y los inyecta en el contexto del prompt para que el modelo genere respuestas fundamentadas. RAG reduce alucinaciones, permite actualizar conocimiento sin re-entrenar, y proporciona trazabilidad a las fuentes. El pipeline típico incluye: chunking (división en fragmentos), embedding (vectorización), indexing, retrieval (búsqueda de similitud), reranking y generación. Variantes avanzadas incluyen GraphRAG (uso de knowledge graphs), Agentic RAG (agentes que deciden cuándo y cómo recuperar), y RAPTOR (índices jerárquicos).

## Conceptos clave

- **Chunking**: División del conocimiento en fragmentos manejables. Estrategias: fixed-size con overlap, semantic chunking, recursive character split, token-based split.
- **Embeddings**: Representaciones vectoriales densas de texto. Modelos: text-embedding-3-small/large (OpenAI), BGE (BAAI), E5 (Microsoft), Instructor, Jina Embeddings.
- **Vector Index**: Estructura de datos para búsqueda de similitud ANN (Approximate Nearest Neighbor). IVF, HNSW, LSH.
- **Retrieval**: Búsqueda de fragmentos relevantes. Similitud coseno, producto punto, distancia euclidiana.
- **Hybrid Search**: Combina búsqueda semántica (embeddings) con búsqueda por palabras clave (BM25, TF-IDF). Resultados fusionados con RRF (Reciprocal Rank Fusion).
- **Reranking**: Segundo paso de filtrado que reordena resultados usando un modelo más potente (cross-encoder). Mejora precisión.
- **GraphRAG**: RAG sobre knowledge graphs en lugar de texto plano. Usa relaciones y entidades estructuradas para recuperación más precisa (Microsoft GraphRAG).
- **Agentic RAG**: Agente LLM que decide dinámicamente qué recuperar, cómo formular queries, cuándo detenerse o reformular.
- **Context Injection**: Inserción de documentos recuperados en el prompt del LLM. Técnicas: map_reduce, refine, stuff, context window management.
- **RAGAS**: Framework de evaluación para RAG: fidelidad, relevancia de contexto, relevancia de respuesta, recall del contexto.

## Tecnologías principales

- **Frameworks RAG**: LangChain, LlamaIndex, Haystack, Canopy (Pinecone).
- **Vector Databases**: Pinecone, Weaviate, Chroma, Qdrant, Milvus (ver ../038-VectorDatabases/).
- **Embedding Models**: OpenAI Embeddings, Cohere Embed, Voyage AI, BGE, E5, Jina, Instructor.
- **Rerankers**: Cohere Rerank, BGE Reranker, Cross-encoders (Sentence-Transformers).
- **Chunking Tools**: LangChain text splitters (RecursiveCharacter, Semantic), LlamaIndex node parsers.
- **Hybrid Search**: Elasticsearch + vector, Milvus hybrid, Qdrant hybrid, Weaviate hybrid.
- **GraphRAG**: Microsoft GraphRAG, Neo4j + LLM, NebulaGraph.
- **Evaluación**: RAGAS, TruLens, LangSmith, Arize AI.
- **Almacenamiento**: Document stores: MongoDB, Postgres (pgvector), Redis, S3.

## Hoja de ruta

**Principiante:**
1. Concepto de RAG: entender el ciclo retrieve → augment → generate.
2. Chunking básico: fixed-size split con overlap, RecursiveCharacterTextSplitter.
3. Embeddings: generar vectores con OpenAI Embeddings o Sentence-Transformers.
4. Búsqueda simple: similitud coseno en Chroma o FAISS.
5. Pipeline mínimo: cargar PDF → chunk → embed → index → retrieve → LLM responda.

**Intermedio:**
1. Multi-modal RAG: tablas, imágenes, código en documentos.
2. Hybrid search: BM25 + embeddings con RRF fusion.
3. Reranking con cross-encoder: mejorar calidad de retrieved documents.
4. Advanced chunking: semantic splitting, agentic chunking, chunk overlap strategies.
5. Evaluación con RAGAS: calcular fidelidad, relevancia, precisión del contexto.

**Avanzado:**
1. GraphRAG: construir knowledge graph desde documentos, recuperar relaciones y entidades.
2. Agentic RAG: herramientas de retrieval controladas por agente, reformulación de consultas.
3. RAG a escala: sharding, indexing incremental, caching, streaming.
4. RAG + Multi-hop: recuperación multi-paso, razonamiento sobre documentos cruzados.
5. Fine-tuning para RAG: embedding adapters, retrieval-augmented fine-tuning, RAFT.

## Relaciones con otros módulos

- `../034-LLM/`: LLMs como generadores en el pipeline RAG.
- `../038-VectorDatabases/`: Almacenamiento y búsqueda de vectores de embeddings.
- `../037-AgenticAI/`: Agentes que orquestan recuperación y generación en RAG avanzado.
- `../039-PromptEngineering/`: Diseño de prompts para inyectar contexto recuperado.
- `../033-DeepLearning/`: Modelos de embeddings y rerankers basados en deep learning.
- `../031-AI/`: Fundamentos de IA aplicados a recuperación y generación.
- `../062-Search/`: Búsqueda híbrida y sistemas de recuperación subyacentes.
- `../058-KnowledgeGraph/`: GraphRAG y representación estructurada del conocimiento.

## Recursos recomendados

- **Paper**: "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020) — Paper fundacional.
- **Paper**: "GraphRAG: Unlocking LLM Discovery on Narrative Private Data" (Microsoft, 2024).
- **Guía**: "Building RAG-based LLM Applications" (Anyscale).
- **Documentación**: LangChain RAG docs, LlamaIndex RAG docs.
- **Repositorio**: ragas-io/ragas, microsoft/graphrag, langchain-ai/langchain.
- **Video**: "RAG from Scratch" (LangChain YouTube series).
