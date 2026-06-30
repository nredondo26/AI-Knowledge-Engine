# Monitoring — Monitoreo de Sistemas

## Conceptos Fundamentales

El monitoreo es la práctica de observar, medir y alertar sobre el estado y rendimiento de sistemas en producción. Proporciona visibilidad en tiempo real para detectar anomalías, diagnosticar problemas y planificar capacidad.

### Pilares del Monitoreo

| Pilar | Enfoque | Herramientas |
|-------|---------|--------------|
| **Métricas** | Datos numéricos en series temporales | Prometheus, Datadog, Grafana |
| **Logs** | Eventos textuales estructurados | Loki, ELK Stack, CloudWatch |
| **Trazas (Traces)** | Seguimiento de requests distribuidos | Jaeger, Tempo, Zipkin |
| **Alertas** | Notificaciones basadas en umbrales | Alertmanager, PagerDuty |
| **Uptime** | Disponibilidad externa | Pingdom, StatusCake |

## Prometheus + Grafana

### Configuración de Prometheus

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "alerts/*.yml"

scrape_configs:
  - job_name: "api"
    metrics_path: "/metrics"
    static_configs:
      - targets: ["localhost:8000"]

  - job_name: "node"
    static_configs:
      - targets: ["localhost:9100"]
```

### Métricas Personalizadas

```python
# app/metrics.py
from prometheus_client import Counter, Histogram, Gauge, generate_latest
from fastapi import FastAPI
from starlette.middleware.base import BaseHTTPMiddleware

app = FastAPI()

REQUESTS = Counter("http_requests_total", "Total requests", ["method", "endpoint", "status"])
LATENCY = Histogram("http_request_duration_seconds", "Request latency", ["method", "endpoint"])
IN_FLIGHT = Gauge("http_requests_in_flight", "Current requests in flight")

@app.middleware("http")
async def metrics_middleware(request, call_next):
    IN_FLIGHT.inc()
    with LATENCY.labels(request.method, request.url.path).time():
        response = await call_next(request)
    IN_FLIGHT.dec()
    REQUESTS.labels(request.method, request.url.path, response.status_code).inc()
    return response
```

### Alertas

```yaml
# alerts/api.yml
groups:
  - name: api-alerts
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.01
        for: 5m
        labels: { severity: critical }
        annotations:
          summary: "Error rate > 1% en los últimos 5 minutos"

      - alert: HighLatency
        expr: histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 10m
        labels: { severity: warning }
```

## ELK Stack / Loki

```yaml
# docker-compose.monitoring.yml
version: "3.8"
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana

  loki:
    image: grafana/loki
    ports:
      - "3100:3100"

  jaeger:
    image: jaegertracing/all-in-one
    ports:
      - "16686:16686"

volumes:
  grafana-data:
```

## Best Practices

1. **USE method**: Utilization, Saturation, Errors.
2. **RED method**: Rate, Errors, Duration.
3. **Four Golden Signals**: Latencia, Tráfico, Errores, Saturación.
4. **Alarmas accionables**: Cada alerta debe requerir acción humana.
