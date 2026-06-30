# RAG Avanzado (AdvancedRAG)

## Descripción del dominio

RAG Avanzado (AdvancedRAG) comprende técnicas y arquitecturas que van más allá del pipeline básico de recuperación-generación para abordar limitaciones como la mala calidad de recuperación, la pérdida de contexto intermedio, la falta de razonamiento multi-paso y la escalabilidad. Estas técnicas incluyen GraphRAG (uso de knowledge graphs para recuperación estructurada), RAPTOR (indexación jerárquica con resúmenes), CRAG (Corrective RAG con autoevaluación), Self-RAG (el LLM decide cuándo recuperar), Agentic RAG (agentes que orquestan retrieval), Multi-Modal RAG (procesamiento de imágenes, tablas, código) y RAG con fine-tuning (RAFT, AAR). AdvancedRAG también aborda la optimización de chunks, la fusión de múltiples fuentes, el razonamiento multi-hop sobre documentos cruzados, y la personalización del retrieval basada en el usuario o la tarea.

## Conceptos clave

- **GraphRAG**: Construye un knowledge graph a partir de documentos. La recuperación usa relaciones y entidades estructuradas, no solo texto plano. Microsoft GraphRAG permite descubrimiento de temas globales y recuperación jerárquica.
- **RAPTOR (Recursive Abstractive Processing for Tree-Organized Retrieval)**: Indexa documentos en una jerarquía de resúmenes recursivos. Los nodos hoja son chunks, los niveles superiores son resúmenes. Retrieval recorre el árbol de arriba abajo.
- **Self-RAG**: El LLM decide dinámicamente si necesita recuperar información, qué fragmentos usar, y si la respuesta está fundamentada. Usa tokens especiales (retrieve, relevant, support, useful) generados por el modelo.
- **CRAG (Corrective RAG)**: Evaluación automática de la calidad de los documentos recuperados. Si son irrelevantes, se descartan y se busca otra fuente. Si son parcialmente relevantes, se refina la búsqueda.
- **Agentic RAG**: Un agente LLM controla el proceso de retrieval: reformula consultas, elige entre múltiples fuentes (vector DB, web, SQL), decide cuándo detenerse y cómo combinar resultados.
- **HyDE (Hypothetical Document Embeddings)**: Genera un documento hipotético como respuesta a la consulta, usa su embedding para buscar documentos similares. Útil cuando la brecha semántica entre consulta y documentos es grande.
- **Multi-Hop RAG**: Razonamiento que requiere recuperar información de múltiples documentos en secuencia, donde la respuesta a una pregunta depende de información obtenida en pasos anteriores.
- **Multi-Modal RAG**: Procesa documentos con texto, imágenes, tablas y código. Usa modelos multimodales (CLIP, GPT-4V) para embedding y recuperación de todos los modos.
- **FiD (Fusion-in-Decoder)**: Arquitectura donde cada documento recuperado se procesa por separado (encoder) y luego se fusionan en el decoder. Escalable a muchos documentos.
- **REPLUG**: El retriever se integra con el LLM como un "plug-in": el LLM puede influir en qué recuperar basándose en su propia generación.
- **Fine-tuning para RAG**: Técnicas como RAFT (Retrieval Augmented Fine Tuning) que fine-tunean el LLM para usar correctamente documentos recuperados, incluyendo casos sin documentos (el modelo debe responder con su conocimiento).

## Ejemplo: Self-RAG

```python
# Pseudocódigo del flujo Self-RAG
def self_rag(query):
    # 1. Decidir si recuperar
    decision = llm.generate(
        f"Pregunta: {query}\n¿Necesito buscar información? (SÍ/NO): "
    )
    if "SÍ" in decision:
        chunks = retriever.invoke(query)
        # 2. Evaluar relevancia de cada chunk
        useful_chunks = []
        for chunk in chunks:
            eval = llm.generate(
                f"Contexto: {chunk}\n"
                f"Pregunta: {query}\n"
                f"¿Este contexto es relevante? (SÍ/NO): "
            )
            if "SÍ" in eval:
                useful_chunks.append(chunk)
        # 3. Generar respuesta con chunks útiles
        response = llm.generate(
            f"Contexto: {' '.join(useful_chunks)}\n"
            f"Pregunta: {query}\n"
            f"Responde solo si el contexto soporta tu respuesta: "
        )
    else:
        response = llm.generate(query)
    return response
```

## Ejemplo: GraphRAG con Microsoft GraphRAG

```python
# Configuración de GraphRAG (CLI)
# graphrag init --root ./my_project
# graphrag index --root ./my_project
# graphrag query --root ./my_project \
#   --method global \
#   --query "¿Cuáles son los temas principales?"

# Uso programático (desde la librería)
from graphrag.query import GlobalSearch, LocalSearch

global_search = GlobalSearch(config)
result = global_search.search(
    "Evolución de la inteligencia artificial"
)
print(result.response)
```

## Técnicas de optimización

- **Chunking Avanzado**: Semantic chunking con embeddings, agentic chunking con LLM, chunking jerárquico.
- **Query Transformation**: Reescritura de consultas, descomposición en sub-preguntas, generación de variaciones.
- **Indexación Jerárquica**: RAPTOR, resúmenes por sección, tabla de contenido + chunks.
- **Retrieval Fusion**: Multi-query retrieval, RRF, weighted sum, fusión adaptativa.
- **Context Window Management**: Sliding window, map-reduce, refine, resumen selectivo de chunks.
- **Caching de Retrieval**: Caché LRU para fragmentos frecuentemente recuperados, embedding cache.

## Relaciones con otros módulos

- `../Chunking/`: Técnicas de chunking avanzado para mejorar recuperación.
- `../HybridSearch/`: Fusión de retrievers como base para técnicas avanzadas.
- `../Pipelines/`: Componentes de pipelines que integran estas técnicas.
- `../Evaluation/`: Evaluación comparativa de técnicas avanzadas.
- `../GraphRAG/`: GraphRAG como técnica específica de RAG avanzado.
- `../../037-AgenticAI/`: Agentic RAG como integración con agentes.
- `../../038-VectorDatabases/`: Vector databases que soportan índices híbridos y jerárquicos.
- `../../039-PromptEngineering/`: Prompts para controlar retrievers y evaluación.

## Recursos recomendados

- **Paper**: "GraphRAG: Unlocking LLM Discovery on Narrative Private Data" (Microsoft, 2024).
- **Paper**: "RAPTOR: Recursive Abstractive Processing for Tree-Organized Retrieval" (Sarthi et al., 2024).
- **Paper**: "Self-RAG: Learning to Retrieve, Generate, and Critique through Self-Reflection" (Asai et al., 2023).
- **Paper**: "Corrective Retrieval Augmented Generation" (Yan et al., 2024).
- **Paper**: "RAFT: Adapting Language Model to Domain Specific RAG" (Zhang et al., 2024).
- **Guía**: "Advanced RAG Techniques" (LlamaIndex, 2024).
- **Repositorio**: microsoft/graphrag, langchain-ai/langgraph.
- **Video**: "Advanced RAG Techniques" (LangChain YouTube).
