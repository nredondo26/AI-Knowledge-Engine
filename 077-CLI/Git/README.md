# Git CLI — Comandos Avanzados

## Introducción

Guía de uso avanzado de Git desde CLI. Para conceptos básicos, ver `074-Tools/Git/README.md`.

## Comandos Poco Conocidos

### Bisect — Encontrar Commits Problemáticos

```bash
git bisect start
git bisect bad HEAD
git bisect good v1.0
git bisect good   # Marcar cada commit
git bisect bad
git bisect reset
git bisect run pytest tests/   # Automatizado
```

### Worktree — Múltiples Ramas Simultáneas

```bash
git worktree add ../project-feature feature-branch
git worktree list
git worktree remove ../project-feature
```

### Reflog — Recuperación de Commits Perdidos

```bash
git reflog
git reset --hard HEAD@{1}       # Recuperar después de reset
git checkout -b recovered HEAD@{2}
```

### Cherry-pick — Aplicar Commits Específicos

```bash
git cherry-pick abc123
git cherry-pick abc123 def456
git cherry-pick -n abc123       # Sin commit automático
```

### Submódulos

```bash
git submodule add https://github.com/user/repo.git
git clone --recurse-submodules url
git submodule update --remote
```

## Manipulación del Historial

### Rebase Interactivo

```bash
git rebase -i HEAD~3
# pick = usar, reword = cambiar mensaje
# squash = combinar con anterior, drop = eliminar
```

### Filter-branch / Filter-repo

```bash
# Eliminar archivo sensible del historial
git filter-repo --path secrets.txt --invert-paths
```

### Amend — Modificar Último Commit

```bash
git commit --amend -m "nuevo mensaje"
git commit --amend --no-edit     # Mantiene mensaje
```

## Firmado de Commits (GPG)

```bash
gpg --full-generate-key
git config --global user.signingkey KEY_ID
git config --global commit.gpgsign true
git commit -S -m "mensaje firmado"
```

## Hooks

```bash
# .git/hooks/pre-commit
#!/bin/bash
npm run lint
if [ $? -ne 0 ]; then exit 1; fi
```

## Debugging

```bash
git blame -L 10,20 archivo.py
git log -S "password" --all --oneline
git log -G "def .*\(self" --all --oneline
git fsck --full                # Verificar integridad
git gc --aggressive --prune=now # Limpieza
```

## Estrategias de Merge Avanzadas

```bash
git merge -s ours branch-name   # Mantener nuestra versión
git merge -X theirs branch-name # Preferir cambios entrantes
git merge branch1 branch2       # Merge octopus
```

## Parches

```bash
git format-patch -1 HEAD -o patches/
git apply patches/0001-commit.patch
git bundle create repo.bundle --all
```

## Buenas Prácticas

1. Crear alias para comandos frecuentes
2. Usar `git add -p` para staging interactivo
3. Limpiar ramas: `git branch --merged | xargs git branch -d`
4. Usar `git log --graph --oneline --all`

## Recursos

- [Git SCM Docs](https://git-scm.com/docs)
- [Git Flight Rules](https://github.com/k88hudson/git-flight-rules)
