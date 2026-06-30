# MariaDB

## Modelado

MariaDB es un fork de MySQL con motores adicionales (Aria, XtraDB, ColumnStore, Spider, MyRocks). Soporta `INET6`, `UUID`, columnas dinámicas y tablas del sistema.

```sql
CREATE TABLE users (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid        UUID NOT NULL UNIQUE,
    username    VARCHAR(64) NOT NULL,
    email       VARCHAR(255),
    status      ENUM('active','inactive','banned') DEFAULT 'active',
    last_login  DATETIME,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email(100)),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE posts (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT UNSIGNED NOT NULL,
    title       VARCHAR(255) NOT NULL,
    slug        VARCHAR(255) NOT NULL UNIQUE,
    body        LONGTEXT,
    view_count  INT UNSIGNED DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_created (user_id, created_at DESC),
    FULLTEXT INDEX ft_search (title, body)
) ENGINE=Aria;
```

### Columnas dinámicas (MariaDB 10+)

```sql
INSERT INTO products VALUES (1, 'Laptop', COLUMN_CREATE('color','silver','ram',16,'ssd',512));

SELECT id, name,
       COLUMN_GET(attributes, 'ram' AS INTEGER) AS ram,
       COLUMN_GET(attributes, 'color' AS CHAR)  AS color
FROM products;
```

## Consultas

```sql
WITH ranked AS (
    SELECT u.username, p.title, p.view_count,
           RANK() OVER (PARTITION BY p.user_id ORDER BY p.view_count DESC) AS rk
    FROM posts p JOIN users u ON u.id = p.user_id
)
SELECT username, title, view_count FROM ranked WHERE rk <= 3;

-- Búsqueda FULLTEXT
SELECT id, title,
       MATCH(title, body) AGAINST('inteligencia artificial' IN BOOLEAN MODE) AS relevance
FROM posts
WHERE MATCH(title, body) AGAINST('inteligencia artificial' IN BOOLEAN MODE)
ORDER BY relevance DESC;
```

## Índices

```sql
CREATE INDEX idx_user_date_views ON posts(user_id, created_at DESC, view_count);
CREATE INDEX idx_lower_email ON users((LOWER(email)));   -- funcional (10.5+)
ALTER TABLE posts ADD INDEX idx_draft (status) INVISIBLE; -- pruebas A/B

EXPLAIN ANALYZE SELECT COUNT(*) FROM posts WHERE user_id = 42 AND created_at > '2025-01-01';
```

## Configuración (my.cnf)

```ini
[mariadb]
innodb_buffer_pool_size = 4G          # 70-80% RAM
innodb_log_file_size = 1G
max_connections = 500
tmp_table_size = 64M
default_storage_engine = InnoDB
aria_pagecache_buffer_size = 256M
slow_query_log = 1
long_query_time = 1.0
server_id = 1
log_bin = /var/log/mysql/mariadb-bin
binlog_format = ROW
```

## Conexión desde aplicación

```python
import aiomysql

pool = await aiomysql.create_pool(
    host='localhost', port=3306,
    user='app', password='secret', db='knowledge',
    minsize=5, maxsize=20, autocommit=True
)

async with pool.acquire() as conn:
    async with conn.cursor(aiomysql.DictCursor) as cur:
        await cur.execute("""
            INSERT INTO posts (user_id, title, slug, body)
            VALUES (%s, %s, %s, %s)
        """, (42, "Título", "titulo", "Cuerpo..."))
        await conn.commit()
        await cur.execute("SELECT LAST_INSERT_ID()")
        new_id = await cur.fetchone()
```

## Monitoreo

```sql
SHOW FULL PROCESSLIST;
SELECT POOL_ID, FREE_BUFFERS, DATABASE_PAGES FROM INFORMATION_SCHEMA.INNODB_BUFFER_POOL_STATS;
SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST;
```
