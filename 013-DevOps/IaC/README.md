# IaC — Infrastructure as Code

## Conceptos Fundamentales

Infrastructure as Code (IaC) es la práctica de gestionar y aprovisionar infraestructura computacional mediante archivos de definición legibles por máquina, en lugar de procesos manuales. Es el pilar fundamental de DevOps.

### Tipos de IaC

| Tipo | Enfoque | Herramientas |
|------|---------|--------------|
| **Declarativo** | Estado deseado, la herramienta calcula el plan | Terraform, Pulumi, AWS CDK |
| **Imperativo** | Pasos para alcanzar el estado deseado | Ansible, Shell scripts |
| **Inmutable** | Reemplazar instancia en lugar de modificar | Packer, AMI baking, Containers |

### Principios

1. **Idempotencia**: Ejecutar N veces produce el mismo estado final.
2. **Versionado**: Todo el código de infraestructura en Git (GitOps-ready).
3. **Revisión por pares**: Pull requests para cambios de infraestructura.
4. **Pruebas automatizadas**: `terraform plan`, `pulumi preview`, `ansible --check`.
5. **Separación de entornos**: Workspaces, state files o directorios distintos.

## Terraform — State Management

El archivo de estado (`terraform.tfstate`) es el activo más crítico. Almacena el mapeo entre recursos declarados y objetos reales.

```hcl
terraform {
  backend "s3" {
    bucket         = "tf-state-prod"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tf-state-locks"
  }
}
```

Estrategias: local (simple, sin locking), S3+DynamoDB (recomendado), Terraform Cloud (policy as code).

## Módulos reutilizables

```hcl
# modules/vpc/main.tf
variable "environment" { type = string }
variable "cidr_block"  { type = string }

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = { Name = "vpc-${var.environment}", Environment = var.environment }
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
```

## Pulumi — IaC con lenguajes generales

```typescript
import * as aws from "@pulumi/aws";
const vpc = new aws.ec2.Vpc("main", {
  cidrBlock: "10.0.0.0/16",
  tags: { Name: "vpc-production" },
});
export const vpcId = vpc.id;
```

Ventaja: lógica condicional, bucles, funciones sin HCL.

## Testing de Infraestructura

### Plan validation (OPA/Rego)

```rego
package terraform.analysis
deny[msg] {
  resource := input.resource.aws_s3_bucket[_]
  resource.config.acl == "public-read"
  msg := sprintf("S3 bucket %s no debe ser público", [resource.config.bucket])
}
```

### Terratest (Go)

```go
func TestTerraformVPC(t *testing.T) {
    opts := &terraform.Options{TerraformDir: "../examples/vpc"}
    defer terraform.Destroy(t, opts)
    terraform.InitAndApply(t, opts)
    vpcID := terraform.Output(t, opts, "vpc_id")
    assert.NotEmpty(t, vpcID)
}
```

## Best Practices

1. **Remote state siempre**: Nunca mantener state local en equipo.
2. **State locking**: Evita corrupción por ejecuciones concurrentes.
3. **DRY con módulos**: Encapsular en módulos versionados.
4. **Etiquetado consistente**: Tags Environment, ManagedBy, CostCenter.
5. **Secretos externos**: Vault, AWS Secrets Manager o SOPS.
6. **Plan/Apply separados**: Revisar `plan` en PRs antes de `apply`.
7. **Pre-commit hooks**: `terraform fmt`, `tflint`, `checkov` en cada commit.
   ```yaml
   repos:
     - repo: https://github.com/antonbabenko/pre-commit-terraform
       rev: v1.77.0
       hooks:
         - id: terraform_fmt
         - id: terraform_tflint
         - id: checkov
   ```

## Seguridad

```bash
checkov -d . -- framework terraform
tfsec .
```

```hcl
# Mal
resource "aws_security_group_rule" "bad" {
  cidr_blocks = ["0.0.0.0/0"]
}
# Bien
resource "aws_security_group_rule" "good" {
  cidr_blocks = ["10.0.0.0/8"]
}
```

## Ecosistema

| Herramienta | Tipo | Clave |
|------------|------|-------|
| **Terraform** | Declarativo multi-cloud | State management, módulos |
| **Pulumi** | Declarativo + lenguajes | TypeScript, Python, Go, C# |
| **AWS CDK** | CloudFormation gen | Constructos reutilizables L2/L3 |
| **Bicep** | DSL Azure | Nativo ARM |
| **Crossplane** | Control plane K8s | API de K8s para infra cloud |
| **Packer** | Immutable images | AMIs, VM images |
