# Model Context Protocol (036-MCP)

## Descripción del dominio

Model Context Protocol (MCP) es un protocolo abierto estandarizado desarrollado por Anthropic que permite a los LLMs (Large Language Models) interactuar con herramientas, recursos y servicios externos de manera segura y estructurada. MCP define una arquitectura cliente-servidor donde los hosts (aplicaciones como Claude Desktop, IDEs) se conectan a servidores MCP que exponen herramientas (funciones ejecutables), recursos (datos consultables) y prompts (plantillas de instrucciones). El protocolo utiliza JSON-RPC 2.0 como base de comunicación, soportando transporte por stdio (procesos locales) y SSE (Server-Sent Events para conexiones remotas). MCP resuelve el problema de conectar LLMs con datos y sistemas reales, proporcionando un estándar interoperable similar a cómo USB estandarizó la conexión de periféricos.

## Conceptos clave

- **Host**: Aplicación que inicia la conexión MCP (Claude Desktop, IDE, herramienta CLI). Es el cliente del protocolo.
- **Client**: Cliente MCP que establece una conexión con un servidor. El host puede gestionar múltiples clientes.
- **Server**: Servidor MCP que expone capacidades. Puede ser local (stdio) o remoto (SSE).
- **Tools**: Funciones invocables por el LLM. Tienen nombre, descripción, esquema de entrada (JSON Schema) y ejecutan acciones (leer BD, llamar API, ejecutar código).
- **Resources**: Datos expuestos por el servidor que el LLM puede leer. Identificados por URI. Pueden ser archivos, documentos, resultados de queries.
- **Resource Templates**: Patrones URI dinámicos para recursos parametrizables (ej. `file://{path}`).
- **Prompts**: Plantillas de instrucciones predefinidas que el servidor puede proporcionar al host. Incluyen mensajes y argumentos.
- **JSON-RPC 2.0**: Protocolo de transporte subyacente. Mensajes request/response/notification con identificadores.
- **Capabilities**: Habilidades que un servidor declara al conectarse: tools, resources, prompts.
- **Sampling**: Capacidad opcional del servidor para solicitar al LLM generaciones adicionales, permitiendo servidores que actúan como agentes.
- **Roots**: Directorios o rutas que el host comparte con el servidor como contexto accesible.
- **Notifications**: Mensajes asíncronos para cambios de estado (recursos actualizados, cancelaciones).
- **Progress**: Mecanismo para reportar progreso de operaciones largas mediante tokens de progreso.

## Tecnologías principales

- **SDKs Oficiales**: Python SDK (anthropic/mcp), TypeScript SDK (modelcontextprotocol/typescript-sdk), Java SDK (modelcontextprotocol/java-sdk).
- **Servidores de Referencia**: filesystem, github, git, fetch, puppeteer, sqlite, brave-search, google-maps, docker, redis.
- **Claude Desktop**: Host principal de Anthropic con soporte nativo MCP. Configuración via `claude_desktop_config.json`.
- **MCP Inspector**: Herramienta de depuración y testing para servidores MCP (interfaz web).
- **VSCode MCP Extension**: Integración con VS Code para usar MCP servers en el editor.
- **Continue.dev**: IDE open source que integra MCP servers para asistentes de código.
- **Cline/Claude Dev**: Extensiones de VS Code que soportan MCP servers para navegación, archivos y más.
- **Ollama + MCP**: Uso de modelos locales con servidores MCP mediante adaptadores.
- **FastMCP**: Framework simplificado de Python para construir servidores MCP (pip install fastmcp).

## Hoja de ruta

**Principiante:**
1. Entender qué es MCP y por qué estandariza la interacción LLM-herramientas.
2. Configurar Claude Desktop con servidores MCP básicos (filesystem, fetch, sqlite).
3. Usar MCP Inspector para explorar servidores: listar tools, resources, prompts.
4. Escribir un servidor MCP simple en Python con una tool (ej. calculadora o clima).
5. Probar el servidor localmente con Claude Desktop y MCP Inspector.

**Intermedio:**
1. Recursos y resource templates: exponer datos estructurados (documentos, configuraciones, queries).
2. Prompts personalizados: crear plantillas de instrucciones reutilizables en el servidor.
3. Transporte remoto: configurar servidor MCP con SSE (Server-Sent Events) para acceso remoto.
4. Manejo de errores, validación de argumentos con JSON Schema, logging.
5. Integrar MCP con frameworks de agentes: LangChain MCP adapter, LlamaIndex tool integration.

**Avanzado:**
1. Sampling: implementar servidores MCP que solicitan generaciones adicionales al LLM.
2. Servidores compuestos: un servidor que consume otros servidores MCP como dependencias.
3. Autenticación y seguridad: OAuth, API keys, rate limiting en servidores remotos.
4. Despliegue de servidores MCP en producción: Docker, Kubernetes, monitoreo.
5. Contribución al protocolo: propuestas de extensión, nuevos transportes (WebSocket, gRPC), mejoras de rendimiento.

## Relaciones con otros módulos

- `../034-LLM/`: LLMs como consumidores del protocolo MCP para acceder a herramientas.
- `../037-AgenticAI/`: MCP como infraestructura para que agentes ejecuten herramientas.
- `../077-CLI/`: Servidores MCP vía stdio integrados con herramientas CLI.
- `../074-Tools/`: Catálogo de herramientas expuestas a través de servidores MCP.
- `../079-APIs/`: MCP como capo de abstracción sobre APIs REST/GraphQL.
- `../035-RAG/`: Servidores MCP de recuperación de documentos y búsqueda.
- `../065-Workflows/`: Orquestación de herramientas MCP en pipelines automatizados.
- `../064-Agents/`: Implementaciones de agentes que usan MCP para ejecución de acciones.

## Recursos recomendados

- **Documentación oficial**: modelcontextprotocol.io — Especificación completa, SDKs, servidores de referencia.
- **Repositorio**: github.com/modelcontextprotocol — Organización oficial con SDKs y servidores.
- **Guía**: "MCP Quick Start" (modelcontextprotocol.io/quickstart).
- **Video**: "Introducing the Model Context Protocol" (Anthropic, 2024).
- **Repositorio**: "Awesome MCP Servers" (punkpeye/awesome-mcp-servers) en GitHub.
- **Herramienta**: MCP Inspector — Interfaz de depuración interactiva para servidores MCP.
