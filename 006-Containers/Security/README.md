# Seguridad en Contenedores

## Descripción

La seguridad en contenedores abarca imágenes base seguras, hardening en construcción, ejecución con mínimos privilegios, aislamiento en runtime y monitorización. Linux proporciona namespaces, cgroups, capabilities, seccomp y AppArmor/SELinux para restringir procesos.

## Principios

- **Least privilege**: Mínimas capabilities, usuario no root, read-only rootfs
- **Defense in depth**: namespaces + capabilities + seccomp + AppArmor
- **Imágenes mínimas**: Alpine, Distroless, Scratch
- **Firmado**: Cosign/Notation
- **Escaneo**: Trivy, Snyk, Grype

## Hardening en Dockerfile

```dockerfile
FROM alpine:3.19
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN find / -perm /6000 -type f -exec chmod a-s {} \;
COPY --chown=appuser:appgroup --chmod=500 ./app /app
USER appuser
WORKDIR /app
ENTRYPOINT ["/app/server"]
```

## Capabilities

```bash
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx:alpine
docker run --rm alpine getcap -r /
```

| Capability | Riesgo |
|------------|--------|
| NET_BIND_SERVICE | Bajo |
| NET_ADMIN | Medio |
| SYS_ADMIN | Alto |
| SYS_PTRACE | Alto |
| DAC_OVERRIDE | Alto |

## Seccomp

```json
{
  "defaultAction": "SCMP_ACT_ERRNO",
  "architectures": ["SCMP_ARCH_X86_64"],
  "syscalls": [
    {"names": ["accept", "bind", "read", "write", "open", "close"], "action": "SCMP_ACT_ALLOW"}
  ]
}
```

```bash
docker run --security-opt seccomp=default nginx:alpine
docker run --security-opt seccomp=/ruta/perfil.json nginx
```

## AppArmor y SELinux

```bash
# AppArmor
docker run --security-opt apparmor=docker-nginx nginx:alpine

# SELinux (Red Hat)
docker run --security-opt label=type:container_t nginx
```

## Rootless containers

```bash
# Podman: rootless por defecto
podman run -d --name app nginx:alpine

# Docker rootless
dockerd-rootless-setuptool.sh install
docker context use rootless
```

## Escaneo con Trivy

```bash
trivy image nginx:alpine
trivy fs .
trivy image --severity CRITICAL,HIGH nginx:alpine
trivy image --format json -o report.json nginx:alpine
```

## Firmado (Cosign)

```bash
cosign generate-key-pair
cosign sign --key cosign.key ghcr.io/usuario/mi-app:latest
cosign verify --key cosign.pub ghcr.io/usuario/mi-app:latest
```

## Network Policies (Kubernetes)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-allow-frontend
spec:
  podSelector:
    matchLabels:
      app: api
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - port: 3000
```

## Relaciones con otros módulos

- [Docker](../Docker/) — Motor que aplica configuraciones de seguridad
- [Podman](../Podman/) — Rootless nativo
- [Registry](../Registry/) — Firmado de imágenes
- [Security](../../009-Security/) — Políticas generales, Falco, OPA
- [Kubernetes](../../007-Orchestration/Kubernetes/) — PodSecurityStandards, Kyverno

## Recursos recomendados

- [Docker security docs](https://docs.docker.com/engine/security/)
- [Container Security — Liz Rice](https://container-security.com/)
- [Trivy — Aqua Security](https://github.com/aquasecurity/trivy)
