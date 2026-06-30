# Datadog — Observabilidad como SaaS

## Conceptos Fundamentales

Datadog es una plataforma SaaS de monitoreo y seguridad para aplicaciones cloud-native. Proporciona métricas, trazas (APM), logs, experiencia real de usuario (RUM), synthetics, network monitoring, seguridad (Cloud SIEM) y profiling continuo, todo integrado en una única interfaz con correlación automática entre señales.

### Arquitectura del Agent

Datadog opera mediante un **Agent** instalado en cada host o pod que recolecta y envía telemetría:

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Application  │────▶│  Datadog     │────▶│  Datadog     │
│  + DogStatsD  │     │  Agent       │     │  SaaS        │
│  + APM lib    │     │  (host/pod)  │     │  Backend     │
└──────────────┘     └──────────────┘     └──────────────┘
                          │     ▲
                          ▼     │
                     ┌──────────┴──┐
                     │  Integrations │
                     │  (K8s, AWS,   │
                     │   Postgres…)  │
                     └─────────────┘
```

Componentes del Agent:
- **DogStatsD**: Receptor de métricas custom via UDP
- **APM Agent**: Recibe trazas y las enruta al backend
- **Log Agent**: Recolecta archivos de log, Docker stdout, journald
- **Process Agent**: Descubre procesos en ejecución
- **System Probe**: Monitoreo de red y seguridad (eBPF)
- **Integrations**: Checks programados (PostgreSQL, Redis, Nginx, AWS, GCP)

## Configuración

### datadog.yml — Configuración Base

```yaml
# /etc/datadog-agent/datadog.yml
api_key: ${DD_API_KEY}
site: datadoghq.com
hostname: web-prod-01
tags:
  - env:production
  - team:platform
  - region:eu-west-1

logs_enabled: true
logs_config:
  container_collect_all: true
  processing_rules:
    - type: mask_sequences
      name: mask_emails
      replace_placeholder: "[EMAIL_REDACTED]"
      pattern: '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'

apm_config:
  enabled: true
  max_traces_per_second: 100
  env: production
  log_injection: true
  profiler:
    enabled: true

process_config:
  enabled: true
  scrub_args: true

network_config:
  enabled: true

security_agent:
  enabled: true
  runtime_security:
    enabled: true
```

### Helm Chart para Kubernetes

```yaml
# values.yaml — Datadog Agent en Kubernetes
datadog:
  apiKeyExistingSecret: datadog-secret
  appKeyExistingSecret: datadog-app-secret
  site: datadoghq.com
  tags:
    - env:production
  logs:
    enabled: true
    containerCollectAll: true
  apm:
    portEnabled: true
    port: 8126
    env:
      - name: DD_APM_ENABLED
        value: "true"
  processAgent:
    enabled: true
  systemProbe:
    enabled: true
    enableTCPQueueLength: true
    enableOOMKill: true
  securityAgent:
    runtime:
      enabled: true
    compliance:
      enabled: true

clusterAgent:
  enabled: true
  metricsProvider:
    enabled: true
    useDatadogMetrics: true
  replicas: 2

agents:
  replicas: 3
  tolerations:
    - operator: Exists
```

## Instrumentación APM

### Python con ddtrace

```bash
pip install ddtrace
DD_SERVICE=payment-svc DD_ENV=production ddtrace-run python app.py
```

### Instrumentación Manual

```python
from ddtrace import tracer, patch
from ddtrace.contrib.flask import FlaskMiddleware
from ddtrace.contrib.requests import TracedSession
from ddtrace.contrib.sqlalchemy import trace_engine

patch(requests=True, sqlalchemy=True, redis=True, celery=True)

tracer.configure(
    hostname="localhost",
    port=8126,
    settings={
        "FILTERS": [
            # Filtrar health checks
            lambda span: span.name != "flask.request" or span.resource != "/health"
        ]
    }
)

@app.route("/api/checkout")
@tracer.wrap("checkout.process", resource="checkout")
def checkout():
    span = tracer.current_span()
    span.set_tag("cart.id", cart_id)
    span.set_tag("payment.amount", total)

    with tracer.trace("payment.charge", service="payment-svc") as payment_span:
        payment_span.set_tag("payment.method", method)
        result = payment_service.charge(cart_id, total)

    if result.get("fraud_flag"):
        span.set_tag("fraud.flagged", "true")
        span.set_metric("fraud.score", result["fraud_score"])

    return {"status": "ok"}
```

### DogStatsD — Métricas Custom

```python
from datadog import DogStatsd

statsd = DogStatsd(host="localhost", port=8125, namespace="app")

# Counter
statsd.increment("checkout.total", tags=["env:production", "region:eu"])
statsd.decrement("queue.size")

# Gauge
statsd.gauge("memory.used", 1024, tags=["host:web-01"])

# Histogram (calculo de percentiles en backend)
statsd.histogram("http.request.duration", 245.3, tags=["endpoint:/api/users"])

# Distribution (cálculo de percentiles globales)
statsd.distribution("payment.latency", 150.2, tags=["service:payment"])

# Set (conteo de valores únicos)
statsd.set("active.users", "user_abc123")

# Event
statsd.event("Deploy", "v2.1.3 desplegado en producción",
             alert_type="success", tags=["env:production"])
```

## Consultas y Monitoreo

### Métricas Clave

```
# Latencia P99 por servicio
avg:payment.p99.duration{service:payment-svc,env:production} by {service}

# Tasa de errores
sum:http.requests.errors{env:production}.as_rate() /
sum:http.requests{env:production}.as_rate() * 100

# Uso de CPU por pod
avg:kubernetes.cpu.usage.total{env:production} by {pod_name}

# Conexiones activas a base de datos
avg:postgresql.connections{env:production} by {host}
```

### Logs (Log Query)

```
service:payment-svc env:production status:error
  -@http.status_code:>=500
  | head(100)
  | sort(-@timestamp)

service:auth-svc -@http.url:"/health"
  | parse "method=* path=* status=*" as method, path, status
  | where status > 400
  | group_by([service, path], function=count())
```

### Monitors (Alertas)

```json
{
  "name": "High Payment Error Rate",
  "type": "query alert",
  "query": "avg(last_5m):sum:payment.errors{env:production}.as_rate() / sum:payment.requests{env:production}.as_rate() * 100 > 5",
  "message": "Error rate en payments ha superado 5% (actual: {{value}}%). @slack-alerts",
  "tags": ["service:payment", "severity:critical"],
  "options": {
    "thresholds": {"critical": 5, "warning": 3},
    "notify_no_data": false,
    "evaluation_delay": 60,
    "new_host_delay": 300
  }
}
```

## Best Practices

1. **Tags estructurados**: Usar tags consistentes: `env`, `service`, `team`, `region`, `version`. Los tags son la base de la correlación.
2. **APM + Logs + RUM**: Activar `log_injection` en APM para correlacionar trazas con logs. Unir RUM (frontend) con APM (backend) via `traceId`.
3. **Cardinalidad en custom metrics**: Usar `distribution` en lugar de `histogram` cuando se necesiten percentiles globales. Limitar tags a cardinalidad < 1000.
4. **Filtrado de trazas**: Filtrar health checks, favicon, y endpoints de monitoreo interno para reducir consumo de APM.
5. **Sampling inteligente**: Configurar `max_traces_per_second` a 50-100 por servicio. Usar sampling por cabecera (head-based) con reglas:
   ```yaml
   # en datadog.yml
   apm_config:
     sampling_rate: 0.1  # 10% base
     error_traces_sampling_rate: 1.0  # 100% errores
   ```
6. **Dashboards dinámicos**: Usar template variables con `$service`, `$env`, `$region` para dashboards reutilizables.
7. **SLOs**: Definir SLOs sobre métricas de APM o logs con ventanas deslizantes de 28 días. Usar error budgets para alertas.
8. **Cloud SIEM**: Activar detección de amenazas en logs con reglas out-of-box. Crear reglas custom para patrones específicos de seguridad.
9. **Contenedores**: Usar el Datadog Operator en Kubernetes para gestionar el Agent como DaemonSet con auto-configuración.
10. **Costos**: Monitorear dashboard de Usage. Reducir cardinalidad de custom metrics y usar sampling en APM para controlar costos.
