# 063-Examples: Ejemplos Prácticos

## Descripción del dominio

Este módulo contiene ejemplos prácticos de código y casos de uso implementados que ilustran los conceptos cubiertos en otros módulos del Knowledge Engine. Cada ejemplo es autocontenido, reproducible y está documentado con instrucciones claras de ejecución. Los ejemplos están organizados por tecnología (Python, TypeScript, Rust, Go, Java) y por dominio (RAG, búsqueda, agentes, embeddings, workflows). Sirven como referencia rápida para desarrolladores que necesitan ver implementaciones funcionales antes de aplicar los conceptos en proyectos reales.

## Conceptos clave

- **Ejemplos autocontenidos**: Código completo con dependencias especificadas, listo para clonar y ejecutar — incluye scripts de setup y archivos de configuración docker-compose cuando es necesario
- **Cobertura por tecnología**: Python (sentence-transformers, LangChain, FastAPI, Elasticsearch), TypeScript/Node.js (LangChain.js, OpenAI SDK, Meilisearch), Rust (tantivy, candle), Go (bleve, go-elasticsearch), Java (Spring Boot + Elasticsearch)
- **Casos de uso implementados**: RAG básico y avanzado, chat con documentos, búsqueda híbrida, agentes autónomos, pipelines de ETL para datos no estructurados, APIs de embeddings, workflows de procesamiento
- **Demos interactivas**: Aplicaciones con interfaces web (Streamlit, Gradio, Next.js) para visualizar resultados en tiempo real — incluye datasets pequeños para pruebas locales
- **Pruebas automatizadas**: Tests unitarios y de integración para cada ejemplo — validación de resultados esperados — scripts CI/CD de ejemplo (GitHub Actions, GitLab CI)
- **Benchmarks comparativos**: Notebooks Jupyter que comparan rendimiento de diferentes enfoques (BM25 vs semántico, diferentes modelos de embedding, diferentes bases de datos vectoriales)

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Lenguajes | Python (principal), TypeScript/Node.js, Rust, Go, Java, Bash |
| Frameworks de IA | LangChain, LlamaIndex, Haystack, Semantic Kernel, DSPy |
| Búsqueda | Elasticsearch, Meilisearch, Typesense, Algolia |
| Embeddings | sentence-transformers, OpenAI Embeddings, Cohere, BGE |
| Bases de datos vectoriales | Chroma, Qdrant, Pinecone, Weaviate, pgvector |
| Workflows | Prefect, Temporal, Airflow, LangGraph |
| Agentes | LangChain Agents, CrewAI, AutoGPT, OpenAI Assistants API |
| Fronend demo | Streamlit, Gradio, FastAPI + React, Jupyter Notebooks |
| Contenedores | Docker Compose para entornos multi-servicio (Elasticsearch + API + DB vectorial) |

## Hoja de ruta

1. **Principiante**: README de ejemplo con código básico — "Hello World" de búsqueda semántica — script Python para crear embeddings con sentence-transformers — API básica con FastAPI — consulta simple a Elasticsearch desde Python
2. **Intermedio**: Pipeline RAG completo (ingestión → chunking → embedding → almacenamiento → consulta) — agente simple con LangChain — búsqueda híbrida con BM25 + embeddings — notebook Jupyter de comparación de embeddings
3. **Avanzado**: Sistema multi-agente con CrewAI — workflow de procesamiento de documentos con Prefect — API de búsqueda con re-ranking — integración con OpenAI Assistants API — despliegue con Docker Compose completo
4. **Experto**: Ejemplos con múltiples modelos de embedding combinados — pipelines de RAG con routing y clasificación — agentes con memoria persistente y herramientas — benchmarks reproducibles con datasets públicos — ejemplos de fine-tuning de embeddings para dominio específico

## Relaciones con otros módulos

- [034-LLM](../034-LLM/) — Ejemplos de integración con LLMs locales y cloud
- [035-RAG](../035-RAG/) — Ejemplos implementados de Retrieval Augmented Generation
- [061-Embeddings](../061-Embeddings/) — Código de generación y uso de embeddings
- [062-Search](../062-Search/) — Implementaciones de búsqueda textual, semántica e híbrida
- [064-Agents](../064-Agents/) — Agentes implementados con diferentes frameworks
- [065-Workflows](../065-Workflows/) — Pipelines y flujos de trabajo implementados
- [038-VectorDatabases](../038-VectorDatabases/) — Ejemplos de uso de cada base de datos vectorial
- [001-Languages](../001-Languages/) — Código en diferentes lenguajes de programación

## Recursos recomendados

- **Documentación oficial**: LangChain Examples, LlamaIndex Guides, Elasticsearch Examples, OpenAI Cookbook
- **Repositorios de ejemplo**: LangChain Templates, LlamaIndex Examples, Google Generative AI Samples, Cohere Notebooks
- **Plataformas**: HuggingFace Spaces (demos desplegadas), Replicate (modelos como API), Google Colab (notebooks gratuitos)
- **Workshops**: Full Stack LLM Bootcamp (Hamel Husain), Building RAG Applications (Pinecone), LangChain Academy
