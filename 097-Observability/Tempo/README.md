# Grafana Tempo — Trazado Distribuido Escalable

## Conceptos Fundamentales

Grafana Tempo es un backend de tracing distribuido de código abierto, diseñado para ser **económico, escalable y simple**. A diferencia de Jaeger o Zipkin, Tempo **no indexa trazas por contenido**, solo por ID de trace y tiempo. Esto reduce drásticamente el costo operativo y permite escalar a billones de spans.

### Arquitectura Tempo

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  OTel SDK    │────▶│  Tempo       │────▶│  Grafana     │
│  + OTLP      │     │  (backend)   │     │  (TraceQL)   │
├──────────────┤     │  /tempo/api  │     │              │
│  Jaeger      │────▶│  /trace/{id} │     │  Explore     │
│  Thrift      │     │  /search     │     │              │
├──────────────┤     │              │     │  Service     │
│  Zipkin      │────▶│  + metrics   │     │  Graph       │
│  JSON/v1     │     │  generator   │     │              │
├──────────────┤     │              │     │  + Prometheus │
│  OpenCensus  │────▶│  + compactor │     │  exemplars   │
└──────────────┘     └──────────────┘     └──────────────┘
```

### Componentes

- **Distributor**: Recibe spans y los distribuye a los ingesters usando hashing consistente (ring)
- **Ingester**: Almacena spans recientes en memoria y los persiste a object storage
- **Querier**: Consulta trazas por ID desde ingesters y backend storage
- **Query-frontend**: Cache, cola y splitting de queries TraceQL grandes
- **Compactor**: Fusiona bloques pequeños en bloques más grandes para reducir I/O
- **Metrics-generator**: Deriva métricas RED (Rate, Errors, Duration) desde spans hacia Prometheus
- **Sparkpl**: Service graph basado en traces

## Configuración

### Tempo Stack con Docker Compose

```yaml
version: '3.8'
services:
  tempo:
    image: grafana/tempo:2.4.0
    command: -config.file=/etc/tempo/config.yml
    ports:
      - "3200:3200"   # HTTP (tempo API)
      - "4317:4317"   # OTLP gRPC
      - "4318:4318"   # OTLP HTTP
      - "9411:9411"   # Zipkin
      - "6832:6832"   # Jaeger thrift
    volumes:
      - ./tempo-config.yml:/etc/tempo/config.yml
      - tempo-data:/tmp/tempo

  grafana:
    image: grafana/grafana:10.4.0
    ports:
      - "3000:3000"
    environment:
      - GF_AUTH_ANONYMOUS_ENABLED=true
    volumes:
      - ./datasources.yml:/etc/grafana/provisioning/datasources/datasources.yml

  prometheus:
    image: prom/prometheus:v2.51.0
    ports:
      - "9090:9090"
    command:
      - --config.file=/etc/prometheus/prometheus.yml
      - --web.enable-remote-write-receiver
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
```

### Tempo Config — Despliegue Monolítico a Escalable

```yaml
# tempo-config.yml
server:
  http_listen_port: 3200
  grpc_listen_port: 9095

distributor:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317
        http:
          endpoint: 0.0.0.0:4318
    jaeger:
      protocols:
        thrift_compact:
          endpoint: 0.0.0.0:6831
        thrift_binary:
          endpoint: 0.0.0.0:6832
        thrift_http:
          endpoint: 0.0.0.0:14268
        grpc:
          endpoint: 0.0.0.0:14250
    zipkin:
      endpoint: 0.0.0.0:9411
    opencensus:
      endpoint: 0.0.0.0:55678

ingester:
  trace_idle_period: 10s
  max_block_duration: 30m
  max_block_bytes: 500_000_000  # 500MB
  lifecycler:
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1

storage:
  trace:
    backend: s3
    s3:
      bucket: tempo-traces
      endpoint: minio:9000
      access_key: tempo
      secret_key: ${TEMPO_SECRET}
      insecure: true
    pool:
      max_workers: 100
      queue_depth: 2000
    block:
      bloom_filter_false_positive: 0.05
      encoding: zstd
      index_downsample_bytes: 500
      version: vParquet3
    wal:
      path: /tmp/tempo/wal
    local:
      path: /tmp/tempo/blocks

compactor:
  compaction:
    block_retention: 48h
    compacted_block_retention: 1h
    compaction_window: 1h
    max_compaction_range: 24h
    chunk_size_bytes: 10_000_000

querier:
  max_concurrent_queries: 20
  search:
    max_duration: 6h
    max_spans_per_span_set: 100

metrics_generator:
  registry:
    collection_interval: 15s
    external_labels:
      cluster: production
  processor:
    service_graphs:
      dimensions: ["http.method", "http.target"]
    span_metrics:
      histogram_buckets: [0.002, 0.005, 0.010, 0.025, 0.050, 0.100, 0.250, 0.500, 1, 2.5, 5, 10]
    local_blocks:
      max_block_duration: 10m
      max_block_bytes: 100_000_000

overrides:
  defaults:
    ingestion:
      rate_strategy: local
      max_traces_per_user: 10000
    global:
      max_bytes_per_trace: 5_000_000
    forwarders: []
```

### Datasource Grafana para Tempo + Prometheus + Loki

```yaml
# provisioning/datasources/datasources.yml
apiVersion: 1
datasources:
  - name: Tempo
    type: tempo
    uid: tempo
    url: http://tempo:3200
    jsonData:
      tracesToLogs:
        datasourceUid: loki
        tags: ['service.name', 'instance', 'pod']
        mappedTags: [{key: 'service.name', value: 'service'}]
        spanStartTimeShift: '-5m'
        spanEndTimeShift: '5m'

  - name: Prometheus
    type: prometheus
    uid: prometheus
    url: http://prometheus:9090
    isDefault: true
    jsonData:
      exemplarTraceIdDestinations:
        - name: traceID
          datasourceUid: tempo

  - name: Loki
    type: loki
    uid: loki
    url: http://loki:3100
    jsonData:
      derivedFields:
        - name: traceID
          type: string
          url: "$${__value.raw}"
          datasourceUid: tempo
```

## TraceQL — Lenguaje de Consulta de Trazas

TraceQL permite buscar trazas por propiedades estructurales de los spans (duración, atributos, estado, jerarquía) sin necesidad de indexar contenido.

### Consultas Básicas

```traceql
# Trazas con duración > 500ms
{ duration > 500ms }

# Trazas con error
{ status = error }

# Trazas de un servicio específico
{ .service.name = "payment-svc" }

# Span con método HTTP GET
{ .http.method = "GET" }

# Combinación de condiciones
{ .service.name = "api-gateway" && duration > 1s }
```

### Navegación Jerárquica

```traceql
# Span raíz (kind = server)
{ kind = server && duration > 2s }

# Span hijo de otro span
{ .service.name = "payment-svc" }
  { .db.system = "postgresql" && duration > 100ms }

# Span en cualquier nivel de la jerarquía
{ .service.name = "frontend" } >> { status = error }

# Hermano de un span específico
{ .service.name = "api-gateway" }
  ~ { .http.method = "POST" }
```

### Agregaciones y Proyecciones

```traceql
# Seleccionar atributos específicos
{ duration > 1s }
  | select(.service.name, .http.method, .http.target, .http.status_code)

# Conteo de spans por servicio
{ }
  | count() by(.service.name)

# Agrupación y filtro
{ duration > 500ms && status = error }
  | group_by(.service.name)
```

### Ejemplos Avanzados

```traceql
# P99 de duración por servicio (retorna series temporales)
{ kind = server }
  | rate() by(.service.name)

# Trazas lentas de un endpoint específico
{ .http.target = "/api/checkout" && duration > 3s }
  | select(.http.method, .http.status_code, .http.target)

# Service graph: dependencias entre servicios
{ }
  | compare(.service.name, .service.name)
  | rate() by(.service.name, .service.name)
```

## Service Graph y RED Metrics

Tempo puede derivar métricas RED desde trazas usando el **metrics-generator**:

```promql
# Tasa de requests por servicio
rate(traces_service_graph_request_total{job="tempo"}[5m])

# Tasa de errores por par de servicios
rate(traces_service_graph_request_failed_total{job="tempo"}[5m])

# Latencia P99 por servicio
histogram_quantile(0.99,
  sum(rate(traces_span_metrics_latency_bucket[5m])) by (le, service)
)
```

## Best Practices

1. **Object storage**: Usar S3/GCS/Azure Blob como backend principal. Evitar filesystem local en producción (no escala, no es resiliente).
2. **vParquet columnar**: Tempo 2.x usa formato Parquet columnar que permite queries eficientes sobre atributos sin índice previo.
3. **Metrics-generator**: Activar siempre. Deriva métricas RED desde trazas sin instrumentación adicional. Permite service graph y dashboards.
4. **Sampling siempre**: Nunca enviar 100% de trazas. Usar tail-based sampling (10% base + 100% errores). Configurar en OTel Collector.
5. **Retention de bloques**: `block_retention: 48h` en compactor mantiene datos calientes. Datos más viejos se mantienen en object storage.
6. **Ingester sizing**: `max_block_bytes: 500MB` y `max_block_duration: 30m` son valores recomendados. No exceder 1GB por bloque en ingester.
7. **Exemplars**: Configurar Prometheus + exemplars para saltar de métrica a trace. Requiere `--web.enable-remote-write-receiver` en Prometheus.
8. **Correlación Logs↔Traces**: Configurar derivedFields en Loki datasource. Usar `traceID` como campo estructurado en logs.
9. **Querier cache**: Usar Redis/Memcached para cache de resultados de TraceQL. Reduce latencia de queries repetitivas.
10. **Monitorear Tempo**: Exportar métricas internas (tempo_build_info, tempo_ingester_live_traces, tempo_querier_queries_total) a Prometheus.
