# 043-Templates: Plantillas y Scaffolds

## Descripción del dominio

Las plantillas y scaffolds aceleran la creación de proyectos al proporcionar estructuras predefinidas, configuración inicial y código repetitivo listo para usar. Este módulo cubre herramientas como cookiecutter, Yeoman y generadores de proyectos, así como la creación y mantenimiento de repositorios plantilla (template repositories) en plataformas como GitHub y GitLab. Se exploran patrones de scaffolding para diferentes tipos de proyectos (aplicaciones web, bibliotecas, paquetes Python, microservicios, proyectos de IA/ML) y buenas prácticas para mantener las plantillas actualizadas con las últimas versiones de dependencias y convenciones.

## Conceptos clave

- **Cookiecutter**: Herramienta CLI que crea proyectos a partir de plantillas con variables, prompts interactivos y hooks pre/post generación
- **Yeoman**: Sistema de scaffolding con generadores (webapp, node, angular, react) y ecosistema de plugins
- **Repositorios plantilla (GitHub/GitLab)**: Template repositories que permiten crear nuevos repositorios con la misma estructura
- **Boilerplates**: Conjuntos de código repetitivo predefinido para evitar tareas tediosas (configuración de webpack, babel, ESLint, etc.)
- **Starter kits**: Proyectos completos y funcionales listos para modificar (Create React App, Next.js starter, Express generator)
- **Scaffolding personalizado**: Scripts de generación con prompts, argumentos CLI, integración con gestores de paquetes
- **Hooks**: Pre-generación (validación de entrada) y post-generación (npm install, git init, configuración inicial)
- **Variables y prompts**: Jinja2 (en cookiecutter), Handlebars, EJS para interpolación en plantillas
- **Mantenimiento de plantillas**: Dependencias actualizadas, versionado semántico, changelogs, tests automatizados de plantillas
- **Plantillas de IA/ML**: Cookiecutter Data Science, ML Project Template, Kedro project template, Copier para proyectos de ML

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Herramientas de scaffolding | Cookiecutter, Yeoman, Copier, Scaffold, Plop (micro-generators) |
| Repositorios plantilla | GitHub Template Repos, GitLab Template, Bitbucket Workspace Templates |
| Motores de plantillas | Jinja2, Handlebars, EJS, Mustache, Nunjucks, Pug |
| Starter kits populares | Create React App, Vite (create-vite), Next.js (create-next-app), Express Generator |
| Plantillas de datos | Cookiecutter Data Science, Kedro Starter, PySpark Template |
| Frameworks de generación | JHipster (full-stack web), Nx (monorepos), Turborepo, Lerna |
| Scaffolding cloud | AWS SAM Init, CDK Init, Terraform Starter, Pulumi Templates |

## Hoja de ruta

1. **Principiante**: Uso de templates existentes (cookiecutter) — creación de proyectos con starters — personalización de variables en cookiecutter.json
2. **Intermedio**: Creación de plantillas cookiecutter propias — hooks pre/post generación — organización de repositorios plantilla en GitHub — scaffolding para librerías
3. **Avanzado**: Plantillas con múltiples opciones (framework, ORM, testing) — generadores interactivos con prompts — testing de plantillas (pytest + cookiecutter) — integración en CICD
4. **Experto**: Ecosisstemas de generación multi-repositorio — generadores basados en IA — scaffolding con análisis de código existente — plantillas corporativas centralizadas con actualización automática

## Relaciones con otros módulos

- [046-BestPractices](../046-BestPractices/) — Convenciones y estructura que deben reflejar las plantillas
- [072-Community](../072-Community/) — Plantillas comunitarias mantenidas por la organización
- [013-DevOps](../013-DevOps/) — Plantillas de infraestructura como código (Docker, Terraform)
- [014-CICD](../014-CICD/) — Pipeline CI/CD preconfigurados en las plantillas
- [063-Examples](../063-Examples/) — Proyectos de ejemplo que pueden servir como inspiración para plantillas
- [044-ReferenceProjects](../044-ReferenceProjects/) — Proyectos de referencia con arquitecturas que pueden templatearse
- [052-Standards](../052-Standards/) — Estándares de estructura de proyectos

## Recursos recomendados

- **Documentación**: Cookiecutter Documentation, Yeoman Getting Started, GitHub Docs (Template Repositories)
- **Repositorios**: "cookiecutter-django", "cookiecutter-flask", "cookiecutter-data-science", "copier-template"
- **Cursos**: PluralSight "Creating Project Scaffolds with Cookiecutter", "Yeoman: Create Your Own Generators"
- **Artículos**: "The Art of Scaffolding" (ThoughtWorks), "Project Templates for Your Organization" (Medium)
