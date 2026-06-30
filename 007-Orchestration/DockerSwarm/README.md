# Docker Swarm — Orquestación nativa de Docker

## Descripción

Docker Swarm es el modo de orquestación integrado en Docker Engine. Convierte nodos Docker en un clúster virtual con servicios escalables, redes overlay multi-host y balanceo integrado. Es la opción más simple para orquestación Docker, ideal para entornos pequeños/medianos.

## Arquitectura

- **Manager nodes**: Control plane (Raft, API, scheduling)
- **Worker nodes**: Ejecutan tareas
- **Services**: Definición declarativa del workload
- **Tasks**: Contenedores individuales del servicio
- **Overlay network**: Red multi-host
- **Routing Mesh**: Balanceo integrado (Ingress)

## Inicializar clúster

```bash
docker swarm init --advertise-addr 192.168.1.10
docker swarm join --token SWMTKN-1-xxxxx 192.168.1.10:2377
docker node ls
```

## Desplegar servicios

```bash
docker service create --name web --replicas 3 \
  --publish published=8080,target=80 nginx:alpine

docker network create --driver overlay --attachable mired
docker service create --name api --replicas 5 \
  --network mired --publish 3000:3000 miapp:latest

docker service ls
docker service ps web
```

## Stack (Compose en Swarm)

```yaml
version: "3.8"
services:
  web:
    image: nginx:alpine
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: "0.5"
          memory: 256M
    ports:
      - "8080:80"
    networks: [frontend]
  api:
    image: miapp:latest
    deploy:
      replicas: 5
      update_config:
        parallelism: 2
        delay: 10s
        order: start-first
    environment:
      DB_HOST: db
    networks: [frontend, backend]
  db:
    image: postgres:16-alpine
    deploy:
      mode: replicated
      replicas: 1
    volumes:
      - db-data:/var/lib/postgresql/data
    networks: [backend]

volumes:
  db-data:
networks:
  frontend: { driver: overlay }
  backend: { driver: overlay, internal: true }
```

```bash
docker stack deploy -c stack.yml miapp
docker stack services miapp
docker stack rm miapp
```

## Routing Mesh

```bash
# Ingress (balanceo externo) — por defecto
docker service create --name web --publish published=80,target=80 --replicas 5 nginx:alpine

# DNS Round Robin (balanceo interno)
docker service create --name api --network mired --endpoint-mode dnsrr --replicas 5 miapp:latest
```

## Rolling updates

```bash
docker service update --image nginx:1.25 web
docker service update --image nginx:1.26 --update-parallelism 1 --update-delay 30s web
docker service rollback web
```

## Labels y constraints

```bash
docker node update --label-add ssd=true nodo-worker-1
docker service create --name db \
  --constraint 'node.labels.ssd == true' \
  --replicas 1 postgres:16-alpine
```

## Secretos

```bash
echo "password_s3cr3ta" | docker secret create db_password -
docker service create --name db --secret db_password \
  -e POSTGRES_PASSWORD_FILE=/run/secrets/db_password postgres:16-alpine
```

## Relaciones con otros módulos

- [Containers/Docker](../../006-Containers/Docker/) — Swarm es parte de Docker Engine
- [Containers/Compose](../../006-Containers/Compose/) — Stacks basados en Compose
- [Kubernetes](../Kubernetes/) — Alternativa más potente

## Recursos recomendados

- [Docker Swarm overview](https://docs.docker.com/engine/swarm/)
- [Deploy stack to Swarm](https://docs.docker.com/engine/swarm/stack-deploy/)
- [Docker Swarm cheatsheet](https://dockerlabs.collabnix.com/docker/cheatsheet/)
