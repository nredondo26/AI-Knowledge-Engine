# OpenTelemetry — Instrumentación Universal

## Conceptos Fundamentales

OpenTelemetry (OTel) es el estándar CNCF para instrumentación de telemetría. Proporciona SDKs, APIs y un Collector para generar, recopilar y exportar **trazas (traces)**, **métricas (metrics)** y **logs** desde cualquier aplicación. Es el sucesor de OpenTracing y OpenCensus, unificando ambos proyectos.

### Los Tres Pilares de OTel

| Señal | Descripción | API/SDK | Ejemplo de uso |
|-------|-------------|---------|----------------|
| **Traces** | Ruta completa de una solicitud a través de servicios distribuidos | `TracerProvider`, `Tracer`, `Span` | Latencia por endpoint, dependencias |
| **Metrics** | Mediciones numéricas agregadas | `MeterProvider`, `Meter`, `Instrument` | Counters de requests, gauge de memoria |
| **Logs** | Eventos discretos con timestamp y payload estructurado | `LoggerProvider`, `Logger`, `LogRecord` | Errores con contexto de trace |

### Context Propagation

El mecanismo que permite que un trace atraviese servicios es la **propagación de contexto**. OTel soporta los protocolos:
- **W3C Trace Context** (estándar, `traceparent`/`tracestate` headers)
- **Zipkin B3** (single y multi header)
- **Jaeger** (uber-trace-id)
- **AWS X-Ray**, **Google Cloud Trace**, **New Relic**, **Datadog**

```python
# Propagación W3C Trace Context en Python
from opentelemetry import trace
from opentelemetry.propagate import inject, extract

headers = {}
inject(headers)  # Añade traceparent y tracestate
# headers: {'traceparent': '00-abc123...-def456...-01'}
ctx = extract(headers)
```

## Instrumentación

### Auto-Instrumentación (Java con OpenTelemetry Agent)

```bash
java -javaagent:opentelemetry-javaagent.jar \
     -Dotel.service.name=payment-service \
     -Dotel.traces.exporter=otlp \
     -Dotel.metrics.exporter=otlp \
     -Dotel.logs.exporter=otlp \
     -Dotel.exporter.otlp.endpoint=http://otel-collector:4318 \
     -Dotel.resource.attributes=deployment.environment=production \
     -jar app.jar
```

### Instrumentación Manual (Python)

```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.metrics import get_meter_provider, set_meter_provider
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader

# Configurar TracerProvider
provider = TracerProvider()
processor = BatchSpanProcessor(
    OTLPSpanExporter(endpoint="http://otel-collector:4317", insecure=True)
)
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

tracer = trace.get_tracer(__name__)

@tracer.start_as_current_span("process-payment")
def process_payment(user_id: str, amount: float):
    current_span = trace.get_current_span()
    current_span.set_attribute("user.id", user_id)
    current_span.set_attribute("payment.amount", amount)
    current_span.add_event("payment.started", {"user_id": user_id})

    try:
        result = charge_payment(user_id, amount)
        current_span.set_status(trace.StatusCode.OK)
        return result
    except Exception as e:
        current_span.record_exception(e)
        current_span.set_status(trace.StatusCode.ERROR, str(e))
        raise
```

### Métricas con OTel

```python
from opentelemetry.metrics import get_meter

meter = get_meter(__name__)

request_counter = meter.create_counter(
    "http.requests.total",
    description="Total de solicitudes HTTP",
    unit="1",
)

request_duration = meter.create_histogram(
    "http.request.duration",
    description="Duración de solicitudes HTTP",
    unit="ms",
)

request_counter.add(1, {"method": "POST", "path": "/api/users", "status": "200"})
request_duration.record(245.3, {"method": "POST", "path": "/api/users"})
```

## OpenTelemetry Collector

El Collector es un componente crítico que recibe telemetría de múltiples fuentes, la procesa (filtra, agrega, enriquece, muestrea) y la exporta a uno o más backends.

### Pipeline Completo

```yaml
# otel-collector-config.yml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318
  jaeger:
    protocols:
      grpc:
        endpoint: 0.0.0.0:14250
  prometheus:
    config:
      scrape_configs:
        - job_name: 'otel-collector'
          scrape_interval: 10s
          static_configs:
            - targets: ['localhost:8888']

processors:
  batch:
    timeout: 1s
    send_batch_size: 1024
  memory_limiter:
    check_interval: 1s
    limit_mib: 512
    spike_limit_mib: 128
  filter:
    metrics:
      exclude:
        match_type: regexp
        metric_names:
          - 'container_.*'
          - 'kube_.*'
  attributes:
    actions:
      - key: environment
        value: production
        action: upsert
  tail_sampling:
    decision_wait: 30s
    num_traces: 100
    policies:
      - name: error-sampling
        type: status_code
        config:
          status_code_source: status
          errors_only: true
      - name: slow-sampling
        type: latency
        config:
          threshold_ms: 500

exporters:
  otlp:
    endpoint: "jaeger:4317"
    tls:
      insecure: true
  prometheus:
    endpoint: "0.0.0.0:8889"
  logging:
    loglevel: debug
  elasticsearch:
    endpoints: ["http://elasticsearch:9200"]

service:
  pipelines:
    traces:
      receivers: [otlp, jaeger]
      processors: [memory_limiter, batch, tail_sampling]
      exporters: [otlp, logging]
    metrics:
      receivers: [otlp, prometheus]
      processors: [memory_limiter, filter, batch, attributes]
      exporters: [prometheus, logging]
    logs:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [elasticsearch, logging]
```

## Semantic Conventions

OTel define convenciones semánticas para nombres de atributos y métricas, garantizando interoperabilidad:

| Atributo | Descripción | Ejemplo |
|----------|-------------|---------|
| `http.method` | Método HTTP | `GET`, `POST` |
| `http.status_code` | Código de respuesta | `200`, `404`, `500` |
| `http.url` | URL completa de la solicitud | `https://api.example.com/users` |
| `db.system` | Sistema de base de datos | `postgresql`, `mysql`, `redis` |
| `db.statement` | Sentencia SQL | `SELECT * FROM users WHERE id = ?` |
| `messaging.system` | Sistema de mensajería | `kafka`, `rabbitmq`, `pubsub` |
| `net.peer.name` | Nombre del host remoto | `db.example.com` |

## Sampling (Muestreo)

### Head-based Sampling

```python
from opentelemetry.sdk.trace.sampling import Sampler, Decision

class CustomSampler(Sampler):
    def should_sample(self, parent_context, trace_id, name, kind, attributes, links):
        # Muestrear 100% si es error, 10% si es lento, 1% si es rápido
        if attributes and attributes.get("http.status_code", 200) >= 500:
            return Decision.RECORD_AND_SAMPLE
        if attributes and attributes.get("http.latency", 0) > 1000:
            return Decision.RECORD_AND_SAMPLE
        return Decision.RECORD_AND_SAMPLE  # 1% de muestreo base

provider = TracerProvider(sampler=CustomSampler())
```

### Tail-based Sampling

Se realiza en el Collector (ver `tail_sampling` en el pipeline más arriba). Ideal para mantener traces de errores y operaciones lentas descartando las normales.

## Best Practices

1. **Siempre usar el Collector en producción**: Nunca exportes directamente desde la aplicación. El Collector permite procesamiento, buffering, retry y routing.
2. **Propagación correcta**: Asegurar que todos los servicios propagan el contexto W3C Trace Context. Verificar con headers `traceparent` en las requests.
3. **Cardinalidad controlada**: En métricas, limitar attributes de alta cardinalidad (ej: user_id, session_id). Usar `view` en el SDK para agregar.
4. **Sampling estratégico**: Head-based (probabilidad 1-10%) + tail-based (100% errores, 10% lentos). Nunca muestrear 100% en producción.
5. **Naming consistente**: Seguir semantic conventions de OTel. Nombrar spans con verbos en pasado (`process.payment`, `db.query`).
6. **Atributos útiles**: Añadir atributos que permitan correlación: trace_id en logs, service.version, deployment.environment.
7. **No sobre-instrumentar**: Instrumentar puntos de entrada/salida (HTTP handlers, gRPC interceptors, DB clients, message consumers). Evitar spans dentro de bucles.
8. **Exemplars**: Configurar métricas con exemplars para enlazar valores de métrica con traces específicos.
9. **Recursos (Resources)**: Definir `service.name`, `service.version`, `deployment.environment` como Resource attributes, no como span attributes.
10. **Monitorear el Collector**: El propio Collector debe exponer métricas de su pipeline (gRPC, HTTP, batch sizes, errores de exportación).
