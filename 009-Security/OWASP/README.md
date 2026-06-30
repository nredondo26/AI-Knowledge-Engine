# OWASP — Seguridad en Aplicaciones Web

## Conceptos Fundamentales

OWASP (Open Web Application Security Project) es una comunidad global sin fines de lucro dedicada a mejorar la seguridad del software. Sus proyectos principales son el **OWASP Top 10**, el **ASVS** (Application Security Verification Standard) y el **SAMM** (Software Assurance Maturity Model).

### OWASP Top 10:2021

| Posición | Vulnerabilidad | Descripción | Impacto |
|----------|---------------|-------------|---------|
| A01 | Broken Access Control | Usuarios acceden a recursos sin autorización | Crítico |
| A02 | Cryptographic Failures | Exposición de datos por cifrado débil | Alto |
| A03 | Injection | SQL, NoSQL, OS Command injection | Crítico |
| A04 | Insecure Design | Fallos de diseño que no siguen secure-by-design | Alto |
| A05 | Security Misconfiguration | Configuraciones inseguras por defecto | Alto |
| A06 | Vulnerable Components | Dependencias con CVEs conocidas | Alto |
| A07 | Identification & Auth Failures | Autenticación y sesiones débiles | Crítico |
| A08 | Software & Data Integrity Failures | Actualizaciones sin verificar, CI/CD inseguro | Alto |
| A09 | Security Logging & Monitoring Failures | Falta de detección de incidentes | Medio |
| A10 | Server-Side Request Forgery (SSRF) | Requests a destinos internos | Alto |

## A01 — Broken Access Control

### IDOR (Insecure Direct Object Reference)

```python
# VULNERABLE: usuario accede a datos de otro usuario
@app.get("/api/users/{user_id}")
def get_user(user_id: int):
    user = db.query(User).filter(User.id == user_id).first()
    return {"email": user.email, "ssn": user.ssn}

# SEGURO: verificar propiedad
@app.get("/api/users/{user_id}")
def get_user(user_id: int, current_user: User = Depends(get_current_user)):
    if current_user.id != user_id and not current_user.is_admin:
        raise HTTPException(status_code=403, detail="Access denied")
    user = db.query(User).filter(User.id == user_id).first()
    return {"email": user.email}

# MEJOR: RBAC con políticas
@app.get("/api/users/{user_id}")
@require_permission("users:read")
def get_user(user_id: int, current_user: User = Depends(get_current_user)):
    authorize(current_user, "read", User, user_id)
    user = db.query(User).filter(User.id == user_id).first()
    return UserReadSchema.from_orm(user)
```

### Prueba Automatizada

```python
def test_idor_vulnerability(client, test_users):
    user_token = login_as(client, "user@test.com", "password")
    admin_id = test_users["admin"].id
    response = client.get(
        f"/api/users/{admin_id}",
        headers={"Authorization": f"Bearer {user_token}"},
    )
    assert response.status_code == 403
```

## A03 — Injection

### SQL Injection

```python
# VULNERABLE
query = f"SELECT * FROM users WHERE email = '{email}' AND password = '{password}'"
cursor.execute(query)

# SEGURO: query parametrizada
cursor.execute(
    "SELECT * FROM users WHERE email = %s AND password = %s",
    (email, hashed_password),
)
```

### NoSQL Injection

```python
# VULNERABLE
users = db.users.find({"email": {"$regex": user_input}})

# SEGURO
import re
safe_input = re.escape(user_input)
users = db.users.find({"email": {"$eq": user_input}})
```

### Command Injection

```python
import subprocess

# VULNERABLE
result = subprocess.run(f"ping -c 1 {hostname}", shell=True, capture_output=True)

# SEGURO
result = subprocess.run(
    ["ping", "-c", "1", hostname],
    capture_output=True,
    text=True,
    check=True,
)
```

## A02 — Cryptographic Failures

### Hashing de Contraseñas

```python
from passlib.context import CryptContext

pwd_context = CryptContext(
    schemes=["bcrypt"],
    bcrypt__rounds=12,
    deprecated="auto",
)

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)
```

### Cifrado de Datos Sensibles

```python
from cryptography.fernet import Fernet
import base64, os

class DataEncryptor:
    def __init__(self, key: bytes = None):
        self.key = key or os.urandom(32)
        self.cipher = Fernet(base64.urlsafe_b64encode(self.key))

    def encrypt(self, data: str) -> bytes:
        return self.cipher.encrypt(data.encode())

    def decrypt(self, token: bytes) -> str:
        return self.cipher.decrypt(token).decode()
```

## A07 — Authentication Failures

### JWT Seguro

```python
from datetime import datetime, timedelta
from jose import jwt, JWTError
from uuid import uuid4

SECRET_KEY = "clave-segura-256bits"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE = 15

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE)
    to_encode.update({
        "exp": expire,
        "iat": datetime.utcnow(),
        "jti": str(uuid4()),
    })
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def verify_token(token: str):
    try:
        payload = jwt.decode(
            token, SECRET_KEY, algorithms=[ALGORITHM],
            options={"require": ["exp", "iat", "jti"], "verify_exp": True},
        )
        if is_token_revoked(payload["jti"]):
            raise HTTPException(status_code=401, detail="Token revoked")
        return payload
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
```

## A06 — Vulnerable Components

### SBOM y Dependencias

```bash
# Escaneo de dependencias
pip install pip-audit
pip-audit --requirement requirements.txt

# Trivy para contenedores
trivy image myapp:latest --severity CRITICAL,HIGH
```

```yaml
name: Dependency Security Scan
on:
  pull_request:
    paths:
      - '**/requirements.txt'
      - '**/package.json'
jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Trivy
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'
```

## A05 — Security Misconfiguration

### Headers de Seguridad

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://app.example.com"],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["Authorization", "Content-Type"],
)

@app.middleware("http")
async def add_security_headers(request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    response.headers["Content-Security-Policy"] = "default-src 'self'"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
    return response
```

## A10 — SSRF

```python
import requests, socket, ipaddress
from urllib.parse import urlparse

ALLOWED_DOMAINS = {"api.external.com", "cdn.trusted.com"}
BLOCKED_IPS = {"10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "127.0.0.0/8"}

@app.post("/api/proxy")
def proxy_url(url: str):
    parsed = urlparse(url)
    if parsed.scheme not in ("https",):
        raise HTTPException(status_code=400, detail="Only HTTPS")
    if parsed.hostname not in ALLOWED_DOMAINS:
        raise HTTPException(status_code=403, detail="Domain not allowed")
    ip = socket.gethostbyname(parsed.hostname)
    for blocked in BLOCKED_IPS:
        if ipaddress.IPv4Address(ip) in ipaddress.IPv4Network(blocked):
            raise HTTPException(status_code=403, detail="Internal IP blocked")
    response = requests.get(url, timeout=5)
    return response.text
```

## Best Practices

1. **Security by Design**: Integrar seguridad desde el diseño (threat modeling, STRIDE, attack trees). No añadir seguridad al final.
2. **Defense in Depth**: Múltiples capas de seguridad: WAF, input validation, auth, encryption, logging. Ninguna capa es suficiente sola.
3. **Principle of Least Privilege**: Cada usuario/servicio tiene mínimos permisos necesarios. Usar RBAC + ABAC.
4. **Input Validation**: Validar, sanitizar y rechazar entrada en el servidor. Nunca confiar en validación del frontend.
5. **Zero Trust**: No confiar en ninguna solicitud por defecto. Verificar autenticación, autorización e integridad en cada request.
6. **Secret Management**: Usar vault/KMS para secrets. Nunca hardcodear API keys, passwords o tokens en código o config.
7. **Dependency Scanning**: Escanear dependencias en cada build. Usar Snyk, Trivy, Dependabot, pip-audit. Parchear CVEs críticas en < 24h.
8. **Security Headers**: Implementar CSP, HSTS, X-Frame-Options, X-Content-Type-Options en todas las respuestas HTTP.
9. **Rate Limiting y Throttling**: Proteger contra brute force, DDoS y scraping. Usar Redis + middleware de rate limiting.
10. **Incident Response**: Tener plan de respuesta a incidentes. Loggear eventos de seguridad con contexto suficiente para forense.
