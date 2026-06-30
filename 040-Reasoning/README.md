# 040-Reasoning: Razonamiento en IA

## Descripción ampliada del dominio

El razonamiento es la capacidad de los sistemas de IA para procesar información, establecer conexiones lógicas, inferir conclusiones y resolver problemas complejos mediante cadenas de pensamiento estructuradas. Este módulo cubre técnicas de razonamiento en modelos de lenguaje (CoT, ToT, GoT, ReAct), razonamiento simbólico (lógica formal, sistemas expertos), razonamiento causal (inferencia causal, do-calculus), razonamiento multi-hop (conectar múltiples fragmentos de información), y razonamiento basado en herramientas (cálculo, verificación de código, búsqueda). El razonamiento es la frontera actual de la IA: los modelos pueden "pensar" paso a paso, pero aún tienen limitaciones en consistencia, profundidad y veracidad. La evolución: reglas if-then (sistemas expertos, 1970s) → lógica de primer orden (Prolog, 1980s) → razonamiento probabilístico (bayesian networks, 1990s) → ML (razonamiento estadístico, 2000s) → Chain-of-Thought (2022, modelos de lenguaje razonan paso a paso) → system 2 thinking (2024, razonamiento profundo, verificación) → test-time compute scaling (2025, más compute = mejor razonamiento). Las tendencias actuales incluyen: razonamiento matemático (GPT-4, Gemini, Claude resuelven problemas complejos), razonamiento visual, razonamiento multi-modal, agent reasoning (planning, tool use), y razonamiento auto-consistente.

## Tabla de conceptos clave

| Concepto | Descripción | Técnicas/Modelos |
|----------|-------------|------------------|
| System 1 Thinking | Rápido, intuitivo, automático. Respuesta directa del LLM. | Zero-shot directo, few-shot simple |
| System 2 Thinking | Lento, deliberado, analítico. Razonamiento paso a paso. | Chain-of-Thought, Tree-of-Thought, plan-and-execute |
| Chain-of-Thought (CoT) | Razonamiento paso a paso (let's think step by step) | CoT, Few-shot CoT, CoT-SC (self-consistency) |
| Tree-of-Thought (ToT) | Exploración en árbol de razonamiento con evaluación | ToT (BFS/DFS sobre pasos de razonamiento) |
| ReAct | Reasoning + Acting: pensamiento alterna con acciones | Tool use con razonamiento previo/ posterior |
| Self-Consistency | Múltiples cadenas de razonamiento → voto mayoritario | CoT-SC (Wang, 2022) |
| Verification | Validación de la respuesta generada | Self-Verification, Self-Refine, Chain-of-Verification |
| Causal Reasoning | Inferencia sobre causa-efecto | Do-calculus, structural causal models, counterfactual |
| Multi-hop Reasoning | Conectar múltiples fragmentos de información | Retrieval + CoT, Graph reasoning, knowledge graph traversal |
| Mathematical Reasoning | Resolver problemas matemáticos | GSM8K, MATH dataset, theorem proving (LEAN) |
| Symbolic Reasoning | Manipulación de símbolos y reglas formales | Prolog, theorem provers, SAT solvers |
| Abductive Reasoning | Inferir la explicación más probable para una observación | Abductive inference, hypothesis generation |
| Analogical Reasoning | Aplicar solución de un dominio análogo | Analogies, example mapping |
| Commonsense Reasoning | Razonamiento basado en conocimiento del mundo | Winograd schemas, physical reasoning, social reasoning |

## Tecnologías principales

| Técnica | Framework/Implementación | Evaluación | Modelos representativos |
|---------|------------------------|------------|------------------------|
| CoT | LangChain, prompting manual | GSM8K, MATH, MMLU, StrategyQA | GPT-4o, Claude 3.5, Gemini 1.5 |
| CoT-SC | Self-consistency sampling | GSM8K, MATH | GPT-4, Claude, Gemini |
| ToT | Tree-of-Thought implementation | Game of 24, crossword, creative writing | GPT-4, Claude Opus |
| GoT | Graph-of-Thought (Besta) | Sorting, document merging | GPT-4 |
| ReAct | LangChain ReAct Agent, OpenAI Functions | HotpotQA, WebQA, AlfWorld | GPT-4o, Claude 3, Gemini |
| Verification | Self-Refine, Self-Verify, CoVe | GSM8K, HotpotQA, HumanEval | GPT-4 |
| Program-of-Thought | Code-based reasoning (Python) | GSM8K, MATH | GPT-4, Claude |
| Causal Models | DoWhy (Microsoft), CausalNex | Causal benchmarks | GPT-4 causal reasoning |
| Lean/Theorem | Lean 4, Isabelle, Coq | Math Olympiad, IMO problems | GPT-f, AlphaProof |

## Hoja de ruta detallada

1. **Principiante (0-2 semanas)**: Conceptos: qué es razonamiento en IA, System 1 vs System 2 thinking. Chain-of-Thought (CoT): "Let's think step by step", ejemplos de few-shot CoT. CoT funciona mejor que direct answer para problemas multi-paso. Common pitfalls in CoT: errores aritméticos, inconsistencias, razonamiento circular. ReAct: razón → herramienta → observación → razón final. Ejemplos: ReAct para QA (research question, find answer, verify). Evaluación: accuracy en prompts directos vs CoT.
   - Práctica: Comparar zero-shot vs CoT vs few-shot CoT en problemas de matemáticas (GSM8K sample). ReAct prompt para investigación web.
   - Lectura: "Chain-of-Thought Prompting Elicits Reasoning in LLMs" (Wei, 2022), "ReAct" (Yao, 2022).

2. **Intermedio (2-4 semanas)**: Self-Consistency (CoT-SC): generar k=5-10 cadenas, majority vote o weighted vote. Tree-of-Thought (ToT): estados de razonamiento, branching, BFS/DFS search over thoughts, evaluator (LLM scores each state), backpropagation of best path. Multi-step reasoning: task decomposition (break complex problem into sub-tasks), plan-and-execute (plan first, then execute each step). Self-Verification: modelo genera respuesta y luego verifica su corrección (Self-Refine, Chain-of-Verification). Mathematical reasoning: GSM8K problems, abstract math (MATH dataset), solving equations step by step. Commonsense reasoning: physical reasoning (blocks world), social reasoning (theory of mind), temporal reasoning. Causal reasoning basics: correlation vs causation, confounders, DAGs, do-operator. Program of Thoughts: razonar generando código Python y ejecutándolo (sympy, math eval, data processing). Evaluación: CoT accuracy vs CoT-SC vs ToT, error analysis, consistency checks.
   - Proyecto: ToT for Game of 24 or crossword. CoT-SC for GSM8K problem set. Self-Refine for code generation.
   - Lectura: "Self-Consistency Improves Chain of Thought" (Wang, 2022), "Tree-of-Thoughts" (Yao, 2023), "Chain-of-Thoughts without Explicit Reasoning" (Kojima, 2022).

3. **Avanzado (4-8 semanas)**: Graph-of-Thought (GoT): reasoning graph (split, merge, loop), aggregation of partial results. Causal reasoning: structural causal models (SCM), do-calculus (interventions), counterfactual reasoning. Formal reasoning: theorem proving (Lean 4, Isabelle, Coq), SAT/SMT solvers (Z3), integration with LLMs (Copra, AlphaProof). Integration with retrieval: knowledge graph traversal, multi-hop QA (HotpotQA). Reasoning with tools: compute tools (calculator, Python), verification tools (code execution, unit test), search tools. Faithfulness of reasoning: ensuring CoT reflects actual reasoning, not post-hoc rationalization. Consistency: reasoning contradictions (same problem → different answers), calibration (confidence vs accuracy). Reasoning in LLMs vs humans: systematic vs analogical, working memory constraints, cognitive biases. Verification: CoVe (Chain-of-Verification), SelfCheckGPT, Factual consistency. Multi-agent reasoning: debate (two agents debate, judge decides), collaborative reasoning, critics (agent + critic).
   - Proyecto: Graph-of-Thought for document analysis. Multi-hop QA over knowledge base. Program-of-Thought for mathematical competition problems.
   - Lectura: "Graph-of-Thought" (Besta, 2023), "Chain-of-Verification" (Dhuliawala, 2023), "Faithful Reasoning" papers, "Causal Inference in Statistics" (Pearl).

4. **Experto (8+ semanas)**: Test-time compute scaling: compute budget for reasoning, diminishing returns, optimal compute allocation. Extended thinking (Claude, Gemini): models that "think" longer for harder problems (system 2 thinking, internal monologue). Deep reasoning: recursive reasoning (think about thinking), meta-cognition (monitor reasoning process). Causal discovery: learning causal graphs from data, DoWhy implementation. Neurosymbolic reasoning: combining neural networks with symbolic reasoning (SATNet, NeuroLog, Logic Tensor Networks). Reasoning benchmarks: ARC (Abstraction and Reasoning Corpus), BIG-Bench, MMLU-Pro, GPQA, MATH, ProofNet, IMO Grand Challenge. Scaling reasoning: multiple agents, multi-step planning, hierarchical reasoning. Beyond CoT: chain-of-thought without explicit reasoning, implicit reasoning (compressed CoT). Theory of mind: reasoning about beliefs, intentions, knowledge of others. AI alignment through reasoning: reasoning about values, consequences, ethics. Formal verification of LLM reasoning: property-based testing, formal proof of reasoning steps. Emergent reasoning capabilities: when does reasoning emerge during pre-training?
   - Proyecto: DoWhy causal inference pipeline with LLM reasoning. Test-time compute scaling analysis. Formal verification of CoT reasoning (Lean integration).
   - Lectura: "Thinking, Fast and Slow" (Kahneman) — cognitive science foundation. "Causality" (Pearl), "The Book of Why" (Pearl). Papers: "Scaling Test-Time Compute" (Snell, 2024), "Chain-of-Thought: A Survey" (2023).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [031-AI](../031-AI/) | Razonamiento como capacidad central de IA |
| [034-LLM](../034-LLM/) | LLMs como plataforma para razonamiento moderno |
| [037-AgenticAI](../037-AgenticAI/) | Agentes usan razonamiento para planificar y actuar |
| [039-PromptEngineering](../039-PromptEngineering/) | CoT, ToT, ReAct como técnicas de prompting |
| [041-CodeGeneration](../041-CodeGeneration/) | Program-of-Thought, code for reasoning |
| [000-Core](../000-Core/) | Lógica formal, algoritmos de búsqueda para ToT |

## Recursos recomendados

- **Papers clave**: "Chain-of-Thought" (Wei, 2022), "Self-Consistency" (Wang, 2022), "Tree-of-Thoughts" (Yao, 2023), "Graph-of-Thought" (Besta, 2023), "ReAct" (Yao, 2022), "Chain-of-Verification" (Dhuliawala, 2023), "Scaling Test-Time Compute" (Snell, 2024).
- **Libros**: "Thinking, Fast and Slow" (Kahneman), "The Book of Why" (Pearl), "Causality: Models, Reasoning, and Inference" (Pearl).
- **Benchmarks**: GSM8K, MATH, MMLU, BIG-Bench, HumanEval, ARC (Abstraction & Reasoning Corpus), GPQA, IMO Grand Challenge.
- **Frameworks**: LangChain (agents, CoT), DSPy (optimized prompts), Python LEO (Lean theorem prover).
- **Cursos**: Stanford CS330 (Reasoning), MIT 6.S094 (Deep Learning, reasoning section).

## Notas adicionales

Chain-of-Thought es la técnica de razonamiento más importante y accesible. System 2 thinking (deliberado) es la frontera de los LLMs modernos (Claude's extended thinking, OpenAI o1). El razonamiento causal es el "próximo paso" para IA más robusta. La verificación (self-verify, CoVe) es clave para mejorar fiabilidad. Para problemas que requieren cálculo exacto, Program-of-Thought (código Python) supera a CoT textual. La consistencia del razonamiento sigue siendo un desafío importante. El razonamiento multi-hop (conectar piezas de información) es la base de RAG avanzado y agentes. El futuro: test-time compute scaling permitirá a los modelos "pensar más" cuando el problema lo requiera.
