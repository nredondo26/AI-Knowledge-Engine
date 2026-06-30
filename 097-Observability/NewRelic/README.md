# New Relic — Plataforma de Observabilidad

## Descripción del dominio

New Relic es una plataforma de observabilidad completa (SaaS) que proporciona monitoreo de aplicaciones (APM), infraestructura, logs, métricas, tracing distribuido, dashboards y alertas. Fundada en 2008, New Relic es uno de los líderes del mercado junto con Datadog. Su plataforma unificada (New Relic One) integra datos de telemetría (métricas, eventos, logs, traces) en un solo lugar con un lenguaje de consulta propio (NRQL). Ofrece agentes para múltiples lenguajes (Java, .NET, Python, Node.js, Ruby, Go, PHP) y soporta OpenTelemetry como estándar abierto.

## Áreas clave

- **APM (Application Performance Monitoring)**: Monitoreo de rendimiento de aplicaciones con agentes que instrumentan el código automáticamente. Métricas: throughput, error rate, Apdex (satisfacción del usuario), response time (percentiles p50, p90, p99), transaction traces
- **Distributed Tracing**: Trazas distribuidas (distributed traces) que siguen una solicitud a través de múltiples servicios. Muestreo head-based y tail-based. Span attributes, service maps, waterfall view
- **New Relic Infrastructure**: Monitoreo de servidores, contenedores, Kubernetes, cloud (AWS, Azure, GCP). Métricas de CPU, memoria, disco, red. Eventos de cambio de estado, integración con config management
- **Logs**: Ingesta, parsing, almacenamiento y consulta de logs. Integración con Fluentd, Logstash, syslog, CloudWatch Logs. Pattern matching, enrichment, live tail. Correlación automática con traces
- **NRQL (New Relic Query Language)**: Lenguaje SQL-like para consultar datos de telemetría. SELECT, FROM, WHERE, FACET, TIMESERIES, SINCE, UNTIL. Creación de dashboards y alertas basadas en NRQL
- **Alertas**: Políticas de alerta con condiciones NRQL o metric-based. Notificaciones: email, Slack, PagerDuty, Opsgenie, Webhooks. Incidents management, escalation policies
- **Synthetics**: Monitoreo proactivo simulado. Browser monitors (Selenium scripts), API checks (HTTP requests), scripted browsers (JavaScript). Checks desde múltiples locations globales
- **Browser Monitoring**: Monitoreo de用户体验 del lado del cliente. Page load timing, AJAX calls, JavaScript errors, session traces, Core Web Vitals (LCP, FID, CLS)
- **Integración OpenTelemetry**: New Relic acepta datos OTLP (OpenTelemetry Protocol). Soporte nativo para OTel SDKs con mapping automático a entidades New Relic

## Ejemplo: Configuración agente Python

```bash
pip install newrelic
newrelic-admin generate-config YOUR_LICENSE_KEY newrelic.ini
```

```ini
# newrelic.ini
[newrelic]
license_key = YOUR_LICENSE_KEY
app_name = My Python App
monitor_mode = true
log_level = info
transaction_tracer.enabled = true
transaction_tracer.transaction_threshold = apdex_f
error_collector.enabled = true
```

```python
# En el entry point de la aplicación
import newrelic.agent
newrelic.agent.initialize('newrelic.ini')

@app.route('/api/users')
@newrelic.agent.function_trace()
def get_users():
    return get_users_from_db()
```

## Ejemplo: Consulta NRQL

```sql
-- Respuesta promedio de la aplicación en últimos 30 minutos
SELECT average(duration) FROM Transaction
WHERE appName = 'MiApp' SINCE 30 minutes ago

-- Error rate por endpoint (última hora)
SELECT count(*) / uniqueCount(session) * 100 AS error_rate
FROM TransactionError FACET request.uri
SINCE 1 hour ago

-- Top 5 servicios más lentos en trazas distribuidas
SELECT average(duration) FROM Span
FACET service.name LIMIT 5
SINCE 1 hour ago TIMESERIES

-- Uso de CPU por host
SELECT average(cpuPercent) FROM SystemSample
FACET hostname SINCE 10 minutes ago TIMESERIES
```

## Tecnologías principales

| Componente | Descripción |
|------------|-------------|
| New Relic One | Plataforma UI unificada |
| APM Agents | Java, .NET, Python, Node, Ruby, Go, PHP, Elixir |
| Infrastructure Agent | Linux, Windows, Kubernetes, Docker, cloud |
| Browser Agent | JavaScript injection para monitoreo frontend |
| Mobile Agents | iOS (Swift), Android (Kotlin/Java) |
| OpenTelemetry | Soporte nativo OTLP |
| Logs | Fluentd, Logstash, vector, CloudWatch, syslog |
| Kubernetes | New Relic Kubernetes Operator, Pixie integration |
| NRQL | Lenguaje de consulta propio |
| NerdGraph | GraphQL API para configurar y consultar |

## Buenas prácticas

- Instrumentar con el agente APM desde el inicio del proyecto (no post-facto)
- Configurar sampling en distributed tracing para controlar costos (head-based con 5-10%)
- Crear dashboards por dominio: rendimiento, errores, infraestructura, negocio
- Usar NRQL para alertas inteligentes: basadas en tendencias, no solo thresholds fijos
- Correlacionar logs con traces usando el correlation ID automático
- Implementar Synthetics para monitoreo de APIs críticas y flujos de usuario clave
- Configurar Apdex con objetivos realistas (0.5s para web, 2s para API)
- Usar la integración OpenTelemetry para stacks heterogéneos sin agente New Relic
- Etiquetar entidades con tags (environment, service, team, tier) para organización
- Revisar dashboards prediseñados de New Relic (AWS, Kubernetes, lenguajes)
- Limitar cardinalidad de atributos en spans (evitar UUIDs, timestamps precisos como atributos)
