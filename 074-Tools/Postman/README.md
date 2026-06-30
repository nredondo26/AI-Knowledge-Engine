# Postman — Plataforma de Colaboración para APIs

## ¿Qué es Postman?

Postman es una plataforma integral para desarrollo, prueba, documentación y monitoreo de APIs. Herramienta indispensable para desarrolladores backend, frontend y QA.

## Características Principales

- **Cliente REST/GraphQL**: Envía peticiones HTTP y visualiza respuestas.
- **Colecciones**: Agrupa peticiones relacionadas.
- **Entornos**: Variables según contexto (dev, staging, producción).
- **Tests automatizados**: Scripts en JavaScript para validar respuestas.
- **Documentación automática**: Genera documentación interactiva.
- **Monitores**: Ejecuta colecciones periódicamente.
- **Mock Servers**: Simula endpoints sin backend real.

## Instalación

- **Desktop**: Postman standalone para Windows, macOS, Linux.
- **Web**: Postman Web desde el navegador.
- **CLI**: Newman para terminal o CI/CD.

## Conceptos Básicos

Componentes de una petición:
- **Método**: GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
- **URL**: Endpoint de la API
- **Headers**: Metadatos (Content-Type, Authorization)
- **Body**: Datos (raw, form-data, x-www-form-urlencoded, binary, GraphQL)
- **Params**: Parámetros de consulta en URL

### Variables

| Ámbito | Alcance |
|--------|---------|
| Global | Todas las colecciones y entornos |
| Colección | Dentro de una colección |
| Entorno | Entorno activo (dev, staging, prod) |
| Local | Script o petición |

Sintaxis: `{{variable_name}}`

## Scripting

### Pre-request Script (antes de enviar)
```javascript
pm.variables.set("timestamp", Date.now());
```

### Test Script (después de recibir)
```javascript
pm.test("Status code is 200", () => {
    pm.response.to.have.status(200);
});
pm.test("Response contains data", () => {
    const data = pm.response.json();
    pm.expect(data.id).to.eql(123);
});
pm.environment.set("authToken", pm.response.json().token);
```

## Newman CLI

```bash
npm install -g newman
newman run coleccion.json -e entorno.json
newman run coleccion.json -r htmlextra
```

## Entornos

Conjuntos de variables agrupados:
- **Desarrollo**: `{{base_url}} = http://localhost:3000`
- **Staging**: `https://staging.api.com`
- **Producción**: `https://api.com`

## Documentación Automática

Postman genera documentación interactiva con descripciones, ejemplos de peticiones/respuestas y código generado en múltiples lenguajes.

## Integraciones

- **CI/CD**: Jenkins, GitHub Actions, GitLab CI, CircleCI
- **Slack, Teams, PagerDuty**: Notificaciones
- **Swagger/OpenAPI**: Importación y exportación

## Buenas Prácticas

1. Usar entornos para separar configuraciones
2. Escribir tests para peticiones críticas
3. Documentar cada endpoint con descripciones
4. Versionar colecciones en Git (exportar como JSON)
5. Usar variables para evitar valores hardcodeados
6. Compartir colecciones mediante workspaces

## Atajos (Desktop)

| Atajo | Acción |
|-------|--------|
| Ctrl + Enter | Enviar petición |
| Ctrl + S | Guardar |
| Ctrl + ` | Abrir consola |

## Recursos

- [Documentación oficial](https://learning.postman.com/)
- [Postman API Network](https://www.postman.com/explore)
