# CloudSecurity — Seguridad en la Nube

## Conceptos Fundamentales

La seguridad en la nube abarca políticas, tecnologías y controles para proteger datos, aplicaciones e infraestructura en entornos cloud. Se basa en el **Modelo de Responsabilidad Compartida** (Shared Responsibility Model), donde el proveedor asegura la nube y el cliente asegura lo que pone en ella.

### Shared Responsibility Model

| Capa | AWS | Azure | GCP | Cliente |
|------|-----|-------|-----|---------|
| Datos | — | — | — | ✓ |
| Aplicaciones | — | — | — | ✓ |
| Identity & Access | — | — | — | ✓ |
| Sistema Operativo | — | — | — | ✓ |
| Virtualización | ✓ | ✓ | ✓ | — |
| Red Física | ✓ | ✓ | ✓ | — |
| Centro de Datos | ✓ | ✓ | ✓ | — |

## IAM (Identity and Access Management)

### Política AWS IAM (JSON)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::mi-bucket-seguro",
        "arn:aws:s3:::mi-bucket-seguro/*"
      ],
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "10.0.0.0/16"
        },
        "Bool": {
          "aws:SecureTransport": "true"
        }
      }
    }
  ]
}
```

### Roles vs Users

```hcl
# Terraform: Rol para EC2 con acceso a S3
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_readonly"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_read" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
```

## KMS (Key Management Service)

```go
import (
    "context"
    "github.com/aws/aws-sdk-go-v2/service/kms"
)

func encryptWithKMS(client *kms.Client, plaintext []byte) ([]byte, error) {
    result, err := client.Encrypt(context.TODO(), &kms.EncryptInput{
        KeyId:     aws.String("alias/mi-clave"),
        Plaintext: plaintext,
    })
    return result.CiphertextBlob, err
}

func decryptWithKMS(client *kms.Client, ciphertext []byte) ([]byte, error) {
    result, err := client.Decrypt(context.TODO(), &kms.DecryptInput{
        CiphertextBlob: ciphertext,
    })
    return result.Plaintext, err
}
```

## WAF (Web Application Firewall)

```hcl
# AWS WAF: Bloquear SQL injection y XSS
resource "aws_wafv2_web_acl" "app_waf" {
  name        = "app-waf"
  scope       = "REGIONAL"

  default_action { allow {} }

  rule {
    name     = "block-sqli"
    priority = 1
    action   = { block {} }

    statement {
      sqli_match_statement {
        field_to_match { body {} }
        text_transformation {
          priority = 1
          type     = "URL_DECODE"
        }
      }
    }
  }

  rule {
    name     = "block-xss"
    priority = 2
    action   = { block {} }

    statement {
      xss_match_statement {
        field_to_match { query_string {} }
        text_transformation {
          priority = 1
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }
  }
}
```

## CloudTrail / GuardDuty (Auditoría y Detección)

```bash
# Configurar CloudTrail para registrar todas las acciones
aws cloudtrail create-trail \
  --name audit-trail \
  --s3-bucket-name mi-bucket-audit-logs \
  --is-multi-region-trail \
  --enable-log-file-validation

# Habilitar GuardDuty
aws guardduty create-detector --enable

# Ver hallazgos de seguridad
aws guardduty list-findings --detector-id <detector_id>
```

## Secrets Manager

```python
import boto3
from botocore.exceptions import ClientError

def get_db_secret():
    session = boto3.session.Session()
    client = session.client('secretsmanager')
    
    try:
        response = client.get_secret_value(
            SecretId='prod/rds/mydb'
        )
        return json.loads(response['SecretString'])
    except ClientError as e:
        print(f"Error accediendo a secreto: {e}")
        return None

# Rotación automática: Lambda + Secrets Manager
```

## Tecnologías Principales

| Servicio | AWS | Azure | GCP |
|----------|-----|-------|-----|
| IAM | AWS IAM | Entra ID / RBAC | Cloud IAM |
| KMS | AWS KMS + CloudHSM | Azure Key Vault | Cloud KMS |
| WAF | AWS WAF | Azure WAF | Cloud Armor |
| SIEM/Detección | GuardDuty, Security Hub | Microsoft Sentinel | Security Command Center |
| Secrets | Secrets Manager | Key Vault | Secret Manager |
| HSM | CloudHSM | Dedicated HSM | Cloud HSM |

## Relaciones

- [IAM (Authentication)](../Authentication/) — Identidad federada, SSO con OIDC/SAML
- [Cryptography](../Cryptography/) — KMS, HSM, cifrado en reposo/tránsito
- [NetworkSecurity](../NetworkSecurity/) — Security Groups, NACL, WAF, DDoS
- [SIEM](../SIEM/) — CloudTrail logs, GuardDuty findings
- [DevSecOps](../DevSecOps/) — Infrastructure as Code scanning (Checkov, Terrascan)

## Recursos Recomendados

- AWS Security Documentation — docs.aws.amazon.com/security
- Azure Security Best Practices — learn.microsoft.com/security
- GCP Security Foundation — cloud.google.com/security
- CSA (Cloud Security Alliance) — cloudsecurityalliance.org
- "AWS Security" — Dylan Shields (O'Reilly)
- Well-Architected Framework — Security Pillar (AWS)
