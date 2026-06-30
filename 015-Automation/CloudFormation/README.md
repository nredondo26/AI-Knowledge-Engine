# AWS CloudFormation — IaC Nativo de AWS

## Conceptos Fundamentales

AWS CloudFormation es el servicio de Infrastructure as Code nativo de AWS. Utiliza templates JSON o YAML para describir recursos AWS y sus dependencias, y gestiona automáticamente el aprovisionamiento, actualización y eliminación ordenada de stacks.

### Conceptos Clave

- **Template**: Archivo YAML/JSON que define los recursos.
- **Stack**: Conjunto de recursos gestionados como una unidad.
- **Change Set**: Vista previa de cambios antes de aplicarlos.
- **Outputs**: Valores exportados que pueden ser importados por otros stacks.
- **Nested Stacks**: Stacks anidados para modularizar templates grandes.
- **Drift Detection**: Detecta cambios manuales no autorizados en recursos.

## Template Básico

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: VPC con subnets públicas y privadas

Parameters:
  Environment:
    Type: String
    Default: dev
    AllowedValues: [dev, staging, prod]

  VpcCIDR:
    Type: String
    Default: 10.0.0.0/16

Resources:
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref VpcCIDR
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: !Sub "vpc-${Environment}"
        - Key: Environment
          Value: !Ref Environment

  PublicSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: !Select [0, !Cidr [!Ref VpcCIDR, 6, 8]]
      AvailabilityZone: !Select [0, !GetAZs ""]
      MapPublicIpOnLaunch: true

  InternetGateway:
    Type: AWS::EC2::InternetGateway

  VPCGatewayAttachment:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref InternetGateway

Outputs:
  VpcId:
    Description: ID de la VPC
    Value: !Ref VPC
    Export:
      Name: !Sub "${AWS::StackName}-VpcId"
```

## Módulos (Nested Stacks)

```yaml
# master.yaml
Resources:
  NetworkStack:
    Type: AWS::CloudFormation::Stack
    Properties:
      TemplateURL: https://s3.amazonaws.com/templates/vpc.yaml
      Parameters:
        Environment: !Ref Environment
        VpcCIDR: 10.0.0.0/16

  AppStack:
    Type: AWS::CloudFormation::Stack
    Properties:
      TemplateURL: https://s3.amazonaws.com/templates/app.yaml
      Parameters:
        VpcId: !GetAtt NetworkStack.Outputs.VpcId
        SubnetIds: !GetAtt NetworkStack.Outputs.PublicSubnetIds
```

## Change Sets

```bash
# Crear change set
aws cloudformation create-change-set \
  --stack-name myapp-prod \
  --template-body file://template.yaml \
  --change-set-name upgrade-v2

# Revisar cambios
aws cloudformation describe-change-set \
  --change-set-name upgrade-v2 \
  --stack-name myapp-prod

# Ejecutar
aws cloudformation execute-change-set \
  --change-set-name upgrade-v2 \
  --stack-name myapp-prod
```

## Drift Detection

```bash
aws cloudformation detect-stack-drift --stack-name myapp-prod
```

## Best Practices

1. **Templates pequeños y modulares**: Nested Stacks para infraestructura grande.
2. **Parámetros para entornos**: Values que cambian entre entornos como Parameters.
3. **Outputs y Exports**: Compartir outputs entre stacks con Fn::ImportValue.
4. **Change Sets obligatorios**: Revisar cambios antes de aplicar en producción.
5. **Drift detection**: Ejecutar periódicamente para detectar cambios manuales.
6. **Stack Policies**: Proteger recursos críticos de eliminación accidental.
7. **CI/CD**: Integrar con CodePipeline o GitHub Actions.
