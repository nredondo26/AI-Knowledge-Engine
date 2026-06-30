# 005-Cloud: Cloud Computing

## Descripción del dominio

El cloud computing es el paradigma de entrega de recursos computacionales (servidores, almacenamiento, bases de datos, redes, software, análisis, inteligencia artificial) a través de Internet, con facturación por uso y escalabilidad bajo demanda. Este módulo cubre los tres grandes proveedores cloud (AWS, Azure, Google Cloud), los modelos de servicio (IaaS, PaaS, SaaS), arquitecturas cloud-native, serverless, almacenamiento, redes cloud, Identity and Access Management (IAM), optimización de costos y estrategias de migración.

## Conceptos clave

- **Modelos de servicio**: IaaS (servidores virtuales, redes, almacenamiento), PaaS (plataforma gestionada: App Engine, Elastic Beanstalk, Azure App Service), SaaS (aplicaciones completas: Gmail, Office 365)
- **Modelos de despliegue**: Pública, privada, híbrida, multi-cloud, community cloud
- **Cómputo**: EC2, Azure VMs, Compute Engine — instancias spot/reservadas, auto-scaling groups, ASG, VMSS, MIGs
- **Serverless**: AWS Lambda, Azure Functions, Google Cloud Functions, Cloud Run — cold starts, execution limits, event-driven triggers
- **Containers en cloud**: ECS, EKS (Kubernetes), AKS, GKE — Fargate vs EC2 launch type
- **Almacenamiento**: S3 (object), EBS (block), EFS/FSx (file), Azure Blob, Cloud Storage — tiers de almacenamiento, lifecycle policies
- **IAM (Identity and Access Management)**: Roles, policies (JSON), service accounts, Principal of Least Privilege, ARN, trust relationships
- **Redes cloud**: VPC, subnets, security groups, NACLs, route tables, Internet/NAT/VPN Gateways, CloudFront (CDN), AWS Global Accelerator
- **Bases de datos gestionadas**: RDS, Aurora, DynamoDB, ElastiCache, Cloud SQL, Bigtable, Cosmos DB, Firestore
- **Observabilidad**: CloudWatch, CloudTrail, X-Ray (AWS); Azure Monitor, Log Analytics (Azure); Cloud Monitoring, Cloud Logging, Trace (GCP)
- **Infraestructura como Código (IaC)**: Terraform, AWS CloudFormation, Azure Resource Manager (ARM), Google Deployment Manager, Pulumi
- **Costos y facturación**: AWS Cost Explorer, Azure Cost Management, GCP Billing; Reserved Instances, Savings Plans, Committed Use Discounts
- **Well-Architected Framework**: AWS 6 pilares (Excelencia operativa, Seguridad, Fiabilidad, Eficiencia de rendimiento, Optimización de costos, Sostenibilidad); Azure Well-Architected Framework; GCP Architecture Framework

## Tecnologías principales

| Proveedor | Cómputo | Serverless | Almacenamiento | Base de datos | CDN |
|-----------|---------|------------|----------------|---------------|-----|
| AWS | EC2 | Lambda | S3 / EBS / EFS | RDS / Aurora / DynamoDB | CloudFront |
| Azure | Virtual Machines | Azure Functions | Blob / Disk / Files | SQL Database / Cosmos DB | Front Door / CDN |
| GCP | Compute Engine | Cloud Functions | Cloud Storage / Persistent Disk | Cloud SQL / Bigtable / Spanner | Cloud CDN |

## Hoja de ruta

1. **Principiante**: Fundamentos de cloud computing — elegir un proveedor (AWS recomendado por cuota de mercado) — consola web — EC2 + S3 + VPC básica — security groups — presupuesto y facturación
2. **Intermedio**: Auto Scaling, load balancers (ALB/ELB) — RDS, DynamoDB — Lambda functions — IAM policies (roles, permisos) — CloudWatch logs/métricas/alarmas — VPC avanzada (NAT, peering, VPN) — costos y tagging
3. **Avanzado**: Terraform / Pulumi para IaC — CI/CD pipelines con CodePipeline/GitHub Actions — ECS/EKS con Fargate — Microservicios cloud-native — CloudFront + WAF — Multi-región, disaster recovery — Well-Architected Framework
4. **Experto**: Arquitecturas multi-cloud — cost optimization avanzado (spot instances, Savings Plans) — organziaciones (AWS Organizations, Management Groups) — control tower, landing zones — compliance (SOC2, HIPAA, PCI, ISO27001) — migraciones enterprise (7 Rs de migración)

## Relaciones con otros módulos

- [003-Databases](../003-Databases/) — Bases de datos gestionadas (RDS, Aurora, DynamoDB, Cloud SQL, Cosmos DB)
- [004-OperatingSystems](../004-OperatingSystems/) — AMIs, imágenes de VM, optimización de SO en cloud
- [006-Containers](../006-Containers/) — Container registries (ECR, ACR, GCR), Docker en cloud
- [007-Orchestration](../007-Orchestration/) — EKS, AKS, GKE — Kubernetes gestionado en cloud
- [008-Networking](../008-Networking/) — VPC, subnets, DNS (Route 53, Cloud DNS), CDN, Global Accelerator
- [009-Security](../009-Security/) — IAM, KMS, Secrets Manager, Shield, WAF, GuardDuty, Security Hub
- [013-DevOps](../013-DevOps/) — CI/CD integrado con cloud, IaC (Terraform), GitOps (ArgoCD)
- [062-Search](../062-Search/) — Cloud Search, CloudWatch Logs Insights, Elasticsearch Service

## Recursos recomendados

- **AWS**: aws.amazon.com/documentation, AWS Well-Architected Framework whitepapers, "AWS Cookbook" (Zaal); AWS re:Invent videos; AWS Skill Builder
- **Azure**: learn.microsoft.com/azure, Azure Architecture Center, "Azure for Architects" (Tejada)
- **GCP**: cloud.google.com/docs, Google Cloud Skills Boost, "Google Cloud Platform in Action" (Cohen)
- **Multi-cloud**: Terraform by HashiCorp, "Infrastructure as Code" (Morris), CloudHealth / CloudAbility para costos
- **Certificaciones**: AWS Solutions Architect Associate, Azure AZ-900, GCP Associate Cloud Engineer
