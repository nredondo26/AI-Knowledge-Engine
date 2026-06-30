# ArgoCD

## Conceptos Fundamentales

ArgoCD es un operador GitOps declarativo para Kubernetes (CNCF graduated). Usa Git como fuente única de verdad y reconcilia continuamente el clúster con el repositorio.

### Componentes

| Componente | Función |
|------------|---------|
| **API Server** | API REST/gRPC, UI, CLI. Auth, RBAC, SSO |
| **Repo Server** | Clona repos, genera manifiestos (Kustomize, Helm) |
| **Application Controller** | Compara Git vs clúster, aplica diferencias |
| **Redis** | Caché para escalar horizontalmente |

## Application CRD

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/argoproj/argocd-example-apps.git
    targetRevision: HEAD
    path: guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: guestbook
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - ApplyOutOfSyncOnly=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

## Project CRD (RBAC)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: team-alpha
spec:
  sourceRepos: ['https://github.com/team-alpha/*']
  destinations:
    - namespace: 'team-*'
      server: https://kubernetes.default.svc
  roles:
    - name: developer
      policies:
        - p, proj:team-alpha:developer, applications, get, team-alpha/*, allow
      groups: [team-alpha-developers]
    - name: admin
      policies:
        - p, proj:team-alpha:admin, applications, *, team-alpha/*, allow
      groups: [team-alpha-admins]
```

## Sync Waves

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  annotations:
    argocd.argoproj.io/sync-wave: "-5"  # Primero
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  annotations:
    argocd.argoproj.io/sync-wave: "0"   # Después
---
apiVersion: v1
kind: Service
metadata:
  name: myapp
  annotations:
    argocd.argoproj.io/sync-wave: "1"   # Último
```

## Hooks

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
  annotations:
    argocd.argoproj.io/hook: PreSync
    argocd.argoproj.io/hook-delete-policy: HookSucceeded
spec:
  template:
    spec:
      containers:
        - name: migration
          image: myapp:latest
          command: ["./run-migrations.sh"]
      restartPolicy: Never
```

## ApplicationSets

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: guestbook
spec:
  generators:
    - clusters:
        selector:
          matchLabels:
            environment: production
    - git:
        repoURL: https://github.com/argoproj/argocd-example-apps.git
        directories:
          - path: apps/*
  template:
    metadata:
      name: '{{name}}-guestbook'
    spec:
      source:
        repoURL: https://github.com/argoproj/argocd-example-apps.git
        path: '{{path}}'
      destination:
        server: '{{server}}'
        namespace: guestbook
```

Generadores: List, Clusters, Git, SCM Provider, Matrix, Merge.

## SSO / RBAC Config

```yaml
# argocd-cm.yaml
data:
  url: https://argocd.example.com
  dex.config: |
    connectors:
      - type: oidc
        id: google
        config:
          issuer: https://accounts.google.com
          clientID: $ARGOCD_SSO_CLIENT_ID

# argocd-rbac-cm.yaml
data:
  policy.default: role:readonly
  policy.csv: |
    p, role:org-admin, applications, *, */*, allow
    g, my-team@example.com, role:org-admin
```

## Monitoreo

```yaml
groups:
  - name: argocd
    rules:
      - alert: ArgoCDAppOutOfSync
        expr: argocd_app_info{sync_status!="Synced"} > 0
        for: 10m
        labels: { severity: warning }
      - alert: ArgoCDAppDegraded
        expr: argocd_app_info{health_status=="Degraded"} > 0
        for: 5m
        labels: { severity: critical }
```

## Best Practices

1. **No editar manifiestos en el clúster** (self-heal).
2. **`ignoreDifferences`** solo para campos mutados.
3. **ApplicationSets para multi-entorno**.
4. **Sync Waves para dependencias**.
5. **Migrations como PreSync hooks**.
6. **Prune protection**: `prune: false` en ventanas de cambio.
7. **Secretos con SealedSecrets o External Secrets**.
8. **Monitorear OutOfSync**.
9. **CLI en pipelines**: `argocd app sync`.
10. **RBAC granular**: Proyectos por equipo.
