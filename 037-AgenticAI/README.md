# 037-AgenticAI: Inteligencia Artificial Agéntica

## Descripción ampliada del dominio

Agentic AI se refiere a sistemas de IA capaces de actuar de manera autónoma para lograr objetivos complejos: percibir el entorno, razonar, planificar, tomar decisiones, ejecutar acciones (usando herramientas), aprender de la retroalimentación y adaptar su comportamiento. Los agentes de IA modernos están impulsados por LLMs como "cerebro", combinando razonamiento, planificación, memoria y capacidad de usar herramientas (tool calling). La evolución: agentes reactivos (reglas, 1980s) → agentes BDI (Beliefs-Desires-Intentions, 1990s) → agentes basados en RL (Deep RL, 2010s) → agentes LLM (2023+, ReAct, AutoGPT, BabyAGI) → multi-agentes (2024, AutoGen, CrewAI, LangGraph) → agentes autónomos con razonamiento profundo (2025, model-based agents, self-improving). Los agentes LLM pueden ser: simples (single-step tool use), con planificación (ReAct, CoT, Tree-of-Thought), reflexivos (AutoGPT, reflect on past actions), multi-agente (especialización, debate, colaboración) y agentes de frontera (computer use, web navigation). Las tendencias actuales son: agentes que usan el computador (Claude Computer Use), agentes que navegan la web, agentes de código (Devin, Cursor Agent), agentes multi-modal, y frameworks de orquestación (LangGraph, CrewAI, AutoGen, Semantic Kernel).

## Tabla de conceptos clave

| Concepto | Descripción | Frameworks/Implementaciones |
|----------|-------------|---------------------------|
| Agente LLM | Sistema autónomo con LLM como "cerebro" | LangChain Agent, LlamaIndex Agent, Semantic Kernel |
| ReAct | Reasoning + Acting: pensar antes de actuar y actuar basado en pensamiento | ReAct (Yao et al., 2022), LangChain ReAct Agent |
| Tool Calling | LLM selecciona y llama herramientas externas | OpenAI function calling, MCP, tool schema |
| Planificación | Creación de plan multi-paso para lograr objetivo | Plan-and-Execute, Tree-of-Thought, CoT-SC, re-planning |
| Memoria | Almacenamiento de experiencia pasada | Short-term (conversation), Long-term (vector DB, SQL), Episodic |
| Multi-Agente | Coordinación de múltiples agentes especializados | AutoGen (Microsoft), CrewAI, LangGraph, Agora |
| Reflexión | El agente evalúa sus propias acciones y se corrige | Reflexion (Shinn, 2023), Self-Refine, Chain-of-Verification |
| Computer Use | Agente que controla la interfaz de computadora (mouse, teclado) | Claude Computer Use, OS-Copilot, UFO, Microsoft Omniparser |
| Agente de Código | Agente especializado en programación | Devin, Cursor Agent, SWE-agent, CodeAct |
| Observability | Monitoreo de acciones, decisiones y rendimiento del agente | LangSmith, LangFuse, Weights & Biases, Lunary |
| Seguridad | Prevención de acciones dañinas, sandboxing, permisos | MCP (permission scoping), human-in-the-loop, rate limiting |
| Evaluación | Métricas para agentes: task completion, efficiency, safety | SWE-Bench, GAIA, AgentBench, WebArena, HumanEval |

## Tecnologías principales

| Framework | Propósito | Lenguaje | Orquestación | Multi-Agente | Memoria | Observabilidad |
|-----------|-----------|----------|-------------|-------------|---------|---------------|
| LangGraph | Orquestación de agentes (grafos de estado) | Python, JS | Grafo cíclico/estado | Sí (subgraphs) | Sí (persistencia) | LangSmith |
| AutoGen (Microsoft) | Multi-agente conversacional | Python | Chat-based agent groups | Sí (nativo) | Sí | Integración |
| CrewAI | Multi-agente con roles y tareas | Python | Jerárquico, secuencial | Sí (nativo) | Sí (memoria) | CrewAI + LangFuse |
| Semantic Kernel | Agentes empresariales (.NET/Python) | C#, Python | Planners (sequential, stepwise) | Sí | Sí (memoria semántica) | Azure Monitor |
| OpenAI Agents SDK | Agentes con OpenAI API | Python | Agent orchestration loop | Sí (handoffs) | Sí (contexto) | OpenAI Dashboard |
| Agno (ex Phidata) | Agentes multi-modal | Python | Agent + tools + knowledge | Sí | Sí (vector, DB) | Agno monitor |
| LangChain | Framework base para agentes | Python, JS | AgentExecutor, Agent | Sí | Sí | LangSmith |
| LlamaIndex | Agentes + RAG | Python | AgentRunner, WorkerAgent | Sí | Sí | Arize, LangFuse |
| Haystack | NLP pipelines, agente simple | Python | Pipeline (con Agent) | No (single) | No | Haystack traces |

## Hoja de ruta detallada

1. **Principiante (0-1 mes)**: Conceptos de agente: qué es un agente LLM, diferencia entre LLM + prompt y agente autónomo. ReAct pattern: Thought → Action (tool call) → Observation → ... → Final Answer. Tool calling: definition of tools (JSON Schema), LLM decides which tool to call based on the conversation. OpenAI function calling: functions definition, tool_choice (auto, any, specific). LangChain Agent: AgentExecutor, types (OpenAI Tools, ReAct, Self-Ask). Simple tools: calculator, search (DuckDuckGo), fetch URL, current time. Agent vs Chain: agent decide qué hacer, chain sigue pipeline fijo. Human-in-the-loop: ask for confirmation before executing actions.
   - Práctica: LangChain ReAct agent with web search + calculator. OpenAI assistant with function calling.
   - Lectura: "ReAct: Synergizing Reasoning and Acting in Language Models" (Yao et al.), LangChain agent docs, OpenAI assistants.

2. **Intermedio (1-3 meses)**: Multi-step agents: Plan-and-Execute, task decomposition (LLM plan → execute → verify → summarize). LangGraph: StateGraph (state, nodes, edges), conditional edges, tool calling node, memory (checkpointing, persistence). Memoria: short-term (conversation history), long-term (vector store, SQLite), entity memory (extract entities and store). Reflexión: agent self-reflect after each step or after completion, correct mistakes, improve strategy. Custom tools: authentication, error handling, complex inputs/outputs, streaming outputs, progress reporting. Agent security: tool permissions (read only, write allowed), input validation, confirm steps before execution, sandboxing (Docker, subprocess with limited permissions). Observability: tracking agent steps (thought, action, observation), token usage per step, duration, decisions. Testing agents: task completion tests, edge cases (ambiguous instructions, tool failure, timeout), conversation scenarios.
   - Proyecto: LangGraph agent for task automation (research → write summary → save to file). Tool-using agent with memory + reflection.
   - Certificación: DeepLearning.AI "Building Agentic RAG with LlamaIndex", "AI Agents in LangGraph".
   - Lectura: LangGraph docs, "Reflexion" (Shinn, 2023), "Plan-and-Solve" (Wang, 2023).

3. **Avanzado (3-6 meses)**: Multi-agent systems: specialized agents (planner, executor, validator, researcher, coder), agent communication (tools, messages, shared state), supervisor agent (orchestrator), agent handoff. CrewAI: agents with roles (goal, backstory, tools), tasks (description, expected output, agent), process (sequential, hierarchical). AutoGen: agent chat, group chat, agent roles, termination conditions, agent function calling for each other. LangGraph multi-agent: Agent Supervisor (LLM router), subgraphs for each agent, parallel agent execution. Agent evaluation: benchmarks (SWE-Bench for code agents, GAIA for general agents, AgentBench, WebArena), custom eval (task completion rate, steps per task, success rate, tool call accuracy). Code agents: SWE-agent (Linux commands + file editing), Devin approach (planning + coding + testing + debugging), Cursor Agent (edit files, run commands). Computer Use: Claude Computer Use API (click, type, scroll, screenshot), OS interaction frameworks. Constrained agents: structured outputs (JSON, Pydantic), guardrails (output validation, tool call validation, content filtering). Production deployment: state persistence (Redis, Postgres), scaling (multi-instance), rate limiting, logging, monitoring, cost tracking.
   - Proyecto: Multi-agent system (researcher + writer + reviewer) for report generation. Code agent for automated PR creation. Computer Use agent for web task automation.
   - Lectura: AutoGen docs, CrewAI docs, "SWE-agent" (Yang, 2024), "Computer Use" (Claude docs), GAIA benchmark paper.

4. **Experto (6+ meses)**: Advanced agent architectures: model-based agents (world model, planning, execution, learning), hierarchical agents (sub-goals, sub-agents, re-planning), agentic workflows (generative agents loop). Long-running agents: persistent state across sessions, autonomous operation with supervision, batch processing agents. Agent safety research: alignment of agent goals, corrigibility (can be corrected by humans), interpretable decision making, sandbox escape prevention, tool misuse detection. Self-improving agents: agents that learn from feedback (RLHF for agent), improve tool use strategies, adapt to new tasks. Foundation models for agents: models fine-tuned for agentic tasks (function calling, computer use, webshop), multi-modal agents (vision + tools + code). Emergent agent capabilities: tool innovation (agent creates new tools), meta-cognition (thinking about own thinking), theory of mind (predicting other agent's behavior). Agent MCP integration: MCP servers como tools, MCP prompts como agent behavior templates, MCP resources como conocimiento. Agent orchestration frameworks del futuro: SWE-agent-patched, OpenHands, Devika, ChatDev.
   - Proyecto: Long-running agent for continuous improvement tasks. Multi-agent system for software development (plan → code → test → pr). Safety evaluation framework for autonomous agents.
   - Lectura: "Generative Agents" (Park, 2023), "Voyager" (Wang, 2023), "Sparrow" (Glaese, 2022), "WebGPT" (Nakano, 2021), Alignment research papers.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [031-AI](../031-AI/) | Fundamentos de IA para agentes autónomos |
| [034-LLM](../034-LLM/) | LLM como cerebro del agente, tool calling, reasoning |
| [035-RAG](../035-RAG/) | RAG como fuente de conocimiento para agentes |
| [036-MCP](../036-MCP/) | MCP como protocolo de herramientas para agentes |
| [038-VectorDatabases](../038-VectorDatabases/) | Memoria a largo plazo en bases vectoriales |
| [039-PromptEngineering](../039-PromptEngineering/) | Prompting avanzado para comportamiento del agente |
| [040-Reasoning](../040-Reasoning/) | Razonamiento multi-paso para planificación de agentes |
| [041-CodeGeneration](../041-CodeGeneration/) | Agentes de código para programación autónoma |

## Recursos recomendados

- **Papers**: "ReAct" (Yao), "Reflexion" (Shinn), "Generative Agents" (Park), "SWE-agent" (Yang), "Plan-and-Solve" (Wang), "Tree-of-Thoughts" (Yao), "AutoGen" (Wu), "Computer Use" (Anthropic).
- **Frameworks**: LangGraph (langchain-ai.github.io/langgraph), AutoGen (microsoft.github.io/autogen), CrewAI (docs.crewai.com), Semantic Kernel (learn.microsoft.com/semantic-kernel).
- **Cursos**: DeepLearning.AI "AI Agents in LangGraph" (Andrew Ng), "Multi AI Agent Systems" (CrewAI), "Building Agentic RAG with LlamaIndex".
- **Evaluación**: SWE-Bench (swebench.com), GAIA (huggingface.co/gaia-benchmark), AgentBench (github.com/THUDM/AgentBench).
- **Comunidad**: LangChain Discord, AutoGen GitHub discussions, Anthropic Cookbook, Awesome LLM Agents (GitHub).

## Notas adicionales

Los agentes LLM son el desarrollo más transformador de 2024-25, permitiendo que la IA pase de "conversación" a "acción". ReAct (Think → Act → Observe) es el patrón fundamental de todos los agentes modernos. LangGraph es el framework de orquestación más flexible. La seguridad del agente es el desafío crítico: un agente autónomo con herramientas puede causar daño real. Frameworks: LangGraph (más flexible, estado explícito), CrewAI (más simple, roles), AutoGen (multi-agente conversacional). La evaluación de agentes es difícil — un agente puede tener éxito por diferentes caminos. Computer Use y Code agents son las capacidades más impactantes. El futuro: agentes que aprenden, mejoran y colaboran entre sí.
