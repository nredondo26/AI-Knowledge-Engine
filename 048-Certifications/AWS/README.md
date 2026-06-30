# Certificaciones AWS

## Visión General

Amazon Web Services (AWS) es la plataforma cloud más adoptada globalmente. Sus certificaciones validan habilidades técnicas en arquitectura, desarrollo, operaciones y especializaciones.

## Jerarquía de Certificaciones

```
Foundational
  └── Cloud Practitioner
Examinate          ┌── Solutions Architect (Associate)
  Associate ──────┼── Developer (Associate)
                   └── SysOps Administrator (Associate)
Professional       ┌── Solutions Architect (Professional)
                   └── DevOps Engineer (Professional)
Specialty          ┌── Advanced Networking
                   ├── Security
                   ├── Machine Learning
                   ├── Data Analytics
                   ├── Database
                   └── SAP on AWS
```

## Rutas Recomendadas

| Perfil | Ruta |
|--------|------|
| Arquitecto | Cloud Practitioner → SA Associate → SA Professional |
| Desarrollador | Cloud Practitioner → Developer Associate → DevOps Pro |
| Operaciones | Cloud Practitioner → SysOps Associate → DevOps Pro |

## Servicios Clave por Categoría

### Cómputo
```yaml
EC2:        Virtual machines con AMIs personalizadas
Lambda:     Serverless functions (Node.js, Python, Java, Go)
ECS/EKS:    Contenedores con Docker / Kubernetes
Fargate:    Serverless containers sin gestionar servidores
Lightsail:  VPS simplificado para proyectos pequeños
```

### Almacenamiento
```yaml
S3:         Object storage (11 9's durabilidad)
EBS:        Block storage para EC2
EFS:        NFS compartido y elástico
Glacier:    Archivado de largo plazo (clases S3 Glacier)
RDS:        Bases de datos relacionales (MySQL, Postgres, Aurora)
DynamoDB:   NoSQL clave-valor / documento
```

### Red y CDN
```yaml
VPC:        Red virtual aislada con subnets públicas/privadas
CloudFront: CDN global con Edge Locations
Route53:    DNS gestionado con routing policies
ALB/NLB:    Load balancers (Application / Network)
API Gateway: Front-end para APIs REST/WebSocket
```

### Seguridad e Identidad
```yaml
IAM:        Identity and Access Management (Users, Groups, Roles, Policies)
KMS:        Key Management Service (encriptación SSE-C, SSE-S3, SSE-KMS)
Secrets Manager: Rotación automática de credenciales
Cognito:    Identity pools para autenticación federada
WAF:        Web Application Firewall
```

## Ejemplo: Infraestructura como Código con Terraform

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data_lake" {
  bucket = "mi-data-lake-${var.environment}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
```

## Estrategia de Estudio

1. **AWS Skill Builder** — Cursos oficiales gratuitos y laboratorios
2. **Exam Readiness** — Talleres oficiales por nivel
3. **Práctica con consola** — Crear y destruir recursos (usar `terraform destroy`)
4. **Practice exams** — Tutorials Dojo, Whizlabs, TD
5. **Whitepapers** — AWS Well-Architected Framework, 5 Pillars

## Well-Architected Framework (6 Pilares)

```
Operational Excellence ─── Observabilidad y mejora continua
Security                ─── Protección de datos y sistemas
Reliability             ─── Recuperación ante fallos
Performance Efficiency  ─── Uso óptimo de recursos
Cost Optimization       ─── Evitar gastos innecesarios
Sustainability         ─── Minimizar impacto ambiental
```

## Cloud Adoption Framework (CAF)

CAF organiza la migración en 6 perspectivas: Business, People, Governance, Platform, Security, Operations. Cada perspectiva tiene capacidades y preguntas de评估.

## Servicios de AI/ML

```
Amazon SageMaker ── Entrenamiento y despliegue de modelos
Amazon Bedrock  ── Modelos fundacionales (Claude, Llama, Mistral)
Amazon Rekognition ── Visión por computadora
Amazon Polly ── Text-to-speech
Amazon Lex ── Chatbots conversacionales
```

## Comandos Útiles (AWS CLI)

```bash
# Configurar perfil
aws configure --profile dev

# Listar buckets
aws s3 ls

# Describir instancias EC2 con filtro
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].{ID:InstanceId,Type:InstanceType}"

# Sincronizar directorio con S3
aws s3 sync ./dist s3://mi-bucket --delete

# Obtener secretos
aws secretsmanager get-secret-value --secret-id mi-secreto --query SecretString
```

## Referencias

- [AWS Certified](https://aws.amazon.com/certification/)
- [AWS Documentation](https://docs.aws.amazon.com/)
- [AWS Well-Architected](https://aws.amazon.com/architecture/well-architected/)
- [Tutorials Dojo Practice Exams](https://tutorialsdojo.com/)
