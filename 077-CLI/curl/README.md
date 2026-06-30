# curl — Cliente HTTP y Transferencia de Datos

## ¿Qué es curl?

curl (Client URL) transfiere datos con sintaxis URL. Soporta HTTP, HTTPS, FTP, SFTP, LDAP, SMTP y más. Herramienta esencial para depuración de APIs y automatización.

## Instalación

```bash
sudo apt install curl            # Debian/Ubuntu
brew install curl                # macOS
```

## Peticiones HTTP

```bash
# GET
curl https://api.example.com/users

# POST con JSON
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Juan", "email": "juan@ex.com"}'

# PUT / PATCH / DELETE
curl -X PUT https://api.example.com/users/1 -d '{"name": "Juan"}'
curl -X DELETE https://api.example.com/users/1
```

## Headers

```bash
curl -H "Authorization: Bearer token123" URL
curl -H "Accept: application/json" URL
curl -A "MyApp/1.0" URL             # User-Agent
```

## Parámetros de Consulta

```bash
curl "https://api.example.com/search?q=python&page=1"
curl -G "https://api.example.com/search" \
  --data-urlencode "q=python language"
```

## Autenticación

```bash
curl -u username:password URL                    # Basic Auth
curl -H "Authorization: Bearer <token>" URL      # Bearer
curl -H "X-API-Key: <key>" URL                   # API Key
```

## Manejo de Respuestas

```bash
curl -I URL                          # Solo headers
curl -i URL                          # Headers + cuerpo
curl -s URL                          # Silencioso
curl -sS URL                         # Silent con errores
curl -o /dev/null -w "%{http_code}" -s URL    # Solo código
curl -v URL                          # Verboso (debug)
```

## Timings

```bash
curl -w "\nConnect: %{time_connect}s\n\
TTFB: %{time_starttransfer}s\n\
Total: %{time_total}s\n" -o /dev/null -s URL
```

## Descarga de Archivos

```bash
curl -o archivo.zip URL              # Nombre personalizado
curl -O URL                          # Nombre original
curl -C - -O URL                     # Reanudar descarga
curl -L URL                          # Seguir redirecciones
curl --limit-rate 100K -O URL        # Límite de velocidad
```

## Envío de Datos

```bash
curl -d "nombre=Juan&edad=30" URL    # Formulario
curl -F "imagen=@foto.jpg" URL       # Multipart
curl -d @data.json -H "Content-Type: application/json" URL
```

## Cookies

```bash
curl -b "session=abc123" URL         # Enviar cookies
curl -c cookies.txt URL             # Guardar cookies
curl -b cookies.txt URL             # Usar cookies guardadas
```

## Proxy

```bash
curl -x http://proxy:8080 URL
curl --socks5 127.0.0.1:1080 URL
```

## SSL/TLS

```bash
curl -k URL                          # Ignorar SSL (solo testing)
curl --cacert /path/to/ca-bundle.crt URL
curl --tlsv1.2 URL
```

## Configuración Avanzada

```bash
curl --connect-timeout 10 URL        # Timeout conexión
curl --max-time 30 URL              # Timeout total
curl --retry 3 URL                  # Reintentos
curl --compressed URL               # Comprimir respuesta
```

## Casos de Uso

```bash
# Verificar servidor
curl -o /dev/null -s -w "%{http_code}" https://example.com

# Obtener IP pública
curl -s https://api.ipify.org

# Health check
curl -f --connect-timeout 5 http://localhost:8080/health

# Subir archivo
curl -F "file=@report.pdf;type=application/pdf" https://api.example.com/upload
```

## Buenas Prácticas

1. Usar `-sS` para silenciar progreso pero mostrar errores
2. Usar `-f` para exit code en errores HTTP
3. Especificar `Content-Type` al enviar datos
4. Validar SSL en producción (no usar `-k`)
5. Usar `--retry` para fallos transitorios

## Recursos

- [Documentación oficial](https://curl.se/docs/)
- [Everything curl](https://everything.curl.dev/)
