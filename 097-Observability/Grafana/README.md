# Grafana — Observabilidad y Dashboards

## Conceptos Fundamentales

Grafana es una plataforma de observabilidad y visualización de código abierto que permite consultar, alertar y explorar métricas, logs y trazas sin importar dónde estén almacenados. Su arquitectura de **plugins de datasource** permite conectar cualquier backend (Prometheus, Loki, Tempo, Elasticsearch, CloudWatch, etc.) con una interfaz unificada.

### Arquitectura

Grafana se compone de:
- **Frontend**: UI React con paneles redimensionables, variables de template y exploración ad-hoc
- **Backend**: Servidor Go que maneja autenticación, autorización, proxy de datasources, alertas y provisionamiento
- **Datasources**: Conexiones configuradas a fuentes de datos (cada una con su propio query editor)
- **Panels**: Componentes visuales (time series, bar chart, stat, gauge, table, heatmap, logs, trace view)
- **Dashboards**: Colecciones de paneles organizados en filas, con variables de template y anotaciones
- **Alerting**: Sistema unificado de alertas que evalúa queries de cualquier datasource

### Modos de Despliegue

```yaml
# docker-compose.yml — Stack Grafana + Prometheus + Loki + Tempo
version: '3.8'
services:
  grafana:
    image: grafana/grafana:10.4.0
    ports:
      - "3000:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GF_PASSWORD}
      GF_INSTALL_PLUGINS: grafana-piechart-panel,grafana-worldmap-panel
      GF_AUTH_LDAP_ENABLED: "true"
    volumes:
      - grafana-data:/var/lib/grafana
      - ./provisioning:/etc/grafana/provisioning
    restart: unless-stopped
```

## Configuración y Provisionamiento

Grafana soporta provisionamiento declarativo para datasources, dashboards y alertas, permitiendo gestión como código (GitOps).

### Datasources Provisionados

```yaml
# provisioning/datasources/datasources.yml
apiVersion: 1
datasources:
  - name: Prometheus-Prod
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    jsonData:
      timeInterval: 15s
      queryTimeout: 60s
      httpMethod: POST
      exemplarTraceIdDestinations:
        - name: traceID
          datasourceUid: tempo

  - name: Loki-Logs
    type: loki
    access: proxy
    url: http://loki:3100
    jsonData:
      maxLines: 5000
      derivedFields:
        - name: traceID
          type: string
          url: "$${__value.raw}"
          datasourceUid: tempo

  - name: Tempo-Traces
    type: tempo
    access: proxy
    url: http://tempo:3200
    jsonData:
      tracesToLogs:
        datasourceUid: loki
        tags: ['instance', 'pod']
        mappedTags: [{key: 'service.name', value: 'service'}]
```

### Dashboards Provisionados

```yaml
# provisioning/dashboards/dashboards.yml
apiVersion: 1
providers:
  - name: 'default'
    orgId: 1
    folder: 'Producción'
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    options:
      path: /var/lib/grafana/dashboards
```

## PromQL en Grafana

### Variables de Template

Las variables permiten dashboards dinámicos e interactivos:

```sql
-- Query de variable para seleccionar namespace
label_values(kube_namespace_labels, namespace)

-- Query de variable para servicio (dependiente de namespace)
label_values(kube_pod_info{namespace="$namespace"}, service)

-- Variable de intervalo (auto)
-- Valores: 30s,1m,5m,15m,30m,1h,3h,6h,12h,24h
```

### Panel Time Series — Latencia P99 por Servicio

```promql
# Query A: P50
histogram_quantile(0.50,
  sum(rate(http_request_duration_seconds_bucket{service=~"$service"}[$__rate_interval]))
    by (le, service)
)

# Query B: P99   (en el mismo panel)
histogram_quantile(0.99,
  sum(rate(http_request_duration_seconds_bucket{service=~"$service"}[$__rate_interval]))
    by (le, service)
)

# Query C: Error rate %
sum(rate(http_requests_total{service=~"$service", status=~"5.."}[$__rate_interval]))
  / sum(rate(http_requests_total{service=~"$service"}[$__rate_interval]))
* 100
```

## Loki (LogQL)

```logql
# Contar errores por servicio en los últimos 15 min
sum by (service) (
  count_over_time({namespace="production"} |= "ERROR" [$__interval])
)

# Encontrar traceID asociado a un error
{namespace="production", service="api-gateway"}
  |= "Exception"
  | pattern "<ip> - - <method> <path> <status> <size> <duration>"
  | status =~ "5[0-9][0-9]"
  | line_format "{{.traceID}}"
```

## Tempo (TraceQL)

```traceql
# Trazas lentas (latencia > 2s)
{ duration > 2s && status = error }

# Servicio con errores
{ .service.name = "payment-svc" && .http.status_code >= 500 }
  | select(.http.method, .http.target, .http.status_code)

# Root spans de peticiones lentas
{ kind = server && duration > 1s }
  | select(.service.name, .http.method, .http.target)
```

## Sistema de Alertas Unificado

```yaml
# provisioning/alerting/alert_rules.yml
apiVersion: 1
groups:
  - name: production-alerts
    interval: 30s
    rules:
      - uid: high_error_rate
        title: "High Error Rate"
        condition: A
        data:
          - refId: A
            relativeTimeRange:
              from: 600
              to: 0
            datasourceUid: prometheus
            model:
              expr: |
                sum(rate(http_requests_total{status=~"5.."}[5m])) /
                sum(rate(http_requests_total[5m])) * 100 > 5
        noDataState: NoData
        execErrState: Alerting
        for: 5m
        annotations:
          summary: "Error rate > 5% en {{ $labels.service }}"
        labels:
          severity: critical
```

## Best Practices

1. **Dashboards como código**: Almacenar dashboards en JSON versionado, provisionados desde repositorio Git.
2. **Variables**: Usar variables de template para filtrar (entorno, servicio, namespace, host). Evitar dashboards hardcodeados.
3. **Panel density**: Máximo 12-16 paneles por dashboard. Usar filas para agrupar por dominio.
4. **Paleta de colores**: Usar colores semánticos: verde (ok), amarillo (warning), rojo (critical), azul (info).
5. **Time range**: Configurar `$__rate_interval` (contra Prometheus) para rate queries óptimas.
6. **Exemplars**: Configurar exemplars en datasource Prometheus para saltar de métrica a trace.
7. **Annotations**: Usar anotaciones para despliegues, cambios de configuración y escalado.
8. **Permissions**: Usar RBAC con teams para aislar dashboards por equipo. Evitar Admin para todos.
9. **Caching**: Para cargas pesadas, configurar caching de datasource con `GF_CACHING_ENABLED=true`.
10. **Explore vs Dashboards**: Usar Explore para debugging ad-hoc; dashboards para monitoreo permanente.
