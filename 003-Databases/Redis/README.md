# Redis

## Modelado

Redis es un almacén en memoria clave-valor con estructuras de datos avanzadas. El modelado consiste en elegir la estructura óptima según el patrón de acceso.

### Estructuras clave

```bash
# String: caché simple, sesiones, contadores
SET user:1000:session "token-abc-123" EX 3600
SET article:42:views 1000
INCR article:42:views

# Hash: objetos planos (menor huella que string serializado)
HSET user:1000 username "jdoe" email "j@example.com" role "admin"
HGETALL user:1000

# List: colas, timelines
LPUSH notifications:user:1000 "nuevo_seguidor"
BRPOP notifications:user:1000 0

# Set: membresía, etiquetas
SADD article:42:tags "database" "nosql" "cache"
SISMEMBER article:42:tags "cache"

# Sorted Set: rankings, colas priorizadas
ZADD leaderboard 1500 "user:1000" 1200 "user:1001"
ZREVRANGE leaderboard 0 9 WITHSCORES

# Bitmap: analítica binaria (100M flags ≈ 12MB)
SETBIT users:active:2025-06-01 1000 1
BITCOUNT users:active:2025-06-01

# HyperLogLog: cardinalidad aproximada (~0.8% error)
PFADD page_views:2025-06 "unique_ip_1" "unique_ip_2"
PFCOUNT page_views:2025-06

# Stream: mensajería, logs, eventos
XADD events * type "publish" article_id 42
XREAD COUNT 10 STREAMS events 0
```

## Consultas / Comandos

### Patrones avanzados

```bash
# Rate limiting (Sliding Window con Sorted Set)
MULTI
ZADD rate:api:user:1000:minute 1625000000 "req_1"
ZREMRANGEBYSCORE rate:api:user:1000:minute 0 1624999400
EXPIRE rate:api:user:1000:minute 60
ZCARD rate:api:user:1000:minute
EXEC

# Caché con invalidation pattern
GET article:42:html
# Si no existe:
SET article:42:html "<html>..." EX 3600

# Pub/Sub
SUBSCRIBE channel:updates
PUBLISH channel:updates "{\"event\":\"article_updated\",\"id\":42}"

# Lua scripting (transaccional y atómico)
EVAL "
  local key = KEYS[1]
  local limit = tonumber(ARGV[1])
  local current = redis.call('GET', key) or 0
  if current + 1 > limit then return 0 end
  redis.call('INCR', key)
  redis.call('EXPIRE', key, 60)
  return 1
" 1 rate:email:user:1000 5
```

## Configuración (redis.conf)

```ini
# Memoria
maxmemory 4gb
maxmemory-policy allkeys-lfu        # evicción LFU para caché
# maxmemory-policy volatile-ttl      # para expiración controlada

# Persistencia
save 900 1
save 300 10
save 60 10000
appendonly yes
appendfsync everysec                # no usar always en prod

# Seguridad
requirepass "redis_secret_strong"
rename-command FLUSHALL ""
rename-command FLUSHDB ""
rename-command DEBUG ""

# Red
bind 127.0.0.1
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300

# Cluster (si aplica)
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
```

## Conexión desde aplicación

```python
import aioredis
import orjson

redis = await aioredis.from_url(
    "redis://:password@localhost:6379/0",
    max_connections=50,
    decode_responses=True
)

# Caché de objetos con serialización eficiente
async def get_article(article_id: int):
    key = f"article:{article_id}:data"
    cached = await redis.get(key)
    if cached:
        return orjson.loads(cached)

    data = {"id": article_id, "title": "Redis Guide", "views": 42}
    await redis.setex(key, 3600, orjson.dumps(data))
    return data

# Pipeline para múltiples operaciones
async with redis.pipeline(transaction=True) as pipe:
    pipe.incr("stats:total_requests")
    pipe.zincrby("leaderboard:daily", 1, "user:1000")
    pipe.lpush("audit:log", "request_processed")
    await pipe.execute()
```

## Monitoreo

```bash
# Información del servidor
redis-cli INFO stats
redis-cli INFO memory | grep human
redis-cli INFO commandstats

# Latencia
redis-cli --latency -h localhost -p 6379

# Keyspace
redis-cli INFO keyspace

# Slow log
redis-cli SLOWLOG GET 10
redis-cli SLOWLOG LEN

# Big keys
redis-cli --bigkeys

# Monitoreo en tiempo real
redis-cli MONITOR
```
