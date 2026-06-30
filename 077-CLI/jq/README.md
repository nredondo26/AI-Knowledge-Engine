# jq — Procesador JSON de Línea de Comandos

## ¿Qué es jq?

jq es un procesador JSON ligero similar a `sed` para datos JSON. Permite filtrar, transformar y consultar documentos JSON desde la terminal.

## Instalación

```bash
sudo apt install jq              # Debian/Ubuntu
brew install jq                  # macOS
jq --version                     # Verificar
```

## Sintaxis Básica

```bash
jq 'filtro' archivo.json         # Desde archivo
comando | jq 'filtro'           # Desde pipe
```

## Filtros Fundamentales

```bash
jq '.' archivo.json              # Identidad (formatear)
jq '.nombre' archivo.json        # Acceder a propiedad
jq '.usuario.nombre'             # Acceso anidado
jq '.nombre, .edad'              # Múltiples propiedades
jq '.items[0]'                   # Índice de array
jq '.[]'                         # Desenvolver array
jq '.items[].nombre'             # Iterar propiedad
```

## Filtros Avanzados

```bash
# Pipe y construcción
jq '.items[] | {nombre, precio}'
jq '{total: (.precio * .cantidad)}'

# Selección condicional
jq '.[] | select(.edad > 18)'
jq '.[] | select(.edad > 18 and .activo == true)'
jq '.[] | select(has("email"))'
```

## Funciones Incorporadas

```bash
jq '.items | length'             # Longitud
jq 'keys'                        # Claves del objeto
jq '[.[].categoria] | unique'    # Valores únicos
jq 'map(.precio * 1.21)'         # Mapear
jq '[.[].precio] | min/max/add'  # Agregaciones
jq 'sort_by(.nombre)'            # Ordenar
jq 'group_by(.categoria)'        # Agrupar
```

## Transformaciones

```bash
jq '. += {"activo": true}'       # Añadir propiedad
jq 'del(.password)'              # Eliminar propiedad
jq '. * {"nuevo": "valor"}'      # Merge de objetos
jq 'flatten'                     # Aplanar arrays
```

## Formato de Salida

```bash
jq -c '.'                        # Compacto (una línea)
jq -C '.'                        # Con color
jq -r '.nombre'                  # Raw (sin comillas)
```

## Variables

```bash
jq --arg nombre "Juan" '.usuario = $nombre'
jq --argjson extra '{"rol": "admin"}' '. * $extra'
jq -s '.[0] * .[1]' a.json b.json  # Slurp mode
```

## Casos de Uso

```bash
# Procesar API response
curl -s https://api.github.com/repos/stedolan/jq | jq '{name, stars: .stargazers_count}'

# Análisis de logs
cat app.log | grep '^{' | jq -c 'select(.level == "ERROR") | {time, message}'

# Transformar datos
jq '[.[] | {id, nombre: (.first + " " + .last)}]' users.json

# Convertir a CSV
jq -r '.[] | [.id, .name, .email] | @csv' data.json

# Actualizar config
jq '.version = "2.0.0"' package.json > package_new.json
```

## Formatos Especiales

```bash
jq -r '.[] | [.id, .name] | @csv'    # CSV
jq -r '.[] | [.id, .name] | @tsv'    # TSV
jq -r '.url | @uri'                    # URL encode
jq -r '.texto | @base64'               # Base64
```

## Buenas Prácticas

1. Usar `-r` para output sin comillas
2. Usar `-e` para exit code en scripts
3. Comillas simples alrededor del filtro
4. Validar JSON: `jq . archivo.json > /dev/null`

## Recursos

- [jq Manual](https://stedolan.github.io/jq/manual/)
- [jq Playground](https://jqplay.org/)
- [jq Cheatsheet](https://lzone.de/cheat-sheet/jq)
