# Pipelines RAG (Pipelines)

## Descripción del dominio

Los pipelines RAG son arquitecturas de software que orquestan el flujo completo de Retrieval Augmented Generation: desde la ingesta de documentos hasta la generación de respuestas fundamentadas. Un pipeline RAG típico incluye etapas de carga (document loading), chunking (división en fragmentos), embedding (vectorización), indexación (almacenamiento en vector database), retrieval (búsqueda de fragmentos relevantes) y generación (producción de la respuesta con el LLM). Sin embargo, los pipelines modernos incorporan múltiples variaciones: rutas condicionales, retrievers múltiples, reranking, reformulación de consultas, fusión híbrida, y post-procesamiento. Frameworks como LangChain (LCEL - LangChain Expression Language), LlamaIndex y Haystack proporcionan abstracciones modulares para construir pipelines complejos con componentes reutilizables, permitiendo composición, paralelización, streaming y observabilidad.

## Conceptos clave

- **Document Loading**: Carga de documentos desde diversas fuentes: PDF (PyMuPDF, Unstructured), HTML, bases de datos, APIs, S3, SharePoint, Confluence.
- **Text Splitting / Chunking**: División de documentos en fragmentos manejables. Estrategias: fixed-size, recursive character, semantic, agentic, hierarchical.
- **Embedding Stage**: Conversión de chunks a vectores densos usando modelos de embeddings. Puede ser batch, con caché o incremental.
- **Indexing Stage**: Almacenamiento de vectores en una vector database. Incluye creación de índices ANN (HNSW, IVF), metadatos y filtros.
- **Retrieval Stage**: Búsqueda de chunks relevantes. Puede ser simple (top-k), hibrida (keyword + vector), multi-query, o jerárquica.
- **Query Transformation**: Reformulación de la consulta del usuario para mejorar retrieval: reescritura (rewrite), descomposición (decomposition), generación de pseudo-documentos (HyDE).
- **Reranking**: Segundo paso de filtrado con cross-encoder para reordenar resultados por relevancia más precisa.
- **Generation Stage**: Inyección de chunks recuperados en el prompt del LLM. Estrategias: stuff, map-reduce, refine, context window management.
- **Streaming**: Salida token por token del LLM para mejorar experiencia de usuario. Puede incluir streaming de chunks recuperados primero.
- **Observabilidad**: Tracing, logging y monitoreo de cada etapa. Uso de LangSmith, LangFuse, Phoenix para depuración y evaluación.

## Arquitecturas de pipeline

- **Pipeline Lineal Simple**: Load → Chunk → Embed → Index → Retrieve → Generate. El flujo más básico para prototipado.
- **Pipeline con Reranking**: Load → Chunk → Embed → Index → Retrieve → Rerank → Generate. Añade un cross-encoder entre retrieval y generación.
- **Pipeline Híbrido**: Load → Embed (dense) + Tokenize (sparse) → Dual Index → Hybrid Retrieve (RRF) → Rerank → Generate.
- **Pipeline Multi-Query**: Query → Expand (variaciones) → Retrieve (para cada variación) → Fusión → Rerank → Generate.
- **Pipeline con Memoria**: Historial de chat → Resumen de contexto → Retrieve (con historial) → Generate (con memoria).
- **Pipeline Agente**: Agente LLM decide qué herramientas de retrieval usar, cuándo reformular, cuándo detenerse.

## Ejemplo: Pipeline básico con LangChain LCEL

```python
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_chroma import Chroma
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain_core.runnables import RunnablePassthrough
from langchain_core.prompts import ChatPromptTemplate

loader = PyPDFLoader("documento.pdf")
pages = loader.load()

splitter = RecursiveCharacterTextSplitter(
    chunk_size=500, chunk_overlap=50
)
chunks = splitter.split_documents(pages)

vectorstore = Chroma.from_documents(
    chunks, OpenAIEmbeddings()
)
retriever = vectorstore.as_retriever(search_kwargs={"k": 5})

template = """Responde basándote en el contexto:
{context}
Pregunta: {question}"""
prompt = ChatPromptTemplate.from_template(template)

chain = (
    {"context": retriever, "question": RunnablePassthrough()}
    | prompt
    | ChatOpenAI(model="gpt-4o-mini")
)

respuesta = chain.invoke("¿Qué dice sobre RAG?")
```

## Ejemplo: Pipeline con Query Rewriting

```python
from langchain_core.prompts import PromptTemplate
from langchain_openai import ChatOpenAI

rewrite_prompt = PromptTemplate.from_template(
    "Dada la pregunta original, genera 3 versiones mejoradas "
    "para búsqueda:\nOriginal: {question}\nVersiones:"
)

rewriter = rewrite_prompt | ChatOpenAI()

def rewrite_and_retrieve(question):
    variations = rewriter.invoke({"question": question})
    all_chunks = []
    for v in variations.split("\n"):
        chunks = retriever.invoke(v.strip())
        all_chunks.extend(chunks)
    unique = list({c.page_content: c for c in all_chunks}.values())
    return unique[:10]
```

## Relaciones con otros módulos

- `../Chunking/`: Estrategias de división usadas en la etapa de chunking del pipeline.
- `../Embedding/`: Modelos de embedding para vectorización.
- `../Retrieval/`: Estrategias de recuperación en la etapa de retrieval.
- `../HybridSearch/`: Búsqueda híbrida integrada en el pipeline.
- `../Reranking/`: Reranking como etapa opcional del pipeline.
- `../Evaluation/`: Evaluación del pipeline completo.
- `../AdvancedRAG/`: Técnicas avanzadas integrables en pipelines.
- `../../036-MCP/`: MCP como interfaz para exponer pipelines como herramientas.
- `../../037-AgenticAI/`: Agentes que construyen y ejecutan pipelines dinámicamente.

## Recursos recomendados

- **Documentación**: LangChain LCEL docs, LlamaIndex Pipeline docs, Haystack Pipeline docs.
- **Guía**: "Building RAG Pipelines" (LangChain How-to Guides).
- **Paper**: "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020).
- **Repositorio**: langchain-ai/langchain, run-llama/llama_index, deepset-ai/haystack.
- **Video**: "RAG from Scratch" series (LangChain YouTube).
- **Curso**: "LangChain for LLM Application Development" (DeepLearning.AI).
