# Mocking — Simulación de Dependencias

## Conceptos Fundamentales

Mocking es una técnica de testing que reemplaza dependencias reales (bases de datos, APIs, sistemas de archivos) con objetos simulados que imitan su comportamiento. Permite aislar la unidad bajo test y controlar entradas/salidas de forma predecible.

### Tipos de Test Doubles

| Tipo | Descripción | Uso |
|------|-------------|-----|
| **Dummy** | Objeto que se pasa pero no se usa | Rellenar parámetros |
| **Fake** | Implementación funcional simplificada | Base de datos en memoria |
| **Stub** | Proporciona respuestas fijas | Configurar retorno de llamadas |
| **Spy** | Registra interacciones | Verificar que se llamó un método |
| **Mock** | Stub + Spy con expectativas | Validar comportamiento completo |

## unittest.mock (Python)

```python
from unittest.mock import Mock, patch, MagicMock, PropertyMock, AsyncMock
import pytest

# Mock básico
def test_payment_service():
    gateway = Mock()
    gateway.charge.return_value = {"id": "ch_123", "status": "succeeded"}
    service = PaymentService(gateway)
    result = service.process(100.0)
    assert result["status"] == "succeeded"
    gateway.charge.assert_called_once_with(amount=100.0, currency="usd")

# Side effects (diferentes respuestas o excepciones)
def test_payment_failure():
    gateway = Mock()
    gateway.charge.side_effect = [{"status": "failed"}, {"status": "succeeded"}]
    service = PaymentService(gateway)
    assert service.process(50.0)["status"] == "failed"
    assert service.process(50.0)["status"] == "succeeded"

# AsyncMock
@pytest.mark.asyncio
async def test_async_service():
    client = AsyncMock()
    client.fetch.return_value = {"data": "test"}
    result = await client.fetch("/api/data")
    assert result["data"] == "test"
```

### Patch — Reemplazar Importaciones

```python
# src/services.py
import requests

def get_user(user_id):
    resp = requests.get(f"https://api.example.com/users/{user_id}")
    return resp.json()

# test_services.py
@patch("src.services.requests.get")
def test_get_user(mock_get):
    mock_get.return_value.json.return_value = {"id": 1, "name": "Alice"}
    mock_get.return_value.status_code = 200

    result = get_user(1)
    assert result["name"] == "Alice"
    mock_get.assert_called_once_with("https://api.example.com/users/1")
```

### Property Mock

```python
def test_user_properties():
    user = Mock()
    type(user).is_admin = PropertyMock(return_value=True)
    type(user).name = PropertyMock(return_value="Alice")
    assert user.is_admin is True
    assert user.name == "Alice"
```

## Vitest (JavaScript/TypeScript)

```typescript
// service.ts
export class EmailService {
  async send(to: string, subject: string): Promise<{ status: string }> {
    return { status: "sent" };
  }
}

// service.test.ts
import { vi, describe, it, expect } from "vitest";
import { EmailService } from "./service";

describe("EmailService", () => {
  it("should send email successfully", async () => {
    const mockSend = vi.fn().mockResolvedValue({ status: "sent" });
    const service = new EmailService();
    service.send = mockSend;

    const result = await service.send("user@test.com", "Hello");
    expect(result.status).toBe("sent");
    expect(mockSend).toHaveBeenCalledWith("user@test.com", "Hello");
  });
});
```

### Mock de Módulos

```typescript
// api.ts
import axios from "axios";
export async function fetchUser(id: number) {
  const { data } = await axios.get(`/users/${id}`);
  return data;
}

// api.test.ts
import { vi } from "vitest";
vi.mock("axios");

import axios from "axios";
import { fetchUser } from "./api";

test("fetchUser returns user data", async () => {
  vi.mocked(axios.get).mockResolvedValue({
    data: { id: 1, name: "Alice" },
  });
  const user = await fetchUser(1);
  expect(axios.get).toHaveBeenCalledWith("/users/1");
  expect(user.name).toBe("Alice");
});
```

## Best Practices

1. **Solo mockear lo externo**: I/O (red, DB, filesystem), no el sistema bajo test.
2. **Preferir fakes sobre mocks**: Un fake es más mantenible que mocks con muchas expectativas.
3. **No sobremockear**: Muchos mocks = señal de arquitectura frágil.
4. **Mockear en el límite**: En la frontera del sistema (adaptadores), no en el dominio.
