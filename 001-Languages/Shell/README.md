# Shell (POSIX sh)

Lenguaje interpretado, procedural, scripting UNIX. Estándar POSIX (IEEE 1003.1). Implementaciones: sh (Bourne), dash (Debian), ash (BusyBox). Filosofía: tuberías de procesos, composición de herramientas, minimalismo.

## Sintaxis básica

```sh
#!/bin/sh

echo "Hola, mundo"

NOMBRE="Ana"
EDAD=30
echo "${NOMBRE} tiene ${EDAD} años"

FECHA=$(date +%Y-%m-%d)

if [ "$EDAD" -ge 18 ]; then
    echo "Mayor"
elif [ "$EDAD" -gt 12 ]; then
    echo "Adolescente"
else
    echo "Menor"
fi

for i in 1 2 3 4 5; do echo "$i"; done

while IFS= read -r linea; do
    echo "$linea"
done < archivo.txt

case "$EDAD" in
    [0-9]|1[0-2]) echo "Niño" ;;
    1[3-9]|2[0-5]) echo "Joven" ;;
    *) echo "Adulto" ;;
esac

saludar() {
    echo "Hola, $1"
}
```

## Expansiones y parámetros

```sh
# Manipulación de strings
echo "${#NOMBRE}"          # longitud
echo "${NOMBRE:-default}"  # default si no set
echo "${NOMBRE:0:2}"       # substring

# Pattern matching
PATH="/usr/local/bin:/usr/bin"
echo "${PATH#*/}"          # elimina prefijo corto
echo "${PATH##*/}"         # elimina prefijo largo
echo "${PATH%/*}"          # elimina sufijo corto

# Aritmética
echo "$(( (EDAD + 5) * 2 ))"

# Redirección
comando > archivo          # stdout
comando 2> error.log       # stderr
comando &> todo.log        # ambos
comando1 | comando2        # pipe

# Heredoc
cat << EOF
Texto multilínea con ${VARIABLE}
EOF
```

## Procesos y señales

```sh
# Background y jobs
comando &
PID=$!
kill -TERM $PID

# Trap
cleanup() { rm -f /tmp/temp.$$; }
trap cleanup INT TERM EXIT

# Tests
[ -f archivo ] && cat archivo
[ -d directorio ] && ls
[ -z "$var" ] && echo "vacío"
[ -n "$var" ] && echo "no vacío"

# getopts
while getopts "n:a:h" opt; do
    case "$opt" in
        n) NOMBRE="$OPTARG" ;;
        h) echo "Uso: $0 -n nombre"; exit 0 ;;
    esac
done

# Errores
set -e   # exit on error
set -u   # error on undefined vars
```

## Buenas prácticas POSIX

```sh
#!/bin/sh

# Portable dirname
SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)

# Archivo temporal seguro
TMPFILE=$(mktemp /tmp/script.XXXXXX)
trap 'rm -f "$TMPFILE"' EXIT

# Leer archivo portable
while IFS= read -r line; do echo "$line"; done < archivo

# Globbing seguro
for file in ./*.txt; do
    [ -f "$file" ] || continue
    echo "$file"
done

# shellcheck: linting
# shellcheck -s sh script.sh
```

## Relaciones

- [Bash](../Bash/README.md)
- [Sistemas Operativos](../../004-OperatingSystems/README.md)
- [Contenedores](../../006-Containers/README.md)
```