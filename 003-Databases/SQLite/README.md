# SQLite

## Modelado

SQLite es una base de datos relacional embebida sin servidor. El modelado es similar a otros motores SQL, con limitaciones: no tiene tipos fijos (type affinity), no admite concurrencia de escritura intensiva, y las FK se validan solo si se habilita.

### Type Affinity y schemas

```sql
PRAGMA journal_mode = WAL;
PRAGMA foreign_keys = ON;
PRAGMA page_size = 4096;
PRAGMA cache_size = -64000;  -- 64MB

CREATE TABLE articles (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid        TEXT NOT NULL UNIQUE,
    title       TEXT NOT NULL,
    body        TEXT,
    status      TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published')),
    word_count  INTEGER,
    metadata    BLOB,  -- JSON binario con json1 extension
    created_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE tags (
    id   INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE COLLATE NOCASE
);

CREATE TABLE articles_tags (
    article_id INTEGER NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
    tag_id     INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (article_id, tag_id)
) WITHOUT ROWID;

-- Índices
CREATE INDEX idx_articles_status ON articles(status, created_at);
CREATE INDEX idx_articles_title ON articles(title COLLATE NOCASE);
CREATE VIRTUAL TABLE articles_fts USING fts5(title, body, content=articles);
```

## Consultas

### Full-Text Search con FTS5

```sql
-- Búsqueda con ranking (BM25)
SELECT a.id, a.title, rank
FROM articles_fts
JOIN articles a ON a.id = articles_fts.rowid
WHERE articles_fts MATCH 'inteligencia OR artificial'
ORDER BY rank
LIMIT 20;

-- Snippet con contexto
SELECT snippet(articles_fts, 1, '<b>', '</b>', '...', 32)
FROM articles_fts
WHERE articles_fts MATCH 'base de datos';
```

### CTE y window functions

```sql
WITH tag_counts AS (
    SELECT t.name, COUNT(at.article_id) AS cnt
    FROM tags t
    LEFT JOIN articles_tags at ON at.tag_id = t.id
    GROUP BY t.id
),
ranked_tags AS (
    SELECT name, cnt,
           RANK() OVER (ORDER BY cnt DESC) AS rk
    FROM tag_counts
)
SELECT name, cnt FROM ranked_tags WHERE rk <= 10;

-- Recursiva para jerarquías
WITH RECURSIVE tree AS (
    SELECT id, parent_id, name, 0 AS depth
    FROM categories WHERE parent_id IS NULL
    UNION ALL
    SELECT c.id, c.parent_id, c.name, t.depth + 1
    FROM categories c JOIN tree t ON c.parent_id = t.id
)
SELECT * FROM tree ORDER BY depth, name;
```

### Upsert con conflicto

```sql
INSERT INTO tags (name) VALUES ('machine learning')
ON CONFLICT(name) DO UPDATE SET
    name = excluded.name
WHERE tags.name != excluded.name;

-- Reemplazar parcialmente
INSERT OR REPLACE INTO articles (id, title, body)
VALUES (42, 'Nuevo título', 'Nuevo cuerpo');
```

## Índices

```sql
-- Índice parcial para consultas comunes
CREATE INDEX idx_published_recent
ON articles(created_at) WHERE status = 'published';

-- Índice expresivo (SQLite 3.32+)
CREATE INDEX idx_lower_title ON articles(LOWER(title));

-- Índice covering para COUNT
CREATE INDEX idx_status_count ON articles(status) WHERE status = 'published';

-- Sin índice covering completo (SQLite no tiene INCLUDE),
-- pero se puede forzar con tabla con indices separados

EXPLAIN QUERY PLAN
SELECT title FROM articles WHERE status = 'published' ORDER BY created_at DESC;
```

## Configuración (PRAGMAs)

```sql
-- Optimización de conexión
PRAGMA journal_mode = WAL;          -- Write-Ahead Log: mejor concurrencia
PRAGMA synchronous = NORMAL;        -- balance seguridad/velocidad
PRAGMA temp_store = MEMORY;         -- tablas temporales en RAM
PRAGMA mmap_size = 268435456;       -- 256MB memory-mapped I/O
PRAGMA busy_timeout = 5000;         -- esperar 5s en lugar de fallar
PRAGMA automatic_index = OFF;       -- control manual de índices

-- Integridad (por conexión)
PRAGMA foreign_keys = ON;
PRAGMA integrity_check;

-- Cache
PRAGMA cache_size = -80000;         -- 80MB
PRAGMA optimize;                    -- optimizar estadísticas
```

### Configuración para producción (embebido)

```sql
-- Aplicación de alto rendimiento (riesgo de corrupción mínimo)
PRAGMA journal_mode = WAL;
PRAGMA synchronous = OFF;           -- solo si se acepta riesgo
PRAGMA locking_mode = NORMAL;

-- Backup en caliente
PRAGMA wal_checkpoint(TRUNCATE);
```

## Conexión desde aplicación

```python
import aiosqlite
import sqlite3

# Uso básico con aiosqlite
async with aiosqlite.connect("knowledge.db") as db:
    db.row_factory = aiosqlite.Row
    await db.execute("PRAGMA journal_mode=WAL")
    await db.execute("PRAGMA foreign_keys=ON")

    await db.execute("""
        INSERT INTO articles (uuid, title, body, status)
        VALUES (?, ?, ?, 'published')
    """, ("uuid-abc", "My Article", "Body content..."))
    await db.commit()

    # Query con múltiples filas
    cursor = await db.execute("""
        SELECT id, title FROM articles
        WHERE status = ? ORDER BY created_at DESC LIMIT ?
    """, ("published", 20))
    rows = await cursor.fetchall()
    return [dict(row) for row in rows]
```

## Monitoreo

```sql
-- Diagnóstico
PRAGMA database_list;
PRAGMA page_count;
PRAGMA page_size;
PRAGMA freelist_count;      -- páginas libres = desperdicio

-- Estadísticas de índices
PRAGMA index_info(idx_articles_status);
PRAGMA index_xinfo(idx_articles_status);

-- Perfilamiento
PRAGMA stats;

-- Análisis de consultas
EXPLAIN QUERY PLAN SELECT * FROM articles WHERE status = 'published';
```
