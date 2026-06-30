# TDD — Test-Driven Development

## Conceptos Fundamentales

Test-Driven Development (TDD) es una metodología de desarrollo donde los tests se escriben **antes** del código de producción. Sigue el ciclo **Red-Green-Refactor**: escribir un test que falla (Red), hacerlo pasar con el mínimo código posible (Green), y luego mejorar el diseño sin cambiar comportamiento (Refactor).

### El Ciclo TDD

```
┌────────────────────────────────────────────────────┐
│                    1. RED                           │
│    Escribir un test que falla                      │
│    (define el comportamiento esperado)             │
│          │                                         │
│          ▼                                         │
│                    2. GREEN                         │
│    Escribir el mínimo código para pasar el test    │
│    (sin preocuparse por calidad del código)        │
│          │                                         │
│          ▼                                         │
│                    3. REFACTOR                      │
│    Mejorar el código manteniendo los tests verdes  │
│    (eliminar duplicación, mejorar diseño)          │
│          │                                         │
│          └───────────┐ ┌───────────────────────────┘
│                      ▼ ▼                           │
│              Repetir ciclo para                    │
│              siguiente requisito                   │
└────────────────────────────────────────────────────┘
```

### Beneficios Clave

- **Diseño emergente**: El código se diseña desde la perspectiva del consumidor (el test), produciendo APIs más limpias y acopladas.
- **Regression safety**: El 100% del código tiene tests. Cualquier cambio que rompa funcionalidad se detecta instantáneamente.
- **Documentación viva**: Los tests son la especificación ejecutable del sistema. Definen el comportamiento esperado sin ambigüedad.
- **Menos debugging**: Si un test falla, el error está en el último cambio. No hay semanas de debugging.
- **Refactoring seguro**: Se puede mejorar el diseño continuamente sin miedo a introducir bugs.

## Ejemplo Paso a Paso: Calculadora de Descuentos

### Paso 1: RED — Escribir el primer test

```python
# test_pricing.py
import pytest
from src.pricing import calculate_discount

def test_no_discount_for_basic_user():
    """Un usuario básico sin historial no recibe descuento."""
    result = calculate_discount(
        user_tier="basic",
        total_purchases=0.0,
        member_months=1,
    )
    assert result == 0.0
```

Ejecutamos: `pytest test_pricing.py` → **FAIL** (`ModuleNotFoundError: No module named 'src.pricing'`)

### Paso 2: GREEN — Mínimo código para pasar

```python
# src/pricing.py
def calculate_discount(user_tier: str, total_purchases: float, member_months: int) -> float:
    return 0.0
```

Ejecutamos: `pytest test_pricing.py` → **PASS**

### Paso 3: RED — Segundo test

```python
def test_gold_user_gets_ten_percent():
    """Usuario gold recibe 10% de descuento."""
    result = calculate_discount(
        user_tier="gold",
        total_purchases=500.0,
        member_months=12,
    )
    assert result == 10.0
```

Ejecutamos → **FAIL**: `assert 0.0 == 10.0`

### Paso 4: GREEN — Código mínimo

```python
def calculate_discount(user_tier: str, total_purchases: float, member_months: int) -> float:
    if user_tier == "gold":
        return 10.0
    return 0.0
```

Ejecutamos → **PASS**

### Paso 5: RED — Tercer test (caso borde)

```python
def test_gold_user_above_threshold_gets_fifteen():
    """Usuario gold con más de 1000 USD en compras recibe 15%."""
    result = calculate_discount(
        user_tier="gold",
        total_purchases=1500.0,
        member_months=12,
    )
    assert result == 15.0
```

### Paso 6: GREEN — Implementación real

```python
def calculate_discount(user_tier: str, total_purchases: float, member_months: int) -> float:
    if user_tier == "gold":
        if total_purchases >= 1000.0:
            return 15.0
        return 10.0
    return 0.0
```

### Paso 7: REFACTOR — Mejorar diseño

```python
DISCOUNT_TIERS = {
    "basic": {"base": 0.0, "threshold": float('inf'), "bonus": 0.0},
    "silver": {"base": 5.0, "threshold": 500.0, "bonus": 5.0},
    "gold": {"base": 10.0, "threshold": 1000.0, "bonus": 5.0},
    "platinum": {"base": 15.0, "threshold": 2000.0, "bonus": 10.0},
}

def calculate_discount(user_tier: str, total_purchases: float, member_months: int) -> float:
    tier = DISCOUNT_TIERS.get(user_tier, DISCOUNT_TIERS["basic"])
    discount = tier["base"]
    if total_purchases >= tier["threshold"]:
        discount += tier["bonus"]
    return discount
```

Ejecutamos todos los tests → **PASS**. El diseño mejoró sin cambiar comportamiento.

## Fakes vs Mocks en TDD

TDD clásico (London School vs Detroit School):

```python
# Detroit School (clásico) — usa implementaciones reales o fakes
class InMemoryPaymentGateway:
    def __init__(self):
        self.charges = []

    def charge(self, amount, currency="usd"):
        self.charges.append({"amount": amount, "currency": currency})
        return {"id": f"ch_{len(self.charges)}", "status": "succeeded"}

def test_payment_with_fake_gateway():
    gateway = InMemoryPaymentGateway()
    service = PaymentService(gateway=gateway)
    result = service.process_payment(50.0)
    assert result["status"] == "succeeded"
    assert len(gateway.charges) == 1

# London School — usa mocks para colaboradores
@patch("src.payments.PaymentGateway")
def test_payment_with_mock_gateway(mock_gateway_class):
    mock_gateway = Mock()
    mock_gateway.charge.return_value = {"id": "ch_123", "status": "succeeded"}
    mock_gateway_class.return_value = mock_gateway

    service = PaymentService()
    result = service.process_payment(50.0)

    mock_gateway.charge.assert_called_once_with(amount=50.0, currency="usd")
    assert result["status"] == "succeeded"
```

## TDD en APIs REST

```python
# test_api.py
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

# RED: especificar comportamiento
def test_create_user_returns_201():
    response = client.post("/api/users", json={
        "name": "Alice",
        "email": "alice@test.com",
    })
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Alice"
    assert "id" in data

# GREEN: mínimo endpoint
# @app.post("/api/users") → return {"id": 1, "name": "Alice", "email": "alice@test.com"}

# RED: validación de email
def test_create_user_invalid_email_returns_422():
    response = client.post("/api/users", json={
        "name": "Bob",
        "email": "not-an-email",
    })
    assert response.status_code == 422

# GREEN: añadir validación
# from pydantic import EmailStr
# class UserCreate(BaseModel): email: EmailStr

# REFACTOR: extraer lógica de validación a schema
```

## TDD con Bases de Datos

```python
import pytest
from datetime import datetime

@pytest.mark.asyncio
async def test_create_order_persists_in_db():
    # Usar base de datos en memoria para tests
    db = await get_test_database()

    service = OrderService(db)
    order = await service.create_order(
        user_id=1,
        items=[{"product_id": 101, "quantity": 2}],
    )

    # Verificar persistencia
    saved = await db.orders.find_one({"id": order["id"]})
    assert saved is not None
    assert saved["user_id"] == 1
    assert saved["total"] == 200.0
    assert saved["status"] == "pending"
    assert "created_at" in saved
```

## TDD para Algoritmos

```python
# RED: especificar el comportamiento del algoritmo
def test_levenshtein_distance_basic():
    assert levenshtein_distance("kitten", "sitting") == 3
    assert levenshtein_distance("", "") == 0
    assert levenshtein_distance("abc", "abc") == 0

# GREEN: implementación mínima
def levenshtein_distance(a, b):
    if not a:
        return len(b)
    if not b:
        return len(a)
    if a[0] == b[0]:
        return levenshtein_distance(a[1:], b[1:])
    return 1 + min(
        levenshtein_distance(a[1:], b),      # delete
        levenshtein_distance(a, b[1:]),      # insert
        levenshtein_distance(a[1:], b[1:]),  # replace
    )

# RED: test de performance (para inputs grandes)
def test_levenshtein_large_strings():
    import time
    start = time.time()
    result = levenshtein_distance("a" * 100, "b" * 100)
    elapsed = time.time() - start
    assert result == 100
    assert elapsed < 0.1  # debe ser rápido

# GREEN + REFACTOR: implementación con DP (O(n*m))
def levenshtein_distance(a, b):
    m, n = len(a), len(b)
    dp = list(range(n + 1))
    for i in range(1, m + 1):
        prev = dp[0]
        dp[0] = i
        for j in range(1, n + 1):
            temp = dp[j]
            if a[i - 1] == b[j - 1]:
                dp[j] = prev
            else:
                dp[j] = 1 + min(prev, dp[j], dp[j - 1])
            prev = temp
    return dp[n]
```

## Best Practices

1. **Tests atómicos**: Cada test cubre un único comportamiento. Si un test falla, sabes exactamente qué requisito no se cumple.
2. **Sin dependencias entre tests**: Los tests deben poder ejecutarse en cualquier orden. Usar `reset` en setUp para estado compartido.
3. **Rojo → Verde lo más rápido posible**: En la fase Green, escribe el código más simple que haga pasar el test. No anticipes requisitos futuros (YAGNI).
4. **Refactor sin miedo**: Los tests son la red de seguridad. Refactoriza agresivamente: extrae métodos, mejora nombres, elimina duplicación.
5. **Triangle TDD**: Cuando tengas 3 tests que cubren el mismo método, es momento de refactorizar.
6. **Nombrar tests como especificaciones**: `test_[escenario]_[resultado]`. Ej: `test_user_with_expired_card_payment_declined`.
7. **No probar el framework**: No escribas tests para verificar que Django/FastAPI/Express funciona. Confía en el framework. Prueba tu lógica.
8. **TDD en legacy**: Para código legacy sin tests, escribe **Characterization Tests** primero (test que captura el comportamiento actual), luego refactoriza.
9. **Parejas de programación**: TDD funciona muy bien en pair programming (navegador escribe test, conductor implementa).
10. **Baby steps**: Si un test es muy grande, divídelo. Si el paso de RED a GREEN es muy complejo, da pasos más pequeños.
