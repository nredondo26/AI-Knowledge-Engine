# Versionado de APIs — Estrategias y Mejores Prácticas

## Descripción General

El versionado de APIs permite evolucionar un servicio sin romper a los clientes existentes. Es esencial para mantener compatibilidad hacia atrás mientras se añaden funcionalidades, se modifican campos o se deprecan endpoints.

---

## Estrategias de Versionado

| Estrategia | Ejemplo | Pros | Contras |
|------------|---------|------|---------|
| **URL Path** | `/api/v1/usuarios` | Simple, visible, fácil de cachear | URLs largas, mezcla de versiones |
| **Query Param** | `/api/usuarios?version=1` | Misma URL base | Cacheo complejo, no estándar |
| **Header** | `Accept: application/vnd.api+json;version=1` | URLs limpias | Complejo de debuggear |
| **Content Negotiation** | `Accept: application/vnd.miapp.v1+json` | RESTful puro | Mayor complejidad |

---

## Versionado por URL Path

```javascript
// Express.js
import express from 'express';
const app = express();

// V1
const v1 = express.Router();
v1.get('/usuarios', (req, res) => {
    res.json({ data: [], version: '1.0' });
});
app.use('/api/v1', v1);

// V2
const v2 = express.Router();
v2.get('/usuarios', (req, res) => {
    res.json({
        data: [],
        meta: { version: '2.0', total: 0 },
        links: { self: '/api/v2/usuarios' }
    });
});
app.use('/api/v2', v2);

app.listen(3000);
```

---

## Versionado por Header (Accept)

```javascript
// FastAPI (Python)
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

app = FastAPI()

@app.get("/api/usuarios")
async def get_usuarios(request: Request):
    accept = request.headers.get("accept", "")

    if "vnd.miapp.v2" in accept:
        return JSONResponse({
            "data": [],
            "meta": {"version": "2", "total": 0}
        })

    # Default V1
    return JSONResponse({"data": [], "version": "1"})
```

```bash
# Uso
curl -H "Accept: application/vnd.miapp.v1+json" https://api.ejemplo.com/usuarios
curl -H "Accept: application/vnd.miapp.v2+json" https://api.ejemplo.com/usuarios
```

---

## Política de Deprecación (Sunset)

```javascript
// Middleware de deprecación
function deprecationCheck(req, res, next) {
    const version = req.path.match(/\/api\/(v\d+)/)?.[1];

    if (version === 'v1') {
        res.set('Sunset', 'Sat, 31 Dec 2026 23:59:59 GMT');
        res.set('Deprecation', 'true');
        res.set('Link', '</api/v2/usuarios>; rel="successor-version"');
    }

    next();
}

app.use(deprecationCheck);
```

---

## Compatibilidad hacia atrás

```javascript
// V2 añade campo "telefono" pero mantiene campos de V1
app.get('/api/v2/usuarios/:id', (req, res) => {
    const usuario = db.find(u => u.id === req.params.id);
    res.json({
        ...usuario,           // id, nombre, email (compat V1)
        telefono: usuario.telefono ?? null,  // Nuevo en V2
        _version: '2.0'
    });
});

// Query param para opt-in a campos nuevos
// GET /api/v2/usuarios/1?include=telefono,avatar
```

---

## Evolución de Schema (Migraciones)

```sql
-- Base de datos: soportar múltiples versiones
ALTER TABLE usuarios ADD COLUMN telefono VARCHAR(20);
ALTER TABLE usuarios ADD COLUMN avatar_url TEXT;

-- V1 endpoint usa columnas originales
-- V2 endpoint usa todo
```

```javascript
// Transformers de respuesta por versión
function transformResponse(user, version) {
    const base = { id: user.id, nombre: user.nombre, email: user.email };

    if (version === 1) return base;
    if (version === 2) return { ...base, telefono: user.telefono ?? null };
    if (version === 3) return { ...base, telefono: user.telefono, avatar: user.avatar_url };
}
```

---

## Enrutamiento con API Gateway

```yaml
# Kong API Gateway
services:
  - name: usuarios-v1
    url: http://backend-v1:3000
    routes:
      - paths: [/api/v1/usuarios]

  - name: usuarios-v2
    url: http://backend-v2:3000
    routes:
      - paths: [/api/v2/usuarios]

  - name: usuarios-router
    url: http://router:3000
    routes:
      - paths: [/api/usuarios]
        hosts: [api.ejemplo.com]
    plugins:
      - name: request-transformer
        config:
          add:
            headers:
              - X-API-Version: $request_version
```

---

## Versionado de Schemas (OpenAPI)

```yaml
openapi: 3.0.3
info:
  title: Usuarios API
  version: "2.0"
  description: API de usuarios con soporte multi-versión
  x-versions:
    - "1.0" (deprecated)
    - "2.0" (current)

paths:
  /v1/usuarios:
    get:
      deprecated: true
      summary: "[V1] Listar usuarios"
      responses:
        "200":
          description: Lista de usuarios (formato V1)
  /v2/usuarios:
    get:
      summary: "[V2] Listar usuarios"
      responses:
        "200":
          description: Lista de usuarios con paginación
```

---

## Mejores Prácticas

1. **Versionar desde el día 1**: Incluso `/v1` aunque sea la primera.
2. **Deprecación planificada**: Anunciar sunset con 6-12 meses de anticipación.
3. **Header Sunset**: Incluir fecha de deprecación en respuestas de versiones viejas.
4. **Mantener V1 mínimo**: No añadir features a V1, solo bugs críticos.
5. **Documentar cambios**: Changelog claro por versión.
6. **Pruebas de compatibilidad**: Tests que verifican V1 y V2 simultáneamente.

---

## Referencias

- [Microsoft API Versioning Guidelines](https://github.com/microsoft/api-guidelines/blob/vNext/Guidelines.md#12-versioning)
- [Stripe API Changelog](https://stripe.com/docs/changelog)
- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html)
- [Sunset Header RFC 8594](https://datatracker.ietf.org/doc/html/rfc8594)
