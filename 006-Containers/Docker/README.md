# Docker

## Conceptos Fundamentales

Docker empaqueta aplicaciones y dependencias en **imágenes** ejecutadas como **contenedores** aislados. Comparten el kernel del host con sistema de archivos, red y procesos propios.

### Arquitectura

```
Docker CLI ──REST──> Docker Daemon ──> containerd ──> runc (OCI)
```

## Dockerfile

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production
COPY src/ tsconfig.json ./
RUN npm run build

FROM node:20-alpine AS runner
RUN apk add --no-cache dumb-init
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
USER appuser
EXPOSE 3000
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/main.js"]

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1
```

### .dockerignore

```
node_modules
dist
.git
*.md
.env
.gitignore
Dockerfile
docker-compose.yml
```

## Multi-stage Build

```dockerfile
FROM golang:1.22-alpine AS go-builder
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app main.go

FROM node:20-alpine AS node-builder
WORKDIR /app
COPY frontend/package.json ./
RUN npm ci
COPY frontend/ .
RUN npm run build

FROM gcr.io/distroless/static-debian12:nonroot
WORKDIR /app
COPY --from=go-builder /app .
COPY --from=node-builder /app/dist ./dist
ENTRYPOINT ["/app"]
```

## Docker Compose

```yaml
version: "3.9"
services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
      target: runner
    ports: ["3000:3000"]
    environment:
      - NODE_ENV=production
      - DB_HOST=db
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
    volumes:
      - uploads:/data/uploads
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d myapp"]

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes: [redisdata:/data]

volumes:
  pgdata:
  redisdata:
  uploads:
```

## Comandos Esenciales

```bash
docker build -t myapp:1.0.0 -t myapp:latest .
docker run -it --rm -p 3000:3000 --name myapp myapp:1.0.0
docker run --env-file .env.prod myapp:1.0.0
docker exec -it myapp sh
docker logs -f myapp
docker system prune -af --volumes
docker tag myapp:1.0.0 registry.example.com/myapp:1.0.0
docker push registry.example.com/myapp:1.0.0
```

## Redes

```bash
docker network create --driver bridge --subnet 172.20.0.0/16 my-network
docker run --network my-network --name api --rm -d myapp
docker run --network my-network --rm alpine ping api
```

## Volúmenes

```yaml
services:
  app:
    volumes:
      - data:/var/lib/data        # Named volume
      - ./config:/app/config:ro   # Bind mount
      - type: tmpfs               # Memoria
        target: /app/cache
```

## Seguridad

```dockerfile
RUN adduser -D -u 1001 appuser
USER appuser
```

```bash
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE myapp
docker scout quickview myapp:1.0.0
```

## Best Practices

1. **Imágenes base pequeñas**: Alpine, distroless.
2. **Multi-stage builds**: Build separado del runtime.
3. **Cache de capas**: Dependencias antes que código.
4. **No `:latest`**: Usar SHA de git o semver.
5. **Healthchecks siempre**.
6. **No secrets en imágenes**: BuildKit.
   ```dockerfile
   RUN --mount=type=secret,id=npmrc cat /run/secrets/npmrc > .npmrc
   ```
7. **Limitar recursos**: `--memory` y `--cpus`.
8. **Escaneo**: `trivy` o `docker scout` en CI.
9. **Logging a stdout/stderr**: JSON driver.
10. **`dumb-init` o `tini`**: Manejo correcto de señales.
