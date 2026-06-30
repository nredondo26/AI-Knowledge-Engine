# 042-Documentation: Documentación

## Descripción ampliada del dominio

La documentación en ingeniería de software es la práctica de crear y mantener registros escritos que describen el diseño, arquitectura, funcionamiento, uso y mantenimiento de sistemas de software. Incluye documentación técnica (API, arquitectura, código, bases de datos), documentación de usuario (manuales, guías, FAQs), documentación de procesos (runbooks, playbooks, decisiones), y documentación de proyecto (roadmaps, changelogs, README). La buena documentación es esencial para: onboarding de nuevos miembros, mantenimiento a largo plazo, colaboración entre equipos, cumplimiento normativo, y continuidad del negocio. La evolución: documentación en papel (1970s-80s) → wikis (2000s, Confluence, MediaWiki) → docs-as-code (2010s, Markdown + Git, ReadTheDocs, Sphinx) → documentation generation (2020s, AI-powered, automatic docs, knowledge bases). Las tendencias actuales incluyen: documentación generada por IA (Copilot, Cursor, Mintlify), Knowledge Bases para LLMs (RAG documentation), interactive documentation (Swagger UI, Postman collections), "docs-as-code" como estándar, ADRs (Architecture Decision Records), y documentación living (actualizada automáticamente desde código y pipelines).

## Tabla de conceptos clave

| Concepto | Descripción | Herramientas/Estándares |
|----------|-------------|------------------------|
| README | Documento principal de presentación de un proyecto | Markdown, RST, AsciiDoc |
| API Documentation | Documentación de endpoints, parámetros, respuestas | OpenAPI/Swagger, GraphQL docs (GraphiQL), Postman |
| Architecture Documentation | Diagramas, decisiones, patrones, estructura del sistema | C4 model, Structurizr, PlantUML, Mermaid, ADRs |
| Code Documentation | Comentarios en código, docstrings, JSDoc, typedoc | JSDoc, Sphinx, Doxygen, Javadoc, Rustdoc |
| User Documentation | Guías, tutoriales, FAQs para usuarios finales | GitBook, Docusaurus, ReadTheDocs, MkDocs |
| Knowledge Base | Base de conocimiento centralizada (wiki) | Confluence, Notion, GitBook, Obsidian, Outline |
| Changelog | Registro de cambios por versión | Keep a Changelog, semantic-release, auto-changelog |
| ADR (Architecture Decision Record) | Documento que captura decisiones arquitectónicas importantes | ADR (Markdown), Log4bra, MADR |
| Runbook | Procedimientos operativos documentados | PagerDuty Runbooks, FireHydrant, Rundeck |
| Playbook | Guías de respuesta a incidentes | PagerDuty, Splunk SOAR, Ansible Tower |
| Docs-as-Code | Documentación tratada como código (en Git, revisada, versionada) | Markdown + Git + CI/CD + static site generator |
| Diagram as Code | Diagramas generados desde código | Mermaid, PlantUML, Diagrams (Python), D2 |
| AI Documentation | Documentación generada por modelos de lenguaje | Mintlify, Copilot Docs, Cursor Docs, MutableAI |

## Herramientas principales

| Categoría | Herramientas | Formato | Generación | Output | Caso de uso |
|-----------|-------------|---------|------------|--------|-------------|
| Static Site | Docusaurus, MkDocs, Sphinx, Hugo, Astro Starlight | Markdown, MDX, RST | Build-time | HTML/PDF site | Documentación de proyectos, API, conocimiento |
| API Docs | Swagger UI, Redoc, Stoplight, Postman | OpenAPI 3.1, AsyncAPI | Desde specs | Interactive API docs | Documentación de APIs REST/GraphQL/gRPC |
| Wiki/Knowledge | Confluence, Notion, GitBook, Outline, Slab | WYSIWYG, Markdown | Edición colaborativa | Web/wiki | Documentación interna, wikis de equipo |
| Code Docs | Sphinx (Python), JSDoc (JS), Rustdoc, Doxygen, Javadoc | Docstrings, comments | Build-time | HTML/PDF | Documentación de librerías y frameworks |
| Diagraming | Mermaid, PlantUML, Structurizr (C4), Diagrams, Draw.io | DSL (texto) | Build-time | PNG/SVG | Diagramas de arquitectura, flujo, secuencia |
| AI-Generated | Mintlify, Copilot Docs, Cursor Docs, MutableAI, GitBook AI | — | On-demand | Markdown/Text | Generación automática de documentación |
| Presentations | Slidev, Marp, Reveal.js, Deckset | Markdown, MDX | Build-time | HTML/PDF slides | Presentaciones técnicas desde markdown |

## Hoja de ruta detallada

1. **Principiante (0-1 mes)**: Escribir buenos README: nombre, descripción, instalación, uso, ejemplos, contribución, licencia. Markdown: sintaxis básica (headers, bold/italic, lists, links, images, code blocks, tables, admonitions). API documentation básica: OpenAPI/ Swagger specs (paths, methods, parameters, responses, schemas). Code documentation: docstrings (Python Sphinx style, JS JSDoc). GitBook/Docusaurus: estructurar documentación de proyecto. Estructura de documentación: getting started, guides, API reference, examples, FAQ. Changelog: keep a changelog format, version sections (added, changed, deprecated, removed, fixed, security).
   - Práctica: Escribir README completo para un proyecto personal. Documentar API con OpenAPI. Crear documentación con Docusaurus/MkDocs.
   - Lectura: "Keep a Changelog", makeareadme.com, Write the Docs guide, Google Developer Documentation Style Guide.

2. **Intermedio (1-3 meses)**: Docs-as-Code workflow: Markdown + Git + CI/CD (GitHub Pages, ReadTheDocs, Netlify). Diagram-as-code: Mermaid (flowchart, sequence, class diagram, Gantt, state diagram, pie chart), PlantUML (component, deployment, use case, activity). C4 Model: Context, Container, Component, Code diagrams con Structurizr/PlantUML. ADRs: Architecture Decision Records (format: Title, Context, Decision, Consequences, Status), ADR management (ADR tools, Log4bra). Code documentation generation: Sphinx (Python, autodoc, Napoleon Google/NumPy style), JSDoc, Rustdoc. API documentation: OpenAPI specification (paths, components, security, tags, external docs), Swagger UI/Redoc UI. Knowledge base: Confluence/Notion organization (spaces, pages, templates), git-backed documentation. Technical writing best practices: style guides (Google, Microsoft, Apple), plain language, active voice, consistent terminology.
   - Proyecto: Docs-as-Code pipeline (Markdown + Git + CI/CD + Docusaurus deploy). C4 model documentation for a project. ADR collection for architecture decisions.
   - Lectura: "Documenting Software Architectures" (Clements), C4 model (c4model.com), Write the Docs community.

3. **Avanzado (3-6 meses)**: AI-powered documentation: Copilot/Cursor generate docs from code (docstrings, function docs, README). Mintlify: auto-generate docs from codebase (GitHub integration). Documentation testing: automated documentation tests (docstrings examples testing, link checking, spelling). Documentation as code quality: Vale (proselint for docs), Alex (inclusive language), markdownlint. Living documentation: automating documentation updates from deployments, changelog from commits (semantic-release), API docs from code specs (OpenAPI code-first). Interactive documentation: runnable code examples (RunKit, CodeSandbox), interactive API playground (Postman collections, Swagger Petstore). Multi-version documentation: versioned docs (docs v1, v2), migration guides. Documentation for developers vs end-users: writing for different audiences, personas. Documentation metrics: page views, time on page, search queries, feedback ratings. Single-sourcing: writing once, publishing multiple formats (HTML, PDF, ePub, man pages). i18n for documentation: translation management, locale-specific content.
   - Proyecto: AI-generated API docs with Mintlify or Copilot. Automated changelog + API docs generation in CI/CD. Documentation quality pipeline (linters + tests).
   - Lectura: "Docs for Developers" (Bhatti), "Modern Technical Writing" (Andrew Etter), "The Product Is Docs" (McNamee).

4. **Experto (6+ meses)**: Documentation Knowledge Base for LLMs: structuring documentation for RAG (chunking, metadata, Q&A pairs, embeddings). AI-assisted documentation: generating docs from codebase (Mintlify, GitBook AI), AI copilot that answers questions from docs (docs chatbot). Documentation chatbot: RAG over documentation (LangChain + vector store), documentation as source for AI assistants. Documentation architecture for large-scale projects: docs monorepo, cross-project linking, content reuse, taxonomy. Documentation as Product: treating docs as a product (user research, metrics, testing, iteration). Compliance documentation: audit trails, regulatory documentation (SOC 2, HIPAA, PCI DSS), policy documentation. Automatic diagram generation: code → architecture diagrams (AI-powered), sequence diagrams from code. Knowledge graph from docs: extracting entities, relationships from documentation for search and AI. Documentation for AI: documentation that needs to be readable by both humans and LLMs (structured, complete, cross-linked). Enterprise documentation: SSO, permissions, version control, content lifecycle management, translation workflows.
   - Proyecto: Documentation RAG pipeline (docs → vector DB → chatbot). Architecture diagram generation from codebase. Knowledge graph from cross-project documentation.
   - Lectura: "The Knowledge Graph Cookbook", "Documentation RAG" (LangChain blog), "Docs as Product" (Write the Docs Conference talks).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [010-Architecture](../010-Architecture/) | Documentación arquitectónica (C4, ADR, diagramas) |
| [034-LLM](../034-LLM/) | LLMs generan y consumen documentación |
| [035-RAG](../035-RAG/) | Documentation as RAG source for AI assistance |
| [037-AgenticAI](../037-AgenticAI/) | Agentes que generan y mantienen documentación |
| [039-PromptEngineering](../039-PromptEngineering/) | Prompts para generar documentación |
| [041-CodeGeneration](../041-CodeGeneration/) | Code generation + documentation generation |
| [000-Core](../000-Core/) | Documentación técnica de algoritmos y estructuras |

## Recursos recomendados

- **Guías de estilo**: Google Developer Documentation Style Guide, Microsoft Style Guide, Apple Style Guide, IBM Developer Works Style Guide.
- **Herramientas de documentación**: Docusaurus (docusaurus.io), MkDocs (mkdocs.org), Sphinx (sphinx-doc.org), ReadTheDocs, Mermaid (mermaid.js.org), Structurizr (structurizr.com).
- **Herramientas de diagramas**: Mermaid, PlantUML, Diagrams (github.com/mingrammer/diagrams), Draw.io, Excalidraw.
- **Estándares**: OpenAPI 3.1, AsyncAPI, C4 Model, ADR (GitHub adr.github.io), Keep a Changelog, SemVer.
- **AI Documentation**: Mintlify, MutableAI, Copilot Docs, Cursor Docs, GitBook AI, Docusaurus AI.
- **Comunidades**: Write the Docs (writethedocs.org), Google Season of Docs, /r/technicalwriting.
- **Libros**: "Documenting Software Architectures" (Clements), "Docs for Developers" (Bhatti), "The Product Is Docs" (McNamee), "Modern Technical Writing" (Etter), "Docs Like Code" (Gentle).

## Notas adicionales

La buena documentación es una inversión con ROI alto (reduce onboarding, bugs, interrupciones). "Docs-as-Code" es el estándar moderno: documentación en Git, versionada, revisada. Los diagramas como código (Mermaid, PlantUML) mantienen la documentación actualizada con el código. La generación de documentación con IA (Mintlify, Copilot) reduce significativamente el esfuerzo. La documentación debe ser un artefacto de primera clase en el repositorio, no un afterthought. RAG sobre documentación es la forma más efectiva de crear asistentes de documentación. La documentación para IA (estructurada, enlazada, completa) es una habilidad emergente. La documentación viviente (actualizada automáticamente) es el ideal.
