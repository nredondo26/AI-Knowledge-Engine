# Loki — Logging Cloud-Native

## Conceptos Fundamentales

Grafana Loki es un sistema de agregación de logs diseñado para ser económico y escalable. A diferencia de Elasticsearch, Loki **no indexa el contenido del log**, solo etiqueta los streams con labels (similar a Prometheus). Esto reduce drásticamente el costo de almacenamiento y la complejidad operativa.

### Arquitectura Loki

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Promtail    │────▶│  Loki        │────▶│  Grafana     │
│  (agent)     │     │  (storage)   │     │  (consulta)  │
├──────────────┤     │              │     │              │
│  Fluent Bit  │────▶│  /loki/api/  │     │  + LogQL     │
├──────────────┤     │  v1/push     │     │              │
│  Docker      │     │              │     │  Explore     │
│  plugin      │────▶│              │     │              │
└──────────────┘     └──────────────┘     └──────────────┘
```

### Componentes

- **Loki**: Almacenamiento de logs, expone API de push (ingesta) y query (consulta)
- **Promtail**: Agente oficial que descubre targets, etiqueta streams y envía logs
- **Grafana**: UI para consultas LogQL, dashboards y alertas
- **LogQL**: Lenguaje de consulta inspirado en PromQL + funciones de log
- **Boltdb-shipper**: Index store nativo, sin dependencia externa
- **Object storage**: Backend de chunks (S3, GCS, Azure Blob, MinIO, filesystem)

## Configuración

### Loki Stack con Docker Compose

```yaml
version: '3.8'
services:
  loki:
    image: grafana/loki:3.0.0
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/loki-config.yml
    volumes:
      - ./loki-config.yml:/etc/loki/loki-config.yml
      - loki-data:/loki
    restart: unless-stopped

  promtail:
    image: grafana/promtail:3.0.0
    volumes:
      - /var/log:/var/log
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - ./promtail-config.yml:/etc/promtail/config.yml
    command: -config.file=/etc/promtail/config.yml
    depends_on:
      - loki

  grafana:
    image: grafana/grafana:10.4.0
    ports:
      - "3000:3000"
    environment:
      GF_INSTALL_PLUGINS: grafana-piechart-panel
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana-datasources.yml:/etc/grafana/provisioning/datasources/datasources.yml
```

### Loki Config (alta disponibilidad)

```yaml
# loki-config.yml
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9095

common:
  path_prefix: /loki
  storage:
    filesystem:
      chunks_directory: /loki/chunks
      rules_directory: /loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2024-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v12
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /loki/index
    cache_location: /loki/cache
    cache_ttl: 24h
    shared_store: filesystem

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h
  ingestion_rate_mb: 10
  ingestion_burst_size_mb: 20
  per_stream_rate_limit: 3MB
  per_stream_rate_limit_burst: 15MB
  max_line_size: 256KB
  max_entries_limit_per_query: 5000
  max_query_series: 500
  max_query_bytes_read: 1GB

querier:
  max_concurrent: 10

ingester:
  lifecycler:
    ring:
      kvstore:
        store: inmemory
    num_tokens: 512
  chunk_idle_period: 30m
  chunk_retain_period: 1m
  max_chunk_age: 1h
  chunk_target_size: 1536000  # 1.5MB

compactor:
  working_directory: /loki/compactor
  shared_store: filesystem
  retention_enabled: true
  retention_delete_delay: 2h
  retention_delete_worker_count: 150
```

### Promtail Config — Descubrimiento y Etiquetado

```yaml
# promtail-config.yml
scrape_configs:
  - job_name: system-logs
    static_configs:
      - targets: [localhost]
        labels:
          job: varlogs
          __path__: /var/log/*.log

  - job_name: docker-logs
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 15s
    relabel_configs:
      - source_labels: [__meta_docker_container_name]
        regex: '/(.*)'
        target_label: container
      - source_labels: [__meta_docker_container_log_stream]
        target_label: stream
      - source_labels: [__meta_docker_container_label_com_docker_compose_service]
        target_label: service

  - job_name: kubernetes-pods
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - action: replace
        source_labels: [__meta_kubernetes_pod_label_app]
        target_label: app
      - action: replace
        source_labels: [__meta_kubernetes_pod_label_component]
        target_label: component
      - action: replace
        source_labels: [__meta_kubernetes_pod_node_name]
        target_label: node
      - action: replace
        source_labels: [__meta_kubernetes_namespace]
        target_label: namespace
      - action: replace
        replacement: /var/log/pods/*$1*/*.log
        source_labels: [__meta_kubernetes_pod_uid]
        target_label: __path__
      - action: replace
        source_labels: [__meta_kubernetes_pod_container_name]
        target_label: container
    pipeline_stages:
      - cri: {}
      - regex:
          expression: '^(?P<level>ERROR|WARN|INFO|DEBUG) (?P<message>.+)$'
      - metrics:
          log_entries_total:
            type: Counter
            description: "Total de entradas de log"
            prefix: my_promtail_custom_
            max_idle_duration: 24h
            config:
              match_all: true
              action: inc
```

## LogQL — Lenguaje de Consulta

LogQL combina selectores de streams (como PromQL) con filtros y operaciones sobre el contenido de logs.

### Selectores de Streams

```logql
# Selector simple
{job="varlogs", env="production"}

# Selector con operadores
{namespace=~"prod|staging", app!="healthcheck"}

# Rango de tiempo con rate (contar líneas por segundo)
rate({namespace="production"}[5m])
```

### Filtros de Línea

```logql
# Igualdad
{job="varlogs"} |= "ERROR"

# Expresión regular
{service="api"} |~ "(5[0-9][0-9]|Exception|Timeout)"

# Negación
{service="api"} != "healthcheck"

# Regex negado
{service="api"} !~ "DEBUG|TRACE"
```

### Expresiones de Pattern y JSON

```logql
# Parseo de logs JSON
{service="payment-svc"}
  |= "charge"
  | json
  | amount > 1000
  | line_format "{{.method}} {{.status}} {{.duration}}ms"

# Pattern parsing (más rápido que regex)
{service="nginx"}
  | pattern "<ip> - - <method> <path> <status> <size> <duration>"
  | status >= 500
  | duration > 2

# Logfmt
{service="app"} | logfmt | level = "error" | duration > 3s
```

### Métricas desde Logs

```logql
# Tasa de errores por servicio
sum by (service, namespace) (
  rate({env="production"} |= "ERROR" [5m])
)

# Percentiles de latencia desde logs
quantile_over_time(0.99,
  {service="api"}
    | json
    | unwrap duration [5m]
) by (service)

# Conteo de errores por código HTTP
sum by (status) (
  count_over_time({service="nginx"} | pattern "<status>" [1h])
)

# Top 5 endpoints con más errores
topk(5, sum by (path) (
  rate({service="api", status=~"5.."} [5m])
))
```

### Pipeline de Transformación

```logql
{service="orders-svc"}
  | json
  | level = "error"
  | line_format "{{.timestamp}} [{{.level}}] {{.service}}: {{.message}}"
  | label_format level=upper(level), service=template("{{.service}}-{{.version}}")
  | drop __error__, __error_details__
  | keep timestamp, level, service, message, trace_id
```

## Correlación Traces ↔ Logs

Loki puede derivar traceIDs de logs y saltar directamente a Tempo:

```yaml
# Datasource Loki en Grafana
jsonData:
  derivedFields:
    - name: traceID
      type: string
      url: "$${__value.raw}"
      datasourceUid: tempo
      matcherRegex: "traceID=(\\w+)"
```

```logql
# Buscar logs con traceID y saltar a Tempo
{service="payment-svc"} |= "ERROR" | json
# Click en traceID → abre trace en Tempo
```

## Best Practices

1. **Labels de alta calidad**: Usar labels de baja cardinalidad: `job`, `namespace`, `service`, `container`, `level`. **Nunca** usar `trace_id`, `user_id`, `session_id` como labels (alta cardinalidad quiebra Loki).
2. **Líneas grandes**: Configurar `max_line_size: 256KB` en Loki. Si una línea excede el límite, se rechaza en ingesta.
3. **Chunk size objetivo**: `chunk_target_size: 1.5MB` es el sweet spot. Chunks muy pequeños incrementan I/O; muy grandes aumentan latencia de consulta.
4. **Retention**: Configurar `retention_enabled: true` en el compactor. Loki no elimina datos por tiempo por defecto; requiere compactor con retention.
5. **Promtail pipeline stages**: Usar `json`, `logfmt`, `pattern`, `regex` para extraer campos estructurados. Usar `metrics` stage para contadores desde logs.
6. **Boltdb-shipper**: Para despliegues multi-instancia, usar `boltdb-shipper` con object store (S3/GCS). Evitar `consul` o `etcd` para el ring.
7. **Caching**: Configurar cache en el querier para resultados repetidos: `cache_results: true` + Redis/Memcached.
8. **Rate limits**: Ajustar `ingestion_rate_mb` y `per_stream_rate_limit` según capacidad del clúster. Monitorizar `loki_ingester_rate_limiter_log_rate_level`.
9. **LogQL optimizado**: Preferir `|=`, `!=` sobre `|~`, `!~` (los filtros exactos son más rápidos). Usar `pattern` en lugar de `regex` para parsing.
10. **Alertas**: Usar `grafana/loki_rule` o Ruler component para alertas basadas en LogQL. Combinar con métricas de Prometheus para correlación.
