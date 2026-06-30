# 036-MCP: Model Context Protocol

## Descripción ampliada del dominio

Model Context Protocol (MCP) es un protocolo abierto estandarizado que permite a modelos de lenguaje (LLMs) conectarse de manera segura y estructurada con herramientas externas, fuentes de datos y aplicaciones. Desarrollado por Anthropic y anunciado en noviembre de 2024, MCP define una arquitectura cliente-servidor donde el LLM actúa como cliente MCP y las herramientas/datos como servidores MCP. El protocolo incluye: MCP Client (LLM host), MCP Server (tools, resources, prompts), MCP Transport (stdio, SSE, streaming), y MCP Protocol (JSON-RPC 2.0). MCP resuelve el problema de fragmentación de integraciones LLM: antes de MCP, cada framework (LangChain, LlamaIndex, Semantic Kernel) definía sus propios protocolos de herramientas. Con MCP, cualquier servidor MCP compatible funciona con cualquier cliente MCP. Los servidores MCP proveen: Tools (acciones que el LLM puede ejecutar, con schema de entrada/salida), Resources (datos que el LLM puede leer, como archivos, DB queries, APIs), y Prompts (templates de prompt reutilizables). MCP ha sido adoptado por las principales plataformas: Claude Desktop, Cursor IDE, VS Code, Sourcegraph Cody, y frameworks (LangChain, LlamaIndex, Continue.dev, Genkit).

## Tabla de conceptos clave

| Concepto | Descripción | Implementación |
|----------|-------------|---------------|
| MCP Client | Aplicación/host que se conecta a servidores MCP (Claude Desktop, editor, app) | Claude Desktop, Cursor, VS Code, Continue.dev |
| MCP Server | Servicio que expone tools, resources y prompts a clientes MCP | anthropic-quickstarts, mcp-servers, custom servers |
| Tool | Función ejecutable que el LLM puede llamar (con esquema) | Calculator, web search, DB query, file read/write, API call |
| Resource | Dato que el LLM puede leer (archivo, query result, API response) | File contents, database records, URL content |
| Prompt | Template de prompt reutilizable con placeholders | Expert persona, task description, role definition |
| Transport | Canales de comunicación entre cliente y servidor | stdio (subprocess), SSE (Server-Sent Events), HTTP streaming |
| Protocol | MCP protocolo basado en JSON-RPC 2.0 | initialize, tools/list, tools/call, resources/list, resources/read |
| Tool Schema | Definición de entrada/salida de herramienta (JSON Schema) | Input: {type: object, properties: {...}} Output: {content: [...]} |
| MCP Hub | Repositorio de servidores MCP | npm (mcp-server-*), PyPI (mcp-server-*), GitHub |

## Tecnologías principales

| Categoría | Herramientas/Plataformas | Propósito |
|-----------|-------------------------|-----------|
| Clients MCP | Claude Desktop, Cursor IDE, VS Code (Cody, Continue.dev), LangChain, LlamaIndex | Hosts que ejecutan LLMs y se conectan a servers MCP |
| SDKs MCP | Python SDK (mcp), TypeScript SDK (@modelcontextprotocol/sdk), Go, Java, Rust | Desarrollo de servidores MCP |
| Servidores Oficiales | Filesystem (acceso a archivos local), SQLite, PostgreSQL, GitHub, Git, Puppeteer | Servidores de referencia de Anthropic |
| Servidores Comunitarios | Docker, Kubernetes, AWS, GCP, Stripe, Notion, Linear, Jira, Slack, Google Maps | Cientos de servidores open source |
| MCP en Frameworks | LangChain (LangGraph MCP Agent), LlamaIndex (MCP integration), Continue.dev | Integración en frameworks existentes |
| MCP Hosting | Cloudflare Workers, AWS Lambda, Railway, Render, Docker | Hosting de servidores MCP |

## Hoja de ruta detallada

1. **Principiante (0-2 semanas)**: Conceptos MCP: qué es Client, Server, Tool, Resource, Prompt. Arquitectura: LLM ↔ MCP Client ↔ MCP Server (stdin/stdout o HTTP). Instalación de Claude Desktop. Configurar servidores MCP básicos: filesystem (acceso a directorio local), SQLite (query base de datos local). Ejemplos: Claude Desktop + Filesystem Server (leer archivos, buscar, contar líneas). Probar Tools: web search, calculator, fetch URL. Probar Resources: leer archivo, query SQL. MCP JSON-RPC: entender mensajes initialize, tools/list, tools/call, resources/list, resources/read. Crear un servidor MCP mínimo con Python SDK: @mcp.tool() decorator, tool with JSON Schema input.
   - Práctica: Instalar Claude Desktop + examples. Configurar servidor filesystem + SQLite. Crear un servidor MCP personalizado simple (calculator tool).
   - Lectura: MCP specification (modelcontextprotocol.io/specification), examples/quickstart (github.com/modelcontextprotocol).

2. **Intermedio (2-4 semanas)**: Desarrollo de servidores MCP: Python SDK (FastMCP, MCP Server), TypeScript SDK (Server, Transport, Tool). Recursos y Prompts: resources (file://, db://, custom URI schemes), prompts (reusable templates con placeholders y argumentos). Transport options: stdio (subprocess, local), SSE (server-sent events, remoto), streaming (HTTP). Tool design: input schema (required/optional parameters, types), output format (text, image, resource, embedded resource), error handling (MCPError, ToolError). Dynamic tools: tools que se registran dinámicamente según estado. Tool calling: parallel tool calls, nested tool calls, tool selection. Authentication: API keys via args, environment variables. Resource templates: pattern-based URIs (file://{path}, db://{query}). Prompt templates: role, expert capabilities, task-specific. Testing: MCP Inspector (web UI para probar servidores MCP), writing tests with mcp SDK.
   - Práctica: Servidor MCP con tools + resources + prompts. Servidor MCP SSE para integración remota. Integración con Cursor/VSCode.
   - Lectura: MCP SDK docs (modelcontextprotocol.io/sdk), MCP Inspector docs, GitHub MCP servers examples.

3. **Avanzado (4-8 semanas)**: Complex tools: streaming tools (result streaming), progress reporting, long-running tools (async, background). Tool chaining: composición de tools (tool que llama a otra tool), stateful tools (mantener estado entre llamadas). Authentication & Authorization: bearer tokens, OAuth, session management, API key rotation. Error recovery: retry logic, timeout handling, idempotent tools, circuit breaker. Resource subscriptions: server → client notifications when resources change (real-time updates). Transport optimization: connection pooling, request batching, caching. Multi-server orchestrator: un cliente MCP que orquesta múltiples servidores, routing requests según tipo. Security: input validation (JSON Schema), rate limiting, permission scoping, content filtering, audit logging. Production deployment: Docker container, Cloudflare Workers, AWS Lambda, Railway. MCP en LangChain/LlamaIndex: LangGraph MCP Agent (MCPAgent), LlamaIndex MCP integration.
   - Práctica: Servidor MCP con autenticación + rate limiting + audit logging. Multi-server orchestration (routing entre servidores según query). Deploy server en Railway/Cloudflare Workers.
   - Lectura: MCP security guidelines, LangChain MCP docs, LlamaIndex MCP docs.

4. **Experto (2+ meses, emergente)**: MCP standards contribution: proponer nuevas características (resource templates, streaming, batch operations), MCP extensions for specific domains (MCP for databases, MCP for observability). MCP en herramientas de desarrollo: VS Code extensions que exponen MCP servers (editor actions, code analysis, git operations), CI/CD pipelines con MCP. MCP para agentes: MCP como protocolo unificado de tools para agentes multi-modelo, MCP Agent (LangGraph). MCP for enterprise: enterprise SSO, audit logging (every tool call logged), compliance, SLA monitoring, cost tracking per tool. MCP bridge: conectar LLMs locales (Ollama) con MCP servers. MCP in edge: MCP servers en Cloudflare Workers (edge compute). MCP generative UI: tools que generan UI components, interactive forms. MCP ecosystem: package managers (mcp registry), marketplaces, SDK generators, monitoring (OpenTelemetry + MCP). MCP for RAG: MCP servers como retrievers (vector DB query, hybrid search, reranking), MCP tools for document processing.
   - Práctica: Contribución a MCP specification o SDK. MCP server marketplace/packaging. MCP-powered agent framework.
   - Lectura: Anthropic MCP announcements, MCP GitHub issues/discussions, MCP community servers (awesome-mcp-servers).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [034-LLM](../034-LLM/) | LLM como cliente MCP principal |
| [035-RAG](../035-RAG/) | MCP servers pueden exponer retrievers de RAG |
| [037-AgenticAI](../037-AgenticAI/) | MCP proporciona tools para agentes |
| [038-VectorDatabases](../038-VectorDatabases/) | MCP server para query a vector databases |
| [039-PromptEngineering](../039-PromptEngineering/) | MCP prompts como templates reutilizables |
| [041-CodeGeneration](../041-CodeGeneration/) | MCP tools para code generation y code review |
| [042-Documentation](../042-Documentation/) | MCP resources para documentación técnica |

## Recursos recomendados

- **Documentación oficial**: modelcontextprotocol.io (specification, SDK, quickstart), github.com/modelcontextprotocol (spec + SDK + examples).
- **Servidores de referencia**: anthropic-quickstarts (modelcontextprotocol/servers GitHub), awesome-mcp-servers (GitHub community collection).
- **SDKs**: Python (pip install mcp), TypeScript (npm install @modelcontextprotocol/sdk), Go, Java, Kotlin, Rust.
- **Herramientas**: MCP Inspector (modelcontextprotocol/inspector), MCP CLI tools.
- **Cursos/Guías**: Anthropic MCP blog posts, YouTube MCP tutorials, MCP Cookbook (community).
- **Comunidad**: MCP Discord (Anthropic), GitHub discussions, Twitter/X #MCPProtocol.

## Notas adicionales

MCP es un protocolo en desarrollo temprano (anunciado noviembre 2024). La adopción está creciendo rápidamente: Claude Desktop, Cursor, VS Code (Cody, Continue), LangChain, LlamaIndex. MCP es similar a LSP (Language Server Protocol) pero para LLMs. El protocolo es abierto y agnóstico a proveedor. La contribución más valiosa actualmente es construir servidores MCP para herramientas populares y compartirlos open source. Para desarrolladores, el SDK para Python/Typescript permite crear servidores en minutos. El futuro: MCP podría convertirse en el estándar universal para integración LLM, como LSP lo es para editores de código.
