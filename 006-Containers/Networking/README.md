# Networking en Contenedores

## Descripción

El networking de contenedores gestiona la comunicación entre contenedores y con el exterior. Linux proporciona namespaces de red, bridges virtuales, veth pairs e iptables; Docker y otros motores abstraen estos conceptos en drivers de red reutilizables.

## Drivers de red en Docker

| Driver | Aislamiento | Alcance | Caso de uso |
|--------|-------------|---------|-------------|
| bridge | Sí | Single host | Comunicación entre contenedores (default) |
| host | No | Single host | Máximo rendimiento |
| none | Completo | — | Sin red |
| overlay | Sí | Multi-host | Swarm, clúster |
| macvlan | Sí (MAC) | Multi-host | IP real de red física |
| ipvlan | Sí (IP) | Multi-host | Sin MAC propia |

## Red bridge personalizada

```bash
docker network create --driver bridge \
  --subnet 172.28.0.0/16 \
  --gateway 172.28.0.1 \
  mi-red
docker run -d --network mi-red --name app1 nginx:alpine
docker run -d --network mi-red --name app2 nginx:alpine
docker exec app1 ping app2
```

## Red host

```bash
docker run --network host -d nginx:alpine
# No hay aislamiento de puertos; -p no funciona aquí
```

## Red overlay (Swarm)

```bash
docker network create --driver overlay --subnet 10.10.0.0/16 --attachable mired
docker service create --name web --network mired --replicas 3 nginx:alpine
```

## Publicación de puertos

```bash
docker run -p 8080:80 nginx
docker run -p 127.0.0.1:8080:80 nginx
docker run -p 53:53/udp dns-server
```

## DNS interno

Docker resuelve nombres de servicio en redes bridge personalizadas:

```yaml
services:
  api:
    image: miapp:latest
    depends_on: [db]
  # api resuelve "db" por DNS
  db:
    image: postgres:16-alpine
```

## iptables

Docker gestiona reglas iptables automáticamente:

```bash
sudo iptables -t nat -L -n | grep DOCKER
```

## CNI (Container Network Interface)

Estándar usado por Kubernetes y otros orquestadores:

```json
{
  "cniVersion": "1.0.0",
  "name": "mired",
  "type": "bridge",
  "bridge": "cni0",
  "ipam": {
    "type": "host-local",
    "ranges": [[{"subnet": "10.22.0.0/16"}]]
  }
}
```

## Plugins CNI populares

| Plugin | Descripción |
|--------|-------------|
| Calico | NetworkPolicy, BGP, eBPF |
| Cilium | eBPF, Hubble, L7 |
| Flannel | Overlay VXLAN simple |
| Antrea | Open vSwitch |

## Network namespaces

```bash
docker inspect --format '{{.State.Pid}}' contenedor
sudo nsenter -t $(docker inspect --format '{{.State.Pid}}' contenedor) -n ip addr
```

## Relaciones con otros módulos

- [Docker](../Docker/) — Motores que implementan los drivers
- [Security](../Security/) — Aislamiento de red, iptables
- [Networking](../../008-Networking/) — CNI, service mesh
- [Kubernetes](../../007-Orchestration/Kubernetes/) — Pod networking, NetworkPolicy

## Recursos recomendados

- [Docker networking overview](https://docs.docker.com/network/)
- [CNI specification](https://www.cni.dev/docs/)
- [Cilium — eBPF](https://cilium.io/)
