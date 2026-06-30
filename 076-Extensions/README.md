# 076-Extensions — Extensiones y Plugins

## Descripción del dominio

Las extensiones y plugins son componentes de software que amplían la funcionalidad de IDEs, editores de código y navegadores web. Este módulo cubre los marketplaces de extensiones, las categorías principales, las mejores extensiones recomendadas por tecnología, y cómo desarrollar y publicar extensiones propias.

## Conceptos clave

- **Extension / Plugin**: Paquete que añade funcionalidades a un programa anfitrión (IDE, editor, navegador).
- **Marketplace**: Plataforma de distribución de extensiones (VS Code Marketplace, JetBrains Marketplace, Chrome Web Store, Firefox Add-ons).
- **Language Server Protocol (LSP)**: Extensiones que implementan soporte de lenguaje (autocompletado, diagnóstico, refactorización).
- **Theme**: Extensión que modifica la apariencia visual (colores, iconos, fuentes).
- **Snippet Extension**: Extensiones que proporcionan fragmentos de código reutilizables.
- **Debugger Extension**: Extensiones que añaden soporte para debuggear lenguajes o runtimes específicos.
- **Formatter Extension**: Extensiones que integran formateadores de código en el editor.
- **Integration Extension**: Extensiones que conectan el editor con servicios externos (GitHub, Jira, Docker, AWS).
- **Language Extension**: Extensiones que añaden soporte para un lenguaje de programación (syntax highlighting, IntelliSense).
- **VS Code API**: API para desarrollar extensiones de VS Code (contribution points, activation events, webviews).
- **JetBrains Plugin SDK**: SDK para desarrollar plugins para IDEs JetBrains.

## Tecnologías principales

### Marketplaces
- **VS Code Marketplace**: store.visualstudio.com — Mayor catálogo de extensiones para editores.
- **Open VSX Registry**: open-vsx.org — Registry open-source compatible con VS Code (Open VSX).
- **JetBrains Marketplace**: plugins.jetbrains.com — Plugins para IntelliJ, PyCharm, WebStorm, etc.
- **Chrome Web Store**: chrome.google.com/webstore — Extensiones para Google Chrome.
- **Firefox Add-ons**: addons.mozilla.org — Extensiones para Firefox.
- **Vim/Neovim Plugins**: vimawesome.com — Plugins para Vim y Neovim.

### Extensiones Esenciales por Categoría

- **Lenguajes**: ESLint, Prettier, Python, Go, Rust Analyzer, TypeScript, Java Extension Pack.
- **Temas**: One Dark Pro, Dracula, Catppuccin, Tokyo Night, Nord.
- **Iconos**: Material Icon Theme, vscode-icons, file-icons.
- **Productividad**: GitLens, GitHub Copilot, TabNine, Codeium, Live Share, Remote SSH, Docker.
- **Markdown**: Markdown Preview Enhanced, markdownlint, Foam.
- **Testing**: Jest, Mocha Test Explorer, Coverage Gutters.
- **DevOps**: Docker, Kubernetes, Terraform, YAML, GitHub Actions.

## Hoja de ruta

1. **Principiante**: Instalar extensiones esenciales para tu stack (linter, formatter, theme, iconos). Configurar GitLens y GitHub Copilot. Gestionar extensiones sincronizadas (Settings Sync).
2. **Intermedio**: Crear snippets personalizados. Usar Dev Containers con extensiones específicas del proyecto. Desarrollar extensiones simples para VS Code (comandos básicos, webviews).
3. **Avanzado**: Publicar extensiones en VS Code Marketplace y Open VSX. Desarrollar plugins complejos para JetBrains con UI personalizada. Contribuir a extensiones open-source populares. Mantener extensiones con CI/CD y tests.

## Relaciones con otros módulos

- [`../075-IDEs/`](../075-IDEs/) — Las extensiones son el ecosistema que hace poderosos a los IDEs modernos.
- [`../074-Tools/`](../074-Tools/) — Extensiones que integran linters, formatters y debuggers en el editor.
- [`../077-CLI/`](../077-CLI/) — Extensiones que exponen funcionalidades CLI dentro del editor.
- [`../041-CodeGeneration/`](../041-CodeGeneration/) — Extensiones de IA generativa (Copilot, Codeium) para asistencia de código.
- [`../013-DevOps/`](../013-DevOps/) — Extensiones de integración con Docker, K8s, Terraform.
- [`../079-APIs/`](../079-APIs/) — Extensiones para probar APIs (Thunder Client, REST Client).

## Recursos recomendados

- [VS Code Extension API](https://code.visualstudio.com/api) — Documentación oficial para crear extensiones VS Code.
- [JetBrains Plugin Development](https://plugins.jetbrains.com/docs/intellij/) — Documentación de desarrollo de plugins JetBrains.
- [Open VSX Registry](https://open-vsx.org/) — Registry open-source de extensiones VS Code.
- [Awesome VS Code Extensions](https://github.com/viatsko/awesome-vscode) — Colección curada de extensiones.
- [Chrome Extensions Docs](https://developer.chrome.com/docs/extensions/) — Documentación de extensiones Chrome.
- [VimAwesome](https://vimawesome.com/) — Catálogo de plugins para Vim/Neovim.
