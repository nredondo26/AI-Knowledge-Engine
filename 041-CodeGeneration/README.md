# 041-CodeGeneration: Generación de Código

## Descripción del dominio

La generación de código mediante inteligencia artificial ha revolucionado la productividad del desarrollo de software. Este módulo cubre las herramientas, modelos y técnicas utilizados para generar, completar, refactorizar y traducir código fuente de forma automática. Abarca desde asistentes de código comerciales como GitHub Copilot y Cursor hasta modelos open-source como CodeLlama, DeepSeek-Coder y StarCoder. Se exploran las arquitecturas subyacentes (transformers entrenados en código), técnicas de fine-tuning para generación de código, evaluación de calidad del código generado y consideraciones éticas sobre propiedad intelectual y seguridad.

## Conceptos clave

- **Modelos de generación de código**: Codificadores-decodificadores basados en transformers, modelos solo decoder (GPT-style) pre-entrenados en repositorios de código
- **Fill-in-the-Middle (FIM)**: Técnica de entrenamiento donde el modelo predice el código faltante entre un contexto izquierdo y derecho
- **Infilling**: Capacidad de rellenar bloques de código en medio de una función, clase o método
- **Completado de código**: Predicción línea a línea, sugerencias inline, autocompletado multicursor
- **Generación de código natural a código**: Transformar descripciones en lenguaje natural a código ejecutable (text-to-code)
- **Refactorización automática**: Renombrado, extracción de métodos, cambio de firma, migración entre versiones de APIs
- **Traducción entre lenguajes**: Transpilación automática (Python ↔ JavaScript, Java ↔ Kotlin, etc.)
- **Reparación automática de bugs**: Program Repair, APR (Automated Program Repair), parches generados por LLM
- **Fine-tuning específico**: LoRA, QLoRA, adaptación a bases de código propietarias, estilos de codificación corporativos
- **Evaluación de código generado**: HumanEval, MBPP, CodeXGLUE, pass@k, tasa de aceptación, corrección sintáctica y semántica
- **Seguridad en generación de código**: Inyección de código, jailbreaks, verificación de dependencias, código vulnerable generado

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Asistentes comerciales | GitHub Copilot, Cursor, Amazon CodeWhisperer (Q Developer), Tabnine, Codeium |
| Modelos open-source | CodeLlama (Meta), DeepSeek-Coder, StarCoder/StarCoder2 (BigCode), CodeGen, PolyCoder |
| Frameworks de fine-tuning | Hugging Face Transformers + PEFT, Unsloth, Axolotl, LitGPT |
| Evaluación | HumanEval, MBPP, BigCodeBench, CodeXGLUE, EvalPlus, LiveCodeBench |
| Entornos integrados | VS Code + Copilot extension, JetBrains AI Assistant, Cursor IDE, Replit AI |
| Transpilación | j2py (Java to Python), ts2py, TypeScript compiler API, Babel |

## Hoja de ruta

1. **Principiante**: Uso básico de GitHub Copilot en IDE — comandos de chat — comprensión de sugerencias — aceptación y rechazo de código generado
2. **Intermedio**: Personalización de asistentes (comentarios estructurados, contexto adecuado) — evaluación de calidad — configuración de Copilot/Cursor — generación de tests unitarios
3. **Avanzado**: Fine-tuning de CodeLlama/DeepSeek-Coder con LoRA en base de código propia — implementación de pipelines de code generation — evaluación con HumanEval — técnicas FIM
4. **Experto**: Implementación de sistemas multi-agente para generación de código — verificación formal de código generado — modelos de razonamiento de código — integración en CICD con revisión automática

## Relaciones con otros módulos

- [034-LLM](../034-LLM/) — Modelos base sobre los que se construyen los generadores de código
- [037-AgenticAI](../037-AgenticAI/) — Agentes que escriben, ejecutan y depuran código de forma autónoma
- [040-Reasoning](../040-Reasoning/) — Razonamiento necesario para generar código lógicamente correcto
- [039-PromptEngineering](../039-PromptEngineering/) — Ingeniería de prompts para descripciones precisas de código deseado
- [015-Automation](../015-Automation/) — Automatización de flujos que incluyen generación de código
- [012-Testing](../012-Testing/) — Tests generados automáticamente y verificación de código generado
- [046-BestPractices](../046-BestPractices/) — Guías de estilo para código generado por IA

## Recursos recomendados

- **Libros**: "Generative AI for Software Development" (Denny), "AI-Assisted Programming" (Raheja), "The Programmer's Guide to AI"
- **Papers**: "Evaluating Large Language Models Trained on Code" (Codex, Chen et al., 2021), "CodeLlama: Open Foundation Models for Code" (Rozière et al., 2023), "StarCoder: May the Source Be with You" (Li et al., 2023)
- **Repositorios**: GitHub Copilot Docs, BigCode Project, DeepSeek-Coder, HumanEval (OpenAI)
- **Herramientas**: Continue.dev (asistente open-source en IDE), Aider (pair programming con LLM en CLI), Sweep AI (PR automation)
