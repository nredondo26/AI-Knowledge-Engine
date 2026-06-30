# Clientes MCP — Consumidores del Model Context Protocol

## Concepto

Un **Cliente MCP** es una aplicación o framework que se conecta a uno o más servidores MCP para extender las capacidades de un modelo de lenguaje. El cliente orquesta la comunicación JSON-RPC 2.0, gestiona el ciclo de vida de las conexiones, y expone las herramientas, recursos y prompts de los servidores al LLM.

Ejemplos de clientes MCP: Claude Desktop, VS Code (Cline), asistentes personalizados, agents autónomos, pipelines de IA.

## Arquitectura de un Cliente MCP

```
Aplicación / LLM
    │
    └─► Cliente MCP
          │
          ├─► Session Manager (conexiones activas)
          │     ├─ Servidor A (stdio) ──► Tools A
          │     ├─ Servidor B (SSE)  ──► Tools B
          │     └─ Servidor C (WS)   ──► Resources C
          │
          ├─► Tool Aggregator
          │     └─ Unifica herramientas de todos los servidores
          │
          ├─► Resource Cache
          │     └─ Cachea recursos para evitar lecturas repetidas
          │
          └─► Prompt Manager
                └─ Combina prompts del sistema con prompts de servidores
```

## Implementación de un Cliente MCP

### 1. Cliente básico con Python SDK

```python
import asyncio
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

async def main():
    # Parámetros del servidor
    server_params = StdioServerParameters(
        command="python",
        args=["/ruta/servidor_mcp.py"]
    )

    # Conectar
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            # Inicializar
            await session.initialize()

            # Listar herramientas disponibles
            tools = await session.list_tools()
            print("Herramientas disponibles:")
            for t in tools.tools:
                print(f"  - {t.name}: {t.description}")

            # Ejecutar una herramienta
            resultado = await session.call_tool(
                "saludar",
                {"nombre": "Usuario"}
            )
            print(f"Resultado: {resultado.content[0].text}")

asyncio.run(main())
```

### 2. Cliente con múltiples servidores

```python
import asyncio
from mcp import ClientSession
from mcp.client.stdio import stdio_client

class MCPClientManager:
    def __init__(self):
        self.sessions = {}

    async def connect_stdio(self, name: str, command: str, args: list):
        from mcp.client.stdio import StdioServerParameters, stdio_client
        params = StdioServerParameters(command=command, args=args)
        read, write = await stdio_client(params).__aenter__()
        session = await ClientSession(read, write).__aenter__()
        await session.initialize()
        self.sessions[name] = session

    async def list_all_tools(self):
        todas = {}
        for name, session in self.sessions.items():
            tools = await session.list_tools()
            for t in tools.tools:
                todas[f"{name}:{t.name}"] = {
                    "server": name,
                    "tool": t,
                    "session": session
                }
        return todas

    async def call_tool_by_name(self, full_name: str, args: dict):
        server_name, tool_name = full_name.split(":", 1)
        session = self.sessions[server_name]
        return await session.call_tool(tool_name, args)

    async def disconnect_all(self):
        for session in self.sessions.values():
            await session.__aexit__(None, None, None)

# Uso
async def ejemplo():
    manager = MCPClientManager()
    await manager.connect_stdio("fs", "python", ["fs_server.py"])
    await manager.connect_stdio("db", "python", ["db_server.py"])

    tools = await manager.list_all_tools()
    print(f"Total herramientas: {len(tools)}")
    for name in tools:
        print(f"  - {name}")

asyncio.run(ejemplo())
```

## Ciclo de Vida de un Cliente MCP

1. **Discovery**: Localizar servidores (config local, registro, mDNS)
2. **Handshake**: Intercambiar capacidades (versión del protocolo, características)
3. **Initialization**: `session.initialize()`
4. **Listing**: `list_tools()`, `list_resources()`, `list_prompts()`
5. **Execution**: `call_tool()`, `read_resource()`, `get_prompt()`
6. **Teardown**: Cerrar sesiones, liberar recursos

## Buenas Prácticas

1. **Timeout**: Configurar timeout por operación (default 60s).
2. **Reconexión**: Implementar backoff exponencial ante fallos.
3. **Caché**: Cachear `list_tools()` (cambia poco).
4. **Logging**: Registrar todas las llamadas y respuestas.
5. **Seguridad**: Validar que el servidor no ejecute comandos peligrosos.

```python
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("mcp-client")

class LoggedClientSession(ClientSession):
    async def call_tool(self, name: str, args: dict):
        logger.info(f"Llamando a {name} con args={args}")
        result = await super().call_tool(name, args)
        logger.info(f"Respuesta de {name}: {result}")
        return result
```
