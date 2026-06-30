# MySQL

## Modelado

MySQL (InnoDB) es relacional con soporte ACID. Modelar implica elegir tipos precisos, claves primarias clusterizadas y motores de almacenamiento.

### Buenas prácticas de esquema

```sql
CREATE TABLE users (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid        CHAR(36) NOT NULL UNIQUE COMMENT 'UUID v4 for sharding',
    username    VARCHAR(64) NOT NULL,
    email       VARCHAR(255),
    status      ENUM('active','inactive','banned') DEFAULT 'active',
    last_login  DATETIME,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email(100)),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE posts (
    id          BIGINT UNSIGNED AUTO_INCREMENT,
    user_id     BIGINT UNSIGNED NOT NULL,
    title       VARCHAR(255) NOT NULL,
    slug        VARCHAR(255) NOT NULL,
    body        LONGTEXT,
    view_count  INT UNSIGNED DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_slug (slug),
    INDEX idx_user_created (user_id, created_at DESC),
    FULLTEXT INDEX ft_search (title, body)
) ENGINE=InnoDB;
```

### Particionamiento por RANGE

```sql
ALTER TABLE posts
PARTITION BY RANGE (YEAR(created_at)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
```

## Consultas

### JOIN y agregación

```sql
SELECT u.username,
       COUNT(p.id) AS total_posts,
       COALESCE(AVG(p.view_count), 0) AS avg_views
FROM users u
LEFT JOIN posts p ON p.user_id = u.id
WHERE u.status = 'active'
GROUP BY u.id
HAVING total_posts > 5
ORDER BY avg_views DESC
LIMIT 50;
```

### Búsqueda FULLTEXT

```sql
SELECT id, title,
       MATCH(title, body) AGAINST('inteligencia artificial' IN NATURAL LANGUAGE MODE) AS relevance
FROM posts
WHERE MATCH(title, body) AGAINST('inteligencia artificial' IN BOOLEAN MODE)
ORDER BY relevance DESC;
```

### Ventana (MySQL 8+)

```sql
SELECT username, title, created_at,
       RANK() OVER (PARTITION BY user_id ORDER BY view_count DESC) AS rk
FROM posts p
JOIN users u ON u.id = p.user_id;
```

## Índices

```sql
-- Índice compuesto cubriente
CREATE INDEX idx_user_date_views ON posts(user_id, created_at, view_count);

-- Índice inverso para ORDER BY DESC
CREATE INDEX idx_created_desc ON posts(created_at DESC);

-- Índice funcional (MySQL 8.0.13+)
CREATE INDEX idx_lower_email ON users((LOWER(email)));

-- Índice invisible (para pruebas)
ALTER TABLE posts ADD INDEX idx_draft (status) INVISIBLE;

-- Índice con prefijo para VARCHAR largo
CREATE INDEX idx_body_prefix ON posts(body(100));
```

### Uso de EXPLAIN

```sql
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM posts
WHERE user_id = 42 AND created_at > '2025-01-01';
```

## Configuración (my.cnf)

```ini
[mysqld]
innodb_buffer_pool_size = 4G          # 70-80% RAM en servidor dedicado
innodb_log_file_size = 1G             # transacciones grandes
innodb_flush_log_at_trx_commit = 2    # balance rendimiento/durabilidad
innodb_file_per_table = 1
innodb_flush_method = O_DIRECT
max_connections = 500
tmp_table_size = 64M
max_heap_table_size = 64M
sort_buffer_size = 2M
read_buffer_size = 128K
read_rnd_buffer_size = 256K
join_buffer_size = 256K

# Slow query log
slow_query_log = 1
long_query_time = 1.0
log_queries_not_using_indexes = 1

# Replicación
server_id = 1
binlog_format = ROW
expire_logs_days = 7
```

## Conexión desde aplicación

```python
import aiomysql
import pymysql

# Pool asíncrono
pool = await aiomysql.create_pool(
    host='localhost', port=3306,
    user='app', password='secret', db='knowledge',
    minsize=5, maxsize=20,
    autocommit=True
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
-- Procesos activos
SHOW FULL PROCESSLIST;

-- Estado del buffer pool
SELECT POOL_ID, FREE_BUFFERS, DATABASE_PAGES
FROM INFORMATION_SCHEMA.INNODB_BUFFER_POOL_STATS;

-- Consultas en ejecución
SELECT * FROM sys.session WHERE conn_id != CONNECTION_ID();

-- Tablas sin índice primario
SELECT DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES t
WHERE NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS s
    WHERE s.TABLE_SCHEMA = t.TABLE_SCHEMA
      AND s.TABLE_NAME = t.TABLE_NAME
      AND s.INDEX_NAME = 'PRIMARY'
);
```
