# ClickHouse

## Modelado

ClickHouse es una base OLAP columnar open-source (Yandex) optimizada para consultas analíticas sobre petabytes. Usa MergeTree como motor principal con particionamiento y ordenamiento forzados.

```sql
CREATE TABLE events (
    event_id    UUID DEFAULT generateUUIDv4(),
    timestamp   DateTime64(3) DEFAULT now64(),
    user_id     UInt32,
    event_type  LowCardinality(String),
    url         String,
    duration_ms UInt32,
    revenue     Float32,
    finger_print UInt64 DEFAULT cityHash64(url, user_id)
) ENGINE = MergeTree
PARTITION BY toYYYYMM(timestamp)
ORDER BY (user_id, toDate(timestamp), event_type)
PRIMARY KEY (user_id, toDate(timestamp))
SAMPLE BY finger_print
TTL timestamp + INTERVAL 90 DAY TO DISK 'cold'
SETTINGS index_granularity = 8192;

-- ReplacingMergeTree (dedup)
CREATE TABLE sessions (...)
ENGINE = ReplacingMergeTree(version) ORDER BY (user_id, session_id);

-- SummingMergeTree (auto-agregación)
CREATE TABLE daily_metrics (...)
ENGINE = SummingMergeTree ORDER BY (date, metric_name);
```

## Consultas

```sql
-- Top URLs por hora
SELECT url, COUNT(*) AS visits, COUNT(DISTINCT session_id) AS sessions,
       SUM(duration_ms)/COUNT(*) AS avg_duration
FROM events WHERE timestamp >= now() - INTERVAL 1 HOUR
GROUP BY url ORDER BY visits DESC LIMIT 20;

-- Serie temporal por minuto
SELECT toStartOfMinute(timestamp) AS minute,
       uniqExact(user_id) AS users, countIf(event_type='purchase') AS purchases
FROM events WHERE timestamp >= today() GROUP BY minute ORDER BY minute;

-- Embudo de conversión
SELECT countIf(event_type='page_view') AS views, countIf(event_type='signup') AS signups,
       countIf(event_type='purchase') AS purchases,
       signups/view*100 AS signup_rate, purchases/signups*100 AS conv_rate
FROM events WHERE timestamp >= now() - INTERVAL 7 DAY;

-- Ventana (22.3+)
SELECT url, timestamp, duration_ms,
       avg(duration_ms) OVER (PARTITION BY url ORDER BY timestamp ROWS 10 PRECEDING) AS moving_avg
FROM events ORDER BY url, timestamp;
```

## Configuración (config.xml)

```xml
<max_server_memory_usage_to_ram_ratio>0.75</max_server_memory_usage_to_ram_ratio>
<max_concurrent_queries>200</max_concurrent_queries>

<merge_tree>
    <max_parts_in_total>100000</max_parts_in_total>
    <parts_to_throw_insert>300</parts_to_throw_insert>
    <parts_to_delay_insert>150</parts_to_delay_insert>
    <min_bytes_for_wide_part>0</min_bytes_for_wide_part>
</merge_tree>
```

## Conexión desde aplicación

```python
import clickhouse_connect

client = clickhouse_connect.get_client(host='localhost', port=8123, username='default', password='secret')

data = [('2025-06-01 10:00:00', 1001, 'click', 'home', 0.5)]
client.insert('events', data,
    column_names=['timestamp','user_id','event_type','url','revenue'],
    column_types=['DateTime64(3)','UInt32','String','String','Float32']
)

result = client.query("""
    SELECT toDate(timestamp) AS day, COUNT(*) AS events
    FROM events WHERE timestamp >= now() - INTERVAL 7 DAY
    GROUP BY day ORDER BY day
""")
```

## Monitoreo

```sql
-- Consultas en ejecución
SELECT query_id, query, elapsed, memory_usage FROM system.processes WHERE elapsed > 5;

-- Top 10 lentas
SELECT query, query_duration_ms/1000 AS sec, read_rows, memory_usage
FROM system.query_log WHERE type='QueryFinish' AND event_date>=today()
ORDER BY query_duration_ms DESC LIMIT 10;

-- Tamaño de tablas
SELECT database, table, formatReadableSize(sum(bytes)) AS size, sum(rows) AS rows
FROM system.parts WHERE active=1 GROUP BY database, table ORDER BY sum(bytes) DESC;

-- Merges en progreso
SELECT database, table, elapsed, progress FROM system.merges;
```
