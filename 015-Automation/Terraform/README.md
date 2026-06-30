# Terraform

## Conceptos Fundamentales

Terraform es una herramienta de IaC declarativa multi-cloud de HashiCorp. Usa HCL para definir recursos, mantiene state y ejecuta planes antes de aplicar.

### Principios

- **Declarativo**: Estado final deseado; calcula cómo alcanzarlo.
- **Idempotente**: Aplicar N veces produce el mismo resultado.
- **Multi-cloud**: AWS, Azure, GCP, K8s.
- **Inmutable**: Prefiere reemplazar sobre modificar.
- **Versionado**: Todo en Git.

### Ciclo de Vida

```bash
terraform init && terraform plan -out=tfplan && terraform apply tfplan
terraform destroy
```

## HCL

```hcl
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"
    }
  }
  backend "s3" {
    bucket         = "tf-state-prod"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tf-state-locks"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
```

### Variables y Outputs

```hcl
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Debe ser dev, staging o prod."
  }
}

variable "instance_type" {
  type = map(string)
  default = {
    dev     = "t3.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
```

## Recursos

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-24.04-*"]
  }
  owners = ["099720109477"]
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "vpc-${var.environment}" }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type[var.environment]
  lifecycle {
    create_before_destroy = true
  }
}
```

## Módulos

```hcl
# modules/vpc/main.tf
variable "environment" { type = string }
variable "cidr_block"  { type = string }

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = { Name = "vpc-${var.environment}" }
}

resource "aws_subnet" "public" {
  count      = 3
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
}

# environments/prod/main.tf
module "vpc" {
  source      = "../../modules/vpc"
  environment = "prod"
  cidr_block  = "10.0.0.0/16"
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "~> 20.0"
  cluster_name = "eks-prod"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
}
```

## State Management

```bash
terraform state list
terraform mv aws_instance.web aws_instance.app
terraform import aws_s3_bucket.my_bucket nombre
terraform state rm aws_instance.old
```

| Backend | Locking | Ideal para |
|---------|---------|-----------|
| S3 + DynamoDB | Sí | AWS |
| Terraform Cloud | Sí | Equipos |
| Local | No | Desarrollo |

## Workspaces

```bash
terraform workspace new dev
terraform workspace select dev
terraform apply -auto-approve
```

## Seguridad

```hcl
# Mal
resource "aws_s3_bucket" "bad" { acl = "public-read" }
# Bien
resource "aws_s3_bucket_public_access_block" "good" {
  bucket = aws_s3_bucket.good.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
```

## Best Practices

1. **Remote state + locking obligatorio**.
2. **Módulos versionados**.
3. **Etiquetado**: Environment, ManagedBy.
4. **Variables tipadas y validadas**.
5. **Lifecycle rules**: `create_before_destroy`.
6. **Separar entornos por backend**.
7. **`terraform fmt -recursive`** pre-commit.
8. **`terraform validate` en CI**.
9. **Provider versions fijas**.
10. **No hardcodear secrets**.
11. **Estructura**: `modules/` y `environments/{dev,staging,prod}/`.
