# Prometheus — Sistema de Métricas y Alertas

## Conceptos Fundamentales

Prometheus es un sistema de monitoreo y alerta de código abierto diseñado para fiabilidad y escalabilidad. Su modelo de **recolección pull** (scrape) extrae métricas de targets en intervalos regulares, lo que elimina la necesidad de agentes que envíen datos activamente. Cada instancia de Prometheus es autónoma y no depende de almacenamiento distribuido, lo que simplifica su operación.

### Modelo de Datos

Todas las métricas en Prometheus tienen un nombre y un conjunto de **labels** (etiquetas) que las identifican de forma única. El formato interno es:

```
<metric_name>{<label_name>=<label_value>, ...} <value> <timestamp>
```

Ejemplo:
```
http_requests_total{method="POST", endpoint="/api/users", status="200"} 1024 1680000000
```

Los tipos de métricas son:
- **Counter**: Valor acumulativo que solo aumenta (requests totales, errores acumulados)
- **Gauge**: Valor que puede subir y bajar (uso de CPU, memoria, conexiones activas)
- **Histogram**: Muestra observaciones en buckets configurables y calcula percentiles
- **Summary**: Similar al histogram pero calcula percentiles en el cliente (φ-quantiles)

### Cardinalidad y Rendimiento

La cardinalidad es el número de combinaciones únicas de labels. Una métrica con 5 labels y 100 valores posibles cada una genera 10^10 series temporales. Prometheus recomienda mantener < 1000 series por target y < 10M series totales.

## Configuración

### prometheus.yml — Configuración Base

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  scrape_timeout: 10s
  external_labels:
    cluster: 'production-eu'

rule_files:
  - "alerts/*.yml"
  - "rules/*.yml"

scrape_configs:
  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
    relabel_configs:
      - source_labels: [__address__]
        regex: '(.*):10250'
        replacement: '${1}:9100'
        target_label: __address__
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: 'container_.*'
        action: keep

  - job_name: 'api-service'
    scrape_interval: 10s
    static_configs:
      - targets: ['localhost:8080', 'localhost:8081']
        labels:
          service: 'api-gateway'
    basic_auth:
      username: 'prometheus'
      password_file: '/etc/prometheus/auth/pass'
    tls_config:
      cert_file: /etc/prometheus/certs/client.crt
      key_file: /etc/prometheus/certs/client.key
```

### ServiceMonitor para Kubernetes (Prometheus Operator)

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: app-monitor
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: my-service
  endpoints:
    - port: http
      interval: 15s
      path: /metrics
      relabelings:
        - sourceLabels: [__meta_kubernetes_pod_node_name]
          targetLabel: node
  namespaceSelector:
    any: true
```

## PromQL — Prometheus Query Language

PromQL es el lenguaje de consulta funcional. Sus operaciones clave:

### Consultas Básicas

```promql
# Selector simple
http_requests_total

# Selector con filtro de labels
http_requests_total{method="GET", status=~"5[0-9]{2}"}

# Range vector (últimos 5 minutos)
http_requests_total[5m]

# Offset (datos de hace 1 hora)
http_requests_total offset 1h

# Rate (tasa por segundo sobre un counter)
rate(http_requests_total[5m])

# Increase (incremento absoluto en el período)
increase(http_requests_total[1h])
```

### Operaciones Avanzadas

```promql
# Percentiles con histogram_quantile (P99 de latencia)
histogram_quantile(0.99,
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le, endpoint)
)

# Uso de CPU por contenedor
sum(rate(container_cpu_usage_seconds_total{namespace="production"}[5m]))
  by (pod, container)

# Tasa de errores como porcentaje
sum(rate(http_requests_total{status=~"5.."}[5m]))
  /
sum(rate(http_requests_total[5m]))
* 100

# Predicción de agotamiento de disco en 24h
predict_linear(node_filesystem_free_bytes{mountpoint="/"}[1h], 86400) < 0
```

### Funciones Clave

| Función | Propósito | Ejemplo |
|---------|-----------|---------|
| `rate()` | Tasa por segundo de counter | `rate(counter[5m])` |
| `irate()` | Tasa instantánea (últimos 2 puntos) | `irate(counter[5m])` |
| `increase()` | Incremento en ventana | `increase(counter[1h])` |
| `histogram_quantile()` | Percentil desde histograma | `histogram_quantile(0.99, ...)` |
| `avg_over_time()` | Promedio en ventana | `avg_over_time(gauge[5m])` |
| `predict_linear()` | Regresión lineal predictiva | `predict_linear(series[1h], 3600)` |
| `label_replace()` | Manipular labels | `label_replace(metric, "dc", "$1", "instance", "(.*):.*")` |

## Alerting con Alertmanager

```yaml
# alerts/kubernetes.yml
groups:
  - name: kubernetes-alerts
    interval: 30s
    rules:
      - alert: KubernetesPodCrashLooping
        expr: |
          kube_pod_container_status_restarts_total > 5
        for: 5m
        labels:
          severity: critical
          team: platform
        annotations:
          summary: "Pod {{ $labels.pod }} en crash loop"
          description: "El pod {{ $labels.pod }} en namespace {{ $labels.namespace }} ha reiniciado {{ $value }} veces"

      - alert: HighMemoryUsage
        expr: |
          (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes)
          / node_memory_MemTotal_bytes > 0.9
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Uso de memoria > 90% en {{ $labels.instance }}"
```

## Best Practices

1. **Nomenclatura de métricas**: Usar snake_case, prefijo con dominio (`http_`, `db_`, `container_`) y sufijo con unidad (`_total`, `_seconds`, `_bytes`).
2. **Labels**: Mantener baja cardinalidad. No usar labels para valores que cambian constantemente (session_id, user_id, IPs).
3. **Rate vs Counter**: Siempre usar `rate()` o `increase()` en counters; nunca graficar counters crudos.
4. **Histogram buckets**: Elegir buckets que cubran el rango esperado de latencia (ej: `{0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10}`).
5. **Recording rules**: Precalcular queries pesadas ejecutándolas cada 30s-60s y almacenando el resultado:
   ```yaml
   groups:
     - name: recording_rules
       rules:
         - record: job:http_errors:rate5m
           expr: sum(rate(http_requests_total{status=~"5.."}[5m])) by (job)
   ```
6. **Retention**: Configurar `--storage.tsdb.retention.time=15d` por defecto. Para periodos largos, usar Thanos o Cortex.
7. **Relabeling**: Usar `relabel_configs` para enriquecer y limpiar labels antes del almacenamiento. `metric_relabel_configs` modifica labels de la métrica.
8. **Service Discovery**: Preferir service discovery (kubernetes, consul, ec2) sobre static_configs.
9. **Alerting**: Usar `for` para evitar falsos positivos por picos transitorios. Definir severity (warning/critical) y team.
10. **Sharding**: Para alta cardinalidad, particionar targets por job o shard con `hashmod`.
