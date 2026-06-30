# OpenAPI — Especificación para APIs REST

## Descripción General

OpenAPI (anteriormente Swagger) es un estándar para describir APIs REST en YAML/JSON. Actualmente **OpenAPI 3.1.0**, alineado con JSON Schema 2020-12.

---

## Estructura del Documento

```yaml
openapi: 3.1.0
info:
  title: API de Usuarios
  description: API RESTful para gestión de usuarios
  version: 1.0.0
  contact: { name: Equipo, email: dev@ejemplo.com }
servers:
  - url: https://api.ejemplo.com/v1
    description: Producción
  - url: http://localhost:3000
    description: Local

paths:
  /usuarios:
    get:
      summary: Listar usuarios
      operationId: listarUsuarios
      parameters:
        - name: page; in: query; schema: { type: integer, minimum: 1, default: 1 }
        - name: limit; in: query; schema: { type: integer, minimum: 1, maximum: 100, default: 10 }
        - name: activo; in: query; schema: { type: boolean }
      responses:
        '200':
          description: Lista paginada
          content:
            application/json:
              schema: { $ref: '#/components/schemas/ListaUsuariosResponse' }
        '400': { $ref: '#/components/responses/BadRequest' }

    post:
      summary: Crear usuario
      operationId: crearUsuario
      requestBody:
        required: true
        content:
          application/json:
            schema: { $ref: '#/components/schemas/CrearUsuarioRequest' }
      responses:
        '201': { description: Creado, content: { application/json: { schema: { $ref: '#/components/schemas/UsuarioResponse' } } } }
        '409': { description: Email duplicado }

  /usuarios/{id}:
    get:
      summary: Obtener usuario por ID
      parameters: [{ name: id, in: path, required: true, schema: { type: integer, minimum: 1 } }]
      responses:
        '200': { description: OK, content: { application/json: { schema: { $ref: '#/components/schemas/UsuarioResponse' } } } }
        '404': { $ref: '#/components/responses/NotFound' }
    delete:
      summary: Eliminar usuario
      parameters: [{ $ref: '#/components/parameters/usuarioIdPath' }]
      responses: { '204': { description: Eliminado }, '404': { $ref: '#/components/responses/NotFound' } }

components:
  securitySchemes:
    bearerAuth: { type: http, scheme: bearer, bearerFormat: JWT }

  parameters:
    usuarioIdPath: { name: id, in: path, required: true, schema: { type: integer, minimum: 1 } }

  schemas:
    UsuarioResponse:
      type: object
      properties:
        id: { type: integer, example: 1 }
        nombre: { type: string, example: "Ana López" }
        email: { type: string, format: email, example: "ana@ejemplo.com" }
        activo: { type: boolean, example: true }
        fechaRegistro: { type: string, format: date-time }
      required: [id, nombre, email, activo]

    ListaUsuariosResponse:
      type: object
      properties:
        data: { type: array, items: { $ref: '#/components/schemas/UsuarioResponse' } }
        pagination:
          type: object
          properties: { page: { type: integer }, limit: { type: integer }, total: { type: integer }, totalPages: { type: integer } }

    CrearUsuarioRequest:
      type: object
      required: [nombre, email]
      properties:
        nombre: { type: string, minLength: 1, maxLength: 100 }
        email: { type: string, format: email }

    ErrorResponse:
      type: object
      properties:
        error: { type: object, properties: { code: { type: string }, message: { type: string }, details: { type: array, items: { type: object, properties: { field: { type: string }, message: { type: string } } } } }, required: [code, message] }
```

---

## Swagger UI (Documentación interactiva)

```html
<link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5/swagger-ui.css">
<div id="swagger-ui"></div>
<script src="https://unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js"></script>
<script>
  SwaggerUIBundle({ url: '/openapi.yaml', dom_id: '#swagger-ui', presets: [SwaggerUIBundle.presets.apis], tryItOutEnabled: true });
</script>
```

---

## OpenAPI Generator

```bash
# Cliente TypeScript
npx @openapitools/openapi-generator-cli generate -i openapi.yaml -g typescript-axios -o ./src/generated

# Servidor Express
npx @openapitools/openapi-generator-cli generate -i openapi.yaml -g node-express-server -o ./server
```

---

## Validación con Express

```javascript
import { validate } from 'express-openapi-validator';

app.use(validate({
  apiSpec: './openapi.yaml',
  validateRequests: true,
  validateResponses: true,
}));

app.get('/v1/usuarios', (req, res) => {
  // req.query ya validado por el middleware
  res.json({ data: [], pagination: { page: 1, limit: 10, total: 0, totalPages: 0 } });
});

app.use((err, req, res, next) => {
  res.status(err.status || 400).json({ error: { code: 'VALIDATION_ERROR', message: err.message, details: err.errors } });
});
```

---

## OpenAPI 3.1 vs 3.0

| Característica | 3.0.x | 3.1.0 |
|----------------|-------|-------|
| JSON Schema | Draft 07 | 2020-12 |
| `nullable` | Propiedad separada | `type: ["string","null"]` |
| Webhooks | No | Sí (top-level) |
| `$id`/`$anchor` | No | Sí |

---

## Linting CI

```yaml
name: OpenAPI Lint
on: [pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npx @redocly/cli lint openapi.yaml
```

---

## Buenas Prácticas

operationId único. Parámetros reutilizables en `components`. Errores estandarizados (RFC 7807). Documentar todos los códigos de estado. Semver en `info.version`. Ejemplos en schemas. Versionar el spec, no solo la URL.

---

## Referencias

- [OpenAPI Specification v3.1.0](https://spec.openapis.org/oas/v3.1.0)
- [Swagger UI](https://swagger.io/tools/swagger-ui)
- [OpenAPI Generator](https://openapi-generator.tech)
- [Redocly CLI](https://redocly.com/docs/cli)
