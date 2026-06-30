# Cryptography — Criptografía Aplicada

## Conceptos Fundamentales

La criptografía es la ciencia de proteger información transformándola en formatos ilegibles para terceros no autorizados. Cubre cifrado (confidencialidad), hashing (integridad), firmas digitales (autenticación/no repudio) y derivación de claves.

### Clasificación

- **Cifrado simétrico**: Misma clave para cifrar y descifrar. Rápido, adecuado para grandes volúmenes. Algoritmos: AES, ChaCha20.
- **Cifrado asimétrico (PKI)**: Par de claves (pública/privada). Lento, ideal para intercambio de claves y firmas. Algoritmos: RSA, ECC (ECDSA, Ed25519).
- **Hashing**: Función unidireccional. No reversible. SHA-2/3, BLAKE2 para integridad; bcrypt/argon2 para contraseñas.
- **HMAC**: Hash con clave secreta para autenticación de mensajes.

## Cifrado Simétrico — AES en Modos de Operación

```python
from cryptography.fernet import Fernet

# AES-128 en modo CBC con HMAC
key = Fernet.generate_key()
cipher = Fernet(key)

mensaje = b"Datos sensibles: token=abc123"
token = cipher.encrypt(mensaje)
print(f"Cifrado: {token}")

descifrado = cipher.decrypt(token)
print(f"Descifrado: {descifrado}")
```

### AES-GCM (Autenticado, recomendado)

```python
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os

key = AESGCM.generate_key(bit_length=256)
aesgcm = AESGCM(key)
nonce = os.urandom(12)  # IV de 96 bits para GCM

ciphertext = aesgcm.encrypt(nonce, b"mensaje secreto", b"datos asociados")
plaintext = aesgcm.decrypt(nonce, ciphertext, b"datos asociados")
```

## Cifrado Asimétrico — RSA

```python
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes

# Generación de par de claves
private_key = rsa.generate_private_key(
    public_exponent=65537,
    key_size=2048,
)
public_key = private_key.public_key()

# Cifrado con clave pública
mensaje = b"Secreto compartido"
ciphertext = public_key.encrypt(
    mensaje,
    padding.OAEP(
        mgf=padding.MGF1(algorithm=hashes.SHA256()),
        algorithm=hashes.SHA256(),
        label=None
    )
)

# Descifrado con clave privada
plaintext = private_key.decrypt(ciphertext, padding.OAEP(
    mgf=padding.MGF1(algorithm=hashes.SHA256()),
    algorithm=hashes.SHA256(),
    label=None
))
```

## Hashing de Contraseñas

```python
import bcrypt

password = b"mi_contraseña_segura"
salt = bcrypt.gensalt(rounds=12)  # Cost factor: 2^12 iteraciones
hashed = bcrypt.hashpw(password, salt)

# Verificación
if bcrypt.checkpw(password, hashed):
    print("Contraseña válida")
```

### Con Argon2 (recomendado actualmente)

```python
from argon2 import PasswordHasher

ph = PasswordHasher(
    time_cost=3,     # iteraciones
    memory_cost=65536, # 64 MB
    parallelism=4,    # hilos paralelos
    hash_len=32,
    salt_len=16
)

hash_str = ph.hash("mi_contraseña")
print(f"Hash Argon2: {hash_str}")

try:
    ph.verify(hash_str, "mi_contraseña")
    if ph.check_needs_rehash(hash_str):
        print("El hash necesita actualización")
except:
    print("Contraseña incorrecta")
```

## Firmas Digitales (ECDSA)

```go
package main

import (
    "crypto/ecdsa"
    "crypto/elliptic"
    "crypto/rand"
    "crypto/sha256"
    "fmt"
)

func main() {
    privateKey, _ := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
    publicKey := &privateKey.PublicKey

    mensaje := []byte("Documento legal versión 1.2")
    hash := sha256.Sum256(mensaje)

    r, s, _ := ecdsa.Sign(rand.Reader, privateKey, hash[:])

    valido := ecdsa.Verify(publicKey, hash[:], r, s)
    fmt.Printf("Firma válida: %v\n", valido)
}
```

## TLS/SSL Handshake

```
Cliente                              Servidor
  | ------ ClientHello ---------->    |
  |    (algoritmos soportados)        |
  | <---- ServerHello ------------    |
  |    (algoritmo elegido, cert)      |
  | <---- Certificate ------------    |
  | <---- ServerHelloDone --------    |
  | ------ ClientKeyExchange ---->    |
  |    (pre-master secret cifrado)    |
  | ------ ChangeCipherSpec ----->    |
  | ------ Finished ------------->    |
  | <---- ChangeCipherSpec --------   |
  | <---- Finished ----------------   |
  | ==== Canal Cifrado (AES-GCM) ==== |
```

## Tecnologías Principales

| Algoritmo | Tipo | Uso Principal |
|-----------|------|---------------|
| AES-256-GCM | Simétrico | Cifrado de datos en reposo/tránsito |
| ChaCha20-Poly1305 | Simétrico | Alternativa rápida a AES (mobile, TLS) |
| RSA-4096 | Asimétrico | Intercambio de claves, firmas |
| ECDSA P-256 / Ed25519 | Asimétrico | Firmas eficientes (JWT, TLS, blockchain) |
| SHA-256 / SHA-3 | Hash | Integridad, certificados |
| Argon2id | KDF | Hash de contraseñas (ganador PHC) |
| X25519 | ECDH | Intercambio de claves (Curve25519) |

## Relaciones

- [001-Languages](../../001-Languages/) — Implementaciones en crypto/rsa (Go), cryptography (Python), JCA (Java)
- [Authentication](../Authentication/) — JWT firmados, TLS mutual, cifrado de tokens
- [NetworkSecurity](../NetworkSecurity/) — TLS/IPsec, VPN, certificados
- [CloudSecurity](../CloudSecurity/) — KMS, Cloud HSM, Secrets Manager

## Recursos Recomendados

- Cryptography.io — Documentación de la biblioteca Python
- "Applied Cryptography" — Bruce Schneier
- "Cryptography Engineering" — Ferguson, Schneier, Kohno
- Stanford CS255 (Coursera) — Dan Boneh
- NIST SP 800-175B — Guía de criptografía
- Latacora Crypto Right Answers for App Developers
