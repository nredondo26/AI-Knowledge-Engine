#!/bin/bash
# AI Knowledge Engine - Continuation Tool
# Uso: ./continue.sh [status|next|work|track]
#   status  - Muestra el progreso general
#   next    - Muestra el siguiente directorio pendiente
#   work    - Abre el README del siguiente directorio pendiente
#   track   - Marca el directorio actual como completado

ENGINE_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_FILE="$ENGINE_DIR/.engine.state"

show_status() {
    total=$(python3 -c "import json; s=json.load(open('$STATE_FILE')); print(len(s['pending'])+len(s['completed'])+len(s['in_progress']))")
    done=$(python3 -c "import json; s=json.load(open('$STATE_FILE')); print(len(s['completed']))")
    pct=$((done * 100 / total))
    echo "========================================"
    echo " AI Knowledge Engine - Progreso"
    echo "========================================"
    echo " Total: $total directorios"
    echo " Completados: $done ($pct%)"
    echo " En progreso: $(python3 -c "import json; s=json.load(open('$STATE_FILE')); print(len(s['in_progress']))")"
    echo " Pendientes: $(python3 -c "import json; s=json.load(open('$STATE_FILE')); print(len(s['pending']))")"
    echo "========================================"
    echo ""
    echo "Último trabajado: $(python3 -c "import json; s=json.load(open('$STATE_FILE')); print(s.get('last_worked','N/A'))")"
    echo ""
    echo "Comandos:"
    echo "  ./continue.sh next  -> Siguiente pendiente"
    echo "  ./continue.sh work  -> Trabajar en siguiente"
    echo "  ./continue.sh track -> Marcar actual como completado"
}

show_next() {
    next_dir=$(python3 -c "
import json
s=json.load(open('$STATE_FILE'))
if s['pending']:
    print(s['pending'][0])
else:
    print('ALL_DONE')
")
    if [ "$next_dir" = "ALL_DONE" ]; then
        echo "🎉 Todos los directorios están completados."
    else
        echo "Siguiente: $next_dir"
        echo "Tema: $(echo $next_dir | sed 's/^[0-9]*-//')"
    fi
}

do_work() {
    next_dir=$(python3 -c "
import json
s=json.load(open('$STATE_FILE'))
if s['pending']:
    print(s['pending'][0])
else:
    print('ALL_DONE')
")
    if [ "$next_dir" = "ALL_DONE" ]; then
        echo "🎉 Todos los directorios están completados."
        exit 0
    fi

    # Move from pending to in_progress
    python3 -c "
import json
s=json.load(open('$STATE_FILE'))
if s['pending']:
    d=s['pending'].pop(0)
    s['in_progress'].append(d)
    s['last_worked']=d
    json.dump(s, open('$STATE_FILE','w'), indent=2)
    print(d)
"
    echo "Abriendo: $ENGINE_DIR/$next_dir/README.md"
    # Try to open with available editor
    if command -v code &>/dev/null; then
        code "$ENGINE_DIR/$next_dir/README.md"
    elif command -v nano &>/dev/null; then
        nano "$ENGINE_DIR/$next_dir/README.md"
    elif command -v vim &>/dev/null; then
        vim "$ENGINE_DIR/$next_dir/README.md"
    else
        echo "README: $ENGINE_DIR/$next_dir/README.md"
    fi
}

do_track() {
    current=$(python3 -c "
import json
s=json.load(open('$STATE_FILE'))
if s['in_progress']:
    d=s['in_progress'].pop(0)
    s['completed'].append(d)
    json.dump(s, open('$STATE_FILE','w'), indent=2)
    print(d)
else:
    print('NONE')
")
    if [ "$current" = "NONE" ]; then
        echo "No hay directorio en progreso para marcar."
    else
        echo "✅ Marcado como completado: $current"
        show_next
    fi
}

case "${1:-status}" in
    status) show_status ;;
    next)   show_next ;;
    work)   do_work ;;
    track)  do_track ;;
    *)      echo "Uso: $0 [status|next|work|track]" ;;
esac
