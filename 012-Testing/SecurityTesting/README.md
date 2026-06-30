# Security Testing — Pruebas de Seguridad

## Conceptos Fundamentales

Las pruebas de seguridad evalúan las vulnerabilidades de una aplicación para identificar riesgos antes de que sean explotados. Deben integrarse en todo el ciclo de desarrollo (DevSecOps) y cubrir múltiples capas: código, infraestructura, dependencias y configuración.

### OWASP Top 10 (2021)

| Posición | Vulnerabilidad |
|----------|---------------|
| A01 | Broken Access Control |
| A02 | Cryptographic Failures |
| A03 | Injection (SQL, NoSQL, OS, LDAP) |
| A04 | Insecure Design |
| A05 | Security Misconfiguration |
| A06 | Vulnerable and Outdated Components |
| A07 | Identification and Authentication Failures |
| A08 | Software and Data Integrity Failures |
| A09 | Security Logging and Monitoring Failures |
| A10 | Server-Side Request Forgery (SSRF) |

## SAST — Static Application Security Testing

```yaml
# .github/workflows/sast.yaml
name: SAST Scan
on: [push]
jobs:
  semgrep:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: semgrep/semgrep-action@v1
        with:
          config: p/default
          auditOn: push
```

```bash
# Bandit para Python
bandit -r src/ -f json -o reports/bandit.json

# Semgrep con reglas personalizadas
semgrep --config p/owasp-top-ten --error src/
```

## DAST — Dynamic Application Security Testing

```python
# ZAP Python API
from zapv2 import ZAPv2

zap = ZAPv2(apikey="apikey", proxies={"http": "http://localhost:8080"})
zap.urlopen("https://staging.example.com")
zap.spider.scan("https://staging.example.com")
zap.ascan.scan("https://staging.example.com")

while int(zap.ascan.status()) < 100:
    time.sleep(5)

alerts = zap.core.alerts()
for alert in alerts:
    print(f"{alert['alert']}: {alert['risk']} - {alert['url']}")
```

## Pruebas de Dependencias

```bash
# Snyk
snyk test --all-projects --severity-threshold=high

# npm audit
npm audit --audit-level=high

# Trivy (imágenes Docker)
trivy image myapp:latest --severity CRITICAL,HIGH

# OWASP Dependency-Check
dependency-check --scan . --format HTML --out reports/
```

## Pruebas de API Seguridad

```python
import requests

def test_sql_injection():
    payloads = ["' OR '1'='1", "'; DROP TABLE users--", "\" OR 1=1--"]
    for payload in payloads:
        resp = requests.get(f"https://api.example.com/users?email={payload}")
        assert resp.status_code == 400 or resp.status_code == 422

def test_idor():
    # Insecure Direct Object Reference
    user_a_token = login("alice@test.com", "pass123")
    headers = {"Authorization": f"Bearer {user_a_token}"}
    resp = requests.get("https://api.example.com/users/2/orders", headers=headers)
    assert resp.status_code == 403  # No debe acceder a pedidos de otro

def test_rate_limiting():
    for _ in range(100):
        resp = requests.post("https://api.example.com/auth/login", json={
            "email": "test@test.com", "password": "wrong",
        })
    assert resp.status_code == 429
```

## Configuración de Headers de Seguridad

```python
# Middleware en FastAPI
from fastapi import FastAPI
from starlette.middleware.base import BaseHTTPMiddleware

app = FastAPI()

security_headers = {
    "X-Content-Type-Options": "nosniff",
    "X-Frame-Options": "DENY",
    "X-XSS-Protection": "1; mode=block",
    "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
    "Content-Security-Policy": "default-src 'self'",
    "Referrer-Policy": "strict-origin-when-cross-origin",
}

@app.middleware("http")
async def add_headers(request, call_next):
    response = await call_next(request)
    response.headers.update(security_headers)
    return response
```

## Best Practices

1. **Shift left**: SAST en cada commit, no esperar a tener el código completo.
2. **Severity thresholds**: Fallar build con vulnerabilidades critical/high.
3. **Pentesting regular**: Pruebas de penetración 1-2 veces al año.
4. **Dependency scanning**: Escanear dependencias en cada PR (Dependabot).
5. **Secretos en vault**: Nunca committear secrets. Usar Vault o SOPS.
6. **Logging seguro**: No loguear datos sensibles (passwords, tokens, PII).
