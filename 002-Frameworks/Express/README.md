# Express

## Descripción

Express es un framework web minimalista para Node.js, creado por TJ Holowaychuk en 2010. Proporciona ruteo, middlewares, manejo de peticiones HTTP y soporte para motores de plantillas. Es la base de muchos frameworks modernos (NestJS, Sails) y es ampliamente usado para APIs REST, aplicaciones web y microservicios.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Middleware** | Funciones que procesan peticiones/respuestas en cadena. |
| **Routing** | `app.get()`, `app.post()`, `app.use()` para definir rutas. |
| **Router** | `express.Router()` para agrupar rutas en módulos. |
| **Error handling** | Middleware de 4 args `(err, req, res, next)`. |
| **Body parsing** | `express.json()` y `express.urlencoded()`. |

---

## Ejemplos de código

### Servidor básico

```javascript
import express from 'express';

const app = express();
app.use(express.json());

app.get('/', (req, res) => res.json({ mensaje: 'Hola Mundo' }));

app.listen(3000, () => console.log('Server en puerto 3000'));
```

### API REST CRUD

```javascript
import express from 'express';
const app = express();
app.use(express.json());

let tareas = [{ id: 1, texto: 'Aprender Express', completada: false }];
let nextId = 2;

app.get('/api/tareas', (req, res) => res.json(tareas));

app.post('/api/tareas', (req, res) => {
  const tarea = { id: nextId++, ...req.body, completada: false };
  tareas.push(tarea);
  res.status(201).json(tarea);
});

app.put('/api/tareas/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const idx = tareas.findIndex((t) => t.id === id);
  if (idx === -1) return res.status(404).json({ error: 'No encontrada' });
  tareas[idx] = { ...tareas[idx], ...req.body };
  res.json(tareas[idx]);
});

app.delete('/api/tareas/:id', (req, res) => {
  tareas = tareas.filter((t) => t.id !== parseInt(req.params.id));
  res.status(204).send();
});

app.listen(3000);
```

### Router y middleware

```javascript
// routes/usuarios.js
import { Router } from 'express';
export const router = Router();

router.get('/', (req, res) => res.json([{ id: 1, nombre: 'Ana' }]));

// app.js
import express from 'express';
import { router as usuariosRouter } from './routes/usuarios.js';

const app = express();
app.use('/api/usuarios', usuariosRouter);

// Middleware de autenticación
const auth = (req, res, next) => {
  if (!req.headers.authorization) return res.status(401).json({ error: 'No autorizado' });
  next();
};

app.get('/api/admin', auth, (req, res) => res.json({ mensaje: 'Admin' }));
```

### Manejo de errores

```javascript
class AppError extends Error {
  constructor(message, statusCode = 500) {
    super(message);
    this.statusCode = statusCode;
  }
}

app.get('/api/error', (req, res, next) => next(new AppError('No encontrado', 404)));

app.use((err, req, res, next) => {
  res.status(err.statusCode || 500).json({
    error: err.message,
    stack: process.env.NODE_ENV === 'development' ? err.stack : undefined,
  });
});
```

---

## Hoja de ruta

```
1. Node.js fundamentals (módulos, event loop, promesas)
2. Ruteo básico (GET, POST, PUT, DELETE, params)
3. Middlewares (built-in, terceros, personalizados)
4. Routers modulares (express.Router)
5. Manejo de errores (centralizado, asyncHandler)
6. BD (MongoDB + Mongoose, PostgreSQL + Prisma)
7. Autenticación (JWT, bcrypt, Passport.js)
8. Validación (express-validator, Zod)
9. Testing (Supertest + Jest)
10. Producción (dotenv, PM2, Docker)
```
