# Herramientas MCP (Tools)

## Descripción del dominio

Las herramientas (Tools) en el Model Context Protocol (MCP) son funciones ejecutables que un servidor MCP expone para que los LLMs las invoquen durante una conversación. Cada tool tiene un nombre único, una descripción textual (que el LLM usa para decidir si invocarla), y un esquema de entrada definido mediante JSON Schema que especifica los parámetros requeridos y opcionales. Cuando el LLM decide llamar a una tool, el servidor ejecuta la función y devuelve un resultado estructurado. Las tools son el mecanismo principal para que los LLMs interactúen con el mundo exterior: leer archivos, consultar bases de datos, llamar APIs, ejecutar comandos, navegar por la web, etc. La especificación MCP define los tipos de herramientas (herramientas estándar, tools con recursos incrustados) y los formatos de notificación para errores, progreso y cancelación.

## Conceptos clave

- **Tool Definition**: Objeto JSON con `name` (identificador único), `description` (guía para el LLM sobre cuándo usar la tool), `inputSchema` (JSON Schema del objeto de entrada). Se declara durante la inicialización del servidor.
- **Tool Call**: Invocación de una herramienta por parte del LLM. Incluye `name` y `arguments` (objeto con los parámetros). Se envía como solicitud JSON-RPC `tools/call`.
- **Tool Result**: Respuesta del servidor tras ejecutar la tool. Incluye `content` (lista de contenidos: texto, imágenes, recursos) y opcionalmente `isError` (booleano indicando error).
- **JSON-RPC**: Protocolo de transporte subyacente. `tools/call` como método de solicitud, `tools/list` para listar herramientas disponibles.
- **Tool List**: Método `tools/list` que el cliente invoca al conectarse para conocer todas las herramientas disponibles. El servidor responde con la lista de tool definitions.
- **Tool Change Notification**: Notificación asíncrona `notifications/tools/list_changed` que el servidor envía cuando la lista de herramientas cambia dinámicamente.
- **Content Types**: `text` (contenido textual), `image` (base64 + mimeType), `resource` (referencia a un recurso MCP existente), `embedded` (recurso incrustado en el resultado).
- **Error Handling**: La tool puede devolver `isError: true` en el resultado, con mensaje descriptivo. También puede usar notificaciones `$/progress` para reportar avance.
- **Input Validation**: El servidor debe validar los argumentos contra el JSON Schema. Si son inválidos, puede rechazar la llamada con un error.

## Ejemplo: Servidor MCP con herramientas

```python
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

app = Server("mi-servidor")

@app.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="calcular",
            description="Ejecuta una operación aritmética",
            inputSchema={
                "type": "object",
                "properties": {
                    "a": {"type": "number"},
                    "b": {"type": "number"},
                    "operacion": {
                        "type": "string",
                        "enum": ["sumar", "restar", "multiplicar", "dividir"]
                    }
                },
                "required": ["a", "b", "operacion"]
            }
        ),
        Tool(
            name="buscar_clima",
            description="Obtiene el clima actual de una ciudad",
            inputSchema={
                "type": "object",
                "properties": {
                    "ciudad": {"type": "string"},
                    "pais": {"type": "string"}
                },
                "required": ["ciudad"]
            }
        )
    ]

@app.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    if name == "calcular":
        a, b = arguments["a"], arguments["b"]
        op = arguments["operacion"]
        ops = {"sumar": a+b, "restar": a-b,
               "multiplicar": a*b, "dividir": a/b}
        return [TextContent(type="text", text=str(ops[op]))]

    elif name == "buscar_clima":
        ciudad = arguments["ciudad"]
        return [TextContent(type="text",
                text=f"25°C, soleado en {ciudad}")]

    raise ValueError(f"Tool desconocida: {name}")

if __name__ == "__main__":
    import anyio
    anyio.run(stdio_server, app)
```

## Tipos de herramientas

- **Herramientas de Archivos**: read_file, write_file, edit_file, list_directory, search_filesystem (servidor filesystem de referencia).
- **Herramientas de Base de Datos**: query_sqlite, execute_query, list_tables (servidor sqlite de referencia).
- **Herramientas Web**: fetch_url, web_search, scrape_page (servidor fetch, brave-search, puppeteer).
- **Herramientas de Código**: execute_python, run_bash, analyze_code (repos, exec servers).
- **Herramientas de APIs**: github, gitlab, jira, slack, google_maps, send_email.
- **Herramientas de Datos**: list_datasets, query_dataframe, generate_chart, transform_data.
- **Herramientas de IA**: generate_embedding, analyze_sentiment, summarize_text, translate.

## Mejores prácticas

- **Descripciones detalladas**: Escribir descripciones que ayuden al LLM a decidir cuándo usar la tool. Incluir casos de uso y ejemplos.
- **Validación estricta**: Usar JSON Schema completo con tipos, valores permitidos (enum), rangos (minimum, maximum), patrones (pattern), formatos (date-time, email).
- **Manejo de errores**: Devolver `isError: true` con mensajes descriptivos en lugar de lanzar excepciones. Incluir sugerencias de recuperación.
- **Progreso**: Para operaciones largas, usar notificaciones `$/progress` con tokens de progreso.
- **Idempotencia**: Diseñar tools de lectura como idempotentes. Herramientas de escritura deben ser seguras para re-ejecución.
- **Límites de recursos**: Establecer timeouts, límites de tamaño de respuesta, rate limiting por tool.

## Relaciones con otros módulos

- `../Resources/`: Tools pueden devolver referencias a recursos MCP en sus resultados.
- `../Prompts/`: Prompts pueden sugerir o requerir el uso de herramientas específicas.
- `../Transport/`: Cómo se transportan las llamadas a herramientas (stdio, SSE).
- `../Security/`: Permisos, autenticación y rate limiting para herramientas.
- `../Examples/`: Ejemplos completos de servidores con herramientas.
- `../../037-AgenticAI/ToolUse/`: Patrones de uso de herramientas por agentes de IA.
- `../../034-LLM/`: Capacidad de function calling en LLMs para invocar tools MCP.

## Recursos recomendados

- **Documentación oficial**: modelcontextprotocol.io/docs/concepts/tools.
- **Especificación**: Model Context Protocol Specification (tools section).
- **Servidores de referencia**: github.com/modelcontextprotocol/servers.
- **SDK**: Python SDK (anthropic/mcp), TypeScript SDK (modelcontextprotocol/typescript-sdk).
- **Inspector**: MCP Inspector para probar tools interactivamente.
- **Guía**: "Building MCP Servers" (modelcontextprotocol.io/quickstart/server).
