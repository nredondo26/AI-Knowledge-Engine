# System Prompts

## Descripción del dominio

Los System Prompts (o instrucciones de sistema) son mensajes iniciales que definen el rol, personalidad, reglas, restricciones y contexto de comportamiento de un modelo de lenguaje (LLM) durante toda una conversación. A diferencia de los user prompts (que cambian con cada interacción), el system prompt se mantiene constante y establece el "carácter" del asistente: cómo debe responder, qué tono usar, qué información debe priorizar, qué reglas debe seguir y qué límites no debe cruzar. Un system prompt bien diseñado es la diferencia entre un asistente genérico y uno especializado efectivo. Los system prompts son el mecanismo principal para configurar agentes autónomos, asistentes especializados, chatbots de servicio al cliente, tutores, y cualquier aplicación donde el LLM deba mantener un comportamiento consistente. La ingeniería de system prompts incluye técnicas de role prompting, estructuración de instrucciones, definición de reglas, formato de salida esperado, y gestión de límites éticos y de seguridad.

## Conceptos clave

- **Role Definition**: Asignación de un rol al LLM (experto, tutor, asistente, agente, consejero). Define la perspectiva y autoridad del modelo.
- **Personality Traits**: Atributos de personalidad (formal, amigable, conciso, analítico, creativo, empático). Afecta el tono y estilo de las respuestas.
- **Rules and Constraints**: Reglas explícitas que el LLM debe seguir: no inventar información, no dar consejo médico, no ejecutar código peligroso, mantener confidencialidad.
- **Output Formatting**: Especificación del formato de respuesta: JSON, markdown, XML, bullet points, tablas, código con sintaxis destacada.
- **Context Provision**: Información de contexto relevante que el LLM debe conocer: ámbito, audiencia, propósito de la conversación.
- **Guardrails**: Límites de comportamiento: temas prohibidos, acciones restringidas, niveles de seguridad.
- **Instruction Prioritization**: Ordenamiento de instrucciones por importancia. Las primeras instrucciones suelen tener más peso.
- **Few-Shot Examples in System Prompt**: Ejemplos de interacción deseada incluidos en el system prompt para mostrar el tono y formato esperados.
- **Behavioral Guidelines**: Guías de comportamiento: pedir aclaraciones si falta información, admitir ignorancia, ofrecer alternativas.
- **Token Budget Management**: Gestión del espacio del system prompt para no consumir demasiado contexto de la ventana disponible.

## Ejemplo: System prompt para asistente técnico

```
Eres un asistente técnico experto en Python y desarrollo de software.
Tu personalidad es profesional, precisa y pedagógica.

REGLAS:
- Responde siempre en español (a menos que la pregunta sea en otro idioma).
- Proporciona código Python funcional y probado.
- Explica el código paso a paso, asumiendo un nivel intermedio de conocimientos.
- Si no sabes la respuesta, admítelo y sugiere dónde buscar.
- NUNCA inventes APIs, funciones o bibliotecas que no existen.
- Si el código podría ser peligroso (ejecución de comandos, acceso a archivos), incluye una advertencia.

FORMATO DE RESPUESTA:
1. Breve explicación del enfoque
2. Código en bloque ```python
3. Explicación línea por línea de las partes clave
4. Ejemplo de uso
5. Posibles variaciones o mejoras

RESTRICCIONES:
- No proporciones consejos médicos, legales o financieros.
- No generes contenido ofensivo, discriminatorio o ilegal.
- No ejecutes código en el entorno del usuario sin su consentimiento explícito.
```

## Ejemplo: System prompt para agente RAG

```
Eres un asistente especializado en Retrieval Augmented Generation (RAG).
Tu función es responder preguntas basándote EXCLUSIVAMENTE en el contexto proporcionado.

INSTRUCCIONES:
1. Lee cuidadosamente el contexto recuperado de los documentos.
2. Responde solo con información que esté respaldada por el contexto.
3. Si el contexto no contiene suficiente información para responder, di:
   "No encontré información suficiente en los documentos disponibles para responder esta pregunta."
4. No uses tu conocimiento interno. Tus respuestas deben estar 100% fundamentadas.
5. Cuando uses información del contexto, cita la fuente incluyendo el nombre del documento y el fragmento relevante.

FORMATO DE RESPUESTA:
**Respuesta:** [respuesta directa a la pregunta]

**Fuentes:**
- [Nombre del documento 1]: [cita textual]
- [Nombre del documento 2]: [cita textual]

**Contexto usado:**
[Breve resumen de qué partes del contexto se usaron]

CONTEXTO RECUPERADO:
{context}
```

## Elementos de un system prompt efectivo

| Elemento | Descripción | Ejemplo |
|---|---|---|
| Rol | Define quién es el asistente | "Eres un tutor de matemáticas" |
| Tono | Estilo de comunicación | "Responde de manera amigable y alentadora" |
| Reglas | Comportamientos obligatorios | "Nunca des la respuesta directa, guía al estudiante" |
| Formato | Estructura de la respuesta | "Usa formato markdown con secciones" |
| Límites | Lo que no debe hacer | "No resuelvas la tarea, solo ayuda" |
| Contexto | Información de fondo | "El usuario está en 2º de secundaria" |
| Ejemplos | Modelos de interacción | "Ejemplo de buena respuesta: ..." |

## Patrones comunes

- **Role Prompting**: "Eres un abogado especializado en propiedad intelectual..."
- **Persona Prompting**: "Eres un chef italiano apasionado por la cocina tradicional..."
- **Instruction Stacking**: Lista numerada de instrucciones en orden de prioridad.
- **Constraint-Based**: Definir qué NO hacer en lugar de qué hacer.
- **Structured Output**: "Responde en formato JSON con keys: respuesta, confianza, fuentes."
- **Chain of Density**: System prompt que pide respuestas progresivamente más densas en información.

## Relaciones con otros módulos

- `../FewShot/`: Combinación de system prompt + ejemplos few-shot para comportamiento completo.
- `../Safety/`: Guardrails de seguridad integrados en system prompts.
- `../Optimization/`: Optimización de system prompts mediante iteración y A/B testing.
- `../Evaluation/`: Evaluación de adherencia al system prompt.
- `../../037-AgenticAI/`: System prompts como definición de personalidad de agentes.
- `../../036-MCP/Prompts/`: Prompts MCP equivalentes a system prompts reutilizables.

## Recursos recomendados

- **Guía**: "System Prompt Best Practices" (Anthropic, OpenAI, Google).
- **Paper**: "The Power of Prompting: System Prompts in Large Language Models" (2024).
- **Recursos**: Awesome System Prompts (GitHub), PromptHub.
- **Blog**: "How to Write Effective System Prompts" (Anthropic).
- **Video**: "System Prompt Engineering" (Prompt Engineering YouTube).
