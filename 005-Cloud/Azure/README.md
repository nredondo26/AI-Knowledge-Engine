# Microsoft Azure

## Servicios Principales

Azure es la plataforma cloud de Microsoft con más de 200 servicios integrados con el ecosistema Microsoft (Active Directory, SQL Server, .NET, Visual Studio).

| Categoría | Servicios Clave |
|-----------|----------------|
| Cómputo | Azure VMs, Virtual Machine Scale Sets, Azure Kubernetes Service (AKS), Container Instances, Azure Batch, Azure Functions, App Service, Azure Spring Apps |
| Almacenamiento | Blob Storage, Disk Storage, Azure Files, Azure NetApp Files, Archive Storage, Data Lake Storage Gen2 |
| Bases de Datos | Azure SQL Database, Cosmos DB, Azure Database for MySQL/PostgreSQL/MariaDB, Azure Cache for Redis, Azure SQL Managed Instance, Azure Synapse Analytics |
| Red | Virtual Network (VNet), Load Balancer, Application Gateway, Azure CDN, Azure Front Door, Traffic Manager, VPN Gateway, ExpressRoute, Azure DNS |
| Seguridad | Microsoft Entra ID (Azure AD), Key Vault, Defender for Cloud, Sentinel (SIEM), Azure Policy, RBAC, Managed Identities, Privileged Identity Management |
| Serverless | Azure Functions, Logic Apps, Event Grid, Service Bus, Event Hubs, API Management, Durable Functions, Azure Container Apps |
| IA/ML | Azure AI, Azure Machine Learning, OpenAI Service, Cognitive Services, Bot Service, Azure Search |
| DevOps | Azure DevOps, GitHub Actions, Azure Pipelines, Bicep, ARM Templates, Azure Monitor, Application Insights |

---

## IAM (Microsoft Entra ID / Azure RBAC)

Azure utiliza **Microsoft Entra ID** (anteriormente Azure AD) para identidad y **Role-Based Access Control (RBAC)** para autorización.

### Principios fundamentales
- **Microsoft Entra ID**: directorio multi-tenant que proporciona autenticación y autorización
- **RBAC**: control de acceso granular basado en roles asignados a usuarios, grupos, service principals o managed identities
- **Managed Identities**: identidades administradas automáticamente por Azure para autenticación entre servicios
- **Azure Policy**: gobierno y cumplimiento con reglas que evalúan y corrigen recursos
- **Privileged Identity Management (PIM)**: acceso JIT (Just-In-Time) con aprobación y auditoría

### Estructura de RBAC
```json
{
  "id": "/subscriptions/{sub-id}/providers/Microsoft.Authorization/roleAssignments/...",
  "properties": {
    "principalId": "xxx-xxx-xxx",
    "roleDefinitionId": "/subscriptions/{sub-id}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
    "scope": "/subscriptions/{sub-id}/resourceGroups/mi-rg"
  }
}
```

### Ejemplos CLI
```bash
# Login en Azure
az login

# Crear grupo de recursos
az group create --name mi-rg --location eastus

# Crear service principal
az ad sp create-for-rbac --name mi-sp --role Contributor

# Asignar rol RBAC
az role assignment create --assignee xxx-xxx-xxx \
  --role "Contributor" --resource-group mi-rg

# Listar roles disponibles
az role definition list --output table

# Policy: denegar recursos sin tags
az policy assignment create --name "deny-without-tag" \
  --policy "d81c3891-3683-4626-a2e2-0c2b3e4f6e7a" \
  --params '{"tagName": {"value": "environment"}}'
```

---

## Networking

### Virtual Network (VNet)
Red virtual aislada. Componentes clave:

- **Subnets**: división lógica de la VNet; cada subnet puede tener delegación de servicios
- **Network Security Groups (NSG)**: firewall distribuido stateful (reglas allow/deny por prioridad)
- **Application Security Groups (ASG)**: agrupación lógica de VMs por carga de trabajo
- **Azure Load Balancer**: balanceo de capa 4 (público/interno)
- **Application Gateway**: balanceo de capa 7 con WAF integrado
- **Azure Front Door**: CDN y balanceo global con aceleración Anycast
- **VPN Gateway**: conexión site-to-site y point-to-site con IPSec/IKE
- **ExpressRoute**: conexión dedicada privada desde on-premises a Azure
- **Azure Firewall**: firewall administrado con filtrado de capa 3-7, threat intelligence
- **Azure DNS**: hosting de dominios DNS con resolución privada

### Network Watcher
Suite de monitoreo de red:
- **Topology**: visualización gráfica de la topología de red
- **IP Flow Verify**: verifica si el tráfico está permitido o denegado
- **NSG Diagnostics**: logs de flujo de NSG para análisis de tráfico
- **Connection Monitor**: monitoreo de conectividad entre VMs y on-premises
- **Packet Capture**: captura de paquetes en VMs Linux/Windows

```bash
# Crear VNet y subnet
az network vnet create --name mi-vnet --resource-group mi-rg \
  --address-prefix 10.0.0.0/16 --subnet-name mi-subnet \
  --subnet-prefix 10.0.1.0/24

# Crear NSG con regla
az network nsg create --name mi-nsg --resource-group mi-rg
az network nsg rule create --nsg-name mi-nsg -g mi-rg \
  --name AllowHTTP --protocol tcp --priority 100 \
  --destination-port-ranges 80 --access allow

# Crear Application Gateway
az network application-gateway create --name mi-appgw \
  --resource-group mi-rg --sku WAF_v2 --capacity 2 \
  --vnet-name mi-vnet --subnet appgw-subnet \
  --frontend-port 80 --http-settings-port 80
```

---

## Compute

### Azure Virtual Machines
Máquinas virtuales con familias variadas:
- **General purpose**: B-series (burstable), Dv5, Dasv5, DC-series
- **Compute optimized**: F-series, FX-series (altas frecuencias)
- **Memory optimized**: E-series, Esv5, M-series, Mv2
- **Storage optimized**: Lsv3, Lasv3 (alto throughput NVMe)
- **GPU**: NCas T4 v3, ND A100 v4, NVv4 (NVIDIA A100, AMD Radeon Instinct)
- **Confidential Computing**: DCasv5, ECasv5 (encrypted memory con Intel SGX/AMD SEV-SNP)

### Virtual Machine Scale Sets (VMSS)
Grupos idénticos de VMs con escalado automático:
- **Manual, scheduled, autoscale basado en métricas**
- **Upgrade policies**: Automatic, Rolling, Manual
- **Orchestration mode**: Uniform (clásico) o Flexible (orquestación con VMs estándar)
- **Autorepair**: reemplazo automático de VMs no saludables

### Azure Kubernetes Service (AKS)
Kubernetes administrado:
- **Managed control plane**: API server, etcd, scheduler administrados
- **Node pools**: system (core) y user (workloads)
- **Virtual Nodes**: pods serverless con ACI (Container Instances)
- **Azure CNI vs Kubenet**: opciones de red para pods
- **Azure Policy for AKS**: gatekeeper/OPA integrado

```bash
# Crear VM
az vm create --name mi-vm --resource-group mi-rg \
  --image UbuntuLTS --size Standard_D2s_v3 \
  --admin-username azureuser --generate-ssh-keys

# Escalar VMSS
az vmss scale --name mi-vmss --resource-group mi-rg --new-capacity 5

# Crear clúster AKS
az aks create --name mi-aks --resource-group mi-rg \
  --node-count 3 --node-vm-size Standard_DS3_v2 \
  --enable-cluster-autoscaler --min-count 1 --max-count 10
```

---

## Storage

### Azure Blob Storage
Almacenamiento de objetos (equivalente a S3). Capas de acceso:

| Capa | Frecuencia | Costo almacenamiento | Costo acceso |
|------|-----------|---------------------|-------------|
| Hot | Alta | Alto | Bajo |
| Cool | Baja (~30 días) | Medio | Medio |
| Cold | Muy baja (~90 días) | Bajo | Alto |
| Archive | Archivado (>180 días) | Muy bajo | Muy alto |

- **Redundancia**: LRS, ZRS, GRS, RA-GRS, GZRS, RA-GZRS
- **Data Lake Storage Gen2**: sistema de archivos jerárquico sobre Blob Storage (HNS)

### Azure Files
Compartidos de archivos SMB y NFS administrados.
- SMB 3.0 con cifrado en tránsito
- Azure File Sync: sincronización con on-premises Windows Server
- Premium shares: latencia <1ms con SSD

### Azure Disk Storage
Discos administrados para VMs:
- **Ultra Disk**: <1ms latencia, hasta 300K IOPS (IOPS independiente del tamaño)
- **Premium SSD v2**: hasta 80K IOPS, 1200 MB/s
- **Premium SSD**: balance rendimiento/costo
- **Standard SSD**: costo moderado, cargas de baja latencia
- **Standard HDD**: mínimo costo, cargas secuenciales

```bash
# Crear cuenta de almacenamiento
az storage account create --name mistorageabc123 \
  --resource-group mi-rg --location eastus \
  --sku Standard_GRS --kind StorageV2 \
  --hierarchical-namespace true

# Subir blob
az storage blob upload --account-name mistorageabc123 \
  --container-name micontenedor --name archivo.txt \
  --file ./archivo.txt --auth-mode key

# Administrar política de ciclo de vida
az storage account management-policy create \
  --account-name mistorageabc123 --resource-group mi-rg \
  --policy @policy.json
```

---

## Bases de Datos

### Azure SQL Database
Base de datos relacional como servicio (SQL Server engine):
- **DTU vs vCore**: modelos de compra (DTU: predefinido; vCore: elástico)
- **Serverless**: compute auto-pausa cuando inactivo
- **Hyperscale**: hasta 100 TB con escalado de lectura
- **Elastic Pools**: compartición de recursos entre múltiples DBs
- **Geo-Replication**: replicación a otra región para DR
- **Ledger**: blockchain-style, transacciones inmutables con criptografía

### Azure Cosmos DB
Base de datos NoSQL multi-modelo distribuida globalmente:
- **APIs**: SQL (Core), MongoDB, Cassandra, Gremlin (graph), Table
- **Distribución global**: agregar/quitar regiones con un clic, failover automático
- **Consistency levels**: Strong, Bounded Staleness, Session, Consistent Prefix, Eventual
- **RU/s (Request Units)**: throughput provisionado o autoescalable
- **Multi-region writes**: escritura en cualquier región con resolución de conflictos

### Azure Cache for Redis
Caché en memoria basada en Redis (open-source y Redis Enterprise):
- Basic (1 nodo, no SLA), Standard (2 nodos replicados, 99.9%), Premium (clustering, persistencia)
- Redis 6.x/7.x compatible: modules RediSearch, RedisBloom, RedisTimeSeries
- Private link, VNet injection, geo-replication

```bash
# Crear Azure SQL Database
az sql server create --name mi-sql-server --resource-group mi-rg \
  --admin-user adminuser --admin-password "Compleja$123"

az sql db create --name midb --server mi-sql-server \
  --resource-group mi-rg --service-objective S2

# Crear Cosmos DB (API SQL)
az cosmosdb create --name mi-cosmos --resource-group mi-rg \
  --locations regionName=eastus failoverPriority=0 isZoneRedundant=false \
  --default-consistency-level Session
```

---

## Serverless

### Azure Functions
Compute serverless basado en eventos:
- **Planes**: Consumption (paga por ejecución), Premium (pre-warmed, no timeout), Dedicated (App Service)
- **Triggers**: HTTP, Timer, Blob/Queue/Table Storage, Event Grid, Service Bus, Event Hubs, Cosmos DB, Kafka
- **Bindings**: entrada/salida declarativas a servicios Azure (sin código de conexión)
- **Durable Functions**: orquestación de workflows con patrones (chaining, fan-out/fan-in, human interaction)
- **Runtimes**: .NET, Java, Node.js, Python, PowerShell, TypeScript, Custom handlers
- **Managed Identity**: autenticación sin secrets contra Key Vault, SQL, Storage, etc.

### Logic Apps
Workflows visuales (diseñador low-code) con +400 conectores:
- **Triggers**: HTTP, recurrencia, cuando se crea un blob, etc.
- **Actions**: transformaciones, condicionales, bucles, paralelismo
- **Enterprise Integration Pack**: EDI, XML, AS2, B2B
- **Integration Service Environment (ISE)**: ejecución en VNet dedicada

### Azure Event Grid
Enrutamiento de eventos pub/sub con alto throughput:
- **Topics**: system topics (eventos Azure) y custom topics (eventos propios)
- **Event Subscriptions**: filtros por tipo de evento, subject, advanced filters
- **Dead-lettering**: almacenamiento de eventos no entregados
- **Retry policy**: automática con backoff exponencial

```bash
# Crear Function App
az functionapp create --name mi-funcion-app --resource-group mi-rg \
  --storage-account mistorageabc123 --consumption-plan-location eastus \
  --runtime python --runtime-version 3.11 --functions-version 4

# Crear Event Grid topic
az eventgrid topic create --name mi-topic --resource-group mi-rg \
  --location eastus

az eventgrid event-subscription create --name mi-sub \
  --source-resource-id /subscriptions/xxx/resourceGroups/mi-rg/providers/Microsoft.EventGrid/topics/mi-topic \
  --endpoint https://mi-funcion-app.azurewebsites.net/api/handler
```

---

## Cost Optimization

### Azure Cost Management + Billing
Suite de herramientas para monitoreo y optimización de costos.

### Compute
- **Azure Reserved VM Instances**: 1 o 3 años, ahorro 40-72% vs pay-as-you-go
- **Azure Savings Plan**: flexible entre servicios, ahorro hasta 65%
- **Spot VMs**: hasta 90% descuento para workloads interrumpibles
- **Azure Hybrid Benefit**: usar licencias Windows Server/SQL Server on-premises en Azure
- **B-series VMs (Burstable)**: créditos de CPU para cargas irregulares
- **Auto-shutdown**: apagado automático de VMs según horario

### Storage
- **Access Tiers**: mover datos a Cool, Cold o Archive automáticamente
- **Lifecycle Management**: políticas de transición y eliminación
- **Reserved capacity**: Blob Storage con descuento por reserva (1 o 3 años)

### Database
- **Azure SQL Elastic Pool**: compartición de recursos entre DBs
- **Cosmos DB Reserved Capacity**: descuento hasta 65%
- **Auto-pause (SQL Serverless)**: pausa automática cuando no hay actividad

### Monitoreo y alertas
- **Azure Budgets**: alertas de presupuesto por suscripción/grupo de recursos
- **Advisor recommendations**: recomendaciones de optimización de costos, seguridad y rendimiento
- **Azure Cost Analysis**: desglose por servicio, recurso, tag, ubicación

```bash
# Crear presupuesto
az consumption budget create --budget-name mi-budget \
  --amount 1000 --time-grain monthly \
  --start-date 2026-01-01 --end-date 2026-12-31 \
  --category cost --scope /subscriptions/xxx

# Obtener recomendaciones de Azure Advisor
az advisor recommendation list --query "[?category=='Cost']" --output table

# Etiquetar recursos para cost tracking
az tag create --resource-id /subscriptions/xxx/resourceGroups/mi-rg \
  --tags Environment=Production Project=WebApp

# Listar Spot VM precios
az vm list-skus --size Standard_D2s_v3 --output table
```

---

## Ejemplos CLI Adicionales

```bash
# Iniciar sesión con tenant específico
az login --tenant mytenant.onmicrosoft.com

# Establecer suscripción por defecto
az account set --subscription "nombre-suscripcion"

# Listar todos los recursos en un grupo
az resource list --resource-group mi-rg --output table

# Desplegar con ARM template
az deployment group create --resource-group mi-rg \
  --template-file template.json --parameters @params.json

# Desplegar con Bicep
az deployment group create --resource-group mi-rg \
  --template-file main.bicep

# Ejecutar script en VM con Run Command
az vm run-command invoke --resource-group mi-rg \
  --name mi-vm --command-id RunShellScript \
  --scripts 'echo "Hello from Azure"'

# Ver logs de Application Insights
az monitor app-insights query --app mi-app-insights \
  --analytics-query "requests | where timestamp > ago(1h) | count"

# Crear Azure Container Instance
az container create --name mi-container \
  --resource-group mi-rg --image nginx:latest \
  --dns-name-label mi-contenedor-demo --ports 80

# ACR: login y push Docker
az acr login --name micontainerregistry
docker tag mi-app:latest micontainerregistry.azurecr.io/mi-app:v1
docker push micontainerregistry.azurecr.io/mi-app:v1

# Listar eventos de Azure Activity Log
az monitor activity-log list --resource-group mi-rg \
  --start-time 2026-06-01 --max-events 50

# Crear Key Vault y almacenar secreto
az keyvault create --name mi-keyvault-abc --resource-group mi-rg
az keyvault secret set --vault-name mi-keyvault-abc \
  --name db-password --value "S3cr3t0!"
```
