# Unit Testing — Pruebas Unitarias

## Conceptos Fundamentales

Las pruebas unitarias verifican el comportamiento de la unidad más pequeña de código (función, método, clase) de forma aislada. Su objetivo es garantizar que cada unidad funcione correctamente según su especificación, detectando regresiones en etapas tempranas del desarrollo.

### Principios FIRST

- **Fast**: Deben ejecutarse en milisegundos. Una suite de 1000 tests no debería tardar > 10s.
- **Isolated**: No dependen de otros tests, orden de ejecución, ni estado compartido.
- **Repeatable**: Mismo resultado siempre, independientemente del entorno.
- **Self-validating**: Resultado binario (pass/fail) sin interpretación manual.
- **Timely**: Escritas antes o durante el desarrollo (TDD), no después.

### La Pirámide de Tests

```
         ╱╲
        ╱  ╲          E2E (lentos, frágiles, pocos)
       ╱    ╲
      ╱────────╲
     ╱  Integration ╲   (algunos)
    ╱────────────────╲
   ╱   Unit Tests     ╲  (rápidos, muchos, 70%+)
  ╱────────────────────╲
```

## Estructura de un Test

### Arrange-Act-Assert (AAA)

```python
import pytest
from datetime import datetime, timedelta
from src.pricing import calculate_discount, CartItem, User

def test_loyalty_discount_applied_correctly():
    # Arrange
    user = User(id=1, tier="gold", member_since=datetime.now() - timedelta(days=400))
    items = [
        CartItem(product_id=101, price=100.0, quantity=2),
        CartItem(product_id=102, price=50.0, quantity=1),
    ]

    # Act
    result = calculate_discount(user, items)

    # Assert
    assert result["subtotal"] == 250.0
    assert result["discount_percent"] == 15.0
    assert result["discount_amount"] == 37.5
    assert result["total"] == 212.5
    assert result["applied_tier"] == "gold"
```

### Given-When-Then (BDD Style)

```python
def test_expired_coupon_not_applied():
    # Given: un cupón expirado
    coupon = Coupon(code="SAVE20", discount=20.0, expires_at=datetime.now() - timedelta(days=1))
    cart = Cart(items=[CartItem(price=100.0, quantity=1)])

    # When: se intenta aplicar el cupón
    result = cart.apply_coupon(coupon)

    # Then: no se aplica descuento
    assert result["applied"] is False
    assert "expired" in result["reason"]
```

## Frameworks y Herramientas

| Lenguaje | Framework | Mocking | Cobertura |
|----------|-----------|---------|-----------|
| Python | pytest | unittest.mock, pytest-mock | pytest-cov |
| JavaScript | Vitest / Jest | vi.mock, jest.mock | c8, istanbul |
| TypeScript | Vitest | vitest.mock | @vitest/coverage |
| Java | JUnit 5 | Mockito, EasyMock | JaCoCo |
| Go | testing (std) | gomock, testify | go test -cover |
| Rust | #[test] (std) | mockall, mockito | tarpaulin |
| .NET | xUnit / NUnit | Moq, NSubstitute | coverlet |

## Patrones de Mocking

```python
from unittest.mock import Mock, patch, MagicMock, PropertyMock
import pytest

# Mock de dependencia externa
def test_send_notification_on_payment():
    email_service = Mock()
    email_service.send.return_value = {"status": "sent", "id": "msg_123"}

    payment = PaymentProcessor(email_service=email_service)
    result = payment.process(amount=100.0, user_email="user@test.com")

    email_service.send.assert_called_once_with(
        to="user@test.com",
        subject="Payment confirmed",
        body=unittest.mock.ANY,
    )
    assert result["notification_sent"] is True

# Patch de módulo
@patch("src.payments.PaymentGateway.charge")
@patch("src.payments.datetime")
def test_payment_with_mocked_charge(mock_datetime, mock_charge):
    mock_charge.return_value = {"id": "ch_123", "status": "succeeded"}
    mock_datetime.now.return_value = datetime(2024, 1, 15, 10, 0, 0)

    result = process_payment(user_id=1, amount=50.0)

    mock_charge.assert_called_once_with(amount=50.0, currency="usd")
    assert result["charge_id"] == "ch_123"

# Property Mock
def test_user_is_admin():
    user = Mock()
    type(user).is_admin = PropertyMock(return_value=True)
    assert user.is_admin is True
```

## Parametrización y Cobertura de Casos

```python
import pytest

@pytest.mark.parametrize("input_val,expected", [
    (0, 0),
    (1, 1),
    (5, 120),
    (10, 3628800),
    pytest.param(-1, None, marks=pytest.mark.xfail(raises=ValueError)),
])
def test_factorial(input_val, expected):
    if input_val < 0:
        with pytest.raises(ValueError):
            factorial(input_val)
    else:
        assert factorial(input_val) == expected

# Fixture para datos comunes
@pytest.fixture
def sample_user():
    return User(
        id=1,
        name="Alice",
        email="alice@test.com",
        roles=["user", "admin"],
    )

@pytest.fixture
def admin_client(sample_user):
    return APIClient(user=sample_user, token="admin_token_123")

def test_admin_can_delete_user(admin_client):
    response = admin_client.delete("/api/users/2")
    assert response.status_code == 204
```

## Pruebas de Excepciones y Casos Borde

```python
def test_division_by_zero_raises_error():
    with pytest.raises(ZeroDivisionError, match="division by zero"):
        divide(10, 0)

def test_empty_cart_raises_error():
    with pytest.raises(ValueError, match="Cart cannot be empty"):
        checkout([])

def test_negative_quantity_clamped():
    result = add_to_cart(product_id=1, quantity=-5)
    assert result["quantity"] == 1  # valor mínimo

def test_boundary_discount_tiers():
    # Justo en el límite de 12 meses → 10%
    user = User(member_since=datetime.now() - timedelta(days=365))
    discount = calculate_discount(user, [basic_item()])
    assert discount["discount_percent"] == 10.0

    # Un día más → 15%
    user = User(member_since=datetime.now() - timedelta(days=366))
    discount = calculate_discount(user, [basic_item()])
    assert discount["discount_percent"] == 15.0
```

## Cobertura de Código

```bash
# Medir cobertura con pytest
pytest --cov=src --cov-report=term-missing --cov-fail-under=80 tests/

# Generar reporte HTML
pytest --cov=src --cov-report=html

# Ignorar líneas específicas en cobertura
def fallback_handler():  # pragma: no cover
    return "Este código no se prueba directamente"
```

```ini
# .coveragerc
[run]
source = src
omit = */migrations/*, */tests/*, *__init__.py

[report]
exclude_lines =
    pragma: no cover
    def __repr__
    raise NotImplementedError
    if __name__ == .__main__.:
```

## Best Practices

1. **Un assert por concepto**: Cada test debe verificar una sola cosa. Usar múltiples asserts solo si están lógicamente relacionados.
2. **Nombrar tests descriptivamente**: `test_[unidad]_[escenario]_[resultado_esperado]`. El nombre debe explicar qué prueba.
3. **Sin lógica en tests**: No usar if/for/while en tests. Cada test es una secuencia lineal de Arrange → Act → Assert.
4. **DRY con fixtures, no con herencia**: Usar fixtures de pytest, no setUp/tearDown. Las factories son mejores que fixtures globales.
5. **Mockear fronteras**: Solo mockear I/O externa (DB, red, filesystem, clock). No mockear el propio sistema bajo test.
6. **Preferir valores reales**: Usar `email="user@test.com"` en vez de `email=any_string()`. Hace el test más legible.
7. **Cobertura > 80%**: No obsesionarse con 100%. Las líneas no cubiertas deben ser explícitamente justificadas (error handlers, logging).
8. **Test de mutaciones**: Usar mutmut (Python) o Stryker (JS) para validar que los tests detectan cambios en la lógica.
9. **Aislar el estado**: No compartir estado entre tests. Usar `autouse` fixtures para resetear singletons o cachés.
10. **CI pipeline**: Ejecutar tests unitarios en cada commit. Fallar el build si cobertura baja del umbral.
