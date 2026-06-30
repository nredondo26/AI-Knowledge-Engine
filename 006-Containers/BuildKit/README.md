# BuildKit — Motor de construcción de imágenes avanzado

## Descripción

BuildKit es un motor de construcción de imágenes OCI/Docker de próxima generación. Ofrece paralelización, caching remoto, construcción secreta, montajes efímeros y soporte multiplataforma. Es el motor predeterminado desde Docker Engine 23.0+.

## Arquitectura

- **LLB (Low-Level Build)**: Grafo de construcción con operaciones atómicas
- **Frontends**: Convierten Dockerfile a LLB (dockerfile.v0, gateway.v0)
- **Workers**: Ejecutan LLB (containerd worker, OCI worker)
- **Cache**: Almacenamiento de capas (inline, registry, S3, GCS, Azure)

## Uso con Docker

```bash
# BuildKit habilitado por defecto en Docker 23.0+
docker buildx build -t mi-app:latest .

# Multiplataforma (QEMU)
docker buildx create --name multiarch --driver docker-container
docker buildx build --builder multiarch \
  --platform linux/amd64,linux/arm64 -t mi-app:latest --push .
```

## Características avanzadas

### Montajes de caché

```dockerfile
FROM golang:1.22 AS builder
RUN --mount=type=cache,target=/go/pkg/mod go mod download
COPY . .
RUN --mount=type=cache,target=/go/pkg/mod go build -o /app/server

FROM alpine:3.19
COPY --from=builder /app/server /server
CMD ["/server"]
```

### Secretos sin capas

```bash
docker buildx build --secret id=token,src=./secrets/token.txt -t mi-app .
```

```dockerfile
RUN --mount=type=secret,id=token TOKEN=$(cat /run/secrets/token) ./deploy.sh
```

### SSH agent forwarding

```dockerfile
RUN --mount=type=ssh git clone --depth=1 git@github.com:org/repo.git
```

### Caching remoto

```bash
docker buildx build \
  --cache-to type=registry,ref=usuario/mi-app:cache,mode=max \
  --cache-from type=registry,ref=usuario/mi-app:cache \
  -t mi-app:latest --push .
```

## Multi-stage build

```dockerfile
FROM golang:1.22 AS build
ARG TARGETOS TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /out/app .
FROM scratch
COPY --from=build /out/app /app
ENTRYPOINT ["/app"]
```

## Drivers de Buildx

| Driver | Multiplataforma | Uso |
|--------|----------------|-----|
| docker | Solo nativa | Build local |
| docker-container | Sí (QEMU) | Multiplataforma |
| kubernetes | Sí | CI/CD en K8s |
| remote | Sí | BuildKit remoto |

## Relaciones con otros módulos

- [Docker](../Docker/) — BuildKit es el motor de build de Docker
- [Podman](../Podman/) — Podman usa Buildah (compatible)
- [Registry](../Registry/) — Push/pull y cache remoto
- [CICD](../../014-CICD/) — Integración en pipelines

## Recursos recomendados

- [Documentación BuildKit](https://docs.docker.com/build/buildkit/)
- [GitHub — BuildKit](https://github.com/moby/buildkit)
- [Buildx CLI](https://github.com/docker/buildx)
