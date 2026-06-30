# 005-Cloud: Computación en la Nube

## Descripción ampliada del dominio

La computación en la nube es el modelo de entrega de recursos de TI (servidores, almacenamiento, bases de datos, redes, software, análisis e inteligencia) a través de Internet con pago por uso. Este módulo cubre los tres proveedores principales (AWS, Azure, GCP), los modelos de servicio (IaaS, PaaS, SaaS, FaaS), arquitecturas cloud nativas, costos, seguridad, cumplimiento normativo y mejores prácticas. La nube elimina la necesidad de invertir en hardware upfront, permitiendo escalar desde cero a millones de usuarios. Los tres hiperescaladores (AWS desde 2006, Azure desde 2010, GCP desde 2008) compiten con más de 200 servicios cada uno, mientras proveedores regionales y alternativas (DigitalOcean, Linode, Vultr, Hetzner) ofrecen opciones más simples y económicas. La adopción cloud ha pasado de "lift and shift" (migrar servidores on-premise a VMs cloud) a cloud-native architectures (microservicios, contenedores, serverless, managed services). La tendencia actual incluye multi-cloud, edge computing, FinOps (gestión de costos cloud), y plataformas internas de desarrolladores (IDP) que abstraen la complejidad cloud.

## Tabla de conceptos clave

| Concepto | Descripción | Ejemplo AWS | Ejemplo Azure | Ejemplo GCP |
|----------|-------------|-------------|---------------|-------------|
| IaaS | Infraestructura como servicio: VMs, storage, redes | EC2, EBS, VPC | Azure VMs, Managed Disks | Compute Engine, Persistent Disk |
| PaaS | Plataforma como servicio: runtime gestionado | Elastic Beanstalk, RDS | App Service, Azure SQL | App Engine, Cloud SQL |
| SaaS | Software como servicio: aplicación completa | WorkDocs, Chime | Office 365, Dynamics 365 | Workspace, Gmail |
| FaaS | Function as a Service: código en respuesta a eventos | Lambda | Azure Functions | Cloud Functions |
| CaaS | Containers as a Service: orquestación gestionada | ECS, EKS | AKS | GKE |
| VPC/VNet | Red virtual aislada en la nube | VPC | Virtual Network | VPC |
| Object Storage | Almacenamiento de objetos escalable y duradero | S3 | Blob Storage | Cloud Storage |
| CDN | Content Delivery Network para contenido estático | CloudFront | Azure CDN | Cloud CDN |
| Load Balancer | Distribución de tráfico entre instancias | ELB/ALB/NLB | Load Balancer | Cloud Load Balancing |
| Auto Scaling | Escalado automático según métricas | Auto Scaling Groups | VM Scale Sets | MIG |
| DNS | Sistema de nombres de dominio gestionado | Route 53 | Azure DNS | Cloud DNS |
| Managed DB | Bases de datos como servicio gestionado | RDS, Aurora, DynamoDB | Azure SQL, Cosmos DB | Cloud SQL, Spanner, Bigtable |
| Serverless | Ejecución sin gestionar servidores | Lambda + API Gateway | Functions + API Management | Cloud Functions + API Gateway |

## Tecnologías principales

| Servicio | AWS | Azure | GCP | Tipo | Caso de uso |
|----------|-----|-------|-----|------|-------------|
| Cómputo | EC2, Lambda, ECS/EKS, Fargate | VMs, Functions, AKS, Container Instances | Compute Engine, Cloud Functions, GKE, Cloud Run | Cómputo | Aplicaciones, microservicios, batch |
| Almacenamiento | S3, EBS, EFS, Glacier | Blob, Disk, Files, Archive | Cloud Storage, Persistent Disk, Filestore | Almacenamiento | Objetos, bloques, archivos, backup |
| Base de datos | RDS, Aurora, DynamoDB, ElastiCache | SQL, Cosmos DB, Redis Cache | Cloud SQL, Spanner, Bigtable, Memorystore | Bases de datos | Relacional, NoSQL, caché |
| Redes | VPC, CloudFront, Route 53, Direct Connect | VNet, CDN, DNS, ExpressRoute | VPC, Cloud CDN, Cloud DNS, Interconnect | Redes | Conectividad, CDN, DNS |
| Seguridad | IAM, KMS, Shield, WAF, GuardDuty | Entra ID, Key Vault, DDoS Protection, WAF | IAM, Cloud KMS, Cloud Armor, Security Command Center | Seguridad | Identidad, cifrado, protección |
| Monitoreo | CloudWatch, X-Ray, Config | Monitor, Application Insights, Policy | Cloud Monitoring, Trace, Config, Audit Log | Observabilidad | Métricas, logs, tracing |
| ML/AI | SageMaker, Bedrock, Rekognition | Azure ML, OpenAI Service, Cognitive | Vertex AI, AutoML, Gemini API | Machine Learning | Modelos, IA generativa, visión |
| Analytics | Athena, EMR, Redshift, Kinesis | Synapse, HDInsight, Stream Analytics | BigQuery, Dataproc, Dataflow, Pub/Sub | Datos | Queries, ETL, streaming, BI |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales de cloud computing: IaaS, PaaS, SaaS, nube pública/privada/híbrida. Crear cuenta AWS/Azure/GCP (free tier). Cómputo básico: lanzar VM (EC2, Compute Engine), conectar SSH, instalar software. Almacenamiento de objetos: S3/Cloud Storage, crear buckets, subir/descargar archivos, políticas de acceso. Base de datos gestionada: RDS/Cloud SQL, crear instancia, conectar desde app. Red básica: VPC/VNet, subredes públicas/privadas, security groups/firewall rules, Internet Gateway. Facturación y costos: entender free tier, calculadora de costos, presupuestos y alertas.
   - Proyecto: Desplegar app web simple (WordPress, Node.js) en VM. Sitio estático en S3/Cloud Storage con CloudFront/CDN.
   - Certificación: AWS Cloud Practitioner, Azure Fundamentals (AZ-900), Google Cloud Digital Leader.

2. **Intermedio (3-8 meses)**: Alta disponibilidad y escalabilidad: Auto Scaling Groups, Load Balancers (ALB/GLB), Multi-AZ. Serverless: AWS Lambda/Azure Functions/Cloud Functions con triggers (S3, HTTP, DynamoDB). API Gateway / Cloud Endpoints. Contenedores: ECS con Fargate / Cloud Run / ACI — desplegar app containerizada sin gestionar servidores. Bases de datos NoSQL: DynamoDB/Cosmos DB/Firestore. DNS: Route 53 / Azure DNS / Cloud DNS con routing policies (failover, latency, weighted, geolocation). CI/CD cloud-native: CodePipeline + CodeBuild / GitHub Actions + deploy automation. CloudFormation/Terraform: IaC básico para gestionar infraestructura. IAM (Identity and Access Management): usuarios, grupos, roles, políticas, mejores prácticas de least privilege.
   - Proyecto: API serverless con Lambda + API Gateway + DynamoDB + Cognito/DynamoDB Auth. Microservicio containerizado en ECS Fargate con CI/CD.
   - Certificación: AWS Solutions Architect Associate, Azure Administrator (AZ-104), Google Associate Cloud Engineer.

3. **Avanzado (8-14 meses)**: Arquitecturas cloud nativas: microservicios con service mesh (Istio, App Mesh, Linkerd), event-driven architectures (EventBridge, Eventarc, Event Grid). Data analytics: BigQuery/Redshift/Synapse — data warehousing, ETL con Glue/Dataflow/ADF. Streaming: Kinesis/Pub-Stream/Event Hubs + Flink/Spark Streaming. ML en cloud: SageMaker/Vertex AI/Azure ML (pipelines, training, deployment). Multi-cloud y hybrid cloud: Azure Arc, AWS Outposts, Google Anthos. FinOps: cost optimization (reserved instances, savings plans, spot instances), tagging strategy, resource rightsizing. Well-Architected Framework: AWS Well-Architected, Azure Well-Architected, GCP Architecture Framework. Disaster Recovery: RTO/RPO, backup strategies, cross-region replication, pilot light, warm standby, multi-site active-active. Networking avanzado: Transit Gateway, VPC peering, PrivateLink, VPN, Direct Connect/ExpressRoute/Interconnect, egress optimization, NAT gateways.
   - Proyecto: Arquitectura multi-región activa-activa. Pipeline de datos streaming con analytics en tiempo real. ML pipeline completo.
   - Certificación: AWS Solutions Architect Professional, Azure Solutions Architect (AZ-305), Google Professional Cloud Architect.

4. **Experto (14+ meses)**: Cloud security: SIEM (Splunk, Sentinel, Chronicle), CSPM (AWS Security Hub, Azure Defender, GCP SCC), Cloud IAM avanzado (ABAC, SCP, policy as code). Compliance: SOC 2, PCI DSS, HIPAA, FedRAMP, ISO 27001 — implementación en cloud. Landing zones: AWS Control Tower, Azure Landing Zone, GCP Enterprise Foundations. Service mesh y advanced networking: eBPF-based security, Cilium, network policies. Cloud cost governance: showback/chargeback, anomaly detection, commitment-based discounts, savings plans optimization. Containers y serverless a escala: bin packing, cold start optimization, provisioned concurrency, custom runtimes. Edge computing: CloudFront Functions/Lambda@Edge, Cloudflare Workers, Google Edge. Multi-cloud service mesh, federation. Confidential computing: AMD SEV-SNP, Intel TDX, AWS Nitro Enclaves, Azure Confidential Computing.
   - Práctica: Diseñar landing zone multi-account. Implementation de soc compliance automation. Optimización de costos multi-cloud de $1M+/año.
   - Certificación: Todas las Professional + Specialty (AWS Security, Data Analytics, Networking, ML).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | DBaaS gestionado en cloud (RDS, Cloud SQL, DynamoDB) |
| [004-OperatingSystems](../004-OperatingSystems/) | AMIs/VM images, Linux optimizado para cloud |
| [006-Containers](../006-Containers/) | ECS, EKS, GKE, AKS como servicios de contenedores cloud |
| [007-Orchestration](../007-Orchestration/) | Kubernetes gestionado (EKS, GKE, AKS) y autoescalado |
| [008-Networking](../008-Networking/) | VPC, DNS, CDN, load balancing en cloud |
| [009-Security](../009-Security/) | Cloud IAM, KMS, WAF, SIEM, compliance |
| [013-DevOps](../013-DevOps/) | DevOps practices for cloud: automation, IaC, GitOps |
| [014-CICD](../014-CICD/) | Cloud-native CI/CD pipelines (CodePipeline, GitHub Actions) |
| [015-Automation](../015-Automation/) | Infrastructure automation with Terraform, CloudFormation |
| [024-Fintech](../024-Fintech/) | Regulaciones cloud para fintech, compliance |
| [031-AI](../031-AI/) | Cloud AI services (SageMaker, Vertex AI, Azure ML) |

## Recursos recomendados

- **AWS**: docs.aws.amazon.com, "AWS Well-Architected Framework" whitepaper, AWS re:Invent videos, AWS Workshops, "AWS Cookbook" (Zhi).
- **Azure**: learn.microsoft.com/azure, "Microsoft Azure Well-Architected Framework", Azure Friday, Azure Architecture Center.
- **GCP**: cloud.google.com/docs, "Google Cloud Architecture Framework", Google Cloud Next videos, Google Cloud Skills Boost.
- **Multi-cloud**: "Cloud Architecture Patterns" (Wilder), "The Cloud Adoption Playbook" (Bluepages).
- **FinOps**: finops.org, "Cloud FinOps" (Storment, Fuller).
- **Security**: "AWS Security" (Freeman, Miller), cloud security alliance guidance.
- **General**: "Architecting the Cloud" (Kavis), "Cloud Native Patterns" (Davis).

## Notas adicionales

AWS tiene la mayor cuota de mercado y la oferta de servicios más amplia; Azure es fuerte en entornos empresariales con integración Microsoft; GCP destaca en datos, analytics y ML. Se recomienda especializarse en un proveedor principal (AWS es la opción más universal) y tener conocimiento práctico de al menos otro. Las certificaciones cloud son altamente valoradas en la industria. La experiencia práctica con proyectos reales y el dominio de IaC (Terraform) son más importantes que las certificaciones por sí solas.
