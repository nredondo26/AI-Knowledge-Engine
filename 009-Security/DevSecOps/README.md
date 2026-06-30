# DevSecOps — Seguridad en el Ciclo de Desarrollo

## Conceptos Fundamentales

DevSecOps integra la seguridad en cada fase del ciclo de vida del desarrollo de software (SDLC), automatizando controles de seguridad en los pipelines de CI/CD. El lema es **"Shift Left"** — mover la seguridad lo más temprano posible en el desarrollo, y **"Security as Code"** — tratar políticas y configuraciones de seguridad como código versionado.

### Principios Clave

- **Automation**: Escaneos SAST, DAST, SCA y secret scanning automatizados en CI/CD.
- **Policy as Code**: Políticas de seguridad definidas como código (OPA, Kyverno, Checkov).
- **Continuous Compliance**: Verificar cumplimiento normativo en cada build.
- **Security Gates**: Bloquear depliegues si no se superan los controles de seguridad.

## Pipeline DevSecOps Completo

```yaml
# .github/workflows/devsecops.yml
name: DevSecOps Pipeline
on: [push, pull_request]

jobs:
  security-checks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # 1. SAST - Análisis estático
      - name: Semgrep SAST
        uses: semgrep/semgrep-action@v1
        with:
          config: p/owasp-top-ten
          json: true

      # 2. Secret Scanning
      - name: Gitleaks
        uses: gitleaks/gitleaks-action@v2
        with:
          config-path: .gitleaks.toml

      # 3. SCA - Dependencias
      - name: Trivy vulnerability scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'

  build-and-scan:
    needs: security-checks
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Build Docker image
        run: docker build -t app:${{ github.sha }} .

      # 4. Escaneo de imagen Docker
      - name: Scan Docker image
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'image'
          scan-ref: 'app:${{ github.sha }}'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'

      # 5. Pruebas DAST (post-deploy)
      - name: Deploy to staging
        run: docker run -d -p 8080:8080 app:${{ github.sha }}

      - name: OWASP ZAP Scan
        uses: zaproxy/action-full-scan@v0.10.0
        with:
          target: 'http://localhost:8080'
          fail_action: true
```

## Policy as Code con Checkov (IaC Security)

```python
# checkov_custom_rules.py
from checkov.common.models.enums import CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class S3PublicAccessBlock(BaseResourceCheck):
    def __init__(self):
        name = "Ensure S3 bucket has public access block"
        id = "CUSTOM_AWS_001"
        supported_resources = ['aws_s3_bucket']
        categories = [CheckCategories.GENERAL_SECURITY]
        super().__init__(name=name, id=id, categories=categories)

    def scan_resource_conf(self, conf):
        if 'block_public_acls' in conf and \
           conf['block_public_acls'][0] == True:
            return CheckResult.PASSED
        return CheckResult.FAILED

check = S3PublicAccessBlock()
```

```hcl
# main.tf — Terraform validado por Checkov
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "mi-bucket-seguro"
  
  # Sin esto, Checkov fallará
  # checkov:skip=CUSTOM_AWS_001: "Bucket público permitido temporalmente"
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.secure_bucket.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

## Container Security en DevSecOps

```dockerfile
# Dockerfile — Construcción segura multi-stage
FROM python:3.12-slim AS builder
RUN pip install --no-cache-dir poetry
COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt > requirements.txt

FROM python:3.12-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    tini \
    && rm -rf /var/lib/apt/lists/*

# No ejecutar como root
RUN groupadd -r app && useradd -r -g app app

COPY --from=builder requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=app:app app/ /app

USER app
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["python", "/app/main.py"]

# HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/health || exit 1
```

### Kubernetes Security Context

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: app
          image: app:latest
          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop: ["ALL"]
            readOnlyRootFilesystem: true
            runAsUser: 1000
            runAsGroup: 1000
```

## Software Supply Chain Security

### Verificación de Artefactos (SLSA)

```bash
# Firmar imagen Docker con Cosign
cosign generate-key-pair
cosign sign --key cosign.key ghcr.io/user/app:latest

# Verificar firma
cosign verify --key cosign.pub ghcr.io/user/app:latest

# Verificar proveniencia SLSA
slsa-verifier verify-artifact \
  --provenance-path attestation.intoto.jsonl \
  --source-uri github.com/user/repo \
  --source-tag v1.0.0 \
  app.binary
```

```yaml
# GitHub Actions: SLSA provenance
jobs:
  build:
    permissions:
      id-token: write
      contents: read
    uses: slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@v2.0.0
    with:
      base64-subjects: "${{ needs.build.outputs.digest }}"
```

## Tecnologías Principales

| Categoría | Herramientas |
|-----------|-------------|
| SAST | Semgrep, SonarQube, CodeQL, Checkmarx |
| SCA | Trivy, Snyk, Dependabot, Renovate, Grype |
| Secret Scanning | Gitleaks, TruffleHog, git-secrets |
| IaC Scanning | Checkov, Terrascan, tfsec, KICS |
| Container Scan | Trivy, Grype, Clair, Anchore |
| Supply Chain | Cosign, SLSA Framework, in-toto |
| Policy as Code | OPA, Kyverno, Checkov, Sentinel |

## Relaciones

- [AppSec](../AppSec/) — Herramientas SAST/DAST/SCA integradas en CI/CD
- [CloudSecurity](../CloudSecurity/) — IaC scanning (Checkov/Terrascan) para cloud
- [SIEM](../SIEM/) — Eventos de seguridad del pipeline enviados a SIEM
- [ZeroTrust](../ZeroTrust/) — Policy as Code con OPA/Kyverno en K8s
- [010-Architecture/Solid](../../010-Architecture/Solid/) — Código más mantenible → menos vulnerabilidades

## Recursos Recomendados

- OWASP DevSecOps Guideline
- SLSA Framework — slsa.dev
- "Securing DevOps" — Julien Vehent (Manning)
- CNCF Supply Chain Security Whitepaper
- GitHub Security Lab — securitylab.github.com
- Docker Security Cheat Sheet — OWASP
