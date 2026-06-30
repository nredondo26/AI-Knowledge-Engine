# 041-CodeGeneration: Generación de Código

## Descripción ampliada del dominio

La generación de código por IA utiliza modelos de lenguaje (LLMs) y modelos especializados para generar, completar, explicar, traducir, depurar y refactorizar código fuente en múltiples lenguajes de programación. Esta tecnología está transformando el desarrollo de software al aumentar la productividad de los desarrolladores, automatizar tareas repetitivas y democratizar la programación. Las herramientas principales incluyen: GitHub Copilot (basado en GPT-4/OpenAI Codex), Cursor (IDE con AI integrada), Amazon CodeWhisperer (Q Developer), Google Gemini Code Assist, Codeium, y Replit AI. La evolución: autocompletado basado en reglas/templates (1990s-2010s) → autocompletado estadístico (TabNine, 2018) → Codex/GPT-3 fine-tuned (2021, OpenAI, GitHub Copilot) → StarCoder, Code Llama, DeepSeek Coder (modelos open, 2023) → agentes de código (Devin, SWE-agent, Cursor Agent, CodeAct, 2024) → razonamiento profundo para código (Claude Code, OpenAI o1, 2024-25). Los benchmarks principales son: HumanEval (Python function completion), MBPP (programming problems), SWE-Bench (real GitHub issue resolution), BigCodeBench y DS-1000 (data science).

## Tabla de conceptos clave

| Concepto | Descripción | Herramientas/Modelos |
|----------|-------------|---------------------|
| Code Completion | Autocompletado de código mientras se escribe | GitHub Copilot, TabNine, Codeium, Supermaven |
| Code Generation from Prompt | Generar código a partir de descripción en lenguaje natural | GPT-4, Claude, Copilot Chat, Cursor |
| Code Review | Revisión automática de código por IA | GitHub Copilot Code Review, Cursor, CodeRabbit |
| Code Translation | Traducir código entre lenguajes | GPT-4, Claude, Code Llama |
| Bug Fixing | Identificar y corregir bugs automáticamente | SWE-agent, GPT-4 o1, Claude Code |
| Refactoring | Mejorar estructura de código sin cambiar comportamiento | Cursor, Copilot, Codeium |
| Test Generation | Generar tests unitarios automáticamente | Copilot, Cursor, Diffblue Cover, EvoSuite |
| Documentation Generation | Generar documentación de código automáticamente | Copilot, Mintlify, MutableAI |
| Code Explanation | Explicar código en lenguaje natural | Cursor, Copilot Chat, Code Explain (GPT-4) |
| Agentic Code Generation | Agente autónomo que escribe y prueba código | Devin, SWE-agent, Cursor Agent, CodeAct |
| Synthetic Data Generation | Generación de datos de entrenamiento sintéticos | GPT-4, Claude, Code gen models |
| RAG for Code | Retrieval augmented generation para contexto de código | Copilot (repo context), Continue.dev |

## Tecnologías principales

| Herramienta/Modelo | Tipo | Lenguajes | Modalidad | Integración | Precio |
|--------------------|------|-----------|-----------|-------------|--------|
| GitHub Copilot | Asistente | Todos principales | Completion + Chat | VS Code, JetBrains, Neovim | $10/mes (Individual) |
| Cursor | IDE + AI | Todos | Edición + Chat + Agent | IDE propio (VS Code fork) | $20/mes (Pro) |
| Codeium/Windsurf | Asistente | 70+ | Completion + Chat + Agent | VS Code, JetBrains, Chrome | Gratis/Pro |
| Amazon Q Developer | Asistente | 15+ | Completion + Chat + Security | VS Code, JetBrains, IntelliJ | Gratis/Pro |
| Claude Code | CLI Agent | Todos | Terminal Agent + Edit | CLI | API (pago por uso) |
| OpenAI o1/o3 | Model | Todos | Reasoning + Code | API + ChatGPT | API (pago por uso) |
| GPT-4o | Model | Todos | Completion + Chat + Multi-modal | API + ChatGPT | API (pago por uso) |
| DeepSeek Coder V2 | Model (open) | 338 lenguajes | Completion + Fill-in-Middle | API + local | Open / API |
| Code Llama | Model (open) | Code specialized | Completion + Infill | Local + API | Open |
| StarCoder2 | Model (open) | 619 lenguajes | Completion + Fill-in-Middle | Hugging Face + local | Open |
| Continue.dev | Open source tool | Todos | Completion + Chat + Agent | VS Code, JetBrains | Gratuito |

## Hoja de ruta detallada

1. **Principiante (0-2 semanas)**: Conceptos: qué es code generation, cómo funcionan los modelos de código (autocompletado, fill-in-middle, prompt-to-code). GitHub Copilot: instalar extensión, trigger completions (Tab), accept/cycle/ignore, write comments → Copilot generates code. Cursor: install, Ctrl+K for inline edit, Ctrl+L for chat. Copilot Chat: conversational code help, "explain this", "fix this", "optimize this". Writing good prompts for code: specific requirements, example inputs/outputs, constraints, error handling. Understanding model limitations: hallucination, incorrect imports, style variations, edge cases. Review AI-generated code: testing, validation, security review.
   - Práctica: Usar Copilot/Cursor para un proyecto personal. Generar código desde comentarios. Usar chat para explicar y depurar.
   - Lectura: GitHub Copilot docs, Cursor docs, OpenAI code generation best practices.

2. **Intermedio (2-4 semanas)**: Prompt engineering for code: system prompts (language, framework, style), few-shot examples (function signature + docstring → implementation), multi-step prompts. Code review with AI: Cursor Agent, Copilot Code Review, PR summary generation. Test generation: prompts for unit tests (edge cases, mocks, parameterized tests), Copilot test generation. Code translation: Python → JavaScript, JavaScript → TypeScript, legacy → modern. Refactoring: extract function, rename, restructure, pattern migration. Fill-in-Middle (FIM): cursor → fill code (used for inline completions). Context optimization: including relevant files, imports, type definitions. Security review of AI-generated code: SQL injection, XSS, hardcoded secrets, insecure deserialization. Debugging: prompts for bug explanation and fix. Multi-file projects: context across files, understanding project structure. Documentation: generating docstrings, comments, API reference, README.

   - Práctica: Generate tests for existing code with Copilot. Translate a module between languages. Code review your own project with AI.
   - Lectura: "Evaluating Large Language Models Trained on Code" (Codex paper, 2021), "Code Llama" (Rozière, 2023).

3. **Avanzado (4-8 semanas)**: Agentic code generation: Devin (SWE-bench), SWE-agent (agent fixes GitHub issues), Cursor Agent (autonomous code edit, terminal, debug). Agent loop: plan → code → run → fix → commit. Multi-file changes: agent that edits multiple files, runs linters, runs tests, reviews diff. Code generation with tools: agent can run commands, install packages, check syntax, run tests. Codebase RAG: indexing codebase, retrieving relevant context (functions, classes, docs) for generation. Fine-tuning code models: LoRA fine-tuning of Code Llama, StarCoder on custom codebase. Custom completions: continue.dev with local models, custom rules, tab-autocomplete. Evaluation: HumanEval (pass@k), MBPP, SWE-bench (issue resolution), personal code benchmarks. Security: sandboxing code execution, safe execution container, prompt injection in code generation. Reproducibility: deterministic generation (temperature=0, seed), versioning of generated code. Cost optimization: model selection (open vs API, size), caching similar completions, context optimization.
   - Proyecto: Cursor Agent for automated task (edit a React component with tests). SWE-agent to fix a real open source issue. Fine-tune Code Llama on a specific coding style.
   - Certificación: GitHub Copilot certification (beta, free), no standard code-gen certs.
   - Lectura: "SWE-bench" (Jimenez, 2024), "Devin" (Cognition, 2024), "Code as Policies" (Liang, 2022).

4. **Experto (8+ semanas)**: Multi-step code reasoning: models that reason before generating code (Claude extended thinking, o1), planning step-by-step code architecture. Automated code refactoring at scale: large-scale migration, API upgrades, framework migration. Code generation for unit tests: EvoSuite, Diffblue, automated generation + mutation testing. Formal verification + code generation: generating verified code, Lean proofs for code correctness. Self-improving code agents: agent that writes code, tests it, fixes bugs, learns from mistakes. Multi-agent code generation: architect agent (design), coder agent (implement), tester agent (test), reviewer agent (review). Code generation + execution: agent writes code, executes securely, checks results, iterates. In-IDE advanced AI: deep codebase understanding, AST-level operations, custom refactoring rules. AI-native IDEs: Cursor, Zed (AI first), VS Code + Copilot, JetBrains AI. Code generation safety: backdoor detection, vulnerability scanning, supply chain security for generated dependencies. Enterprise code generation: compliance with coding standards, license compliance (generated code license?), internal style guides.
   - Proyecto: Multi-agent system for software development (spec → code → test → review → merge). Code generation with formal verification integration. Enterprise code generation pipeline with compliance and security checks.
   - Lectura: "Verified Code Generation" papers, o1 reasoning report, "SWE-agent" papers, "ChatDev" (Qian, 2023), "MetaGPT" (Hong, 2023).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [001-Languages](../001-Languages/) | Code generation produce código en estos lenguajes |
| [031-AI](../031-AI/) | Base de IA para code generation |
| [034-LLM](../034-LLM/) | LLMs son la base de los modelos de código |
| [037-AgenticAI](../037-AgenticAI/) | Code agents son aplicación de agentes |
| [039-PromptEngineering](../039-PromptEngineering/) | Prompting específico para generación de código |
| [040-Reasoning](../040-Reasoning/) | Razonamiento para planificación de código |
| [042-Documentation](../042-Documentation/) | Generación de documentación de código |

## Recursos recomendados

- **Modelos**: GPT-4o, Claude 3.5 Sonnet, DeepSeek Coder V2, Code Llama, StarCoder2, Qwen2.5-Coder.
- **Herramientas**: GitHub Copilot, Cursor, Codeium/Windsurf, Continue.dev, Amazon Q, Claude Code.
- **Benchmarks**: HumanEval, MBPP, SWE-Bench, BigCodeBench, DS-1000 (data science), CodeXGLUE.
- **Papers**: "Codex" (Chen, 2021), "Code Llama" (Rozière, 2023), "StarCoder" (Li, 2023), "SWE-bench" (Jimenez, 2024), "Self-Refine" (Madaan, 2023).
- **Comunidad**: GitHub Copilot Community, Cursor Discord, Continue.dev Discord, Hugging Face BigCode.
- **Cursos**: DeepLearning.AI "Pair Programming with LLMs" (Andrew Ng), "Building Applications with Vector Databases" (includes code gen).

## Notas adicionales

La generación de código es la aplicación más impactante de IA en productividad de desarrollo. Copilot y Cursor son las herramientas más usadas. Para generación de código autónomo (agentes), SWE-bench es el benchmark de referencia. El modelo DeepSeek Coder V2 es el mejor modelo open-weight para código. La calidad del contexto (archivos relevantes, imports, project structure) es más importante que la calidad del modelo. Los agentes de código representan el futuro: no solo completan código, sino que planifican, implementan, prueban y depuran. La seguridad del código generado debe ser revisada — los modelos pueden introducir vulnerabilidades. La verificación formal de código generado es la frontera de investigación. El avance más importante de 2024/25 es la integración de razonamiento profundo (o1, extended thinking) en code generation.
