# Tree-of-Thoughts (ToT)

## Descripción del dominio

Tree-of-Thoughts (ToT, Árbol de Pensamientos) es una técnica avanzada de prompting que extiende Chain-of-Thought (CoT) al explorar múltiples líneas de razonamiento en paralelo, organizadas como un árbol donde cada nodo representa un estado de pensamiento parcial. A diferencia de CoT que sigue una sola línea de razonamiento lineal, ToT permite al modelo generar múltiples "pensamientos" en cada paso, evaluar su utilidad, y podar ramas poco prometedoras. El proceso incluye cuatro componentes: descomposición del problema en pasos (thought decomposition), generación de múltiples pensamientos por paso (thought generation), evaluación de estados (state evaluation) y estrategias de búsqueda en el árbol (DFS, BFS, beam search). ToT es particularmente efectivo para problemas que requieren exploración deliberada, planificación, optimización y creatividad, donde una sola línea de razonamiento puede llevar a callejones sin salida.

## Conceptos clave

- **Thought Node**: Estado intermedio de razonamiento. Representa un paso parcial hacia la solución. Contiene el razonamiento acumulado hasta ese punto.
- **Tree (Árbol)**: Estructura jerárquica de nodos de pensamiento. La raíz es el problema inicial, las hojas son soluciones completas o estados terminales.
- **Thought Generation**: Generación de posibles siguientes pensamientos desde un nodo actual. Estrategias: sample (generar variaciones con temperature > 0) o propose (el LLM propone múltiples opciones explícitamente).
- **State Evaluation**: Evaluación de la utilidad de un nodo para llegar a la solución. Puede ser Value (puntuación numérica de 1-10) o Vote (clasificación: seguro/posible/imposible).
- **BFS (Breadth-First Search)**: Exploración por niveles: evalúa todos los nodos de un nivel antes de profundizar. Limitado por ancho (b).
- **DFS (Depth-First Search)**: Exploración en profundidad: sigue una rama hasta el final antes de retroceder. Limitado por profundidad.
- **Beam Search**: Mantiene los k mejores nodos en cada nivel (beam width). Balance entre exploración y explotación.
- **Pruning (Poda)**: Eliminación de ramas con baja probabilidad de éxito basada en la evaluación. Reduce el espacio de búsqueda.
- **Backtracking**: Retroceso a nodos anteriores cuando una rama no lleva a una solución válida.
- **Self-Evaluation**: El propio LLM evalúa la calidad de sus pensamientos, decidiendo si continuar, podar o retroceder.

## Ejemplo: ToT para planificación

```python
import json
from openai import OpenAI

client = OpenAI()

def tree_of_thoughts(
    problem: str,
    k_generations: int = 3,
    beam_width: int = 2,
    max_depth: int = 5
):
    """
    Implementación simplificada de ToT con beam search.
    """

    def generate_thoughts(state: str, step: int) -> list[str]:
        prompt = f"""Problema: {problem}
Paso actual {step}: {state}
Genera {k_generations} posibles siguientes pasos (distintos y específicos):
1.
2.
3."""
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.8
        )
        thoughts = response.choices[0].message.content.strip().split("\n")
        return [t.split(". ", 1)[1] for t in thoughts if ". " in t]

    def evaluate_thought(thought: str) -> float:
        prompt = f"""Problema: {problem}
Pensamiento: {thought}
Evalúa la utilidad de este pensamiento para resolver el problema.
Puntúa del 1 al 10 (10 = muy útil, 1 = no útil).
Solo responde con el número:"""
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": prompt}],
            temperature=0
        )
        return float(response.choices[0].message.content.strip())

    # Beam search sobre el árbol
    current_nodes = [{"state": "", "depth": 0, "score": 0}]

    for depth in range(max_depth):
        candidates = []
        for node in current_nodes:
            thoughts = generate_thoughts(node["state"], depth)
            for thought in thoughts:
                score = evaluate_thought(thought)
                candidates.append({
                    "state": node["state"] + f"\n-> {thought}",
                    "depth": depth + 1,
                    "score": node["score"] + score
                })

        # Seleccionar mejores k (beam)
        candidates.sort(key=lambda x: x["score"], reverse=True)
        current_nodes = candidates[:beam_width]

        # Verificar si algún nodo es solución completa
        for node in current_nodes:
            if is_solution(problem, node["state"]):
                return node["state"]

    return current_nodes[0]["state"] if current_nodes else "No encontrado"
```

## Aplicaciones

- **Planificación**: Descomposición de objetivos complejos en pasos, explorando múltiples estrategias.
- **Resolución de Puzzles**: Problemas lógicos (Sudoku, crucigramas, acertijos) donde se necesita exploración.
- **Optimización**: Búsqueda de la mejor solución en espacios con múltiples óptimos locales.
- **Razonamiento Matemático**: Problemas que requieren explorar diferentes enfoques de solución.
- **Toma de Decisiones**: Evaluación de múltiples cursos de acción y sus consecuencias.
- **Creatividad**: Generación de ideas creativas con exploración de direcciones diversas.

## ToT vs. CoT vs. Self-Consistency

| Característica | CoT | Self-Consistency | ToT |
|---|---|---|---|
| Estructura | Lineal | Múltiples líneas independientes | Árbol jerárquico |
| Exploración | Una sola ruta | Múltiples rutas paralelas | Ramificación + poda |
| Evaluación | No | Votación final | Evaluación por paso |
| Retroceso | No | No | Sí (backtracking) |
| Complejidad | Baja | Media | Alta (múltiples llamadas) |
| Costo de tokens | Bajo | Medio-alto | Alto |
| Ideal para | Razonamiento simple | Razonamiento con incertidumbre | Problemas complejos con exploración |

## Implementaciones

- **ToT Prompting Manual**: Implementación con prompts que piden al modelo generar múltiples opciones y evaluarlas explícitamente.
- **Tree of Thoughts con LangChain**: Usando `langchain.chains.TreeOfThoughtChain` o implementación personalizada con LLMChain.
- **ToT con APIs**: Llamadas secuenciales al LLM donde cada llamada corresponde a un nodo del árbol, con el historial acumulado.
- **Autogenerativo**: El propio modelo gestiona la exploración del árbol, decidiendo cuándo ramificar y cuándo podar.
- **ToT con Evaluación por Votación**: En lugar de puntuación numérica, el modelo clasifica pensamientos como "bueno", "regular", "malo".

## Relaciones con otros módulos

- `../ChainOfThought/`: Base lineal sobre la que ToT construye exploración en árbol.
- `../FewShot/`: Ejemplos few-shot para guiar la generación y evaluación de pensamientos.
- `../Optimization/`: Optimización de parámetros de búsqueda (beam width, profundidad, k generaciones).
- `../Evaluation/`: Evaluación de la calidad de soluciones generadas por ToT.
- `../../037-AgenticAI/Planning/`: Planificación con exploración de múltiples estrategias.
- `../../040-Reasoning/`: Razonamiento avanzado con estructuras de árbol.

## Recursos recomendados

- **Paper**: "Tree of Thoughts: Deliberate Problem Solving with Large Language Models" (Yao et al., 2023) — Paper fundacional.
- **Paper**: "Large Language Model Guided Tree-of-Thought" (Long, 2023).
- **Paper**: "Improving Multi-hop Reasoning with Tree of Thoughts" (Khot et al., 2023).
- **Implementación**: github.com/princeton-nlp/tree-of-thought-llm.
- **Guía**: "Tree of Thoughts Prompting" (promptingguide.ai).
- **Video**: "Tree of Thoughts: LLM Reasoning Explained" (AI Explained).
