# Podman — Motor de contenedores sin daemon

## Descripción

Podman (Pod Manager) es un motor de contenedores open-source de Red Hat que ejecuta y gestiona contenedores sin daemon central. Es compatible con la CLI de Docker y ofrece capacidades rootless por defecto, mejorando la seguridad.

## Arquitectura

- **Sin daemon**: Cada contenedor es proceso hijo directo del usuario o systemd
- **Rootless**: Contenedores sin privilegios usando slirp4netns + fuse-overlayfs
- **Compatibilidad OCI**: Soporta imágenes OCI, runtimes runc, crun, Kata Containers
- **Pods**: Varios contenedores comparten red/PID/IPC (similar a Kubernetes)

## Instalación

```bash
# Fedora / RHEL
sudo dnf install podman
# Ubuntu / Debian
sudo apt-get install podman
# macOS
brew install podman && podman machine init && podman machine start
```

## Comandos esenciales

```bash
podman run -d --name nginx -p 8080:80 docker.io/library/nginx:alpine
podman ps -a
podman exec -it nginx sh
podman build -t mi-app:latest .
podman pod create --name mi-pod -p 8080:80
podman run --pod mi-pod -d --name app nginx:alpine
```

## Podman Compose

```bash
pip install podman-compose
podman-compose up -d
```

## Quadlet — Integración con systemd

```container
# ~/.config/containers/systemd/nginx.container
[Container]
Image=docker.io/library/nginx:alpine
PublishPort=8080:80

[Service]
Restart=always

[Install]
WantedBy=default.target
```

```bash
systemctl --user daemon-reload && systemctl --user start nginx
```

## Diferencias clave con Docker

| Aspecto | Docker | Podman |
|---------|--------|--------|
| Daemon | dockerd (root) | Sin daemon |
| Rootless | Complejo | Nativo |
| Pods | Compose | Podman pod |
| systemd | docker.service | Quadlet |

## Seguridad

```bash
podman run --cap-drop=ALL --security-opt=no-new-privileges nginx:alpine
podman run --read-only --tmpfs /tmp nginx:alpine
```

## Relaciones con otros módulos

- [Docker](../Docker/) — Alternativa con daemon
- [BuildKit](../BuildKit/) — Construcción de imágenes, Podman usa Buildah
- [Security](../Security/) — Prácticas de hardening para contenedores
- [Kubernetes](../../007-Orchestration/Kubernetes/) — Podman genera YAML de pods

## Recursos recomendados

- [Documentación oficial](https://podman.io/docs)
- [Red Hat Blog — Podman](https://developers.redhat.com/topics/podman)
- [Podman Compose](https://github.com/containers/podman-compose)
