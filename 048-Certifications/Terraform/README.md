# Certificaciones Terraform

## Visión General

HashiCorp Terraform es la herramienta líder de Infrastructure as Code (IaC). La certificación oficial **HashiCorp Certified: Terraform Associate** valida la capacidad de aprovisionar, gestionar y versionar infraestructura cloud mediante código.

## Terraform Associate (003)

| Aspecto | Detalle |
|---------|---------|
| Formato | 57 preguntas, múltiple opción |
| Duración | 60 minutos |
| Precio | 142.50 USD (con voucher frecuente en eventos) |
| Recertificación | Cada 2 años |
| Prerequisito | Ninguno |

### Dominios del Examen

| Dominio | Peso |
|---------|------|
| Comprender los fundamentos de IaC | 12% |
| Comprender el propósito de Terraform | 18% |
| Usar el core workflow de Terraform | 12% |
| Implementar y mantener estado (state) | 18% |
| Leer, generar y modificar configuración | 12% |
| Comprender el módulo de registro (registry) | 9% |
| Usar el ecosistema de Terraform (HCP, Cloud) | 12% |
| Automatizar el workflow de Terraform | 7% |

## Flujo de Trabajo Básico

```bash
# 1. Inicializar directorio
terraform init

# 2. Validar configuración
terraform validate

# 3. Ver plan de cambios
terraform plan -out=tfplan

# 4. Aplicar cambios
terraform apply tfplan

# 5. Destruir recursos (cuando sea necesario)
terraform destroy
```

## Ejemplo: Infraestructura Multi-Cloud

```hcl
terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "azurerm" {
  features {}
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "main-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Environment = "production"
    Managed_by  = "terraform"
  }
}
```

## Gestión de Estado (State)

El estado es crítico en Terraform. Almacena el mapeo entre recursos reales y configuración.

```hcl
# Backend remoto en S3 con DynamoDB para locking
terraform {
  backend "s3" {
    bucket         = "mi-terraform-state"
    key            = "prod/infrastructure.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

### Workflows de Estado

```bash
# Listar recursos en estado
terraform state list

# Mover recurso dentro del estado
terraform state mv aws_instance.web aws_instance.web_new

# Importar recurso existente
terraform import aws_instance.existing i-1234567890abcdef0

# Reemplazar recurso forzado
terraform apply -replace="aws_instance.web"
```

## Variables y Outputs

```hcl
# variables.tf
variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El entorno debe ser dev, staging o prod."
  }
}

variable "instance_type" {
  default = "t3.micro"
}

# outputs.tf
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

# terraform.tfvars
environment   = "staging"
instance_type = "t3.medium"
```

## Módulos

Los módulos permiten reutilizar configuraciones empaquetadas.

```hcl
# modules/ec2-instance/main.tf
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = var.name
  }
}

# Uso del módulo
module "web_server" {
  source = "./modules/ec2-instance"

  ami_id        = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[0]
  name          = "web-server-${var.environment}"
}
```

## Terraform Cloud / HCP

Terraform Cloud ofrece ejecución remota, state management, políticas (Sentinel) y VCS integration.

```hcl
# Configurar Cloud
terraform {
  cloud {
    organization = "mi-org"
    workspaces {
      name = "infra-production"
    }
  }
}
```

## Buenas Prácticas

1. **Formatear siempre** — `terraform fmt -recursive`
2. **Pin versiones** de providers y módulos (evitar `latest`)
3. **State remoto** con locking (S3 + DynamoDB o Terraform Cloud)
4. **Workspaces** para separar entornos (o usar directorios separados)
5. **Pre-commit hooks** — `terraform fmt`, `terraform validate`, `tflint`
6. **Secretos** — Usar variables de entorno o Vault, nunca en `.tfvars`

## Comandos de Diagnóstico

```bash
# Visualizar grafo de dependencias
terraform graph | dot -Tsvg > graph.svg

# Consola interactiva para expresiones
terraform console

# Mostrar recursos gestionados
terraform show

# Comprobar sintaxis sin init
terraform fmt -check -recursive

# Linter avanzado
tflint --recursive
```

## Estrategia de Estudio

1. **HashiCorp Learn** — Tutoriales oficiales gratuitos
2. **Terraform Up & Running** (Yevgeniy Brikman) — Libro de referencia
3. **Práctica** — Desplegar infraestructura real en AWS/Azure/GCP
4. **Exam Review** — Preguntas de práctica en Tutorials Dojo y Whizlabs
5. **Repositorio** — Mantener ejemplos propios en GitHub

## Referencias

- [Terraform Associate Certification](https://www.hashicorp.com/certification/terraform-associate)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [HashiCorp Learn](https://learn.hashicorp.com/terraform)
