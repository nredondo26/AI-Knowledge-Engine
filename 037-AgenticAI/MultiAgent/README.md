# Sistemas Multi-Agente (MultiAgent)

## Descripción del dominio

Los sistemas multi-agente (MAS, Multi-Agent Systems) son arquitecturas donde múltiples agentes de IA autónomos interactúan para resolver tareas complejas que un solo agente no podría abordar eficientemente. Cada agente tiene un rol especializado, un conjunto de herramientas y una personalidad definida por su system prompt. Los agentes pueden colaborar (compartir información, delegar subtareas), competir (generar opciones y votar la mejor) o coordinar secuencialmente (un agente produce output que otro consume). Los patrones comunes incluyen: supervisor/worker (un agente orquesta a otros), debate (agentes discuten para llegar a consenso), pipeline (agentes en cadena), y equipo autónomo (agentes se organizan dinámicamente). Frameworks como CrewAI, AutoGen (Microsoft), LangGraph, y Semantic Kernel proporcionan infraestructura para definir roles, gestionar comunicación entre agentes, controlar flujos de conversación y manejar estado compartido.

## Conceptos clave

- **Rol (Role)**: Especialización del agente definida por system prompt. Ejemplos: Investigador, Escritor, Editor, Crítico, Programador, Tester, Analista.
- **Task (Tarea)**: Unidad de trabajo asignada a un agente. Tiene descripción, herramientas permitidas, contexto y criterios de éxito.
- **Proceso (Process)**: Flujo de ejecución del equipo multi-agente. Secuencial (agentes en cadena), jerárquico (supervisor delega a workers), autónomo (agentes deciden el flujo).
- **Comunicación entre Agentes**: Mecanismos de paso de mensajes. Puede ser directa (agente a agente), vía bus de mensajes, o mediante estado compartido.
- **Supervisor / Manager**: Agente que coordina, asigna tareas, evalúa resultados y decide el siguiente paso.
- **Debate / Discusión**: Múltiples agentes argumentan posiciones diferentes para llegar a una solución consensuada. Mejora calidad y reduce sesgos.
- **Delegación**: Un agente pasa una subtarea a otro agente más especializado. El supervisor decide qué delegar y a quién.
- **Estado Compartido (Shared State)**: Memoria o contexto accesible por todos los agentes. Puede ser una base de datos, un documento compartido o un objeto en memoria.
- **Votación (Voting)**: Mecanismo de consenso donde múltiples agentes votan la mejor respuesta o acción.
- **Tool Sharing**: Herramientas que pueden ser usadas por múltiples agentes. El supervisor puede controlar qué herramientas usa cada agente.
- **Agent Handoff**: Transferencia de control de un agente a otro. Incluye contexto de la conversación, estado actual y objetivos pendientes.

## Frameworks principales

- **CrewAI**: Framework Python para equipos de agentes con roles, tareas y procesos secuenciales/jerárquicos. Integración con LangChain, herramientas personalizadas.
- **AutoGen (Microsoft)**: Framework multi-agente con conversación entre agentes. Soporta GPT-4, Gemini, modelos locales. Patrones de conversación, tool use, human-in-the-loop.
- **LangGraph**: Framework para grafos de agentes con estados. Soporta multi-agente mediante nodos de agentes y routing condicional entre ellos.
- **Semantic Kernel (Microsoft)**: SDK con soporte para multi-agente via AgentChat, agentes con plugins, y patrones de grupo de chat.
- **OpenAI Swarm (experimental)**: Framework ligero para multi-agente con handoffs entre agentes. Patrón de orchestrator/worker.
- **Camel**: Framework para investigación multi-agente. Role-playing entre agentes, comunicación estructurada, memoria compartida.

## Ejemplo: Equipo multi-agente con CrewAI

```python
from crewai import Agent, Task, Crew, Process

investigador = Agent(
    role="Investigador Senior",
    goal="Encontrar información relevante y actualizada",
    backstory="Experto en búsqueda y análisis de información técnica",
    tools=[search_tool, web_scraper],
    verbose=True
)

escritor = Agent(
    role="Escritor Técnico",
    goal="Redactar informes claros y bien estructurados",
    backstory="Especialista en comunicación técnica y documentación",
    verbose=True
)

revisor = Agent(
    role="Editor de Calidad",
    goal="Revisar y mejorar la calidad del contenido",
    backstory="Editor experto con ojo crítico para detalles",
    verbose=True
)

tarea_investigacion = Task(
    description="Investiga las últimas tendencias en IA para 2025",
    agent=investigador,
    expected_output="Lista de 10 tendencias con fuentes"
)

tarea_redaccion = Task(
    description="Redacta un informe basado en la investigación",
    agent=escritor,
    expected_output="Informe de 500 palabras bien estructurado"
)

tarea_revision = Task(
    description="Revisa y mejora el informe final",
    agent=revisor,
    expected_output="Informe final revisado con sugerencias"
)

equipo = Crew(
    agents=[investigador, escritor, revisor],
    tasks=[tarea_investigacion, tarea_redaccion, tarea_revision],
    process=Process.sequential,
    verbose=True
)

resultado = equipo.kickoff()
print(resultado)
```

## Patrones de interacción

- **Secuencial**: Agente 1 → Agente 2 → Agente 3. Cada agente recibe el output del anterior. Simple pero rígido.
- **Jerárquico (Supervisor/Worker)**: Un supervisor asigna tareas a workers, evalúa resultados, decide iteraciones o finalización.
- **Debate**: Dos o más agentes generan respuestas, discuten, y llegan a un consenso. Útil para reducción de sesgos.
- **Pipeline con Router**: Un router decide qué agente debe manejar la siguiente tarea basado en el contenido o estado.
- **Equipo Autónomo**: Agentes se auto-organizan, deciden roles dinámicamente y negocian la asignación de tareas.
- **Votación**: Múltiples agentes generan soluciones independientes, luego votan la mejor. Combinable con debate.

## Relaciones con otros módulos

- `../Planning/`: Planificación en multi-agente (asignación de subtareas, orden de ejecución).
- `../Memory/`: Memoria compartida entre agentes para mantener contexto del equipo.
- `../ToolUse/`: Herramientas que los agentes del equipo pueden usar.
- `../Evaluation/`: Evaluación del rendimiento del equipo multi-agente.
- `../../036-MCP/`: MCP como protocolo para exponer herramientas a agentes del equipo.
- `../../035-RAG/`: Agentes especializados en recuperación de información dentro del equipo.
- `../../039-PromptEngineering/`: System prompts para definir roles y personalidades de agentes.

## Recursos recomendados

- **Paper**: "AutoGen: Enabling Next-Gen LLM Applications via Multi-Agent Conversation" (Microsoft, 2023).
- **Paper**: "Camel: Communicative Agents for 'Mind' Exploration of Large Scale Language Model Society" (Li et al., 2023).
- **Documentación**: CrewAI Docs, AutoGen Docs, LangGraph Multi-Agent docs.
- **Curso**: "Multi AI Agent Systems with CrewAI" (DeepLearning.AI).
- **Repositorio**: crewAIInc/crewAI, microsoft/autogen, langchain-ai/langgraph.
- **Video**: "Multi-Agent Systems Explained" (AI Explained).
