# OpenAI Assistants API — Agentes Gestionados por OpenAI

## Descripción del dominio

La OpenAI Assistants API es un servicio gestionado que permite crear agentes de IA (asistentes) con capacidades de razonamiento, acceso a herramientas y gestión de estado persistente. Lanzada en noviembre de 2023, la API abstrae la complejidad de orquestar LLMs, mantener historial de conversación, ejecutar herramientas y gestionar threads (hilos de conversación). Los asistentes pueden usar modelos GPT-4, GPT-4 Turbo y GPT-4o, y vienen con herramientas integradas: Code Interpreter (ejecución de código en sandbox), File Search (RAG sobre documentos subidos) y Function Calling (herramientas personalizadas).

## Áreas clave

- **Assistants**: Entidad que define el comportamiento del agente: modelo, instrucciones del sistema, herramientas, vectores de conocimiento (file search), y funciones personalizadas
- **Threads**: Hilos de conversación persistentes. Un thread almacena mensajes y el estado de la conversación. Soporta hasta 10K mensajes. Los mensajes antiguos se resumen automáticamente
- **Runs**: Ejecución de un assistant en un thread. El run procesa los mensajes pendientes, invoca herramientas si es necesario y genera respuestas. Estado: queued, in_progress, requires_action, completed, failed, expired, cancelled
- **Run Steps**: Pasos individuales de un run: creación de mensaje, invocación de tool, resultado de tool. Útil para depuración y UI paso a paso
- **Code Interpreter**: Sandbox de Python con librerías (numpy, pandas, matplotlib, scipy) para análisis de datos, gráficos, cálculos. El código se ejecuta en un entorno aislado efímero
- **File Search (RAG)**: Subida de documentos (PDF, DOCX, HTML, TXT, CSV) que se indexan automáticamente con embeddings. El assistant puede buscar información relevante en los documentos usando búsqueda vectorial
- **Function Calling**: Herramientas personalizadas definidas como funciones JSON Schema. El assistant decide cuándo llamarlas, y el desarrollador ejecuta la lógica y devuelve el resultado
- **Vector Stores**: Almacenes de vectores para File Search. Agrupan archivos, soportan chunking y embedding automáticos. Se asocian a assistants en el momento de creación o en tiempo de ejecución

## Ejemplo: Crear un Assistant con Python

```python
from openai import OpenAI

client = OpenAI()

# Crear un asistente con herramientas
assistant = client.beta.assistants.create(
    name="Analista de Datos",
    instructions="Eres un analista experto. Responde preguntas sobre los datos subidos."
                 "Usa code_interpreter para análisis y genera gráficos cuando sea relevante.",
    model="gpt-4o",
    tools=[
        {"type": "code_interpreter"},
        {"type": "file_search"}
    ],
    tool_resources={
        "file_search": {
            "vector_store_ids": [vector_store.id]
        }
    }
)
```

## Ejemplo: Ejecutar un Thread con función personalizada

```python
import json
from openai import OpenAI

client = OpenAI()

# Definir herramienta personalizada
tools = [{
    "type": "function",
    "function": {
        "name": "get_weather",
        "description": "Obtiene el clima actual para una ciudad",
        "parameters": {
            "type": "object",
            "properties": {
                "city": {"type": "string", "description": "Nombre de la ciudad"},
            },
            "required": ["city"]
        }
    }
}]

# Crear thread y ejecutar
thread = client.beta.threads.create()
client.beta.threads.messages.create(
    thread_id=thread.id,
    role="user",
    content="¿Cómo está el clima en Madrid?"
)

run = client.beta.threads.runs.create(
    thread_id=thread.id,
    assistant_id=assistant.id,
    tools=tools
)

# Polling hasta requires_action o completed
while run.status in ("queued", "in_progress", "requires_action"):
    if run.status == "requires_action":
        # Ejecutar función y devolver resultado
        tool_call = run.required_action.submit_tool_outputs.tool_calls[0]
        if tool_call.function.name == "get_weather":
            city = json.loads(tool_call.function.arguments)["city"]
            result = json.dumps({"temperature": 22, "condition": "soleado"})
            client.beta.threads.runs.submit_tool_outputs(
                thread_id=thread.id,
                run_id=run.id,
                tool_outputs=[{
                    "tool_call_id": tool_call.id,
                    "output": result
                }]
            )
    run = client.beta.threads.runs.retrieve(
        thread_id=thread.id, run_id=run.id
    )

messages = client.beta.threads.messages.list(thread_id=thread.id)
print(messages.data[0].content[0].text.value)
```

## Tecnologías relacionadas

| Componente | Descripción |
|------------|-------------|
| OpenAI Python SDK | openai>=1.0, soporte nativo para Assistants API |
| OpenAI Node SDK | openai npm package, soporte Assistants |
| Assistants Dashboard | UI en platform.openai.com para gestionar asistentes |
| Playground | Entorno de prueba interactivo en la web de OpenAI |
| File Search | RAG gestionado con embeddings automáticos |
| Code Interpreter | Sandbox Python efímero (no persistente entre runs) |
| Response Format | json_object, text, o structured outputs con JSON Schema |

## Buenas prácticas

- Definir instrucciones del sistema claras y específicas (system prompt bien diseñado)
- Usar File Search para RAG sobre documentos largos; evitar subir archivos > 512 MB
- Para funciones externas, implementar timeouts y manejo de errores robustos
- Usar polling asíncrono (streaming) en lugar de blocking para mejor UX
- Almacenar thread IDs para persistencia de conversación entre sesiones
- Para datasets grandes, usar Vector Stores con chunking optimizado (500-1000 tokens)
- Monitorear costos: cada ejecución de Code Interpreter consume recursos adicionales
- Implementar rate limiting y backoff en la polling de runs
- Probar instrucciones y herramientas en el Playground antes de implementar
- Usar Response Format con json_schema para respuestas estructuradas
