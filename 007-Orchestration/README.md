# 007-Orchestration: Orquestación

## Descripción del dominio

La orquestación de contenedores automatiza el despliegue, escalado, redes, gestión de recursos y disponibilidad de aplicaciones containerizadas a través de clústeres de servidores. Kubernetes (K8s) es el estándar de facto de la industria, aunque existen alternativas como Docker Swarm, HashiCorp Nomad y los servicios gestionados de los proveedores cloud (ECS, AKS, GKE). Este módulo cubre la arquitectura de Kubernetes, objetos fundamentales, redes, almacenamiento, seguridad, observabilidad, operaciones day-2 y ecosistema CNCF.

## Conceptos clave

- **Arquitectura K8s**: Control plane (kube-apiserver, etcd, kube-scheduler, kube-controller-manager) + worker nodes (kubelet, kube-proxy, container runtime)
- **Pods**: Unidad mínima de ejecución; uno o más contenedores comparten red/almacenamiento; ephemeral por naturaleza
- **Workloads**: Deployment (declarativo + rolling updates), StatefulSet (orden, identidad estable), DaemonSet (un pod por nodo), Job/CronJob (tareas batch), ReplicaSet
- **Servicios (Services)**: ClusterIP, NodePort, LoadBalancer, ExternalName — Service Mesh (Istio, Linkerd, Consul) para mTLS, tráfico, observabilidad
- **Ingress y Gateway API**: Enrutamiento HTTP/HTTPS, TLS termination, path-based routing, host-based routing; Gateway API (evolución de Ingress)
- **Almacenamiento**: PersistentVolume (PV), PersistentVolumeClaim (PVC), StorageClass, CSI (Container Storage Interface), dynamic provisioning
- **ConfigMap y Secret**: Configuración desacoplada de la imagen; Secrets en etcd cifrados; External Secrets Operator (ESO) con AWS Secrets Manager, HashiCorp Vault
- **Redes (CNI)**: Calico (NetworkPolicy), Cilium (eBPF), Flannel (overlay simple), Weave Net, Antrea; Service Mesh (Istio, Linkerd, Consul, Kuma)
- **Escalado**: HPA (Horizontal Pod Autoscaler — basado en CPU/memory/custom metrics), VPA (Vertical Pod Autoscaler), KEDA (event-driven, basado en colas, Kafka, etc.)
- **Seguridad**: RBAC (Role/ClusterRole + RoleBinding/ClusterRoleBinding), PodSecurityContext, PodSecurityStandards (Privileged, Baseline, Restricted), NetworkPolicies, seccomp, OPA/Gatekeeper, Kyverno
- **Helm**: Package manager para K8s — Charts, templating (Go templates/values.yaml), repositorios (ArtifactHUB)
- **Operadores**: Patrón para aplicaciones stateful (Prometheus Operator, PostgreSQL Operator, Strimzi para Kafka) — framework: Operator SDK, Kopf (Python), Java Operator SDK
- **GitOps**: ArgoCD, Flux CD — Git como única fuente de verdad; reconciliación automática, PR-driven deployments
- **Observabilidad**: Prometheus (métricas) + Grafana (dashboards), Loki (logs), Tempo (traces), OpenTelemetry — kube-state-metrics, node_exporter, cAdvisor

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Orquestadores | Kubernetes (K8s), Docker Swarm, HashiCorp Nomad, Apache Mesos + Marathon |
| K8s gestionados | Amazon EKS, Azure AKS, Google GKE, DigitalOcean DOKS, OVH Managed K8s |
| K8s on-prem | OpenShift (Red Hat), Rancher (RKE2), k3s (IoT/Edge), microk8s (Canonical), k0s (Mirantis) |
| Service Mesh | Istio, Linkerd, Consul, Kuma, Cilium Service Mesh |
| CNI (Red) | Calico, Cilium, Flannel, Weave Net, Antrea |
| GitOps | ArgoCD, Flux CD, Jenkins X |
| Helm + Charts | Helm CLI, ArtifactHUB, Bitnami charts, charts de la comunidad |
| Seguridad | Kyverno, OPA/Gatekeeper, Trivy, Falco, cert-manager, Vault (HashiCorp) |
| Observabilidad | Prometheus + Grafana, Loki, Tempo, Datadog, New Relic, Dynatrace |

## Hoja de ruta

1. **Principiante**: Conceptos de orquestación — minikube/k3d/kind para K8s local — kubectl básico (get, describe, logs, exec, apply, delete) — Pods, Deployments, Services (ClusterIP)
2. **Intermedio**: ConfigMaps, Secrets — Ingress (nginx-ingress-controller) — PersistentVolumeClaims — Healthchecks (liveness, readiness, startup probes) — kubectl port-forward, exec interactivo — Helm básico (install, upgrade, rollback)
3. **Avanzado**: HPA + VPA + KEDA — StatefulSets — RBAC — Network Policies — Helm avanzado (charts propios, dependencias) — ArgoCD (GitOps) — Prometheus + Grafana + Alertmanager — cert-manager + Let's Encrypt
4. **Experto**: Operadores personalizados — Service Mesh (Istio: VirtualService, DestinationRule) — Cilium + eBPF (network policies, observabilidad) — multi-cluster (Cluster API, Submariner, Skupper) — K8s performance tuning — escalado a miles de nodos — compliance (PodSecurityStandards, OPA)

## Relaciones con otros módulos

- [003-Databases](../003-Databases/) — Operadores de bases de datos en K8s (Strimzi Kafka, Zalando Postgres, MySQL Operator)
- [004-OperatingSystems](../004-OperatingSystems/) — Container-Optimized OS, Bottlerocket, Flatcar; cgroups v2; kernel tuning
- [005-Cloud](../005-Cloud/) — EKS, AKS, GKE — clústeres gestionados; Fargate como serverless para K8s
- [006-Containers](../006-Containers/) — Container runtimes (containerd, CRI-O); imágenes OCI; registries
- [008-Networking](../008-Networking/) — CNI, Service Mesh, Ingress, DNS en K8s (CoreDNS), Cilium eBPF
- [009-Security](../009-Security/) — PodSecurityStandards, NetworkPolicies, RBAC, secrets, Falco, OPA
- [013-DevOps](../013-DevOps/) — CI/CD para K8s, GitOps (ArgoCD, Flux), pipeline tools
- [034-LLM](../034-LLM/) — Despliegue de LLMs en K8s (vLLM, TGI, Ray Serve), GPU/NPU scheduling

## Recursos recomendados

- **Documentación**: kubernetes.io/docs, "Kubernetes: Up and Running" (Burns, Hightower, Evenson), "Programming Kubernetes" (Hausenblas, Schimanski)
- **Cursos**: KodeKloud: Certified Kubernetes Administrator (CKA), KodeKloud: Certified Kubernetes Application Developer (CKAD), KubeCon + CloudNativeCon talks
- **Práctica**: killercoda.com, katacoda, Play with Kubernetes, Kubernetes The Hard Way (Kelsey Hightower)
- **Certificaciones**: CKA, CKAD, CKS (Certified Kubernetes Security Specialist) de CNCF/Linux Foundation
- **Comunidad**: CNCF Slack, Kubernetes SIG meetings, K8s Office Hours
