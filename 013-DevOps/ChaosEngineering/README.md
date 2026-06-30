# Chaos Engineering — Ingeniería del Caos

## Conceptos Fundamentales

Chaos Engineering es la disciplina de experimentar en sistemas distribuidos para descubrir debilidades antes de que se manifiesten como incidentes en producción. Introduce fallos controlados para validar la resiliencia del sistema.

### Principios

1. **Hipótesis sobre comportamiento estable**: Antes de experimentar, definir qué debería pasar (ej. "el sistema sigue funcionando si un pod falla").
2. **Minimizar radio de explosión**: Comenzar en staging, con impacto controlado y mecanismo de rollback inmediato.
3. **Experimentos continuos**: Integrar chaos experiments en el pipeline de CI/CD.
4. **Automatizar**: Los experimentos deben ser repetibles y ejecutarse sin intervención manual.

## Chaos Mesh

Chaos Mesh es una plataforma de chaos engineering nativa de Kubernetes.

### Instalación

```bash
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos-mesh --create-namespace
```

### Experimentos

```yaml
# pod-kill.yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: PodChaos
metadata:
  name: pod-kill-example
  namespace: production
spec:
  action: pod-kill
  mode: one
  selector:
    namespaces:
      - production
    labelSelectors:
      app: api
  duration: "30s"
  scheduler:
    cron: "@every 10m"
```

```yaml
# network-delay.yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: NetworkChaos
metadata:
  name: network-delay
spec:
  action: delay
  mode: all
  selector:
    labelSelectors:
      app: database
  delay:
    latency: "2000ms"
    jitter: "500ms"
  duration: "60s"
```

```yaml
# stress-cpu.yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: StressChaos
metadata:
  name: cpu-stress
spec:
  mode: one
  selector:
    labelSelectors:
      app: api
  stressors:
    cpu:
      workers: 2
      load: 80
  duration: "120s"
```

## LitmusChaos

```yaml
# pod-delete-experiment.yaml
apiVersion: litmuschaos.io/v1alpha1
kind: ChaosEngine
metadata:
  name: engine-nginx
spec:
  engineState: "active"
  chaosServiceAccount: litmus-admin
  experiments:
    - name: pod-delete
      spec:
        components:
          env:
            - name: TOTAL_CHAOS_DURATION
              value: "30"
            - name: CHAOS_INTERVAL
              value: "10"
            - name: TARGET_PODS
              value: "nginx-deployment"
```

## Simulación en Aplicaciones

```python
# chaos.py — Inyectar fallos programáticamente
import random
import time
import os
from typing import Callable

def with_fault_tolerance(func: Callable):
    """Decorador que simula fallos aleatorios."""
    def wrapper(*args, **kwargs):
        # Simular latencia
        if random.random() < float(os.getenv("CHAOS_LATENCY_PROB", "0")):
            delay = random.uniform(0.1, 2.0)
            time.sleep(delay)

        # Simular error
        if random.random() < float(os.getenv("CHAOS_ERROR_PROB", "0")):
            raise Exception(f"Chaos: error simulado en {func.__name__}")

        return func(*args, **kwargs)
    return wrapper
```

```python
# app.py
from chaos import with_fault_tolerance

class PaymentGateway:
    @with_fault_tolerance
    def charge(self, amount: float) -> dict:
        return {"status": "succeeded", "id": "ch_123"}
```

## Best Practices

1. **Comenzar en staging**: Nunca ejecutar chaos en producción sin validar antes en staging.
2. **Steady state hypothesis**: Definir métricas de estado normal antes del experimento.
3. **Blast radius controlado**: Limitar el impacto a un subconjunto de instancias.
4. **Automated rollback**: Mecanismo para detener el experimento y restaurar estado.
5. **Documentar hallazgos**: Cada experimento genera reporte con resultados y acciones correctivas.
6. **Frecuencia regular**: Experiments semanales en staging, mensuales en producción.
