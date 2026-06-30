# GitHub Actions Self-Hosted Runners

## Descripción General

Los **self-hosted runners** de GitHub Actions son servidores gestionados por el usuario que ejecutan workflows. Ideales para entornos on-premise, hardware especializado (GPU), o cuando se necesita acceso a redes privadas. Se registran a nivel de repositorio, organización o empresa.

---

## Arquitectura

- **Runner app**: Aplicación que se conecta vía HTTPS a GitHub Actions.
- **Listener**: Proceso que escucha trabajos asignados.
- **Worker**: Proceso que ejecuta cada job en su propio directorio.
- **Group**: Conjunto de runners etiquetados para enrutamiento.

---

## Instalación y Registro

```bash
# Descargar y configurar
mkdir actions-runner && cd actions-runner
curl -O -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz
tar xzf actions-runner-linux-x64-2.319.1.tar.gz

# Registrar (token desde Settings > Actions > Runners)
./config.sh --url https://github.com/org/repo \
  --token AAAAAAAA \
  --labels gpu,linux,x64 \
  --name runner-prod-1 \
  --work _work

# Instalar como servicio
sudo ./svc.sh install
sudo ./svc.sh start

# Ver estado
sudo ./svc.sh status
```

---

## Configuración Avanzada

```bash
# Registro a nivel de organización
./config.sh --url https://github.com/org \
  --token AAAAAAAA \
  --labels on-prem,docker \
  --runnergroup "Default"

# Sin root (recomendado)
./config.sh --disableupdate --ephemeral
```

---

## .env Personalizado

```bash
# .env
ACTIONS_RUNNER_HOOK_JOB_COMPLETED=/opt/runner-hooks/cleanup.sh
ACTIONS_ALLOW_UNSUPPORTED_RUNNER=true
```

---

## Uso en Workflows

```yaml
jobs:
  build-on-prem:
    runs-on: [self-hosted, linux, x64]
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t myapp .

  train-model:
    runs-on: [self-hosted, gpu, nvidia]
    steps:
      - run: nvidia-smi
      - run: python train.py

  deploy-internal:
    runs-on: [self-hosted, on-prem, vpn]
    environment: production
    steps:
      - run: ./deploy-internal.sh
```

---

## Runners Efímeros (Ephemeral)

```bash
./config.sh --url https://github.com/org/repo --token AAAAAA --ephemeral
```

Cada runner se registra, ejecuta un solo job y se da de baja automáticamente. Ideal para auto-scaling con contenedores.

---

## Auto-Scaling con Docker

```bash
# Usar actions/actions-runner-controller (Kubernetes)
```

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: runner-gpu
spec:
  replicas: 3
  template:
    spec:
      repository: org/repo
      labels:
        - gpu
      env:
        - name: RUNNER_GROUP
          value: Default
      tolerations:
        - key: "nvidia.com/gpu"
          operator: "Exists"
```

---

## Labels para Enrutamiento

```yaml
runs-on: [self-hosted, linux, x64, gpu, docker]
```

| Label | Propósito |
|-------|-----------|
| `self-hosted` | Obligatorio para runners propios |
| `linux`, `windows`, `macos` | SO |
| `x64`, `arm64` | Arquitectura |
| `gpu` | Hardware especializado |
| `docker` | Docker-in-Docker habilitado |

---

## Limpieza de Discos (Hook)

```bash
#!/bin/bash
# /opt/runner-hooks/cleanup.sh
echo "Limpiando espacio en disco..."
docker system prune -af --volumes
rm -rf /tmp/*
```

---

## Seguridad

- **Aislamiento**: Cada job se ejecuta en un workspace limpio (`_work`).
- **Token de registro**: Expira tras 1 hora; generar nuevo tras instalación.
- **Firewall**: Runner necesita outbound HTTPS a `api.github.com`.
- **No exponer runners**: Evitar que PRs de forks accedan a runners privados.
- **Entornos protegidos**: Combinar `environment` con `required reviewers`.

```yaml
jobs:
  deploy:
    runs-on: [self-hosted, prod]
    environment:
      name: production
      url: https://app.example.com
    concurrency: production-deploy
```

---

## Monitoreo

```bash
# Logs del runner
journalctl -u actions.runner.service -f

# Health check
curl -s http://localhost:8080/healthz
```

---

## Mejores Prácticas

1. **Etiquetas descriptivas**: `self-hosted, linux, gpu, prod`.
2. **Runners efímeros**: Evitar estado residual entre jobs.
3. **Hooks**: Limpiar disco, Docker y caché tras cada job.
4. **Auto-scaling**: ARC (Actions Runner Controller) en Kubernetes para elasticidad.
5. **Aislamiento**: Contenedores Docker por job.
6. **Versionado**: Mantener runner app actualizada.

---

## Referencias

- [GitHub Self-Hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [actions-runner-controller](https://github.com/actions/actions-runner-controller)
- [Runner Releases](https://github.com/actions/runner/releases)
