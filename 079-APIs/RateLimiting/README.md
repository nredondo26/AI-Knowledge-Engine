# Rate Limiting — Control de Tráfico en APIs

## Descripción General

Rate limiting (limitación de tasa) controla el número de solicitudes que un cliente puede hacer a una API en un período de tiempo determinado. Previene abusos, protege contra DoS/DDoS, distribuye recursos equitativamente y asegura la disponibilidad del servicio.

---

## Algoritmos de Rate Limiting

| Algoritmo | Descripción | Pros | Contras |
|-----------|-------------|------|---------|
| **Token Bucket** | Tokens se añaden a tasa constante; cada request consume uno | Permite bursts, simple | Memory-bound |
| **Leaky Bucket** | Requests entran a un buffer y se procesan a tasa constante | Flujo uniforme | No permite bursts |
| **Sliding Window Log** | Ventana temporal deslizante con timestamps | Preciso | Alta memoria |
| **Sliding Window Counter** | Contadores en ventanas de tiempo discretas | Eficiente | Aproximado |
| **Fixed Window** | Contador por ventana fija (ej. 100 req/hora) | Simple | Burst en bordes |

---

## Token Bucket (Implementación)

```javascript
class TokenBucket {
    constructor(capacity, fillRate) {
        this.capacity = capacity;     // Máximo de tokens
        this.fillRate = fillRate;      // Tokens por segundo
        this.tokens = capacity;
        this.lastRefill = Date.now();
    }

    refill() {
        const now = Date.now();
        const elapsed = (now - this.lastRefill) / 1000;
        this.tokens = Math.min(this.capacity, this.tokens + elapsed * this.fillRate);
        this.lastRefill = now;
    }

    consume(count = 1) {
        this.refill();
        if (this.tokens >= count) {
            this.tokens -= count;
            return true;
        }
        return false;
    }
}

// Uso
const bucket = new TokenBucket(100, 10); // 100 tokens, 10 tokens/s
setInterval(() => {
    if (bucket.consume()) {
        console.log('Request procesado');
    } else {
        console.log('Rate limit excedido');
    }
}, 50);
```

---

## Sliding Window Counter (Redis)

```javascript
import { createClient } from 'redis';

const redis = createClient({ url: process.env.REDIS_URL });

async function slidingWindowRateLimit(key, limit, windowMs) {
    const now = Date.now();
    const windowStart = now - windowMs;

    // Transacción atómica
    const multi = redis.multi();
    multi.zRemRangeByScore(key, 0, windowStart);
    multi.zAdd(key, { score: now, value: `${now}-${Math.random()}` });
    multi.zCard(key);
    multi.expire(key, Math.ceil(windowMs / 1000));

    const [, , count] = await multi.exec();

    if (count > limit) {
        return { allowed: false, remaining: Math.max(0, limit - count + 1) };
    }

    return { allowed: true, remaining: limit - count, resetAt: now + windowMs };
}

// Middleware Express
async function rateLimitMiddleware(req, res, next) {
    const key = `ratelimit:${req.ip}:${req.path}`;
    const result = await slidingWindowRateLimit(key, 100, 60000);

    res.set('X-RateLimit-Limit', '100');
    res.set('X-RateLimit-Remaining', result.remaining);
    res.set('X-RateLimit-Reset', Math.ceil(result.resetAt / 1000));

    if (!result.allowed) {
        return res.status(429).json({
            error: 'Demasiadas solicitudes',
            retryAfter: Math.ceil((result.resetAt - Date.now()) / 1000)
        });
    }
    next();
}

app.use('/api/', rateLimitMiddleware);
```

---

## Rate Limiting Distribuido (Redis + Express)

```javascript
import rateLimit from 'express-rate-limit';
import RedisStore from 'rate-limit-redis';

const limiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    standardHeaders: true,
    store: new RedisStore({
        sendCommand: (...args) => redis.sendCommand(args),
        prefix: 'rl:'
    }),
    message: { error: 'Demasiadas solicitudes' },
    keyGenerator: (req) => `${req.ip}:${req.user?.sub || 'anon'}`
});

app.use('/api/', limiter);
```

---

## Rate Limiting por Usuario vs IP

```javascript
function perUserLimiter(userLimit = 1000, ipLimit = 100) {
    return async (req, res, next) => {
        const key = req.user?.sub
            ? `user:${req.user.sub}`
            : `ip:${req.ip}`;

        const max = req.user?.sub ? userLimit : ipLimit;
        const result = await checkLimit(key, max, 3600000); // 1 hora

        if (!result.allowed) {
            return res.status(429).json({ error: 'Límite excedido' });
        }
        next();
    };
}
```

---

## Rate Limiting por Endpoint

```javascript
const limits = {
    '/api/auth/login': { window: 15 * 60 * 1000, max: 5 },
    '/api/auth/register': { window: 60 * 60 * 1000, max: 3 },
    '/api/search': { window: 60 * 1000, max: 30 },
    '/api/payments': { window: 60 * 1000, max: 10 },
    'default': { window: 60 * 1000, max: 100 }
};

function dynamicLimiter(req, res, next) {
    const config = limits[req.path] || limits['default'];
    const key = `${req.ip}:${req.path}`;
    // checkLimit(key, config.max, config.window)
}
```

---

## Headers Estandarizados

```
# Respuesta exitosa
HTTP/1.1 200 OK
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1800000

# Rate limit excedido
HTTP/1.1 429 Too Many Requests
Retry-After: 3600
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1875000000
Content-Type: application/json

{ "error": "Demasiadas solicitudes", "retryAfter": 3600 }
```

---

## Backoff Estrategias (Cliente)

```javascript
class ApiClient {
    constructor(baseUrl) {
        this.baseUrl = baseUrl;
    }

    async request(path, options = {}) {
        const maxRetries = options.maxRetries || 3;
        let attempt = 0;

        while (attempt < maxRetries) {
            const response = await fetch(`${this.baseUrl}${path}`, options);

            if (response.status === 429) {
                const retryAfter = parseInt(
                    response.headers.get('Retry-After') || '60'
                );
                const delay = retryAfter * 1000 + Math.random() * 1000;
                console.warn(`Rate limited, retrying in ${retryAfter}s`);
                await new Promise(r => setTimeout(r, delay));
                attempt++;
                continue;
            }

            return response;
        }

        throw new Error('Max retries exceeded');
    }
}
```

---

## Concurrency Limiting (Nº conexiones simultáneas)

```javascript
import Bottleneck from 'bottleneck';

const limiter = new Bottleneck({
    maxConcurrent: 10,
    minTime: 100,  // 100ms entre requests
    reservoir: 100, // Tokens totales
    reservoirRefreshAmount: 100,
    reservoirRefreshInterval: 60 * 1000
});

// Cliente con rate limiting
const client = limiter.wrap(fetch);

async function main() {
    const results = await Promise.all(
        urls.map(url => client(`https://api.ejemplo.com${url}`))
    );
}
```

---

## Monitoreo y Alertas

```javascript
// Métricas Prometheus
import prometheus from 'prom-client';

const rateLimitCounter = new prometheus.Counter({
    name: 'rate_limit_blocked_total',
    help: 'Total de requests bloqueados por rate limiting',
    labelNames: ['path', 'method', 'client']
});

// En middleware
if (!result.allowed) {
    rateLimitCounter.inc({ path: req.path, method: req.method, client: req.ip });
    res.status(429).json({ error: 'Rate limit' });
}
```

---

## Mejores Prácticas

1. **Capas múltiples**: CDN (Cloudflare), API Gateway, app layer.
2. **Headers informativos**: Siempre devolver remaining, limit, reset.
3. **Retry-After preciso**: No solo 429, decir cuándo reintentar.
4. **Límites por usuario vs IP**: Usuarios autenticados: límite mayor.
5. **Endpoint diferencial**: Login (bajo), Read (medio), Write (medio).
6. **Distribuido**: Redis/Memcached para múltiples instancias.
7. **Alertas**: Notificar cuando un cliente excede consistentemente.

---

## Referencias

- [IETF RateLimit Header Fields (draft)](https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers)
- [Express Rate Limit](https://github.com/express-rate-limit/express-rate-limit)
- [Bottleneck (Node.js)](https://github.com/SGrondin/bottleneck)
- [Cloudflare Rate Limiting](https://developers.cloudflare.com/waf/rate-limiting-rules)
