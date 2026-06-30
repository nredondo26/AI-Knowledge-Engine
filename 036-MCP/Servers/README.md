# Servidores MCP — Model Context Protocol Servers

## Concepto

Un **Servidor MCP** (Model Context Protocol Server) es un servicio que expone herramientas, recursos y prompts a clientes MCP (como asistentes IA) siguiendo el protocolo JSON-RPC 2.0 sobre transporte estándar (stdio, SSE, WebSocket). Los servidores MCP actúan como capa de abstracción entre modelos de lenguaje y sistemas externos: bases de datos, APIs, sistemas de archivos, motores de búsqueda, etc.

MCP fue creado por Anthropic para estandarizar la conexión entre LLMs y herramientas externas, de forma similar a cómo USB estandarizó la conexión de periféricos.

## Arquitectura de un Servidor MCP

```
Cliente MCP (Host)
    │
    ├── JSON-RPC 2.0 ──► Servidor MCP
    │                        │
    │                     ├── Tools (funciones ejecutables)
    │                     │     └─ Ej: leer_archivo(), buscar_web()
    │                     │
    │                     ├── Resources (datos expuestos)
    │                     │     └─ Ej: archivo://, db://, api://
    │                     │
    │                     ├── Prompts (plantillas)
    │                     │     └─ Ej: "Resumir: {{texto}}"
    │                     │
    │                     └── Transport Layer
    │                           ├─ stdio (subprocess)
    │                           └─ SSE (HTTP Server-Sent Events)
```

## Implementación de un Servidor MCP

### 1. Servidor básico con stdio (Python)

```python
# servidor_mcp.py
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

app = Server("mi-servidor")

@app.list_tools()
async def list_tools():
    return [
        Tool(
            name="saludar",
            description="Saluda a un usuario",
            inputSchema={
                "type": "object",
                "properties": {
                    "nombre": {
                        "type": "string",
                        "description": "Nombre del usuario"
                    }
                },
                "required": ["nombre"]
            }
        ),
        Tool(
            name="calcular",
            description="Realiza una operación matemática",
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
        )
    ]

@app.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "saludar":
        return [TextContent(type="text", text=f"¡Hola, {arguments['nombre']}!")]
    elif name == "calcular":
        a, b = arguments["a"], arguments["b"]
        ops = {
            "sumar": a + b,
            "restar": a - b,
            "multiplicar": a * b,
            "dividir": a / b if b != 0 else float("inf")
        }
        return [TextContent(type="text", text=str(ops[arguments["operacion"]]))]

async def main():
    async with stdio_server() as (read_stream, write_stream):
        await app.run(read_stream, write_stream, app.create_initialization_options())
```

### 2. Servidor con Recursos (Resources)

Expone datos que el cliente puede leer.

```python
from mcp.types import Resource, ResourceTemplate

@app.list_resources()
async def list_resources():
    return [
        Resource(
            uri="file:///etc/hosts",
            name="Hosts File",
            mimeType="text/plain",
            description="Contenido del archivo hosts"
        )
    ]

@app.read_resource()
async def read_resource(uri: str):
    if uri == "file:///etc/hosts":
        with open("/etc/hosts") as f:
            return [TextContent(type="text", text=f.read())]
    raise ValueError(f"Resource not found: {uri}")
```

### 3. Servidor con Transporte SSE (HTTP)

```python
# pip install mcp[uvicorn]
from mcp.server.sse import SseServerTransport
from starlette.applications import Starlette
from starlette.routing import Route

sse = SseServerTransport("/messages/")

async def handle_sse(request):
    async with sse.connect_sse(request) as (read, write):
        await app.run(read, write, app.create_initialization_options())

app_http = Starlette(
    routes=[
        Route("/sse", endpoint=handle_sse),
        Route("/messages/{message_id}", endpoint=sse.handle_post_message, methods=["POST"]),
    ]
)

# uvicorn servidor_mcp:app_http --host 0.0.0.0 --port 8000
```

## Buenas Prácticas

1. **Validación de entrada**: Usa Pydantic para validar argumentos.
2. **Manejo de errores**: Devuelve errores legibles, no excepciones crudas.
3. **Timeout**: Operaciones largas deben tener timeout configurable.
4. **Logging**: Registra cada llamada para depuración.
5. **Seguridad**: Nunca exponer credenciales. Validar rutas de archivos.

```python
# Validación con Pydantic
from pydantic import BaseModel

class ArgsCalcular(BaseModel):
    a: float
    b: float
    operacion: str

@app.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "calcular":
        args = ArgsCalcular(**arguments)
        # ...
```
