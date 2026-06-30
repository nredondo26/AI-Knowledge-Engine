# Linode (Akamai Connected Cloud)

## Descripción

Linode —ahora parte de Akamai— es un proveedor cloud enfocado en desarrolladores, con precios predecibles, documentación excelente y generoso tier gratuito. Ofrece VMs (Linodes), Kubernetes (LKE), bases de datos administradas, Object Storage y PaaS.

| Categoría | Servicios Clave |
|-----------|----------------|
| Cómputo | Linodes (Shared, Dedicated, High Memory, GPU A100) |
| Kubernetes | LKE (control plane HA gratuito) |
| Bases de Datos | PostgreSQL, MySQL, MongoDB, Redis administrados |
| Almacenamiento | Object Storage (S3), Block Storage (Volumes), Backups |
| Networking | VPC, VLAN, NodeBalancers, Firewalls, DNS Manager |

---

## Linodes (Compute)

### Planes

| Plan | Rango | Caso de uso |
|------|-------|-------------|
| Shared CPU | 1GB–192GB ($5–$960/mes) | Web servers, dev/staging |
| Dedicated CPU | 4GB–512GB ($36–$1,440/mes) | CPU-bound, CI/CD |
| High Memory | 24GB–512GB ($60–$2,400/mes) | In-memory DBs, Redis |
| GPU | 1–4× A100 ($1,000–$4,000/mes) | ML training, AI inference |

```bash
# CLI
pip install linode-cli
linode-cli configure

# Crear Linode
linode-cli linodes create \
  --label mi-linode \
  --region us-east --type g6-nanode-1 \
  --image linode/ubuntu22.04 --root_pass MiPassword

# Comandos básicos
linode-cli linodes list
linode-cli linodes view <id>
linode-cli linodes reboot/shutdown/boot <id>
linode-cli linodes resize <id> --type g6-dedicated-4
```

## Networking

```bash
# NodeBalancer
linode-cli nodebalancers create --label mi-lb --region us-east
linode-cli nodebalancers config-create <nb-id> \
  --port 80 --protocol http --check path --check_path /health

# Cloud Firewall
linode-cli firewalls create --label "mi-firewall" \
  --rules.inbound "[{protocol:TCP,ports:22,addresses:{ipv4:['0.0.0.0/0']}}]"

# DNS Manager
linode-cli domains create --domain midominio.com --type master --soa_email admin@m.com
linode-cli domains records-create <domain-id> \
  --type A --name "@" --target <ip-linode>
```

## Object Storage (S3-compatible)

```bash
s3cmd --configure
# Endpoint: us-east-1.linodeobjects.com
s3cmd mb s3://mi-bucket
s3cmd put archivo.txt s3://mi-bucket/
s3cmd setacl s3://mi-bucket --acl-public   # bucket público

aws s3 ls --endpoint-url https://us-east-1.linodeobjects.com
aws s3 cp archivo.txt s3://mi-bucket/ --endpoint-url https://us-east-1.linodeobjects.com
```

## Block Storage

```bash
linode-cli volumes create --label mi-volumen --region us-east --size 100
linode-cli volumes attach <volume-id> --linode_id <linode-id>

# En el Linode:
mkfs.ext4 /dev/disk/by-id/scsi-0Linode_Volume_mi-volumen
mount /dev/disk/by-id/scsi-0Linode_Volume_mi-volumen /mnt/volumen
```

## LKE (Linode Kubernetes Engine)

```bash
linode-cli lke cluster-create \
  --label mi-cluster --region us-east --k8s_version 1.30 \
  --node_pools.type g6-standard-2 --node_pools.count 3

linode-cli lke kubeconfig-view <cluster-id> | jq -r '.kubeconfig' | base64 -d > kubeconfig.yaml
kubectl get nodes

linode-cli lke pool-create <cluster-id> \
  --type g6-dedicated-8 --count 2 \
  --autoscaler.enabled true --autoscaler.min 1 --autoscaler.max 5
```

## Managed Databases

```bash
linode-cli databases create \
  --engine postgresql --type g6-standard-2 \
  --region us-east --label mi-pg --cluster_size 2 --ssl_connection true

linode-cli databases view <db-id>  # obtener cadena de conexión
linode-cli databases backups list <db-id>
linode-cli databases backups restore <db-id> <backup-id>
```

## Marketplace Apps

```bash
linode-cli stackscripts list --is_public true | grep "marketplace"
linode-cli linodes create \
  --label wordpress-site --region us-east \
  --type g6-standard-2 --image linode/ubuntu22.04 \
  --stackscript_id <id> \
  --stackscript_data '{"db_root_password":"secure123"}'
```

## Costos

```bash
linode-cli account invoice-list      # factura
linode-cli account transfer          # uso actual
linode-cli linodes shutdown <id>     # apagar (solo storage se cobra)
```

---

## Relaciones

- [005-Cloud/DigitalOcean](../../005-Cloud/DigitalOcean/) — Competidor directo CLI similar
- [005-Cloud/AWS](../../005-Cloud/AWS/) — EC2 vs Linode, S3 vs Object Storage
- [004-OperatingSystems](../../004-OperatingSystems/) — Imágenes SO, cloud-init
- [006-Containers](../../006-Containers/) — Docker en Linode, LKE
- [007-Orchestration](../../007-Orchestration/) — LKE, Kubernetes

## Recursos

- **Documentación**: linode.com/docs — una de las mejores documentaciones cloud
- **API v4**: linode.com/docs/api (OpenAPI 3.0)
- **CLI**: github.com/linode/linode-cli
- **Terraform**: registry.terraform.io/providers/linode/linode
