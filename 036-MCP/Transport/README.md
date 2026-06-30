# Transporte MCP (Transport)

## Descripción del dominio

El transporte (Transport) en el Model Context Protocol (MCP) define cómo se comunican los clientes y servidores MCP a través de la red o procesos locales. MCP especifica dos mecanismos de transporte principales: stdio (Standard Input/Output) para comunicación con procesos locales mediante pipes estándar, y SSE (Server-Sent Events) para comunicación remota sobre HTTP. Ambos transportes utilizan JSON-RPC 2.0 como formato de mensaje subyacente. El transporte stdio es ideal para servidores ejecutados localmente (como plugins de editor o herramientas CLI) por su simplicidad y baja latencia. El transporte SSE permite conexiones remotas a servidores en la nube, con soporte para sesiones y endpoints separados para mensajes entrantes y salientes. La elección del transporte afecta la latencia, seguridad, escalabilidad y despliegue del servidor MCP.

## Conceptos clave

- **JSON-RPC 2.0**: Protocolo de llamada a procedimiento remoto ligero y sin estado. Define request (con id), response (con id correspondiente), notification (sin id) y error (con código y mensaje).
- **Transport Layer**: Capa abstracta que maneja el envío y recepción de mensajes JSON-RPC. Independiente del mecanismo físico subyacente.
- **Stdio Transport**: Comunicación via stdin/stdout del proceso del servidor. El cliente inicia el servidor como subproceso, envía mensajes por stdin y recibe respuestas por stdout. stderr es para logging/depuración.
- **SSE Transport (Server-Sent Events)**: Comunicación sobre HTTP. El servidor expone un endpoint SSE para eventos unidireccionales y un endpoint POST para mensajes del cliente. Las sesiones se identifican por session ID.
- **Message Encoding**: Los mensajes se codifican como JSON. En stdio, cada mensaje es una línea JSON terminada en newline (`\n`). En SSE, los mensajes se envuelven en eventos `event: message` con `data:` JSON.
- **Session Management**: En SSE, el servidor asigna un session ID a cada conexión. El cliente usa este ID para enrutar mensajes posteriores.
- **Endpoint POST**: En SSE transport, el cliente envía mensajes JSON-RPC via HTTP POST a un endpoint específico como `application/json`.
- **Endpoint SSE**: El servidor envía eventos SSE al cliente, incluyendo respuestas a requests y notificaciones.
- **Heartbeat / Keep-Alive**: Mecanismos opcionales para mantener conexiones SSE activas y detectar desconexiones.
- **Stream Cancellation**: Soporte para cancelar operaciones de streaming mediante notificaciones especiales.

## Ejemplo: Servidor MCP con stdio

```python
from mcp.server import Server
from mcp.server.stdio import stdio_server

# El servidor stdio se comunica via stdin/stdout
# El cliente ejecuta: python servidor.py
# y se comunica mediante JSON-RPC sobre stdio

app = Server("mi-servidor-stdio")

@app.list_tools()
async def list_tools():
    return [Tool(
        name="saludar",
        description="Saluda a una persona",
        inputSchema={
            "type": "object",
            "properties": {
                "nombre": {"type": "string"}
            },
            "required": ["nombre"]
        }
    )]

if __name__ == "__main__":
    import anyio
    anyio.run(stdio_server, app)
```

## Ejemplo: Configuración de cliente con diferentes transportes

```json
// Claude Desktop config - Transporte stdio (local)
{
  "mcpServers": {
    "mi-servidor-local": {
      "command": "python",
      "args": ["/ruta/servidor.py"],
      "transport": "stdio"
    }
  }
}

// Claude Desktop config - Transporte SSE (remoto)
{
  "mcpServers": {
    "mi-servidor-remoto": {
      "url": "https://api.miservidor.com/mcp",
      "transport": "sse"
    }
  }
}
```

## Comparación de transportes

| Característica | Stdio | SSE |
|---|---|---|
| Latencia | Muy baja (proceso local) | Mayor (red HTTP) |
| Seguridad | Aislamiento del proceso | TLS/HTTPS, autenticación |
| Escalabilidad | 1 servidor por cliente | Múltiples clientes |
| Despliegue | Local (CLI, editor) | Remoto (servidor web) |
| Estado del servidor | Efímero (por sesión) | Persistente |
| Logging | stderr | logs del servidor web |
| Configuración | command + args | URL + headers |
| Ideal para | Herramientas locales, plugins | APIs, servicios cloud |

## Implementación de transportes personalizados

Además de stdio y SSE, el protocolo MCP permite implementar transportes personalizados. Ejemplos potenciales:

- **WebSocket Transport**: Comunicación bidireccional completa sobre WebSocket. Ideal para aplicaciones en tiempo real.
- **gRPC Transport**: Streaming bidireccional con tipado fuerte. Para sistemas de alta performance.
- **Unix Domain Socket**: Comunicación local entre procesos en el mismo host, más rápida que TCP loopback.
- **Message Queue (RabbitMQ, Kafka)**: Para sistemas asíncronos y desacoplados con buffering y persistencia.
- **WebRTC Data Channel**: Para comunicación peer-to-peer de baja latencia en navegadores.

## Mejores prácticas

- **Stdio para desarrollo local**: Usar stdio para servidores que se ejecutan localmente en el mismo host que el cliente (IDEs, CLI tools).
- **SSE para producción**: Usar SSE con TLS/HTTPS para servidores remotos. Implementar autenticación (API keys, OAuth).
- **Manejo de errores de conexión**: Implementar retry con backoff para reconexiones SSE. Detectar servidor caído en stdio.
- **Timeouts**: Configurar timeouts adecuados para lectura/escritura según el transporte y la operación.
- **Logging en stderr**: En stdio, usar stderr para mensajes de depuración; stdout solo para JSON-RPC.
- **Session isolation**: En SSE, asegurar que cada sesión esté aislada y no comparta estado no deseado.

## Relaciones con otros módulos

- `../Tools/`: Tools se invocan mediante mensajes JSON-RPC sobre el transporte.
- `../Resources/`: Recursos se leen mediante solicitudes JSON-RPC sobre el transporte.
- `../Prompts/`: Prompts se obtienen mediante solicitudes JSON-RPC sobre el transporte.
- `../Security/`: Seguridad de la capa de transporte (TLS, autenticación, rate limiting).
- `../Examples/`: Ejemplos de servidores con diferentes configuraciones de transporte.
- `../../077-CLI/`: Integración de servidores MCP con herramientas CLI mediante stdio.
- `../../079-APIs/`: Exposición de servidores MCP como APIs HTTP mediante SSE.

## Recursos recomendados

- **Documentación oficial**: modelcontextprotocol.io/docs/concepts/transports.
- **Especificación**: Model Context Protocol Specification (transport section).
- **SDK**: Python SDK (anthropic/mcp) — StdioServerParameters, SSE transport classes.
- **Guía**: "MCP Transport Configuration" (modelcontextprotocol.io).
- **Repositorio**: github.com/modelcontextprotocol/servers (ejemplos con stdio y SSE).
