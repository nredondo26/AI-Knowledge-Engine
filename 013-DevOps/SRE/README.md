# SRE — Site Reliability Engineering

## Conceptos Fundamentales

SRE aplica principios de software engineering a operaciones de infraestructura. Acuñado por Google, busca sistemas escalables y confiables mediante automatización, medición y cultura blameless.

### Principios

- **Confianza medida**: Todo se cuantifica con SLIs, SLOs y error budgets.
- **Automatización de toil**: Trabajo repetitivo se elimina con código.
- **Sistemas antivulnerables**: Diseñados para fallar gracefulmente (chaos engineering).
- **Blameless culture**: Incidentes para mejorar el sistema, no castigar personas.

## SLIs, SLOs y Error Budget

### SLI (Service Level Indicator)

| SLI | Fórmula | Ejemplo |
|-----|---------|---------|
| Latencia (p99) | Percentil 99 | < 200 ms |
| Disponibilidad | `éxitos / total` | 99.9% |
| Error rate | `HTTP 5xx / total` | < 0.1% |

### SLO y Error Budget

```yaml
slo:
  name: "API Availability"
  sli: "proportion_good / proportion_valid"
  threshold: 99.9
  window: "28d"
```

Error budget = 100% - SLO. Con SLO 99.9%, presupuesto = ~43 min/mes.

```yaml
error_budget_policy:
  consumption:
    - level: < 50%
      action: "Deployments normales"
    - level: 50-80%
      action: "Congelar deploys, solo bugfixes"
    - level: > 80%
      action: "Incidente activo"
```

## 4 Golden Signals

1. **Latencia**: Tiempo en servir (éxitos vs fallos lentos).
2. **Tráfico**: Demanda (requests/segundo, conexiones activas).
3. **Errores**: Ratio de requests fallidos (5xx, respuestas incorrectas).
4. **Saturación**: CPU, memoria, conexiones DB, colas.

```yaml
# prometheus-alerts.yaml
groups:
  - name: sre-alerts
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m]))
          /
          sum(rate(http_requests_total[5m])) > 0.001
        for: 5m
        labels: { severity: page }
      - alert: LatencyHighP99
        expr: histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) > 0.2
        for: 10m
        labels: { severity: warning }
```

## Incident Response

| Rol | Responsabilidad |
|-----|----------------|
| **IC** | Coordina, asigna tareas |
| **Comms Lead** | Comunica a stakeholders |
| **Ops Lead** | Debugging y mitigación |
| **Scribe** | Documenta timeline |

### Timeline

```
t+00:00 — Alerta (HighErrorRate)
t+00:02 — IC asignado, canal de incidente
t+00:05 — Diagnóstico: DB connection pool agotado
t+00:08 — Mitigación: escalar conexiones DB
t+00:12 — Servicio recuperado
t+24:00 — Postmortem (#blameless)
```

### Runbook

```markdown
## DB Connection Pool Exhaustion
**Síntomas**: Error rate elevado, timeouts PostgreSQL.

**Diagnóstico**:
1. `SHOW max_connections;`
2. `SELECT * FROM pg_stat_activity WHERE state = 'active';`

**Mitigación**:
1. `ALTER SYSTEM SET max_connections = 200;`
2. Terminar conexiones idle: `pg_terminate_backend(pid)`
```

## Postmortem Template

```markdown
# Postmortem: Incidente #42
**Fecha**: 2025-06-15 | **Duración**: 12 min | **Impacto**: 0.03%

## Causa Raíz
Timeout incorrecto en PgBouncer `idle_in_transaction`.

## Acciones Correctivas
- [ ] Ajustar `server_idle_timeout` de 300s a 60s
- [ ] Alerta de `idle_in_transaction > 50`
- [ ] Simular caída de pool en Game Day
```

## Toil Automation

```python
from prometheus_api_client import PrometheusConnect

prom = PrometheusConnect(url="http://prometheus:9090")

def check_pool():
    result = prom.custom_query('avg(pg_stat_activity_count{datname="myapp"})')
    current = float(result[0]["value"][1])
    threshold = 100 * 0.8
    if current > threshold:
        print(f"Escalado: {current} > {threshold}")
        return True
    return False
```

## SRE Maturity Model

| Nivel | Características |
|-------|----------------|
| 1 — Ad-hoc | Sin SLOs, alertas mal configuradas |
| 2 — Reactivo | SLOs básicos, algunos runbooks |
| 3 — Proactivo | Error budget, automatización > 50% |
| 4 — Predictivo | Anomaly detection, auto-remediation |
| 5 — Autónomo | Sistemas auto-curativos |

## KPIs

| Métrica | Objetivo |
|---------|----------|
| MTTR | < 30 min |
| MTTD | < 5 min |
| Toil % | < 30% |
| Error budget restante | > 50% |
