# AppSec — Seguridad en Aplicaciones

## Conceptos Fundamentales

AppSec (Application Security) abarca las prácticas, herramientas y procesos para identificar, corregir y prevenir vulnerabilidades en el software durante todo su ciclo de vida. Se integra en el SDLC (Software Development Lifecycle) mediante el enfoque **Shift Left** — detectar problemas cuanto antes.

### Categorías de Pruebas de Seguridad

| Tipo | Sigla | Descripción |
|------|-------|-------------|
| Static Analysis | SAST | Analiza código fuente sin ejecutarlo |
| Dynamic Analysis | DAST | Prueba la aplicación en ejecución |
| Software Composition | SCA | Analiza dependencias y bibliotecas |
| Interactive Testing | IAST | Combina SAST + DAST en runtime |
| Runtime Protection | RASP | Protege la app desde dentro |
| Fuzzing | — | Envía datos malformados para hallar bugs |

## SAST — Static Application Security Testing

### Semgrep (Reglas personalizadas)

```yaml
# semgrep_rules.yaml
rules:
  - id: avoid-hardcoded-secrets
    patterns:
      - pattern: |
          $PASSWORD = "..."
      - pattern-not: |
          $PASSWORD = os.environ.get("...")
    message: "No hardcodear contraseñas. Usar variables de entorno o secrets manager."
    severity: ERROR
    languages: [python]
    metadata:
      cwe: CWE-798

  - id: sql-injection-detection
    patterns:
      - pattern: |
          cursor.execute(f"...{...}...")
    message: "Posible SQL injection. Usar parámetros en lugar de f-strings."
    severity: ERROR
    languages: [python]
    metadata:
      cwe: CWE-89
```

### Integración SAST en CI/CD

```yaml
# .github/workflows/sast.yml
name: SAST Security Scan
on: [push, pull_request]

jobs:
  semgrep:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Semgrep
        uses: semgrep/semgrep-action@v1
        with:
          config: >
            p/python
            p/owasp-top-ten
            semgrep_rules.yaml
          json: true
          output: semgrep-report.json

      - name: Block on critical findings
        run: |
          critical=$(jq '.results | map(select(.severity == "ERROR")) | length' semgrep-report.json)
          if [ "$critical" -gt 0 ]; then
            echo "Se encontraron $critical vulnerabilidades críticas"
            exit 1
          fi
```

## DAST — Dynamic Application Security Testing

### OWASP ZAP en Pipeline

```yaml
# docker-compose para ZAP
services:
  zap:
    image: ghcr.io/zaproxy/zaproxy:stable
    command: >
      zap.sh -cmd -quickurl http://target-app:8080
      -quickprogress -quickout /zap/zap_report.html
    volumes:
      - ./reports:/zap
    network_mode: "service:target"

  target:
    build: .
    ports:
      - "8080:8080"
```

### Escaneo automatizado con ZAP API

```python
from zapv2 import ZAPv2

zap = ZAPv2(apikey='changeme', proxies={'http': 'http://localhost:8080'})

# Iniciar spider
print("Spidering target...")
zap.spider.scan('http://target-app:8080')
while int(zap.spider.status()) < 100:
    time.sleep(1)

# Escaneo activo
print("Active scanning...")
zap.ascan.scan('http://target-app:8080')
while int(zap.ascan.status()) < 100:
    time.sleep(5)

# Reporte de alertas
alerts = zap.core.alerts(baseurl='http://target-app:8080')
for alert in alerts:
    print(f"[{alert['risk']}] {alert['alert']}: {alert['url']}")
```

## SCA — Software Composition Analysis

### Trivy (Escaneo de dependencias)

```bash
# Escanear dependencias de un proyecto
trivy fs --scanners vuln,secret,misconfig .

# Escanear imagen Docker
trivy image python:3.12-slim

# Escanear SBOM generado
trivy sbom bom.json

# Modo exit code: fallar si hay CVEs críticas
trivy fs --severity CRITICAL,HIGH --exit-code 1 .
```

### SBOM (Software Bill of Materials)

```bash
# Generar SBOM con Syft
syft packages ./app -o cyclonedx-json > sbom.cyclonedx.json

# Verificar SBOM con Grype
grype sbom:./sbom.cyclonedx.json --fail-on high
```

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "components": [
    {
      "type": "library",
      "name": "requests",
      "version": "2.31.0",
      "purl": "pkg:pypi/requests@2.31.0",
      "licenses": [{"license": {"id": "Apache-2.0"}}]
    },
    {
      "type": "library",
      "name": "django",
      "version": "4.2.10",
      "purl": "pkg:pypi/django@4.2.10",
      "licenses": [{"license": {"id": "BSD-3-Clause"}}]
    }
  ]
}
```

## Secret Scanning

```yaml
# .gitleaks.toml
[allowlist]
  description = "Allowlisted paths and commits"
  paths = [
    "test/**/*",
    "*.test.*"
  ]

[rule]
  id = "aws-access-token"
  description = "AWS Access Token"
  regex = '''\bAKIA[0-9A-Z]{16}\b'''
  tags = ["aws", "credential"]
  keywords = ["AKIA"]

[rule]
  id = "github-pat"
  description = "GitHub Personal Access Token"
  regex = '''\bghp_[0-9a-zA-Z]{36}\b'''
  tags = ["github", "credential"]
```

## Tecnologías Principales

| Categoría | Herramientas |
|-----------|-------------|
| SAST | Semgrep, SonarQube, CodeQL, Checkmarx, Fortify |
| DAST | OWASP ZAP, Burp Suite, Acunetix, Netsparker |
| SCA | Trivy, Snyk, Dependabot, Renovate, Grype |
| Secret Scanning | Gitleaks, TruffleHog, git-secrets |
| Fuzzing | AFL++, libFuzzer, OSS-Fuzz |
| RASP | Contrast Protect, Hdiv, Sqreen |

## Relaciones

- [OWASP](../OWASP/) — OWASP Top 10 como guía principal para AppSec
- [DevSecOps](../DevSecOps/) — Integración de herramientas AppSec en CI/CD
- [SIEM](../SIEM/) — Alertas de RASP/IAST enviadas al SIEM
- [IncidentResponse](../IncidentResponse/) — Vulnerabilidades explotadas → incidentes

## Recursos Recomendados

- OWASP Application Security Verification Standard (ASVS)
- OWASP Cheat Sheet Series
- PortSwigger Web Security Academy — labs gratuitos de Burp Suite
- "The Web Application Hacker's Handbook" — Stuttard & Pinto
- Semgrep Playground — semgrep.dev/playground
- SANS Secure Coding Guidelines
