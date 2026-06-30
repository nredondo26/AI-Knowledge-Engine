# Memoria en Agentes (Memory)

## Descripción del dominio

La memoria en agentes de IA es el sistema que permite almacenar, recuperar y utilizar información a lo largo del tiempo para mantener coherencia, contexto y aprendizaje en las interacciones del agente. A diferencia de los LLMs sin estado (cada consulta es independiente), los agentes necesitan memoria para recordar conversaciones anteriores, preferencias del usuario, resultados de acciones previas, y conocimiento acumulado. La memoria se organiza típicamente en tres niveles: memoria a corto plazo (short-term, dentro de la ventana de contexto del LLM), memoria a largo plazo (long-term, persistente en vector database), y memoria episódica (episodic, historial comprimido de experiencias). Frameworks como Mem0, Zep, LangGraph (persistence) y LlamaIndex (ChatMemoryBuffer) proporcionan implementaciones listas para usar. La gestión eficiente de la memoria es crítica para agentes que operan en sesiones largas o necesitan aprendizaje continuo.

## Conceptos clave

- **Short-Term Memory (STM)**: Memoria dentro de la ventana de contexto del LLM. Contiene el historial reciente de mensajes, herramientas llamadas y resultados. Volátil, limitada por tokens.
- **Long-Term Memory (LTM)**: Memoria persistente almacenada en una vector database. Contiene conocimientos, hechos, preferencias y aprendizaje acumulado entre sesiones. Consultable por similitud semántica.
- **Episodic Memory**: Registro de experiencias pasadas del agente: qué acciones tomó, qué resultados obtuvo, qué errores cometió. Usada para aprendizaje por refuerzo y reflexión.
- **Semantic Memory**: Conocimiento factual almacenado por el agente: conceptos, reglas, información del dominio. Puede solaparse con LTM pero es más estructurada.
- **Working Memory**: Espacio de trabajo temporal donde el agente mantiene información relevante para la tarea actual. Similar a STM pero más enfocada en el contexto inmediato de razonamiento.
- **Memory Consolidation**: Proceso de transferir información relevante de STM a LTM. Puede ser automático (resúmenes periódicos) o explícito (el agente decide qué recordar).
- **Memory Retrieval**: Búsqueda en LTM usando embeddings de la consulta actual. Recupera recuerdos relevantes para inyectar en el contexto del LLM.
- **Memory Buffer**: Estructura de datos que mantiene el historial reciente con gestión de ventana deslizante (sliding window) para limitar tokens.
- **Summary Memory**: Resumen comprimido de la conversación hasta el momento. Se actualiza periódicamente y se inyecta en el contexto cuando la ventana se llena.
- **Forgetting**: Estrategias para olvidar información obsoleta o irrelevante: decay (pérdida gradual), recency (priorizar reciente), importance (priorizar relevante).
- **Mem0**: Framework de memoria para agentes. Provee perfil de usuario, memoria de conversación y aprendizaje adaptativo.

## Ejemplo: Memoria con Mem0

```python
from mem0 import Memory

memory = Memory(
    config={
        "vector_store": {
            "provider": "qdrant",
            "config": {
                "host": "localhost",
                "port": 6333,
                "collection_name": "memoria_agente"
            }
        },
        "llm": {
            "provider": "openai",
            "config": {
                "model": "gpt-4o"
            }
        }
    }
)

# Almacenar memoria
memory.add(
    messages=[
        {"role": "user", "content": "Me llamo Juan"},
        {"role": "assistant", "content": "Hola Juan, encantado de conocerte"}
    ],
    user_id="juan",
    agent_id="asistente"
)

# Recuperar memoria relevante
recuerdos = memory.search(
    query="¿Cómo se llama el usuario?",
    user_id="juan",
    agent_id="asistente",
    limit=5
)

# Obtener historial completo
historial = memory.get_history(
    user_id="juan",
    agent_id="asistente"
)
```

## Ejemplo: Memoria con LangGraph

```python
from langgraph.checkpoint import MemorySaver
from langgraph.graph import StateGraph
from typing import TypedDict, Annotated
from langgraph.graph.message import add_messages

class AgentState(TypedDict):
    messages: Annotated[list, add_messages]
    summary: str  # memoria comprimida
    user_preferences: dict

# Usar MemorySaver para persistencia
memory = MemorySaver()

graph = StateGraph(AgentState)

# Configurar resumen periódico de memoria
def summarize_memory(state: AgentState) -> AgentState:
    if len(state["messages"]) > 20:
        summary_prompt = (
            f"Resume la conversación hasta ahora. "
            f"Resumen anterior: {state.get('summary', '')}\n"
            f"Nuevos mensajes: {state['messages'][-10:]}"
        )
        new_summary = llm.invoke(summary_prompt)
        state["summary"] = new_summary
        # Mantener solo los últimos mensajes
        state["messages"] = state["messages"][-5:]
    return state

graph.add_node("summarize", summarize_memory)
# ... resto del grafo
graph.compile(checkpointer=memory)
```

## Niveles de memoria

| Nivel | Duración | Almacenamiento | Contenido | Ejemplo |
|---|---|---|---|---|
| Working Memory | Segundos | Contexto LLM | Estado actual | Variables, resultados parciales |
| Short-Term | Minutos | Message buffer | Historial reciente | Últimos 10 intercambios |
| Episodic | Sesiones | Vector DB | Experiencias | "La última vez que busqué X, encontré Y" |
| Semantic | Permanente | Vector DB + KB | Conocimiento | "El usuario prefiere respuestas concisas" |
| Long-Term | Permanente | Vector DB + SQL | Hechos acumulados | "Juan es programador Python" |

## Mejores prácticas

- **Ventana deslizante**: Mantener un buffer de los últimos N mensajes. Cuando se excede el límite, resumir los más antiguos y mantener los recientes.
- **Resúmenes periódicos**: Cada cierto número de intercambios, generar un resumen de la conversación y almacenarlo en LTM.
- **Recuperación selectiva**: No inyectar toda la LTM en el contexto; solo los recuerdos más relevantes para la consulta actual.
- **Priorización**: Ponderar recuerdos por recencia, frecuencia de acceso e importancia explícita (marcada por el agente o usuario).
- **Privacidad**: Almacenar memorias de forma segura, permitir al usuario ver/olvidar datos, cumplir con regulaciones (GDPR).
- **Expiración**: Implementar TTL (time-to-live) para recuerdos temporales y políticas de archive para memoria obsoleta.

## Relaciones con otros módulos

- `../MultiAgent/`: Memoria compartida entre agentes de un equipo.
- `../Planning/`: Memoria de planes anteriores y resultados para mejorar planificación.
- `../ToolUse/`: Memoria de herramientas usadas y resultados obtenidos.
- `../Evaluation/`: Evaluación de la efectividad de la memoria en el rendimiento del agente.
- `../../038-VectorDatabases/`: Vector databases como almacén de memoria a largo plazo.
- `../../035-RAG/`: Técnicas RAG aplicadas a recuperación de memoria.
- `../../034-LLM/`: Ventana de contexto del LLM como memoria a corto plazo.

## Recursos recomendados

- **Paper**: "Memory Augmented Large Language Models are Computationally Universal" (Giannou et al., 2023).
- **Paper**: "Reflexion: Language Agents with Verbal Reinforcement Learning" (Shinn et al., 2023).
- **Documentación**: Mem0 docs, Zep docs, LangGraph persistence docs.
- **Repositorio**: mem0ai/mem0, getzep/zep, langchain-ai/langgraph.
- **Guía**: "Building Memory for AI Agents" (Mem0 blog).
- **Video**: "Memory in AI Agents" (LangChain YouTube).
