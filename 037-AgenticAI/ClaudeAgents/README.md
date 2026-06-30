# Claude Agents — Agentes con Anthropic Claude

## Descripción del dominio

Anthropic Claude ofrece capacidades nativas para construir agentes de IA a través de su API de Tool Use (Function Calling) y el Model Context Protocol (MCP). Claude se destaca en tareas de razonamiento paso a paso, manejo seguro de herramientas, seguimiento de instrucciones complejas y comportamiento alineado. La construcción de agentes con Claude se basa en el patrón ReAct (Reasoning + Acting): el modelo razona sobre el estado actual, decide qué acción tomar (tool call), ejecuta la acción, observa el resultado y repite. Claude 3.5 Sonnet y Claude 3 Opus son los modelos recomendados para agentes.

## Áreas clave

- **Tool Use (Function Calling)**: Claude puede invocar funciones externas definidas con JSON Schema. El modelo decide cuándo llamar herramientas basándose en la conversación y las instrucciones
- **Extended Thinking**: Modo de Claude que permite mostrar su proceso de razonamiento paso a paso antes de dar la respuesta final. Mejora la calidad en tareas complejas (matemáticas, código, análisis)
- **MCP Integration**: Claude Desktop soporta servidores MCP como herramientas nativas. Los servidores MCP exponen tools, resources y prompts que Claude puede usar
- **Computer Use (Beta)**: Claude puede controlar un escritorio (mouse, teclado, captura de pantalla) para tareas de automatización de GUI. Basado en captura de pantalla + acciones de coordenadas
- **Prompt Engineering para agentes**: System prompt estructurado con personalidad, herramientas disponibles, reglas de uso y formato de respuesta esperado. Buenas prácticas: pocos ejemplos, descripciones claras
- **Streaming de tool calls**: Claude soporta streaming de respuestas, incluyendo tool calls. Ideal para UX responsive donde se muestran las acciones del agente en tiempo real
- **Multi-turn conversations**: Claude mantiene contexto a través de múltiples turnos de tool use. Historial de llamadas y resultados disponibles para decisiones futuras

## Ejemplo: Tool Use con la API de Anthropic

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    tools=[{
        "name": "get_weather",
        "description": "Obtiene el clima actual para una ubicación",
        "input_schema": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "Ciudad o coordenadas"
                }
            },
            "required": ["location"]
        }
    }],
    messages=[{"role": "user", "content": "¿Qué clima hace en Barcelona?"}]
)

# Manejar tool call
for block in response.content:
    if block.type == "tool_use":
        location = block.input["location"]
        result = get_weather_from_api(location)
        # Enviar resultado de vuelta
        response = client.messages.create(
            model="claude-3-5-sonnet-20241022",
            messages=[
                {"role": "user", "content": "¿Qué clima hace en Barcelona?"},
                {"role": "assistant", "content": response.content},
                {"role": "user", "content": [
                    {"type": "tool_result", "tool_use_id": block.id, "content": str(result)}
                ]}
            ],
            tools=[...]
        )
```

## Ejemplo: Agente con system prompt y herramientas

```python
SYSTEM_PROMPT = """Eres un asistente de investigación con acceso a herramientas de búsqueda web y base de conocimiento.
Sigue estas reglas:
1. Primero piensa paso a paso qué información necesitas
2. Usa las herramientas apropiadas para cada necesidad
3. Si la búsqueda no encuentra resultados, intenta con términos alternativos
4. Resume la información encontrada con citas de las fuentes
5. Si no puedes encontrar la información, indícalo claramente

Herramientas disponibles:
- search_web: Búsqueda en internet
- search_knowledge_base: Búsqueda en documentos internos
- get_page_content: Obtener contenido completo de una URL"""

tools = [
    {
        "name": "search_web",
        "description": "Busca información en internet",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {"type": "string", "description": "Términos de búsqueda"},
                "max_results": {"type": "integer", "default": 5}
            },
            "required": ["query"]
        }
    },
    {
        "name": "search_knowledge_base",
        "description": "Busca en documentos internos",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {"type": "string"}
            },
            "required": ["query"]
        }
    }
]
```

## Tecnologías relacionadas

| Componente | Descripción |
|------------|-------------|
| Anthropic Python SDK | anthropic>=0.30, soporte nativo para tool use y streaming |
| Anthropic Node SDK | @anthropic-ai/sdk |
| Claude Desktop | Host MCP con interfaz gráfica, soporta MCP servers |
| MCP Servers | Servidores que exponen tools y resources a Claude |
| Computer Use (Beta) | Automatización de GUI con Claude |
| Prompt improver | Herramienta incluida en Anthropic Console para mejorar prompts |
| Workbench | Consola web de Anthropic para probar prompts y tools |

## Buenas prácticas

- Diseñar system prompts con instrucciones claras y reglas de comportamiento
- Usar descripciones detalladas en herramientas para ayudar al modelo a elegir correctamente
- Implementar manejo de errores: si una tool falla, devolver un mensaje de error descriptivo
- Usar streaming para mostrar el razonamiento del agente en tiempo real
- Para tareas largas, implementar un bucle con manejo de estado parcial
- Validar parámetros de herramientas antes de ejecutar acciones con efectos secundarios
- Monitorizar el número de tool calls para controlar costos y detectar loops infinitos
- Probar diferentes variantes de system prompt para optimizar el comportamiento
- Usar Extended Thinking para tareas que requieran razonamiento profundo (depuración, análisis)
