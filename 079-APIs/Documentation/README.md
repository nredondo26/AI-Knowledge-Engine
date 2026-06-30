# Documentación de APIs — Contratos y Herramientas

## Descripción General

La documentación de APIs es el contrato entre proveedores y consumidores. Una buena documentación acelera la integración, reduce errores y mejora la experiencia del desarrollador (DX). Los estándares principales son OpenAPI (REST), GraphQL Schema, y protobuf (gRPC).

---

## OpenAPI / Swagger — El Estándar REST

OpenAPI es una especificación estándar (antes Swagger) para describir APIs REST. Define endpoints, parámetros, respuestas, autenticación y modelos.

```yaml
openapi: 3.0.3
info:
  title: Usuarios API
  description: API para gestión de usuarios
  version: 1.0.0
  contact:
    name: Equipo API
    email: api@ejemplo.com

servers:
  - url: https://api.ejemplo.com/v1
    description: Producción
  - url: https://staging-api.ejemplo.com/v1
    description: Staging

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    Usuario:
      type: object
      required: [nombre, email]
      properties:
        id:
          type: integer
          example: 1
        nombre:
          type: string
          example: Ana López
        email:
          type: string
          format: email
          example: ana@ejemplo.com
        activo:
          type: boolean
          default: true

    Error:
      type: object
      properties:
        error:
          type: string
        code:
          type: integer

paths:
  /usuarios:
    get:
      summary: Listar usuarios
      security:
        - bearerAuth: []
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
            maximum: 100
      responses:
        "200":
          description: Lista de usuarios
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/Usuario'
                  pagination:
                    type: object
                    properties:
                      page: { type: integer }
                      total: { type: integer }

    post:
      summary: Crear usuario
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Usuario'
      responses:
        "201":
          description: Usuario creado
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Usuario'
        "422":
          description: Error de validación
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
```

---

## Herramientas OpenAPI

```javascript
// Express + swagger-jsdoc + swagger-ui-express
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

const options = {
    definition: {
        openapi: '3.0.3',
        info: { title: 'Mi API', version: '1.0.0' },
    },
    apis: ['./src/routes/*.js'],
};

const specs = swaggerJsdoc(options);
app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(specs, {
    customCss: '.swagger-ui .topbar { display: none }',
    customSiteTitle: 'Mi API Docs'
}));

// Endpoint JSON de la especificación
app.get('/api/openapi.json', (req, res) => res.json(specs));
```

```python
# FastAPI genera OpenAPI automáticamente
from fastapi import FastAPI
from fastapi.openapi.utils import get_openapi

app = FastAPI()

@app.get("/api/openapi.json", include_in_schema=False)
async def openapi_json():
    return get_openapi(
        title="Mi API",
        version="1.0.0",
        routes=app.routes,
    )

# Swagger UI en /docs y ReDoc en /redoc automáticos
```

---

## Documentación con Redoc

```html
<!DOCTYPE html>
<html>
<head>
    <title>API Docs</title>
    <link rel="stylesheet" href="https://cdn.redoc.ly/redoc/latest/bundles/redoc.css" />
</head>
<body>
    <redoc spec-url="/api/openapi.json"
           theme='{"colors": {"primary": {"main": "#2563eb"}}}'
           scroll-y-offset="60">
    </redoc>
    <script src="https://cdn.redoc.ly/redoc/latest/bundles/redoc.standalone.js"></script>
</body>
</html>
```

---

## Generación de Clientes (API-First)

```bash
# openapi-generator (Java, Python, TS, Go, etc.)
npx @openapitools/openapi-generator-cli generate \
  -i openapi.yaml \
  -g typescript-fetch \
  -o ./generated-client

# Orval (TypeScript)
npx orval --input ./openapi.yaml --output ./src/api
```

```typescript
// Cliente generado con Orval
import { getUsuarios, createUsuario } from './api/usuarios';

const { data } = await getUsuarios({ page: 1, limit: 20 });
const nuevo = await createUsuario({ nombre: 'Ana', email: 'ana@e.com' });
```

---

## Documentación de GraphQL

GraphQL se autodocumenta mediante introspección. Herramientas como GraphiQL, Apollo Sandbox y GraphQL Voyager exploran el schema.

```graphql
"""
Usuario registrado en el sistema
"""
type Usuario {
  "ID único del usuario"
  id: ID!
  "Nombre completo"
  nombre: String!
  "Email (único)"
  email: String!
  "Indica si la cuenta está activa"
  activo: Boolean!
}

type Query {
  "Obtener lista de usuarios con paginación"
  usuarios(
    "Número de página (1-indexed)"
    page: Int = 1,
    "Elementos por página (máx. 100)"
    limit: Int = 20
  ): [Usuario!]!
}
```

```javascript
// Apollo Sandbox embedded
import { ApolloServer } from '@apollo/server';
import { ApolloServerPluginLandingPageLocalDefault } from '@apollo/server/plugin/landingPage/default';

const server = new ApolloServer({
    typeDefs,
    resolvers,
    plugins: [ApolloServerPluginLandingPageLocalDefault()],
    introspection: process.env.NODE_ENV !== 'production'
});
```

---

## Documentación de gRPC (protobuf)

```protobuf
syntax = "proto3";

package usuarios.v1;

service UsuarioService {
  rpc GetUsuario (GetUsuarioRequest) returns (Usuario);
  rpc ListUsuarios (ListUsuariosRequest) returns (ListUsuariosResponse);
  rpc CreateUsuario (CreateUsuarioRequest) returns (Usuario);
}

message Usuario {
  int32 id = 1;
  string nombre = 2;
  string email = 3;
  bool activo = 4;
}

message GetUsuarioRequest {
  int32 id = 1;
}

message ListUsuariosRequest {
  int32 page = 1;
  int32 limit = 2;
}

// Generar doc: protoc --doc_out=./docs --doc_opt=markdown,api.md
```

---

## API Playground / Try-it

```javascript
// Stoplight Elements
import { API } from '@stoplight/elements';

const Page = () => (
    <API
        apiDescriptionUrl="/api/openapi.json"
        router="hash"
        layout="sidebar"
    />
);

// Postman Collections export
// Insomnia / Bruno (offline-first)
```

---

## Versionado de Documentación

```javascript
// Múltiples versiones en Swagger UI
const v1Specs = swaggerJsdoc({ ...options, definition: { ...base, version: '1.0.0' }, apis: ['./src/routes/v1/*.js'] });
const v2Specs = swaggerJsdoc({ ...options, definition: { ...base, version: '2.0.0' }, apis: ['./src/routes/v2/*.js'] });

app.use('/api/v1/docs', swaggerUi.serve, swaggerUi.setup(v1Specs));
app.use('/api/v2/docs', swaggerUi.serve, swaggerUi.setup(v2Specs));
```

---

## Changelog

```markdown
# Changelog de la API

## v2.0.0 (2026-06-30)
### Added
- Paginación cursor-based en `/usuarios`
- Campo `telefono` en respuesta de usuarios

### Changed
- Formato de errores: ahora `{ error, code, details }`
- Rate limit aumentado de 100 a 200 req/min

### Deprecated
- `/v1/usuarios` — se eliminará el 31/12/2026

### Fixed
- Paginación no devolvía total correcto en ciertos casos
```

---

## Mejores Prácticas

1. **API-First**: Diseñar el contrato antes del código.
2. **Documentación viva**: Generada desde el código (anotaciones/JSDoc).
3. **Ejemplos funcionales**: Request/response reales en cada endpoint.
4. **Try-it console**: Swagger UI, Redoc, Postman docs.
5. **Changelog**: Fechas de deprecación y cambios breaking.
6. **SDK generado**: Clientes auto-generados reducen errores de integración.

---

## Referencias

- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html)
- [Swagger UI](https://swagger.io/tools/swagger-ui)
- [Redoc](https://redocly.com/redoc)
- [Stoplight Elements](https://github.com/stoplightio/elements)
- [GraphQL Documentation](https://graphql.org/learn)
- [protobuf documentation](https://protobuf.dev)
