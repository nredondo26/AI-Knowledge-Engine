# 006-Containers: Contenedores

## Descripción ampliada del dominio

Los contenedores son unidades ligeras y portátiles que empaquetan una aplicación junto con todas sus dependencias (bibliotecas, binarios, configuración) para ejecutarse de manera consistente en cualquier entorno. A diferencia de las máquinas virtuales, los contenedores comparten el kernel del sistema operativo anfitrión, lo que los hace más eficientes en recursos y arranque. Docker popularizó los contenedores en 2013 basándose en tecnologías Linux existentes (cgroups para limitación de recursos, namespaces para aislamiento, y overlayfs/UnionFS para capas del sistema de archivos). El ecosistema de contenedores incluye la especificación OCI (Open Container Initiative) para estandarizar formatos de imágenes (OCI Image Spec) y tiempos de ejecución (OCI Runtime Spec). Además de Docker, existen runtimes alternativos como containerd, CRI-O, Podman (sin daemon, rootless), y sistemas de contenedores para entornos específicos. Los contenedores son la base de la computación moderna: desde desarrollo local hasta producción en Kubernetes, pasando por CI/CD, microservicios y serverless.

## Tabla de conceptos clave

| Concepto | Descripción | Herramientas/Frameworks |
|----------|-------------|------------------------|
| Imagen (Image) | Plantilla inmutable con el sistema de archivos y metadatos de la app | Dockerfile, BuildKit, Kaniko, Podman |
| Contenedor (Container) | Instancia ejecutable de una imagen, aislada con namespaces/cgroups | Docker, containerd, CRI-O, Podman |
| Capas (Layers) | Cada instrucción del Dockerfile crea una capa, cacheable y reutilizable | OverlayFS, aufs, devicemapper, btrfs |
| Dockerfile | Script declarativo para construir una imagen, instrucciones FROM, RUN, COPY, CMD | Multi-stage builds, buildx (docker buildx) |
| Registro (Registry) | Repositorio de imágenes de contenedores | Docker Hub, Harbor, ECR, GCR, ACR, GitHub Container Registry |
| Namespaces | Aislamiento de procesos, red, montaje, usuario, PID, IPC, UTS | Linux namespaces (clone flags) |
| cgroups | Control groups: limitación de CPU, memoria, IO, PIDs | cgroups v1/v2, systemd |
| OCI Spec | Estándar abierto para imágenes y runtimes de contenedores | OCI Image Spec, OCI Runtime Spec |
| Runtime | Software que ejecuta contenedores según OCI Runtime Spec | runc, crun (C/Rust), youki (Rust) |
| Docker Compose | Definición multi-contenedor en YAML para desarrollo local | docker-compose, compose V2 |
| Volumen | Persistencia de datos fuera del sistema de archivos del contenedor | bind mounts, volumes, tmpfs, named volumes |
| Network | Conectividad entre contenedores y con el exterior | bridge, host, overlay, macvlan, ipvlan, CNI |

## Tecnologías principales

| Herramienta | Tipo | Lenguaje | Creador | Características principales |
|-------------|------|----------|---------|---------------------------|
| Docker | Plataforma contenedores completa | Go | Docker Inc. | CLI, daemon, compose, swarm, build, registry client |
| containerd | Runtime de contenedores (CRI) | Go | Docker/CNCF | Core runtime, usado por Docker y Kubernetes |
| CRI-O | Runtime OCI para Kubernetes | Go | Red Hat | K8s CRI implementation ligero |
| Podman | Alternativa a Docker sin daemon | Go | Red Hat | Rootless, pods, CRICTL compatible, replace Docker |
| BuildKit | Motor de build optimizado para Docker | Go | Docker/Moby | build caching paralelo, LLB, multi-platform |
| Kaniko | Build de imágenes sin privilegios | Go | Google | Build en Kubernetes sin docker daemon |
| Skopeo | Gestión de imágenes remotas | Go | Red Hat | copy, inspect, delete, sign images |
| Dive | Análisis de capas de imágenes en CLI | Go | Alex Goodman | Optimización de tamaño de imágenes |
| Docker Compose | Orquestación multi-contenedor local | Go | Docker Inc. | YAML definición de servicios con dependencias, redes, volúmenes |
| Nerdctl | Cliente Docker-compatible para containerd | Go | CNCF | Docker CLI compataible, rootless, lazy-pulling |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos: qué es un contenedor, diferencia con VM, aislamiento (cgroups + namespaces). Instalar Docker (Docker Desktop / Docker Engine). Dockerfile básico: FROM, RUN, COPY, CMD/ENTRYPOINT, WORKDIR, EXPOSE. Construir y ejecutar imágenes (docker build, docker run). Gestión básica: docker ps, stop, rm, rmi, logs, exec, inspect. Volúmenes: bind mounts vs named volumes, persistencia de datos. Redes: bridges, exponer puertos (-p EXP:CONT). Docker Hub: pull imágenes públicas, push imágenes propias. Docker Compose básico: servicios, ports, volumes, environment.
   - Proyecto: Contenedorizar app web (Node.js/Express, Python/Flask). Docker Compose con app + PostgreSQL.
   - Lectura: docs.docker.com/get-started, "Docker Deep Dive" (Poulton).

2. **Intermedio (2-6 meses)**: Dockerfile avanzado: multi-stage builds (imágenes finales ligeras, builder pattern), COPY --from, ARG vs ENV, HEALTHCHECK, LABELs, .dockerignore. Optimización de imágenes: Alpine vs distroless, minimizar capas (RUN combinados), squash, tamaño final. Seguridad: no ejecutar como root (USER), read-only root filesystem, capability dropping (--cap-drop), seccomp profiles, AppArmor. Docker networking: network drivers (bridge, host, overlay, macvlan, ipvlan, none), user-defined networks, DNS resolution entre contenedores, network aliases. Docker Compose avanzado: depends_on, healthchecks, replicas (--scale, deploy), secrets, configs, restart policies, resource constraints (mem_limit, cpus). Logging: drivers (json-file, syslog, fluentd, awslogs), log rotation, docker logs. Volúmenes avanzados: tmpfs, NFS volumes, drivers de volúmenes (Rex-Ray, Portworx). Monitoreo: docker stats, cAdvisor, Prometheus node exporter + container metrics.
   - Proyecto: Aplicación multi-servicio con web, API, worker asíncrono, base de datos, caché, cola de mensajes (Redis, RabbitMQ).
   - Lectura: "Docker in Practice" (Miell, Sayers), Docker docs advanced sections, Dockercon videos.

3. **Avanzado (6-12 meses)**: Runtimes contenedores: OCI spec, runc, crun, youki — diferencias internas. Security: rootless containers (Podman, Docker rootless), user namespaces, gVisor (sandbox kernel), Kata Containers (VM lightweight), seccomp y AppArmor profiles personalizados, image signing (Cosign, Notary), content trust, vulnerability scanning (Trivy, Grype, Snyk, Clair). Networking avanzado: CNI (Container Network Interface) para Kubernetes, Cilium (eBPF), Calico, Weave, service mesh sidecar pattern. Storage: CSI (Container Storage Interface), Rook/Ceph, Longhorn. Construcción optimizada: BuildKit (--progress=plain, cache mounts, SSH mounts, secrets mounts), Kaniko (Kubernetes), buildx multi-platform builds (amd64, arm64, arm). Registries: Harbor (vulnerability scanning, replication, proxy cache), Artifact Registry, GitHub Container Registry. Docker in Docker (DinD) vs. Docker out of Docker (DooD). Estrategias de tagging: semantic versioning, git SHA, latest, immutable tags.
   - Proyecto: Plataforma de CI/CD auto-build y push a registry. Custom runtime container. Multi-platform pipeline.
   - Lectura: OCI specs, "Containerization: The Complete Guide", CNCF container overview.

4. **Experto (12+ meses)**: Implementación de runtime: cómo funciona runc (create, start, delete), especificación OCI, bundles. Implementación de namespaces y cgroups desde cero. Custom container images minimalistas: scratch-based, distroless, from source. Container sandboxing: Firecracker (microVM de AWS), gVisor internals (Sentry, Gofer), Katacontainers. eBPF para observability de contenedores: Cilium, Falco, Tetragon, Pixie. Container security en profundidad: kernel capabilities mínimas, LSM, seccomp-bpf profiles auto-generados (inspeccr, docker-slim). Image optimization: Lazy pulling (stargz, nydus, eStargz), container image streaming, filesystem optimization para cold starts. WASM containers: runwasi, WasmEdge, WebAssembly como alternativa a contenedores OCI. Contribución a proyectos open source (Docker, containerd, Podman, BuildKit). Edge containers: K3s, KubeEdge, MicroK8s, balenaEngine.
   - Proyecto: Implementación de OCI runtime simple. Contribución a containerd o BuildKit. Custom security profile generator.
   - Lectura: Docker source code, containerd Architecture docs, OCI specs, "Building a Container Runtime" (Sergey Slotin), Linux kernel cgroups/namespaces docs.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [004-OperatingSystems](../004-OperatingSystems/) | cgroups, namespaces, overlayfs como base tecnológica |
| [005-Cloud](../005-Cloud/) | ECS, EKS, GKE, AKS, Cloud Run como servicios container cloud |
| [007-Orchestration](../007-Orchestration/) | Kubernetes como orquestador de contenedores |
| [013-DevOps](../013-DevOps/) | Contenedores para entornos consistentes Dev/Test/Prod |
| [014-CICD](../014-CICD/) | Build de imágenes en CI/CD, deploy en CD |
| [009-Security](../009-Security/) | Seguridad de imágenes, runtime security, hardening |
| [001-Languages](../001-Languages/) | Compilación multi-stage para cada lenguaje |
| [002-Frameworks](../002-Frameworks/) | Containerización de apps con frameworks específicos |

## Recursos recomendados

- **Libros**: "Docker Deep Dive" (Poulton), "Docker in Practice" (Miell, Sayers), "Container Security" (Rice), "Kubernetes in Action" (Luksa).
- **Cursos**: Coursera "Containerization" (Whizlabs), Pluralsight "Docker", Docker Certified Associate exam.
- **Documentación**: docs.docker.com, OCI specs (github.com/opencontainers), containerd.io, podman.io.
- **Herramientas**: Dive, Trivy, Hadolint (Dockerfile linter), Sysbox, cAdvisor, Portainer, Lazydocker.
- **Seminarios**: DockerCon videos, KubeCon container track, Linux Foundation container training.

## Notas adicionales

Los contenedores han transformado la industria del software. Se recomienda entender los fundamentos de Linux (cgroups, namespaces) antes de abordar herramientas de alto nivel. Docker sigue siendo el estándar de facto para desarrollo, pero en producción Kubernetes usa containerd o CRI-O directamente. Podman ofrece una alternativa a Docker sin daemon y con mejores características de seguridad (rootless). La optimización del tamaño de imágenes es una habilidad práctica importante: una imagen Alpine típica pesa ~5MB vs ~200MB para una basada en Ubuntu.
