# 077-CLI — Herramientas de Línea de Comandos

## Descripción del dominio

La línea de comandos (CLI) es la interfaz fundamental para interactuar con sistemas operativos, herramientas de desarrollo y servicios cloud. Este módulo cubre terminales, shell scripting, herramientas clásicas Unix (grep, sed, awk), utilidades modernas (jq, curl, httpie, fzf), y el ecosistema de herramientas CLI que todo desarrollador debe dominar para ser productivo.

## Conceptos clave

- **Terminal Emulator**: Aplicación que emula una terminal dentro del sistema gráfico (iTerm2, Kitty, Alacritty, Windows Terminal, GNOME Terminal).
- **Shell**: Intérprete de comandos (bash, zsh, fish, powershell, nushell).
- **Shell Scripting**: Programación de scripts para automatizar tareas usando el shell.
- **Pipeline**: Encadenamiento de comandos con `|` para procesar datos secuencialmente.
- **Redirection**: Redirección de entrada/salida estándar (`>`, `<`, `>>`, `2>&1`).
- **Environment Variables**: Variables de entorno para configuración del shell y aplicaciones.
- **Alias**: Atajos para comandos frecuentes en el shell.
- **Prompt**: Indicador del shell, altamente personalizable (Starship, Oh My Zsh, Powerlevel10k).
- **TUI (Terminal User Interface)**: Aplicaciones con interfaz de usuario en terminal (htop, lazygit, neofetch).
- **Job Control**: Gestión de procesos en segundo plano (&, fg, bg, jobs, tmux/screen).
- **History**: Historial de comandos con búsqueda (Ctrl+R, fzf).
- **Completion**: Autocompletado inteligente de comandos, opciones y rutas.

## Tecnologías principales

### Shells Modernos
- **bash**: Shell por defecto en la mayoría de sistemas Linux y macOS.
- **zsh**: Shell moderno con autocompletado mejorado, tema Oh My Zsh.
- **fish**: Shell "amigable" con autosugerencias y resaltado de sintaxis nativo.
- **powershell**: Shell orientado a objetos de Microsoft, multiplataforma.
- **nushell**: Shell moderno con sistema de tipos y pipeline estructurado.

### Herramientas CLI Esenciales
- **grep**: Búsqueda de texto con patrones regex en archivos y streams.
- **sed**: Editor de streams para transformación de texto (buscar/reemplazar, extraer líneas).
- **awk**: Lenguaje de procesamiento de texto para columnas y reportes.
- **jq**: Procesador JSON de línea de comandos (query, filtrado, transformación).
- **curl**: Transferencia de datos con URL (HTTP, FTP, etc.), esencial para APIs.
- **httpie**: Cliente HTTP alternativo a curl con interfaz más legible.
- **fzf**: Filtro difuso interactivo para búsqueda en listas.
- **ripgrep (rg)**: Alternativa moderna a grep con rendimiento extremo.
- **fd**: Alternativa moderna a find con sintaxis intuitiva.
- **bat**: Alternativa a cat con resaltado de sintaxis y integración con Git.
- **htop / btop**: Monitores de sistema interactivos para terminal.
- **tmux**: Multiplexor de terminal para sesiones persistentes y paneles.
- **lazygit / gitui**: Interfaces TUI para Git.
- **yazi / lf**: Gestores de archivos en terminal.
- **starship**: Prompt minimalista y rápido para cualquier shell.

## Hoja de ruta

1. **Principiante**: Navegación básica (`ls`, `cd`, `pwd`, `mkdir`, `rm`, `cp`, `mv`). Usar grep y curl. Configurar aliases simples. Entender pipes y redirección.
2. **Intermedio**: Escribir scripts bash con variables, condicionales y loops. Usar sed y awk para transformación de texto. Configurar zsh con Oh My Zsh y Starship. Usar tmux para sesiones persistentes. Dominar jq para consultas JSON.
3. **Avanzado**: Escribir plugins de shell. Automatizar flujos completos con shell scripts. Usar herramientas modernas (rg, fd, bat, fzf) en pipelines complejos. Crear TUIs con bash o Python. Gestionar entornos con Dev Containers y dotfiles.

## Relaciones con otros módulos

- [`../074-Tools/`](../074-Tools/) — Muchas herramientas de desarrollo se usan exclusivamente desde CLI.
- [`../075-IDEs/`](../075-IDEs/) — Terminal integrada en IDEs; keybindings para comandos CLI.
- [`../079-APIs/`](../079-APIs/) — curl, httpie y jq para probar y debuggear APIs.
- [`../013-DevOps/`](../013-DevOps/) — Automatización DevOps con scripts CLI y pipelines.
- [`../006-Containers/`](../006-Containers/) — Docker CLI como herramienta fundamental.
- [`../014-CICD/`](../014-CICD/) — Pipelines CI/CD basados en comandos CLI.
- [`../046-BestPractices/`](../046-BestPractices/) — Buenas prácticas de shell scripting.

## Recursos recomendados

- [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line) — Maestría de línea de comandos en una página.
- [ExplainShell](https://explainshell.com/) — Explicación visual de comandos shell.
- [ShellCheck](https://www.shellcheck.net/) — Linter para scripts bash.
- [Oh My Zsh](https://ohmyz.sh/) — Framework para gestionar configuración de zsh.
- [Starship Prompt](https://starship.rs/) — Prompt minimalista y rápido.
- [jq Manual](https://stedolan.github.io/jq/manual/) — Documentación completa de jq.
- [Learn bash in Y minutes](https://learnxinyminutes.com/docs/bash/) — Referencia rápida de bash.
