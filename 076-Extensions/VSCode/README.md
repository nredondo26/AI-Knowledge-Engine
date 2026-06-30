# Visual Studio Code — Extensiones Esenciales

## ¿Qué es VS Code?

Editor de código gratuito, open-source y multiplataforma de Microsoft. Su ecosistema de extensiones lo hace adaptable a cualquier lenguaje y flujo de trabajo.

## Extensiones por Categoría

### Lenguajes y Frameworks

| Extensión | Uso |
|-----------|-----|
| **Python** (Microsoft) | IntelliSense, linting, depuración, Jupyter |
| **Java Extension Pack** | Red Hat + Microsoft + Debugger |
| **Go** | Lenguaje Go: navegación, testing |
| **rust-analyzer** | Análisis de código Rust |
| **C/C++** (Microsoft) | IntelliSense, depuración |
| **PHP IntelliSense** | Autocompletado PHP |

### Linters y Formateadores

| Extensión | Descripción |
|-----------|-------------|
| **ESLint** | Análisis estático JS/TS |
| **Prettier** | Formateador opinado |
| **Ruff** | Linter rápido Python |
| **Black Formatter** | Formateo Python |
| **markdownlint** | Calidad Markdown |

### Control de Versiones

| Extensión | Descripción |
|-----------|-------------|
| **GitLens** | Blame, historial, exploración Git |
| **Git Graph** | Visualización gráfica de ramas |
| **GitHub Pull Requests** | Revisar PRs desde VS Code |

### Desarrollo Web

| Extensión | Descripción |
|-----------|-------------|
| **Live Server** | Servidor local con recarga |
| **ES7+ React/Redux** | Snippets React, Redux, Next.js |
| **Vue (Volar)** | Soporte Vue 3 |
| **Tailwind CSS IntelliSense** | Clases y previews |
| **Thunder Client** | Cliente REST/GraphQL |

### Docker y DevOps

| Extensión | Descripción |
|-----------|-------------|
| **Docker** (Microsoft) | Build, manage, deploy |
| **Dev Containers** | Desarrollo en contenedores |
| **Remote — SSH** | Conexión remota |
| **YAML** (Red Hat) | Validación YAML |

### Bases de Datos

| Extensión | Descripción |
|-----------|-------------|
| **SQLTools** | Múltiples bases de datos |
| **MongoDB for VS Code** | Consultas MongoDB |
| **SQLite Viewer** | Visualización SQLite |

### Inteligencia Artificial

| Extensión | Descripción |
|-----------|-------------|
| **GitHub Copilot** | Autocompletado con IA |
| **Tabnine** | Autocompletado local |
| **Continue** | Asistente con LLMs locales |
| **Codeium** | Autocompletado gratuito |

### Testing

| Extensión | Descripción |
|-----------|-------------|
| **Jest** | Test runner JS/TS |
| **Python Test Explorer** | Tests Python |
| **Coverage Gutters** | Cobertura inline |

## Configuración Recomendada

```json
{
  "editor.fontSize": 14,
  "editor.fontFamily": "'Cascadia Code', monospace",
  "editor.fontLigatures": true,
  "editor.formatOnSave": true,
  "editor.renderWhitespace": "boundary",
  "editor.bracketPairColorization.enabled": true,
  "files.autoSave": "onFocusChange",
  "git.enableSmartCommit": true,
  "github.copilot.enable": { "*": true, "yaml": false, "markdown": false }
}
```

## Atajos Útiles

| Atajo | Acción |
|-------|--------|
| `Ctrl+P` | Buscar archivo |
| `Ctrl+Shift+P` | Paleta de comandos |
| `Ctrl+\`` | Terminal integrada |
| `Alt+Up/Down` | Mover línea |
| `F12` | Ir a definición |
| `Ctrl+Shift+F` | Buscar en archivos |

## Buenas Prácticas

1. Sincronizar configuraciones con Settings Sync
2. Versionar `.vscode/` con configuraciones del proyecto
3. Usar perfiles (Profiles) para diferentes roles
4. Deshabilitar extensiones no utilizadas

## Recursos

- [Marketplace oficial](https://marketplace.visualstudio.com/)
- [Awesome VS Code](https://github.com/viatsko/awesome-vscode)
