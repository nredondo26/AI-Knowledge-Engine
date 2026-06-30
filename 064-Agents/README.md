# 064-Agents: Implementaciones de Agentes

## Descripción del dominio

Los agentes de IA son sistemas autónomos que perciben su entorno, razonan, toman decisiones y ejecutan acciones para lograr objetivos específicos. Este módulo cubre implementaciones concretas de agentes usando frameworks modernos como LangChain Agents, CrewAI, AutoGPT y OpenAI Assistants API, así como patrones arquitectónicos de agentes (ReAct, Plan-and-Execute, Reflection, Tool-Use, Multi-Agent). Se exploran desde agentes simples de una sola herramienta hasta sistemas multi-agente con orquestación compleja, memoria compartida y loops de retroalimentación.

## Conceptos clave

- **Agentes LangChain**: AgentExecutor, herramientas (Tools), toolkits, memory, callbacks — tipos de agentes (zero-shot-react-description, structured-chat-zero-shot, conversational-react-description, openai-functions, openai-tools)
- **Patrón ReAct (Reasoning + Acting)**: Ciclo de razonamiento-acción-observación — prompting para Chain-of-Thought + tool use — implementación en LangChain, Vercel AI SDK, MiniChain
- **CrewAI**: Framework multi-agente — roles, tareas, procesos (sequential, hierarchical, consensual) — agentes especializados con herramientas compartidas — delegación y colaboración entre agentes
- **AutoGPT**: Agente autónomo con objetivos a largo plazo — descomposición de tareas en subtareas — iteración con feedback — memoria vectorial persistente — web browsing y ejecución de código
- **OpenAI Assistants API**: Asistentes gestionados con instrucciones personalizadas — retrieval de conocimiento — code interpreter — functions/tools — threads y runs para conversación multi-turno
- **Patrones de agente**: Tool-use (uso de herramientas externas), Reflection (auto-evaluación de outputs), Plan-and-Execute (descomposición + ejecución), Multi-Agent (especialización y coordinación), Supervisor (agente que coordina otros agentes)
- **Memoria**: Memoria a corto plazo (conversación), memoria a largo plazo (vector store), memoria episódica (eventos pasados), memoria procedimental (habilidades aprendidas)
- **Seguridad en agentes**: Sandboxing de ejecución, limitación de herramientas, rate limiting, validación de salidas, human-in-the-loop, guardrails

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Frameworks de agentes | LangChain/LangGraph, CrewAI, AutoGPT, MetaGPT, Agno (phi), Semantic Kernel |
| Plataformas cloud | OpenAI Assistants API, Anthropic Claude Agent (tool use), Google Vertex AI Agent Builder, AWS Bedrock Agents |
| Multi-agente | CrewAI, AutoGen (Microsoft), MetaGPT, ChatDev, AgentVerse, LangGraph Supervisor |
| Browsing y scraping | Playwright, Selenium, Puppeteer, BeautifulSoup, Spacy |
| Ejecución de código | Sandbox Docker, Pyodide, WASM, E2B (dev sandbox), Restrict Python |
| Herramientas comunes | Brave Search API, Tavily Search, SerpAPI, Zapier NLA, SQL databases, REST APIs, file I/O |
| Observabilidad | LangSmith, LangFuse, Weights & Biases, Arize AI, AgentOps |

## Hoja de ruta

1. **Principiante**: Concepto de agente como programa autónomo — diferencia entre LLM y agente — creación de un agente simple con LangChain (1-2 herramientas) — OpenAI Assistants API: creación de assistant con instrucciones básicas — pattern ReAct explicado paso a paso
2. **Intermedio**: Agentes con múltiples herramientas — memory persistente (conversación + vector store) — funciones personalizadas como herramientas — agentes con Plan-and-Execute — fine-tuning de prompts para agentes — manejo de errores y reintentos
3. **Avanzado**: Sistemas multi-agente con CrewAI — orquestación jerárquica (LangGraph Supervisor) — agentes con reflexión y loops de mejora — caching de resultados de herramientas — streaming de outputs de agentes — logging y tracing con LangSmith
4. **Experto**: Agentes autónomos con planificación dinámica — agentes con aprendizaje por refuerzo (RLHF for tool use) — arquitecturas agentic (Model Context Protocol) — agentes distribuidos en múltiples servicios — adversarial testing y security hardening — fine-tuning de modelos base para tool use especializado

## Relaciones con otros módulos

- [037-AgenticAI](../037-AgenticAI/) — Fundamentos teóricos de agentes autónomos y sistemas multi-agente
- [036-MCP](../036-MCP/) — Model Context Protocol: estandarización de herramientas y contexto para agentes
- [034-LLM](../034-LLM/) — Modelos de lenguaje que impulsan el razonamiento de los agentes
- [035-RAG](../035-RAG/) — Agentes que usan RAG para recuperar información en tiempo real
- [062-Search](../062-Search/) — Agentes que utilizan motores de búsqueda como herramienta
- [065-Workflows](../065-Workflows/) — Orquestación de flujos de trabajo que combinan múltiples agentes
- [063-Examples](../063-Examples/) — Implementaciones prácticas de agentes por framework
- [066-Playbooks](../066-Playbooks/) — Procedimientos operativos para desplegar y mantener agentes

## Recursos recomendados

- **Papers**: "ReAct: Synergizing Reasoning and Acting in Language Models" (Yao et al., 2022); "Plan-and-Solve Prompting" (Wang et al., 2023); "Reflexion: Language Agents with Verbal Reinforcement Learning" (Shinn et al., 2023); "Toolformer: Language Models Can Teach Themselves to Use Tools" (Schick et al., 2023)
- **Documentación oficial**: LangChain Agents Documentation, CrewAI Docs, OpenAI Assistants API, AutoGPT Docs
- **Cursos**: DeepLearning.AI: LangChain for LLM Application Development, Multi AI Agent Systems (CrewAI), Building Agentic RAG (DeepLearning.AI)
- **Herramientas**: LangSmith (tracing), LangGraph (orquestación), AgentOps (monitoreo), Guardrails AI (validación)
