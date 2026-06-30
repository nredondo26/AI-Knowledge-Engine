# Planificación en Agentes (Planning)

## Descripción del dominio

La planificación (Planning) en agentes de IA es el proceso mediante el cual un agente descompone un objetivo complejo en una secuencia de pasos ejecutables, determina el orden óptimo, asigna recursos y maneja contingencias. A diferencia de la planificación clásica en IA (STRIPS, PDDL), la planificación en agentes modernos se realiza mediante LLMs que razonan sobre el objetivo, el contexto actual y las herramientas disponibles para generar planes adaptativos. Las estrategias principales incluyen ReAct (Reasoning + Acting, donde el agente alterna razonamiento y acción en un bucle), Plan-and-Execute (generar un plan completo primero, luego ejecutarlo paso a paso), Tree-of-Thoughts (explorar múltiples caminos de planificación en paralelo), y Hierarchical Planning (planes anidados con subobjetivos). La planificación puede ser estática (plan fijo antes de ejecutar) o dinámica (replanificación basada en resultados intermedios y feedback del entorno).

## Conceptos clave

- **ReAct (Reason + Act)**: Bucle iterativo donde el agente razona sobre el estado actual, decide una acción, la ejecuta, observa el resultado y vuelve a razonar. Alternancia natural de pensamiento y acción.
- **Plan-and-Execute**: Dos fases: (1) generar un plan completo con pasos ordenados, (2) ejecutar cada paso verificando resultados. Si un paso falla, se replanifica.
- **Chain-of-Thought (CoT)**: Razonamiento paso a paso para descomponer problemas. Base de muchas estrategias de planificación.
- **Tree-of-Thoughts (ToT)**: Exploración de múltiples líneas de razonamiento (árbol de pensamientos). Cada nodo es un estado parcial. Se evalúan y podan ramas usando heurísticas.
- **Plan Generation**: El LLM genera un plan estructurado (lista de pasos, DAG, o grafo) que incluye objetivos intermedios, herramientas y criterios de éxito.
- **Replanning**: Capacidad de modificar el plan sobre la marcha cuando un paso falla, los resultados son inesperados o el contexto cambia.
- **Subgoal Decomposition**: Descomposición recursiva de un objetivo en subobjetivos más manejables. Cada subobjetivo puede tener su propio sub-plan.
- **Dependency Graph**: Grafo que muestra dependencias entre pasos: qué pasos deben completarse antes de que otros comiencen. Permite paralelización.
- **Plan Validation**: Verificación de que un plan es factible: herramientas disponibles, recursos suficientes, restricciones de orden respetadas.
- **World Model**: Representación interna del entorno que el agente usa para simular resultados de acciones antes de ejecutarlas.

## Ejemplo: Plan-and-Execute

```python
from langchain.chains import PlanAndExecute
from langchain_community.agent_toolkits.load_tools import load_tools
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4o", temperature=0)
tools = load_tools(["serpapi", "llm-math"], llm=llm)

agent = PlanAndExecute(
    llm=llm,
    tools=tools,
    verbose=True,
    max_iterations=10
)

result = agent.run(
    "Investiga el PIB de España en 2024, "
    "compáralo con Francia y Alemania, "
    "y calcula el promedio de los tres."
)

# El agente generará un plan como:
# 1. Buscar PIB de España 2024
# 2. Buscar PIB de Francia 2024
# 3. Buscar PIB de Alemania 2024
# 4. Calcular promedio de los tres
# 5. Presentar resultados comparativos
```

## Ejemplo: ReAct loop manual

```python
import json

def react_agent(question, tools, llm, max_steps=10):
    messages = [
        {"role": "system", "content": (
            "Eres un agente ReAct. Piensa paso a paso. "
            "Formato: Thought: ... Action: tool_name(\\\"arg\\\") "
            "Observation: ... Final Answer: ..."
        )},
        {"role": "user", "content": question}
    ]

    for step in range(max_steps):
        response = llm.invoke(messages)
        content = response.content
        messages.append({"role": "assistant", "content": content})

        if "Final Answer:" in content:
            return content.split("Final Answer:")[-1].strip()

        if "Action:" in content:
            action_line = content.split("Action:")[-1].strip()
            tool_name, args_str = action_line.split("(", 1)
            args_str = args_str.rstrip(")")
            args = json.loads(f"{{{args_str}}}") if ":" in args_str else {}

            for tool in tools:
                if tool.name == tool_name:
                    observation = tool.run(args)
                    break
            else:
                observation = f"Tool {tool_name} no encontrada"

            messages.append({
                "role": "user",
                "content": f"Observation: {observation}"
            })

    return "No se pudo completar la tarea"
```

## Estrategias de planificación

- **ReAct**: Simple, flexible, funciona para la mayoría de tareas. No requiere plan explícito.
- **Plan-and-Execute**: Mejor para tareas complejas con pasos claros. El plan da estructura pero es menos flexible.
- **Tree-of-Thoughts**: Ideal para problemas que requieren exploración (optimización, puzzles, creatividad). Mayor costo computacional.
- **Reflexion (Reflection)**: El agente ejecuta, evalúa el resultado, reflexiona sobre errores, y ajusta el plan. Ciclo de mejora continua.
- **LLM Compiler**: Descomposición jerárquica con un planificador que genera sub-tareas y un ejecutor que las completa.
- **RePlan**: Variante de Plan-and-Execute que replanifica automáticamente cuando detecta fallos.

## Relaciones con otros módulos

- `../MultiAgent/`: Planificación distribuida entre múltiples agentes.
- `../Memory/`: Memoria de planes anteriores y resultados para mejorar planificación futura.
- `../ToolUse/`: Herramientas disponibles que condicionan los planes generados.
- `../Evaluation/`: Evaluación de la calidad de los planes generados.
- `../../039-PromptEngineering/TreeOfThought/`: Tree-of-Thoughts como técnica de planificación.
- `../../039-PromptEngineering/ChainOfThought/`: Chain-of-Thought como base para planificación.
- `../../040-Reasoning/`: Razonamiento avanzado para planificación.

## Recursos recomendados

- **Paper**: "ReAct: Synergizing Reasoning and Acting in Language Models" (Yao et al., 2022).
- **Paper**: "Tree of Thoughts: Deliberate Problem Solving with Large Language Models" (Yao et al., 2023).
- **Paper**: "Plan-and-Solve Prompting" (Wang et al., 2023).
- **Paper**: "Reflexion: Language Agents with Verbal Reinforcement Learning" (Shinn et al., 2023).
- **Documentación**: LangChain PlanAndExecute docs, LangGraph Planning docs.
- **Repositorio**: langchain-ai/langgraph, principia-ai/ReAct.
- **Video**: "Planning in AI Agents" (LangChain YouTube).
