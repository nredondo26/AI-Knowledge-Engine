# 097-Observability — Observabilidad

## Descripción del dominio

Directorio que cubre el ecosistema de observabilidad en sistemas modernos: monitoreo, logging, tracing distribuido y métricas. Incluye configuración y operación de Prometheus, Grafana, Datadog, New Relic, OpenTelemetry, ELK Stack, Loki, Tempo y otras herramientas. Aborda desde la instrumentación de código hasta la creación de dashboards, alertas y SLOs. El objetivo es lograr visibilidad completa del comportamiento de sistemas complejos, especialmente en arquitecturas distribuidas y microservicios.

## Conceptos clave

- **Observabilidad**: Capacidad de inferir el estado interno de un sistema a partir de sus outputs externos (métricas, logs, traces)
- **Los tres pilares**: Métricas, Logs, Trazas — las tres señales fundamentales de observabilidad
- **Métrica**: Valor numérico medido en un punto del tiempo (contador, gauge, histogram, summary)
- **Log**: Evento discreto con timestamp y mensaje textual estructurado o no estructurado
- **Trace**: Registro del recorrido completo de una solicitud a través de múltiples servicios
- **Span**: Unidad individual de trabajo dentro de un trace (ej. llamada HTTP, query DB)
- **Service mesh**: Capa de infraestructura para observabilidad (Istio, Linkerd, Consul) con sidecar proxies
- **RED method**: Rate (tasa), Errors (errores), Duration (duración) — métricas clave para servicios
- **USE method**: Utilization (utilización), Saturation (saturación), Errors (errores) — métricas clave para recursos
- **SLO** (Service Level Objective): Objetivo de nivel de servicio (ej. 99.9% disponibilidad)
- **SLI** (Service Level Indicator): Medición real del nivel de servicio (ej. latencia P99)
- **SLA** (Service Level Agreement): Acuerdo formal de nivel de servicio con consecuencias
- **Cardinality**: Número de valores únicos que puede tomar una etiqueta (alta cardinalidad = caro)
- **Sampling**: Muestreo de traces/logs para reducir volumen de datos (head-based, tail-based)
- **Instrumentación**: Código añadido a la aplicación para emitir señales de observabilidad
- **Auto-instrumentation**: Instrumentación automática sin modificar código (agents, sidecars, eBPF)
- **Telemetry pipeline**: Pipeline de procesamiento de señales (collect, buffer, transform, route)
- **Causality**: Relación causal entre eventos distribuidos (fundamento del tracing)
- **Service graph**: Mapa de dependencias entre servicios basado en traces

## Tecnologías principales

| Categoría | Herramientas y plataformas |
|---|---|
| **Métricas** | Prometheus, VictoriaMetrics, Thanos, Mimir, Graphite, InfluxDB, TimescaleDB |
| **Dashboards** | Grafana, Kibana, Chronograf, SigNoz, Datadog Dashboards |
| **Logging** | ELK Stack (Elasticsearch, Logstash, Kibana), Loki, Fluentd/Fluent Bit, Graylog, Splunk, Papertrail, Loggly |
| **Tracing distribuido** | Jaeger, Zipkin, Grafana Tempo, Datadog APM, AWS X-Ray, Azure Application Insights, GCP Cloud Trace |
| **OpenTelemetry** | Collector, SDKs (Java, Python, Go, JS, .NET, Rust, C++), OTLP protocol, exporters |
| **APM** | Datadog APM, New Relic, Dynatrace, AppDynamics, Elastic APM, SigNoz, Sentry |
| **Alerting** | Alertmanager (Prometheus), Grafana Alerting, Opsgenie, PagerDuty, Slack webhooks, OnCall |
| **eBPF** | Cilium, Pixie, Parca, Coroot, Hubble, Tetragon, Falco |
| **Service mesh** | Istio (Envoy), Linkerd, Consul Connect, Kuma, NGINX Service Mesh |
| **SLO/Error budget** | Sloth, Pyrra, Nobl9, Google Cloud SLO Monitoring |
| **Health checks** | Kubernetes probes (liveness, readiness, startup), Healthz endpoints, gRPC health protocol |
| **Tracing protocols** | W3C Trace Context, Zipkin B3, Jaeger propagation, OpenTracing (legacy), OpenCensus (legacy) |
| **Pipeline de telemetría** | OpenTelemetry Collector, Vector, Telegraf, Cribl, Logstash, Fluentd |
| **Profiling continuo** | Parca, Pyroscope, Google Cloud Profiler, Datadog Continuous Profiler |

## Hoja de ruta

### Principiante
1. **Métricas básicas** — CPU, memory, disk, network con `top`, `htop`, `nmon`, `dstat`
2. **Logging estructurado** — JSON logs, log levels (debug, info, warn, error), contexto en logs
3. **Prometheus + Grafana** — Instalar, configurar exporters, crear dashboard simple
4. **Health checks** — Endpoints `/healthz`, `/ready`, liveness/readiness probes en K8s
5. **Alertas simples** — CPU > 80%, disk space < 10%, 5xx errors > threshold
6. **ELK básico** — Elasticsearch + Logstash + Kibana para centralizar logs

### Intermedio
1. **RED method para microservicios** — Rate, Errors, Duration por endpoint
2. **OpenTelemetry SDK** — Instrumentar aplicación manualmente con spans y métricas
3. **Tracing distribuido** — Jaeger o Tempo para seguimiento de requests cross-service
4. **Dashboards avanzados** — Grafana variables, templates, alertas complejas
5. **Loki + Promtail** — Logging agregado sin Elasticsearch (más económico)
6. **Service mesh observability** — Istio Telemetry + Kiali para service graph
7. **Métricas de negocio** — Revenue per request, conversion rate, user retention

### Avanzado
1. **OpenTelemetry Collector** — Pipelines, processors (batch, filter, transform), exporters
2. **Cardinality management** — Control de alta cardinalidad en Prometheus, sharding
3. **Sampling de traces** — Head-based vs tail-based, probability sampling, rate limiting
4. **SLOs y error budgets** — Definir SLOs, calcular budgets, alertas de burn rate
5. **eBPF para observabilidad** — Pixie o Coroot para auto-instrumentación sin código
6. **Continuous profiling** — Parca/Pyroscope para profiling en producción 24/7
7. **Logs-to-metrics** — Derivar métricas de logs con Loki ruler o Promtail pipeline

### Experto
1. **Observabilidad multi-cluster** — Thanos/Mimir para métricas globales, cross-cluster tracing
2. **Causality-preserving sampling** — Estrategias para no perder contexto causal al muestrear
3. **Chaos observability** — Validar observabilidad durante caos (network partition, node failure)
4. **ML para observabilidad** — Anomaly detection, change point detection, forecasting
5. **Data lake de telemetría** — Almacenar señales en Parquet/Delta Lake para análisis histórico
6. **Cost optimization de observabilidad** — Reducir almacenamiento, sampling adaptativo, retention tiers
7. **Observability-as-Code** — GitOps para dashboards, alertas y pipelines de telemetría

## Relaciones con otros módulos

- `../095-Performance/` — Métricas de rendimiento y profiling
- `../096-Optimization/` — Optimización de recursos basada en datos de observabilidad
- `../007-Orchestration/` — Monitoreo de clústeres K8s con Prometheus Operator
- `../005-Cloud/` — CloudWatch, Azure Monitor, GCP Cloud Monitoring
- `../008-Networking/` — Monitoreo de red, métricas de tráfico, latencia
- `../013-DevOps/` — SRE prácticas, SLIs/SLOs, on-call, incident management
- `../047-Troubleshooting/` — Uso de señales de observabilidad para debugging
- `../053-Compliance/` — Audit logging, retención de logs, compliance
- `../066-Playbooks/` — Runbooks de incidentes basados en alertas
- `../054-Benchmarks/` — Benchmarks de overhead de instrumentación

## Recursos recomendados

- [OpenTelemetry Documentation](https://opentelemetry.io/docs/) — Documentación oficial
- [Prometheus Documentation](https://prometheus.io/docs/) — Monitoreo y alertas
- [Grafana Documentation](https://grafana.com/docs/) — Dashboards y visualización
- [Grafana Loki](https://grafana.com/oss/loki/) — Logging agregado
- [Grafana Tempo](https://grafana.com/oss/tempo/) — Tracing distribuido
- [Datadog Learning Center](https://learn.datadoghq.com) — Cursos gratuitos de observabilidad
- [Google SRE Books](https://sre.google/books/) — Site Reliability Engineering
- [Honeycomb: O11y Guide](https://www.honeycomb.io/observability-guide) — Guía de observabilidad
- [USE Method (Brendan Gregg)](https://www.brendangregg.com/usemethod.html) — Análisis de recursos
- [RED Method (Tom Wilkie)](https://grafana.com/blog/2018/11/30/the-red-method-how-to-instrument-your-services/) — Métricas para servicios
- [eBPF.io](https://ebpf.io) — Recursos de eBPF para observabilidad
