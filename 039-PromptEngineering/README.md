# Ingeniería de Prompts (039-PromptEngineering)

## Descripción del dominio

La Ingeniería de Prompts (Prompt Engineering) es la disciplina que diseña, optimiza y refina las instrucciones (prompts) dadas a modelos de lenguaje (LLMs) para obtener respuestas precisas, relevantes y seguras. Es una habilidad fundamental en la era de los LLMs, ya que la calidad del output depende críticamente de la calidad del input. Abarca desde técnicas simples como estructurar instrucciones claras hasta métodos avanzados como Chain-of-Thought (cadena de pensamiento), Few-Shot (ejemplos en contexto), Tree-of-Thoughts (árbol de pensamientos), y system prompts complejos que definen roles, reglas y comportamientos. También incluye aspectos de seguridad (jailbreaking, prompt injection, guardrails) y optimización sistemática mediante iteración y evaluación (prompt benchmarking). Con la evolución de los LLMs, el prompt engineering se ha convertido en una interfaz de programación de alto nivel para sistemas de IA.

## Conceptos clave

- **System Prompt**: Instrucción de sistema que define el rol, personalidad, tono, reglas y límites del asistente. Se mantiene fija durante la conversación.
- **User Prompt**: Mensaje del usuario que contiene la consulta o instrucción específica. Puede incluir contexto, ejemplos y formato deseado.
- **Few-Shot Prompting**: Incluir ejemplos de entrada y salida esperada en el prompt para guiar el comportamiento del modelo sin fine-tuning.
- **Zero-Shot Prompting**: Instrucción sin ejemplos, el modelo debe inferir la tarea solo con la descripción.
- **Chain-of-Thought (CoT)**: Indicar al modelo que razone paso a paso antes de dar la respuesta. Mejora precisión en tareas de razonamiento matemático y lógico.
- **Chain-of-Thought con Auto-consistencia (Self-Consistency)**: Generar múltiples cadenas de pensamiento y votar la respuesta más común.
- **Tree-of-Thoughts (ToT)**: Explorar múltiples líneas de razonamiento en paralelo, evaluando y podando ramas.
- **ReAct**: Sinergia entre razonamiento (Reasoning) y acción (Acting). El modelo piensa, actúa (llama herramientas), observa resultados y continúa.
- **Prompt Chaining**: Secuencia de prompts donde la salida de uno es la entrada del siguiente. Útil para tareas complejas descompuestas en pasos.
- **Prompt Injection**: Técnica de seguridad donde un usuario malicioso inserta instrucciones en el prompt para modificar el comportamiento del modelo.
- **Jailbreaking**: Técnicas para evadir las restricciones de seguridad del modelo (role-playing, hipotéticos, codificación).
- **Guardrails**: Filtros y validaciones que restringen las respuestas del LLM para garantizar seguridad y cumplimiento.
- **Output Formatting**: Especificación del formato de salida (JSON, markdown, XML, listas) para integración programática.
- **Structured Outputs**: Generación de salidas estructuradas con esquemas JSON predefinidos (OpenAI Structured Outputs, Anthropic tool_use).
- **Temperature / Top-p**: Parámetros que controlan la creatividad: baja temperatura para respuestas deterministas, alta para creatividad.
- **Prompt Optimization**: Iteración sistemática sobre prompts usando métricas (precisión, relevancia, adherencia a formato) y A/B testing.

## Tecnologías principales

- **Lenguajes de Prompt**: System prompts con markdown, XML, JSON, YAML para estructurar instrucciones.
- **Frameworks de Prompting**: LangChain (PromptTemplate, FewShotPromptTemplate), LlamaIndex (prompts personalizados).
- **Gestión de Prompts**: LangSmith Hub, Anthropic Console, OpenAI Playground, Google AI Studio.
- **Optimización**: DSPy (programación con prompts como módulos compilables), Promptfoo (evaluación y testing), ChainForge.
- **Seguridad**: NVIDIA NeMo Guardrails, Guardrails AI, Prompt Inject Detection (protect.ai, Lakera).
- **Evaluación**: BLEU, ROUGE, METEOR para generación; Exact Match, F1 para QA; LLM-as-judge (G-Eval, Prometheus).
- **Versionado**: Git para prompts, LangSmith Hub para versionado y reutilización.
- **Prompt Libraries**: Awesome ChatGPT Prompts, PromptHero, FlowGPT.

## Hoja de ruta

**Principiante:**
1. Estructura básica de un prompt: instrucción clara, contexto, formato esperado.
2. Zero-shot vs Few-shot: cuándo usar ejemplos y cómo seleccionarlos.
3. System prompt: definir rol y reglas. Ejemplo: "Eres un asistente experto en Python que responde con código y explicaciones."
4. Parámetros de generación: temperature, top_p, max_tokens, stop sequences.
5. Técnicas básicas: delimitadores, pedir formato estructurado (JSON, listas, tablas).

**Intermedio:**
1. Chain-of-Thought: agregar "Piensa paso a paso" y estructuras de razonamiento.
2. Prompt chaining: descomponer tareas complejas en pasos secuenciales.
3. Role prompting: asignar roles específicos (abogado, científico, profesor).
4. Iterative refinement: pedir al modelo que revise y mejore sus propias respuestas.
5. Evaluación básica: comparar respuestas, identificar sesgos, alucinaciones.

**Avanzado:**
1. Tree-of-Thoughts y Self-Consistency para problemas complejos de razonamiento.
2. ReAct: integrar herramientas y razonamiento en prompts para agentes.
3. Seguridad avanzada: detection de prompt injection, protección contra jailbreaking.
4. Prompt optimization sistemática: DSPy para optimización automática de prompts.
5. Production prompts: A/B testing, monitoreo de drift, versionado, guardrails en producción.

## Relaciones con otros módulos

- `../034-LLM/`: Modelos de lenguaje a los que se dirigen los prompts.
- `../037-AgenticAI/`: System prompts para definir comportamiento de agentes autónomos.
- `../035-RAG/`: Prompts para inyectar contexto recuperado y formatear respuestas.
- `../036-MCP/`: Prompts como recurso expuesto por servidores MCP.
- `../040-Reasoning/`: Técnicas de razonamiento (CoT, ToT) implementadas vía prompts.
- `../041-CodeGeneration/`: Prompts para generación de código y depuración.
- `../093-CommonErrors/`: Errores comunes en diseño de prompts y cómo evitarlos.

## Recursos recomendados

- **Guía**: "Prompt Engineering Guide" (promptingguide.ai) — La guía de referencia más completa.
- **Paper**: "Chain-of-Thought Prompting Elicits Reasoning in Large Language Models" (Wei et al., 2022).
- **Paper**: "Tree of Thoughts: Deliberate Problem Solving with Large Language Models" (Yao et al., 2023).
- **Paper**: "ReAct: Synergizing Reasoning and Acting in Language Models" (Yao et al., 2022).
- **Documentación**: OpenAI Prompt Engineering Guide, Anthropic Prompt Engineering, Google Prompt Design.
- **Curso**: "Prompt Engineering for LLMs" (DeepLearning.AI + OpenAI).
- **Repositorio**: "Prompt-Engineering-Guide" (dair-ai) en GitHub.
