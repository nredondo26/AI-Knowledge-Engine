# PostgreSQL

## Modelado

PostgreSQL es un motor relacional-objeto. El modelado se basa en tablas, tipos, dominios, herencia y extensiones como PostGIS. Soporta datos estructurados, JSONB, arrays, rangos y datos compuestos.

### Diagrama conceptual

```sql
CREATE TYPE user_role AS ENUM ('admin', 'editor', 'viewer');

CREATE TABLE users (
    id          BIGSERIAL PRIMARY KEY,
    username    VARCHAR(64) NOT NULL UNIQUE,
    email       CITEXT UNIQUE,
    role        user_role DEFAULT 'viewer',
    metadata    JSONB DEFAULT '{}',
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE articles (
    id          BIGSERIAL PRIMARY KEY,
    author_id   BIGINT NOT NULL REFERENCES users(id),
    title       TEXT NOT NULL,
    body        TEXT,
    tags        TEXT[],
    search_vec  TSVECTOR GENERATED ALWAYS AS (
                    to_tsvector('spanish', coalesce(title,'') || ' ' || coalesce(body,''))
                 ) STORED,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### Particionamiento

```sql
CREATE TABLE logs (
    id BIGSERIAL, level TEXT, message TEXT, logged_at TIMESTAMPTZ
) PARTITION BY RANGE (logged_at);

CREATE TABLE logs_2024 PARTITION OF logs
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
CREATE TABLE logs_2025 PARTITION OF logs
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
```

## Consultas

### Búsqueda textual con ranking

```sql
SELECT title,
       ts_rank(search_vec, plainto_tsquery('spanish', 'inteligencia artificial')) AS rank
FROM articles
WHERE search_vec @@ plainto_tsquery('spanish', 'inteligencia artificial')
ORDER BY rank DESC
LIMIT 20;
```

### CTE y ventanas

```sql
WITH ranked AS (
    SELECT u.username, a.title,
           ROW_NUMBER() OVER (PARTITION BY a.author_id ORDER BY a.created_at DESC) AS rn
    FROM articles a
    JOIN users u ON u.id = a.author_id
)
SELECT username, title FROM ranked WHERE rn <= 5;
```

### Recursiva (árbol de categorías)

```sql
WITH RECURSIVE tree AS (
    SELECT id, name, parent_id, 1 AS depth
    FROM categories WHERE parent_id IS NULL
    UNION ALL
    SELECT c.id, c.name, c.parent_id, t.depth + 1
    FROM categories c JOIN tree t ON c.parent_id = t.id
)
SELECT * FROM tree ORDER BY depth, name;
```

## Índices

```sql
-- B-tree estándar (únicos y compuestos ya los crea la PK)
CREATE INDEX idx_articles_author ON articles(author_id);

-- Índice GiST para búsqueda de rango
CREATE INDEX idx_logs_date ON logs USING gist (logged_at);

-- Índice GIN para JSONB (operador @>, ?, ?|)
CREATE INDEX idx_users_metadata ON users USING gin (metadata jsonb_path_ops);

-- Índice GIN para tsvector
CREATE INDEX idx_articles_search ON articles USING gin (search_vec);

-- Índice parcial
CREATE INDEX idx_users_active ON users(id) WHERE role != 'viewer';
```

## Configuración (postgresql.conf)

```ini
shared_buffers = 4GB                # 25% de RAM
effective_cache_size = 12GB         # 75% de RAM
work_mem = 64MB                     # por operación de ordenamiento
maintenance_work_mem = 1GB          # VACUUM, CREATE INDEX
random_page_cost = 1.1              # para SSD
effective_io_concurrency = 200      # discos SSD
wal_buffers = 64MB
max_connections = 100
checkpoint_completion_target = 0.9
default_statistics_target = 500     # mejora planes
```

### Tuning para OLTP vs OLAP

```ini
# OLTP: muchas escrituras concurrentes
synchronous_commit = off
wal_writer_delay = 1000ms

# OLAP: consultas pesadas
jit = on
parallel_query_workers = 4
```

## Conexión desde aplicación (Python)

```python
import asyncpg
import psycopg2

# Conexión con pool
pool = await asyncpg.create_pool(
    dsn="postgresql://user:pass@localhost:5432/knowledge",
    min_size=4, max_size=20,
    command_timeout=30
)

async with pool.acquire() as conn:
    rows = await conn.fetch("""
        SELECT id, username
        FROM users
        WHERE email ILIKE $1
    """, "%@example.com")

# UPSERT
await conn.execute("""
    INSERT INTO users (username, email)
    VALUES ($1, $2)
    ON CONFLICT (username) DO UPDATE
    SET email = EXCLUDED.email
""", "jdoe", "j@example.com")
```

## Monitoreo

```sql
-- Consultas lentas
SELECT query, calls, total_exec_time / calls AS avg_ms
FROM pg_stat_statements
ORDER BY total_exec_time DESC LIMIT 10;

-- Bloqueos activos
SELECT pid, locktype, relation::regclass, mode, granted
FROM pg_locks WHERE NOT granted;

-- Tamaño de tablas
SELECT relname, pg_size_pretty(pg_total_relation_size(relid))
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;
```
