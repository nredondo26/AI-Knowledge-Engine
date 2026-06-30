# BDD — Behavior-Driven Development

## Conceptos Fundamentales

BDD es una metodología ágil que extiende TDD usando lenguaje natural (Gherkin) para describir el comportamiento del software desde la perspectiva del usuario. Fomenta la colaboración entre desarrolladores, QA y negocio mediante escenarios legibles por humanos.

### El Ciclo BDD

```
Feature (Gherkin) → Step Definitions (Código) → Automatización → Validación
     ↑                                                              │
     └─────────────────────── Feedback ────────────────────────────┘
```

### Gherkin — Lenguaje de Escenarios

```gherkin
# features/checkout.feature
Feature: Proceso de compra
  Como usuario registrado
  Quiero poder comprar productos
  Para recibirlos en mi domicilio

  Background:
    Given un usuario autenticado con email "alice@test.com"
    And un producto "Camiseta" con precio $29.99 en stock

  Scenario: Compra exitosa con tarjeta de crédito
    When añade "Camiseta" al carrito
    And procede al checkout
    And ingresa su dirección de envío "123 Main St"
    And paga con tarjeta terminada en "4242"
    Then la orden se crea con estado "confirmed"
    And se envía un email de confirmación
```

## Behave (Python)

### Step Definitions

```python
# features/steps/checkout_steps.py
from behave import given, when, then
from src.services import CheckoutService, PaymentGateway
from src.models import User, Product, Order

@given("un usuario autenticado con email {email}")
def step_authenticated_user(context, email):
    context.user = User(email=email, is_authenticated=True)
    context.checkout = CheckoutService(context.user)

@given("un producto {name} con precio ${price} en stock")
def step_product_in_stock(context, name, price):
    context.product = Product(name=name, price=float(price), stock=10)

@when("añade {product_name} al carrito")
def step_add_to_cart(context, product_name):
    context.checkout.add_to_cart(context.product)

@when("procede al checkout")
def step_proceed_checkout(context):
    pass  # Navegar a la pantalla de checkout

@when("ingresa su dirección de envío {address}")
def step_enter_address(context, address):
    context.checkout.shipping_address = address

@when("paga con tarjeta terminada en {last_digits}")
def step_pay_with_card(context, last_digits):
    gateway = PaymentGateway()
    context.result = context.checkout.place_order(gateway, card_last_digits=last_digits)

@then("la orden se crea con estado {status}")
def step_order_status(context, status):
    assert context.result is not None
    assert context.result.status == status

@then("se envía un email de confirmación")
def step_email_sent(context):
    assert context.result.notification_sent is True
```

### Ejecución

```bash
behave features/
behave features/checkout.feature --tags=smoke
behave --format allure --outdir reports/
```

## Cucumber (JavaScript)

```gherkin
# features/login.feature
Feature: Inicio de sesión
  Scenario: Login exitoso
    Given I am on the login page
    When I enter "user@test.com" as email
    And I enter "Pass123!" as password
    And I click the login button
    Then I should see the dashboard
```

```javascript
// features/step_definitions/login_steps.js
const { Given, When, Then } = require("@cucumber/cucumber");
const { chromium } = require("playwright");

Given("I am on the login page", async function () {
  this.page = await (await chromium.launch()).newPage();
  await this.page.goto("https://example.com/login");
});

When("I enter {string} as email", async function (email) {
  await this.page.fill('[data-testid="email"]', email);
});

When("I enter {string} as password", async function (password) {
  await this.page.fill('[data-testid="password"]', password);
});

When("I click the login button", async function () {
  await this.page.click('[data-testid="login-button"]');
});

Then("I should see the dashboard", async function () {
  await this.page.waitForSelector('[data-testid="dashboard"]');
  await this.page.close();
});
```

## Ejemplo de Data Tables

```gherkin
Scenario Outline: Cálculo de descuento por nivel
  Given un usuario con nivel "<tier>" y compras por "$<purchases>"
  When calcula el descuento
  Then el descuento es <discount>%

  Examples:
    | tier     | purchases | discount |
    | basic    | 0         | 0        |
    | gold     | 500       | 10       |
    | gold     | 1500      | 15       |
    | platinum | 5000      | 25       |
```

## Best Practices

1. **Lenguaje ubicuo**: Términos de negocio en Gherkin.
2. **Scenario Outline**: Probar combinaciones sin duplicar.
3. **Tags**: `@smoke`, `@regression`, `@wip`.
