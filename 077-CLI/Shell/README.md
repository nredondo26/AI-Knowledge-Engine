# Shell — Línea de Comandos Unix/Linux

## ¿Qué es el Shell?

Intérprete de comandos para acceder a servicios del sistema operativo. Los más comunes: Bash (Linux por defecto), Zsh, Fish.

## Comandos Básicos

### Sistema de Archivos

```bash
pwd                     # Directorio actual
ls -la                  # Listar archivos
cd /ruta                # Cambiar directorio
mkdir -p dir1/dir2      # Crear directorios
rm -rf dir              # Eliminar recursivamente
cp -r origen destino    # Copiar
mv origen destino       # Mover/renombrar
find . -name "*.py"     # Buscar archivos
```

### Permisos

```bash
chmod 755 script.sh     # rwxr-xr-x
chmod +x script.sh      # Añadir ejecución
chown user:group file   # Cambiar propietario
```

### Procesos

```bash
ps aux                  # Listar procesos
top                     # Monitor en tiempo real
kill -9 PID             # Matar proceso
nohup comando &         # Segundo plano persistente
```

### Red

```bash
ping host               # Verificar conectividad
curl -I url             # Headers HTTP
wget url                # Descargar archivo
ss -tulpn               # Puertos y conexiones
ssh user@host           # Conexión SSH
```

### Manipulación de Texto

```bash
cat archivo.txt         # Mostrar contenido
less archivo.txt        # Paginación
head -n 10 archivo.txt  # Primeras líneas
tail -f archivo.log     # Seguir escritura
grep "patrón" archivo   # Buscar
sed -i 's/foo/bar/g' f  # Reemplazar
awk '{print $1}' f      # Primera columna
sort | uniq             # Ordenar y únicos
wc -l archivo.txt       # Contar líneas
```

## Redirección y Tuberías

```bash
comando > archivo       # Sobrescribe
comando >> archivo      # Anexa
comando 2>&1            # stderr a stdout
comando1 | comando2     # Pipeline
ps aux | grep python
find . -name "*.log" | xargs rm
```

## Variables y Expansión

```bash
NOMBRE="Mundo"
echo "Hola $NOMBRE"
export PATH="$PATH:/nuevo/dir"
fecha=$(date +%Y-%m-%d)
echo {1..10}
```

## Scripting Básico

```bash
#!/bin/bash
set -euo pipefail

ORIGEN="/home/usuario/datos"
FECHA=$(date +%Y%m%d)

if [ ! -d "$ORIGEN" ]; then
    echo "Error: $ORIGEN no existe"
    exit 1
fi

tar -czf "backup_$FECHA.tar.gz" "$ORIGEN"
```

### Condicionales y Bucles

```bash
if [ "$USER" = "root" ]; then
    echo "Ejecutando como root"
fi

for file in *.py; do
    echo "Procesando: $file"
done

while IFS= read -r line; do
    echo "Línea: $line"
done < archivo.txt
```

## Personalización del Prompt

```bash
# En ~/.bashrc
PS1='[\u@\h \W]\$ '
```

## Buenas Prácticas

1. Usar `set -euo pipefail` en scripts
2. Preferir `[[ ]]` sobre `[ ]` en Bash
3. Citar variables: `"$var"`
4. Usar `trap` para limpieza
5. Usar `$(comando)` sobre comillas invertidas

## Recursos

- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [Explain Shell](https://explainshell.com/)
- [ShellCheck](https://www.shellcheck.net/)
