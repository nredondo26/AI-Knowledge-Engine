# Google GKE — Google Kubernetes Engine

## Descripción

GKE es Kubernetes gestionado por Google Cloud, el creador original de Kubernetes. Ofrece Autopilot (serverless), nodos Spot/GPU/TPU, Workload Identity, Dataplane V2 (eBPF + Cilium) y Anthos (multi-cloud).

## Arquitectura

- **Control plane**: Gestionado por Google (redundante multi-zona)
- **Node pools**: Compute Engine (estándar, Spot, GPU, TPU, Confidential)
- **Autopilot**: Modo serverless (Google gestiona todo)
- **Workload Identity**: Acceso a GCP desde K8s sin secretos
- **Dataplane V2**: eBPF-based (Cilium) para redes y NetworkPolicy
- **GKE Sandbox**: Aislamiento con gVisor

## Creación (gcloud)

```bash
# Autopilot (serverless)
gcloud container clusters create-auto gke-miapp-prod --region us-east1

# Standard
gcloud container clusters create gke-miapp-prod --region us-east1 \
  --num-nodes=3 --machine-type=e2-standard-2 \
  --enable-autoscaling --min-nodes=3 --max-nodes=10 \
  --release-channel=stable --enable-image-streaming \
  --workload-pool=mi-proyecto.svc.id.goog

gcloud container clusters get-credentials gke-miapp-prod --region us-east1
```

## Creación con Terraform

```hcl
resource "google_container_cluster" "primary" {
  name     = "gke-miapp-prod"
  location = "us-east1"
  remove_default_node_pool = true
  initial_node_count = 1

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  datapath_provider = "ADVANCED_DATAPATH"
  release_channel { channel = "STABLE" }
}

resource "google_container_node_pool" "primary" {
  name       = "default-pool"
  location   = "us-east1"
  cluster    = google_container_cluster.primary.name
  node_count = 3
  autoscaling { min_node_count = 3; max_node_count = 10 }
  node_config {
    machine_type    = "e2-standard-2"
    service_account = google_service_account.gke.email
  }
}
```

## Workload Identity

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: bigquery-reader
  annotations:
    iam.gke.io/gcp-service-account: bigquery-sa@mi-proyecto.iam.gserviceaccount.com
```

```bash
gcloud iam service-accounts add-iam-policy-binding \
  bigquery-sa@mi-proyecto.iam.gserviceaccount.com \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:mi-proyecto.svc.id.goog[default/bigquery-reader]"
```

## GKE Sandbox (gVisor)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sandboxed-pod
spec:
  runtimeClassName: gvisor
  containers:
  - name: app
    image: nginx:alpine
```

## Node pools especializados

```bash
# GPU
gcloud container node-pools create gpu-pool --cluster gke-miapp-prod \
  --region us-east1 --machine-type a2-highgpu-1g \
  --accelerator type=nvidia-tesla-a100,count=1

# Spot
gcloud container node-pools create spot-pool --cluster gke-miapp-prod \
  --region us-east1 --spot --num-nodes=5
```

## Dataplane V2 (eBPF + Cilium)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
spec:
  podSelector:
    matchLabels:
      app: backend
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - port: 5432
```

## Relaciones con otros módulos

- [EKS](../EKS/) — Kubernetes en AWS
- [AKS](../AKS/) — Kubernetes en Azure
- [Cloud/GCP](../../005-Cloud/GCP/) — Infraestructura base
- [Containers/Security](../../006-Containers/Security/) — Sandbox, Workload Identity

## Recursos recomendados

- [Documentación GKE](https://cloud.google.com/kubernetes-engine/docs)
- [GKE Autopilot](https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview)
- [GKE Dataplane V2](https://cloud.google.com/kubernetes-engine/docs/concepts/dataplane-v2)
