# Kubernetes

## Conceptos Fundamentales

Kubernetes (K8s) es el orquestador de contenedores estándar de CNCF: service discovery, balanceo, rolling updates y auto-reparación.

### Arquitectura

```
Control Plane: API Server ── etcd ── Scheduler ── Controller Manager
Worker Nodes:  kubelet ── kube-proxy ── Pods
```

## Pods

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  containers:
    - name: myapp
      image: registry.example.com/myapp:1.0.0
      ports:
        - containerPort: 3000
      resources:
        requests:
          cpu: "250m"
          memory: "256Mi"
        limits:
          cpu: "500m"
          memory: "512Mi"
      livenessProbe:
        httpGet:
          path: /healthz
          port: 3000
```

## Deployments

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: myapp
          image: registry.example.com/myapp:1.0.0
          resources:
            requests:
              cpu: "200m"
              memory: "256Mi"
```

## Services e Ingress

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-svc
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 3000
  selector:
    app: myapp
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: nginx
  rules:
    - host: app.example.com
      http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: myapp-svc
                port:
                  number: 3000
```

## ConfigMaps, Secrets y SA

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  db_host: "postgresql.db.svc.cluster.local"
---
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
stringData:
  password: s3cret!
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: myapp-sa
```

## HPA

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 2
  maxReplicas: 20
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

## Storage y Network

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes: [ReadWriteOnce]
  resources:
    requests:
      storage: 50Gi
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes: [Ingress, Egress]
```

## Best Practices

1. **Namespaces con ResourceQuotas**.
2. **Etiquetar**: `app`, `version`, `tier`.
3. **Probes**: Liveness + Readiness.
4. **Pod Anti-Affinity**.
5. **Helm charts versionados**.
6. **External Secrets Operator**.
7. **RBAC mínimo**: SA por app.
8. **Network Policies**: Default deny.
9. **PodDisruptionBudget**:
   ```yaml
   apiVersion: policy/v1
   kind: PodDisruptionBudget
   metadata:
     name: myapp-pdb
   spec:
     minAvailable: 2
     selector:
       matchLabels:
         app: myapp
   ```
