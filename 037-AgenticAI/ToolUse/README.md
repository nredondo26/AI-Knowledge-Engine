# Uso de Herramientas en Agentes (ToolUse)

## Descripción del dominio

El uso de herramientas (Tool Use o Function Calling) es la capacidad de un agente de IA para invocar funciones externas definidas mediante esquemas estructurados. Es el mecanismo fundamental que permite a los LLMs trascender su conocimiento interno y actuar sobre el mundo real: leer archivos, consultar bases de datos, llamar APIs, ejecutar código, enviar emails, controlar dispositivos, etc. Los LLMs modernos (GPT-4, Claude 3, Gemini) tienen soporte nativo para tool calling: el modelo recibe definiciones de herramientas con nombre, descripción y esquema JSON de parámetros; durante la generación, el modelo puede decidir invocar una herramienta, devolviendo un objeto estructurado con el nombre de la herramienta y los argumentos. El sistema entonces ejecuta la función y devuelve el resultado al modelo para que continúe la generación. Los frameworks de agentes (LangChain, Anthropic Tool Use, OpenAI Assistants) abstraen este ciclo en bucles de agente que manejan múltiples herramientas, errores, retry y estado.

## Conceptos clave

- **Function Calling (Tool Calling)**: Capacidad del LLM de devolver una llamada a función estructurada en lugar de texto. El modelo elige cuándo y qué herramienta invocar.
- **Tool Definition**: Especificación de una herramienta: `name` (único), `description` (para que el LLM entienda cuándo usarla), `parameters` (JSON Schema con tipos, required, descripciones).
- **Tool Call**: Invocación generada por el LLM. Contiene `id`, `function.name` y `function.arguments` (JSON). Se devuelve como parte de la respuesta del LLM.
- **Tool Result**: Resultado de ejecutar la herramienta, que se devuelve al LLM como un mensaje con `tool_call_id` correspondiente.
- **Agent Loop (Tool Loop)**: Ciclo: LLM genera respuesta (texto o tool call) → si es tool call, ejecutar herramienta → devolver resultado al LLM → repetir hasta que el LLM devuelva texto.
- **Parallel Tool Calls**: Capacidad de invocar múltiples herramientas en paralelo en un solo paso. El LLM devuelve múltiples tool calls en una respuesta.
- **Structured Output**: Generación de salidas con formato estructurado (JSON) usando tool calling con tools especiales de output parsing.
- **Error Handling**: Manejo de errores de herramientas: timeout, excepciones, argumentos inválidos. El resultado del error se devuelve al LLM para que decida cómo recuperarse.
- **Retry Logic**: Reintento automático de herramientas fallidas con backoff. El LLM puede reformular argumentos si falló por validación.
- **Tool Permissions**: Control de qué herramientas puede usar el agente y bajo qué condiciones (autenticación, rate limiting, alcance).
- **Dynamic Tool Selection**: El agente puede elegir entre un conjunto dinámico de herramientas basado en el contexto de la tarea.

## Ejemplo: Tool Use con OpenAI

```python
from openai import OpenAI

client = OpenAI()

tools = [
    {
        "type": "function",
        "function": {
            "name": "obtener_clima",
            "description": "Obtiene el clima actual de una ciudad",
            "parameters": {
                "type": "object",
                "properties": {
                    "ciudad": {
                        "type": "string",
                        "description": "Nombre de la ciudad"
                    },
                    "unidad": {
                        "type": "string",
                        "enum": ["celsius", "fahrenheit"],
                        "default": "celsius"
                    }
                },
                "required": ["ciudad"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "buscar_vuelos",
            "description": "Busca vuelos disponibles entre dos ciudades",
            "parameters": {
                "type": "object",
                "properties": {
                    "origen": {"type": "string"},
                    "destino": {"type": "string"},
                    "fecha": {"type": "string", "format": "date"}
                },
                "required": ["origen", "destino", "fecha"]
            }
        }
    }
]

def ejecutar_tool(name, args):
    if name == "obtener_clima":
        return f"25°C en {args['ciudad']}"
    elif name == "buscar_vuelos":
        return f"Vuelos de {args['origen']} a {args['destino']}: ..."

messages = [
    {"role": "user", "content": "¿Qué clima hace en Madrid y qué vuelos hay a Barcelona mañana?"}
]

while True:
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=messages,
        tools=tools
    )
    msg = response.choices[0].message
    messages.append(msg)

    if not msg.tool_calls:
        print("Respuesta:", msg.content)
        break

    for tool_call in msg.tool_calls:
        name = tool_call.function.name
        args = json.loads(tool_call.function.arguments)
        result = ejecutar_tool(name, args)
        messages.append({
            "role": "tool",
            "tool_call_id": tool_call.id,
            "content": result
        })
```

## Patrones avanzados de tool use

- **Tool Chaining**: El resultado de una herramienta se pasa como entrada a otra. Ej: buscar → analizar → resumir → traducir.
- **Dynamic Tool Creation**: El agente puede crear nuevas herramientas en tiempo real (ej. definir funciones Python y ejecutarlas).
- **Tool Composition**: Combinar múltiples herramientas en una meta-herramienta que el LLM puede invocar como una sola.
- **Tool Validation**: Validación de resultados de herramientas antes de pasarlos al LLM. Filtrar datos sensibles, verificar formatos.
- **Tool Caching**: Cachear resultados de herramientas para evitar llamadas repetidas.
- **Human-in-the-Loop**: Algunas herramientas requieren aprobación humana antes de ejecutarse (acciones destructivas, pagos, envío de datos).

## Relaciones con otros módulos

- `../MultiAgent/`: Distribución de herramientas entre agentes especializados.
- `../Planning/`: Planificación que decide qué herramientas usar y en qué orden.
- `../Memory/`: Memoria de resultados de herramientas para evitar repetición.
- `../Evaluation/`: Evaluación de efectividad del tool use en tareas.
- `../../036-MCP/`: MCP como protocolo estándar para exponer herramientas a agentes.
- `../../034-LLM/`: Capacidad nativa de function calling en LLMs.
- `../../039-PromptEngineering/`: Diseño de descripciones de herramientas para guiar al LLM.

## Recursos recomendados

- **Paper**: "Toolformer: Language Models Can Teach Themselves to Use Tools" (Schick et al., 2023).
- **Paper**: "Gorilla: Large Language Model Connected with Massive APIs" (Patil et al., 2023).
- **Documentación**: OpenAI Function Calling docs, Anthropic Tool Use docs, Google Function Calling docs.
- **Guía**: "Building Effective Tools for LLMs" (Anthropic).
- **Repositorio**: langchain-ai/langchain (tool integrations), richardyc/awesome-agent-tools.
- **Video**: "Tool Use and Function Calling Explained" (LangChain YouTube).
