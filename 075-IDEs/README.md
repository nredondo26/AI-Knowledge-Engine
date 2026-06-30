# 075-IDEs — Entornos de Desarrollo

## Descripción del dominio

Los Entornos de Desarrollo Integrado (IDEs) son aplicaciones que proporcionan herramientas completas para escribir, depurar, compilar y desplegar software. Este módulo cubre los principales IDEs del mercado —VS Code, IntelliJ IDEA, PyCharm, WebStorm, Vim, Neovim— así como su configuración, atajos de teclado, personalización y mejores prácticas para maximizar la productividad.

## Conceptos clave

- **IDE**: Aplicación integrada con editor, debugger, terminal, control de versiones y herramientas de build.
- **Code Editor**: Editor de código ligero y extensible (VS Code, Vim, Neovim, Sublime Text).
- **LSP (Language Server Protocol)**: Protocolo estándar que proporciona autocompletado, diagnósticos y refactorización en cualquier editor.
- **DAP (Debug Adapter Protocol)**: Protocolo estándar para debuggers intercambiables entre editores.
- **Keybindings / Atajos**: Combinaciones de teclado para acciones frecuentes (Ctrl+P, Ctrl+Shift+P, etc.).
- **Snippets**: Fragmentos de código reutilizables insertables con atajos.
- **Workspace**: Configuración y contexto de un proyecto dentro del IDE.
- **Remote Development**: Desarrollo en contenedores, máquinas remotas o WSL desde el IDE local.
- **Tasks**: Automatización de builds, tests y otras tareas desde el IDE.
- **Debugging**: Ejecución paso a paso, breakpoints, watch variables, call stacks.
- **Refactoring**: Herramientas automáticas de refactorización (renombrar, extraer método, cambiar firma).
- **Integrated Terminal**: Terminal embebida en el IDE para comandos sin cambiar de ventana.

## Tecnologías principales

### IDEs Complejos
- **IntelliJ IDEA**: IDE para Java/Kotlin con soporte empresarial (JetBrains).
- **PyCharm**: IDE especializado en Python con soporte científico y web (JetBrains).
- **WebStorm**: IDE para JavaScript/TypeScript con soporte para frameworks modernos (JetBrains).
- **GoLand**: IDE para Go de JetBrains.
- **Android Studio**: IDE oficial para desarrollo Android basado en IntelliJ.
- **Xcode**: IDE oficial para desarrollo Apple (Swift, Objective-C).
- **Visual Studio**: IDE de Microsoft para .NET y C++.

### Editores de Código
- **VS Code**: Editor gratuito y extensible de Microsoft con ecosistema masivo de extensiones.
- **Vim**: Editor modal clásico, altamente configurable, presente en cualquier sistema Unix.
- **Neovim**: Fork moderno de Vim con Lua como lenguaje de configuración, LSP nativo.
- **Sublime Text**: Editor rápido y ligero con rendimiento excelente.
- **Zed**: Editor moderno de alto rendimiento escrito en Rust.
- **Helix**: Editor modal con selección y multi-cursor nativos, escrito en Rust.
- **Emacs**: Editor extensible con org-mode, magit y ecosistema integrado.

## Hoja de ruta

1. **Principiante**: Instalar y configurar VS Code con extensiones esenciales. Aprender atajos básicos (Ctrl+P, Ctrl+Shift+P, Ctrl+`). Configurar un tema y fuente.
2. **Intermedio**: Dominar debugging integrado. Configurar tasks para builds y tests. Usar snippets personalizados. Aprender Vim motions básicos (incluso con extensiones Vim en otros editores).
3. **Avanzado**: Migrar a Neovim o Emacs con configuración desde cero. Escribir plugins propios. Configurar entornos dev container. Optimizar keybindings para edición modal avanzada.

## Relaciones con otros módulos

- [`../076-Extensions/`](../076-Extensions/) — Extensiones y plugins que extienden las capacidades del IDE.
- [`../074-Tools/`](../074-Tools/) — Linters, formatters y debuggers integrados en los IDEs.
- [`../077-CLI/`](../077-CLI/) — El terminal integrado y herramientas CLI son parte esencial de IDEs.
- [`../013-DevOps/`](../013-DevOps/) — IDEs con integración DevOps (Docker, Kubernetes, CI/CD).
- [`../046-BestPractices/`](../046-BestPractices/) — Configuración óptima del entorno de desarrollo.
- [`../093-CommonErrors/`](../093-CommonErrors/) — Errores comunes de configuración de IDEs.

## Recursos recomendados

- [VS Code Docs](https://code.visualstudio.com/docs) — Documentación oficial de VS Code.
- [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/) — Gestor de IDEs JetBrains.
- [Learn Vim Progressively](https://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/) — Tutorial práctico de Vim.
- [Neovim Official Site](https://neovim.io/) — Documentación de Neovim.
- [LSP Specification](https://microsoft.github.io/language-server-protocol/) — Protocolo LSP de Microsoft.
- [Awesome VS Code](https://github.com/viatsko/awesome-vscode) — Recursos curados para VS Code.
