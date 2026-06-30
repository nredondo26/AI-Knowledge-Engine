# 014-CI/CD: Integración y Despliegue Continuos

## Descripción ampliada del dominio

CI/CD (Continuous Integration / Continuous Delivery or Deployment) automatiza las etapas de integración, prueba y despliegue del software para entregar cambios de forma rápida, segura y repetible. La integración continua (CI) consiste en fusionar el trabajo de todos los desarrolladores en una rama compartida varias veces al día, verificando cada integración mediante builds y pruebas automatizadas. La entrega continua (CD) extiende CI asegurando que el software pueda ser liberado a producción en cualquier momento mediante un proceso automatizado, con despliegue manual opcional. El despliegue continuo va un paso más allá: cada cambio que pasa el pipeline se despliega automáticamente en producción. La evolución de CI/CD incluye: scripts manuales → Jenkins (2005, Hudson) → CI/SaaS (Travis CI, CircleCI, 2011-12) → CI/CD en cloud (GitHub Actions, GitLab CI, 2018-19) → GitOps (ArgoCD, Flux, 2019-20) → AI-assisted CI/CD (2023+). Los pipelines modernos integran no solo build y test, sino también seguridad (SAST/DAST/SCA), análisis de calidad, compliance, y verificación de infraestructura. El pipeline CI/CD es el "cinturón transportador" de la fábrica de software moderna.

## Tabla de conceptos clave

| Concepto | Descripción | Beneficio clave |
|----------|-------------|----------------|
| Integración Continua (CI) | Build y test automático en cada push/PR | Detección temprana de errores de integración |
| Entrega Continua (CD) | Artefacto listo para producción tras CI | Release rápido y confiable, deploy manual |
| Despliegue Continuo | Deploy automático a producción tras pasar CI/CD | Time-to-market mínimo, zero-touch |
| Pipeline | Serie de etapas automatizadas (lint → build → test → scan → deploy) | Repetibilidad, consistencia, auditabilidad |
| Artefacto | Paquete inmutable (JAR, Docker, ZIP) que avanza por entornos | Trazabilidad, versionado, reproducibility |
| GitOps | Estado deseado declarado en Git, operador sincroniza | Consistencia, auditoría, rollback simple |
| Semantic Versioning | MAJOR.MINOR.PATCH con reglas semánticas | Comunicación de cambios, compatibilidad |
| Trunk-Based Development | Ramas cortas fusionadas frecuentemente a main | Menos merge conflicts, CI más simple |
| Feature Flags | Despliegue de código detrás de toggle | Deploy sin release, A/B testing, rollback rápido |
| Blue/Green | Dos entornos idénticos, switch de tráfico | Zero-downtime deployment, rollback inmediato |
| Canary Release | Despliegue gradual a % de usuarios | Reducción de riesgo, validación en producción |
| Quality Gate | Condición que debe cumplirse para avanzar en el pipeline | Code coverage, lint errors, vulnerabilidades |

## Tecnologías principales

| Herramienta | Tipo | Lenguaje pipeline | Escalabilidad | Caso de uso |
|-------------|------|-------------------|---------------|-------------|
| GitHub Actions | Cloud CI/CD | YAML (workflow) | Alta (20 jobs concurrentes gratis) | Proyectos GitHub, open source, startups |
| GitLab CI/CD | Cloud/Self-hosted | YAML (.gitlab-ci.yml) | Muy alta | Enterprise, privacidad, todo en uno |
| Jenkins | Self-hosted | Groovy (Jenkinsfile) | Muy alta (plugins) | Legacy enterprise, personalización total |
| CircleCI | Cloud | YAML (.circleci) | Alta | Proyectos con caching y paralelismo |
| ArgoCD | GitOps CD | YAML (Application) | Muy alta (multi-cluster) | GitOps on Kubernetes |
| Flux CD | GitOps CD | YAML (GitRepository) | Alta (más simple) | GitOps puro K8s |
| Azure DevOps | Cloud/Server | YAML / Classic | Muy alta | Entornos Microsoft, enterprise |
| Tekton | K8s-native CI/CD | CRDs (Task, Pipeline) | Muy alta (K8s) | Cloud-native, customizability |
| Spinnaker | CD Multi-cloud | JSON/YAML (pipeline) | Muy alta | Multi-cloud CD, deploy strategies |
| Buildkite | Hybrid Cloud | YAML (pipeline) | Alta (agentes propios) | Flexibilidad, control de infra |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos: qué es CI, qué es CD, diferencia entre delivery y deployment. Pipeline básico con GitHub Actions o GitLab CI: estructura (name, on/trigger, jobs, steps, runs-on). Etapas: lint (ESLint, ruff, flake8), build (npm build, gradle build, go build), test (pytest, Jest, JUnit), deploy a staging (SSH, Docker). Triggers: push, pull_request, workflow_dispatch, schedule (cron). Matrix builds: probar en múltiples versiones de lenguaje/OS. GitHub Actions: actions/checkout, actions/setup-node/python/java, actions/cache. Variables de entorno y secrets (GitHub Secrets, GitLab CI variables). Build artifacts: upload/download artifact entre jobs.
   - Proyecto: Pipeline CI/CD para app web con lint + test + build + deploy a VM/Heroku/Railway.
   - Lectura: docs.github.com/actions, docs.gitlab.com/ci, "GitHub Actions in Action" (Laster).

2. **Intermedio (2-6 meses)**: Pipeline multi-stage: stages (build, test, integration, security, deploy), dependencias entre jobs (needs). Jobs paralelos y caching inteligente: cache de dependencias (pip cache, npm cache, Maven local), cache de build outputs. Testing stages: unit tests, integration tests (testcontainers, Docker-in-Docker), E2E tests (Playwright, Cypress). Security scanning: SAST (Semgrep, CodeQL), SCA (Dependabot, Snyk, Renovate), container scanning (Trivy, Grype), secrets scanning (Gitleaks, truffleHog). Code quality: SonarQube/SonarCloud (coverage, duplications, code smells, security hotspots). Docker build: layer caching, multi-stage builds, Docker BuildKit cache mounts. Deployment strategies: SSH deploy (rsync, scp), Docker Compose deploy, rolling update. Artifact management: Docker Hub, GitHub Container Registry, Nexus, Artifactory. Notifications: Slack, Discord, email (success/failure). Branch protection rules: required CI checks, merge gates.
   - Proyecto: Pipeline multi-stage con lint + SAST + unit test + integration test + build + container scan + deploy staging + deploy production.
   - Lectura: "GitHub Actions in Action" (Laster) advanced, GitLab CI/CD advanced docs.

3. **Avanzado (6-12 meses)**: GitOps: ArgoCD (Application, Sync Policy, Auto-heal, Prune, Sync Waves, Hooks), Flux (KustomizeController, HelmController, NotificationController). Progressive Delivery: Flagger (canary weight step, metrics analysis, promotion/abort), Argo Rollouts (blue-green + canary + traffic shifting con Istio/nginx/SMI), A/B testing. Feature Flags: LaunchDarkly, Flagsmith, Unleash — evaluación en app, remote config. Pipeline as Code: Jenkins Pipeline (Declarative + Scripted Groovy), Tekton (Task, Pipeline, Trigger). Deployment strategies avanzadas: blue/green (service mesh, DNS switch), canary (traffic splitting, metrics analysis), shadow/mirroring (traffic duplicado), A/B testing con feature flags. Versionado automático: semantic-release, standard-version, conventional commits, changelog automático. Test sharding: split test suite entre múltiples runners paralelos. Pipeline security: SLSA framework (Build L1-L4), Sigstore (Cosign + Fulcio + Rekor), SBOM generation (CycloneDX), attestations in-toto. Cost optimization en CI/CD: cache sharing, parallel vs sequential analysis, self-hosted runners con spot instances.
   - Proyecto: GitOps multi-ambiente con ArgoCD + Kustomize overlays. Progressive Delivery con Flagger + Istio. SLSA L3 pipeline con Sigstore.
   - Certificación: GitOps (ArgoCD/Flux) certifications, Kubernetes CKA/CKS, GitHub Actions (beta certification).

4. **Experto (12+ meses)**: CI/CD interno como plataforma: Internal Developer Platform (IDP) con Backstage scaffolder + GitHub Actions + ArgoCD. Custom Tekton Chains para supply chain security. Event-driven CI/CD: webhooks, chatops, Git events → triggers → pipelines. AI-assisted CI/CD: auto-test generation, flaky test detection and quarantine, auto-fix de errores comunes, AI-generated release notes. Multi-cloud CD: Spinnaker (pipeline templates, strategies, canary analysis, manual judgment). CI/CD para ML (MLOps/MLOps pipelines): Kubeflow Pipelines, MLflow, TFX, DVC, Feast, model validation and promotion. Performance testing en pipeline: k6 (performance gates, thresholds, load test as code). Blast radius reduction: deployment windows, gradual rollout, automated rollback, abort on failure. Cost governance: FinOps for CI/CD (spot runners, reserved capacity, caching), infrastructure cost per pipeline. Security compliance automation: compliance as code, automated audit trails, SOC 2 evidence collection, policy as code con OPA/Kyverno.
   - Proyecto: IDP completo con CI/CD autoservicio. MLOps pipeline en K8s con Kubeflow. Auditoría compliance automatizada.
   - Lectura: "Continuous Delivery" (Humble, Farley), "GitOps and Kubernetes" (Yuen et al.), "Engineering DevOps" (Gruver), Spinnaker docs.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [010-Architecture](../010-Architecture/) | Pipeline refleja arquitectura (monolito: un artefacto; microservicios: pipelines paralelos) |
| [011-DesignPatterns](../011-DesignPatterns/) | Pipeline como Chain of Responsibility, deployment strategies |
| [012-Testing](../012-Testing/) | Pruebas automatizadas se ejecutan dentro del pipeline |
| [013-DevOps](../013-DevOps/) | CI/CD es el núcleo técnico de DevOps |
| [015-Automation](../015-Automation/) | Pipelines como caso de automatización |
| [006-Containers](../006-Containers/) | Build de imágenes Docker en pipeline |
| [007-Orchestration](../007-Orchestration/) | Deploy a Kubernetes con GitOps |
| [009-Security](../009-Security/) | DevSecOps, security scanning, artifact signing |
| [031-AI](../031-AI/) | MLOps pipelines, AI-assisted CI/CD |

## Recursos recomendados

- **Libros**: "Continuous Delivery" (Humble, Farley), "The DevOps Handbook" (Kim, Humble, Debois, Willis), "GitHub Actions in Action" (Laster), "GitOps and Kubernetes" (Yuen et al.), "Jenkins 2: Up and Running" (Laster).
- **Cursos**: "GitHub Actions" (GitHub Learning Lab), "Continuous Integration and Continuous Delivery" (Coursera/UCDavis), "GitOps at Scale" (Codefresh), ArgoCD tutorials (Argo project).
- **Documentación**: docs.github.com/actions, docs.gitlab.com/ce/ci, argoproj.github.io/cd, fluxcd.io, jenkins.io/doc.
- **Herramientas**: act (local GitHub Actions), dive (image analysis), cosign (image signing), gitleaks (secrets), trivy (scanner), semgrep (SAST).
- **Práctica**: Crear CI/CD para proyecto open source, implementar ArgoCD en cluster K8s local, participar en hacktoberfest CI/CD improvements.

## Notas adicionales

La madurez CI/CD es un indicador clave de la eficiencia de entrega (DORA). Las organizaciones de alto rendimiento tienen CI/CD maduro: deploys múltiples al día con baja tasa de fallos. GitOps ha simplificado enormemente el CD en Kubernetes. El pipeline ideal es rápido (< 10 min), fiable (no flaky), y seguro. Las tendencias incluyen: AI-assisted CI/CD, platform engineering abstrae CI/CD como servicio interno, supply chain security (SLSA, Sigstore) se vuelve obligatorio por regulaciones.
