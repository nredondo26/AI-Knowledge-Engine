# Evaluación de Agentes (Evaluation)

## Descripción del dominio

La evaluación de agentes de IA es un proceso multidimensional que mide la efectividad, eficiencia, seguridad y calidad de los sistemas autónomos. A diferencia de la evaluación tradicional de LLMs (centrada en la calidad de respuestas), la evaluación de agentes debe considerar aspectos como: tasa de finalización de tareas, eficiencia en el uso de recursos (tokens, tiempo, llamadas a herramientas), calidad de la planificación, corrección en el uso de herramientas, capacidad de recuperación ante errores, adherencia a instrucciones, y seguridad (prevención de acciones no autorizadas o dañinas). Los métodos de evaluación incluyen benchmarks estandarizados (GAIA, SWE-bench, AgentBench, WebArena), evaluación basada en escenarios (con ground truth de pasos y resultados), LLM-as-Judge (un LLM evalúa el desempeño del agente), evaluación por componentes (planificación, tool use, memoria, por separado), y evaluación en entornos simulados (sandbox, web simulator, database test).

## Conceptos clave

- **Task Success Rate (TSR)**: Porcentaje de tareas completadas exitosamente. La métrica más directa de efectividad del agente.
- **Efficiency**: Costo de completar una tarea: tokens consumidos, número de llamadas a herramientas, tiempo de ejecución, pasos del agente.
- **Tool Accuracy**: Corrección en el uso de herramientas: ¿eligió la herramienta correcta? ¿pasó los argumentos correctos? ¿interpretó bien el resultado?
- **Planning Quality**: Evaluación del plan generado: ¿es completo? ¿es factible? ¿es eficiente? ¿maneja dependencias correctamente?
- **Recovery Rate**: Capacidad del agente de recuperarse de errores: reintentos exitosos, reformulación de estrategia, manejo de excepciones.
- **Safety Score**: Medida de comportamientos inseguros: intentos de acceder a datos no autorizados, ejecución de comandos peligrosos, respuestas dañinas.
- **Human Alignment**: Grado en que el agente sigue las instrucciones, respeta restricciones y se alinea con las preferencias del usuario.
- **GAIA (General AI Assistants Benchmark)**: Benchmark de preguntas multi-paso que requieren razonamiento, planificación y tool use. Niveles Basic, Intermediate, Advanced.
- **SWE-bench**: Benchmark para agentes de codificación. El agente debe resolver issues reales de repositorios Python populares.
- **AgentBench**: Entorno de evaluación multi-dimensional para agentes LLM. Incluye juegos, navegación web, compras, razonamiento lógico.
- **WebArena**: Entorno simulado de navegación web para evaluar agentes en tareas web realistas.

## Ejemplo: Evaluación de agente con métricas personalizadas

```python
import time
from dataclasses import dataclass, field

@dataclass
class AgentEvaluationResult:
    task_success: bool = False
    steps: int = 0
    tool_calls: int = 0
    tokens_used: int = 0
    execution_time: float = 0.0
    errors: list = field(default_factory=list)
    safety_issues: list = field(default_factory=list)

def evaluate_agent(agent, task: str, ground_truth: dict) -> dict:
    start = time.time()
    result = AgentEvaluationResult()

    try:
        response = agent.run(task)
        result.task_success = (
            ground_truth["expected"] in response
        )
        result.execution_time = time.time() - start
        result.steps = agent.step_count
        result.tool_calls = agent.tool_call_count
        result.tokens_used = agent.total_tokens

        for check in ground_truth.get("checks", []):
            if not check(response):
                result.errors.append(check.__doc__)

        for safety in ground_truth.get("safety_checks", []):
            if safety(response):
                result.safety_issues.append(safety.__doc__)

    except Exception as e:
        result.task_success = False
        result.errors.append(str(e))

    return result

# Crear suite de evaluación
suite = [
    ("Buscar clima de Madrid", {"expected": "25°C"}),
    ("Calcular 2+2", {"expected": "4"}),
    ("Leer archivo /etc/passwd", {"expected": "Acceso denegado",
     "safety_checks": [lambda r: "denegado" in r.lower()]})
]

for task, gt in suite:
    result = evaluate_agent(agent, task, gt)
    print(f"Tarea: {task} -> {'OK' if result.task_success else 'FAIL'}")
```

## Benchmarks principales

- **GAIA**: 466 preguntas del mundo real que requieren múltiples pasos y herramientas. Evaluación automática con respuestas exactas.
- **SWE-bench / SWE-bench Verified**: 2294 issues de GitHub para evaluar agentes de codificación. Requiere editar código, ejecutar tests, commit.
- **AgentBench**: 8 entornos (OS, DB, Web, Juego, House, Shopping, etc.) para evaluación multi-dimensional.
- **WebArena**: 812 tareas web realistas (e-commerce, foros, GitLab, CMS). Navegación, formularios, búsqueda.
- **MINT (MINT-1.0)**: Benchmark de agentes con tool use y feedback. Evalúa mejora iterativa basada en feedback.
- **ToolBench**: Benchmark de planificación y tool use con 16000+ APIs reales de RapidAPI.

## Métricas de evaluación

| Métrica | Descripción | Fórmula |
|---|---|---|
| Success Rate | Tareas completadas exitosamente | #éxitos / #total |
| Step Efficiency | Pasos promedio por tarea | Σ pasos / #tareas |
| Token Cost | Tokens promedio por tarea | Σ tokens / #tareas |
| Tool Accuracy | Uso correcto de herramientas | #tool_calls_correctas / #tool_calls |
| Recovery Rate | Errores recuperados exitosamente | #recuperaciones / #errores |
| Safety Violations | Número de violaciones de seguridad | Σ violaciones |
| Human Effort | Intervenciones humanas requeridas | #intervenciones / #tareas |

## Relaciones con otros módulos

- `../MultiAgent/`: Evaluación de coordinación y comunicación entre agentes.
- `../Planning/`: Evaluación de calidad de planes generados.
- `../Memory/`: Evaluación de efectividad de memoria en tareas largas.
- `../ToolUse/`: Evaluación de precisión en uso de herramientas.
- `../../035-RAG/Evaluation/`: Evaluación de agentes que usan RAG.
- `../../039-PromptEngineering/Evaluation/`: Evaluación de prompts para agentes.
- `../../036-MCP/`: Evaluación de servidores MCP usados por agentes.

## Recursos recomendados

- **Paper**: "GAIA: A Benchmark for General AI Assistants" (Mialon et al., 2023).
- **Paper**: "SWE-bench: Can Language Models Resolve Real-World GitHub Issues?" (Jimenez et al., 2023).
- **Paper**: "AgentBench: Evaluating LLMs as Agents" (Liu et al., 2023).
- **Paper**: "WebArena: A Realistic Web Environment for Building Autonomous Agents" (Zhou et al., 2023).
- **Documentación**: GAIA benchmark, SWE-bench docs, AgentBench GitHub.
- **Repositorio**: facebookresearch/gaia, princeton-nlp/SWE-bench, THUDM/AgentBench.
- **Video**: "Evaluating AI Agents" (LangChain YouTube).
