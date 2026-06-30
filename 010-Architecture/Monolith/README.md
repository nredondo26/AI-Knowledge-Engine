# Monolith — Arquitectura Monolítica

## Conceptos Fundamentales

Un monolito es una aplicación donde todos los componentes (UI, lógica de negocio, acceso a datos) se empaquetan y despliegan como una sola unidad. Es la arquitectura más simple y la más común en proyectos pequeños y medianos. A pesar de su mala reputación actual, sigue siendo una opción válida para muchos escenarios.

### Características

- **Despliegue único**: Un solo artefacto (JAR, WAR, binario, imagen Docker).
- **Base de datos centralizada**: Una sola base de datos compartida por todos los módulos.
- **Comunicación in-process**: Los módulos se llaman mediante funciones/métodos (no hay latencia de red).
- **Estado compartido**: Variables en memoria compartidas entre componentes.

### Cuándo Usar un Monolito

| A favor | En contra |
|---------|-----------|
| Simplicidad inicial | Difícil de escalar horizontalmente |
| Baja latencia (sin red) | Acoplamiento aumenta con el tiempo |
| Fácil de testear (unit + integración) | Despliegues lentos y riesgosos |
| Un solo punto de monitoreo | Stack tecnológico único |
| Ideal para equipos pequeños (2-10) | Difficultad para adopción gradual |

## Estructura de un Monolito Moderno (Módulos)

```
proyecto/
├── modulo-usuarios/
│   ├── controlador/
│   ├── servicio/
│   └── repositorio/
├── modulo-pedidos/
│   ├── controlador/
│   ├── servicio/
│   └── repositorio/
├── modulo-pagos/
│   ├── controlador/
│   ├── servicio/
│   └── repositorio/
├── modulo-productos/
│   ├── controlador/
│   ├── servicio/
│   └── repositorio/
├── shared/
│   ├── dto/
│   ├── excepciones/
│   └── util/
└── config/
```

### Ejemplo en Python (FastAPI monolítico con módulos)

```python
# app/modules/users/service.py
from sqlalchemy.orm import Session
from app.database import get_db
from app.modules.users.models import User

class UserService:
    def __init__(self, db: Session = Depends(get_db)):
        self.db = db

    def get_user(self, user_id: int) -> User:
        return self.db.query(User).filter(User.id == user_id).first()

    def create_user(self, user_data: dict) -> User:
        user = User(**user_data)
        self.db.add(user)
        self.db.commit()
        return user

# app/modules/orders/service.py
class OrderService:
    def __init__(self, invoice_service: InvoiceService):
        self.invoice_service = invoice_service

    def place_order(self, order_data):
        # Llamada in-process al módulo de facturación
        invoice = self.invoice_service.generate(
            order_data["items"])
        return {"order_id": order_data["id"], "invoice": invoice}

# app/main.py
from fastapi import FastAPI
from app.modules.users import router as users_router
from app.modules.orders import router as orders_router

app = FastAPI(title="Monolith App")
app.include_router(users_router.router, prefix="/api/users")
app.include_router(orders_router.router, prefix="/api/orders")
```

## Estrategias para Mantener un Monolito Saludable

### 1. Módulos con interfaces bien definidas

```python
# interfaces de módulo para evitar acoplamiento directo
class PaymentGateway(ABC):
    @abstractmethod
    def charge(self, amount: Decimal, token: str) -> str: ...

class InvoiceService(ABC):
    @abstractmethod
    def generate(self, items: list) -> Invoice: ...
```

### 2. Paquete por feature, no por capa

```
# ❌ Agrupado por capa
controllers/usuarios.py
controllers/pedidos.py
services/usuarios.py
services/pedidos.py

# ✅ Agrupado por feature/módulo
usuarios/controlador.py
usuarios/servicio.py
usuarios/modelo.py
pedidos/controlador.py
pedidos/servicio.py
pedidos/modelo.py
```

### 3. Base de datos: esquemas por módulo

```sql
-- En lugar de tablas mezcladas, prefijar por módulo
CREATE SCHEMA IF NOT EXISTS usuarios;
CREATE SCHEMA IF NOT EXISTS pedidos;

CREATE TABLE usuarios.usuarios (id SERIAL PRIMARY KEY, ...);
CREATE TABLE pedidos.pedidos (id SERIAL PRIMARY KEY, ...);
```

## Transición a Microservicios (Strangler Fig)

```python
# Proxy para migración gradual
from flask import Flask, request, Response
import requests
import json

app = Flask(__name__)

# Mapa de rutas a migrar a servicio independiente
MIGRATED_ROUTES = {
    "/api/pagos": "http://payment-service:8080",
    "/api/notificaciones": "http://notification-service:8080",
}

@app.route("/<path:subpath>", methods=["GET", "POST", "PUT", "DELETE"])
def router(subpath):
    full_path = f"/api/{subpath}"
    
    for prefix, target in MIGRATED_ROUTES.items():
        if full_path.startswith(prefix):
            # Redirigir al nuevo microservicio
            resp = requests.request(
                method=request.method,
                url=f"{target}{full_path}",
                headers=request.headers,
                data=request.get_data(),
            )
            return Response(resp.content, resp.status_code)
    
    # Pasar al monolito
    return proxied_request_to_monolith(full_path, request)
```

## Tecnologías Principales

| Framework | Lenguaje | Características |
|-----------|----------|-----------------|
| Django | Python | Monolito por diseño, batteries included |
| Rails | Ruby | Convención sobre configuración, rápido |
| Spring Boot | Java | Modularizable con paquetes por feature |
| ASP.NET Core | C# | Clean Architecture con proyectos separados |
| Laravel | PHP | MVC clásico con módulos |

## Relaciones

- [Hexagonal](../Hexagonal/) — Aplicar puertos/adaptadores incluso en monolitos
- [DDD](../DDD/) — Bounded contexts dentro del monolito
- [CQRS](../CQRS/) — Separar lecturas/escrituras sin salir del monolito
- [SOA](../SOA/) — El monolito puede ser un servicio dentro de una SOA
- [Microservices](../Microservices/) — Evolución natural cuando el monolito crece demasiado

## Recursos Recomendados

- "Monolith First" — Martin Fowler (martinfowler.com)
- "Building Evolutionary Architectures" — Ford, Parsons, Kua
- "Just say no to microservices" — Ben Morris (YouTube)
- SIG Group — Aplicación modular en monolito vs. microservicios
- Strangler Fig Application — Martin Fowler
