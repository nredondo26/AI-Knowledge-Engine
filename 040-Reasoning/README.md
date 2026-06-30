# 040-Reasoning: Razonamiento en IA

## Descripción del dominio

El razonamiento en inteligencia artificial abarca las técnicas y métodos que permiten a los sistemas realizar inferencias lógicas, tomar decisiones bajo incertidumbre y resolver problemas complejos mediante cadenas de pensamiento estructuradas. Este módulo cubre desde el razonamiento simbólico clásico (lógica proposicional, lógica de primer orden, sistemas basados en reglas) hasta enfoques modernos como Chain-of-Thought (CoT), Tree-of-Thought (ToT), razonamiento probabilístico con redes bayesianas y razonamiento causal. Es el puente entre la representación del conocimiento y la capacidad de los agentes de IA para derivar conclusiones novedosas.

## Conceptos clave

- **Lógica proposicional**: Proposiciones, conectores lógicos (∧, ∨, ¬, →, ↔), tablas de verdad, tautologías, satisfacibilidad
- **Lógica de primer orden**: Cuantificadores (∀, ∃), predicados, términos, unificación, resolución, forma normal de Skolem
- **Sistemas basados en reglas**: Reglas de producción, forward chaining, backward chaining, motor de inferencia, Rete algorithm
- **Razonamiento probabilístico**: Teorema de Bayes, redes bayesianas, modelos gráficos probabilísticos (PGM), inferencia exacta y aproximada
- **Cadenas de Markov**: Cadenas de Markov ocultas (HMM), modelos de Markov, procesos de decisión de Markov (MDP)
- **Razonamiento causal**: Diagramas causales (DAGs), criterio back-door, intervenciones (do-calculus), contrafactuales, inferencia causal
- **Chain-of-Thought (CoT)**: Razonamiento paso a paso en LLMs, few-shot CoT, zero-shot CoT, CoT-SC (self-consistency)
- **Tree-of-Thought (ToT)**: Búsqueda en árbol con evaluación de nodos, poda, backtracking guiado por LLM
- **Graph-of-Thought (GoT)**: Razonamiento estructurado en grafo, fusión de caminos de pensamiento paralelos
- **Razonamiento no monotónico**: Lógicas no monotónicas, circumscripción, negación por fallo, sistemas de creencias revisables
- **Razonamiento con incertidumbre**: Lógica difusa, teoría de Dempster-Shafer, factores de certeza
- **Planificación automática**: STRIPS, PDDL, planificación jerárquica (HTN), GraphPlan, planificación en tiempo real

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Motores de inferencia lógica | Prolog, Datalog, CLIPS, Jena, Drools |
| Redes bayesianas | pgmpy (Python), BUGS, Stan, PyMC, inferencia en Pyro |
| Razonamiento causal | DoWhy, CausalNex, CausalML, EconML, Tetrad |
| Frameworks CoT/ToT | LangChain (Reasoning), guidance, Outlines, DSPy, Tree-of-Thought GitHub |
| Planificación | PDDL (Fast-Downward, Fast-Forward), STRIPS, Optic |
| Lenguajes lógicos | Prolog, Mercury, ASP (Answer Set Programming), MiniZinc |
| Librerías de lógica | SymPy (lógica simbólica), z3 (SMT solver), pyDatalog |

## Hoja de ruta

1. **Principiante**: Lógica proposicional — tablas de verdad — introducción al teorema de Bayes — reglas de inferencia básicas
2. **Intermedio**: Lógica de primer orden — unificación y resolución — sistemas basados en reglas — redes bayesianas simples — razonamiento probabilístico en Python
3. **Avanzado**: Modelos gráficos probabilísticos — inferencia exacta (junction tree) y aproximada (MCMC) — razonamiento causal (do-calculus) — Chain-of-Thought avanzado — programación lógica con Prolog
4. **Experto**: Tree-of-Thought, Graph-of-Thought — inferencia causal con datos observacionales — sistemas híbridos neuro-simbólicos — planificación automatizada — lógicas no clásicas (modal, temporal, epistémica)

## Relaciones con otros módulos

- [031-AI](../031-AI/) — Fundamento del cual se deriva el razonamiento como subdisciplina central de IA
- [034-LLM](../034-LLM/) — Base de los modelos que habilitan CoT, ToT y razonamiento emergente
- [035-RAG](../035-RAG/) — Sistemas que combinan recuperación con razonamiento para responder preguntas
- [037-AgenticAI](../037-AgenticAI/) — Agentes que requieren planificación y razonamiento en tiempo real
- [039-PromptEngineering](../039-PromptEngineering/) — Técnicas de prompting que desencadenan razonamiento estructurado
- [038-VectorDatabases](../038-VectorDatabases/) — Almacenamiento de conocimiento para razonamiento basado en recuperación
- [052-Standards](../052-Standards/) — Notación lógica estandarizada y representación de conocimiento

## Recursos recomendados

- **Libros**: "Artificial Intelligence: A Modern Approach" (Russell & Norvig), "Probabilistic Graphical Models" (Koller & Friedman), "Causal Inference in Statistics" (Pearl), "The Book of Why" (Pearl & Mackenzie)
- **Cursos**: Stanford CS221 (AI), Stanford CS228 (Probabilistic Graphical Models), Coursera "Causal Inference" (Columbia), MIT 6.034
- **Papers**: "Chain-of-Thought Prompting Elicits Reasoning in Large Language Models" (Wei et al., 2022), "Tree of Thoughts: Deliberate Problem Solving with LLMs" (Yao et al., 2023), "DoWhy: A Python Library for Causal Inference"
- **Herramientas**: Prolog (SWI-Prolog), Z3, pgmpy, DoWhy, LangChain Expression Language para cadenas de razonamiento
