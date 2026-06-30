# DigitalOcean

## Servicios Principales

DigitalOcean es un proveedor cloud enfocado en desarrolladores y startups, conocido por su simplicidad, precios predecibles y documentación excelente. Ofrece droplets (VMs), Kubernetes, databases administradas, almacenamiento y serverless.

| Categoría | Servicios Clave |
|-----------|----------------|
| Cómputo | Droplets (VMs), Droplet Autoscale, Reserved CPUs, GPU Droplets (H100), Premium Intel/AMD Droplets |
| Kubernetes | DigitalOcean Kubernetes (DOKS), Node Pools (CPUs, GPUs), Autoscaling, HA Control Plane |
| Bases de Datos | Managed Databases: PostgreSQL, MySQL, Redis, MongoDB, Kafka (PaaS) |
| Almacenamiento | Spaces (S3-compatible Object Storage), Volumes (Block Storage), Backups, Snapshots |
| Networking | VPC, Cloud Firewalls, Floating IPs, Load Balancers, DNS (Managed), CDN, Cloudways |
| Serverless | App Platform (PaaS full-managed), Functions (FaaS, Node.js, Python, Go) |
| PaaS | App Platform: auto-deploy desde GitHub/GitLab, containers, static sites, workers, cron jobs |
| Imágenes | 1-Click Apps (LEMP, Wordpress, Docker, Ghost, GitLab, MEAN, LAMP, etc.), Marketplace, Custom Images |
| Monitoreo | Monitoring (CPU, memory, disk, network, alerts), Uptime Checks, Metrics API, Sentry integration |
| Dev Tools | API, Terraform Provider, Pulumi, Ansible, Packer, Docker, doctl (CLI), Cloud Init |

---

## Droplets (Compute)

### Tipos de Droplets

| Tipo | Familia | Caso de uso |
|------|---------|-------------|
| General Purpose | s-*-vcpu-*-gb Intel/AMD | Web servers, small DBs, dev/staging |
| CPU-Optimized | c-*-vcpu-*-gb Intel/AMD | CI/CD, video encoding, high-traffic web, gaming |
| Memory-Optimized | m-*-vcpu-*-gb Intel/AMD | In-memory caches (Redis), real-time analytics, large DBs |
| Storage-Optimized | so-*-vcpu-*-gb NVMe | High IOPS databases, Elasticsearch, Kafka |
| Premium Intel | s-*, c-*, m-* Intel Xeon | Procesadores Intel más rápidos (3.5 GHz) |
| Premium AMD | s-*, c-*, m-* AMD EPYC | AMD EPYC Milan (mejor relación precio/rendimiento) |
| GPU | gpu-* (H100, A100) | ML training, AI inference, 3D rendering, VDI |

### Características
- **Autoscale**: grupos de droplets con escalado basado en CPU/memory (mín/máx)
- **Reserved CPUs**: 30-50% descuento por compromiso de 1 o 3 años (similar a Reserved Instances)
- **Cloud-Init**: scripts de arranque (YAML) para configuración inicial
- **Custom Images**: importar imágenes propias (RAW, qcow2, VHDX) a través de Custom Images
- **Monitoring**: CPU, memory, disk I/O, network, disk usage con alertas (email, Slack)
- **Snapshots**: imagen completa del droplet (booteable, transferible entre regiones)
- **Backups**: automáticos semanales ($1/mes por 25 GB o 20% del droplet)
- **Floating IPs**: IPs públicas reasignables entre droplets (HA)
- **Metadata API**: http://169.254.169.254/metadata/v1.json

```bash
# Instalar doctl (CLI oficial)
snap install doctl
# o: brew install doctl

# Autenticación
doctl auth init --access-token TOKEN_DO

# Crear droplet
doctl compute droplet create mi-droplet \
  --region nyc1 --size s-2vcpu-4gb \
  --image ubuntu-22-04-x64 \
  --ssh-keys 12345678 --tag-name produccion

# Listar droplets
doctl compute droplet list

# Obtener detalles de un droplet
doctl compute droplet get <droplet-id>

# Hacer snapshot
doctl compute droplet-action snapshot --snapshot-name "backup-$(date +%F)" <droplet-id>

# Power off
doctl compute droplet-action power-off <droplet-id>

# Eliminar droplet
doctl compute droplet delete <droplet-id> --force

# Crear droplet con cloud-init
doctl compute droplet create mi-droplet \
  --user-data-file ./cloud-init.yaml \
  --size s-2vcpu-4gb --image ubuntu-22-04-x64 --region nyc1

# Crear droplet autoscale group
doctl compute droplet autoscale create \
  --name mi-autoscale \
  --config ./autoscale-config.yaml

# Agregar Floating IP
doctl compute floating-ip create --region nyc1
doctl compute floating-ip assign <ip> <droplet-id>
```

---

## Networking

### VPC (Virtual Private Cloud)
Red aislada por región:
- **Default VPC**: creada automáticamente por región
- **Custom VPC**: crear VPCs propias con rangos IP (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
- **Peering**: conectar VPCs en la misma región (tráfico gratuito)
- **Droplets en VPC**: comunicación privada entre droplets sin costo, sin exponer IPs públicas
- **Managed Databases**: conectadas a VPC para tráfico privado (evitar tráfico público)

### Cloud Firewalls
Firewall distribuido con reglas stateful:
- **Inbound/Outbound**: IP, CIDR, tags, droplet IDs, load balancers, VPCs
- **Tags**: aplicar reglas por tag (ej: "web", "db", "cache")
- **Default policies**: deny all inbound, allow all outbound
- **Rate Limiting**: mitigación básica de DDoS a nivel de firewall

### Load Balancers
Balanceo de capa 4/7:
- **Regional**: tráfico entre droplets en la misma región
- **Health Checks**: HTTP, TCP, HTTPS (intervalo configurable)
- **SSL Termination**: TLS 1.2/1.3 con certificados administrados
- **Sticky Sessions**: cookies para sesiones persistentes
- **Proxy Protocol**: preserva IP del cliente
- **Autoscaling Integration**: LB apunta a autoscale groups automáticamente

### DNS
Servidor DNS autoritativo gratuito:
- **Records**: A, AAAA, CNAME, MX, TXT, NS, SRV, CAA
- **DNSSEC**: firmado automático
- **Global**: 18 anycast nameservers

```bash
# Crear firewall
doctl compute firewall create \
  --name mi-firewall \
  --inbound-rules "protocol:tcp,ports:22,address:0.0.0.0/0 protocol:tcp,ports:80,address:0.0.0.0/0 protocol:tcp,ports:443,address:0.0.0.0/0" \
  --outbound-rules "protocol:tcp,ports:0:65535,address:0.0.0.0/0 protocol:udp,ports:0:65535,address:0.0.0.0/0 protocol:icmp,address:0.0.0.0/0"

# Aplicar firewall por tag
doctl compute firewall add-tags mi-firewall --tag-names web

# Crear Load Balancer
doctl compute load-balancer create \
  --name mi-lb --region nyc1 \
  --forwarding-rules "entry_protocol:tcp,entry_port:80,target_protocol:tcp,target_port:80" \
  --health-check "protocol:tcp,port:80,path:/" \
  --droplet-ids <droplet-1>,<droplet-2>

# Crear registro DNS
doctl compute domain create --domain-name midominio.com
doctl compute domain records create --domain-name midominio.com \
  --record-type A --record-name @ --record-data <ip-del-droplet>

# Crear VPC
doctl compute vpc create --name mi-vpc --region nyc1 --ip-range 10.10.0.0/16
```

---

## Storage

### Spaces (Object Storage)
Almacenamiento de objetos S3-compatible:
- **S3-compatible API**: usar AWS SDK (Node.js, Python, Java, Go) con endpoint de DO
- **CDN integrado**: Spaces + CDN (Pull Zone) para entrega global
- **Sin egress fee**: tráfico dentro del mismo datacenter es gratuito
- **Políticas de CORS**: restricción de orígenes
- **ACLs**: bucket-level y object-level permissions
- **Subida vía CLI**: `s3cmd`, `rclone`, `aws s3` (con endpoint custom)
- **Precio**: $0.02/GB/mes, $0.01/GB de ancho de banda saliente (primer 1 TB gratis en CDN)

### Volumes (Block Storage)
Almacenamiento de bloque montable en droplets:
- **Tamaño**: 1 GB a 16 TB
- **Redundancia**: replicado en el datacenter
- **Montaje**: multi-attach (solo lectura), o single-attach (lectura/escritura)
- **Re-dimensionamiento**: escalar sin downtime
- **Snapshots**: backups puntuales

### Backups y Snapshots
- **Snapshots**: imagen manual del droplet (booteable)
- **Backups**: automáticos semanales (mantiene 4 semanas)
- **Precio Snapshots**: $0.05/GB/mes
- **Precio Backups**: 20% del costo del droplet

```bash
# Crear Space (S3-compatible)
s3cmd --configure
# Access Key, Secret Key, endpoint: nyc3.digitaloceanspaces.com

# Subir archivo a Space
s3cmd put archivo.txt s3://mi-space/

# Usar Spaces con AWS CLI
aws s3 ls s3://mi-space \
  --endpoint https://nyc3.digitaloceanspaces.com

# Crear y montar Volume
doctl compute volume create mi-volumen --region nyc1 --size 100GiB
doctl compute volume attach mi-volumen <droplet-id>
# En el droplet:
# mkfs.ext4 /dev/disk/by-id/scsi-0DO_Volume_mi-volumen
# mkdir /mnt/volumen
# mount /dev/disk/by-id/scsi-0DO_Volume_mi-volumen /mnt/volumen

# Listar snapshots
doctl compute snapshot list

# Crear snapshot desde droplet
doctl compute droplet-action snapshot <droplet-id> --snapshot-name "post-update-v3"
```

---

## Databases (Managed)

### Servicios administrados
- **PostgreSQL**: 11-16, hasta 30 GB RAM, 10 CPUs, 1 TB storage, replicación, HA
- **MySQL**: 8.0, 8.4, hasta 30 GB RAM, 10 CPUs
- **Redis**: 7.x, hasta 32 GB RAM, clustering, persistencia
- **MongoDB**: 7.0, hasta 30 GB RAM
- **Kafka**: 3.6+, administrado con schema registry, hasta 8 partitions, 10 TB storage

### Características compartidas
- **HA (High Availability)**: dos nodos standby con failover automático (sin pérdida de datos)
- **Read-only Nodes**: réplicas de lectura para escalar queries
- **Automatic Backups**: backups diarios con retención 7 días (hasta 30 en Pro)
- **Point-in-time Recovery**: restaurar a cualquier momento en los últimos 7 días
- **Private Networking**: conexión via VPC (tráfico interno gratuito)
- **Connection Pools**: PgBouncer para PostgreSQL
- **Managed Maintenance**: ventanas de mantenimiento configurables
- **Monitoring**: métricas detalladas (QPS, conexiones, caché hit ratio, IOPS)

```bash
# Crear base de datos PostgreSQL
doctl databases create mi-postgres \
  --engine pg --region nyc1 \
  --num-nodes 2 --size db-s-2vcpu-4gb

# Crear base de datos MySQL HA
doctl databases create mi-mysql \
  --engine mysql --region sfo3 \
  --num-nodes 2 --size db-s-4vcpu-8gb

# Listar bases de datos
doctl databases list

# Obtener cadena de conexión
doctl databases connection <db-id>

# Crear réplica de lectura
doctl databases replica create --name replica-1 <db-id>

# Crear base de datos específica dentro del clúster
doctl databases db create <db-id> --db-name midb

# Crear usuario
doctl databases user create <db-id> --name app_user

# Obtener CA certificate
doctl databases ca <db-id>
```

---

## DigitalOcean Kubernetes (DOKS)

Kubernetes administrado con control plane HA gratuito:

### Características
- **Control Plane**: HA multi-master, administrado por DO (sin costo)
- **Node Pools**: pools de droplets (CPU, Memory, GPU)
- **Autoscaling**: cluster autoscaler (escala según demanda de pods)
- **Node Pool Upgrades**: rolling updates con drain/cordon
- **Storage**: CSI Driver para Volumes (block storage) persistente
- **Load Balancer**: integración con DO Load Balancer (Service Type: LoadBalancer)
- **Networking**: VPC nativa, flannel o calico (configurable)
- **Monitoring**: integración con DO Monitoring, Prometheus/Grafana (add-on 1-Click)
- **Node Images**: Ubuntu 20.04/22.04, Rocky Linux, Custom Images

```bash
# Crear clúster DOKS
doctl kubernetes cluster create mi-cluster \
  --region nyc1 --version 1.30 \
  --node-pool "name=web-pool,size=s-2vcpu-4gb,count=3,auto-scale=true,min-nodes=1,max-nodes=10" \
  --node-pool "name=ml-pool,size=gpu-h100x1,count=1"

# Obtener kubeconfig
doctl kubernetes cluster kubeconfig save mi-cluster

# Listar nodos
kubectl get nodes

# Listar node pools
doctl kubernetes cluster node-pool list <cluster-id>

# Escalar node pool manualmente
doctl kubernetes cluster node-pool update <cluster-id> \
  --node-pool-name web-pool --count 5

# Upgrade cluster
doctl kubernetes cluster upgrade mi-cluster --version 1.31

# Crear nodepool con GPU
doctl kubernetes cluster node-pool create <cluster-id> \
  --name gpu-pool --size gpu-h100x1 --count 1
```

---

## App Platform (PaaS)

Plataforma PaaS que despliega desde Git con zero configuración:
- **Static Sites**: HTML/CSS/JS directo (sin build, o con build)
- **Web Services**: contenedores Docker deploy automático
- **Workers**: tareas en segundo plano sin HTTP endpoint
- **Cron Jobs**: jobs scheduleados con sintaxis cron
- **Functions**: FaaS serverless con triggers HTTP, cron, o eventos

### Características
- **Auto-deploy**: push a GitHub/GitLab → deploy automático
- **Preview Deployments**: URLs únicas por PR
- **Autoscaling**: escalado horizontal basado en tráfico
- **SSL**: certificados automáticos (Let's Encrypt)
- **Custom Domains**: con validación DNS
- **Env vars**: separadas por entorno (production, staging, preview)
- **Health Checks**: monitoreo y reinserción automática
- **Deploy Logs**: logs en tiempo real

```bash
# Crear app desde GitHub
doctl apps create --spec app.yaml

# Spec app.yaml mínimo
cat app.yaml
# name: mi-app
# region: nyc
# services:
#   - name: web
#     github:
#       repo: usuario/mi-repo
#       branch: main
#     build_command: npm run build
#     run_command: npm start
#     http_port: 3000
#     instance_size_slug: apps-s-1vcpu-0.25gb
#     instance_count: 1

# Listar apps
doctl apps list

# Ver logs de una app
doctl apps logs <app-id>

# Crear deployment manual
doctl apps create-deployment <app-id>

# Obtener URL de la app
doctl apps get <app-id> --format DefaultIngress
```

---

## Cost Optimization

- **Droplets**: desde $4/mes (s-1vcpu-512mb-10gb) — el más bajo del mercado para VMs
- **Reserved CPUs**: 1 año (30% off), 3 años (50% off) — aplica a cualquier droplet
- **Spaces**: $0.02/GB/mes con CDN gratis primer 1 TB — sin egress fee entre servicios DO
- **Functions**: 1M invocaciones/mes gratis (hasta 10s)
- **Load Balancers**: $12/mes fijo, sin costo por tráfico (solo ancho de banda)
- **Managed Databases**: desde $15/mes (db-s-1vcpu-1gb, 10 GB storage)
- **DOKS cluster**: control plane sin costo, solo pagas droplets
- **Bandwidth**: 1 TB transfer gratis (por droplet de 1 GB RAM), más para droplets más grandes

### Estrategias de ahorro
- Usar **Premium AMD Droplets** (mejor performance/precio que Intel)
- **Reserved CPUs** para cargas predecibles (50% descuento a 3 años)
- **Autoscale** para escalar solo cuando es necesario
- **Snapshot + delete droplet**: apagar VMs que no se usan, restore desde snapshot
- **Spaces + CDN**: hosting estático ultra económico en lugar de droplets web
- **App Platform** para apps pequeñas: desde $5/mes (0.25 GB RAM, auto-scalable)

```bash
# Ver costos estimados (CLI no tiene billing nativo, usar web)
open https://cloud.digitalocean.com/account/billing

# Health checks de droplet (evitar costos de droplet zombie)
doctl compute droplet list --format "ID,Name,Status,Memory,VCPUs,Disk"

# Reservar CPUs
doctl compute reserved-cpu list
doctl compute reserved-cpu create --region nyc1 --size s-2vcpu-4gb
```

---

## Ejemplos CLI Adicionales

```bash
# Listar regiones disponibles
doctl compute region list

# Listar tamaños de droplet disponibles
doctl compute size list

# Listar imágenes disponibles
doctl compute image list --public

# Obtener IP de un droplet
doctl compute droplet get <droplet-id> --format PublicIPv4

# SSH directo a droplet
doctl compute ssh <droplet-id> --ssh-user root

# Ejecutar comando remoto
doctl compute ssh <droplet-id> --ssh-command "uptime; free -m"

# Tagging
doctl compute tag create produccion
doctl compute tag add-resource produccion --resource "droplet:123456"

# Crear API Token
open https://cloud.digitalocean.com/account/api/tokens

# Project Management
doctl projects create --name "WebApp Project" --purpose "Hosting"
doctl projects assign-resources <project-id> --resource "do:droplet:123456"

# Obtener Monitoring Metrics
doctl monitoring metrics get \
  --metric cpu_percent \
  --start $(date -d '1 hour ago' --iso-8601=seconds) \
  --end $(date --iso-8601=seconds) \
  --host <droplet-id>

# Crear CDN endpoint para Space
doctl compute cdn create --origin <space-origin> --ttl 3600
doctl compute cdn flush <cdn-id> --files "/*"

# Crear Action Registry (Container Registry)
doctl registry create mi-registry --region nyc3
doctl registry login
docker tag mi-app:latest registry.digitalocean.com/mi-registry/mi-app:v1
docker push registry.digitalocean.com/mi-registry/mi-app:v1
```
