# 007-Orchestration: Orquestación

## Descripción ampliada del dominio

La orquestación de contenedores gestiona el ciclo de vida completo de aplicaciones containerizadas en clústeres de servidores: despliegue, escalado automático, balanceo de carga, descubrimiento de servicios, actualizaciones, almacenamiento, redes, y recuperación ante fallos. Kubernetes (K8s) se ha convertido en el estándar de facto para orquestación desde su lanzamiento por Google en 2014 (basado en su experiencia con Borg y Omega). El ecosistema Kubernetes incluye cientos de proyectos bajo la CNCF (Cloud Native Computing Foundation). La competencia incluye Docker Swarm (simplicidad, integración Docker), Apache Mesos/Marathon (más orientado a big data) y HashiCorp Nomad (simplicidad, multi-workload). La adopción de K8s ha pasado de ser una tecnología de nicho a infraestructura crítica en empresas de todos los tamaños. Las distribuciones de Kubernetes varían desde enterprise (OpenShift, Rancher, VMware Tanzu) hasta ligeras para edge (K3s, MicroK8s, K0s, KubeEdge). El patrón de controladores declarativos (desired state vs actual state reconciliado por controllers) es el principio arquitectónico fundamental.

## Tabla de conceptos clave

| Concepto | Descripción | Componentes Kubernetes |
|----------|-------------|----------------------|
| Pod | Unidad mínima desplegable: uno o más contenedores con IP compartida | kubelet, container runtime, pause container |
| Deployment | Controlador declarativo para ReplicaSets con rolling updates | deployment controller, replicaset controller |
| Service | Abstracción de red para acceder a pods, balanceo interno | kube-proxy, EndpointSlice, ClusterIP, NodePort, LB |
| Ingress | Exposición de servicios HTTP/HTTPS al exterior | Ingress Controller (nginx, Traefik, HAProxy, Contour) |
| ConfigMap/Secret | Configuración y datos sensibles inyectados en pods | etcd storage, Secret encryption, SealedSecrets |
| PersistentVolume (PV) | Almacenamiento persistente abstraído del pod | CSI driver, storage classes, PVC binding |
| Namespace | Aislamiento lógico de recursos dentro del clúster | ResourceQuota, LimitRange, NetworkPolicy |
| StatefulSet | Controlador para aplicaciones stateful con identidad estable | Headless services, ordinal indexing, PVC template |
| DaemonSet | Despliegue de un pod por nodo (logging, monitoring, network) | Node selector, tolerations, update strategy |
| Job/CronJob | Ejecución de tareas batch y programadas | Job controller, completions, parallelism, backoff limit |
| HPA (Horizontal Pod Autoscaler) | Escalado automático según métricas de CPU/memoria/custom | metrics-server, custom metrics API, KEDA |
| RBAC | Control de acceso basado en roles | ServiceAccount, Role, ClusterRole, RoleBinding |
| Custom Resource (CRD) | Extensiones de la API de Kubernetes | CRD + custom controller, operator pattern |

## Tecnologías principales

| Herramienta | Función | Creador/Mantenedor | Características |
|-------------|---------|-------------------|-----------------|
| Kubernetes (K8s) | Orquestador principal | CNCF (Google) | Container orchestrator, declarative, extensible (CRD), self-healing |
| Helm | Package manager para K8s | CNCF | Charts, templates, releases, rollbacks |
| Kustomize | Configuración nativa de K8s sin templates | CNCF/Google | Overlays, patches, transformers, bases |
| Istio | Service mesh | Google/Lyft | Envoy proxy, mTLS, traffic management, observability |
| Cilium | Networking + security (eBPF) | Isovalent | eBPF-based, network policies, service mesh, observability |
| Prometheus | Monitoreo y alerta | CNCF | Metrics collection, PromQL, Alertmanager |
| ArgoCD | GitOps CD | CNCF | Declarative CD, sync policies, multi-cluster |
| Tekton | CI/CD nativo K8s | CNCF | Custom tasks/pipelines CRDs, cloud-native |
| KEDA | Event-driven autoscaling | CNCF | Scale based on external events (Kafka, RabbitMQ, etc.) |
| Knative | Serverless on K8s | Google | Serving (scale-to-zero) + Eventing + Functions |
| Crossplane | Control plane multi-cloud | Upbound/CNCF | Managed resource composition, control planes |
| cert-manager | TLS certificate management | Jetstack | ACME/LetsEncrypt, self-signed, vault issuer |
| Kyverno | Policy engine | Nirmata | Kubernetes-native policies (admission, validation, mutation) |
| K3s | K8s ligero para edge | Rancher | ~50MB binary, SQLite instead of etcd, embedded |
| kubeadm | Bootstrap de clúster | Kubernetes SIG | Init/join, haproxy/etcd setup, upgrade |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos de orquestación: qué resuelve, declarative vs imperative, desired state reconciliation. Instalar K8s local: Minikube, Kind (Docker-in-Docker), K3s, MicroK8s. kubectl básico: pods, deployments, services, namespaces — create, get, describe, delete, logs, exec. Pods: contenedores, init containers, sidecar pattern, resource requests/limits. Deployments: replicas, rolling update strategy, rollback, scale. Services: ClusterIP, NodePort, LoadBalancer — diferencias, selector. ConfigMaps y Secrets: creación, inyección como ENV y volúmenes. Labels y selectors: organización de recursos. Namespaces: aislamiento, recursos compartidos. kubectl port-forward, logs, exec interactivo.
   - Proyecto: Desplegar app web (nginx + node backend + postgres) en K8s local. Crear Deployment, Service, ConfigMap, Secret.
   - Certificación: KCNA (Kubernetes and Cloud Native Associate) — fundamentos.
   - Lectura: "Kubernetes in Action" (Luksa, 1ª ed.), kubernetes.io/docs/tutorials.

2. **Intermedio (3-8 meses)**: Almacenamiento: PersistentVolume (PV), PersistentVolumeClaim (PVC), StorageClass, provisionadores dinámicos (EBS, GCE PD, CSI), StatefulSets con PVC template. Ingress: controladores (nginx-ingress, Traefik, Contour), TLS/HTTPS con cert-manager, annotations. Networking: Service types (ExternalName, headless), NetworkPolicies (Calico, Cilium), CoreDNS (cluster DNS). Helm: charts, values, templates, hooks, repositorios, release lifecycle, testing de charts. Kustomize: bases + overlays, patches estratégicos, components. RBAC: ServiceAccounts, Roles, ClusterRoles, RoleBindings, ClusterRoleBindings. Resource management: requests, limits, LimitRange, ResourceQuota, pod priority, preemption, Quality of Service (Guaranteed, Burstable, BestEffort). Monitoreo básico: Prometheus (ServiceMonitor), Grafana dashboards, metrics-server para HPA. HPA (Horizontal Pod Autoscaler): CPU/memory based, custom metrics. Jobs y CronJobs: parallelism, completions, backoff, ttlSecondsAfterFinished. Liveness, Readiness, Startup probes.
   - Proyecto: Desplegar microservicio con Helm chart, Ingress TLS, base de datos con PV, monitoreo Prometheus + Grafana.
   - Certificación: CKA (Certified Kubernetes Administrator) — administración de clúster.
   - Lectura: "Kubernetes in Action" (2ª ed.), "Kubernetes Patterns" (Ibrahim, Jamshidi), Helm docs.

3. **Avanzado (8-14 meses)**: Operators: patrón operator, Operator SDK, Kopf (Python) o controller-runtime (Go), CRDs (Custom Resource Definitions), webhooks (admission, mutation, conversion). Autoescalado avanzado: VPA (Vertical Pod Autoscaler), Cluster Autoscaler, KEDA (event-driven, Kafka/RabbitMQ/Prometheus), multiple metrics en HPA. GitOps: ArgoCD (ApplicationSets, Sync Waves, hooks), Flux CD (Kustomize + Helm controllers). Service Mesh: Istio (Envoy proxy, VirtualService, DestinationRule, mTLS, authorization policies), Linkerd (ultra light, Rust-based data plane), Cilium (eBPF, service mesh sin sidecar). Security: Pod Security Standards (Privileged, Baseline, Restricted), PodSecurity admission controller, OPA/Gatekeeper, Kyverno policies, security contexts, seccomp/AppArmor profiles, seccomp profiles, image signing (Cosign), vulnerability scanning (Trivy operator). Observabilidad: Loki (logs), Tempo (tracing), Prometheus + Thanos/Cortex (metrics), OpenTelemetry, Kiali, Jaeger. Estrategias de upgrade: rolling, blue/green, canary (Flagger, Argo Rollouts, Istio traffic splitting). Advanced networking: Cilium CNI con eBPF, eBPF service mesh, Hubble observability, BGP (MetalLB), egress gateways. Multi-tenancy: vCluster, Capsule, hierarchical namespaces.
   - Proyecto: Operador personalizado para gestionar un recurso de aplicación propio. GitOps multi-cluster con ArgoCD + Kustomize. Canary deployments con Flagger e Istio.
   - Certificación: CKAD + CKA + CKS (Certified Kubernetes Security Specialist). CKS es la más valorada.
   - Lectura: "Programming Kubernetes" (Martin, Hausenblas), "Managing Kubernetes" (Burns, Saha), "Cloud Native DevOps with Kubernetes" (Dobies, Wood).

4. **Experto (14+ meses)**: Cluster internals: etcd (raft consensus, defrag, backup/restore, encryption), kube-apiserver (API aggregation, authentication webhooks, authorization), kube-scheduler (scheduling framework, plugins, extender), kubelet (pod lifecycle, cAdvisor, image GC, node status). Control plane HA: stacked etcd vs external etcd, kubeadm HA, Keepalived + HAProxy vs cloud load balancer. Performance tuning: pod density optimization, node sizing, scheduler performance, API server tuning (max-requests-inflight, etcd tuning). Network performance: eBPF (Cilium), XDP for packet processing, DPDK for high-throughput. Storage: Rook+Ceph, Longhorn, Portworx, OpenEBS, LINSTOR. Security scanning automation: Trivy operator, Falco (runtime security), Tetragon (eBPF security), Kube-bench (CIS benchmark). Multi-cluster: federation (KubeFed, kubefed), cluster-api (declarative cluster lifecycle), service mesh mesh, submariner (connectivity). WASM on K8s: runwasi, Krustlet, SpinKube. Edge: K3s, KubeEdge, K0s, MicroK8s, balena, K3os. Capacity planning: bin packing algorithms, scheduler performance, node sizing. Disaster recovery: Velero (backup/restore), Rancher Longhorn DR, Stork (snapshot, migration). Chaos engineering: Litmus, Chaos Mesh, Gremlin.
   - Proyecto: Implementar un scheduling plugin personalizado. Multi-cluster mesh con service mesh federation. Cluster API con auto-scaling de nodos. Contribución a CNCF project.
   - Lectura: Kubernetes source code, KEPs (Kubernetes Enhancement Proposals), sig-release docs, "Kubernetes Design Principles" papers.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [005-Cloud](../005-Cloud/) | K8s gestionado (EKS, GKE, AKS), node pools, cluster autoscaling |
| [006-Containers](../006-Containers/) | Contenedores como unidad base, runtimes (containerd, CRI-O) |
| [008-Networking](../008-Networking/) | CNI, Service Mesh, Ingress, Network Policies, DNS |
| [009-Security](../009-Security/) | Pod security, RBAC, network policies, secrets, image signing |
| [010-Architecture](../010-Architecture/) | Arquitectura de microservicios y cloud-native |
| [013-DevOps](../013-DevOps/) | GitOps, automatización de despliegue, infraestructura |
| [014-CICD](../014-CICD/) | Pipelines que construyen y despliegan en K8s |
| [015-Automation](../015-Automation/) | Operators, controllers, automatización de operaciones |
| [029-IoT](../029-IoT/) | K3s, KubeEdge para orquestación edge en IoT |

## Recursos recomendados

- **Libros**: "Kubernetes in Action" (Luksa, 2ª ed.), "Kubernetes Patterns" (Ibrahim), "Programming Kubernetes" (Martin), "Cloud Native DevOps with Kubernetes" (Dobies).
- **Cursos**: "Kubernetes Basics" (Linux Foundation), CKA/CKAD/CKS training (KodeKloud, Mumshad Mannambeth), "Kubernetes: The Complete Guide" (Vijin).
- **Práctica**: KodeKloud playground, Play with Kubernetes (killer.sh), Minikube/Kind local, Google Cloud Skills Boost K8s challenges.
- **Documentación**: kubernetes.io (docs, blog), kubectl reference (kubectl-commands.io), Helm docs, Istio docs, ArgoCD docs.
- **Herramientas**: Lens, Octant, K9s, kubectx/kubens, stern (logs), kube-ps1, kubectl-aliases, Popeye, Goldilocks.
- **Comunidad**: Kubernetes Slack (kubernetes.slack.com), KubeCon (videos en YouTube), sig-release, CNCF landscape.

## Notas adicionales

Kubernetes tiene una curva de aprendizaje pronunciada pero es la habilidad más demandada en infraestructura moderna. Se recomienda el camino de certificación: KCNA → CKA → CKAD → CKS. El ecosistema CNCF incluye cientos de proyectos; dominar ArgoCD, Helm, Prometheus, Istio y Cilium cubre la mayoría de necesidades en producción. El futuro incluye WASM/Krustlet para cargas de trabajo ligeras, K8s en edge (K3s), eBPF como reemplazo de sidecar proxies, y AI/ML workloads (Kubeflow, Kserve, Ray).
