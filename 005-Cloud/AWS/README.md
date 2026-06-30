# AWS (Amazon Web Services)

## Servicios Principales

AWS ofrece más de 200 servicios agrupados en categorías: cómputo, almacenamiento, bases de datos, red, seguridad, IA/ML, serverless, IoT, y más. Los servicios principales incluyen:

| Categoría | Servicios Clave |
|-----------|----------------|
| Cómputo | EC2, Lambda, ECS, EKS, Fargate, Batch, Lightsail |
| Almacenamiento | S3, EBS, EFS, S3 Glacier, Storage Gateway, FSx |
| Bases de Datos | RDS, DynamoDB, Aurora, Redshift, ElastiCache, Neptune, DocumentDB |
| Red | VPC, CloudFront, Route 53, API Gateway, ELB, Direct Connect, Global Accelerator |
| Seguridad | IAM, KMS, Shield, WAF, Cognito, Secrets Manager, GuardDuty, Inspector |
| Serverless | Lambda, API Gateway, DynamoDB, S3, Step Functions, EventBridge, SQS, SNS |
| IA/ML | SageMaker, Bedrock, Rekognition, Comprehend, Polly, Lex, Translate, Textract |
| DevOps | CloudFormation, CodePipeline, CodeBuild, CodeDeploy, CloudWatch, X-Ray |

---

## IAM (Identity and Access Management)

IAM controla acceso a recursos AWS mediante usuarios, grupos, roles y políticas.

### Principios fundamentales
- **Principio de mínimo privilegio**: conceder solo los permisos necesarios
- **Políticas administradas vs. inline**: AWS provee políticas predefinidas; las inline son específicas a un recurso
- **Roles IAM**: identidades sin credenciales permanentes, asumibles por servicios, usuarios federados o cuentas externas
- **Políticas basadas en recursos**: se adjuntan directamente a S3 buckets, KMS keys, SQS queues, etc.

### Estructura de una política IAM
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::mi-bucket/*",
      "Condition": {
        "IpAddress": {"aws:SourceIp": "192.168.1.0/24"}
      }
    }
  ]
}
```

### Ejemplos CLI
```bash
# Crear usuario IAM
aws iam create-user --user-name devops-user

# Adjuntar política administrada
aws iam attach-user-policy --user-name devops-user \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Crear rol para EC2
aws iam create-role --role-name ec2-s3-role \
  --assume-role-policy-document file://trust-policy.json

# Listar políticas
aws iam list-policies --scope AWS --max-items 20
```

---

## Networking

### VPC (Virtual Private Cloud)
Red virtual aislada dentro de AWS. Componentes clave:

- **Subnets**: públicas (con Internet Gateway) y privadas (sin ruta directa a internet)
- **Route Tables**: definen reglas de enrutamiento entre subnets
- **Internet Gateway (IGW)**: permite comunicación entre VPC e internet
- **NAT Gateway / NAT Instance**: permite a instancias en subnets privadas acceder a internet (salida)
- **Security Groups**: firewall stateful a nivel de instancia (solo permite reglas allow)
- **NACL**: firewall stateless a nivel de subnet (allow/deny, evaluadas en orden numérico)
- **VPC Peering**: conexión entre VPCs (misma o diferente cuenta/región)
- **Transit Gateway**: hub central para conectar múltiples VPCs y on-premises
- **VPN Site-to-Site**: conexión cifrada entre VPC y datacenter on-premises
- **Direct Connect**: conexión física dedicada desde on-premises a AWS

### CloudFront
CDN global con +400 puntos de presencia. Soporta comportamientos avanzados:
- Lambda@Edge para ejecutar código en edge locations
- Origin Shield para reducir carga en orígenes
- Field-Level Encryption para datos sensibles

### Route 53
DNS administrado con soporte para:
- Routing policies: Simple, Weighted, Latency, Failover, Geolocation, Geoproximity, Multi-value
- Health checks integrados con failover automático
- Alias records para apuntar a recursos AWS (sin costo adicional)

```bash
# Crear VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Crear subnet pública
aws ec2 create-subnet --vpc-id vpc-xxxxx --cidr-block 10.0.1.0/24

# Crear security group
aws ec2 create-security-group --group-name web-sg \
  --description "SG para servidores web" --vpc-id vpc-xxxxx

# Autorizar tráfico HTTP
aws ec2 authorize-security-group-ingress --group-id sg-xxxxx \
  --protocol tcp --port 80 --cidr 0.0.0.0/0
```

---

## Compute

### EC2 (Elastic Compute Cloud)
Máquinas virtuales con múltiples familias:
- **General purpose**: t3, t4g, m5, m6i, m7g
- **Compute optimized**: c5, c6i, c7g — alta relación CPU/memoria
- **Memory optimized**: r5, r6i, x2iedn, u-6tb1 — alta carga de memoria
- **Storage optimized**: i3, i4i, d2, d3 — alto IOPS y throughput
- **Accelerated computing**: p4, p5 (GPU NVIDIA), inf2 (Inferentia), trn1 (Trainium)
- **Bare metal**: instancias sin hipervisor, para workloads que requieren hardware dedicado

### Auto Scaling Groups (ASG)
Escalado automático horizontal basado en:
- **Launch Templates** o **Launch Configurations**
- **Scaling Policies**: target tracking, step scaling, simple scaling
- **Scheduled scaling**: predecible por horarios
- **Predictive scaling**: basado en ML (pronostica demanda futura)

```bash
# Lanzar instancia EC2
aws ec2 run-instances --image-id ami-xxxxx \
  --instance-type t3.medium --key-name mi-key \
  --security-group-ids sg-xxxxx --subnet-id subnet-xxxxx

# Listar tipos de instancia disponibles
aws ec2 describe-instance-types --filters "Name=instance-type,Values=t3.*"

# Crear un ASG
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name mi-asg \
  --launch-template LaunchTemplateName=mi-template \
  --min-size 1 --max-size 10 --desired-capacity 2 \
  --vpc-zone-identifier "subnet-xxxxx,subnet-yyyyy"
```

---

## Storage

### S3 (Simple Storage Service)
Almacenamiento de objetos con 11 9s de durabilidad. Clases de almacenamiento:

| Clase | Disponibilidad | Caso de uso |
|-------|---------------|-------------|
| S3 Standard | 99.99% | Datos críticos de acceso frecuente |
| S3 Intelligent-Tiering | 99.99% | Datos con patrones de acceso cambiantes |
| S3 Standard-IA | 99.9% | Datos de acceso poco frecuente |
| S3 One Zone-IA | 99.5% | Datos recreables de baja frecuencia |
| S3 Glacier Instant Retrieval | 99.9% | Archivado con recuperación en ms |
| S3 Glacier Flexible Retrieval | 99.99% | Archivado (min 1 min - 12 horas) |
| S3 Glacier Deep Archive | 99.99% | Archivado de largo plazo (12-48 horas) |

### EBS (Elastic Block Store)
Volúmenes de bloque para EC2:
- **gp3**: SSD propósito general (3000 IOPS base, escalable a 16000)
- **io2 Block Express**: SSD de alta IOPS (hasta 256K IOPS, 64 TB)
- **st1**: HDD throughput optimizado (cargas secuenciales)
- **sc1**: HDD cold (mínimo costo para acceso poco frecuente)

```bash
# Subir archivo a S3
aws s3 cp mi-archivo.txt s3://mi-bucket/

# Sincronizar directorio con S3
aws s3 sync ./carpeta s3://mi-bucket/carpeta --delete

# Crear volumen EBS
aws ec2 create-volume --volume-type gp3 --size 100 \
  --availability-zone us-east-1a

# Configurar ciclo de vida S3 (transición a Glacier tras 30 días)
aws s3api put-bucket-lifecycle-configuration --bucket mi-bucket \
  --lifecycle-configuration file://lifecycle.json
```

---

## Bases de Datos

### RDS (Relational Database Service)
Bases de datos relacionales administradas: Aurora, MySQL, PostgreSQL, MariaDB, Oracle, SQL Server.
- **Multi-AZ**: replicación síncrona para alta disponibilidad
- **Read Replicas**: hasta 15 réplicas de lectura (Aurora hasta 15)
- **Automated backups**: retention 1-35 días, point-in-time recovery
- **RDS Proxy**: pool de conexiones para reducir latencia y evitar agotamiento

### DynamoDB
Base de datos NoSQL clave-valor y documento:
- **Tablas**: sin esquema fijo, throughput provisionado o bajo demanda
- **Índices**: LSI (Local Secondary Index) y GSI (Global Secondary Index)
- **DAX (DynamoDB Accelerator)**: caché in-memory para microsegundos de latencia
- **Streams**: captura cambios en orden cronológico (TTL, CDC)
- **Transactions**: operaciones ACID en hasta 25 items o 4 MB

### Aurora
Motor relacional compatible con MySQL y PostgreSQL:
- **Auto-scaling**: almacenamiento de 10 GB a 128 TB automático
- **Global Database**: réplicas en hasta 6 regiones con <1s de latencia
- **Aurora Serverless v2**: escala automáticamente desde 0.5 ACU hasta 256 ACU
- **Backtrack**: retrocede en el tiempo sin restaurar backup

```bash
# Crear instancia RDS MySQL
aws rds create-db-instance --db-instance-identifier mydb \
  --db-instance-class db.t3.medium --engine mysql \
  --master-username admin --master-user-password secreta123 \
  --allocated-storage 100 --multi-az

# Crear tabla DynamoDB
aws dynamodb create-table --table-name Usuarios \
  --attribute-definitions AttributeName=id,AttributeType=S \
  --key-schema AttributeName=id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

---

## Serverless

### AWS Lambda
Ejecuta código sin aprovisionar servidores.
- **Runtimes**: Node.js, Python, Java, Go, Ruby, .NET, Custom (provided.al2)
- **Trigger**: S3, API Gateway, DynamoDB Streams, SQS, SNS, EventBridge, Kinesis, Cognito
- **Límites**: 15 min timeout, 10 GB memory, 512 MB /tmp, 1 MB payload (sync), 256 KB (async)
- **Concurrency**: hasta 1000 concurrentes por defecto (solicitable)
- **Lambda SnapStart**: reduce cold starts (Java, Python, .NET)
- **Lambda@Edge**: ejecución en CloudFront edge locations
- **Lambda Layers**: capas con dependencias compartidas entre funciones

### API Gateway
Creación, publicación y monitoreo de APIs REST y WebSocket.
- **REST API**: APIs HTTP tradicionales con features completas
- **HTTP API**: más rápidas y económicas (ideal para Lambda)
- **WebSocket API**: conexiones bidireccionales y persistentes
- **Throttling**: control de velocidad por cliente y por método
- **WAF Integration**: protección contra OWASP Top 10

### Step Functions
Orquestación serverless de workflows distribuidos:
- **Standard**: ejecución hasta 1 año, exactly-once, ideal para workflows largos
- **Express**: ejecución hasta 5 min, at-least-once, ideal para eventos de alto volumen
- **Integraciones**: 200+ servicios AWS directas desde JSON de estado

```bash
# Crear función Lambda
aws lambda create-function --function-name mi-funcion \
  --runtime python3.12 --role arn:aws:iam::xxx:role/lambda-role \
  --handler index.handler --zip-file fileb://funcion.zip

# Invocar Lambda (síncrono)
aws lambda invoke --function-name mi-funcion \
  --payload '{"key": "value"}' output.json

# Crear API Gateway REST
aws apigateway create-rest-api --name "Mi API" --description "API principal"
```

---

## Cost Optimization

Estrategias y servicios para optimizar costos en AWS:

### Compute Cost Optimization
- **EC2 Reserved Instances**: 1-3 años, ahorro 40-60% vs on-demand
- **EC2 Savings Plans**: flexible entre instancias y regiones, ahorro hasta 72%
- **Spot Instances**: hasta 90% descuento, ideales para workloads tolerantes a fallos
- **EC2 Auto Scaling**: ajustar capacidad según demanda real
- **Graviton (ARM)**: instancias ARM más económicas que x86, hasta 40% mejor rendimiento/costo

### Storage Cost Optimization
- **S3 Lifecycle Policies**: transición automática a clases más económicas
- **S3 Intelligent-Tiering**: monitoreo automático de patrones de acceso
- **S3 Requester Pays**: el solicitante paga por descarga y ancho de banda
- **EBS Snapshots**: backups incrementales, eliminar snapshots obsoletos
- **EBS gp3**: más IOPS y throughput base incluido sin costo adicional vs gp2

### Database Cost Optimization
- **Aurora Serverless**: paga por consumo (ACU), ideal para cargas variables
- **DynamoDB On-Demand**: sin capacidad provisionada, paga por operación
- **RDS Reserved Instances**: descuento por compromiso de 1-3 años
- **Read Replicas**: descarga lecturas de la base de datos principal

### Herramientas de monitoreo
- **AWS Cost Explorer**: visualización y análisis de costos
- **AWS Budgets**: alertas cuando se exceden umbrales de costo
- **Trusted Advisor**: recomendaciones de optimización (ahorro, seguridad, rendimiento)
- **Compute Optimizer**: recomendaciones basadas en ML para tamaño de instancias

```bash
# Crear alerta de presupuesto
aws budgets create-budget --account-id 123456789012 \
  --budget file://budget.json --notifications-with-subscribers file://notif.json

# Obtener recomendaciones de Compute Optimizer
aws compute-optimizer get-ec2-instance-recommendations \
  --instance-arns arn:aws:ec2:us-east-1:123456789012:instance/i-xxxxx

# Listar Spot Instance recommendations
aws ec2 describe-spot-instance-requests
```

---

## Ejemplos CLI Adicionales

```bash
# Configurar AWS CLI
aws configure
# AWS Access Key ID [None]: AKIA...
# AWS Secret Access Key [None]: wJalrX...
# Default region name [None]: us-east-1
# Default output format [None]: json

# Usar perfiles
aws configure --profile produccion
aws s3 ls --profile produccion

# Listar todos los buckets S3
aws s3 ls

# Describir instancias EC2 con filtro
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]" \
  --output table

# Obtener logs de CloudWatch
aws logs filter-log-events --log-group-name /aws/lambda/mi-funcion \
  --start-time $(date -d '1 hour ago' +%s) \
  --end-time $(date +%s)

# Crear un bucket S3 con cifrado
aws s3api create-bucket --bucket mi-bucket-seguro \
  --region us-east-1 \
  --create-bucket-configuration LocationConstraint=us-east-1

# Habilitar versioning en S3
aws s3api put-bucket-versioning --bucket mi-bucket \
  --versioning-configuration Status=Enabled

# Generar pre-signed URL para S3 (expira en 3600s)
aws s3 presign s3://mi-bucket/archivo.zip --expires-in 3600

# Ejecutar comando en instancia EC2 mediante SSM (sin SSH)
aws ssm send-command --instance-ids i-xxxxx \
  --document-name "AWS-RunShellScript" \
  --parameters commands="df -h; free -m"

# Listar funciones Lambda
aws lambda list-functions --max-items 50

# CloudFormation: desplegar stack
aws cloudformation deploy --template-file template.yaml \
  --stack-name mi-stack --capabilities CAPABILITY_IAM

# ECR: login y push de Docker
aws ecr get-login-password --region us-east-1 | docker login --username AWS \
  --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
docker tag mi-imagen:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/mi-repo:latest
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/mi-repo:latest
```
