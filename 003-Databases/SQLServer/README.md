# SQL Server

## Modelado

SQL Server es un RDBMS propietario de Microsoft con soporte ACID, índices columnstore, in-memory OLTP (Hekaton), temporal tables y graph processing.

```sql
CREATE TABLE dbo.Users (
    Id          BIGINT IDENTITY(1,1) NOT NULL,
    Username    NVARCHAR(64) NOT NULL,
    Email       NVARCHAR(255),
    Status      VARCHAR(20) CHECK (Status IN ('active','inactive','banned')) DEFAULT 'active',
    LastLogin   DATETIME2,
    CreatedAt   DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT UQ_Users_Username UNIQUE (Username)
);

CREATE NONCLUSTERED INDEX IX_Posts_UserId_CreatedAt
    ON dbo.Posts (UserId, CreatedAt DESC) INCLUDE (Title, ViewCount);

-- Temporal tables (2016+)
ALTER TABLE dbo.Users ADD
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
    SysEndTime   DATETIME2 GENERATED ALWAYS AS ROW END   NOT NULL,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime);
ALTER TABLE dbo.Users SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.UsersHistory));
```

## Consultas

```sql
WITH ranked AS (
    SELECT u.Username, p.Title, p.ViewCount,
           ROW_NUMBER() OVER (PARTITION BY p.UserId ORDER BY p.CreatedAt DESC) AS rn
    FROM dbo.Posts p JOIN dbo.Users u ON u.Id = p.UserId WHERE u.Status = 'active'
)
SELECT Username, Title, ViewCount FROM ranked WHERE rn <= 5;

-- PIVOT
SELECT * FROM (
    SELECT YEAR(CreatedAt) AS Year, MONTH(CreatedAt) AS Month, ViewCount FROM dbo.Posts
) src PIVOT (SUM(ViewCount) FOR Month IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) pvt;

-- Full-text search
CREATE FULLTEXT INDEX ON dbo.Posts (Title, Body) KEY INDEX PK_Posts ON FTCatalog;
SELECT Id, Title FROM dbo.Posts WHERE CONTAINS((Title, Body), '"inteligencia" AND "artificial"');
```

## Índices

```sql
-- Columnstore para analytics
CREATE CLUSTERED COLUMNSTORE INDEX CCI_Posts ON dbo.Posts;

-- Índice filtrado
CREATE INDEX IX_Users_Active ON dbo.Users(Id) WHERE Status = 'active';

-- Índice incluido (covering)
CREATE INDEX IX_Posts_Covering ON dbo.Posts(UserId, CreatedAt DESC) INCLUDE (Title, Body, ViewCount);
```

## Configuración

```sql
EXEC sp_configure 'max server memory (MB)', 8192; RECONFIGURE;
EXEC sp_configure 'max degree of parallelism', 4; RECONFIGURE;

-- READ COMMITTED SNAPSHOT (evita bloqueos lectores)
ALTER DATABASE Knowledge SET READ_COMMITTED_SNAPSHOT ON;
```

## Conexión desde aplicación

```python
import aioodbc

conn_str = "DRIVER={ODBC Driver 18 for SQL Server};SERVER=localhost;DATABASE=knowledge;UID=sa;PWD=secret;TrustServerCertificate=yes"
pool = await aioodbc.create_pool(dsn=conn_str, minsize=2, maxsize=10)

async with pool.acquire() as conn:
    async with conn.cursor() as cur:
        await cur.execute("""
            INSERT INTO dbo.Posts (UserId, Title, Slug, Body) OUTPUT INSERTED.Id VALUES (?, ?, ?, ?)
        """, (42, "Título", "titulo", "Cuerpo..."))
        row = await cur.fetchone()
        await conn.commit()
```

## Monitoreo

```sql
-- Top 10 consultas por CPU
SELECT TOP 10 qs.total_worker_time/qs.execution_count AS avg_cpu_ms,
    SUBSTRING(st.text, qs.statement_start_offset/2+1, ...) AS query_text
FROM sys.dm_exec_query_stats qs CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY avg_cpu_ms DESC;

-- Bloqueos activos
SELECT * FROM sys.dm_tran_locks WHERE request_status = 'WAIT';

-- Tamaño de tablas
SELECT t.Name, p.rows, SUM(a.total_pages)*8/1024 AS TotalSpaceMB
FROM sys.tables t JOIN sys.indexes i ON t.object_id=i.object_id
JOIN sys.partitions p ON i.object_id=p.object_id AND i.index_id=p.index_id
JOIN sys.allocation_units a ON p.partition_id=a.container_id
GROUP BY t.Name, p.rows ORDER BY TotalSpaceMB DESC;
```
