# Agentes de IA (037-AgenticAI)

## Descripción del dominio

Los Agentes de IA son sistemas autónomos que perciben su entorno, razonan, planifican y ejecutan acciones para alcanzar objetivos complejos. A diferencia de los LLMs tradicionales que responden pasivamente a prompts, los agentes toman iniciativa, gestionan su propio flujo de trabajo, utilizan herramientas externas, mantienen memoria de interacciones anteriores y pueden operar en ciclos iterativos de observación → pensamiento → acción. La arquitectura típica de un agente incluye: un modelo (LLM) como cerebro, herramientas (APIs, funciones, bases de datos), memoria (corto y largo plazo), planificación (Chain-of-Thought, ReAct, Plan-and-Execute) y un bucle de ejecución. Los sistemas multi-agente (MAS) coordinan múltiples agentes especializados que colaboran, compiten o se delegan tareas. Frameworks como LangGraph, CrewAI, AutoGen y Semantic Kernel facilitan la construcción de estos sistemas.

## Conceptos clave

- **Tool Use (Function Calling)**: Capacidad del LLM para invocar funciones externas definidas con esquemas JSON. El modelo decide cuándo y cómo llamar herramientas.
- **Planning**: El agente descompone objetivos en pasos. Estrategias: ReAct (Reason + Act), Plan-and-Execute, Tree-of-Thoughts, Reflexión.
- **Memoria**: Memoria a corto plazo (contexto de ventana del LLM), memoria a largo plazo (embeddings en vector database), memoria episódica (historial de interacciones comprimido).
- **Bucle Agente (Agent Loop)**: Ciclo continuo: observar estado → pensar/próximo paso → ejecutar acción → procesar resultado → repetir hasta completar objetivo.
- **Multi-Agent Systems (MAS)**: Múltiples agentes con roles especializados. Supervisor/worker, debate, colaboración, competencia.
- **Function Calling**: API nativa de LLMs (OpenAI tool_calls, Anthropic tool_use) para invocar herramientas estructuradas.
- **System Prompt**: Instrucción de sistema que define personalidad, capacidades, restricciones y estilo del agente.
- **Grounding**: Asegurar que las acciones del agente están basadas en hechos verificables y fuentes confiables.
- **Human-in-the-Loop**: Intervención humana en puntos críticos del flujo del agente (aprobación de acciones, corrección de errores).
- **Orquestación**: Gestión de flujo de llamadas al LLM, ejecución de herramientas y paso de estado entre pasos.
- **State Management**: Mantenimiento del estado del agente a través de múltiples pasos, incluyendo contexto, resultados intermedios y metadatos.

## Tecnologías principales

- **LangChain / LangGraph**: Framework líder. LangChain para cadenas lineales; LangGraph para grafos cíclicos (agentes con loops). Soporte nativo para tool calling, memoria, multi-agente.
- **CrewAI**: Framework para sistemas multi-agente. Roles, tareas, procesos secuenciales o jerárquicos.
- **AutoGen (Microsoft)**: Framework multi-agente con conversación entre agentes. Soporta GPT-4, Gemini, modelos locales.
- **Semantic Kernel (Microsoft)**: SDK para integrar LLMs con plugins y orquestación. C#, Python, Java.
- **OpenAI Assistants API**: API gestionada con threads, runs, tools (code interpreter, file search, functions).
- **Anthropic Tool Use**: API nativa de Claude para function calling y tool use.
- **Google Vertex AI Agent Builder**: Plataforma gestionada para construir agentes con Gemini.
- **pydantic-ai**: Framework Python para agentes con tipado fuerte usando Pydantic.
- **Mem0 / Zep**: Gestión de memoria persistente para agentes.
- **Guardrails / NVIDIA NeMo Guardrails**: Seguridad, validación de inputs/outputs, políticas de comportamiento.

## Hoja de ruta

**Principiante:**
1. Concepto de agente: autonomía, percepción, acción, bucle.
2. Tool use básico: definir funciones como herramientas, invocarlas desde un LLM (OpenAI tool_calls).
3. Construir un agente simple con Python: LLM + 1-2 herramientas + bucle manual.
4. ReAct pattern: implementar el ciclo Reason → Act → Observe manualmente.
5. Sistema de prompts: diseñar system prompt que defina personalidad, tono, reglas del agente.

**Intermedio:**
1. Memoria: implementar memoria de corto plazo (message history) y largo plazo (vector store).
2. Frameworks: LangGraph para grafos de agentes con estados, routing condicional, loops.
3. Multi-herramientas: integración de múltiples APIs (navegador, archivos, bases de datos, cálculos).
4. Manejo de errores: retry, fallback, validación de outputs de herramientas.
5. Evaluación de agentes: métricas de éxito, eficiencia, tasa de error, cost de tokens.

**Avanzado:**
1. Multi-agente: CrewAI o AutoGen para equipos de agentes especializados (investigador, escritor, editor).
2. Planificación avanzada: Tree-of-Thought, Plan-and-Execute con replanificación dinámica.
3. Agentes especializados: code agents (SWE-agent, Devin), research agents, data agents.
4. Fine-tuning para agentes: entrenar modelos para mejor tool use y planificación.
5. Producción: monitoreo, observabilidad (LangSmith, LangFuse), safety, escalabilidad, cost optimization.

## Relaciones con otros módulos

- `../034-LLM/`: LLMs como cerebro de los agentes, tool calling nativo.
- `../036-MCP/`: MCP como protocolo estándar para exponer herramientas a agentes.
- `../038-VectorDatabases/`: Memoria a largo plazo basada en embeddings para agentes.
- `../035-RAG/`: Recuperación de conocimiento como herramienta del agente.
- `../039-PromptEngineering/`: Diseño de prompts para comportamiento de agentes.
- `../065-Workflows/`: Orquestación de flujos de agentes en pipelines complejos.
- `../064-Agents/`: Implementaciones de agentes específicos (SWE-agent, etc.).
- `../040-Reasoning/`: Patrones de razonamiento para planificación (CoT, ToT).

## Recursos recomendados

- **Paper**: "ReAct: Synergizing Reasoning and Acting in Language Models" (Yao et al., 2022) — Fundacional.
- **Paper**: "AutoGen: Enabling Next-Gen LLM Applications via Multi-Agent Conversation" (Microsoft, 2023).
- **Paper**: "Toolformer: Language Models Can Teach Themselves to Use Tools" (Schick et al., 2023).
- **Documentación**: LangGraph Docs, CrewAI Docs, AutoGen Docs.
- **Curso**: "Building Agents with LangGraph" (DeepLearning.AI + LangChain).
- **Repositorio**: langchain-ai/langgraph, microsoft/autogen, crewAIInc/crewAI.
- **Video**: "AI Agents: State of the Art" (AI Explained).
