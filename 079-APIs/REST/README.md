# REST — Representational State Transfer

## Descripción General

REST es un estilo arquitectónico para servicios web (Roy Fielding, 2000). Usa HTTP estándar sobre recursos identificados por URIs. Una API que sigue estos principios es **RESTful**.

---

## Principios Fundamentales

1. **Cliente-Servidor**: Separación frontend/backend.
2. **Stateless**: Cada petición es autónoma; el servidor no guarda sesión.
3. **Cacheable**: Respuestas indican cacheabilidad (`Cache-Control`, `ETag`).
4. **Interfaz Uniforme**: Recursos, representaciones, mensajes autodescriptivos, HATEOAS.
5. **Sistema por Capas**: Proxies, gateways, balanceadores.

---

## Métodos HTTP y CRUD

| Método | CRUD | Idempotente | Seguro |
|--------|------|-------------|--------|
| `GET` | Read | ✅ | ✅ |
| `POST` | Create | ❌ | ❌ |
| `PUT` | Replace | ✅ | ❌ |
| `PATCH` | Partial update | ❌ | ❌ |
| `DELETE` | Delete | ✅ | ❌ |

---

## Diseño de URIs

```
GET    /api/usuarios                    → Listar
GET    /api/usuarios/{id}              → Obtener
POST   /api/usuarios                   → Crear
PUT    /api/usuarios/{id}              → Reemplazar
PATCH  /api/usuarios/{id}              → Modificar parcial
DELETE /api/usuarios/{id}              → Eliminar

GET    /api/usuarios?rol=admin&page=2&limit=20&sort=nombre&order=asc
GET    /api/v1/usuarios
```

---

## Códigos de Estado HTTP

| Código | Significado |
|--------|-------------|
| `200 OK` | GET, PUT, PATCH exitosos |
| `201 Created` | POST exitoso |
| `204 No Content` | DELETE exitoso |
| `400 Bad Request` | Solicitud inválida |
| `401 Unauthorized` | Autenticación requerida |
| `403 Forbidden` | Sin permisos |
| `404 Not Found` | No encontrado |
| `409 Conflict` | Duplicado/versión obsoleta |
| `422 Unprocessable` | Error de validación |
| `429 Too Many Requests` | Rate limit |
| `500 Internal Server Error` | Error del servidor |

---

## Ejemplo con Express.js

```javascript
import express from 'express';
import { body, validationResult } from 'express-validator';

const app = express(); app.use(express.json());
let usuarios = [{ id: 1, nombre: 'Ana López', email: 'ana@e.com', activo: true }];
let nextId = 2;

app.get('/api/usuarios', (req, res) => {
  let result = [...usuarios];
  const { activo, page = 1, limit = 10 } = req.query;
  if (activo !== undefined) result = result.filter(u => u.activo === (activo === 'true'));
  const total = result.length; const start = (Number(page)-1)*Number(limit);
  res.json({ data: result.slice(start, start+Number(limit)), pagination: { page: Number(page), limit: Number(limit), total } });
});

app.get('/api/usuarios/:id', (req, res) => {
  const u = usuarios.find(u => u.id === Number(req.params.id));
  if (!u) return res.status(404).json({ error: 'No encontrado' });
  res.json({ data: u });
});

app.post('/api/usuarios', body('nombre').isString().notEmpty(), body('email').isEmail(), (req, res) => {
  const errs = validationResult(req); if (!errs.isEmpty()) return res.status(422).json({ errors: errs.array() });
  if (usuarios.some(u => u.email === req.body.email)) return res.status(409).json({ error: 'Email duplicado' });
  const nuevo = { id: nextId++, nombre: req.body.nombre, email: req.body.email, activo: true };
  usuarios.push(nuevo); res.status(201).json({ data: nuevo });
});

app.put('/api/usuarios/:id', (req, res) => {
  const i = usuarios.findIndex(u => u.id === Number(req.params.id));
  if (i === -1) return res.status(404).json({ error: 'No encontrado' });
  usuarios[i] = { id: Number(req.params.id), ...req.body };
  res.json({ data: usuarios[i] });
});

app.patch('/api/usuarios/:id', (req, res) => {
  const i = usuarios.findIndex(u => u.id === Number(req.params.id));
  if (i === -1) return res.status(404).json({ error: 'No encontrado' });
  usuarios[i] = { ...usuarios[i], ...req.body };
  res.json({ data: usuarios[i] });
});

app.delete('/api/usuarios/:id', (req, res) => {
  const i = usuarios.findIndex(u => u.id === Number(req.params.id));
  if (i === -1) return res.status(404).json({ error: 'No encontrado' });
  usuarios.splice(i, 1); res.status(204).send();
});

app.listen(3000, () => console.log('REST en http://localhost:3000'));
```

---

## HATEOAS

```json
{
  "data": { "id": 1, "nombre": "Ana", "_links": { "self": "/api/usuarios/1", "pedidos": "/api/usuarios/1/pedidos" } },
  "_links": { "collection": "/api/usuarios", "create": { "href": "/api/usuarios", "method": "POST" } }
}
```

---

## Autenticación JWT

```javascript
function auth(req, res, next) {
  const h = req.headers.authorization;
  if (!h?.startsWith('Bearer ')) return res.status(401).json({ error: 'Token requerido' });
  try { req.user = jwt.verify(h.split(' ')[1], process.env.JWT_SECRET); next(); }
  catch { res.status(401).json({ error: 'Token inválido' }); }
}
```

---

## Content Negotiation

```javascript
app.get('/api/usuarios/:id', (req, res) => {
  res.format({
    'application/json': () => res.json(usuario),
    'application/xml': () => res.type('application/xml').send(`<usuario><id>${usuario.id}</id></usuario>`),
    default: () => res.status(406).send('Not Acceptable'),
  });
});
```

---

## Buenas Prácticas

Sustantivos plurales para recursos. Versionar desde inicio. Paginación con page/limit. Errores consistentes (`{ error, message, details }`). Rate limiting con express-rate-limit. ETag para caching.

---

## Referencias

- [Roy Fielding — REST Dissertation](https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm)
- [Microsoft REST Guidelines](https://github.com/microsoft/api-guidelines)
- [JSON:API Specification](https://jsonapi.org)
