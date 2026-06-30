# Git — Sistema de Control de Versiones

## ¿Qué es Git?

Git es un sistema de control de versiones distribuido creado por Linus Torvalds en 2005. Permite rastrear cambios en el código fuente, coordinar trabajo entre múltiples desarrolladores y mantener un historial completo del proyecto.

## Conceptos Fundamentales

- **Repositorio**: Almacén del historial completo del proyecto.
- **Commit**: Instantánea del proyecto con hash SHA-1 único.
- **Rama (branch)**: Línea independiente de desarrollo. Por defecto `main`.
- **HEAD**: Puntero al commit actual.
- **Staging area (index)**: Área intermedia antes de confirmar cambios.

## Flujo de Trabajo Básico

```bash
git init                          # Inicializar repositorio
git clone <url>                   # Clonar repositorio
git status                        # Ver estado
git add <archivo>                 # Añadir cambios al staging
git commit -m "mensaje"           # Confirmar cambios
git push origin <rama>            # Enviar al remoto
git pull origin <rama>            # Obtener del remoto
git log --oneline --graph         # Ver historial
```

## Ramas y Fusiones

```bash
git branch <nombre-rama>          # Crear rama
git checkout -b <nombre-rama>     # Crear y cambiar
git merge <nombre-rama>           # Fusionar rama
git branch -d <nombre-rama>       # Eliminar rama
```

## Resolución de Conflictos

Aparecen marcadores en el archivo:
```
<<<<<<< HEAD
código actual
=======
código entrante
>>>>>>> rama-origen
```
Se resuelven editando manualmente, eliminando marcadores y confirmando.

## Comandos Avanzados

```bash
git stash                         # Guardar cambios temporales
git stash pop                     # Recuperar stash
git rebase -i HEAD~3              # Rebase interactivo
git cherry-pick <hash>            # Aplicar commit específico
git bisect start                  # Encontrar commit con bug
git reset --hard HEAD~1           # Descartar commits (peligroso)
git revert <hash>                 # Deshacer cambios (seguro)
```

## Configuración

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
git config --global alias.lg "log --oneline --graph --all"
```

## Estrategias de Ramificación

- **Git Flow**: `main`, `develop`, `feature/*`, `release/*`, `hotfix/*`
- **GitHub Flow**: `main` + `feature/*` con Pull Requests
- **Trunk-Based Development**: Ramas cortas fusionadas frecuentemente

## Hooks

Scripts automáticos en eventos de Git:
- `pre-commit`: Linters, tests antes del commit
- `post-commit`: Después del commit
- `pre-push`: Antes de enviar al remoto

## Buenas Prácticas

1. Commits atómicos con mensajes descriptivos (imperativo presente)
2. Una rama por funcionalidad/bugfix
3. Pull Requests con descripción clara y revisión de código
4. Usar `.gitignore` para archivos generados
5. Mantener historial limpio con rebase interactivo
6. Firmar commits con GPG para verificar autoría

## Diagnóstico

```bash
git diff                          # Cambios sin staging
git blame <archivo>               # Quién modificó cada línea
git reflog                        # Registro de movimientos de HEAD
git gc                            # Limpieza y optimización
```

## Integración con Plataformas

- **GitHub**: Pull Requests, Actions, Issues
- **GitLab**: Merge Requests, CI/CD integrado
- **Bitbucket**: Pipelines, integración con Jira

## Recursos

- [Pro Git Book](https://git-scm.com/book/es/v2)
- [Git Flight Rules](https://github.com/k88hudson/git-flight-rules)
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
