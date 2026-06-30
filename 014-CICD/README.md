# 014-CI/CD

## Descripción del dominio

CI/CD (Continuous Integration / Continuous Delivery o Deployment) es la práctica de automatizar las etapas de integración, prueba y despliegue del software para entregar cambios de forma rápida, segura y repetible. La integración continua (CI) consiste en fusionar el trabajo de todos los desarrolladores en una rama compartida varias veces al día, verificando cada integración mediante builds y pruebas automatizadas. La entrega continua (CD) extiende CI asegurando que el software pueda ser liberado a producción en cualquier momento, mientras que el despliegue continuo automatiza también la publicación en producción sin intervención manual.

## Conceptos clave

- **Integración Continua (CI)**: práctica donde cada commit se integra en la rama principal y se valida con un build automatizado y una suite de pruebas, detectando errores de integración de forma temprana.
- **Entrega Continua (CD)**: extensión de CI donde el software siempre está en un estado liberable; el despliegue a producción es un proceso manual pero trivial (un clic).
- **Despliegue Continuo**: cada cambio que pasa todas las etapas del pipeline se despliega automáticamente en producción sin intervención humana.
- **Pipeline**: serie de etapas automatizadas (lint, build, test, security scan, deploy) que ejecuta el código desde el commit hasta la producción.
- **Estrategias de despliegue**: rolling update, blue/green, canary, feature flags, A/B testing.
- **Artefacto**: paquete inmutable producido por el pipeline (JAR, Docker image, ZIP, binary) que se promueve a través de los entornos.
- **Versionado semántico (SemVer)**: sistema de versiones MAJOR.MINOR.PATCH que comunica el tipo de cambios realizados.
- **GitOps**: los pipelines son activados por cambios en repositorios Git; el estado deseado se declara en Git y un operador (ArgoCD, Flux) sincroniza el entorno.
- **Secretos**: credenciales, API keys y tokens gestionados de forma segura en el pipeline (HashiCorp Vault, GitHub Secrets, GitLab CI variables).
- **Trunk-Based Development**: flujo de trabajo donde los desarrolladores trabajan en ramas cortas y fusionan frecuentemente con la rama principal (trunk), evitando ramas largas.

## Tecnologías principales

- **Plataformas CI/CD**: GitHub Actions, GitLab CI/CD, Jenkins, CircleCI, Travis CI, Azure DevOps Pipelines, Bitbucket Pipelines, TeamCity.
- **GitOps**: ArgoCD, Flux CD, Harness, Codefresh.
- **Empaquetado y build**: Maven, Gradle, npm, pip, Docker BuildKit, Buildah, Bazel.
- **Registro de artefactos**: Docker Hub, Harbor, Artifactory, Nexus, AWS ECR, GitHub Packages.
- **Análisis y calidad**: SonarQube, ESLint, Checkstyle, PMD, Trivy, Snyk, OWASP Dependency-Check.
- **Estrategias de despliegue**: Spinnaker, Argo Rollouts, Flagger, Helm, Kustomize.
- **Feature Flags**: LaunchDarkly, Split, Flagsmith, Unleash.

## Hoja de ruta

1. **Principiante**: entender qué es un pipeline CI/CD y sus etapas básicas (lint, build, test); configurar un pipeline simple con GitHub Actions o GitLab CI; ejecutar pruebas unitarias y construir un artefacto; publicar el artefacto en un registro.
2. **Intermedio**: añadir stages de pruebas de integración y E2E; integrar análisis estático (linter, SonarQube) y de seguridad (SAST); configurar despliegues a entornos de staging y producción con estrategias rolling update; gestionar secretos de forma segura.
3. **Avanzado**: implementar GitOps con ArgoCD o Flux; diseñar pipelines con ejecución paralela y cacheo inteligente; integrar scans de seguridad de dependencias (SBOM) y de imágenes (Trivy); aplicar versionado semántico automático y changelog generado.
4. **Experto**: optimizar tiempos de pipeline con test sharding, paralelismo y build caching distribuido; implementar despliegues canary con análisis de métricas (Flagger, Argo Rollouts); diseñar plataformas internas de CI/CD autoservicio; establecer governance y compliance automatizados en el pipeline.

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — la topología del pipeline refleja la arquitectura (monolito: un solo artefacto; microservicios: múltiples pipelines paralelos).
- [011-DesignPatterns](../011-DesignPatterns/) — patrones como Pipeline (Chain of Responsibility) y Strategy se usan para diseñar stages configurables.
- [012-Testing](../012-Testing/) — todas las pruebas automatizadas se ejecutan dentro del pipeline; la calidad del pipeline depende de la calidad y velocidad de las pruebas.
- [013-DevOps](../013-DevOps/) — CI/CD es el núcleo técnico de DevOps; la cultura DevOps proporciona el contexto organizacional para la automatización.
- [015-Automation](../015-Automation/) — los pipelines son en sí mismos un caso de automatización; Ansible y scripts se integran como stages.
- [016-RPA](../016-RPA/) — los bots RPA pueden integrarse en pipelines para pruebas o despliegue de configuraciones.
- [017-MFT](../017-MFT/) — la transferencia de artefactos entre entornos puede usar protocolos MFT con seguridad y trazabilidad.
- [018-ERP](../018-ERP/) — los pipelines despliegan configuraciones, parches y personalizaciones en sistemas ERP.
- [019-CRM](../019-CRM/) — los pipelines despliegan metadata de CRM, paquetes gestionados y flujos de Power Automate.

## Recursos recomendados

- *Continuous Delivery* — Jez Humble, David Farley
- *Continuous Integration* — Paul Duvall, Steve Matyas, Andrew Glover
- *The DevOps Handbook* — Gene Kim, Jez Humble, Patrick Debois, John Willis
- *Learning GitHub Actions* — Brent Laster
- *GitOps and Kubernetes* — Billy Yuen, Alexander Matyushentsev, Todd Ekenstam, Jesse Suen
- *Jenkins 2: Up and Running* — Brent Laster
- *ArgoCD in Practice* — John Prophet
- *Pro Git* (capítulo sobre Git hooks y automatización) — Scott Chacon, Ben Straub
