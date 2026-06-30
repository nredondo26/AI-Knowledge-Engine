# Recursos MCP (Resources)

## Descripción del dominio

Los recursos (Resources) en el Model Context Protocol (MCP) son fuentes de datos estructuradas que un servidor MCP expone para que los LLMs y hosts las consulten. A diferencia de las herramientas (que ejecutan acciones), los recursos son datos pasivos identificados por URIs que el LLM puede leer para obtener información contextual. Cada recurso tiene un URI único, un tipo MIME (text/plain, application/json, image/png, etc.), nombre y descripción. Los recursos pueden ser estáticos (archivos, documentos) o dinámicos (resultados de consultas a bases de datos, respuestas de APIs). Los Resource Templates permiten definir URIs parametrizables (ej. `file://{path}`) para acceder a recursos dinámicamente. Los recursos son fundamentales para proporcionar contexto adicional al LLM sin necesidad de invocar herramientas activamente.

## Conceptos clave

- **Resource Definition**: Objeto con `uri` (identificador único tipo URI), `name` (nombre legible), `description` (opcional), `mimeType` (tipo MIME del contenido). Se declara en `resources/list`.
- **Resource URI**: Identificador único del recurso. Esquemas comunes: `file://`, `db://`, `api://`, `docs://`, `config://`. Los URIs pueden incluir rutas jerárquicas.
- **Resource Content**: Contenido del recurso devuelto por `resources/read`. Puede ser `text` (contenido textual con mimeType) o `blob` (datos binarios en base64 con mimeType).
- **Resource Template**: Patrón URI con variables entre llaves `{var}` para recursos dinámicos. Ejemplo: `file://{path}` donde path es un parámetro que el cliente debe proveer.
- **Resource List**: Método `resources/list` que devuelve todos los recursos disponibles. Soporta paginación con cursor para listas grandes.
- **Resource Read**: Método `resources/read` que recibe un URI y devuelve el contenido del recurso. Puede incluir sub-recursos (paginación interna).
- **Resource Subscription**: Mecanismo opcional para que el cliente se suscriba a cambios en un recurso. El servidor notifica cambios vía `notifications/resources/list_changed`.
- **Resource Change Notification**: Notificación asíncrona `notifications/resources/list_changed` cuando la lista de recursos cambia.
- **Sub-Resources**: Un recurso puede contener múltiples sub-recursos (ej. un directorio que lista archivos). Se acceden mediante el mismo URI.

## Ejemplo: Servidor MCP con recursos

```python
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Resource, ResourceTemplate, TextContent

app = Server("servidor-documentacion")

@app.list_resources()
async def list_resources() -> list[Resource]:
    return [
        Resource(
            uri="docs://manual/introduccion",
            name="Introducción al sistema",
            description="Guía de inicio rápido",
            mimeType="text/markdown"
        ),
        Resource(
            uri="docs://manual/api_reference",
            name="Referencia de API",
            description="Documentación completa de la API REST",
            mimeType="text/html"
        ),
        Resource(
            uri="config://app/settings.json",
            name="Configuración de la aplicación",
            mimeType="application/json"
        )
    ]

@app.list_resource_templates()
async def list_templates() -> list[ResourceTemplate]:
    return [
        ResourceTemplate(
            uriTemplate="file://{path}",
            name="Archivo del sistema",
            description="Accede a cualquier archivo del sistema",
            mimeType="text/plain"
        ),
        ResourceTemplate(
            uriTemplate="db://{tabla}/{id}",
            name="Registro de base de datos",
            description="Recupera un registro por tabla e ID",
            mimeType="application/json"
        )
    ]

@app.read_resource()
async def read_resource(uri: str) -> list[TextContent]:
    if uri == "docs://manual/introduccion":
        content = "# Introducción\n\nBienvenido al sistema..."
        return [TextContent(
            type="text", text=content, mimeType="text/markdown"
        )]
    elif uri.startswith("file://"):
        path = uri.replace("file://", "")
        with open(path, "r") as f:
            return [TextContent(
                type="text", text=f.read(), mimeType="text/plain"
            )]
    raise ValueError(f"Recurso no encontrado: {uri}")
```

## Tipos de recursos

- **Documentación**: Manuales, guías, referencias API, README, tutorials. Formato markdown, HTML, PDF.
- **Configuración**: Archivos de configuración (JSON, YAML, TOML), settings de aplicación, variables de entorno.
- **Datos Estructurados**: Resultados de queries SQL, respuestas de API REST, datos de tablas, CSV, JSON.
- **Archivos del Sistema**: Archivos locales, directorios, logs, código fuente.
- **Esquemas y Modelos**: OpenAPI specs, JSON Schema, protobuf definitions, GraphQL schemas.
- **Estado y Métricas**: Estado del sistema, health checks, métricas de rendimiento, logs recientes.
- **Contexto de Conversación**: Historial de mensajes, resumen de conversación, estado del agente.

## Recursos vs. Herramientas

| Característica | Resources | Tools |
|---|---|---|
| Naturaleza | Datos pasivos, solo lectura | Acciones ejecutables |
| Invocación | El host/LLM lee el recurso | El LLM llama a la tool |
| URI | Identificador único | Nombre de la función |
| Parámetros | En el URI (template) | En arguments (JSON Schema) |
| Mutación | No (solo lectura) | Sí (puede modificar estado) |
| Subscripción | Sí (notificaciones de cambio) | No |

## Mejores prácticas

- **URIs significativos**: Usar esquemas de URI claros y jerárquicos que reflejen la organización de los datos.
- **MIME types correctos**: Especificar el tipo MIME apropiado para que el host sepa cómo procesar el contenido.
- **Recursos vs. Tools**: Usar resources para datos que el LLM necesita consultar; usar tools para acciones que el LLM necesita ejecutar.
- **Paginación**: Para listas grandes de recursos, implementar paginación con cursor en `resources/list`.
- **Caché**: Recursos estáticos pueden cachearse; recursos dinámicos deben marcarse como volátiles.
- **Templates útiles**: Diseñar templates que cubran patrones de consulta comunes sin exponer todo el sistema.

## Relaciones con otros módulos

- `../Tools/`: Tools pueden devolver referencias a resources en sus resultados (content type `resource`).
- `../Prompts/`: Prompts pueden incluir referencias a resources como contexto predefinido.
- `../Transport/`: Transporte de solicitudes de lectura de recursos.
- `../Security/`: Control de acceso a recursos sensibles, sanitización de rutas en templates.
- `../Examples/`: Ejemplos de servidores con recursos estáticos y dinámicos.
- `../../035-RAG/`: Resources como fuente de documentos para sistemas RAG.

## Recursos recomendados

- **Documentación oficial**: modelcontextprotocol.io/docs/concepts/resources.
- **Especificación**: Model Context Protocol Specification (resources section).
- **SDK**: Python SDK (anthropic/mcp) — métodos list_resources, read_resource.
- **Servidores de referencia**: Servidor filesystem (recursos de archivos), servidor sqlite (recursos de BD).
- **Guía**: "MCP Resources Tutorial" (modelcontextprotocol.io).
