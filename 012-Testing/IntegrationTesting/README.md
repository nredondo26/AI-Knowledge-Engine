# Integration Testing — Pruebas de Integración

## Conceptos Fundamentales

Las pruebas de integración verifican que los diferentes módulos, servicios o capas de una aplicación funcionen correctamente al interactuar entre sí. Se sitúan en el nivel medio de la pirámide de tests y son clave para detectar fallos de comunicación entre componentes.

### ¿Qué probar en integración?

- **Base de datos**: Consultas, migraciones, transacciones, constraints.
- **APIs internas**: Comunicación entre microservicios (REST, gRPC, GraphQL).
- **Colas y eventos**: Producer → Broker → Consumer.
- **Servicios externos**: APIs de terceros, proveedores cloud, servicios de pago.
- **Caché**: Redis/Memcached en conjunto con la lógica de negocio.

## Pruebas de Base de Datos

```python
# test_user_repository.py
import pytest
from src.database import get_db_session, Base
from src.repositories.user_repo import UserRepository
from src.models.user import User

@pytest.fixture
def db_session():
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    session = Session(engine)
    yield session
    session.close()

def test_create_and_retrieve_user(db_session):
    repo = UserRepository(db_session)
    user = User(name="Alice", email="alice@test.com")
    repo.save(user)

    retrieved = repo.get_by_email("alice@test.com")
    assert retrieved is not None
    assert retrieved.name == "Alice"
    assert retrieved.id is not None
```

### Testcontainers (PostgreSQL real en Docker)

```python
import pytest
from testcontainers.postgres import PostgresContainer

@pytest.fixture(scope="module")
def postgres():
    with PostgresContainer("postgres:16") as pg:
        yield pg.get_connection_url()

def test_user_persistence(postgres):
    # Se conecta a PostgreSQL real en contenedor Docker
    engine = create_engine(postgres)
    # resto del test...
```

## Pruebas de API REST

```python
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_create_user_integration():
    # Este test prueba el endpoint completo con DB real
    response = client.post("/api/users", json={
        "name": "Alice",
        "email": "alice@test.com",
        "password": "Secure123!",
    })
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Alice"
    assert "id" in data

    # Verificar que persiste en DB
    get_resp = client.get(f"/api/users/{data['id']}")
    assert get_resp.status_code == 200
```

## Pruebas de Colas (RabbitMQ / Redis Queue)

```python
import pytest
from src.queue import publish_event, consume_events

def test_event_publish_consume():
    # Publicar evento
    publish_event("user.created", {"user_id": 1, "email": "alice@test.com"})

    # Consumir y verificar
    messages = consume_events("user.created")
    assert len(messages) == 1
    assert messages[0]["user_id"] == 1
```

## Estrategias de Data Setup

| Estrategia | Descripción | Ventaja |
|------------|-------------|---------|
| **Real DB** | Base de datos real (testcontainer) | Mayor fidelidad |
| **In-memory** | SQLite :memory: o H2 | Velocidad |
| **Transactional** | Rollback automático al finalizar | Aislamiento |
| **Fixtures** | Datos precargados con factories | Reutilización |

## Configuración de Entorno

```python
# conftest.py
import pytest
import os

@pytest.fixture(autouse=True)
def setup_test_env():
    os.environ["DATABASE_URL"] = "sqlite:///:memory:"
    os.environ["REDIS_URL"] = "redis://localhost:6379/1"
    os.environ["STRIPE_API_KEY"] = "sk_test_..."
    yield
    os.environ.pop("DATABASE_URL", None)
```

## Best Practices

1. **Aislar el estado**: Datos conocidos con rollback o reset entre tests.
2. **No mockear lo que se integra**: Usar PostgreSQL real (testcontainer).
3. **Fixture factories**: `factory_boy` o builders para datos complejos.
4. **Categorizar tests**: Separar unit de integration con markers.
5. **CI segmentado**: Unit → Integration → E2E.
