# 039-PromptEngineering: Ingeniería de Prompts

## Descripción ampliada del dominio

La ingeniería de prompts (Prompt Engineering) es la práctica de diseñar, optimizar y refinar instrucciones (prompts) para modelos de lenguaje (LLMs) con el objetivo de obtener respuestas precisas, confiables y útiles. Es una habilidad fundamental en la era de los LLMs: un buen prompt puede marcar la diferencia entre una respuesta inútil y una solución brillante. La evolución del prompting: zero-shot (dar instrucción directa, 2020) → few-shot (dar ejemplos, 2020) → Chain-of-Thought (razonamiento paso a paso, 2022) → Tree-of-Thought (exploración múltiple, 2023) → ReAct (razonamiento + acciones, 2023) → Automatic Prompt Engineering (APE, prompting optimizado por LLM, 2023) → system prompts complejos (2024) → meta-prompting y agent prompting (2025). Las técnicas avanzadas incluyen: CoT (Chain-of-Thought), CoT-SC (Self-Consistency), ToT (Tree-of-Thought), GoT (Graph-of-Thought), SoT (Skeleton-of-Thought), structured prompts (JSON, XML, markdown schema), persona prompting, negative prompting, y prompt chaining. La ingeniería de prompts es tanto arte como ciencia: requiere experimentación sistemática, comprensión del modelo, y diseño cuidadoso.

## Tabla de conceptos clave

| Concepto | Descripción | Técnica |
|----------|-------------|---------|
| Zero-shot | Pedir al modelo realizar una tarea sin ejemplos | "Translate to Spanish: Hello" |
| Few-shot | Proporcionar ejemplos de entrada/salida en el prompt | "Q: 2+2. A: 4. Q: 5+3. A:" |
| System Prompt | Instrucción que define comportamiento, rol, tono y restricciones | "Eres un asistente experto en Python. Responde con código." |
| Chain-of-Thought (CoT) | Razonamiento paso a paso antes de la respuesta final | "Let's think step by step. Step 1: ... Step 2: ..." |
| CoT Self-Consistency | Múltiples cadenas de razonamiento → mayoría de votos | Muestrear k cadenas, elegir respuesta más común |
| Tree-of-Thought (ToT) | Exploración en árbol con evaluación de estados | BFS/DFS sobre pasos de razonamiento, evaluador de estado |
| ReAct | Reasoning + Acting: agente que piensa, actúa, observa | Thought → Action → Observation → ... → Final Answer |
| Structured Output | Especificar formato de salida (JSON, XML, markdown, YAML) | "Responde en JSON: {\"answer\": \"...\", \"reasoning\": \"...\"}" |
| Persona Prompting | Asignar un rol o personalidad al modelo | "Eres un científico de datos senior en Netflix." |
| Negative Prompting | Especificar qué evitar | "No incluyas información no verificada. No uses jerga." |
| Prompt Chaining | Secuencia de prompts donde salida de uno es entrada del siguiente | Chain #1: Extract. Chain #2: Summarize. Chain #3: Format. |
| Meta-Prompting | Usar LLM para mejorar/optimizar prompts | "Mejora el siguiente prompt para obtener respuestas más precisas:" |
| Adversarial Prompting | Técnicas para jailbreak/safety testing | DAN, role-play, hypothetical scenarios |
| Prompt Injection | Inyección de instrucciones en contenido de usuario | Ignorar instrucciones anteriores: "..." |

## Tecnologías principales

| Categoría | Herramientas/Plataformas | Propósito |
|-----------|-------------------------|-----------|
| Playground | OpenAI Playground, Anthropic Console, Google AI Studio | Experimentación interactiva de prompts |
| Versioning | PromptLayer, LangSmith, Weights & Biases (prompts), Agenta | Versionado y gestión de prompts |
| Optimization | DSPy (programar prompts optimizados), PromptPerfect, Vellum | Optimización automática de prompts |
| Testing | Promptfoo, LangSmith (evaluation), Eval, DeepEval | Testing y evaluación de prompts |
| Guardrails | NeMo Guardrails, Guardrails AI, LLM Guard, Outlines | Validación y seguridad de outputs |
| Templates | LangChain (PromptTemplate), LlamaIndex, Jinja2 | Templates de prompts reutilizables |
| Orchestration | LangChain (chains, LCEL), LangGraph (agent prompts) | Prompts para chains y agentes |

## Hoja de ruta detallada

1. **Principiante (0-2 semanas)**: Fundamentos: qué es un prompt, system vs user vs assistant messages. Zero-shot prompting: instrucciones claras, específicas, con contexto. Structuring prompts: delimiters (""", ---, <xml>), role assignment, output format specification. Few-shot prompting: selección de ejemplos relevantes, formato consistente. Temperature, top_p, max_tokens, stop sequences: efectos en generación. System prompt design: role, capabilities, constraints, tone, output format. Iterative refinement: test → analyze → refine → retest. Common pitfalls: ambiguous instructions, too many constraints, contradictory requirements.
   - Práctica: Diseñar system prompt para asistente de código, tutor, traductor. Experimentar con temperatura y few-shot en OpenAI Playground/Anthropic Console.
   - Lectura: OpenAI Prompt Engineering Guide, Anthropic Prompt Engineering guide, "Prompt Engineering" (Lilian Weng blog).

2. **Intermedio (2-4 semanas)**: Chain-of-Thought (CoT): "Let's think step by step", CoT with structured steps. CoT Self-Consistency: generar k respuestas con CoT, tomar mayoría. Few-shot CoT: ejemplos de razonamiento paso a paso. Structured outputs: schema definition (JSON Schema, Pydantic), XML/JSON output, constrained decoding. Persona prompting: efectividad de roles específicos para mejorar calidad. Context management: window management (recent, summary, sliding), prompt length optimization. Task decomposition: dividir tarea compleja en sub-tasks (prompt chaining). Negative prompting: what NOT to do, avoiding hallucinations, factual grounding. Prompt templates: LangChain PromptTemplate (input variables, template format), system vs human messages. Variables dinámicas: inyectar contexto, historial, tools, resultados de pasos anteriores. Prompt versioning: tracking prompt changes, A/B testing.
   - Práctica: CoT prompts for mathematical reasoning, multi-step QA. Structured output prompts (JSON). Prompt chain for document analysis (extract → classify → summarize).
   - Certificación: DeepLearning.AI "ChatGPT Prompt Engineering for Developers" (Andrew Ng, Isa Fulford).
   - Lectura: "Chain-of-Thought Prompting Elicits Reasoning in LLMs" (Wei, 2022), "Self-Consistency Improves Chain of Thought" (Wang, 2022).

3. **Avanzado (4-8 semanas)**: Tree-of-Thought (ToT): branching reasoning, evaluator (LLM), search (BFS/DFS). Graph-of-Thought (GoT): reasoning graph with merging/aggregation. Skeleton-of-Thought (SoT): outline → expand each point. ReAct prompting: Thought → Action → Observation → Final Answer (for agents). Least-to-Most prompting: solve simpler problem first, then complex. Self-Ask: modelo genera sub-preguntas y las responde. Automatic Prompt Engineering (APE): LLM genera y evalúa prompts, optimization loop. DSPy: programmatic prompting (signature, module, optimizer). Adversarial prompting: red teaming (jailbreak testing, prompt injection, DAN, role-play). Prompt injection defense: input validation, delimiters, system prompt hardening, instruction hierarchy. Evaluation: automated eval (LLM-as-judge, regex, function call), human eval, A/B testing. Prompt compression: removing redundancies, shorter prompts tanpa perder calidad. Multi-modal prompting: image + text, audio + text, video + text (CLIP, GPT-4V). Cost optimization: minimizing tokens (prompt length, number of examples), caching (semantic caching of responses). Prompt security: PII redaction, prompt injection detection, guardrails.
   - Proyecto: Tree-of-Thought for logic puzzles. DSPy optimization pipeline. Red teaming evaluation for custom prompt. Multi-modal prompt (image analysis + text reasoning).
   - Lectura: "Tree-of-Thought" (Yao, 2023), "Graph-of-Thought" (Besta, 2023), "Automatic Prompt Engineering" (Zhou, 2022), "DSPy" (Khattab, 2023).

4. **Experto (8+ semanas)**: Meta-prompting: LLMs that design prompts for other LLMs, optimization loop (prompt generation → evaluation → refinement → convergence). Agentic prompting: prompts for autonomous agents that include planning, tool use, reflection, memory management. Prompt evolution: prompts that adapt based on conversation context or feedback. Constitutional prompting: prompts that embed ethical principles (Constitutional AI). Multi-agent prompts: prompts for agent communication (supervisor, worker, critic), negotiation protocols. Safety-critical prompts: guardrail prompts (input/output filtering), refusal prompts, safety system prompts. Formal verification of prompts: property-based testing, formal methods for prompt behavior. Research: In-context learning theory (why few-shot works?), prompt robustness, adversarial robustness, prompt fairness. LLM-as-judge: designing evaluation prompts that are unbiased, consistent, calibrated. Instruction hierarchy (Anthropic): model following of nested instructions, injection resistance. Prompt ensembling: multiple prompts → aggregated response. Advanced DSPy: custom optimizers, fine-tuning with DSPy-generated prompts. Context window optimization: hierarchical summarization, retrieval-augmented prompt construction. Cross-model prompting: prompts that work well across different LLMs (transferable prompts).
   - Proyecto: Meta-prompting system for automatic prompt optimization. Instruction hierarchy evaluation. Constitutional prompts for aligned agent behavior. Cross-model prompting analysis.
   - Lectura: "Constitutional AI" (Bai, 2022), "Instruction Hierarchy" (Anthropic, 2024), "LLM-as-a-Judge" (Zheng, 2023), "In-Context Learning" papers.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [034-LLM](../034-LLM/) | Prompting es cómo nos comunicamos con LLMs |
| [035-RAG](../035-RAG/) | Prompts para inyectar contexto recuperado |
| [036-MCP](../036-MCP/) | MCP prompts como templates reutilizables |
| [037-AgenticAI](../037-AgenticAI/) | Agent prompts (ReAct, planning, reflection, tools) |
| [040-Reasoning](../040-Reasoning/) | CoT, ToT, ReAct como técnicas de prompting |
| [041-CodeGeneration](../041-CodeGeneration/) | Prompts para generación de código |
| [042-Documentation](../042-Documentation/) | Prompts para documentar código |

## Recursos recomendados

- **Guías**: OpenAI Prompt Engineering Guide, Anthropic Prompt Engineering Guide, Google Prompting Guide (Vertex AI), Cohere Prompt Engineering Guide.
- **Papers**: "Chain-of-Thought" (Wei), "Self-Consistency" (Wang), "Tree-of-Thoughts" (Yao), "Graph-of-Thought" (Besta), "DSPy" (Khattab), "Automatic Prompt Engineer" (Zhou).
- **Cursos**: DeepLearning.AI "ChatGPT Prompt Engineering for Developers" (Andrew Ng), "Advanced Prompt Engineering" (OpenAI), "DSPy" course.
- **Herramientas**: OpenAI Playground, Anthropic Console, DSPy, Promptfoo, LangSmith, Vellum, PromptLayer.
- **Comunidad**: r/PromptEngineering, Prompt Engineering Guide (github.com/dair-ai/Prompt-Engineering-Guide), Lilian Weng Blog.

## Notas adicionales

La ingeniería de prompts es una habilidad en rápida evolución. Empezar con system prompts claros + few-shot ejemplos + output format. Chain-of-Thought es la técnica más efectiva para razonamiento. La experimentación sistemática (A/B testing) es esencial — no hay "un prompt perfecto". DSPy representa el futuro: prompts optimizados programáticamente. La seguridad es crítica: los prompts pueden ser inyectados (prompt injection). La evaluación (eval) es el mayor desafío: ¿cómo saber si un prompt es mejor? La ingeniería de prompts no desaparecerá, pero evolucionará: de escribir prompts manualmente a diseñar sistemas de prompting optimizados automáticamente.
