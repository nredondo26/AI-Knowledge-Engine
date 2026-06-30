# InfluxDB

## Modelado

InfluxDB es una base de datos time-series (TSDB) optimizada para ingestas masivas de métricas, sensores IoT y monitoreo. Usa measurements, tags (indexados, baja cardinalidad), fields (valores) y time.

```
Measurement: metrics
├── Tags: host="server-01", region="us-east", service="api"
├── Fields: cpu_usage=45.2, memory_used=8192, requests=1200
└── Time: 1717200000000000000 (nanosegundos)

# Line Protocol
metrics,host=server-01,region=us-east cpu=45.2,mem=8192 1717200000000000000
```

## Consultas

### Flux (InfluxDB 2.x)

```js
from(bucket: "knowledge")
  |> range(start: -1h)
  |> filter(fn: (r) => r._measurement == "metrics" and r._field == "cpu_usage")
  |> group(columns: ["host"])
  |> mean()

// Promedio móvil cada 5 min
from(bucket: "knowledge")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "metrics" and r._field == "cpu_usage")
  |> aggregateWindow(every: 5m, fn: mean)

// Downsampling con tarea
option task = {name: "downsample_cpu", every: 1h}
from(bucket: "knowledge")
  |> range(start: -1h) |> aggregateWindow(every: 1m, fn: mean)
  |> to(bucket: "knowledge_downsampled")
```

### InfluxQL (InfluxDB 1.x)

```sql
SELECT MEAN(cpu_usage) FROM metrics WHERE time > now() - 1h GROUP BY host;
SELECT DERIVATIVE(MEAN(cpu_usage), 1m) FROM metrics WHERE time > now() - 6h GROUP BY host;
SELECT PERCENTILE(cpu_usage, 95) FROM metrics WHERE time > now() - 24h GROUP BY host;
```

## Retención

```sql
-- 1.x: Retention Policies
CREATE RETENTION POLICY "one_day" ON "knowledge" DURATION 1d REPLICATION 1 DEFAULT;
CREATE RETENTION POLICY "one_year" ON "knowledge" DURATION 365d REPLICATION 1;

-- 2.x: Buckets con retención (CLI)
influx bucket create --name knowledge_short --retention 24h
influx bucket create --name knowledge_long --retention 365d
```

## Configuración

```yaml
engine:
  path: /var/lib/influxdb2/engine
storage:
  cache-max-memory-size: "1g"
  compact-throughput: "48m"
  compact-throughput-burst: "96m"
http-bind-address: ":8086"
query-concurrency: 10
write-concurrency: 40
```

## Conexión desde aplicación

```python
from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS

client = InfluxDBClient(url="http://localhost:8086", token="token", org="my-org")
write_api = client.write_api(write_options=SYNCHRONOUS)

point = Point("metrics").tag("host","srv1").field("cpu_usage",45.2).time(int(time.time_ns()))
write_api.write(bucket="knowledge", record=point)

query_api = client.query_api()
tables = query_api.query('from(bucket:"knowledge") |> range(start:-1h) |> filter(fn:(r)=>r._field=="cpu_usage") |> mean()')
```

## Monitoreo

```bash
influx ping
influx bucket list
curl http://localhost:8086/metrics
du -sh /var/lib/influxdb2/engine/data/*
```
