# 042-Documentation: Documentación Técnica

## Descripción del dominio

La documentación técnica es un pilar fundamental del desarrollo de software sostenible. Este módulo cubre las herramientas, formatos y metodologías para crear, mantener y publicar documentación clara y útil para desarrolladores, usuarios finales y equipos de producto. Incluye desde la escritura de docstrings y documentación de APIs hasta la generación de sitios completos de documentación con Sphinx, Docusaurus, MkDocs y ReadTheDocs. Se abordan también buenas prácticas de escritura técnica, documentación de arquitecturas con diagramas (Mermaid, PlantUML) y la automatización de la documentación en pipelines de CI/CD.

## Conceptos clave

- **Markdown y lenguajes de marcado ligero**: Markdown (GFM), reStructuredText (reST), AsciiDoc, MyST (Markedly Structured Text)
- **Docstrings**: Formatos estándar (Google style, NumPy/SciPy style, Sphinx/reST, Epytext), extracción automática
- **Sphinx**: Generador de documentación para Python, extensiones (autodoc, napoleon, autosummary), themes (ReadTheDocs, Alabaster, Furo)
- **Docusaurus**: Framework de documentación basado en React, versionado, i18n, búsqueda, blogs, MDX
- **MkDocs**: Generador estático de documentación, Material for MkDocs, plugins (autodoc, macros, diagrams)
- **ReadTheDocs**: Plataforma de hosting para documentación, integración con GitHub/GitLab, versionado automático
- **Documentación de APIs**: OpenAPI/Swagger, Postman, Redoc, Stoplight, GraphQL (Apollo, GraphiQL)
- **Documentación de componentes**: Storybook para UI, Compodoc para Angular, JSDoc, TypeDoc, rustdoc, godoc
- **Diagramas como código**: Mermaid, PlantUML, Diagrams (Python), Structurizr (C4 model)
- **Escritura técnica**: Manual de estilo, guías de contribución, documentación de usuario vs desarrollador, changelogs, FAQs
- **Automatización**: CI/CD para docs, linting de markdown (markdownlint, vale), spellcheck, comprobación de enlaces rotos

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Generación de documentación | Sphinx, Docusaurus, MkDocs, Jekyll, Hugo, VuePress |
| Hosting | ReadTheDocs, GitHub Pages, GitLab Pages, Netlify, Vercel |
| Documentación de APIs | Swagger/OpenAPI, Redoc, Stoplight, Postman, Insomnia |
| Docstrings | Google style, NumPy style, Sphinx autodoc, JSDoc, TypeDoc |
| Diagramas | Mermaid, PlantUML, Diagrams (py), Draw.io, Structurizr |
| Linters | markdownlint, vale (prosa), textlint, write-good, alex |
| Herramientas de equipo | Notion, Confluence, Slab, GitBook, Outline |

## Hoja de ruta

1. **Principiante**: Sintaxis Markdown — escritura de README claro — docstrings básicos en Python/JS — GitHub Pages básico
2. **Intermedio**: Sphinx/MkDocs con temas y plugins — documentación de APIs con OpenAPI — diagramas Mermaid — documentación de componentes con Storybook
3. **Avanzado**: Docusaurus con versionado, búsqueda, i18n — automatización de docs en CI/CD — documentación de arquitectura con C4 model — linting de documentación
4. **Experto**: Sistemas de documentación multi-repositorio — documentación generada por IA (LLM + retrieval) — guías de estilo corporativas — documentación interactiva con notebooks (Jupyter Book, Quarto)

## Relaciones con otros módulos

- [041-CodeGeneration](../041-CodeGeneration/) — Generación automática de documentación a partir de código
- [039-PromptEngineering](../039-PromptEngineering/) — Prompts para generar documentación técnica con IA
- [026-Web](../026-Web/) — Frameworks web (Docusaurus, VuePress) para sitios de documentación
- [014-CICD](../014-CICD/) — Pipelines de integración continua que validan y publican documentación
- [052-Standards](../052-Standards/) — Estándares de documentación (ISO/IEC, IEEE, Google Style Guide)
- [055-Checklists](../055-Checklists/) — Listas de verificación para calidad de documentación
- [079-APIs](../079-APIs/) — Documentación de APIs como interfaz entre servicios

## Recursos recomendados

- **Libros**: "Documenting Software Architectures" (Clements et al.), "The Product is Docs" (Spotify), "Docs for Developers" (Stevens)
- **Cursos**: "Technical Writing" (Google Developer Documentation), "Documentation Engineering" (Write the Docs), Coursera "Software Documentation"
- **Herramientas**: Material for MkDocs, Sphinx + autodoc, Docusaurus, ReadTheDocs, Mermaid Live Editor
- **Comunidad**: Write the Docs (conferencias, slack), Google Developer Documentation Style Guide, Diátaxis Framework
