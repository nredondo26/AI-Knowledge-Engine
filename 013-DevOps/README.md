# 013-DevOps: DevOps

## Descripción ampliada del dominio

DevOps es un conjunto de prácticas, principios culturales y herramientas que integran el desarrollo de software (Dev) y las operaciones de TI (Ops) para acortar el ciclo de vida del desarrollo, entregar software de alta calidad de forma continua y reducir el tiempo desde el commit hasta la producción. El término nació en 2009 (Patrick Debois) como respuesta a la brecha entre desarrollo y operaciones. El manifiesto DevOps enfatiza: cultura, automatización, medición y compartición (CAMS). Las prácticas clave incluyen integración continua (CI), entrega continua (CD), infraestructura como código (IaC), GitOps, monitoreo y observabilidad, gestión de incidentes, y blameless postmortems. El modelo de madurez DevOps de DORA (DevOps Research and Assessment, adquirido por Google) define métricas clave: deployment frequency, lead time for changes, mean time to recovery (MTTR), and change failure rate. El estado de la industria (DORA 2023) muestra que los equipos de élite despliegan múltiples veces al día con lead time de minutos y MTTR de horas. Las tendencias actuales incluyen Platform Engineering (IDP: Internal Developer Platform), DevEx (Developer Experience), y AIOps (DevOps con IA).

## Tabla de conceptos clave

| Concepto | Descripción | Herramientas/Estándares |
|----------|-------------|------------------------|
| Integración Continua (CI) | Fusionar código frecuentemente y validar con build + tests | GitHub Actions, GitLab CI, Jenkins |
| Entrega Continua (CD) | Software siempre en estado liberable, deploy manual o automático | ArgoCD, Flux, Spinnaker, GitHub Actions |
| Infraestructura como Código (IaC) | Gestionar infraestructura con código declarativo | Terraform, CloudFormation, Pulumi, CDK |
| Configuration Management | Gestión y automatización de configuración de servidores | Ansible, Puppet, Chef, SaltStack |
| GitOps | Git como fuente única de verdad para infraestructura y apps | ArgoCD, Flux CD, Azure DevOps GitOps |
| Observabilidad | Entender el estado del sistema a través de datos de telemetría | Prometheus, Grafana, OpenTelemetry, ELK |
| Site Reliability Engineering | Ingeniería de confiabilidad aplicada a sistemas de producción | SLO/SLI/SLA, error budget, SLI monitoring |
| Platform Engineering | Creación de IDP (Internal Developer Platform) para equipos de dev | Backstage (Spotify), Port, Humanitec |
| DevSecOps | Seguridad integrada en todo el ciclo DevOps | SAST/DAST/SCA en pipeline, secrets scanning |
| Blameless Postmortem | Análisis post-incidente sin culpar, enfocado en mejora de sistemas | Documentación, seguimiento de acciones |
| Chaos Engineering | Experimentar con fallos controlados para mejorar resiliencia | Chaos Mesh, Litmus, Gremlin |
| Value Stream Mapping | Mapeo del flujo de valor desde idea hasta producción | Optimización de procesos, identificación de cuellos de botella |

## Tecnologías principales

| Área | Herramientas | Propósito |
|------|-------------|-----------|
| CI/CD | GitHub Actions, GitLab CI/CD, Jenkins X, CircleCI, ArgoCD, Flux | Automatización de builds, tests, despliegues |
| IaC Provisioning | Terraform, OpenTofu, Pulumi, AWS CDK, Azure Bicep | Creación de infraestructura cloud |
| IaC Configuration | Ansible, Puppet, SaltStack, Chef | Configuración de servidores existentes |
| Contenedores | Docker, Podman, containerd | Empaquetado de aplicaciones |
| Orquestación | Kubernetes, Docker Swarm, Nomad | Gestión de contenedores en producción |
| Monitoreo | Prometheus, Grafana, Datadog, New Relic, Dynatrace | Métricas, dashboards, alertas |
| Logging | ELK (Elastic, Logstash, Kibana), Loki, Splunk, Graylog | Centralización y análisis de logs |
| Tracing | Jaeger, Tempo, Zipkin, OpenTelemetry | Seguimiento de requests distribuidas |
| Service Mesh | Istio, Linkerd, Cilium, Consul | Comunicación, seguridad, observabilidad |
| Secret Management | HashiCorp Vault, AWS Secrets Manager, SOPS | Gestión segura de credenciales |
| Container Registry | Docker Hub, Harbor, ECR, GCR, ACR | Almacenamiento de imágenes |
| Package Management | Helm, Kustomize, apt, yum, chocolatey | Gestión de paquetes y chart K8s |
| Feature Flags | LaunchDarkly, Flagsmith, Unleash | Despliegue controlado, A/B testing |
| Incident Management | PagerDuty, Opsgenie, FireHydrant, Incident.io | Gestión de alertas e incidentes |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos DevOps: cultura, automatización, métricas, compartición. DORA metrics: deployment frequency, lead time, MTTR, change failure rate — qué miden y por qué importan. CI/CD básico: crear pipeline simple con GitHub Actions (lint → build → test → deploy a staging). Git: branching strategies (GitHub Flow, Git Flow, trunk-based), pull requests, code review. Infraestructura como código (IaC): Terraform básico (resources, variables, outputs, state, providers). Contenedores: Dockerfile, docker-compose para desarrollo local. Monitoreo básico: Prometheus (metrics endpoints), Grafana (dashboards básicos).
   - Proyecto: Pipeline CI/CD de app web simple. Terraform para crear VM en cloud. Docker Compose para stack local.
   - Lectura: "The DevOps Handbook" (Kim, Humble, Debois, Willis), DORA State of DevOps Report.

2. **Intermedio (3-8 meses)**: GitOps: ArgoCD (Application, Sync Policy, Auto-heal, Sync Waves), Git como single source of truth, cluster state reconciliation. Infrastructure as Code avanzado: Terraform modules, remote state (S3/Terraform Cloud), workspaces, Terraform apply automation. Configuration management: Ansible (playbooks, roles, inventory, vars, templates, handlers, tags), Ansible Tower/AWX. Secret management: HashiCorp Vault (KV, dynamic secrets, approle, transit engine), SOPS (encrypt in Git). Observabilidad: Prometheus (service discovery, alerting rules, PromQL basics), Grafana (dashboards avanzados, alerting, annotations), structured logging (JSON format, log levels, correlation IDs). SRE: SLIs (Service Level Indicators), SLOs (Service Level Objectives), Error Budgets, burn rate alerts. CI/CD avanzado: parallel stages, caching, artifact management, security scanning.
   - Proyecto: GitOps con ArgoCD + Kustomize. Ansible roles para configurar servidores. Prometheus + Grafana para monitoreo completo.
   - Certificación: HashiCorp Terraform Associate, Red Hat Ansible Automation, AWS DevOps Engineer.

3. **Avanzado (8-14 meses)**: Platform Engineering: diseño de Internal Developer Platform (IDP) con Backstage (Spotify), Port, Humanitec. Developer portals: Backstage (entity types, plugins: techdocs, catalog, scaffolder, kubernetes). Service Mesh: Istio (Envoy proxy, traffic management, mTLS, authorization policies, telemetry). Multi-cluster Kubernetes: service mesh mesh, cluster-api, federation. Observabilidad avanzada: OpenTelemetry (traces, metrics, logs, OTLP, auto-instrumentation), distributed tracing con Jaeger/Tempo, RED (Rate, Errors, Duration) + USE (Utilization, Saturation, Errors) metrics. AIOps: ML-based anomaly detection, automated root cause analysis, AI for incident response. Chaos Engineering: Chaos Mesh (experiments, schedules), Litmus, steady state hypothesis, blast radius. Cost optimization: FinOps (FinOps.org), cloud cost management, showback/chargeback, commitment discounts (RIs, SPP). Policy as Code: OPA (Rego), Kyverno, Sentinel (HashiCorp). Migration strategies: Strangler Fig, Blue/Green, Canary, feature flags, database migrations.
   - Proyecto: IDP con Backstage + internal CI/CD templates. Service mesh multi-cluster. Chaos Engineering experiment pipeline.
   - Certificación: CKS (Kubernetes Security), AWS DevOps Engineer Professional, Google Cloud DevOps Engineer.

4. **Experto (14+ meses)**: DevSecOps avanzado: SBOM con CycloneDX/SPDX, SLSA (Supply chain Levels for Software Artifacts), Sigstore (Cosign, Fulcio, Rekor), in-toto attestations, compliance as code (Inspec, AWS Config rules). GitOps at scale: ApplicationSets (generators: cluster, git, list, matrix, merge), Progressive Delivery (Flagger, Argo Rollouts). AI/ML in DevOps: ML model deployment pipelines (Kubeflow, Kserve, BentoML), MLOps (MLflow, DVC, Feast, Weights & Biases). FinOps Automation: commitment-based discount optimization (RI, Savings Plans), spot instance automation, resource rightsizing automation. Productivity engineering: DORA metrics automation, value stream management, team topologies (Conway's Law aplicado). Security compliance automation: SOC 2 compliance as code, PCI DSS automation, HIPAA compliance monitoring. Site Reliability Engineering: capacity planning, performance modeling, fault domain analysis, failure modes and effects analysis (FMEA). Self-healing systems: automated rollback, auto-scaling, auto-remediation runbooks, ChatOps. GreenOps: sustainability in DevOps, carbon-aware computing, energy-efficient deployments.
   - Proyecto: SLSA Level 3 pipeline con Sigstore. Compliance as code framework. MLOps platform on Kubernetes.
   - Certificación: Google Cloud Professional DevOps Engineer, AWS DevOps Engineer Professional, HashiCorp Vault Associate.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [004-OperatingSystems](../004-OperatingSystems/) | Gestión de servidores, systemd, procesos |
| [005-Cloud](../005-Cloud/) | Cloud como infraestructura, servicios managed |
| [006-Containers](../006-Containers/) | Contenedores como unidad de empaquetado |
| [007-Orchestration](../007-Orchestration/) | Kubernetes para orquestación y GitOps |
| [009-Security](../009-Security/) | DevSecOps, seguridad en pipeline |
| [010-Architecture](../010-Architecture/) | Arquitectura para DevOps, microservicios |
| [012-Testing](../012-Testing/) | Pruebas automatizadas en pipeline, calidad |
| [014-CICD](../014-CICD/) | Core de automatización CI/CD |
| [015-Automation](../015-Automation/) | Automatización de infraestructura y config |
| [031-AI](../031-AI/) | AIOps, ML pipelines, MLOps |

## Recursos recomendados

- **Libros**: "The DevOps Handbook" (Kim, Humble, Debois, Willis), "Accelerate" (Forsgren, Humble, Kim), "Site Reliability Engineering" (Beyer et al., Google), "The Phoenix Project" (Kim) — novela DevOps, "Continuous Delivery" (Humble, Farley), "Infrastructure as Code" (Morris, 2ª ed.).
- **Cursos**: Coursera "DevOps Culture and Mindset" (UCDavis), "DevOps on AWS" specialization, Azure DevOps Engineer (AZ-400), "GitOps at Scale" (ArgoCD course), Linux Foundation DevOps training.
- **Práctica**: DORA Quick Check (dora.dev), Instalar y configurar ArgoCD + Kustomize, Backstage local deployment, Terraform + Ansible automation.
- **Comunidad**: DevOpsDays conferences, DevOpsTopologies.com, TeamTopologies, State of DevOps Report (DORA), CNCF newsletters.

## Notas adicionales

DevOps es primero cultura y luego herramientas. El cambio cultural (colaboración, confianza, responsabilidad compartida) es más difícil que adoptar herramientas. Las métricas DORA correlacionan con performance organizacional. Platform Engineering es la evolución natural para escalar DevOps. El camino DevOps típico: CI/CD → IaC → GitOps → Observabilidad → SRE → Platform Engineering. La automatización debe ser gradual y medible, no un fin en sí mismo.
