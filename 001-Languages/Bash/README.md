# Bash (GNU Bash)

Lenguaje interpretado, shell UNIX, scripting avanzado. GNU Bourne Again SHell (Brian Fox, 1989). Versión 5.x. Filosofía: extensión de POSIX sh con arrays, aritmética, regex, features interactivos.

## Sintaxis básica

```bash
#!/usr/bin/env bash

echo "Hola, mundo"

nombre="Ana"; edad=30
declare -r CONST=100       # readonly
declare -i num=42           # integer

# Arrays indexados
frutas=("manzana" "pera" "uva")
frutas+=("naranja")
echo "${frutas[0]}" "${frutas[@]}" "${#frutas[@]}"

# Arrays asociativos
declare -A capitales
capitales[MX]="CDMX"; capitales[ES]="Madrid"

# Strings avanzado
texto="Hola Mundo"
echo "${texto,,}"          # minúsculas
echo "${texto^^}"          # mayúsculas
echo "${texto/Mundo/Ana}"  # reemplazar

# [[ ]] vs [ ]
if (( edad >= 18 )); then
    echo "Mayor"
elif (( edad > 12 )); then
    echo "Adolescente"
fi

[[ "$nombre" == A* ]]      # pattern matching
[[ "$nombre" =~ ^A[a-z]+$ ]]  # regex (ERE)

for (( i=0; i<5; i++ )); do echo "$i"; done
for f in "${frutas[@]}"; do echo "$f"; done

# Case con fallthrough
case "$edad" in
    1[0-9]) echo "Teen" ;&
    2[0-4]) echo "Joven" ;;
    *) echo "Otro" ;;
esac

# Función con nameref
procesar() {
    local -n ref=$1
    ref="modificado"
}
```

## Expansiones Bash

```bash
# Brace expansion
echo {A,B,C}{1,2}        # A1 A2 B1 B2 C1 C2
echo {1..10..2}          # 1 3 5 7 9
mkdir -p proj/{src,test}/{2024,2025}

# Parameter expansion
var="archivo.txt.bak"
echo "${var%.bak}"       # "archivo.txt"
echo "${var##*.}"        # "bak"
echo "${var#*.}"         # "txt.bak"

# Indirección
var_contenido="hola"
nombre_var="var_contenido"
echo "${!nombre_var}"    # "hola"

# Transform case
echo "${nombre^}"         # primera mayúscula
echo "${nombre^^}"        # todas mayúsculas

# Mapfile
mapfile -t lineas < archivo.txt

# IFS splitting
IFS=',' read -ra campos <<< "a,b,c"
echo "${campos[1]}"      # "b"

# /dev/tcp (si compilado con --enable-net-redirections)
exec 3<>/dev/tcp/example.com/80
echo -e "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n" >&3
cat <&3
```

## Arrays y funciones avanzadas

```bash
# Slice
echo "${arr[@]:1:3}"

# Shopt
shopt -s globstar       # ** recursivo
shopt -s extglob        # @(pat1|pat2)
shopt -s nullglob       # vacío si no match
shopt -s dotglob        # incluir .files

# Trap con debug
trap 'echo "ERROR en línea $LINENO"' ERR
trap 'echo "DEBUG: $BASH_COMMAND"' DEBUG
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# librería con namespace
lib::log() {
    local level="$1" msg="$2"
    echo "[$(date -Iseconds)] [$level] $msg" >&2
}

lib::die() { lib::log "FATAL" "$1"; exit 1; }

# Hooks
declare -a HOOKS
hook::register() { HOOKS+=("$1"); }
hook::run() { for h in "${HOOKS[@]}"; do $h "$@"; done; }
```

## Herramientas

```bash
# Depuración
bash -x script.sh        # trace
bash -n script.sh        # syntax check
shellcheck -s bash script.sh  # linting

# bashdb: debugger interactivo
# bashdb script.sh

# shellharden: hardening automático
shellharden --transform script.sh

# PS4 profiling
export PS4='+ $(date +%s%N) ${BASH_SOURCE}:${LINENO} '
BASH_XTRACEFD=5; set -x
```

## Relaciones

- [Shell (POSIX)](../Shell/README.md)
- [Sistemas Operativos](../../004-OperatingSystems/README.md)
- [Contenedores](../../006-Containers/README.md)
- [DevOps](../../013-DevOps/README.md)
```