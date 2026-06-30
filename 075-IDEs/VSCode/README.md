# Visual Studio Code — Editor y Extensions

## Visión General

VS Code es un editor de código fuente multiplataforma desarrollado por Microsoft. Basado en Electron y TypeScript, ofrece un ecosistema de extensiones, depurador integrado, control de versiones Git, terminal y soporte para cientos de lenguajes.

## Arquitectura

```
┌──────────────────────────────────────┐
│            VS Code UI                │
├──────────────────────────────────────┤
│  Activity Bar │ Side Bar │ Editor    │
│  (Extension   │ (Explorer,│ (Tabs,   │
│   icons)      │  Search,  │  Groups) │
│               │  Debug,   │          │
│               │  Git)     │          │
├──────────────────────────────────────┤
│  Panel (Terminal, Problems, Output)  │
├──────────────────────────────────────┤
│  Status Bar (Branch, Lint, Encoding) │
└──────────────────────────────────────┘
```

## Atajos de Teclado Esenciales

### Generales
```bash
Ctrl+P          # Paleta de comandos / abrir archivo por nombre
Ctrl+Shift+P    # Paleta de comandos (acciones)
Ctrl+,          # Abrir configuración (Settings)
Ctrl+B          # Toggle sidebar
Ctrl+`          # Abrir terminal integrado
Ctrl+K Ctrl+S   # Atajos de teclado
```

### Edición
```bash
Alt+↑/↓          # Mover línea arriba/abajo
Ctrl+D           # Seleccionar siguiente ocurrencia
Ctrl+Shift+L     # Seleccionar todas las ocurrencias
Ctrl+Shift+K     # Borrar línea actual
Alt+Click        # Insertar cursor múltiple
Ctrl+Space       # Sugerencias (IntelliSense)
Ctrl+Shift+I     # Formatear documento
F2               # Renombrar símbolo (Refactor)
```

### Navegación
```bash
F12              # Ir a definición
Alt+F12          # Peek definición
Ctrl+Shift+O     # Ir a símbolo en archivo (@)
Ctrl+T           # Ir a símbolo en workspace (#)
Ctrl+G           # Ir a línea específica
Ctrl+-           # Navegar hacia atrás
Ctrl+Shift+-     # Navegar hacia adelante
```

## Configuración (settings.json)

```json
{
  "editor.fontSize": 14,
  "editor.fontFamily": "'Fira Code', 'Cascadia Code', monospace",
  "editor.fontLigatures": true,
  "editor.minimap.enabled": false,
  "editor.renderWhitespace": "all",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "editor.wordWrap": "on",
  "editor.cursorBlinking": "smooth",
  "editor.cursorSmoothCaretAnimation": "on",
  "files.autoSave": "afterDelay",
  "files.exclude": {
    "**/.git": true,
    "**/node_modules": true,
    "**/dist": true
  },
  "workbench.colorTheme": "One Dark Pro",
  "workbench.iconTheme": "material-icon-theme",
  "workbench.startupEditor": "none",
  "terminal.integrated.defaultProfile.linux": "bash",
  "terminal.integrated.fontSize": 13,
  "git.autofetch": true,
  "git.confirmSync": false,
  "extensions.ignoreRecommendations": false,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true
}
```

## Extensiones Esenciales

### Lenguajes y Frameworks
```yaml
Python:              ms-python.python (IntelliSense, linting, debugging)
Pylance:             ms-python.vscode-pylance (type checking, autocompletado)
JavaScript/TS:       ms-vscode.vscode-typescript-next
ESLint:              dbaeumer.vscode-eslint
Prettier:            esbenp.prettier-vscode (formateo consistente)
Go:                  golang.go
Rust:                rust-lang.rust-analyzer
Java:                redhat.java + vscjava.vscode-java-debug
Docker:              ms-azuretools.vscode-docker
YAML:                redhat.vscode-yaml
Jupyter:             ms-toolsai.jupyter
```

### Productividad
```yaml
GitLens:             eamodio.gitlens (historial Git en línea)
Git History:         donjayamanne.githistory
Todo Tree:           gruntfuggly.todo-tree (TODO/FIXME en sidebar)
Error Lens:          usernamehw.errorlens (errores inline)
Path Intellisense:   christian-kohler.path-intellisense
Code Spell Checker:  streetsidesoftware.code-spell-checker
Bookmarks:           alefragnani.Bookmarks
Live Share:          ms-vsliveshare.vsliveshare (pair programming)
Remote - SSH:        ms-vscode-remote.remote-ssh
Remote - Containers: ms-vscode-remote.remote-containers
```

### Themes y Visuales
```yaml
One Dark Pro:         zhuangtongfa.Material-theme
Material Icon Theme:  PKief.material-icon-theme
Peacock:              johnpapa.vscode-peacock (color por proyecto)
Better Comments:      aaron-bond.better-comments
Indent Rainbow:       oderwat.indent-rainbow
```

## Debugging (launch.json)

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug API",
      "program": "${workspaceFolder}/src/index.js",
      "envFile": "${workspaceFolder}/.env",
      "skipFiles": ["<node_internals>/**"],
      "outFiles": ["${workspaceFolder}/dist/**/*.js"]
    },
    {
      "type": "python",
      "request": "launch",
      "name": "Python: Current File",
      "program": "${file}",
      "console": "integratedTerminal",
      "env": {
        "PYTHONPATH": "${workspaceFolder}"
      }
    },
    {
      "type": "chrome",
      "request": "launch",
      "name": "Debug Frontend",
      "url": "http://localhost:3000",
      "webRoot": "${workspaceFolder}/src",
      "sourceMapPathOverrides": {
        "webpack:///src/*": "${webRoot}/*"
      }
    }
  ]
}
```

## Tasks (tasks.json)

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Build TypeScript",
      "type": "shell",
      "command": "npx tsc",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": ["$tsc"],
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Run Tests",
      "type": "shell",
      "command": "npm test",
      "group": {
        "kind": "test",
        "isDefault": true
      }
    },
    {
      "label": "Docker Compose Up",
      "type": "shell",
      "command": "docker compose up -d",
      "group": "none"
    }
  ]
}
```

## Snippets Personalizados

```json
// .vscode/mi-codigo.code-snippets
{
  "React Functional Component": {
    "scope": "typescriptreact,javascriptreact",
    "prefix": "rfc",
    "body": [
      "import React from 'react'",
      "",
      "interface ${1:ComponentName}Props {",
      "  $2",
      "}",
      "",
      "const ${1:ComponentName}: React.FC<${1:ComponentName}Props> = ({ $2 }) => {",
      "  return (",
      "    <div>",
      "      $0",
      "    </div>",
      "  )",
      "}",
      "",
      "export default ${1:ComponentName}"
    ],
    "description": "React Functional Component with TypeScript"
  }
}
```

## Remote Development

```bash
# Requiere extensión ms-vscode-remote.remote-ssh

# Configurar SSH hosts (Ctrl+Shift+P → Remote-SSH: Open SSH Configuration File)
Host mi-servidor
    HostName 192.168.1.100
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519

# Abrir Remote-SSH: Connect to Host...
# Luego File → Open Folder → /home/ubuntu/proyecto

# VSCode Server se instala automáticamente en el remoto
# Extensiones locales → instalar también en remoto
```

## Snippets de Terminal (Shell)

```bash
# Abrir archivo con cursor en línea específica
code server.ts:42

# Comparar archivos
code --diff archivo1.ts archivo2.ts

# Abrir sin extensiones (modo seguro)
code --disable-extensions

# Ver rendimiento de extensiones
code --status
```

## Settings Sync

```bash
# Usar GitHub para sincronizar configuraciones
# Settings → Turn on Settings Sync...
# Sincroniza: settings.json, keybindings.json, extensions, snippets
```

## Referencias

- [VS Code Documentation](https://code.visualstudio.com/docs)
- [VS Code Shortcuts (PDF)](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-linux.pdf)
- [VS Code API (Extensiones)](https://code.visualstudio.com/api)
- [Marketplace](https://marketplace.visualstudio.com/)
- [Awesome VS Code](https://github.com/viatsko/awesome-vscode)
