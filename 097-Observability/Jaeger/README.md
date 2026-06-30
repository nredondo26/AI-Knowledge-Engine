# Jaeger — Trazado Distribuido de Uber

## Conceptos Fundamentales

Jaeger es un sistema de tracing distribuido de código abierto, creado por Uber y donado a CNCF. Permite monitorear transacciones complejas entre servicios, identificar cuellos de botella, depurar errores y analizar dependencias. Jaeger implementa el modelo de **tracing basado en sampling** con propagación de contexto.

### Arquitectura Jaeger

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Application │────▶│  Jaeger      │────▶│  Storage     │
│  + Jaeger    │     │  Agent       │     │  (Cassandra, │
│  Client      │────▶│  (sidecar)   │     │   ES, Badger)│
│              │     │              │     │              │
│  OTel SDK    │────▶│  Jaeger      │◀────│  Jaeger UI   │
│  (OTLP)      │     │  Collector   │     │  (query)     │
│              │     │              │     │              │
│  Zipkin      │────▶│  + Ingester  │     │  + gRPC      │
│  format      │     │              │     │  + API       │
└──────────────┘     └──────────────┘     └──────────────┘
```

### Componentes

- **Jaeger Agent (jaeger-agent)**: Daemon sidecar que recibe spans via UDP (Thrift) y los envía al Collector. Obsoleto en favor del OTel Collector.
- **Jaeger Collector (jaeger-collector)**: Recibe spans, los valida, transforma y almacena. Soporta gRPC, Thrift, Zipkin, OTLP.
- **Jaeger Query (jaeger-query)**: Servicio de consulta con API HTTP/gRPC y UI web.
- **Jaeger Ingester**: Componente opcional que lee spans desde Kafka y los escribe al storage.
- **Storage Backends**: Cassandra (recomendado), Elasticsearch, Badger (local), Kafka como buffer.

## Configuración

### Jaeger All-in-One (Desarrollo)

```yaml
version: '3.8'
services:
  jaeger:
    image: jaegertracing/all-in-one:1.57
    ports:
      - "16686:16686"  # UI
      - "4317:4317"    # OTLP gRPC
      - "4318:4318"    # OTLP HTTP
      - "14250:14250"  # Jaeger gRPC
      - "14269:14269"  # Admin
      - "6831:6831/udp"   # Jaeger thrift compact
      - "6832:6832/udp"   # Jaeger thrift binary
      - "5778:5778"    # Agent configs
      - "16685:16685"  # gRPC query
    environment:
      - COLLECTOR_OTLP_ENABLED=true
      - COLLECTOR_ZIPKIN_HOST_PORT=:9411
      - METRICS_STORAGE_TYPE=prometheus
      - PROMETHEUS_SERVER_URL=http://prometheus:9090
```

### Jaeger Production con Elasticsearch

```yaml
version: '3.8'
services:
  jaeger-collector:
    image: jaegertracing/jaeger-collector:1.57
    ports:
      - "14250:14250"  # gRPC
      - "14269:14269"  # Admin
      - "4317:4317"    # OTLP
      - "4318:4318"    # OTLP HTTP
    command:
      - --collector.zipkin.host-port=:9411
      - --span-storage.type=elasticsearch
      - --es.server-urls=http://elasticsearch:9200
      - --es.username=jaeger
      - --es.password=${JAEGER_ES_PASSWORD}
      - --es.tls=false
      - --es.num-shards=5
      - --es.num-replicas=1
      - --es.use-ilm=true
      - --es-ilm-policy-name=jaeger-ilm-policy
      - --collector.queue-size=2000
      - --collector.num-workers=50
    environment:
      - SPAN_STORAGE_TYPE=elasticsearch
    depends_on:
      elasticsearch:
        condition: service_healthy

  jaeger-query:
    image: jaegertracing/jaeger-query:1.57
    ports:
      - "16686:16686"
      - "16685:16685"
      - "16687:16687"
    command:
      - --span-storage.type=elasticsearch
      - --es.server-urls=http://elasticsearch:9200
      - --es.username=jaeger
      - --es.password=${JAEGER_ES_PASSWORD}
      - --query.max-clock-skew-adjustment=5s
    environment:
      - SPAN_STORAGE_TYPE=elasticsearch

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.12.0
    environment:
      - discovery.type=single-node
      - ES_JAVA_OPTS=-Xms4g -Xmx4g
      - xpack.security.enabled=true
      - xpack.security.enrollment.enabled=true
      - ELASTIC_PASSWORD=${ES_PASSWORD}
    volumes:
      - es-data:/usr/share/elasticsearch/data
```

### Jaeger con Kafka como Buffer

```yaml
jaeger-collector:
  image: jaegertracing/jaeger-collector:1.57
  command:
    - --span-storage.type=kafka
    - --kafka.producer.brokers=kafka:9092
    - --kafka.producer.topic=jaeger-spans

jaeger-ingester:
  image: jaegertracing/jaeger-ingester:1.57
  command:
    - --span-storage.type=elasticsearch
    - --kafka.consumer.brokers=kafka:9092
    - --kafka.consumer.topic=jaeger-spans
    - --es.server-urls=http://elasticsearch:9200
```

## Instrumentación

### Python con jaeger-client

```python
from jaeger_client import Config
from opentracing_instrumentations import get_tracer
import time

config = Config(
    config={
        'sampler': {
            'type': 'probabilistic',
            'param': 0.1,  # 10% de trazas
        },
        'logging': True,
        'local_agent': {
            'reporting_host': 'localhost',
            'reporting_port': 6831,
        },
        'tags': {
            'service.version': '1.2.3',
            'deployment.environment': 'production',
        },
    },
    service_name='payment-service',
)

tracer = config.initialize_tracer()

def process_payment(user_id, amount):
    with tracer.start_active_span('process-payment') as scope:
        span = scope.span
        span.set_tag('user.id', user_id)
        span.set_tag('payment.amount', amount)
        span.set_baggage_item('user.tier', 'premium')

        with tracer.start_active_span('validate-card') as validate_scope:
            validate_scope.span.set_tag('card.type', 'visa')
            time.sleep(0.05)

        with tracer.start_active_span('charge') as charge_scope:
            try:
                result = payment_gateway.charge(user_id, amount)
                charge_scope.span.set_tag('charge.id', result['id'])
                charge_scope.span.set_tag('error', False)
            except Exception as e:
                charge_scope.span.set_tag('error', True)
                charge_scope.span.log_kv({
                    'event': 'error',
                    'error.object': e,
                    'stack': traceback.format_exc(),
                })
                raise

    tracer.close()
```

### OpenTelemetry → Jaeger (vía OTLP)

```python
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

exporter = OTLPSpanExporter(
    endpoint="http://jaeger-collector:4317",
    insecure=True,
)
provider = TracerProvider()
provider.add_span_processor(BatchSpanProcessor(exporter))
trace.set_tracer_provider(provider)
```

## UI y Consultas

### Jaeger Query API

```bash
# Buscar trazas por servicio y tags
curl "http://jaeger:16686/api/traces?service=payment-svc&tags=%7B%22error%22%3A%22true%22%7D&limit=20"

# Obtener detalle de un trace por ID
curl "http://jaeger:16686/api/traces/abc123def456"

# Obtener servicios
curl "http://jaeger:16686/api/services"

# Obtener operaciones de un servicio
curl "http://jaeger:16686/api/services/payment-svc/operations"

# Dependencias (service graph)
curl "http://jaeger:16686/api/dependencies?endTs=1700000000&lookback=3600"
```

### gRPC Query

```bash
grpcurl -plaintext -d '{"service": "payment-svc", "tags": "error=true", "limit": 10}' \
  jaeger:16685 jaeger.api_v2.QueryService/FindTraces
```

## Sampling Strategies

Jaeger soporta configuración remota de sampling vía API, permitiendo cambios sin reinicio:

```json
// GET http://jaeger-agent:5778/sampling?service=payment-svc
{
  "strategyType": "PROBABILISTIC",
  "probabilisticSampling": {
    "samplingRate": 0.1
  }
}
```

```yaml
# Estrategias de sampling por servicio (configuración dinámica)
sampling:
  default_strategy:
    type: probabilistic
    param: 0.01  # 1% por defecto
  service_strategies:
    - service: payment-svc
      type: rate_limiting
      param: 100  # 100 traces/segundo
      operation_strategies:
        - operation: POST /charge
          type: probabilistic
          param: 1.0  # 100% para /charge
    - service: healthcheck
      type: probabilistic
      param: 0  # No muestrear healthchecks
```

## Best Practices

1. **Sampling estratégico**: 1-10% en producción para servicios normales. 100% para servicios de alta criticidad (pagos, auth). Usar rate-limiting para controlar picos.
2. **Tags útiles**: Incluir `http.method`, `http.url`, `http.status_code`, `db.type`, `db.instance`, `error.message`, `error.stacktrace`. Evitar tags de alta cardinalidad.
3. **Baggage**: Usar baggage items (context propagation) para datos que cruzan servicios (user.tier, request.id). No abusar (afecta performance).
4. **Storage**: Cassandra para alta escala. Elasticsearch para búsqueda avanzada. Badger solo para desarrollo. Preferir Kafka como buffer entre Collector e Ingester.
5. **Service graph**: Usar la pestaña Dependencies en UI para visualizar dependencias. Identificar servicios con alta latencia o errores en cascada.
6. **Comparar trazas**: Usar la vista de comparación para encontrar diferencias entre trazas exitosas y fallidas.
7. **Architecture differences**: Jaeger indexa tags y operation names para búsqueda. Esto permite `FindTraces` por tag (a diferencia de Tempo). Mayor costo de almacenamiento, pero búsqueda más flexible.
8. **TLS**: Configurar TLS entre Agent, Collector y Query. Jaeger soporta mTLS para comunicación interna.
9. **Retention**: Usar ILM en Elasticsearch o TTL en Cassandra. 7 días para producción. Reducir a 2-3 días si el volumen es alto.
10. **Migración a OTel**: Jaeger está en transición a OpenTelemetry. El Collector de Jaeger soporta OTLP nativamente. Planificar migración de clientes Jaeger a OTel SDK.
