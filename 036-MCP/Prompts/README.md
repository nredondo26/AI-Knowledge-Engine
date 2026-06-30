# Prompts MCP (Prompts)

## Descripción del dominio

Los prompts en el Model Context Protocol (MCP) son plantillas de instrucciones predefinidas que un servidor MCP puede exponer para que los hosts (aplicaciones cliente) las utilicen como base para sus interacciones con el LLM. A diferencia de las tools (que ejecutan acciones) y los resources (que proveen datos), los prompts son plantillas reutilizables que guían el comportamiento del LLM de manera estructurada. Cada prompt tiene un nombre, una descripción, y una lista de mensajes (con roles system, user, assistant) que pueden incluir argumentos dinámicos. Los prompts MCP permiten estandarizar instrucciones complejas (como formato de respuestas, reglas de comportamiento, plantillas de análisis) y compartirlas entre diferentes hosts y aplicaciones, promoviendo la reutilización y consistencia.

## Conceptos clave

- **Prompt Definition**: Objeto con `name` (identificador único), `description` (propósito del prompt), `arguments` (lista de argumentos con nombre, descripción y si son requeridos).
- **Prompt Message**: Mensaje individual dentro del prompt. Tiene `role` (system, user, assistant) y `content` (texto, imagen, o recurso incrustado).
- **Prompt Argument**: Variable que se inyecta en el prompt. Se define con `name`, `description` y `required`. El host proporciona los valores al obtener el prompt.
- **Prompt Template**: El contenido del mensaje puede incluir placeholders como `{{argumento}}` que son reemplazados por los valores de los argumentos.
- **Prompt List**: Método `prompts/list` que devuelve todos los prompts disponibles en el servidor. Soporta paginación.
- **Prompt Get**: Método `prompts/get` que recibe un nombre de prompt y argumentos, y devuelve la lista de mensajes expandidos (con los argumentos reemplazados).
- **Embedded Resources**: Un prompt puede incluir referencias a recursos MCP como parte de su contenido, permitiendo combinar instrucciones con datos dinámicos.
- **Multi-message Prompts**: Los prompts pueden tener múltiples mensajes simulando una conversación de ejemplo (few-shot) o una secuencia de instrucciones.

## Ejemplo: Servidor MCP con prompts

```python
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Prompt, PromptMessage, TextContent

app = Server("servidor-prompts")

@app.list_prompts()
async def list_prompts() -> list[Prompt]:
    return [
        Prompt(
            name="analizar_codigo",
            description="Analiza código fuente y proporciona sugerencias de mejora",
            arguments=[
                {"name": "lenguaje", "description": "Lenguaje de programación", "required": True},
                {"name": "codigo", "description": "Código fuente a analizar", "required": True}
            ]
        ),
        Prompt(
            name="resumir_documento",
            description="Genera un resumen estructurado de un documento",
            arguments=[
                {"name": "tema", "description": "Tema del documento", "required": True},
                {"name": "nivel_detalle", "description": "breve, normal, detallado", "required": False}
            ]
        ),
        Prompt(
            name="traduccion_tecnica",
            description="Traduce texto técnico entre idiomas manteniendo terminología",
            arguments=[
                {"name": "texto", "description": "Texto a traducir", "required": True},
                {"name": "idioma_origen", "description": "Idioma original", "required": True},
                {"name": "idioma_destino", "description": "Idioma destino", "required": True}
            ]
        )
    ]

@app.get_prompt()
async def get_prompt(name: str, arguments: dict) -> list[PromptMessage]:
    if name == "analizar_codigo":
        return [
            PromptMessage(
                role="system",
                content=TextContent(
                    type="text",
                    text=f"Eres un experto en {arguments['lenguaje']}. "
                         f"Analiza el siguiente código y proporciona: "
                         f"1) Problemas de calidad, 2) Sugerencias de mejora, "
                         f"3) Mejores prácticas, 4) Posibles bugs."
                )
            ),
            PromptMessage(
                role="user",
                content=TextContent(
                    type="text",
                    text=f"Código en {arguments['lenguaje']}:\n"
                         f"```{arguments['lenguaje']}\n"
                         f"{arguments['codigo']}\n```"
                )
            )
        ]

    elif name == "resumir_documento":
        nivel = arguments.get("nivel_detalle", "normal")
        return [
            PromptMessage(
                role="system",
                content=TextContent(
                    type="text",
                    text=f"Resume el siguiente documento sobre {arguments['tema']} "
                         f"con nivel de detalle {nivel}. "
                         f"Incluye: idea principal, puntos clave, conclusiones."
                )
            )
        ]

    raise ValueError(f"Prompt no encontrado: {name}")
```

## Usos comunes de prompts MCP

- **Análisis de Código**: Prompts para revisión de código, detección de bugs, sugerencias de refactorización, revisión de seguridad.
- **Generación de Documentación**: Crear docstrings, README, comentarios de código, documentación técnica a partir del código fuente.
- **Traducción Técnica**: Traducir documentación manteniendo terminología especializada, formato técnico y referencias cruzadas.
- **Resumen y Extracción**: Resumir documentos largos, extraer entidades, fechas y conceptos clave.
- **Formateo y Transformación**: Convertir datos entre formatos (JSON a YAML, CSV a markdown), reestructurar documentos.
- **Análisis de Datos**: Prompts para interpretar datos tabulares, generar visualizaciones, detectar patrones y anomalías.
- **Generación de Tests**: Crear casos de prueba, datos de prueba, mocks y stubs a partir de especificaciones.

## Mejores prácticas

- **Descripciones informativas**: Ayudar al host a elegir el prompt correcto con descripciones claras del propósito y cuándo usarlo.
- **Argumentos bien definidos**: Especificar si son requeridos, proporcionar descripciones útiles, incluir valores por defecto cuando sea posible.
- **Roles claros**: Usar role "system" para instrucciones fijas (personalidad, reglas, formato) y "user" para el contenido variable.
- **Ejemplos integrados**: Incluir ejemplos few-shot dentro de los mensajes del prompt para guiar el comportamiento del LLM.
- **Reutilización**: Diseñar prompts modulares que puedan combinarse. Un prompt puede referenciar a otro mediante mensajes encadenados.
- **Versionado**: Los prompts evolucionan; considerar incluir versión en el nombre o mantener prompts legacy.

## Relaciones con otros módulos

- `../Tools/`: Prompts pueden sugerir herramientas específicas que el LLM debería usar.
- `../Resources/`: Prompts pueden incluir recursos embebidos como contexto predefinido.
- `../Transport/`: Transporte de solicitudes de prompts (prompts/list, prompts/get).
- `../Examples/`: Ejemplos de prompts reutilizables en servidores MCP.
- `../../039-PromptEngineering/`: Ingeniería de prompts general que se aplica al diseño de prompts MCP.
- `../../037-AgenticAI/`: System prompts para agentes que pueden exponerse via MCP.

## Recursos recomendados

- **Documentación oficial**: modelcontextprotocol.io/docs/concepts/prompts.
- **Especificación**: Model Context Protocol Specification (prompts section).
- **SDK**: Python SDK (anthropic/mcp) — métodos list_prompts, get_prompt.
- **Inspector**: MCP Inspector para probar prompts interactivamente.
- **Guía**: "Designing MCP Prompts" (modelcontextprotocol.io).
