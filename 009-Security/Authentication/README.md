# Authentication — Autenticación y Gestión de Identidad

## Conceptos Fundamentales

La autenticación es el proceso de verificar la identidad de un usuario, servicio o dispositivo. A diferencia de la autorización (qué puede hacer), la autenticación responde a **quién eres**. Es la primera línea de defensa en cualquier sistema.

### Factores de Autenticación

- **Algo que sabes**: Contraseña, PIN, respuesta a pregunta secreta
- **Algo que tienes**: Teléfono (OTP/TOTP), hardware token (YubiKey), tarjeta inteligente
- **Algo que eres**: Huella digital, reconocimiento facial, voz, iris (biométricos)
- **Algo que haces**: Firma manuscrita, patrón de escritura, ritmo de tecleo
- **Alguna ubicación**: Geolocalización, rango de IP, red corporativa

### MFA (Autenticación Multifactor)

Usar al menos 2 factores diferentes mejora drásticamente la seguridad. Por ejemplo: contraseña (sabes) + TOTP (tienes). El 99.9% de los ataques de account takeover se bloquean con MFA.

## Protocolos de Autenticación

### OAuth 2.0 + OpenID Connect

OAuth 2.0 delega autorización, OIDC añade autenticación. Juntos forman el estándar moderno:

```python
# Flujo Authorization Code + PKCE (recomendado para SPAs)
from authlib.integrations.starlette_client import OAuth
from starlette.config import Config

config = Config(".env")
oauth = OAuth(config)

oauth.register(
    name="google",
    client_id="GOOGLE_CLIENT_ID",
    client_secret="GOOGLE_CLIENT_SECRET",
    server_metadata_url="https://accounts.google.com/.well-known/openid-configuration",
    client_kwargs={"scope": "openid profile email"},
)

@app.get("/auth/login")
async def login(request: Request):
    redirect_uri = request.url_for("auth_callback")
    return await oauth.google.authorize_redirect(request, redirect_uri)

@app.get("/auth/callback")
async def auth_callback(request: Request):
    token = await oauth.google.authorize_access_token(request)
    userinfo = token.get("userinfo")
    # userinfo contiene: sub, email, name, picture, etc.
    session_token = create_session_token(userinfo["sub"])
    response = RedirectResponse(url="/dashboard")
    response.set_cookie(
        key="session",
        value=session_token,
        httponly=True,
        secure=True,
        samesite="lax",
        max_age=86400,
    )
    return response
```

### SAML 2.0 (Enterprise)

Usado principalmente en entornos corporativos con Active Directory:

```xml
<!-- SP Metadata -->
<EntityDescriptor entityID="https://app.example.com/saml/metadata">
  <SPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
    <AssertionConsumerService
      Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
      Location="https://app.example.com/saml/acs"
      index="0"/>
  </SPSSODescriptor>
</EntityDescriptor>
```

### WebAuthn / Passkeys (FIDO2)

Autenticación sin contraseña usando criptografía de clave pública:

```javascript
// Registro WebAuthn (navegador)
const credential = await navigator.credentials.create({
  publicKey: {
    challenge: Uint8Array.from(serverChallenge, c => c.charCodeAt(0)),
    rp: { name: "Example Corp", id: "example.com" },
    user: {
      id: Uint8Array.from(userId, c => c.charCodeAt(0)),
      name: "user@example.com",
      displayName: "Alice",
    },
    pubKeyCredParams: [{ alg: -7, type: "public-key" }],
    authenticatorSelection: {
      authenticatorAttachment: "platform",
      residentKey: "required",
      userVerification: "required",
    },
  },
});

// Autenticación WebAuthn
const assertion = await navigator.credentials.get({
  publicKey: {
    challenge: Uint8Array.from(challenge, c => c.charCodeAt(0)),
    allowCredentials: credentialIds.map(id => ({
      id: Uint8Array.from(atob(id), c => c.charCodeAt(0)),
      type: "public-key",
    })),
    userVerification: "required",
  },
});
```

## Gestión de Sesiones

### Session Tokens Seguros

```python
import secrets
import hashlib
import hmac
from datetime import datetime, timedelta

class SessionManager:
    def __init__(self, redis_client):
        self.redis = redis_client
        self.secret_key = get_secret("session-secret")

    def create_session(self, user_id: str, ttl: int = 86400) -> str:
        session_id = secrets.token_urlsafe(32)
        session_data = {
            "user_id": user_id,
            "created_at": datetime.utcnow().isoformat(),
            "ip": current_ip,
            "user_agent": current_ua,
        }
        self.redis.setex(
            f"session:{session_id}",
            ttl,
            json.dumps(session_data),
        )
        return session_id

    def validate_session(self, session_id: str) -> dict:
        data = self.redis.get(f"session:{session_id}")
        if not data:
            raise HTTPException(status_code=401, detail="Session expired")
        return json.loads(data)

    def revoke_session(self, session_id: str):
        self.redis.delete(f"session:{session_id}")

    def revoke_all_user_sessions(self, user_id: str):
        # Rotar clave de sesión del usuario (invalida todas las sesiones)
        self.redis.set(f"session_rotation:{user_id}", secrets.token_hex(16))
```

### Refresh Token Rotation

```python
class TokenService:
    def rotate_refresh_token(self, old_refresh_token: str) -> tuple[str, str]:
        """Rotación de refresh token (invalida el anterior)."""
        stored = self.redis.get(f"refresh:{old_refresh_token}")
        if not stored:
            raise HTTPException(status_code=401, detail="Invalid refresh token")
        # Revocar anterior
        self.redis.delete(f"refresh:{old_refresh_token}")
        # Crear nuevo par
        new_access = self.create_access_token(stored["user_id"])
        new_refresh = secrets.token_urlsafe(48)
        self.redis.setex(
            f"refresh:{new_refresh}",
            REFRESH_TTL,
            json.dumps({"user_id": stored["user_id"]}),
        )
        return new_access, new_refresh
```

## JWT Avanzado

```python
from jose import jwt, JWTError
from cryptography.hazmat.primitives import serialization

# JWT con RS256 (asimétrico) — recomendado para microservicios
class JWTService:
    def __init__(self):
        with open("/etc/certs/jwt-private.pem", "rb") as f:
            self.private_key = serialization.load_pem_private_key(f.read(), password=None)
        with open("/etc/certs/jwt-public.pem", "rb") as f:
            self.public_key = serialization.load_pem_public_key(f.read())

    def encode(self, payload: dict) -> str:
        payload.update({
            "iss": "auth.example.com",
            "aud": "api.example.com",
            "iat": datetime.utcnow(),
            "nbf": datetime.utcnow(),
        })
        return jwt.encode(payload, self.private_key, algorithm="RS256")

    def decode(self, token: str) -> dict:
        return jwt.decode(
            token, self.public_key,
            algorithms=["RS256"],
            audience="api.example.com",
            options={
                "require": ["exp", "iat", "iss", "aud", "sub"],
                "verify_exp": True,
            },
        )
```

## Rate Limiting en Login

```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

@app.post("/auth/login")
@limiter.limit("5/minute")  # 5 intentos por minuto por IP
async def login(request: Request, form: LoginForm):
    # Verificar bloqueo por usuario
    lock_key = f"lockout:{form.email}"
    if await redis.exists(lock_key):
        ttl = await redis.ttl(lock_key)
        raise HTTPException(
            status_code=429,
            detail=f"Account locked. Try again in {ttl} seconds",
        )

    user = authenticate_user(form.email, form.password)
    if not user:
        # Incrementar contador de fallos
        attempts = await redis.incr(f"attempts:{form.email}")
        await redis.expire(f"attempts:{form.email}", 900)  # 15 min
        if attempts >= 5:
            await redis.setex(lock_key, 1800)  # Lock 30 min
            raise HTTPException(status_code=429, detail="Account locked")
        raise HTTPException(status_code=401, detail="Invalid credentials")

    # Login exitoso: resetear contadores
    await redis.delete(f"attempts:{form.email}")
    return create_session(user.id)
```

## Almacenamiento Seguro de Contraseñas

```python
import hashlib, os

# Usar Argon2id (recomendado por OWASP)
from argon2 import PasswordHasher, exceptions

ph = PasswordHasher(
    time_cost=3,        # 3 iteraciones
    memory_cost=65536,  # 64 MB
    parallelism=4,      # 4 hilos
    hash_len=32,
    salt_len=16,
)

def hash_password(password: str) -> str:
    return ph.hash(password)
    # Output: $argon2id$v=19$m=65536,t=3,p=4$<salt>$<hash>

def verify_password(password: str, hashed: str) -> bool:
    try:
        return ph.verify(hashed, password)
    except exceptions.VerifyMismatchError:
        return False
    except exceptions.VerificationError:
        return False
```

## Best Practices

1. **Hash de contraseñas**: Usar Argon2id o bcrypt (cost >= 12). **Nunca** usar MD5, SHA-1 o SHA-256 directamente para contraseñas.
2. **MFA obligatorio**: Para acceso administrativo, paneles de control y operaciones sensibles (transferencias, cambio de email).
3. **Session timeout**: Sesiones cortas (15-60 min). Refresh tokens con rotación. Invalidar todas las sesiones al cambiar contraseña.
4. **JWTs seguros**: Usar RS256/ES256 (asimétrico) en microservicios. No incluir datos sensibles en el payload (está firmado, no encriptado).
5. **Rate limiting en login**: Implementar rate limiting por IP y por usuario. Bloquear cuenta tras N intentos fallidos (5-10).
6. **Protección contra brute force**: Delay progresivo + CAPTCHA después de intentos fallidos. Notificar al usuario por email.
7. **Secure cookies**: `HttpOnly`, `Secure`, `SameSite=Strict/Lax`. No almacenar tokens en localStorage (vulnerable a XSS).
8. **OAuth state + PKCE**: Siempre usar state para prevenir CSRF en OAuth. PKCE es obligatorio para SPAs (no tienen client_secret).
9. **Account enumeration**: No revelar si el email existe o no. Mensaje genérico: "Invalid credentials" (no "User not found").
10. **Audit logging**: Loggear todos los eventos de autenticación (login, logout, fallo, MFA, cambio de contraseña) con timestamp, IP, user-agent.
