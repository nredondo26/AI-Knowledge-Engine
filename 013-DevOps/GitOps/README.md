# GitOps

## Conceptos Fundamentales

GitOps es un patrón operativo para Kubernetes y otras plataformas cloud-native que utiliza Git como fuente única de verdad (single source of truth) para infraestructura declarativa y aplicaciones. El estado deseado del sistema se describe en repositorios Git, y un operador automatizado (agente) reconcilia continuamente el entorno real con ese estado.

### Principios clave

1. **Sistema declarativo**: Toda la infraestructura y configuración se expresa de forma declarativa (YAML, JSON, HCL).
2. **Git como fuente de verdad**: Git almacena el estado deseado inmutable y versionado.
3. **Reconciliación automatizada**: Un operador (ArgoCD, Flux) sincroniza automáticamente el clúster con el repositorio.
4. **Pull-based deployment**: El agente dentro del clúster "jala" los cambios desde Git, en lugar de que un CI externo "empuje" al clúster.
5. **Auditabilidad total**: Cada cambio queda registrado en el historial de Git con autor, timestamp y revisión.

## Arquitectura Pull vs Push

### Push-based (tradicional)

```bash
CI/CD Pipeline  ──push──>  Kubernetes API  ──update──>  Cluster
```

Problemas: credenciales de clúster expuestas en CI, deriva de configuración (drift), difícil auditoría.

### Pull-based (GitOps)

```bash
Git Repo  ──watch──>  GitOps Operator  ──reconcile──>  Cluster State
                             ▲
                             │
                         (comparación continua)
```

Ventajas: seguridad mejorada, detección de deriva, reversión instantánea con `git revert`.

## Pipeline CI + GitOps (ejemplo práctico)

El pipeline CI construye la imagen y actualiza el manifiesto en el repo GitOps:

### GitHub Actions (CI) → ArgoCD (CD)

```yaml
# .github/workflows/ci.yaml
name: Build & Update GitOps
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build & Push Docker image
        run: |
          docker build -t registry.example.com/app:${{ github.sha }} .
          docker push registry.example.com/app:${{ github.sha }}

      - name: Update GitOps manifest
        run: |
          git clone https://github.com/org/gitops-infra.git
          cd gitops-infra
          sed -i "s|image: .*|image: registry.example.com/app:${{ github.sha }}|" \
            environments/prod/deployment.yaml
          git config user.name "ci-bot"
          git config user.email "ci@example.com"
          git add -A
          git commit -m "chore: bump app to ${{ github.sha }}"
          git push
```

### Application ArgoCD

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-prod
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/org/gitops-infra.git
    targetRevision: main
    path: environments/prod
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - ApplyOutOfSyncOnly=true
```

## Flux v2: Kustomization y HelmRelease

Flux utiliza `Kustomization` y `HelmRelease` como CRDs principales:

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: apps
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./apps/production
  prune: true
  validation: client
  healthChecks:
    - apiVersion: apps/v1
      kind: Deployment
      name: my-app
      namespace: production
---
apiVersion: helm.toolkit.fluxcd.io/v2beta2
kind: HelmRelease
metadata:
  name: redis
  namespace: flux-system
spec:
  interval: 5m
  chart:
    spec:
      chart: redis
      sourceRef:
        kind: HelmRepository
        name: bitnami
        interval: 1h
  values:
    architecture: standalone
    auth:
      enabled: false
```

## Estrategias de Sincronización

| Estrategia | Descripción | Cuándo usarla |
|-----------|-------------|---------------|
| **Automated + Prune** | Sincroniza automáticamente y elimina recursos huérfanos | Entornos prod estables |
| **Manual** | Sincronización solo con aprobación humana | Cambios críticos |
| **Blue/Green vía Git** | Dos ramas (blue, green) y se cambia el targetRevision | Migraciones sin downtime |
| **Canary (Flagger)** | Progressive delivery con métricas | Releases graduales |

## Best Practices

1. **Repo separado para GitOps**: No mezclar código fuente con manifiestos de infraestructura.
2. **Estructura de ramas**: `main` = prod, `staging/`, `envs/*` para entornos efímeros.
3. **Kustomize overlays + Helm**: Usar Kustomize para parches específicos de entorno y Helm para charts empaquetados.
4. **SOPS / SealedSecrets para secretos**: Nunca commitear secretos en texto plano.
   ```yaml
   apiVersion: bitnami.com/v1alpha1
   kind: SealedSecret
   metadata:
     name: db-credentials
     namespace: production
   spec:
     encryptedData:
       password: AgBy3i4... (cifrado con clave pública del clúster)
   ```
5. **Health checks en sync**: Validar que los pods estén Ready antes de marcar la sincronización como exitosa.
6. **Policies con OPA/Gatekeeper**: Validar manifiestos antes de aplicarlos.
7. **Drift detection alerting**: Configurar notificaciones cuando el operador detecte deriva.
8. **Cluster bootstrap con GitOps**: El propio clúster se aprovisiona con Crossplane + GitOps.

## Herramientas del Ecosistema

| Herramienta | Rol | Característica distintiva |
|------------|-----|---------------------------|
| **ArgoCD** | CD declarativo | UI web, SSO, RBAC, multi-clúster |
| **Flux v2** | CD nativo de CNCF | Source-controller, Helm-controller, Kustomize-controller |
| **Flagger** | Progressive delivery | Canary, A/B testing basado en métricas de Prometheus |
| **Jenkins X** | CI/CD + GitOps | Integración nativa con GitHub/GitOps |
| **Werf** | GitOps para GitLab | Construcción y deploy en un solo toolset |
