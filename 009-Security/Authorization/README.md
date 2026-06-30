# Authorization — Control de Acceso y Gestión de Permisos

## Conceptos Fundamentales

La autorización determina **qué puede hacer** un usuario o servicio dentro de un sistema después de haber sido autenticado. Mientras la autenticación responde "¿quién eres?", la autorización responde "¿qué se te permite hacer?".

### Modelos de Autorización

- **RBAC (Role-Based Access Control)**: Los permisos se asignan a roles, y los roles se asignan a usuarios. Es el modelo más común en aplicaciones empresariales.
- **ABAC (Attribute-Based Access Control)**: Las decisiones se basan en atributos del usuario, recurso, entorno y acción. Más flexible y granular que RBAC.
- **ReBAC (Relationship-Based Access Control)**: Los permisos derivan de relaciones entre entidades (ej: "es propietario de", "es miembro de").
- **PBAC (Policy-Based Access Control)**: Usa políticas explícitas (ej: AWS IAM Policies, OPA/Rego) para definir permisos.

## RBAC — Implementación Práctica

### Estructura de Tablas

```sql
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE permissions (
    id SERIAL PRIMARY KEY,
    resource VARCHAR(100) NOT NULL,   -- ej: 'documents', 'users'
    action VARCHAR(50) NOT NULL,      -- ej: 'create', 'read', 'update', 'delete'
    UNIQUE(resource, action)
);

CREATE TABLE role_permissions (
    role_id INTEGER REFERENCES roles(id),
    permission_id INTEGER REFERENCES permissions(id),
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE user_roles (
    user_id INTEGER REFERENCES users(id),
    role_id INTEGER REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id)
);
```

### Middleware de Autorización (Python/FastAPI)

```python
from fastapi import Depends, HTTPException, status
from functools import wraps

def require_permission(resource: str, action: str):
    async def permission_checker(current_user = Depends(get_current_user)):
        if not current_user:
            raise HTTPException(status_code=401)
        if not has_permission(current_user.id, resource, action):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Permiso denegado: {action} en {resource}"
            )
        return current_user
    return permission_checker

@app.get("/documents/{doc_id}")
async def get_document(
    doc_id: int,
    user = Depends(require_permission("documents", "read"))
):
    return {"document_id": doc_id, "content": "Documento seguro"}
```

## ABAC con Políticas Rego/OPA

### Política Rego

```rego
package authz

default allow = false

allow {
    input.action == "read"
    input.resource.type == "document"
    input.user.role == "editor"
}

allow {
    input.action == "delete"
    input.resource.type == "document"
    input.user.role == "admin"
    input.resource.owner == input.user.id
}

allow {
    input.action == "read"
    input.resource.type == "document"
    input.resource.public == true
}
```

### Evaluación desde Go

```go
package main

import (
    "context"
    "encoding/json"
    "fmt"
    "github.com/open-policy-agent/opa/rego"
)

func main() {
    ctx := context.Background()
    query := `data.authz.allow`

    input := map[string]interface{}{
        "user": map[string]interface{}{
            "id":   "user123",
            "role": "editor",
        },
        "action": "read",
        "resource": map[string]interface{}{
            "type":  "document",
            "owner": "user456",
        },
    }

    r := rego.New(rego.Query(query), rego.Load([]string{"policy.rego"}, nil))
    rs, _ := r.Eval(ctx, rego.EvalInput(input))
    fmt.Println("Allow:", rs[0].Expressions[0].Value)
}
```

## OAuth 2.0 Scopes como Autorización

Los scopes de OAuth 2.0 son permisos que el cliente solicita y el usuario aprueba:

```
# Scope definitions
scope: documents:read         # Leer documentos
scope: documents:write        # Crear/editar documentos
scope: documents:delete       # Eliminar documentos
scope: admin:users            # Gestionar usuarios (solo admins)
```

### Validación de Scopes (Node.js/Express)

```javascript
const jwt = require('jsonwebtoken');

function requireScope(scope) {
    return (req, res, next) => {
        const token = req.headers.authorization?.split(' ')[1];
        const payload = jwt.verify(token, process.env.JWT_SECRET);
        if (!payload.scopes || !payload.scopes.includes(scope)) {
            return res.status(403).json({
                error: 'insufficient_scope',
                message: `Se requiere scope: ${scope}`
            });
        }
        req.user = payload;
        next();
    };
}

app.get('/api/documents',
    requireScope('documents:read'),
    (req, res) => res.json({ docs: [] })
);
```

## Tecnologías Principales

| Herramienta | Propósito |
|-------------|-----------|
| OPA (Open Policy Agent) | Políticas unificadas (Rego) para RBAC/ABAC |
| Casbin | Biblioteca de control de acceso en Go, Python, Java, Node.js |
| AWS IAM | RBAC/ABAC para servicios AWS con policies en JSON |
| Keycloak | RBAC y ABAC con administración centralizada |
| Auth0 / Okta | Autorización como servicio con scopes OAuth 2.0 |
| Google Zanzibar | Sistema global de ReBAC (SpiceDB como OSS) |
| permit.io | Plataforma de autorización como servicio (RBAC, ABAC, ReBAC) |

## Relaciones

- [Authentication](../Authentication/) — La autorización siempre sigue a la autenticación
- [OWASP](../OWASP/) — Broken Access Control (A01) es la vulnerabilidad #1 del Top 10
- [AppSec](../AppSec/) — Pruebas de autorización en el SDLC (SAST, DAST)
- [010-Architecture/DDD](../../010-Architecture/DDD/) — Modelado de permisos como parte del dominio

## Recursos Recomendados

- OPA Documentation — openpolicyagent.org/docs
- Casbin Documentation — casbin.org
- "Authorization in Action" — libro sobre OPA y Rego
- SpiceDB: Google Zanzibar Inspired Open Source — authzed.com
- OWASP Authorization Cheat Sheet
