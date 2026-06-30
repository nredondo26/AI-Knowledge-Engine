# Azure AKS — Azure Kubernetes Service

## Descripción

AKS es Kubernetes gestionado por Microsoft Azure con integración con Entra ID, escalado automático, nodos virtuales (ACI) y actualizaciones simplificadas.

## Arquitectura

- **Control plane**: Gestionado por Azure (alta disponibilidad, parches)
- **Node pools**: VMs workers (Linux, Windows, GPU, Spot)
- **Virtual nodes**: ACI para escalado serverless
- **Azure AD integration**: Autenticación con Entra ID
- **Azure CNI**: IP de VNet por pod o Kubenet

## Creación (Azure CLI)

```bash
az group create --name rg-miapp-prod --location eastus
az aks create --resource-group rg-miapp-prod --name aks-miapp-prod \
  --node-count 3 --node-vm-size Standard_D2s_v5 \
  --enable-managed-identity --enable-cluster-autoscaler \
  --min-count 3 --max-count 10 --enable-addons monitoring
az aks get-credentials --resource-group rg-miapp-prod --name aks-miapp-prod
kubectl get nodes
```

## Creación con Terraform

```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-miapp-prod"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-miapp"
  kubernetes_version  = "1.29"
  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2s_v5"
    enable_auto_scaling = true
    min_count  = 3
    max_count  = 10
  }
  identity { type = "SystemAssigned" }
  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }
}
```

## Azure AD + RBAC

```bash
az role assignment create \
  --assignee usuario@dominio.com \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $(az aks show -g rg-miapp-prod -n aks-miapp-prod --query id -o tsv)
```

## Node pools especializados

```bash
# GPU
az aks nodepool add --cluster-name aks-miapp-prod --name gpunodes \
  --node-count 1 --node-vm-size Standard_NC6s_v3 \
  --node-taints "sku=gpu:NoSchedule"

# Spot (80% descuento)
az aks nodepool add --cluster-name aks-miapp-prod --name spotpool \
  --priority Spot --eviction-policy Delete
```

## Virtual Nodes (ACI)

```bash
helm repo add virtual-kubelet https://virtual-kubelet.github.io/charts
helm install aci-connector virtual-kubelet/virtual-kubelet \
  --set providers.azure.target=aks
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: burst-pod
spec:
  containers:
  - name: app
    image: nginx:alpine
  nodeSelector:
    kubernetes.io/role: agent
    type: virtual-kubelet
```

## Integración GitHub Actions

```yaml
- uses: azure/aks-set-context@v3
  with:
    resource-group: rg-miapp-prod
    cluster-name: aks-miapp-prod
- uses: azure/k8s-deploy@v4
  with:
    manifests: manifests/deployment.yaml
    images: myregistry.azurecr.io/miapp:${{ github.sha }}
```

## Relaciones con otros módulos

- [EKS](../EKS/) — Kubernetes en AWS
- [GKE](../GKE/) — Kubernetes en Google Cloud
- [Cloud/Azure](../../005-Cloud/Azure/) — Infraestructura base
- [Containers/Registry](../../006-Containers/Registry/) — ACR

## Recursos recomendados

- [Documentación AKS](https://docs.microsoft.com/azure/aks/)
- [AKS Best Practices](https://docs.microsoft.com/azure/aks/best-practices)
- [AKS Baseline Architecture](https://github.com/mspnp/aks-baseline)
