# Fixtures — Datos de Prueba

## Conceptos Fundamentales

Las fixtures son datos, objetos o estados predefinidos que se configuran antes de ejecutar tests y se limpian después. Su objetivo es proporcionar un contexto conocido y reproducible para que los tests sean deterministas y fáciles de escribir.

### Ciclo de Vida

```
Setup (fixture) → Test → Teardown (limpieza)
```

## pytest Fixtures

```python
import pytest
from datetime import datetime, timedelta
from src.models import User, Order, Product

# Fixture básica
@pytest.fixture
def sample_user():
    return User(
        id=1,
        name="Alice",
        email="alice@test.com",
        roles=["user", "admin"],
        created_at=datetime.now(),
    )

# Fixture con autouse (se ejecuta sin necesidad de inyectarla)
@pytest.fixture(autouse=True)
def setup_test_db():
    db = create_test_database()
    yield db
    drop_test_database(db)

# Fixture parametrizada
@pytest.fixture(params=["basic", "gold", "platinum"])
def user_tier(request):
    return request.param
```

### Alcances (Scope)

| Scope | Duración | Uso típico |
|-------|----------|------------|
| `function` | Por test (default) | Datos aislados |
| `class` | Por clase de test | Configuración de clase |
| `module` | Por archivo | Conexión a DB compartida |
| `session` | Toda la ejecución | Cliente HTTP, singleton |

```python
@pytest.fixture(scope="session")
def api_client():
    return httpx.Client(base_url="http://localhost:8000")

@pytest.fixture(scope="module")
def db_session():
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    session = Session(engine)
    yield session
    session.close()
```

### Fixtures Compuestas

```python
@pytest.fixture
def sample_order(sample_user):
    return Order(user_id=sample_user.id, total=150.0, status="pending")

@pytest.fixture
def admin_client(sample_user):
    return APIClient(auth_token="admin_token_123", user=sample_user)

def test_cancel_order(sample_order, admin_client):
    response = admin_client.post(f"/api/orders/{sample_order.id}/cancel")
    assert response.status_code == 200
```

## Factory Boy (Python)

```python
import factory
from src.models import User, Order

class UserFactory(factory.Factory):
    class Meta:
        model = User

    id = factory.Sequence(lambda n: n)
    name = factory.Faker("name")
    email = factory.LazyAttribute(lambda u: f"{u.name.lower().replace(' ', '.')}@test.com")
    is_active = True

class OrderFactory(factory.Factory):
    class Meta:
        model = Order

    id = factory.Sequence(lambda n: n)
    user = factory.SubFactory(UserFactory)
    total = factory.Faker("pydecimal", left_digits=4, right_digits=2, positive=True)
    status = "pending"

# Uso en tests
def test_order_total():
    order = OrderFactory(total=100.0)
    assert order.total == 100.0

def test_multiple_orders():
    orders = OrderFactory.create_batch(3)
    assert len(orders) == 3
```

## Fixtures para Base de Datos

```python
# fixtures/db.py
import pytest
from sqlalchemy import create_engine, event
from sqlalchemy.orm import Session

@pytest.fixture
def db_session():
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    connection = engine.connect()
    transaction = connection.begin()
    session = Session(bind=connection)

    # Cargar datos semilla
    seed_data(session)
    session.flush()

    yield session

    session.close()
    transaction.rollback()
    connection.close()
```

## Best Practices

1. **Aisladas e independientes**: Cada test con sus fixtures o compartidas seguramente (scope module/session para objetos inmutables).
2. **Limpieza automática**: Usar teardown (yield) o rollback de transacciones.
3. **Factory over fixture global**: Preferir factories (Factory Boy) sobre fixtures fijas.
4. **Datos mínimos**: Solo los datos necesarios para el test.
5. **Nombrar descriptivamente**: `sample_user`, `admin_client`, `empty_cart`.
