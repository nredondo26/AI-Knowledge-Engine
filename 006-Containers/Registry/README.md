# Registry — Almacenamiento y distribución de imágenes OCI

## Descripción

Un registry de contenedores almacena y distribuye imágenes OCI/Docker. Existen registries públicos (Docker Hub, ghcr.io, quay.io), gestionados por cloud (ECR, ACR, GAR) y autoalojados (Harbor, Nexus, Registry v2).

## Registries principales

| Registry | Proveedor | Características |
|----------|-----------|-----------------|
| Docker Hub | Docker Inc. | Públicos ilimitados, privados limitados |
| Amazon ECR | AWS | Integración EKS/ECS, IAM, escaneo |
| Azure ACR | Azure | Integración AKS, georeplicación |
| Google AR | GCP | Integración GKE, multi-formato |
| ghcr.io | GitHub | GitHub Packages, gratis para públicos |
| Harbor | CNCF | Autoalojado, escaneo Trivy, RBAC |
| Registry v2 | Open Source | Distribución oficial, mínimo |

## Docker Registry v2 (autoalojado)

```bash
docker run -d -p 5000:5000 --name registry registry:2
docker tag alpine:latest localhost:5000/alpine:latest
docker push localhost:5000/alpine:latest
```

### Con almacenamiento S3

```yaml
version: '3'
services:
  registry:
    image: registry:2
    environment:
      REGISTRY_STORAGE: s3
      REGISTRY_STORAGE_S3_REGION: us-east-1
      REGISTRY_STORAGE_S3_BUCKET: mi-registry-bucket
```

## Harbor — Registry empresarial

```bash
tar xzvf harbor-offline-installer-v*.tgz && cd harbor
cp harbor.yml.tmpl harbor.yml  # editar hostname, certificados
sudo ./install.sh
```

## Autenticación

```bash
# GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u usuario --password-stdin

# ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin 123456789.dkr.ecr.us-east-1.amazonaws.com

# Pull secret en Kubernetes
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io --docker-username=usuario --docker-password=$GITHUB_TOKEN
```

## Firmado de imágenes (Cosign)

```bash
cosign generate-key-pair
cosign sign --key cosign.key ghcr.io/usuario/mi-app:latest
cosign verify --key cosign.pub ghcr.io/usuario/mi-app:latest
```

## Limpieza (GC)

```bash
# Registry v2
docker exec registry /bin/registry garbage-collect /etc/docker/registry/config.yml
# Harbor: reglas automáticas desde UI
```

## Relaciones con otros módulos

- [Docker](../Docker/) — docker pull/push
- [BuildKit](../BuildKit/) — Caching remoto, push multi-arquitectura
- [Security](../Security/) — Firmado (Cosign), escaneo (Trivy)
- [Kubernetes](../../007-Orchestration/Kubernetes/) — Pull secrets, imagePullPolicy

## Recursos recomendados

- [Docker Registry — GitHub](https://github.com/distribution/distribution)
- [Harbor — CNCF](https://goharbor.io/)
- [Cosign — Sigstore](https://github.com/sigstore/cosign)
