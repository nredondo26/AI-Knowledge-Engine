# containerd — Runtime de contenedores industrial

## Descripción

containerd es un runtime de contenedores graduado de CNCF, diseñado para la gestión del ciclo de vida de contenedores con alta estabilidad y rendimiento. Es el núcleo de Docker (v1.11+), el runtime predeterminado en Kubernetes (CRI) y GKE.

## Arquitectura

- **Containers**: Creación, inicio, parada de contenedores OCI
- **Images**: Pull, push, gestión de capas
- **Snapshots**: overlayfs, devmapper, btrfs, zfs
- **Content**: Almacenamiento direccionable por contenido
- **Tasks**: Ejecución de procesos en contenedores

## Instalación

```bash
sudo apt-get install containerd
# Configurar
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
```

## Configuración base

```toml
version = 2
[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "registry.k8s.io/pause:3.9"
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  runtime_type = "io.containerd.runc.v2"
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = true
```

## Uso con nerdctl (CLI Docker-compatible)

```bash
nerdctl run -d --name nginx -p 8080:80 nginx:alpine
nerdctl build -t mi-app:latest .
nerdctl ps -a
nerdctl pull alpine:latest
nerdctl push quay.io/usuario/imagen:latest
```

## Uso directo con ctr

```bash
ctr namespace ls
ctr image pull docker.io/library/alpine:latest
ctr run --rm -t docker.io/library/alpine:latest alpine sh
```

## containerd como CRI en Kubernetes

```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
containerRuntimeEndpoint: "unix:///run/containerd/containerd.sock"
```

## Snapshotters

| Snapshotter | Descripción |
|-------------|-------------|
| overlayfs | Predeterminado, rápido |
| devmapper | Para entornos sin overlay |
| stargz/nydus | Lazy pulling (arranque rápido) |

## Lazy pulling con Stargz

```bash
nerdctl run -d --name app ghcr.io/stargz-containers/nginx:1.21-alpine-org-sg
```

## Relaciones con otros módulos

- [Docker](../Docker/) — Docker usa containerd como runtime
- [BuildKit](../BuildKit/) — Puede usar containerd como almacenamiento
- [Kubernetes](../../007-Orchestration/Kubernetes/) — containerd es el runtime CRI más usado

## Recursos recomendados

- [Documentación oficial](https://containerd.io/docs/)
- [GitHub — containerd](https://github.com/containerd/containerd)
- [GitHub — nerdctl](https://github.com/containerd/nerdctl)
