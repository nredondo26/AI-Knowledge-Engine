# Storage — Almacenamiento en Contenedores

## Descripción del dominio

El almacenamiento en contenedores resuelve el problema de la persistencia de datos en entornos efímeros. Los contenedores son, por defecto, sin estado: cualquier cambio en el sistema de archivos se pierde al reiniciar el contenedor. Este módulo cubre las estrategias para añadir almacenamiento persistente y compartido a contenedores y orquestadores: volúmenes Docker, bind mounts, tmpfs, CSI (Container Storage Interface), PV/PVC en Kubernetes, soluciones de almacenamiento distribuido (Longhorn, Rook/Ceph, OpenEBS) y patrones de backup/restore para datos en contenedores.

## Áreas clave

- **Volúmenes Docker**: Almacenamiento gestionado por Docker en `/var/lib/docker/volumes/`. Named volumes vs anonymous volumes. Drivers: local, nfs, cifs, tmpfs, bind
- **Bind mounts**: Montaje directo de una ruta del host en el contenedor. Útil para desarrollo (hot-reload), configuraciones, sockets Unix
- **tmpfs mounts**: Almacenamiento en RAM. Rápido pero volátil. Para datos temporales o secretos
- **CSI (Container Storage Interface)**: Estándar para exponer sistemas de almacenamiento a contenedores en Kubernetes. Drivers: EBS (AWS), Persistent Disk (GCP), Azure Disk, NFS, Ceph, Longhorn
- **PersistentVolume (PV) y PersistentVolumeClaim (PVC)**: Abstracción de almacenamiento en Kubernetes. PV = recurso de almacenamiento, PVC = solicitud. AccessModes: ReadWriteOnce (RWO), ReadOnlyMany (ROX), ReadWriteMany (RWX)
- **StorageClass**: Perfiles de almacenamiento dinámico en Kubernetes. provisioner, reclaimPolicy (Retain/Delete/Recycle), allowVolumeExpansion
- **StatefulSet vs Deployment**: StatefulSet para aplicaciones con estado (bases de datos) con PVCs estables, orden de arranque y sticky identities
- **Patrones de almacenamiento**: Sidecar para backups, InitContainer para migraciones, emptydir para caché compartida

## Ejemplo: Volumen Docker con compose

```yaml
# docker-compose.yml
services:
  postgres:
    image: postgres:16
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: secret

volumes:
  pgdata:
    driver: local
```

## Ejemplo: PVC y StorageClass en Kubernetes

```yaml
# storage-class.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
  fsType: ext4
reclaimPolicy: Retain
---
# pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: fast-ssd
```

## Tecnologías principales

| Solución | Tipo | Características |
|----------|------|-----------------|
| Docker volumes | Simple | Nativo Docker, backup con tar, drivers NFS/SSH |
| Longhorn (Rancher) | Distribuido | Replicación síncrona, snapshots, backups S3, CSI |
| Rook/Ceph | Distribuido | Escalable, auto-rebalanceo, soporta RBD/CephFS/S3 |
| OpenEBS | Distribuido | Mayastor (NVMe), Jiva (iSCSI), Local PV |
| Portworx | Comercial | Hyperconverged, encryption, DR, multi-cloud |
| EBS / EFS | Cloud (AWS) | EBS=block single-AZ, EFS=NFS multi-AZ |
| Persistent Disk | Cloud (GCP) | Block storage, snapshots, regional PD |
| Azure Disk / Files | Cloud (Azure) | Disk=block, Files=SMB/NFS |
| NFS | Simple | RWX compartido, servidor NFS externo |

## Buenas prácticas

- Usar volúmenes nombrados (named volumes) en lugar de bind mounts para producción
- Para Kubernetes, definir StorageClasses específicas para cada workload (SSD vs HDD, RWO vs RWX)
- Usar StatefulSet solo cuando sea necesario; preferir Deployments con PV externos
- Realizar backups periódicos de volúmenes (Velero, restic, duplicati)
- Configurar reclaimPolicy: Retain para datos críticos (evitar borrado accidental)
- Limitar tamaño de volúmenes con resource.requests.storage y quota
- Para RWX, usar NFS, Longhorn o EFS; evitar soluciones RWO para múltiples réplicas
- Cifrar datos sensibles en reposo (storage encryption, LUKS)
