# Google Cloud Platform (GCP)

## Servicios Principales

GCP es la plataforma cloud de Google, construida sobre la misma infraestructura que Google Search, YouTube y Gmail. Destaca en data analytics, machine learning y Kubernetes.

| Categoría | Servicios Clave |
|-----------|----------------|
| Cómputo | Compute Engine, Google Kubernetes Engine (GKE), Cloud Run, App Engine, Bare Metal Solution, Batch, VMware Engine |
| Almacenamiento | Cloud Storage, Persistent Disk, Filestore, Local SSD, Cloud Storage for Firebase |
| Bases de Datos | Cloud SQL, Cloud Spanner, Bigtable, Firestore, Memorystore, BigQuery, AlloyDB |
| Red | VPC, Cloud CDN, Cloud Load Balancing, Cloud Armor, Cloud NAT, Private Google Access, Cloud Interconnect, Cloud VPN, Cloud DNS |
| Seguridad | Cloud IAM, Cloud KMS, Security Command Center, Binary Authorization, Cloud HSM, BeyondCorp, Access Transparency, VPC Service Controls |
| Serverless | Cloud Functions, Cloud Run, Eventarc, Workflows, Pub/Sub, Cloud Scheduler, Cloud Tasks, Apigee API Management |
| IA/ML | Vertex AI, Gemini, Cloud TPU, Document AI, Translation AI, Speech-to-Text, Vision AI, Natural Language AI, Dialogflow |
| DevOps | Cloud Build, Cloud Deploy, Artifact Registry, Cloud Code, Cloud Monitoring, Cloud Logging, Error Reporting, Service Mesh (Anthos) |

---

## IAM (Cloud Identity & Access Management)

GCP utiliza IAM con tres componentes clave: *who* (principal), *can do what* (role), *on which resource* (resource).

### Conceptos fundamentales
- **Principals**: cuentas de Google, cuentas de servicio, grupos de Google, dominios, cuentas de Google Workspace, identidades federadas (Workforce Identity Federation) o identidades de workload (Workload Identity Federation)
- **Roles**: básicos (owner/editor/viewer), predefinidos (granulares y administrados por Google), personalizados (custom roles con permisos específicos)
- **Resource hierarchy**: organización > carpetas > proyectos > recursos (herencia de políticas hacia abajo)
- **Service Accounts**: identidades no humanas para autenticación entre servicios (credenciales JSON o workload identity federation)
- **Conditions**: políticas condicionales basadas en atributos (IP, hora, recurso, etc.)
- **Audit Logs**: registro de quién hizo qué, dónde y cuándo (Admin Read, Data Read, Data Write)

### Política IAM (JSON)
```json
{
  "bindings": [
    {
      "role": "roles/storage.objectViewer",
      "members": [
        "user:admin@example.com",
        "serviceAccount:sa-name@project.iam.gserviceaccount.com"
      ],
      "condition": {
        "title": "acceso_solo_laboral",
        "expression": "request.time.getHours(\"America/Lima\") >= 9 && request.time.getHours(\"America/Lima\") <= 18"
      }
    }
  ]
}
```

### Ejemplos CLI (gcloud)
```bash
# Configurar proyecto por defecto
gcloud config set project mi-proyecto-123

# Crear cuenta de servicio
gcloud iam service-accounts create sa-backup \
  --display-name "Service Account for Backups"

# Asignar rol a cuenta de servicio
gcloud projects add-iam-policy-binding mi-proyecto-123 \
  --member serviceAccount:sa-backup@mi-proyecto-123.iam.gserviceaccount.com \
  --role roles/storage.admin

# Generar y descargar key JSON
gcloud iam service-accounts keys create sa-key.json \
  --iam-account sa-backup@mi-proyecto-123.iam.gserviceaccount.com

# Listar miembros con roles en el proyecto
gcloud projects get-iam-policy mi-proyecto-123 \
  --flatten="bindings[].members" --format="table(bindings.role,bindings.members)"
```

---

## Networking

### Virtual Private Cloud (VPC)
Red global por defecto (no regional como AWS/Azure). Características clave:

- **VPC Global**: una VPC puede abarcar todas las regiones del mundo con subnets regionales
- **Subnets**: regionales (auto-mode: `/20` por región; custom-mode: control total CIDR)
- **VPC Peering**: conexión directa entre VPCs (misma o diferentes organizaciones)
- **Shared VPC**: comparte subnets de un proyecto host a proyectos de servicio
- **Cloud NAT**: NAT saliente para instancias sin IP pública
- **Cloud Router**: intercambio dinámico de rutas BGP con on-premises
- **Cloud VPN**: IPSec site-to-site (HA VPN con 99.99% SLA si 2 túneles)
- **Cloud Interconnect**: conexión dedicada (Dedicated Interconnect 10/100 Gbps) o Partner Interconnect
- **Private Google Access**: acceso a APIs de Google desde instancias sin IP pública

### Cloud Load Balancing
Balanceo de carga global, multi-región, multi-protocolo:
- **External HTTP(S) LB**: capa 7 global, integrado con Cloud Armor (WAF), Cloud CDN
- **External TCP/UDP LB**: capa 4, forwarding rules con protocolos SSL/TCP/UDP
- **Internal HTTP(S) LB**: balanceo interno capa 7
- **Internal TCP/UDP LB**: balanceo interno capa 4
- **SSL Proxy**: terminación SSL global (TLS 1.3, HTTPS, certificados administrados)
- **Network LB**: balanceo regional de alto rendimiento (capa 4, direct server return)

### Cloud Armor
WAF y DDoS protection:
- Reglas de seguridad preconfiguradas (OWASP Top 10, CVE específicos)
- Rate limiting, IP blacklist/whitelist
- Geo-based access control
- Adaptive Protection: detección de ataques DDoS mediante ML

### Cloud CDN
CDN global con caché en edge locations de Google (2000+ PoPs):
- Soportado por HTTP(S) Load Balancer
- Cache modes: static (forzar cache), dynamic (sin cache)
- Signed URLs, Signed Cookies para contenido restringido

```bash
# Crear VPC custom-mode
gcloud compute networks create mi-vpc --subnet-mode custom

# Crear subnet
gcloud compute networks subnets create subnet-a \
  --network mi-vpc --range 10.0.1.0/24 --region us-east1

# Crear regla de firewall
gcloud compute firewall-rules create allow-http \
  --network mi-vpc --allow tcp:80 --source-ranges 0.0.0.0/0

# Crear Cloud NAT
gcloud compute routers nats create mi-nat \
  --router mi-router --region us-east1 \
  --nat-external-ip-pool-ips nat-ip-1 --nat-all-subnet-ip-ranges
```

---

## Compute

### Compute Engine
Máquinas virtuales con familias:
- **General-purpose**: N2, N2D (AMD), N1, C3, E2 (precios flexibles)
- **Compute-optimized**: C2, C2D, C3 (altas frecuencias, Intel Xeon Scalable)
- **Memory-optimized**: M1, M2, M3 (hasta 12 TB de memoria)
- **Accelerator-optimized**: G2 (NVIDIA L4), A2 (NVIDIA A100), A3 (NVIDIA H100)
- **Sole-tenant nodes**: servidores físicos dedicados para cumplimiento/licencias
- **Confidential VMs**: memoria cifrada con AMD SEV-ES

### Características Compute Engine
- **Sole Tenant**: dedicación física completa
- **Reservations**: capacidad reservada (on-demand, anual o de 3 años)
- **Instance Templates + Managed Instance Groups**: escalado automático (autoscaling, rolling updates, canary deployments)
- **Shielded VMs**: TPM virtual, integridad del boot, Secure Boot
- **GPUs**: NVIDIA L4, A100, H100, P4, T4, V100
- **TPUs**: Tensor Processing Units para ML (disponibles directo desde Compute Engine)
- **Live Migration**: migración en caliente de VMs sin reinicio durante mantenimiento
- **Preemptible VMs**: hasta 80% descuento, máx 24h, interrumpibles
- **Spot VMs**: evolución de preemptible (sin duración máxima, precio dinámico)

### Google Kubernetes Engine (GKE)
Kubernetes administrado con:
- **Autopilot vs Standard**: Autopilot (sin nodos visibles, paga por pods), Standard (control total)
- **Node Auto-Provisioning (NAP)**: GKE crea nodos automáticamente según necesidades
- **GKE Autopilot**: escalado a cero, worker nodes invisibles, precios por recurso solicitado
- **GKE Enterprise**: Anthos, multi-cluster, multi-cloud (AWS, Azure), Service Mesh, Config Sync
- **GKE Sandbox**: contenedores con seguridad mejorada mediante gVisor
- **Workload Identity**: autenticación K8s ↔ Google Cloud sin keys

```bash
# Crear VM (con IP efímera)
gcloud compute instances create mi-vm \
  --zone us-east1-b --machine-type e2-medium \
  --image-family ubuntu-2204-lts --image-project ubuntu-os-cloud

# SSH a la VM
gcloud compute ssh mi-vm --zone us-east1-b

# Crear Managed Instance Group
gcloud compute instance-groups managed create mi-mig \
  --zone us-east1-b --template mi-template --size 3

# Autoscaling
gcloud compute instance-groups managed set-autoscaling mi-mig \
  --zone us-east1-b --max-num-replicas 10 \
  --target-cpu-utilization 0.75

# Crear cluster GKE Autopilot
gcloud container clusters create-auto mi-cluster \
  --region us-east1 --release-channel regular
```

---

## Storage

### Cloud Storage (GCS)
Almacenamiento de objetos unificado con una API consistente. Clases:

| Clase | Nombre mínimo | Costo | Caso de uso |
|-------|--------------|-------|-------------|
| Standard | Ninguno | Alto | Datos activos, analytics |
| Nearline | 30 días | Medio | Backup mensual, datos accedidos <1 vez/mes |
| Coldline | 90 días | Bajo | DR, datos accedidos <1 vez/trimestre |
| Archive | 365 días | Muy bajo | Archivo legal, compliance |

- **Uniform vs Fine-grained access**: IAM uniforme vs ACLs por objeto
- **Object Lifecycle Management**: transición y eliminación automática
- **Object Versioning**: versiones de objetos (historial)
- **Retention Policies**: retención legal y por bucket
- **Signed URLs y Signed Policy Documents**: acceso temporal sin autenticación
- **Transfer Service**: migración desde AWS S3, Azure Blob, HTTP, on-premises
- **Pub/Sub Notifications**: eventos en Cloud Storage → Pub/Sub

### Persistent Disk
Discos de bloque para Compute Engine:
- **pd-standard**: HDD, económico
- **pd-balanced**: SSD balanceado (hasta 100K IOPS)
- **pd-ssd**: SSD (hasta 100K IOPS)
- **pd-extreme**: SSD de alto rendimiento (hasta 300K IOPS, configurable)
- **Hyperdisk**: nueva generación (Hyperdisk Extreme, Throughput, Balanced, ML)

### Filestore
NAS administrado compatible con NFS v3/v4.1 (capacidades hasta 100 TB, throughput hasta 10 GB/s)

```bash
# Crear bucket estándar
gcloud storage buckets create gs://mi-bucket-unico \
  --location us-east1 --default-storage-class STANDARD \
  --uniform-bucket-level-access

# Copiar archivo a GCS
gcloud storage cp archivo.txt gs://mi-bucket-unico/

# Sincronizar directorio
gcloud storage rsync ./carpeta gs://mi-bucket-unico/carpeta --recursive

# Firmar URL (expira en 1h)
gcloud storage sign-url gs://mi-bucket-unico/archivo.txt --duration 3600

# Configurar lifecycle
gcloud storage buckets update gs://mi-bucket-unico \
  --lifecycle-file=lifecycle.json
```

---

## Bases de Datos

### Cloud SQL
Bases de datos relacionales administradas: MySQL, PostgreSQL, SQL Server.
- **Alta disponibilidad**: failover automático a otra zona (regional)
- **Read replicas**: hasta 10 réplicas de lectura (cross-region soportado)
- **Automated backups**: point-in-time recovery, exportación a GCS
- **Private IP**: conexión a través de VPC
- **Cloud SQL Proxy**: conexión segura sin autorizar IPs
- **Vertex AI Integration**: consultar LLMs y modelos desde SQL (solo Postgres)

### Cloud Spanner
Base de datos relacional globalmente distribuida con consistencia externa fuerte:
- **Escalado horizontal**: de 1 a miles de nodos, hasta petabytes
- **Consistencia**: ACID en múltiples regiones (TrueTime de Google)
- **SQL**: ANSI 2011 con extensiones para datos geoespaciales y arrays
- **Automatic sharding**: sin particionamiento manual
- **Multi-region configs**: nam3 (us-east1/us-west1/us-central1), eur3, etc.
- **Caso de uso**: finanzas globales, carritos de compra, catálogos, gaming

### Bigtable
Base de datos NoSQL ancha (wide-column) basada en HBase:
- **Latencia**: <10ms (optimizado para altísimo throughput, >1M ops/s por clúster)
- **Escalado**: hasta miles de nodos, petabyte-scale
- **Casos de uso**: métricas de tiempo real, IoT, ad-tech, recomendaciones
- **Integración con**: BigQuery (lectura directa), Dataflow, Hadoop, HBase client, Apache Spark

### Firestore (Datastore next-gen)
Base de datos NoSQL documental, serverless, automáticamente escalable:
- **Modos**: Native (Firestore API) y Datastore (backward compatible)
- **Queries**: índices compuestos, colecciones/subcolecciones, transacciones ACID
- **Realtime listeners**: actualizaciones en tiempo real (ideal para apps móviles/web)
- **Offline persistence**: funciona offline y sincroniza al reconectar

### BigQuery
Data warehouse serverless con SQL estándar y motor de ejecución distribuido:
- **Separación cómputo-almacenamiento**: paga por almacenamiento y por queries (on-demand o flat-rate)
- **Particionamiento**: por fecha, entero, timestamp (mejora rendimiento y reduce costo)
- **Clustering**: ordenamiento físico dentro de las particiones
- **Materialized Views**: vistas precomputadas automáticamente
- **BigQuery Omni**: queries sobre datos en AWS Azure, GCS
- **ML en SQL**: crear y ejecutar modelos de ML directamente con SQL
- **BI Engine**: aceleración en memoria para dashboards

```bash
# Crear Cloud SQL (PostgreSQL)
gcloud sql instances create mi-postgres \
  --database-version POSTGRES_15 --cpu 2 --memory 7680MB \
  --region us-east1 --availability-type ZONAL

# Crear base de datos en Cloud SQL
gcloud sql databases create midb --instance mi-postgres

# Crear tabla en BigQuery desde CSV en GCS
bq load --source_format=CSV --autodetect \
  midataset.mitabla gs://mi-bucket/datos.csv

# Correr query en BigQuery
bq query --use_legacy_sql=false 'SELECT column1, COUNT(*) as cnt FROM midataset.mitabla GROUP BY column1'
```

---

## Serverless

### Cloud Functions
Compute serverless basado en eventos (FaaS):
- **2ª generación**: basada en Cloud Run, más escalable y potente
- **Eventos**: Cloud Storage, Pub/Sub, HTTP, Firestore, Firebase, Eventarc
- **Runtimes**: Node.js, Python, Go, Java, .NET, Ruby, PHP
- **Timeout**: 9 min (1ª gen), 60 min (2ª gen / Cloud Run)
- **Concurrency**: 1 por instancia (1ª gen), hasta 1000 (Cloud Run)

### Cloud Run
Compute serverless basado en contenedores:
- **Containerizado**: cualquier runtime o framework (Dockerfile o Buildpacks)
- **Escalado a cero**: sin costo cuando no hay tráfico
- **Escalado automático**: hasta N contenedores por defecto (congurable)
- **Concurrency**: múltiples requests por contenedor (hasta 250)
- **Solicitudes largas**: hasta 60 minutos
- **VPC connectivity**: acceso a recursos de VPC mediante VPC Connector
- **Managed SSL**: certificados TLS automáticos, dominios personalizados
- **Cloud Run jobs**: tareas batch (map/reduce, ETL, backups)

### Eventarc
Enrutamiento de eventos hacia Cloud Functions, Cloud Run, Workflows, GKE
- **Event filters**: filtrado por tipo de evento, servicio, método, recurso
- **Channels**: ingesta de eventos personalizados desde aplicaciones propias

### Workflows
Orquestación serverless de servicios HTTP y APIs de GCP
- **Formato YAML/JSON**: flujos con pasos, ramas, subworkflows, paralelismo
- **Integración directa**: 100+ servicios GCP sin SDK
- **Timeouts**: hasta 12 meses (workflows de larga duración)

### Pub/Sub
Mensajería asíncrona escalable:
- **PUSH (webhook)**: entrega a HTTP endpoints, Cloud Functions, Cloud Run
- **PULL**: consumidores tradicionales (streaming pull o synchronous pull)
- **Exactly-once delivery**: disponible para suscripciones push/pull
- **Dead Letter Topics**: almacenamiento de mensajes no procesables
- **Schema Registry**: validación de esquemas (Avro, Protocol Buffers)
- **Ordering keys**: entrega ordenada por clave

```bash
# Desplegar función Cloud Function (2ª gen)
gcloud functions deploy mi-funcion \
  --gen2 --runtime python312 --trigger-http \
  --entry-point handler --source . --region us-east1 \
  --allow-unauthenticated

# Desplegar en Cloud Run
gcloud run deploy mi-servicio \
  --image gcr.io/mi-proyecto/mi-imagen:latest \
  --region us-east1 --platform managed --allow-unauthenticated

# Crear topic Pub/Sub y suscripción
gcloud pubsub topics create mi-topic
gcloud pubsub subscriptions create mi-sub --topic mi-topic \
  --ack-deadline 60 --push-endpoint https://mi-servicio-xxx.a.run.app/push
```

---

## Cost Optimization

### Compute
- **Committed Use Discounts (CUD)**: 1 o 3 años (vCPU + memoria), hasta 70% descuento
- **Sustained Use Discounts**: descuento automático por uso continuo (>25% del mes)
- **Preemptible/Spot VMs**: hasta 80-91% descuento (interrumpibles)
- **E2 machine series**: hasta 31% más barato que N1 (presupuesto ajustable)
- **GKE Autopilot**: paga por pods en lugar de nodos enteros

### Storage
- **Nearline, Coldline, Archive**: reducir costo de almacenamiento según frecuencia
- **Object Lifecycle Management**: transición automática a clases más económicas
- **Requester Pays**: el solicitante paga por descarga (servicios compartidos)

### Database
- **BigQuery flat-rate vs on-demand**: on-demand ($5/TB) vs slots reservados (predecible)
- **Cloud SQL Committed Use Discounts**: descuentos por 1 o 3 años
- **Cloud Spanner CUD**: descuentos por capacidad comprometida

### Monitoreo y herramientas
- **Google Cloud Pricing Calculator**: estimación de costos
- **Billing Reports**: desglose por proyecto, servicio, SKU
- **Budget Alerts**: notificaciones cuando se excede un umbral
- **Recommender**: recomendaciones de optimización (tamaño de VM, idle resources, CUD)

```bash
# Crear alerta de presupuesto
gcloud billing budgets create \
  --billing-account=XXXXXX-YYYYYY-ZZZZZZ \
  --display-name="Mi Budget" --budget-amount=1000 \
  --threshold-rule=percent=50 \
  --threshold-rule=percent=90 \
  --threshold-rule=percent=100

# Obtener recomendaciones de Compute
gcloud recommender recommendations list \
  --project=mi-proyecto-123 \
  --recommender=google.compute.instance.MachineTypeRecommender \
  --location=us-east1

# Listar precios de GPUs
gcloud compute accelerator-types list

# Ver costos por etiqueta
gcloud billing projects describe mi-proyecto-123
```

---

## Ejemplos CLI Adicionales

```bash
# Autenticación
gcloud auth login
gcloud auth application-default login

# Configurar múltiples configuraciones
gcloud config configurations create produccion
gcloud config set project proyecto-produccion
gcloud config set compute/region us-east1
gcloud config set compute/zone us-east1-b

# Listar todos los recursos
gcloud asset search-all-resources --scope projects/123456

# IAM: testear permisos
gcloud iam simulate-principal-access \
  --member="user:test@example.com" \
  --permissions="compute.instances.create,storage.buckets.list"

# KMS: cifrar con Cloud KMS
gcloud kms keyrings create mi-keyring --location global
gcloud kms keys create mi-key --location global \
  --keyring mi-keyring --purpose encryption
echo "datos secretos" | gcloud kms encrypt \
  --location global --keyring mi-keyring --key mi-key \
  --plaintext-file - --ciphertext-file datos-cifrados.bin

# Cloud Build: construir y desplegar
gcloud builds submit --tag gcr.io/mi-proyecto/mi-app
gcloud run deploy mi-app --image gcr.io/mi-proyecto/mi-app \
  --platform managed --region us-east1

# Deployment Manager (GCP IaC)
gcloud deployment-manager deployments create mi-despliegue \
  --config config.yaml

# Logging: ver logs de auditoría
gcloud logging read "protoPayload.methodName=google.compute.instances.insert" \
  --project mi-proyecto-123 --limit 10

# Cloud Source Repos
gcloud source repos create mi-repo

# Listar IPs públicas de VMs
gcloud compute instances list --format="value(name,networkInterfaces[0].accessConfigs[0].natIP)"
```
