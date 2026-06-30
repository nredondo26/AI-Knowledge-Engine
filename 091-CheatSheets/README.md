# 091-CheatSheets — Guías Rápidas y Cheatsheets

## Descripción del dominio

Directorio que compila cheatsheets, resúmenes visuales, hojas de referencia rápida y atajos esenciales para lenguajes de programación, frameworks, herramientas CLI, bases de datos, cloud providers y tecnologías de IA. Diseñado para consulta rápida durante el desarrollo, debugging y operaciones del día a día. Cada cheatsheet prioriza la densidad de información útil sobre la profundidad explicativa.

## Conceptos clave

- **Cheatsheet**: Hoja de referencia concisa con sintaxis, comandos y ejemplos rápidos
- **TL;DR**: Versión ultra-resumida para consulta inmediata
- **Snippet de referencia**: Bloque de código reutilizable anotado
- **Mnemotecnia**: Técnicas para recordar comandos y parámetros frecuentes
- **Atajo de teclado**: Combinaciones de teclas para acelerar flujos de trabajo
- **Flag/switch**: Parámetros de CLI con ejemplos de uso común
- **Pipe pattern**: Combinaciones de comandos Unix/Linux para procesamiento
- **One-liner**: Comando único que resuelve una tarea completa
- **Dotfile reference**: Configuración rápida de .bashrc, .gitconfig, .vimrc
- **API endpoint cheat**: Verbos HTTP, códigos de estado, headers comunes
- **Regex reference**: Patrones de expresiones regulares con ejemplos
- **Time complexity card**: Notación Big O para estructuras de datos y algoritmos
- **CLI wizard**: Secuencia de comandos para tareas específicas (git, docker, kubectl)

## Tecnologías principales

| Categoría | Tecnologías cubiertas |
|---|---|
| **Lenguajes** | Python, JavaScript, TypeScript, Go, Rust, Java, C++, C#, PHP, Ruby, Swift, Kotlin, Bash |
| **Frameworks web** | React, Vue, Angular, Next.js, Django, FastAPI, Spring Boot, Express, Laravel, Rails |
| **Bases de datos** | PostgreSQL, MySQL, MongoDB, Redis, Elasticsearch, SQLite, Cassandra, DynamoDB |
| **Cloud** | AWS CLI, Azure CLI, GCP gcloud, CloudFormation, Terraform, Pulumi |
| **Contenedores** | Docker, Docker Compose, Podman, containerd, Buildah, Skopeo |
| **Orquestación** | kubectl, Helm, Kustomize, Skaffold, Istio, ArgoCD |
| **DevOps/CI/CD** | Git, GitHub Actions, GitLab CI, Jenkins, Ansible, Packer, Vagrant |
| **Linux** | systemd, grep/awk/sed, find, netstat/ss, iptables, perf, strace, lsof |
| **IA/ML** | NumPy, Pandas, Matplotlib, scikit-learn, PyTorch, TensorFlow, Hugging Face, LangChain |
| **Editores** | Vim, Neovim, VS Code, JetBrains, tmux, emacs |
| **Redes** | curl, wget, netcat, tcpdump, nmap, dig, openssl, iproute2 |

## Hoja de ruta

### Principiante
1. **Linux Bash** — Comandos esenciales: ls, cd, cp, mv, rm, grep, find, chmod, ps, kill
2. **Git básico** — clone, add, commit, push, pull, branch, merge, status, log
3. **Python** — Sintaxis básica, list/dict/set comprehensions, slicing, lambdas
4. **VS Code** — Atajos esenciales: Ctrl+P, Ctrl+Shift+P, Ctrl+D, Ctrl+/
5. **Docker** — docker run, build, ps, exec, logs, compose up/down

### Intermedio
1. **Git avanzado** — rebase, stash, cherry-pick, bisect, reflog, hooks
2. **Docker Compose** — Volúmenes, redes, healthcheck, multi-stage builds
3. **kubectl** — pods, services, deployments, configmap, port-forward, logs
4. **Regex** — Grupos, lookahead/lookbehind, flags, quantifiers, alternation
5. **Vim/Neovim** — Movimiento, edición, ventanas, macros, registros, marks
6. **SQL** — Joins, subqueries, window functions, CTEs, indexes, explain analyze

### Avanzado
1. **Bash scripting** — Arrays, parameter expansion, process substitution, trap, exec, coprocesses
2. **tmux** — Sesiones, ventanas, paneles, sincronización, personalización
3. **Perf/SystemTap** — Profiling de CPU, memoria, I/O, system calls
4. **gdb/lldb** — Debugging de C/C++, breakpoints, backtrace, core dump analysis
5. **OpenSSL** — Certificados, CSR, cifrado simétrico/asimétrico, hash, HMAC
6. **iptables/nftables** — Tablas, chains, reglas, NAT, logging, filtrado

### Experto
1. **eBPF/bcc** — Programas BPF para tracing, profiling, seguridad
2. **strace/ltrace** — Análisis de system calls y library calls
3. **Custom dotfiles** — Gestión de dotfiles con GNU Stow, chezmoi, Nix
4. **Kernel tuning** — sysctl, /proc, cgroups, namespaces, seccomp
5. **Memory forensics** — /proc/pid/maps, pmap, gcore, valgrind, heaptrack

## Relaciones con otros módulos

- `../001-Languages/` — Cheatsheets por cada lenguaje de programación
- `../002-Frameworks/` — Hojas de referencia para frameworks específicos
- `../003-Databases/` — SQL y NoSQL cheatsheets (queries, indexes, aggregations)
- `../005-Cloud/` — Comandos CLI de AWS, Azure, GCP
- `../006-Containers/` — Dockerfile y Docker Compose referencia rápida
- `../007-Orchestration/` — kubectl, Helm, Kustomize cheatsheets
- `../074-Tools/` — Herramientas CLI y su uso detallado
- `../077-CLI/` — Comandos de terminal y automatización
- `../045-Snippets/` — Fragmentos de código ampliados
- `../046-BestPractices/` — Buenas prácticas que complementan los resúmenes

## Recursos recomendados

- [Devhints](https://devhints.io) — Cheatsheets extensas para tecnologías modernas
- [Learn X in Y Minutes](https://learnxinyminutes.com) — Tours rápidos de lenguajes
- [Cheat.sh](https://cheat.sh) — Cheatsheets vía curl para cualquier tecnología
- [tldr-pages](https://tldr.sh) — Versiones simplificadas de man pages
- [QuickRef.ME](https://quickref.me) — Cheatsheets visuales con ejemplos
- [Oh My Zsh cheatsheet](https://github.com/ohmyzsh/ohmyzsh/wiki/Cheatsheet) — Atajos y plugins
- [Vim Adventures](https://vim-adventures.com) — Aprender Vim jugando
- [Regex101](https://regex101.com) — Editor y referencia de regex interactivo
