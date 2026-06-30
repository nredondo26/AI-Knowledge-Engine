# 074-Tools — Herramientas de Desarrollo

## Descripción del dominio

Abarca el conjunto de herramientas esenciales que todo desarrollador utiliza en su flujo de trabajo diario: editores de código, linters, formateadores, debuggers, profilers, herramientas CLI, gestores de paquetes y utilidades de productividad. La selección y configuración adecuada de estas herramientas impacta directamente en la calidad del código, la velocidad de desarrollo y la experiencia del desarrollador.

## Conceptos clave

- **Editor / IDE**: Entorno donde se escribe y edita código (VS Code, Vim, IntelliJ).
- **Linter**: Herramienta que analiza código en busca de errores, malas prácticas y violaciones de estilo (ESLint, Pylint, RuboCop).
- **Formatter**: Herramienta que aplica formato consistente al código automáticamente (Prettier, Black, rustfmt, gofmt).
- **Debugger**: Herramienta para ejecutar código paso a paso, inspeccionar variables y entender el flujo de ejecución (gdb, lldb, pdb, Chrome DevTools).
- **Profiler**: Herramienta que mide el rendimiento del código, uso de CPU, memoria y cuellos de botella (cProfile, Valgrind, perf, Chrome DevTools).
- **Package Manager**: Gestor de dependencias (npm, pip, cargo, go mod, apt, brew).
- **Build Tool**: Herramienta de compilación y empaquetado (webpack, esbuild, Maven, Gradle, make, cmake).
- **Task Runner**: Herramienta para automatizar tareas repetitivas (Makefile, npm scripts, Just, Task).
- **Version Control System (VCS)**: Sistema de control de versiones (Git, Mercurial).
- **Dotfiles**: Archivos de configuración del entorno de desarrollo gestionados con versiones.
- **Terminal Emulator**: Aplicación de terminal (iTerm2, Kitty, Alacritty, Windows Terminal).

## Tecnologías principales

### Linters y Formatters
- **ESLint**: Linter para JavaScript/TypeScript.
- **Prettier**: Formateador universal de código.
- **Black**: Formateador oficial de Python.
- **rustfmt**: Formateador oficial de Rust.
- **gofmt**: Formateador oficial de Go.
- **ruff**: Linter rápido escrito en Rust para Python.

### Debuggers y Profilers
- **Chrome DevTools**: Debugger y profiler para aplicaciones web.
- **pdb / ipdb**: Debugger interactivo de Python.
- **gdb / lldb**: Debuggers para C/C++/Rust.
- **Valgrind**: Herramienta de profiling de memoria.
- **perf**: Profiler de sistema Linux.
- **flamegraph**: Visualización de perfiles de rendimiento.

### Gestores de Paquetes
- **npm / yarn / pnpm**: Gestores de paquetes JavaScript.
- **pip / poetry / uv**: Gestores de paquetes Python.
- **cargo**: Gestor de paquetes Rust.
- **go mod**: Gestor de módulos Go.
- **apt / brew / choco**: Gestores de paquetes del sistema.

## Hoja de ruta

1. **Principiante**: Configurar un editor con linter y formatter básicos. Aprender a usar el debugger integrado. Familiarizarse con el gestor de paquetes del lenguaje principal.
2. **Intermedio**: Configurar pre-commit hooks con Husky o pre-commit. Usar tareas automatizadas (Makefile, npm scripts). Integrar profiling básico en el flujo de trabajo. Gestionar dotfiles con Git.
3. **Avanzado**: Crear herramientas CLI propias. Contribuir a herramientas open-source. Configurar entornos de desarrollo reproducibles (Dev Containers, Nix). Implementar toolchains multi-lenguaje.

## Relaciones con otros módulos

- [`../075-IDEs/`](../075-IDEs/) — Los IDEs integran linters, debuggers y formatters como plugins o funcionalidades nativas.
- [`../076-Extensions/`](../076-Extensions/) — Extensiones que añaden funcionalidades de herramientas a los editores.
- [`../077-CLI/`](../077-CLI/) — Muchas herramientas de desarrollo se usan desde la línea de comandos.
- [`../013-DevOps/`](../013-DevOps/) — Herramientas de build, test y deploy integradas en pipelines.
- [`../046-BestPractices/`](../046-BestPractices/) — Buenas prácticas de configuración y uso de herramientas.
- [`../093-CommonErrors/`](../093-CommonErrors/) — Errores comunes con herramientas y sus soluciones.

## Recursos recomendados

- [Awesome Development Tools](https://github.com/awesome-dev-tools) — Lista curada de herramientas de desarrollo.
- [Prettier](https://prettier.io/) — Formateador de código opinionado.
- [ESLint](https://eslint.org/) — Linter para JavaScript/TypeScript.
- [Valgrind](https://valgrind.org/) — Instrumentación para profiling de memoria.
- [DevDocs](https://devdocs.io/) — Documentación combinada para múltiples herramientas.
- [Dotfiles GitHub](https://dotfiles.github.io/) — Guía de gestión de dotfiles.
