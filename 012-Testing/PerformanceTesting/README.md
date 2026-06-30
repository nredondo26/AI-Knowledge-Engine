# Performance Testing — Pruebas de Rendimiento

## Conceptos Fundamentales

Las pruebas de rendimiento evalúan la velocidad, capacidad de respuesta, estabilidad y escalabilidad de un sistema bajo carga. Son críticas para garantizar SLA, identificar cuellos de botella y planificar capacidad.

### Tipos de Pruebas de Rendimiento

| Tipo | Objetivo | Métrica Clave |
|------|----------|---------------|
| **Carga (Load)** | Comportamiento bajo carga esperada | Latencia p95, throughput |
| **Estrés (Stress)** | Punto de quiebre del sistema | TPS máximo, errores |
| **Resistencia (Soak)** | Degradación con carga sostenida | Memory leak, GC |
| **Pico (Spike)** | Comportamiento ante picos repentinos | Tiempo de recuperación |
| **Escalabilidad** | Relación recursos/rendimiento | Costo por transacción |

## Pipelines de Rendimiento

### k6 — Moderno y basado en JavaScript

```javascript
// load-test.js
import http from "k6/http";
import { sleep, check } from "k6";

export const options = {
  stages: [
    { duration: "2m", target: 100 },  // Ramp-up
    { duration: "5m", target: 100 },  // Sostenido
    { duration: "1m", target: 0 },    // Ramp-down
  ],
  thresholds: {
    http_req_duration: ["p(95)<500"],  // 95% < 500ms
    http_req_failed: ["rate<0.01"],    // < 1% errores
  },
};

export default function () {
  const payload = JSON.stringify({ email: "user@test.com", password: "test123" });
  const headers = { "Content-Type": "application/json" };

  const res = http.post("https://api.example.com/auth/login", payload, { headers });
  check(res, {
    "status is 200": (r) => r.status === 200,
    "response time < 300ms": (r) => r.timings.duration < 300,
  });
  sleep(1);
}
```

### Locust — Python con UI web

```python
# locustfile.py
from locust import HttpUser, task, between

class WebsiteUser(HttpUser):
    wait_time = between(1, 3)

    @task(3)
    def view_products(self):
        self.client.get("/api/products")

    @task(1)
    def create_order(self):
        self.client.post("/api/orders", json={
            "product_id": 101,
            "quantity": 2,
        })
```

### wrk — Benchmarking rápido (CLI)

```bash
wrk -t12 -c400 -d30s --latency https://api.example.com/health
```

## Análisis de Resultados

```yaml
# k6-report.json (resumen)
metrics:
  http_req_duration:
    avg: 245.3
    min: 89.1
    med: 210.5
    p90: 380.2
    p95: 490.8
    max: 1250.4
  http_reqs:
    rate: 523.4  # requests/segundo
  http_req_failed:
    rate: 0.003  # 0.3%
```

### Cuellos de Bottela Comunes

| Síntoma | Causa Probable | Solución |
|---------|---------------|----------|
| Latencia aumenta con usuarios | DB sin índices | Añadir índices, caché |
| Throughput plano | CPU al 100% | Escalar horizontal |
| Errores después de X minutos | Memory leak | Heap dump, profiler |
| Timeouts intermitentes | Connection pool pequeño | Aumentar pool_size |

## CI/CD con Performance Tests

```yaml
# .github/workflows/perf.yaml
name: Performance Tests
on:
  schedule:
    - cron: "0 6 * * *"
  workflow_dispatch:

jobs:
  k6:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run k6
        uses: grafana/k6-action@v0.3.1
        with:
          filename: tests/performance/load-test.js
          flags: --out json=report.json
      - name: Check thresholds
        run: |
          jq '.metrics.http_req_duration.p95' report.json | \
          awk '{if($1 > 500) exit 1}'
```

## Best Practices

1. **Entorno aislado**: No ejecutar tests de rendimiento en producción o compartiendo recursos con otros tests.
2. **Baseline**: Tener una métrica base para comparar regresiones.
3. **Data realista**: Usar datos de prueba con volumen y distribución similares a producción.
4. **Múltiples ejecuciones**: El rendimiento varía; ejecutar al menos 3 veces y promediar.
5. **Monitorear el servidor**: CPU, memoria, I/O, red, GC durante el test.
6. **Think time realista**: Incluir tiempos de espera entre acciones como haría un usuario real.
7. **Objetivos claros**: Definir SLOs de rendimiento antes de testear. `p95 < 500ms` no es un objetivo si el SLA es `p99 < 1s`.
8. **Automatizar en CI**: Ejecutar tests de carga ligeros en cada PR y tests completos en schedule nocturno.
