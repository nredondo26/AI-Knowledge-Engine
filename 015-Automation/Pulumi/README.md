# Pulumi — IaC con Lenguajes de Programación

## Conceptos Fundamentales

Pulumi es una plataforma de Infrastructure as Code que permite definir y gestionar infraestructura cloud usando lenguajes de programación generales (TypeScript, Python, Go, C#, Java, YAML). A diferencia de HCL (Terraform), Pulumi ofrece bucles, condicionales, funciones y todo el poder del lenguaje anfitrión.

### ¿Por qué Pulumi?

| Característica | Pulumi | Terraform |
|---------------|--------|-----------|
| Lenguaje | TypeScript, Python, Go, C# | HCL |
| Lógica programática | Bucles, if/else, funciones | count, for_each, condicionales limitados |
| Testing | Unit tests con mocking nativo | Terratest (externo) |
| Paquetes | npm, pip, go modules | Módulos registry |
| State | Pulumi Cloud / Self-managed | S3, Terraform Cloud |
| CDK | Nativo | AWS CDK (externo) |

## Primer Proyecto (TypeScript)

```typescript
import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

const config = new pulumi.Config();
const environment = config.require("environment");
const instanceType = config.get("instanceType") || "t3.micro";

// Crear VPC
const vpc = new aws.ec2.Vpc("main", {
  cidrBlock: "10.0.0.0/16",
  enableDnsHostnames: true,
  tags: { Name: `vpc-${environment}`, Environment: environment },
});

// Crear subnets
const subnets = [0, 1, 2].map((i) =>
  new aws.ec2.Subnet(`public-${i}`, {
    vpcId: vpc.id,
    cidrBlock: `10.0.${i}.0/24`,
    availabilityZone: `us-east-1${String.fromCharCode(97 + i)}`,
    mapPublicIpOnLaunch: true,
    tags: { Name: `public-${i}-${environment}` },
  })
);

// Security group
const sg = new aws.ec2.SecurityGroup("web-sg", {
  vpcId: vpc.id,
  ingress: [
    { protocol: "tcp", fromPort: 80, toPort: 80, cidrBlocks: ["0.0.0.0/0"] },
    { protocol: "tcp", fromPort: 443, toPort: 443, cidrBlocks: ["0.0.0.0/0"] },
  ],
  egress: [
    { protocol: "-1", fromPort: 0, toPort: 0, cidrBlocks: ["0.0.0.0/0"] },
  ],
});

export const vpcId = vpc.id;
export const subnetIds = subnets.map((s) => s.id);
export const securityGroupId = sg.id;
```

## Python

```python
import pulumi
import pulumi_aws as aws

config = pulumi.Config()
environment = config.require("environment")

vpc = aws.ec2.Vpc("main",
    cidr_block="10.0.0.0/16",
    enable_dns_hostnames=True,
    tags={"Name": f"vpc-{environment}", "Environment": environment},
)

subnets = []
for i in range(3):
    subnet = aws.ec2.Subnet(f"public-{i}",
        vpc_id=vpc.id,
        cidr_block=f"10.0.{i}.0/24",
        availability_zone=f"us-east-1{chr(97 + i)}",
        map_public_ip_on_launch=True,
    )
    subnets.append(subnet)

pulumi.export("vpc_id", vpc.id)
pulumi.export("subnet_ids", [s.id for s in subnets])
```

## Gestión de State

```bash
pulumi login
pulumi stack init dev
```

### Stacks

```yaml
# Pulumi.dev.yaml
config:
  aws:region: us-east-1
  environment: dev
  instanceType: t3.micro

# Pulumi.prod.yaml
config:
  aws:region: us-east-1
  environment: prod
  instanceType: t3.medium
  database:enabled: "true"
```

```bash
pulumi stack select dev
pulumi up -y
pulumi stack select prod
pulumi up -y
```

## Testing

```typescript
import { describe, it, expect } from "vitest";
import * as pulumi from "@pulumi/pulumi";

describe("VPC", () => {
  it("should have DNS hostnames enabled", async () => {
    const vpc = new aws.ec2.Vpc("test", {
      cidrBlock: "10.0.0.0/16",
      enableDnsHostnames: true,
    });

    const result = await pulumi.deployment().runAsync({
      resources: [vpc],
      validate: () => {
        expect(vpc.enableDnsHostnames).toBe(true);
      },
    });
  });
});
```

## Best Practices

1. **Stacks separados por entorno**: Cada entorno es un stack.
2. **Secretos en configuración**: `pulumi config set --secret`.
3. **Componentes reutilizables**: ComponentResource para patrones comunes.
4. **StackReferences**: Importar outputs de otros stacks.
5. **Automation API**: Integrar IaC en aplicaciones o IDP.
