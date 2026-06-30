# Tree-of-Thoughts (ToT) — Razonamiento con Búsqueda en Árbol

## Descripción del dominio

Tree-of-Thoughts (ToT) es una técnica avanzada de prompting y razonamiento que extiende Chain-of-Thought (CoT) al explorar múltiples caminos de razonamiento en forma de árbol. Cada nodo del árbol representa un "pensamiento" o estado intermedio, y el LLM evalúa, poda y expande nodos usando técnicas de búsqueda heurística. Introducida por Long (2023) y Yao et al. (2023), ToT es particularmente efectiva en problemas que requieren exploración estratégica, planificación, puzzles, generación creativa y toma de decisiones con múltiples alternativas.

## Áreas clave

- **Arquitectura ToT**: Árbol donde cada nodo = pensamiento (texto o acción), ramas = alternativas de razonamiento, algoritmo de búsqueda (BFS, DFS, best-first, MCTS). El LLM actúa como generador de pensamientos y evaluador
- **Generación de pensamientos**: Sample (muestreo de múltiples continuaciones) vs Propose (el LLM propone explícitamente alternativas). Sample es más simple; Propose permite exploración más estructurada
- **Evaluación de estados**: Value (valoración numérica, ej. escala 1-10) vs Vote (clasificación: seguro/imposible/quizás). Evaluación prompteada: "Evalúa la probabilidad de éxito de este paso del 1 al 10"
- **Algoritmos de búsqueda**: BFS (breadth-first — explorar por niveles, bueno para problemas con depth limitado), DFS (depth-first — explorar profundo, con backtracking), Best-First (priorizar nodos más prometedores), MCTS (Monte Carlo Tree Search — balancear exploración/explotación con UCB)
- **Poda (Pruning)**: Descartar nodos con baja probabilidad de éxito. Reduzca el espacio de búsqueda drásticamente. Umbral de poda ajustable: agresivo (rápido pero puede perder solución) vs conservador (completo pero costoso)
- **Backtracking**: Si un camino no lleva a solución, retroceder al nodo anterior y probar otra rama. Esencial para problemas con múltiples etapas donde decisiones tempranas afectan el resultado final
- **ToT vs CoT**: CoT = un camino lineal (depth). ToT = múltiples caminos (breadth × depth). ToT explora alternativas, evalúa, poda y retrocede. Mayor costo computacional pero mejor precisión en problemas complejos
- **Graph-of-Thoughts (GoT)**: Extensión a grafo acíclico dirigido (DAG), donde pensamientos pueden combinarse (fusion). Permite razonamiento paralelo y fusión de caminos. Mayor expresividad que ToT

## Ejemplo: ToT para puzzle de las 3 jarras (prompt)

```
Eres un asistente que resuelve problemas con búsqueda en árbol de pensamientos.

Problema: Tienes jarras de 8L, 5L y 3L. La de 8L está llena.
Quieres obtener exactamente 4L en la jarra de 8L.

Estado inicial: [8, 0, 0]
Estado objetivo: [4, ?, ?]

Pasos de razonamiento posibles (pensamientos):
1. Verter de una jarra a otra hasta que una se llene o la fuente se vacíe

Genera 3 posibles siguientes pensamientos desde el estado actual.
Para cada uno, evalúa su progreso hacia el objetivo (1-10).

Estado actual: [8, 0, 0] (jarra 8L, 5L, 3L)
Pensamiento 1: Verter 8L → 5L → estado [3, 5, 0]. Evaluación: 5/10
Pensamiento 2: Verter 8L → 3L → estado [5, 0, 3]. Evaluación: 4/10
Pensamiento 3: No verter. Evaluación: 1/10

Selecciono el pensamiento 1 (score más alto). Nuevo estado: [3, 5, 0]
...
```

## Ejemplo: Implementación ToT simplificada

```python
import itertools

class TreeOfThoughts:
    def __init__(self, llm, max_depth=5, beam_width=3, prune_threshold=3):
        self.llm = llm
        self.max_depth = max_depth
        self.beam_width = beam_width
        self.prune_threshold = prune_threshold

    def solve(self, problem):
        # Inicializar con el estado/problema inicial
        nodes = [{"thought": problem, "depth": 0, "score": 10}]
        best_solution = None

        for depth in range(self.max_depth):
            candidates = []

            for node in nodes:
                if self.is_solution(node["thought"]):
                    return node["thought"]

                # Generar pensamientos siguientes
                new_thoughts = self.generate_thoughts(node["thought"])
                for t in new_thoughts:
                    score = self.evaluate(t)
                    candidates.append({"thought": t, "depth": depth + 1, "score": score})

            # Poda: mantener solo los beam_width mejores
            candidates.sort(key=lambda x: x["score"], reverse=True)
            nodes = candidates[:self.beam_width]

            # Poda por threshold
            nodes = [n for n in nodes if n["score"] >= self.prune_threshold]

            if not nodes:
                # Backtrack implícito: se acabaron caminos
                break

        return best_solution or "No se encontró solución"

    def generate_thoughts(self, thought):
        prompt = f"""Dado el siguiente estado/pensamiento:
{thought}
Genera hasta 3 posibles siguientes pasos o pensamientos alternativos.
Formato: cada pensamiento en una línea separada por "|"
Pensamientos:"""
        response = self.llm.generate(prompt)
        return [t.strip() for t in response.split("|") if t.strip()]

    def evaluate(self, thought):
        prompt = f"""Evalúa la probabilidad de que este pensamiento lleve a una solución.
Puntúa del 1 al 10, donde 10 = seguro que lleva a la solución.
Pensamiento: {thought}
Puntuación:"""
        response = self.llm.generate(prompt)
        import re
        scores = re.findall(r'\d+', response)
        return int(scores[0]) if scores else 5

    def is_solution(self, thought):
        prompt = f"""¿Este pensamiento/estado resuelve el problema?
Pensamiento: {thought}
Responde solo 'SI' o 'NO':"""
        return "SI" in self.llm.generate(prompt).upper()
```

## Tecnologías relacionadas

| Técnica | Descripción | Complejidad |
|---------|-------------|-------------|
| Chain-of-Thought | Un camino lineal | Baja |
| Self-Consistency | Múltiples CoT + votación | Media |
| Tree-of-Thoughts | Árbol con evaluación y poda | Alta |
| Graph-of-Thoughts | DAG con fusión de caminos | Muy alta |
| MCTS + LLM | Monte Carlo Tree Search con LLM como evaluador | Muy alta |
| Algorithm of Thoughts | Replicar algoritmos clásicos (BFS, DFS) con LLM | Alta |
| Reasoning via Planning (RAP) | Planificación en espacio de estados | Alta |

## Buenas prácticas

- Usar ToT cuando CoT sea insuficiente (problemas que requieren exploración de alternativas)
- Ajustar beam_width (ancho de búsqueda) y max_depth según presupuesto de tokens
- Empezar con BFS para problemas con profundidad limitada; DFS para problemas donde se necesita explorar profundo
- Implementar poda agresiva para problemas grandes (mantener solo top-2 o top-3)
- Evaluar nodos con una prompt específica de evaluación (value prompting)
- Usar auto-poda: dejar que el LLM decida si un camino es prometedor
- Para problemas complejos, combinar ToT con búsqueda MCTS (balance exploración/explotación)
- Muestrear temperatura > 0.5 en generación de pensamientos para diversidad
- Limitar el número total de nodos expandidos para controlar costos
- Monitorear: si todos los caminos se podan, reducir umbral de poda o aumentar beam_width
