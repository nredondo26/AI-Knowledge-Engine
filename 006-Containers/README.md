# 006-Containers: Contenedores

## Descripción del dominio

Los contenedores son unidades de software ligeras, portables y autónomas que encapsulan una aplicación y todas sus dependencias (librerías, configuraciones, binarios) para ejecutarse de forma consistente en cualquier entorno. A diferencia de las máquinas virtuales, los contenedores comparten el kernel del sistema operativo anfitrión, lo que los hace más eficientes en recursos y arranque. Este módulo cubre Docker (el estándar de facto), Podman (alternativa sin daemon), containerd (runtime de alto rendimiento), construcción de imágenes, registries, optimización, seguridad y debugging.

## Conceptos clave

- **Imagen vs contenedor**: Una imagen es una plantilla inmutable (layer stack); un contenedor es una instancia en ejecución de una imagen
- **Capas (layers)**: Cada instrucción en un Dockerfile crea una capa read-only; el sistema de capas permite caching y compartición eficiente
- **Dockerfile**: FROM, RUN, COPY, ADD, CMD, ENTRYPOINT, WORKDIR, ENV, EXPOSE, VOLUME, USER, HEALTHCHECK, multi-stage builds
- **Multi-stage builds**: Varias etapas FROM para compilar en un entorno pesado y generar artefactos en una imagen final mínima
- **Registries y repositorios**: Docker Hub, ECR (AWS), ACR (Azure), GCR/GAR (Google), Harbor, Quay, Nexus; versionado con tags semánticos
- **Redes de contenedores**: bridge, host, none, overlay (Swarm/K8s), macvlan, ipvlan; CNI (Container Network Interface)
- **Volúmenes y bind mounts**: Volúmenes gestionados por Docker (named volumes), bind mounts (rutas del host), tmpfs mounts
- **Docker Compose**: Definición de servicios multi-contenedor en YAML (docker-compose.yml); redes, volúmenes, dependencias, healthchecks
- **Contenedores sin Docker**: Podman (sin daemon, rootless), containerd (uso directo via ctr/nerdctl), CRI-O (usado por K8s)
- **Seguridad**: Rootless containers, seccomp, AppArmor, SELinux, Capabilities (cap_drop, cap_add), no-new-privileges, read-only root filesystem
- **Optimización de imágenes**: Imágenes slim (alpine, distroless), multi-stage builds, minimizar capas (RUN &&), .dockerignore, compresión, SBOM
- **Namespaces y cgroups**: Linux namespaces (PID, NET, MNT, UTS, IPC, USER, CGROUP) para aislamiento; cgroups para límites de CPU/memoria/IO
- **Registro y logging**: stdout/stderr como salida de logs, Docker logging drivers (json-file, journald, syslog, fluentd, awslogs, splunk)

## Tecnologías principales

| Herramienta | Rol | Notas |
|-------------|-----|-------|
| Docker CE/EE | Motor de contenedores estándar | Daemon dockerd + client CLI; amplio ecosistema |
| Podman | Motor sin daemon | Compatible con Docker CLI (alias docker=podman); rootless por defecto |
| containerd | Runtime industrial (graduado CNCF) | Usado por Docker, Kubernetes (CRI), GKE; ligero |
| CRI-O | Runtime CRI para Kubernetes | Implementación ligera del CRI específica para K8s |
| nerdctl | CLI para containerd | Docker-compatible CLI para containerd |
| BuildKit | Motor de build avanzado | Construcciones paralelas, caching remoto, secreto seguro |
| Skopeo | Inspección y copia de imágenes | Trabaja con diferentes registries sin necesidad de daemon |
| Dive | Análisis de capas | Inspecciona y optimiza el tamaño de imágenes |

## Hoja de ruta

1. **Principiante**: Instalar Docker — ejecutar contenedores (docker run, ps, exec, logs) — conceptos de imágenes vs contenedores — Dockerfile básico (FROM + CMD) — docker build + docker run — mapeo de puertos (-p) y volúmenes (-v)
2. **Intermedio**: Docker Compose multi-servicio (app + DB + Redis) — multi-stage builds — Dockerfile optimizado (capas, .dockerignore) — redes bridge y host — tags semánticos — healthchecks — docker-compose profiles
3. **Avanzado**: Seguridad de contenedores (capabilities, seccomp, AppArmor) — rootless mode con Podman — BuildKit avanzado — registries privados (Harbor, ECR) — escaneo de vulnerabilidades (Trivy, Snyk, Docker Scout) — SBOM — limitación de recursos (CPU shares, memory limits, --pids-limit)
4. **Experto**: Plugins de red y volúmenes — custom runtimes (gVisor, Kata Containers) — OCI specification — contribución a containerd/runc — firma de imágenes (Cosign, Notary) — políticas de admisión (Kyverno, OPA) — performance tuning a nivel de kernel (cgroups v2, io_uring)

## Relaciones con otros módulos

- [004-OperatingSystems](../004-OperatingSystems/) — Namespaces, cgroups, kernel tuning para contenedores
- [005-Cloud](../005-Cloud/) — Container registries gestionados (ECR, ACR, GCR), Fargate, Cloud Run
- [007-Orchestration](../007-Orchestration/) — Orquestación de contenedores con Kubernetes, ECS, Swarm; K8s usa containerd/CRI-O como runtime
- [008-Networking](../008-Networking/) — CNI plugins (Calico, Cilium, Flannel, Weave), service mesh (Istio, Linkerd)
- [009-Security](../009-Security/) — Políticas de seguridad en contenedores, firma de imágenes, Trivy, Falco
- [013-DevOps](../013-DevOps/) — Pipeline CI/CD con builds de imágenes Docker
- [014-CICD](../014-CICD/) — Build and push de imágenes automatizado

## Recursos recomendados

- **Docker**: docs.docker.com, "Docker Deep Dive" (Nigel Poulton), Play with Docker, Docker Captain's blog
- **Podman**: podman.io/docs, Red Hat Blog: Podman, Quadlet (systemd integration)
- **General**: "Container Security" (Rice Liz), OCI specification (opencontainers.org), CNCF Landscape
- **Herramientas**: Dive (análisis de capas), Trivy (vulnerabilidades), Hadolint (lint para Dockerfile), Dockle (seguridad)
