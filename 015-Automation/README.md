# 015-Automation: Automatización

## Descripción ampliada del dominio

La automatización de TI consiste en usar software para crear instrucciones y procesos repetitivos que reemplazan el trabajo manual en la gestión de infraestructura, despliegue de aplicaciones, operaciones de TI y procesos de negocio. Este módulo cubre automatización de infraestructura (provisionamiento, configuración), automatización de operaciones (monitoreo, incidentes, backup), automatización de procesos de negocio (BPM, workflows), scripting, y orquestación de herramientas. La evolución de la automatización ha ido de scripts manuales (shell, Perl, 1990s) a herramientas de configuración (Puppet, Chef, 2005-10), automatización cloud (Terraform, Ansible, 2012-15), automatización de contenedores (Docker Compose, K8s Operators, 2016-20), y automatización inteligente con IA (RPA inteligente, AIOps, auto-remediation, 2020+). El principio fundamental es: "si lo haces dos veces, automatízalo". La automatización reduce errores humanos, acelera procesos, libera tiempo del equipo para trabajo creativo, y proporciona consistencia y auditabilidad. Sin embargo, requiere inversión inicial y mantenimiento. El ROI de automatización se mide en tiempo ahorrado, reducción de errores y velocidad de entrega.

## Tabla de conceptos clave

| Concepto | Descripción | Herramientas/Frameworks |
|----------|-------------|------------------------|
| Provisionamiento | Creación automática de infraestructura | Terraform, CloudFormation, Pulumi |
| Configuration Management | Configuración y mantenimiento de sistemas existentes | Ansible, Puppet, Chef, SaltStack |
| Orquestación | Coordinación de múltiples tareas/sistemas automatizados | Airflow, Prefect, Temporal, Argo Workflows |
| Scripting | Automatización ad-hoc con lenguajes de scripting | Bash, Python, PowerShell, Groovy |
| Infraestructura como Código | Infraestructura gestionada con código (declarativo o imperativo) | Terraform, Pulumi, CDK, CloudFormation |
| Policy as Code | Políticas de negocio/seguridad expresadas como código | OPA (Rego), Kyverno, Sentinel |
| Configuration Drift | Desviación entre estado real y deseado de la configuración | Terraform plan, Ansible --diff, Puppet enforce |
| Idempotencia | Aplicar la misma operación múltiples veces produce el mismo resultado | Esencial en IaC y configuration management |
| Event-Driven Automation | Automatización desencadenada por eventos | AWS EventBridge, webhooks, Kafka triggers |
| Runbook Automation | Automatización de procedimientos operativos (playbooks) | Rundeck, Ansible Tower, FireHydrant |
| ChatOps | Automatización a través de comandos en chat | Hubot, Errbot, Mattermost slash commands |
| Self-Service Automation | Catálogo de acciones automatizadas para desarrolladores | Backstage scaffolder, ServiceNow |

## Tecnologías principales

| Herramienta | Tipo | Lenguaje | Declarativo/Imperativo | Estado | Propósito |
|-------------|------|----------|------------------------|--------|-----------|
| Ansible | Configuration Mgmt | YAML + Python | Declarativo | Stateless | Configuración de servidores, deploys |
| Terraform | IaC Provisioning | HCL | Declarativo | Stateful | Creación de infraestructura cloud |
| Pulumi | IaC Provisioning | Python/TS/Go | Declarativo | Stateful | Infraestructura con lenguajes reales |
| Bash/PowerShell | Scripting | Shell/PowerShell | Imperativo | Stateless | Automatización ad-hoc |
| Airflow | Workflow Orchestration | Python | DAGs | Stateful | ETL, pipelines de datos |
| Prefect | Workflow Orchestration | Python | DAGs | Stateful | Data pipelines modernos |
| Temporal | Workflow Orchestration | Go/Java/Python/TS | Workflow as Code | Stateful | Aplicaciones stateful duraderas |
| Puppet | Configuration Mgmt | Ruby DSL | Declarativo | Stateful | Configuración de servidores a escala |
| Chef | Configuration Mgmt | Ruby DSL | Declarativo | Stateful | Configuración de servidores |
| OPA | Policy as Code | Rego | Declarativo | Stateless | Policy decision para cualquier sistema |
| Rundeck | Runbook Automation | Java/YAML | Imperativo | Stateful | Automatización de operaciones |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos de automatización: qué automatizar (tareas manuales repetitivas), oportunidad vs esfuerzo. Scripting básico con Bash: variables, funciones, condicionales, bucles, procesamiento de texto (grep, awk, sed, jq). Automatización de tareas locales: backup, limpieza de logs, renombrado masivo de archivos, monitoreo básico (disk usage, uptime). Cron jobs y systemd timers para tareas programadas. Git hooks (pre-commit, pre-push) para automatizar linting/testing en commit. Automatización de deploys simples con scripts SSH + rsync/SCP. Variables de entorno y configuración por entorno.
   - Práctica: Script de backup automático con compresión y rotación. Git hook que corre linter antes de commit. Cron job que reporta health del sistema.
   - Lectura: "The Linux Command Line" (Shotts), Bash scripting guide (tldp.org).

2. **Intermedio (2-6 meses)**: Ansible: inventario (static/dynamic), playbooks (tasks, handlers, variables, templates, roles), módulos comunes (copy, template, service, package, file, command, shell, docker), facts, tags, conditionals, loops, vault para secrets. Terraform: provider configuration, resources, data sources, variables, outputs, state management (remote state, locking), modules, workspaces, HCL syntax. Integración Ansible + Terraform: Terraform provisiona infra, Ansible configura. Automatización de infraestructura: VPC, subnets, security groups, EC2/VM, S3 buckets, RDS. Configuration templates (Jinja2/Ansible templates) para configuración de apps. Workflow automation: Bash + Python scripts orquestados secuencialmente, Makefile como orchestrator de tareas de desarrollo. Automatización de API calls con curl/HTTPie y scripts. Error handling, logging y notificaciones en scripts automatizados.
   - Proyecto: Ansible playbook para configurar servidor web completo (nginx, certbot, app deploy). Terraform para crear infraestructura cloud + Ansible para configurarla.
   - Certificación: Red Hat Ansible Automation (EX374).
   - Lectura: "Ansible for DevOps" (Geerling), "Terraform: Up & Running" (Brikman).

3. **Avanzado (6-12 meses)**: Workflow orchestration: Airflow (DAGs, operators, sensors, tasks, dependencies, scheduling, retries, SLA, alerting), Prefect (flows, tasks, retries, caching, notifications), Temporal (workflows, activities, signal, query, retry, timer). Event-driven automation: AWS EventBridge (rules, event buses, targets), Kafka + Kafka Connect para automatización reactiva, webhooks (GitHub webhooks → automation). Policy as Code: OPA/Rego policies para Kubernetes (admission control), Terraform (validación), API authorization. ChatOps: integración de bots (Slack, Mattermost) con pipelines de automatización (comandos /deploy, /rollback, /status). Configuration drift detection y remediation: Terraform plan → apply automático, Ansible --diff, Puppet enforce, GitOps sync. Runbook automation: Rundeck (jobs, ACLs, notifications, ad-hoc commands), FireHydrant/SquadCast para incident response. Automatización de compliance: Inspec (Chef) profiles, AWS Config rules, Azure Policy. Python automation: Click/typer para CLI tools, requests para API, schedule para tareas, logging para logs estructurados.
   - Proyecto: Pipeline de datos ETL automatizado con Airflow/Prefect. Runbook de auto-remediation para incidentes comunes. ChatOps bot para deploy.
   - Lectura: "Automating DevOps" (Kumar), "Data Pipelines with Apache Airflow" (Harenslak, Rutter).

4. **Experto (12+ meses)**: AIOps: machine learning para automatización de operaciones, detección de anomalías, root cause analysis, predicción de fallos (capacity planning), auto-remediation inteligente. Self-healing infrastructure: auto-scaling reactivo y proactivo, automated incident response, rollback automático. RPA (Robotic Process Automation) integrado con automatización de TI: UiPath/Automation Anywhere bots que interactúan con sistemas legacy, combinado con APIs. Automation mesh: automatización federada multi-herramienta, unificación de plataformas (ServiceNow + Ansible + Terraform + Rundeck + AI). Automation metrics y governance: medición de ROI de automatización (tiempo ahorrado), catálogo de automatizaciones, approval workflows para automatizaciones críticas. Security automation: automated threat hunting (YARA, Sigma, Zeek), automated incident response playbooks (SOAR: Splunk SOAR, Palo Alto XSOAR), automated compliance evidence collection. Infrastructure as Code avanzado: CDK (AWS CDK patterns), Pulumi Automation API, Crossplane control planes. GitOps for infrastructure: Flux/ArgoCD sincronizando Terraform state además de apps.
   - Proyecto: SOAR playbooks para respuesta automática a incidentes. AI-driven auto-remediation pipeline. Internal automation platform como servicio.
   - Lectura: "Artificial Intelligence for DevOps" (Manandhar), "The AIOps Revolution", SOAR playbook best practices.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [004-OperatingSystems](../004-OperatingSystems/) | Scripting de shell, cron, systemd, tareas de sistema |
| [005-Cloud](../005-Cloud/) | IaC (Terraform, CloudFormation), cloud automation |
| [006-Containers](../006-Containers/) | Docker automation, container lifecycle |
| [007-Orchestration](../007-Orchestration/) | Kubernetes operators, controllers, CRDs |
| [009-Security](../009-Security/) | Security automation (SAST/DAST, vulnerability scanning) |
| [013-DevOps](../013-DevOps/) | DevOps automation core |
| [014-CICD](../014-CICD/) | CI/CD pipeline automation |
| [016-RPA](../016-RPA/) | RPA como automatización de procesos de negocio |
| [017-MFT](../017-MFT/) | Automatización de transferencia de archivos |
| [031-AI](../031-AI/) | AIOps, ML automation, automated decision making |

## Recursos recomendados

- **Libros**: "The Phoenix Project" (Kim) — novela sobre DevOps y automatización, "Ansible for DevOps" (Geerling), "Terraform: Up & Running" (Brikman, 3ª ed.), "Automating DevOps" (Kumar), "Data Pipelines with Apache Airflow" (Harenslak, Rutter).
- **Cursos**: Coursera "Automation" (Google IT Automation), Udemy "Ansible Advanced", "Terraform Wizardry", "Python Automation" (freeCodeCamp).
- **Herramientas principales**: Ansible (ansible.com), Terraform (terraform.io), Airflow (airflow.apache.org), Prefect (prefect.io), Temporal (temporal.io), OPA (openpolicyagent.org), Rundeck (rundeck.com).
- **Práctica**: Automatizar tareas diarias (backups, deploys, reportes), construir pipelines de datos, implementar ChatOps, auto-remediation playbooks.

## Notas adicionales

La automatización es un viaje, no un destino. Comenzar con scripts simples y evolucionar a herramientas más sofisticadas según necesidad. El mantra "automatizar todo" puede ser contraproducente: automatizar tareas inestables o poco frecuentes puede no valer la pena. La idempotencia es el principio más importante: una automatización debe poder ejecutarse múltiples veces con el mismo resultado. La documentación de automatizaciones es esencial (README en cada script/playbook). Las métricas permiten medir el éxito: tiempo ahorrado, errores evitados, velocidad de entrega.
