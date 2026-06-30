# 013-DevOps

## Descripción del dominio

DevOps es un conjunto de prácticas, principios y herramientas que integran los equipos de desarrollo (Dev) y operaciones (Ops) para acortar el ciclo de vida del desarrollo de software y entregar características, correcciones y actualizaciones con alta frecuencia, confiabilidad y calidad. Se basa en la automatización continua, la colaboración cultural, la medición de todo el flujo de valor y el aprendizaje constante. Disciplinas como SRE (Site Reliability Engineering) y GitOps extienden estos principios con acuerdos de nivel de servicio (SLIs/SLOs/SLAs) y operaciones declarativas basadas en repositorios Git.

## Conceptos clave

- **Cultura DevOps**: colaboración, responsabilidad compartida, propiedad de extremo a extremo, eliminación de silos entre desarrollo y operaciones.
- **Infraestructura como Código (IaC)**: gestión y aprovisionamiento de infraestructura (servidores, redes, balanceadores) mediante archivos de configuración declarativos o imperativos versionados en Git.
- **SRE (Site Reliability Engineering)**: disciplina que aplica principios de ingeniería de software a la gestión de infraestructura, definiendo SLOs, presupuestos de error (error budgets) y automatizando la remediación.
- **GitOps**: modelo operativo donde Git es la única fuente de verdad para la infraestructura y las aplicaciones; los cambios se realizan mediante pull requests y se sincronizan automáticamente.
- **Observabilidad**: capacidad de inferir el estado interno de un sistema a partir de sus salidas externas (métricas, logs, trazas). Pilares: métricas, logging y tracing distribuido.
- **Contenerización**: empaquetado de aplicaciones con sus dependencias en contenedores ligeros y portátiles (Docker, containerd).
- **Orquestación**: gestión automatizada del despliegue, escalado, redes y disponibilidad de contenedores (Kubernetes, Docker Swarm, Nomad).
- **Pipeline CI/CD**: automatización de la integración, prueba y despliegue de código como una tubería de etapas secuenciales o paralelas.
- **Monitorización**: recolección y visualización de métricas del sistema en tiempo real (Prometheus, Grafana, Datadog).
- **Gestión de configuración**: herramientas para asegurar que los sistemas mantengan un estado deseado (Ansible, Puppet, Chef, SaltStack).

## Tecnologías principales

- **Contenedores**: Docker, Podman, containerd, Buildah
- **Orquestación**: Kubernetes, OpenShift, Rancher, Nomad, Docker Swarm
- **IaC**: Terraform, Pulumi, AWS CDK, CloudFormation, Bicep
- **Configuración**: Ansible, Puppet, Chef, SaltStack
- **Observabilidad**: Prometheus, Grafana, Loki, Jaeger, OpenTelemetry, Datadog, New Relic, ELK Stack
- **CI/CD**: Jenkins, GitLab CI, GitHub Actions, ArgoCD, Tekton, Spinnaker
- **Gestión de secretos**: HashiCorp Vault, AWS Secrets Manager, SOPS, Sealed Secrets
- **Registro de contenedores**: Docker Hub, Harbor, ECR, GCR, ACR, Nexus, Artifactory
- **Malla de servicios**: Istio, Linkerd, Consul Connect, Kuma

## Hoja de ruta

1. **Principiante**: entender la cultura DevOps y sus beneficios; aprender los comandos básicos de Linux, redes y scripting (Bash); usar Docker para contenerizar aplicaciones; conocer Git y flujos de trabajo colaborativos (trunk-based, feature branches).
2. **Intermedio**: configurar pipelines CI/CD básicos con GitHub Actions o GitLab CI; automatizar infraestructura con Terraform; gestionar configuraciones con Ansible; implementar monitorización básica con Prometheus y Grafana.
3. **Avanzado**: desplegar y gestionar clústeres Kubernetes en producción; implementar GitOps con ArgoCD o Flux; aplicar principios SRE (SLOs, error budgets, runbooks); configurar observabilidad completa (métricas + logs + trazas) con OpenTelemetry.
4. **Experto**: diseñar plataformas internas (IDP) con Backstage; implementar seguridad en toda la cadena (DevSecOps: SAST, DAST, SBOM, firma de imágenes); optimizar costos en la nube (FinOps); automatizar políticas de compliance y remediación.

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — la arquitectura determina cómo se despliega, escala y monitorea el sistema.
- [011-DesignPatterns](../011-DesignPatterns/) — patrones de despliegue (Blue/Green, Canary, Circuit Breaker) son parte del repertorio DevOps.
- [012-Testing](../012-Testing/) — las pruebas automatizadas son el corazón de los pipelines CI/CD y la calidad en DevOps.
- [014-CICD](../014-CICD/) — CI/CD es el brazo ejecutor de la automatización DevOps; DevOps proporciona el contexto cultural y organizacional.
- [015-Automation](../015-Automation/) — toda la práctica DevOps es automatización: provisionar, configurar, desplegar, monitorizar.
- [017-MFT](../017-MFT/) — la transferencia de archivos se integra en pipelines automatizados con controles de seguridad.
- [018-ERP](../018-ERP/) — los pipelines DevOps despliegan cambios en módulos ERP y gestionan la configuración del entorno.
- [019-CRM](../019-CRM/) — la integración continua aplica a personalizaciones de CRM, paquetes gestionados y migraciones de datos.

## Recursos recomendados

- *The DevOps Handbook* — Gene Kim, Jez Humble, Patrick Debois, John Willis
- *Site Reliability Engineering* — Betsy Beyer, Chris Jones, Jennifer Petoff, Niall Richard Murphy
- *Accelerate: The Science of Lean Software and DevOps* — Nicole Forsgren, Jez Humble, Gene Kim
- *Infrastructure as Code* — Kief Morris
- *Cloud Native DevOps with Kubernetes* — John Arundel, Justin Domingus
- *Terraform: Up & Running* — Yevgeniy Brikman
- *GitOps and Kubernetes* — Billy Yuen, Alexander Matyushentsev, Todd Ekenstam, Jesse Suen
- *The Phoenix Project* — Gene Kim, Kevin Behr, George Spafford
- *Kubernetes in Action* — Marko Lukša
