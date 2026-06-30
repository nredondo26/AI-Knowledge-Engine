# 015-Automation

## Descripción del dominio

La automatización general de TI abarca el uso de software, scripts y herramientas para ejecutar tareas repetitivas, reducir el error humano, acelerar procesos y liberar tiempo del equipo para trabajo de mayor valor. Incluye desde scripts simples en Bash o PowerShell hasta sistemas complejos de orquestación con herramientas como Ansible, Puppet, Chef y plataformas de automatización de procesos. Se aplica en aprovisionamiento de servidores, configuración de sistemas, despliegues, backups, monitoreo, cumplimiento normativo y respuesta a incidentes.

## Conceptos clave

- **Scripting**: automatización mediante lenguajes interpretados (Bash, Python, PowerShell, Perl) para tareas ad-hoc, manipulación de archivos, ejecución de comandos remotos y transformación de datos.
- **Gestión de configuración**: herramientas declarativas o imperativas que aseguran que los sistemas mantengan un estado deseado (paquetes instalados, servicios iniciados, archivos de configuración correctos) de forma consistente y repetible.
- **Orquestación**: coordinación de múltiples tareas automatizadas en un flujo de trabajo secuencial o paralelo, a menudo involucrando múltiples sistemas o servicios.
- **Infraestructura como Código (IaC)**: gestión de recursos de infraestructura mediante definiciones declarativas (Terraform, CloudFormation, Pulumi) que pueden ser versionadas, revisadas y reutilizadas.
- **Runbook**: documentación de procedimientos operativos que se automatizan progresivamente (crecimiento desde runbooks manuales a runbooks automatizados).
- **Automatización reactiva**: scripts o workflows que se disparan automáticamente en respuesta a eventos (webhooks, alertas, cambios en repositorios).
- **Automatización programada**: tareas ejecutadas en intervalos regulares (cron, schedulers empresariales) como backups, reportes y sincronizaciones.
- **ChatOps**: integración de herramientas de automatización con plataformas de chat (Slack, Teams) para ejecutar comandos y recibir notificaciones en contexto.
- **Automatización de procesos (no RPA)**: orquestación de flujos de trabajo entre sistemas mediante APIs, colas de mensajes y middlewares, sin intervención humana.

## Tecnologías principales

- **Scripting**: Bash, Python, PowerShell, Perl, Ruby, Go
- **Gestión de configuración**: Ansible, Puppet, Chef, SaltStack
- **IaC**: Terraform, Pulumi, AWS CloudFormation, Azure Resource Manager (Bicep), Google Deployment Manager
- **Orquestación de workflows**: Apache Airflow, Prefect, Dagster, Luigi, Jenkins, StackStorm
- **Programación de tareas**: cron, systemd timers, Windows Task Scheduler, Azure Automation, AWS Lambda + CloudWatch Events
- **ChatOps**: Hubot, Errbot, StackStorm, AWS Chatbot, Slack/Teams webhooks
- **Gestión de secretos**: HashiCorp Vault, CyberArk, AWS Secrets Manager, Azure Key Vault
- **Automatización de red**: Ansible Network, NAPALM, Cisco NSO, Netmiko

## Hoja de ruta

1. **Principiante**: aprender scripting básico en Bash y Python; automatizar tareas locales (backups, limpieza de logs, renombrado de archivos); usar cron para programar ejecuciones; escribir scripts parametrizables y reutilizables.
2. **Intermedio**: usar Ansible para gestionar configuración de servidores (playbooks, roles, inventarios); introducir Terraform para provisionar recursos en la nube; orquestar flujos de trabajo con Airflow o Prefect; integrar scripts con APIs REST.
3. **Avanzado**: diseñar sistemas de automatización auto-remediantes (control loops); implementar pipelines de automatización completos que abarquen provisionamiento, configuración, despliegue y tests; usar GitOps para gestionar la automatización como código.
4. **Experto**: construir una plataforma interna de automatización (Internal Developer Platform); implementar políticas de compliance automatizadas (policy as code con OPA/Rego); diseñar sistemas de auto-escalado y auto-reparación; mentorizar equipos en cultura de automatización.

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — la automatización se alinea con los principios arquitectónicos de desacoplamiento y repetibilidad.
- [011-DesignPatterns](../011-DesignPatterns/) — patrones como Command, Strategy, Template Method y Observer se usan para diseñar frameworks de automatización flexibles.
- [012-Testing](../012-Testing/) — automatización de ejecución de pruebas, generación de reportes y verificación de resultados.
- [013-DevOps](../013-DevOps/) — la automatización es el pilar técnico de DevOps; casi toda práctica DevOps es automatización aplicada.
- [014-CICD](../014-CICD/) — los pipelines CI/CD son un caso concreto de automatización: build, test, deploy.
- [016-RPA](../016-RPA/) — la automatización general (scripts, Ansible) y la RPA son complementarias; RPA automatiza la interacción con interfaces de usuario, mientras que la automatización general trabaja a nivel de sistema y red.
- [017-MFT](../017-MFT/) — la automatización de transferencias de archivos (trigger, transformación, notificación) se integra con herramientas de orquestación.
- [018-ERP](../018-ERP/) — automatización de procesos de negocio en ERP (integraciones, reportes periódicos, sincronización de datos maestros).
- [019-CRM](../019-CRM/) — automatización de campañas, scoring de leads, sincronización de contactos y workflows de ventas.

## Recursos recomendados

- *Ansible: Up and Running* — Lorin Hochstein, René Moser
- *Terraform: Up & Running* — Yevgeniy Brikman
- *Infrastructure as Code* — Kief Morris
- *Python for DevOps* — Noah Gift, Kennedy Behrman, Alfredo Deza, Grig Gheorghiu
- *Automate the Boring Stuff with Python* — Al Sweigart
- *Learning PowerShell* — Jonathan Hassell
- *Apache Airflow Documentation* — airflow.apache.org
- *The Phoenix Project* (automatización en contexto empresarial) — Gene Kim
