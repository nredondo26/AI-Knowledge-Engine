# LangChain — Framework para Aplicaciones con LLMs

## Concepto

**LangChain** es un framework open-source (Python/TypeScript) para construir aplicaciones potenciadas por modelos de lenguaje. Proporciona abstracciones modulares para encadenar llamadas a LLMs, conectar herramientas, gestionar memoria, implementar agentes autónomos y construir pipelines RAG completos.

LangChain abstrae la complejidad de orquestar múltiples pasos (recuperación → generación → validación) en cadenas reutilizables y componibles.

## Arquitectura de LangChain

```
Aplicación
  │
  ├─► Model I/O
  │     ├─ ChatModels (GPT-4, Claude, Llama)
  │     ├─ Prompts (PromptTemplate, ChatPromptTemplate)
  │     └─ Output Parsers (Str, JSON, Pydantic, XML)
  │
  ├─► Retrieval
  │     ├─ Document Loaders (PDF, HTML, Web, DB)
  │     ├─ Text Splitters (Recursive, Semantic)
  │     ├─ Embeddings (OpenAI, SBERT, HF)
  │     ├─ Vector Stores (FAISS, Chroma, Pinecone)
  │     └─ Retrievers (VectorStore, MultiQuery, Ensemble)
  │
  ├─► Chains
  │     ├─ LLMChain (prompt → LLM → parser)
  │     ├─ SequentialChain (encadenamiento lineal)
  │     ├─ RouterChain (enrutamiento condicional)
  │     └─ LCEL (LangChain Expression Language)
  │
  └─► Agents
        ├─ Tools (funciones que el agente puede usar)
        ├─ Toolkits (colecciones de herramientas)
        ├─ AgentExecutor (bucle razón-acción-observación)
        └─ Memory (Buffer, Summary, VectorStore)
```

## Componentes Fundamentales

### 1. Model I/O

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

modelo = ChatOpenAI(model="gpt-4o-mini", temperature=0)

prompt = ChatPromptTemplate.from_messages([
    ("system", "Eres un experto en {tema}"),
    ("human", "{pregunta}")
])

parser = StrOutputParser()

# LCEL: composición con pipe |
cadena = prompt | modelo | parser

respuesta = cadena.invoke({"tema": "RAG", "pregunta": "¿Qué es chunking?"})
print(respuesta)
```

### 2. Chains — Cadenas de Procesamiento

```python
from langchain_core.runnables import RunnableParallel, RunnablePassthrough

# Cadena paralela: ejecuta múltiples operaciones simultáneas
cadena_paralela = RunnableParallel(
    resumen=prompt | modelo | parser,
    palabras=lambda x: len(x["pregunta"].split())
)

resultado = cadena_paralela.invoke({"tema": "IA", "pregunta": "¿Qué es RAG?"})
print(resultado)
# {'resumen': '...', 'palabras': 3}

# Cadena secuencial con transformación
from langchain_core.runnables import RunnableLambda

def contar_tokens(texto):
    return {"tokens": len(texto.split())}

cadena = prompt | modelo | parser | RunnableLambda(contar_tokens)
```

### 3. RAG Pipeline Completo

```python
from langchain_community.document_loaders import TextLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import FAISS
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain

# 1. Cargar documentos
loader = TextLoader("documento.txt")
docs = loader.load()

# 2. Fragmentar
splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
chunks = splitter.split_documents(docs)

# 3. Indexar
embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
vectorstore = FAISS.from_documents(chunks, embeddings)

# 4. Crear retriever
retriever = vectorstore.as_retriever(search_kwargs={"k": 4})

# 5. Prompt de generación
prompt_rag = ChatPromptTemplate.from_messages([
    ("system", "Responde basado en el contexto:\n\n{context}"),
    ("human", "{input}")
])

# 6. Chain combinada
combine_chain = create_stuff_documents_chain(modelo, prompt_rag)
rag_chain = create_retrieval_chain(retriever, combine_chain)

# 7. Invocar
respuesta = rag_chain.invoke({"input": "¿Qué es RAG?"})
print(respuesta["answer"])
```

### 4. Agentes con Herramientas

```python
from langchain.agents import create_react_agent, AgentExecutor
from langchain.tools import tool
from langchain_core.prompts import PromptTemplate

@tool
def buscar_web(consulta: str) -> str:
    """Busca información actualizada en la web."""
    # Implementación con API de búsqueda
    return f"Resultados simulados para: {consulta}"

@tool
def calcular(expresion: str) -> str:
    """Evalúa una expresión matemática."""
    return str(eval(expresion))  # solo demo, usar safe_eval en producción

tools = [buscar_web, calcular]

prompt_agente = PromptTemplate.from_template("""
Eres un asistente con herramientas. Responde la pregunta del usuario.

Herramientas disponibles:
{tools}

Usa el formato:
Pensamiento: Razonamiento
Acción: nombre_herramienta
Input de Acción: input
Observación: resultado
Pensamiento: Conclusión
Respuesta Final: ...

Pregunta: {input}
{agent_scratchpad}
""")

agente = create_react_agent(modelo, tools, prompt_agente)
executor = AgentExecutor(agent=agente, tools=tools, verbose=True)

respuesta = executor.invoke({"input": "¿Cuánto es 15 * 7? ¿Y cuál es la capital de Francia?"})
print(respuesta["output"])
```

## Buenas Prácticas

1. **LCEL sobre Chains legacy**: Preferir la sintaxis `|` sobre `LLMChain`.
2. **Runnables paralelos**: Usar `RunnableParallel` para tareas independientes.
3. **Templating**: Usar `ChatPromptTemplate` con mensajes estructurados.
4. **Error handling**: `Runnable.with_fallbacks` para resiliencia.
5. **Trazabilidad**: Integrar con LangSmith para debugging.

```python
cadena_segura = cadena.with_fallbacks([
    prompt | ChatOpenAI(model="gpt-3.5-turbo") | parser
])
```
