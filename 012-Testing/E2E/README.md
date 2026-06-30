# E2E Testing — Pruebas End-to-End

## Conceptos Fundamentales

Las pruebas End-to-End (E2E) verifican el flujo completo de una aplicación desde la perspectiva del usuario, atravesando todas las capas: frontend, backend, base de datos, servicios externos e infraestructura. Son el nivel más alto de la pirámide de tests y las que más confianza proporcionan, pero también las más lentas y frágiles.

### Cuándo usar E2E

- **Flujos críticos de negocio**: Checkout, login, registro, transferencia de fondos
- **Happy paths + errores**: Usuario exitoso + usuario con datos inválidos
- **Regresión visual**: Verificar que la UI no cambió inesperadamente
- **Integración real**: Probar que frontend + backend + DB funcionan juntos
- **Cross-browser**: Verificar comportamiento en Chrome, Firefox, Safari, Edge

### La Pirámide de Confianza

| Nivel | Velocidad | Confianza | Costo | Cantidad |
|-------|-----------|-----------|-------|----------|
| Unit | ms | Baja | $ | 70% |
| Integration | s | Media | $$ | 20% |
| E2E | min | Alta | $$$ | 10% |

## Frameworks E2E

| Framework | Lenguaje | Browser | Velocidad | Característica única |
|-----------|----------|---------|-----------|---------------------|
| Playwright | TS/JS/Python/.NET/Java | Chromium, Firefox, WebKit | ★★★★★ | Auto-wait, network intercept, mobile emulation |
| Cypress | JS/TS | Chromium, Firefox, Edge, WebKit | ★★★★☆ | Time travel, real-time reload, dashboard service |
| Selenium | Todos | Todos | ★★☆☆☆ | Máxima compatibilidad (legacy) |
| Puppeteer | TS/JS | Chromium | ★★★★☆ | Control total de Chrome DevTools Protocol |
| TestCafe | TS/JS | Chromium, Firefox, WebKit, Safari | ★★★☆☆ | Sin WebDriver, soporte multiplataforma |
| WebdriverIO | TS/JS | Todos | ★★★☆☆ | Framework-agnostic, gran ecosistema |

## Playwright — Ejemplo Completo

### Configuración

```typescript
// playwright.config.ts
import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./e2e",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 4 : undefined,
  reporter: [
    ["html"],
    ["json", { outputFile: "test-results/e2e-results.json" }],
    ["list"],
  ],
  use: {
    baseURL: process.env.BASE_URL || "http://localhost:3000",
    trace: "on-first-retry",
    screenshot: "only-on-failure",
    video: "retain-on-failure",
    actionTimeout: 10000,
    navigationTimeout: 30000,
  },
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
    {
      name: "firefox",
      use: { ...devices["Desktop Firefox"] },
    },
    {
      name: "webkit",
      use: { ...devices["Desktop Safari"] },
    },
    {
      name: "mobile-chrome",
      use: { ...devices["Pixel 5"] },
    },
    {
      name: "mobile-safari",
      use: { ...devices["iPhone 14"] },
    },
  ],
});
```

### Test de Checkout Completo

```typescript
// e2e/checkout.spec.ts
import { test, expect } from "@playwright/test";

test.describe("Checkout Flow", () => {
  test.beforeEach(async ({ page }) => {
    // Iniciar sesión antes de cada test
    await page.goto("/login");
    await page.fill("[data-testid=email]", "user@test.com");
    await page.fill("[data-testid=password]", "Test123!");
    await page.click("[data-testid=login-button]");
    await expect(page.locator("[data-testid=user-menu]")).toBeVisible();
  });

  test("complete purchase with credit card", async ({ page }) => {
    // Navegar a producto y añadir al carrito
    await page.goto("/products/tshirt-001");
    await page.selectOption("[data-testid=size-select]", "L");
    await page.click("[data-testid=add-to-cart]");
    await expect(page.locator("[data-testid=cart-count]")).toHaveText("1");

    // Ir al carrito
    await page.click("[data-testid=cart-link]");
    await expect(page.locator("[data-testid=cart-item]")).toHaveCount(1);
    await expect(page.locator("[data-testid=subtotal]")).toContainText("$29.99");

    // Iniciar checkout
    await page.click("[data-testid=checkout-button]");

    // Rellenar dirección de envío
    await page.fill("[name=address]", "123 Main St");
    await page.fill("[name=city]", "Springfield");
    await page.selectOption("[name=state]", "IL");
    await page.fill("[name=zip]", "62701");
    await page.click("[data-testid=continue-to-payment]");

    // Información de pago (tarjeta de prueba)
    await page.fill("[name=cardNumber]", "4242424242424242");
    await page.fill("[name=expiry]", "12/28");
    await page.fill("[name=cvc]", "123");
    await page.click("[data-testid=place-order]");

    // Confirmación de pedido
    await expect(page.locator("[data-testid=order-confirmation]")).toBeVisible();
    await expect(page.locator("[data-testid=order-number]")).not.toBeEmpty();

    // Verificar en el panel de usuario
    await page.goto("/account/orders");
    const orderNumber = await page.locator("[data-testid=order-number]").textContent();
    await expect(page.locator(`[data-testid=order-${orderNumber}]`)).toContainText("Confirmed");
  });

  test("show error on invalid coupon", async ({ page }) => {
    await page.goto("/cart");
    await page.fill("[data-testid=coupon-input]", "INVALID123");
    await page.click("[data-testid=apply-coupon]");
    await expect(page.locator("[data-testid=coupon-error]")).toContainText("Invalid coupon code");
  });
});
```

## Cypress — Ejemplo

```javascript
// cypress/e2e/auth.cy.js
describe("Authentication Flow", () => {
  beforeEach(() => {
    cy.visit("/");
  });

  it("should register a new user", () => {
    cy.get("[data-testid=signup-link]").click();
    cy.url().should("include", "/signup");

    cy.get("[name=name]").type("Alice Johnson");
    cy.get("[name=email]").type("alice@test.com");
    cy.get("[name=password]").type("SecurePass1!");
    cy.get("[name=confirmPassword]").type("SecurePass1!");
    cy.get("[data-testid=signup-submit]").click();

    cy.url().should("include", "/dashboard");
    cy.get("[data-testid=welcome-message]").should("contain", "Alice Johnson");

    // Verificar que se envió email de bienvenida
    cy.request("GET", "/api/users/me/notifications").then((response) => {
      expect(response.body).to.have.length.at.least(1);
      expect(response.body[0].type).to.equal("welcome_email");
    });
  });

  it("should show validation errors", () => {
    cy.get("[data-testid=signup-link]").click();
    cy.get("[data-testid=signup-submit]").click();

    cy.get("[data-testid=field-error]").should("have.length.at.least", 3);
    cy.contains("Email is required").should("be.visible");
    cy.contains("Password must be at least 8 characters").should("be.visible");
  });
});
```

## E2E con API + Base de Datos

No todo E2E es frontend. También se pueden probar APIs como flujo completo:

```python
# test_e2e_api.py
import pytest
from httpx import AsyncClient, ASGITransport
from src.main import app
from src.database import create_test_db, drop_test_db

@pytest.fixture(autouse=True)
async def setup_db():
    await create_test_db()
    yield
    await drop_test_db()

async def test_complete_order_lifecycle():
    transport = ASGITransport(app=app)

    async with AsyncClient(transport=transport, base_url="http://test") as client:
        # 1. Crear usuario
        user_resp = await client.post("/api/users", json={
            "name": "Alice",
            "email": "alice@test.com",
            "password": "Test123!",
        })
        assert user_resp.status_code == 201
        user_id = user_resp.json()["id"]

        # 2. Login
        login_resp = await client.post("/api/auth/login", json={
            "email": "alice@test.com",
            "password": "Test123!",
        })
        token = login_resp.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}

        # 3. Crear producto (admin)
        admin_headers = {"Authorization": "Bearer admin_token"}
        product_resp = await client.post("/api/products", json={
            "name": "T-Shirt",
            "price": 29.99,
            "stock": 100,
        }, headers=admin_headers)
        product_id = product_resp.json()["id"]

        # 4. Añadir al carrito
        cart_resp = await client.post(f"/api/cart/{user_id}/items", json={
            "product_id": product_id,
            "quantity": 2,
        }, headers=headers)
        assert cart_resp.status_code == 200

        # 5. Procesar pago
        payment_resp = await client.post("/api/checkout", json={
            "user_id": user_id,
            "payment_method": "card",
            "shipping_address": {
                "address": "123 Main St",
                "city": "Springfield",
                "state": "IL",
                "zip": "62701",
            },
        }, headers=headers)

        assert payment_resp.status_code == 201
        order = payment_resp.json()
        assert order["status"] == "confirmed"
        assert order["total"] == 59.98

        # 6. Verificar stock reducido
        product_check = await client.get(f"/api/products/{product_id}")
        assert product_check.json()["stock"] == 98
```

## Data Management en E2E

```typescript
// Con Playwright: API requests para setup/teardown
import { test, expect } from "@playwright/test";

test.describe("User Profile", () => {
  // Setup via API (más rápido que UI)
  test.beforeAll(async ({ request }) => {
    const user = await request.post("/api/test/users", {
      data: {
        email: "profile-test@test.com",
        password: "Test123!",
        profile: { name: "Alice", bio: "Hello!" },
      },
    });
    process.env.TEST_USER_TOKEN = (await user.json()).token;
  });

  test("edit profile bio", async ({ page, request }) => {
    // Usar API para login (evitar UI lenta)
    await page.goto("/");
    await page.evaluate((token) => {
      localStorage.setItem("auth_token", token);
    }, process.env.TEST_USER_TOKEN);
    await page.goto("/account/profile");

    await page.fill("[name=bio]", "Updated bio!");
    await page.click("[data-testid=save-profile]");
    await expect(page.locator("[data-testid=success-message]")).toBeVisible();

    // Verificar persistencia
    const profile = await request.get("/api/users/me/profile");
    expect((await profile.json()).bio).toBe("Updated bio!");
  });
});
```

## Best Practices

1. **No duplicar unit tests**: E2E prueba integración, no lógica pura. No verifiques que 2+2=4 en E2E. Deja eso para unit tests.
2. **Data-driven tests**: Usar fixtures de datos precargados via API/DB. No crear datos navegando por la UI (lento y frágil).
3. **Selectores data-testid**: Usar `[data-testid="nombre"]` en vez de selectores CSS frágiles (clases, IDs dinámicos, posiciones).
4. **Auto-wait**: Playwright espera automáticamente a que los elementos sean visibles/estables. No añadir `waitForTimeout` arbitrarios.
5. **Retry (flakiness)**: Los tests E2E fallan intermitentemente por naturaleza. Usar `retries: 2` en CI. Investigar fallos persistentes.
6. **Paralelismo**: Ejecutar tests en paralelo por archivo (fullyParallel). Usar sharding en CI para múltiples máquinas.
7. **Trazabilidad**: Capturar trace, screenshot y video en fallo. Los traces de Playwright son recargables y muestran cada acción.
8. **Entorno aislado**: Usar base de datos dedicada, seeds conocidos y reset entre suites. Nunca apuntar a producción.
9. **Paginación y lazy loading**: Probar scroll infinito, carga de más datos, filtros. Son las fuentes más comunes de bugs en frontend.
10. **CI optimizado**: Ejecutar E2E solo si unit + integration pasan. Usar `webServer` en Playwright para levantar la app automáticamente.
