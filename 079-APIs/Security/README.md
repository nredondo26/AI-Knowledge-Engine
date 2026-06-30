# Seguridad en APIs — Protección de Endpoints y Datos

## Descripción General

La seguridad en APIs abarca autenticación, autorización, validación de entrada, cifrado, rate limiting y protección contra ataques como inyección, XSS, CSRF, y abuse de endpoints. Sigue el OWASP API Security Top 10 como referencia principal.

---

## OWASP API Security Top 10

| # | Riesgo | Descripción |
|---|--------|-------------|
| 1 | Broken Object Level Authorization | Usuario accede a objetos ajenos |
| 2 | Broken Authentication | Fallas en autenticación |
| 3 | Broken Object Property Level | Acceso a campos sensibles |
| 4 | Unrestricted Resource Consumption | Sin rate limiting |
| 5 | Broken Function Level Authorization | Admin endpoints accesibles |
| 6 | Unrestricted Access to Sensitive Business Flows | Abuso de flujos críticos |
| 7 | Server Side Request Forgery (SSRF) | El servidor hace requests no autorizadas |
| 8 | Security Misconfiguration | Config insegura (CORS, headers) |
| 9 | Improper Inventory Management | Endpoints olvidados/documentados |
| 10 | Unsafe Consumption of APIs | APIs que consumen APIs sin validación |

---

## Autenticación con JWT

```javascript
import jwt from 'jsonwebtoken';

// Login
app.post('/api/auth/login', async (req, res) => {
    const { email, password } = req.body;
    const user = await db.findUser(email);
    if (!user || !bcrypt.compareSync(password, user.hash)) {
        return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    const token = jwt.sign(
        { sub: user.id, role: user.role },
        process.env.JWT_SECRET,
        { expiresIn: '15m', issuer: 'mi-api' }
    );

    const refreshToken = jwt.sign(
        { sub: user.id, type: 'refresh' },
        process.env.JWT_REFRESH_SECRET,
        { expiresIn: '7d' }
    );

    res.json({ access_token: token, refresh_token: refreshToken });
});

// Refresh
app.post('/api/auth/refresh', (req, res) => {
    const { refresh_token } = req.body;
    try {
        const decoded = jwt.verify(refresh_token, process.env.JWT_REFRESH_SECRET);
        const newToken = jwt.sign(
            { sub: decoded.sub },
            process.env.JWT_SECRET,
            { expiresIn: '15m' }
        );
        res.json({ access_token: newToken });
    } catch {
        res.status(401).json({ error: 'Refresh token inválido o expirado' });
    }
});

// Auth middleware
function authenticate(req, res, next) {
    const header = req.headers.authorization;
    if (!header?.startsWith('Bearer ')) {
        return res.status(401).json({ error: 'Token requerido' });
    }
    try {
        req.user = jwt.verify(header.split(' ')[1], process.env.JWT_SECRET);
        next();
    } catch {
        res.status(401).json({ error: 'Token inválido o expirado' });
    }
}
```

---

## Autorización (RBAC)

```javascript
// Rol-based access control
function authorize(...allowedRoles) {
    return (req, res, next) => {
        if (!req.user || !allowedRoles.includes(req.user.role)) {
            return res.status(403).json({ error: 'No autorizado' });
        }
        next();
    };
}

app.get('/api/admin/usuarios',
    authenticate,
    authorize('admin', 'superadmin'),
    async (req, res) => {
        const users = await db.getAllUsers();
        res.json({ data: users });
    }
);

// Object-level authorization
app.get('/api/usuarios/:id',
    authenticate,
    async (req, res) => {
        if (req.user.role !== 'admin' && req.user.sub !== req.params.id) {
            return res.status(403).json({ error: 'No puedes ver este recurso' });
        }
        const user = await db.findUser(req.params.id);
        res.json({ data: user });
    }
);
```

---

## Validación de Input

```javascript
import { body, query, param, validationResult } from 'express-validator';

app.post('/api/usuarios',
    body('email').isEmail().normalizeEmail(),
    body('password').isLength({ min: 8 }).matches(/[A-Z]/).matches(/[0-9]/),
    body('nombre').trim().isLength({ min: 2, max: 100 }),
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        }
        // Procesar request válido
    }
);

// Sanitización (anti XSS/NoSQL injection)
import DOMPurify from 'isomorphic-dompurify';
import { MongoSanitize } from 'express-mongo-sanitize';

app.use(express.json());
app.use(MongoSanitize());

app.post('/api/comentarios', (req, res) => {
    const limpio = DOMPurify.sanitize(req.body.texto);
    // Guardar comentario sanitizado
});
```

---

## Cabeceras de Seguridad

```javascript
import helmet from 'helmet';

app.use(helmet({
    contentSecurityPolicy: {
        directives: {
            defaultSrc: ["'self'"],
            scriptSrc: ["'self'", "https://cdn.ejemplo.com"],
            styleSrc: ["'self'", "'unsafe-inline'"],
            imgSrc: ["'self'", "data:"],
            connectSrc: ["'self'", "https://api.ejemplo.com"],
            fontSrc: ["'self'", "https://fonts.gstatic.com"],
        }
    },
    hsts: {
        maxAge: 31536000,
        includeSubDomains: true,
        preload: true
    },
    referrerPolicy: { policy: 'strict-origin-when-cross-origin' }
}));

// Conjunto mínimo
// Content-Security-Policy: default-src 'self'
// X-Content-Type-Options: nosniff
// X-Frame-Options: DENY
// Strict-Transport-Security: max-age=31536000; includeSubDomains
// Permissions-Policy: geolocation=(), microphone=(), camera=()
```

---

## CORS Seguro

```javascript
import cors from 'cors';

app.use(cors({
    origin: [
        'https://app.ejemplo.com',
        'https://admin.ejemplo.com'
    ],
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Authorization', 'Content-Type'],
    exposedHeaders: ['X-Request-Id'],
    credentials: true,
    maxAge: 86400
}));

// No usar en producción:
// app.use(cors({ origin: '*' }))
```

---

## Rate Limiting

```javascript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
    windowMs: 15 * 60 * 1000,   // 15 minutos
    max: 100,                     // 100 requests por ventana
    standardHeaders: true,
    legacyHeaders: false,
    message: { error: 'Demasiadas solicitudes, intenta de nuevo más tarde' },
    keyGenerator: (req) => req.ip
});

app.use('/api/', limiter);

// Rate limiting por endpoint
const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 5,
    message: { error: 'Demasiados intentos de login' }
});

app.use('/api/auth/login', authLimiter);
```

---

## API Keys

```javascript
const API_KEYS = new Set([process.env.API_KEY_1, process.env.API_KEY_2]);

function validateApiKey(req, res, next) {
    const key = req.headers['x-api-key'];
    if (!key || !API_KEYS.has(key)) {
        return res.status(401).json({ error: 'API Key inválida' });
    }
    next();
}

app.get('/api/public/productos', validateApiKey, async (req, res) => {
    // Endpoint público pero con API Key
});
```

---

## Cifrado de Datos Sensibles

```javascript
import crypto from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const ENCRYPTION_KEY = process.env.ENCRYPTION_KEY; // 32 bytes

function encrypt(text) {
    const iv = crypto.randomBytes(12);
    const cipher = crypto.createCipheriv(ALGORITHM, ENCRYPTION_KEY, iv);
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return { iv: iv.toString('hex'), encrypted, tag: cipher.getAuthTag().toString('hex') };
}

function decrypt(encryptedData) {
    const decipher = crypto.createDecipheriv(
        ALGORITHM,
        ENCRYPTION_KEY,
        Buffer.from(encryptedData.iv, 'hex')
    );
    decipher.setAuthTag(Buffer.from(encryptedData.tag, 'hex'));
    let decrypted = decipher.update(encryptedData.encrypted, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
}

// Almacenar datos sensibles cifrados
app.post('/api/usuarios', async (req, res) => {
    const encryptedSSN = encrypt(req.body.ssn);
    await db.saveUser({
        ...req.body,
        ssn_encrypted: encryptedSSN.encrypted,
        ssn_iv: encryptedSSN.iv,
        ssn_tag: encryptedSSN.tag
    });
});
```

---

## Logging Seguro

```javascript
// Nunca loguear secrets, tokens, passwords
function sanitizeLog(obj) {
    const sensitive = ['password', 'token', 'secret', 'authorization', 'cookie'];
    return JSON.parse(JSON.stringify(obj, (key, value) =>
        sensitive.includes(key.toLowerCase()) ? '[REDACTED]' : value
    ));
}

app.use((req, res, next) => {
    logger.info({
        method: req.method,
        path: req.path,
        query: sanitizeLog(req.query),
        user: req.user?.sub || 'anonymous'
    });
    next();
});
```

---

## Mejores Prácticas

1. **HTTPS obligatorio**: HSTS, redirección HTTP→HTTPS.
2. **JWT corto**: Access token 15min, refresh token rotado.
3. **Validar todo input**: Whitelist, sanitización, parametrización.
4. **Principio de mínimo privilegio**: RBAC, ABAC, object-level checks.
5. **Rate limiting**: Por IP, por usuario, por endpoint.
6. **Auditoría**: Loggear accesos sensibles sin datos personales.
7. **Dependencias**: Snyk/Dependabot para vulnerabilidades.

---

## Referencias

- [OWASP API Security Top 10](https://owasp.org/www-project-api-security)
- [JWT Best Practices](https://auth0.com/blog/a-look-at-the-latest-draft-for-jwt-bcp)
- [Helmet.js](https://helmetjs.github.io)
- [Express Rate Limit](https://github.com/express-rate-limit/express-rate-limit)
