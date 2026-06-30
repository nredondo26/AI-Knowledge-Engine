# Docker Compose — Orquestación multi-contenedor

## Descripción

Docker Compose define y ejecuta aplicaciones multi-contenedor usando un archivo YAML. Permite levantar entornos completos (app + DB + cache + cola) con un solo comando.

## Instalación

```bash
# Docker Desktop incluye Compose v2
docker compose version
# Linux
sudo apt-get install docker-compose-plugin
```

## Ejemplo básico

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    depends_on:
      api:
        condition: service_healthy
  api:
    build: ./api
    environment:
      DB_HOST: db
      DB_PASSWORD: ${DB_PASSWORD:-secreto}
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
  db:
    image: postgres:16-alpine
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: miapp
      POSTGRES_PASSWORD: ${DB_PASSWORD:-secreto}

volumes:
  pgdata:
```

## Comandos principales

```bash
docker compose up -d
docker compose logs -f
docker compose exec api npx prisma migrate dev
docker compose up -d --build
docker compose down -v  # -v elimina volúmenes
docker compose up -d --scale api=3
```

## Profiles — Entornos diferenciados

```yaml
services:
  app:
    image: nginx:alpine
    profiles: ["dev", "prod"]
  mailhog:
    image: mailhog/mailhog
    profiles: ["dev"]
    ports: ["8025:8025"]
```

```bash
docker compose --profile dev up -d
```

## Watch mode — Desarrollo en vivo

```yaml
services:
  app:
    build: .
    develop:
      watch:
        - action: sync
          path: ./src
          target: /app/src
        - action: rebuild
          path: ./package.json
```

```bash
docker compose watch
```

## Variables de entorno

```bash
# .env (auto-cargado)
DB_USER=admin
DB_PASSWORD=s3cret
NODE_ENV=production
```

```yaml
services:
  app:
    image: ${IMAGE_NAME:-miapp}:${TAG:-latest}
    environment:
      - NODE_ENV=${NODE_ENV:-development}
```

## Redes personalizadas

```yaml
services:
  frontend:
    image: nginx:alpine
    networks: [frontend]
  backend:
    image: miapp-api:latest
    networks: [frontend, backend]
  db:
    image: postgres:16-alpine
    networks: [backend]

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true
```

## Relaciones con otros módulos

- [Docker](../Docker/) — Docker Engine es el runtime de Compose
- [Podman](../Podman/) — Podman Compose es compatible
- [Networking](../Networking/) — Redes bridge, overlay, DNS
- [Kubernetes](../../007-Orchestration/Kubernetes/) — Compose comparte conceptos con K8s

## Recursos recomendados

- [Docker Compose docs](https://docs.docker.com/compose/)
- [Compose Specification](https://github.com/compose-spec/compose-spec)
- [Awesome Compose](https://github.com/docker/awesome-compose)
