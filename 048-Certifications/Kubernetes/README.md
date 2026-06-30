# Certificaciones Kubernetes

## Visión General

Kubernetes (K8s) es el orquestador de contenedores de facto. La Cloud Native Computing Foundation (CNCF) administra las certificaciones oficiales.

## Certificaciones Oficiales

| Certificación | Siglas | Perfil | Duración | Precio (USD) |
|--------------|--------|--------|----------|--------------|
| Certified Kubernetes Administrator | CKA | Administrador | 2h | 395 |
| Certified Kubernetes Application Developer | CKAD | Desarrollador | 2h | 395 |
| Certified Kubernetes Security Specialist | CKS | Seguridad | 2h | 395 |

### CKA — Certified Kubernetes Administrator

Enfocado en operaciones: instalación, configuración, networking, almacenamiento, troubleshooting.

**Dominios del examen:**
```
Cluster Architecture & Installation    25%
Workloads & Scheduling                 15%
Services & Networking                  20%
Storage                                10%
Troubleshooting                        30%
```

### CKAD — Certified Kubernetes Application Developer

Orientado a desarrollo sobre K8s: diseño, empaquetado, APIs, debugging.

**Dominios del examen:**
```
Core Concepts                          13%
Configuration                          18%
Multi-Container Pods                   10%
Observability                          18%
Pod Design                             20%
Services & Networking                  13%
State Persistence                       8%
```

### CKS — Certified Kubernetes Security Specialist

Requiere CKA como prerequisito. Cubre hardening, vulnerabilidades, políticas de seguridad.

**Dominios del examen:**
```
Cluster Setup & Hardening              20%
Cluster Hardening & Supply Chain        5%
Minimize Microservice Vulnerabilities  25%
Supply Chain Security                  15%
Monitoring, Logging & Runtime Security 25%
Disaster Recovery                      10%
```

## Herramientas Esenciales

```bash
# kubectl — CLI principal
kubectl get pods -n kube-system
kubectl describe pod mi-pod
kubectl logs -f deployment/mi-app
kubectl exec -it pod-name -- /bin/sh

# kubeadm — Bootstrap de clusters
kubeadm init --pod-network-cidr=10.244.0.0/16
kubeadm join <master>:6443 --token <token>

# krew — Plugin manager para kubectl
kubectl krew install stern  # Logs multi-pod
kubectl krew install ns     # Switch namespace rápido

# Helm — Package manager
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/nginx
```

## Ejemplo: Deployment + Service

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-gateway
  labels:
    app: gateway
spec:
  replicas: 3
  selector:
    matchLabels:
      app: gateway
  template:
    metadata:
      labels:
        app: gateway
    spec:
      containers:
      - name: gateway
        image: myregistry/api-gateway:1.2.3
        ports:
        - containerPort: 8080
        resources:
          requests:
            cpu: 250m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: api-gateway-svc
spec:
  type: ClusterIP
  selector:
    app: gateway
  ports:
  - port: 80
    targetPort: 8080
```

## RBAC (Role-Based Access Control)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: development
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: development
  name: read-pods
subjects:
- kind: User
  name: dev-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

## Network Policies

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

## Almacenamiento Persistente

```yaml
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
  storageClassName: standard
```

## Estrategia de Estudio

1. **Killer.sh** — Simulador oficial de examen (incluido con el registro)
2. **Udemy** — Cursos de Mumshad Mannambeth (KodeKloud)
3. **Kubernetes.io/docs** — Tasks y tutoriales
4. **Playground** — `killercoda.com`, `play-with-k8s.com`
5. **Práctica** — Minikube local + Kind para clusters multi-node

```bash
# Kind: Kubernetes in Docker
kind create cluster --name cka-lab --config kind-config.yaml
kubectl cluster-info --context kind-cka-lab
```

## Tips para el Examen

- El examen es **100% práctico** en terminal (sin múltiple opción)
- Usar `kubectl explain` y `--dry-run=client -o yaml` para generar recursos
- `alias k=kubectl` + `export do="--dry-run=client -o yaml"`
- Marcadores (bookmarks) oficiales permitidos: kubernetes.io/docs
- `kubectl api-resources` lista todos los tipos de recursos disponibles

## Referencias

- [CNCF Certification](https://www.cncf.io/certification/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [CKA Curriculum](https://github.com/cncf/curriculum)
- [Killer.sh](https://killer.sh/)
