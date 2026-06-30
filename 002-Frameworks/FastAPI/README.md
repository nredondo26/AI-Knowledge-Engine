# FastAPI

## Descripción

FastAPI es un framework web moderno y rápido para construir APIs con Python 3.8+, basado en **Starlette** (para el manejo HTTP) y **Pydantic** (para la validación de datos). Desarrollado por Sebastián Ramírez en 2018, destaca por su alto rendimiento (comparable a Node.js y Go), generación automática de documentación interactiva (OpenAPI + Swagger UI / ReDoc) y tipado estricto con type hints.

FastAPI es la opción preferida para microservicios, APIs RESTful, WebSockets y aplicaciones que requieren alta concurrencia gracias a su soporte nativo de `async/await`.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Path Operations** | Decoradores (`@app.get`, `@app.post`) que asocian métodos HTTP a funciones. |
| **Pydantic Models** | Clases que definen la estructura de datos con validación automática mediante type hints. |
| **Dependency Injection** | Sistema de dependencias reutilizables (autenticación, sesiones BD, permisos). |
| **Path / Query Parameters** | Parámetros extraídos de la URL (`/items/{id}`) o query string (`?skip=0`). |
| **Validación automática** | Basada en tipos Python; genera errores 422 con detalle. |
| **Documentación automática** | Swagger UI en `/docs` y ReDoc en `/redoc`. |
| **Async support** | Soporte nativo de `async def` para endpoints sin bloqueo. |
| **Background Tasks** | Tareas ejecutadas después de responder al cliente. |
| **WebSockets** | Soporte completo para comunicación bidireccional en tiempo real. |
| **Middlewares** | Procesamiento global de peticiones/respuestas (CORS, logging, etc.). |

---

## Ejemplos de código

### API REST básica

```python
from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel
from typing import Optional

app = FastAPI(title="Mi API", version="1.0.0")

# --- Modelos ---
class ItemCreate(BaseModel):
    nombre: str
    precio: float
    descripcion: Optional[str] = None

class Item(ItemCreate):
    id: int

# --- Datos simulados ---
items_db: list[Item] = []
contador = 1

# --- Endpoints ---
@app.get("/items", response_model=list[Item])
def listar_items(skip: int = 0, limit: int = 10):
    return items_db[skip : skip + limit]

@app.get("/items/{item_id}", response_model=Item)
def obtener_item(item_id: int):
    for item in items_db:
        if item.id == item_id:
            return item
    raise HTTPException(status_code=404, detail="Item no encontrado")

@app.post("/items", response_model=Item, status_code=status.HTTP_201_CREATED)
def crear_item(item: ItemCreate):
    global contador
    nuevo = Item(id=contador, **item.model_dump())
    items_db.append(nuevo)
    contador += 1
    return nuevo
```

### Dependencias y autenticación

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

security = HTTPBearer()

# Dependencia de autenticación
def verificar_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    if token != "mi-token-secreto":
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)
    return token

# Dependencia de paginación reutilizable
def paginacion(skip: int = 0, limit: int = 10):
    return {"skip": skip, "limit": limit}

@app.get("/usuarios/me")
def obtener_perfil(token: str = Depends(verificar_token)):
    return {"usuario": "admin", "token": token}

@app.get("/protegido/datos")
def datos_protegidos(pag: dict = Depends(paginacion)):
    return {"mensaje": "Acceso autorizado", "pag": pag}
```

### Async + SQLAlchemy (patrón repositorio)

```python
from fastapi import FastAPI, Depends
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text

DATABASE_URL = "postgresql+asyncpg://user:pass@localhost/db"
engine = create_async_engine(DATABASE_URL)
AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

@app.get("/health")
async def health_check(db: AsyncSession = Depends(get_db)):
    result = await db.execute(text("SELECT 1"))
    return {"status": "ok", "db": result.scalar() == 1}
```

### Background tasks

```python
from fastapi import BackgroundTasks

def enviar_email(direccion: str, mensaje: str):
    # Simular envío de email
    import time
    time.sleep(2)
    print(f"Email enviado a {direccion}: {mensaje}")

@app.post("/registro")
def registrar_usuario(email: str, background: BackgroundTasks):
    background.add_task(enviar_email, email, "Bienvenido!")
    return {"mensaje": "Usuario registrado. Email en camino."}
```

### Manejo de errores global

```python
from fastapi import Request
from fastapi.responses import JSONResponse

class AppException(Exception):
    def __init__(self, codigo: int, mensaje: str):
        self.codigo = codigo
        self.mensaje = mensaje

@app.exception_handler(AppException)
async def app_exception_handler(request: Request, exc: AppException):
    return JSONResponse(
        status_code=exc.codigo,
        content={"error": exc.mensaje, "tipo": "AppException"},
    )
```

---

## Hoja de ruta

```
1. Python moderno
   ├── Type hints avanzados (Optional, Union, Literal, Annotated)
   ├── async/await, asyncio
   └── Context managers

2. Fundamentos de FastAPI
   ├── Instalación con pip / uv
   ├── Path operations (GET, POST, PUT, DELETE)
   ├── Path parameters, Query parameters, Request body
   └── Documentación interactiva (/docs, /redoc)

3. Validación con Pydantic v2
   ├── Modelos, Field (default, ge, le, pattern)
   ├── Validación personalizada (field_validator, model_validator)
   └── Config (orm_mode, populate_by_name)

4. Dependency Injection (DI)
   ├── Depends() y dependencias anidadas
   ├── Clases como dependencias (DB session, auth)
   ├── Global dependencies
   └── Dependencias con yield (context managers)

5. Base de datos
   ├── SQLAlchemy 2.0 (sync y async)
   ├── Tortoise-ORM (async nativo)
   ├── Alembic para migraciones
   └── Patrón repository + unit of work

6. Autenticación y seguridad
   ├── OAuth2 con Password Bearer (JWT)
   ├── HTTPBasic, API Keys
   ├── Middleware CORS y CSRF
   └── Rate limiting (slowapi)

7. Pruebas
   ├── TestClient de Starlette (httpx)
   ├── Fixtures con pytest-asyncio
   └── Pruebas de integración con BD de prueba

8. Producción
   ├── Uvicorn + Gunicorn (workers)
   ├── Docker multi-stage
   ├── Logging estructurado (structlog)
   ├── Métricas con Prometheus
   └── CI/CD y despliegue

9. Ecosistema
   ├── Background tasks y Celery
   ├── WebSockets
   ├── File uploads (UploadFile)
   ├── Cache (Redis, aiocache)
   └── OpenAPI avanzado (tags, responses, examples)
```
