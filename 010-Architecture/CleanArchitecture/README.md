# Clean Architecture — Arquitectura Limpia

## Conceptos Fundamentales

Clean Architecture, propuesta por Robert C. Martin (Uncle Bob), establece una arquitectura que separa el código en **capas concéntricas** con dependencias dirigidas hacia adentro. Las reglas de negocio están en el centro, aisladas de frameworks, bases de datos, UI y cualquier detalle externo.

### Principio de Dependencias

Las dependencias deben apuntar hacia adentro. Las capas internas **no saben nada** sobre las capas externas. Las capas externas pueden depender de las internas.

```
           ┌─────────────────────────────────────┐
           │         Frameworks & Drivers        │
           │  (Web, DB, UI, Devices, External)   │
           │    ┌───────────────────────────┐    │
           │    │   Interface Adapters      │    │
           │    │  (Controllers, Gateways,  │    │
           │    │   Presenters)             │    │
           │    │   ┌─────────────────┐     │    │
           │    │   │   Use Cases     │     │    │
           │    │   │ (Application    │     │    │
           │    │   │  Business Rules)│     │    │
           │    │   │  ┌─────────┐    │     │    │
           │    │   │  │ Entities│    │     │    │
           │    │   │  │ (Domain │    │     │    │
           │    │   │  │  Rules) │    │     │    │
           │    │   │  └─────────┘    │     │    │
           │    │   └─────────────────┘     │    │
           │    └───────────────────────────┘    │
           └─────────────────────────────────────┘
```

### Las 4 Capas

| Capa | Contenido | Depende de |
|------|-----------|------------|
| **Entities** | Objetos de negocio, reglas críticas. Sin dependencias externas. | Nada |
| **Use Cases** | Casos de uso de la aplicación. Orquestan flujos de negocio. | Entities |
| **Interface Adapters** | Controladores, presenters, gateways. Convierten datos entre capas. | Use Cases |
| **Frameworks & Drivers** | Web frameworks, DB, UI, APIs externas. | Interface Adapters |

## Implementación en Python

### Capa 1: Entities

```python
# domain/entities/user.py
from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from typing import Optional

class UserRole(Enum):
    ADMIN = "admin"
    USER = "user"
    MODERATOR = "moderator"

@dataclass
class User:
    id: Optional[str]
    email: str
    name: str
    password_hash: str
    role: UserRole
    is_active: bool
    created_at: datetime

    def can_access_resource(self, resource_owner_id: str) -> bool:
        return self.id == resource_owner_id or self.role in (UserRole.ADMIN, UserRole.MODERATOR)

    def deactivate(self) -> None:
        if self.role == UserRole.ADMIN:
            raise DomainError("Cannot deactivate admin users")
        self.is_active = False


# domain/entities/order.py
@dataclass
class OrderItem:
    product_id: str
    product_name: str
    quantity: int
    unit_price: Decimal

    @property
    def total(self) -> Decimal:
        return self.unit_price * self.quantity

class OrderStatus(Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"

@dataclass
class Order:
    id: Optional[str]
    user_id: str
    items: list[OrderItem]
    status: OrderStatus
    total: Decimal
    created_at: datetime

    def confirm(self) -> None:
        if self.status != OrderStatus.PENDING:
            raise DomainError("Only pending orders can be confirmed")
        self.status = OrderStatus.CONFIRMED

    def cancel(self) -> None:
        if self.status in (OrderStatus.SHIPPED, OrderStatus.DELIVERED):
            raise DomainError("Cannot cancel shipped or delivered orders")
        self.status = OrderStatus.CANCELLED
```

### Capa 2: Use Cases

```python
# application/use_cases/create_order.py
from dataclasses import dataclass
from domain.entities.order import Order, OrderItem, OrderStatus
from domain.entities.user import User
from domain.interfaces.repositories import OrderRepository, UserRepository
from domain.interfaces.services import PaymentService, InventoryService

@dataclass
class CreateOrderInput:
    user_id: str
    items: list[dict]

@dataclass
class CreateOrderOutput:
    order_id: str
    total: Decimal
    status: str

class CreateOrderUseCase:
    """Caso de uso: Crear un pedido."""

    def __init__(
        self,
        user_repo: UserRepository,
        order_repo: OrderRepository,
        payment_service: PaymentService,
        inventory_service: InventoryService,
    ):
        self.user_repo = user_repo
        self.order_repo = order_repo
        self.payment_service = payment_service
        self.inventory_service = inventory_service

    def execute(self, input_data: CreateOrderInput) -> CreateOrderOutput:
        # 1. Validar usuario
        user = self.user_repo.find_by_id(input_data.user_id)
        if not user:
            raise ValueError("User not found")
        if not user.is_active:
            raise ValueError("Inactive user cannot create orders")

        # 2. Crear entidades de dominio
        order_items = [
            OrderItem(
                product_id=item["product_id"],
                product_name=item["product_name"],
                quantity=item["quantity"],
                unit_price=Decimal(str(item["unit_price"])),
            )
            for item in input_data.items
        ]

        order = Order(
            id=None,
            user_id=input_data.user_id,
            items=order_items,
            status=OrderStatus.PENDING,
            total=sum(item.total for item in order_items),
            created_at=datetime.utcnow(),
        )

        # 3. Validar reglas de negocio
        if order.total <= 0:
            raise ValueError("Order total must be positive")

        # 4. Llamar a servicios externos (vía interfaces)
        self.inventory_service.reserve_items(order_items)
        payment_result = self.payment_service.process_payment(user.id, order.total)

        if payment_result.status == "confirmed":
            order.confirm()
        else:
            self.inventory_service.release_items(order_items)
            raise ValueError(f"Payment failed: {payment_result.error}")

        # 5. Persistir
        saved_order = self.order_repo.save(order)

        return CreateOrderOutput(
            order_id=saved_order.id,
            total=saved_order.total,
            status=saved_order.status.value,
        )
```

### Capa 3: Interface Adapters

```python
# adapters/controllers/order_controller.py
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from application.use_cases.create_order import CreateOrderUseCase, CreateOrderInput

router = APIRouter()

class CreateOrderRequest(BaseModel):
    user_id: str
    items: list[dict]

class CreateOrderResponse(BaseModel):
    order_id: str
    total: float
    status: str

def get_create_order_usecase() -> CreateOrderUseCase:
    # En producción, usar DI container (FastAPI Depends)
    return container.resolve(CreateOrderUseCase)

@router.post("/orders", response_model=CreateOrderResponse)
async def create_order(
    request: CreateOrderRequest,
    usecase: CreateOrderUseCase = Depends(get_create_order_usecase),
):
    input_data = CreateOrderInput(
        user_id=request.user_id,
        items=request.items,
    )
    try:
        result = usecase.execute(input_data)
        return CreateOrderResponse(
            order_id=result.order_id,
            total=float(result.total),
            status=result.status,
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


# adapters/gateways/user_repository_impl.py
from domain.entities.user import User
from domain.interfaces.repositories import UserRepository
from adapters.database.models import UserModel

class SQLUserRepository(UserRepository):
    """Implementación concreta del repositorio usando SQLAlchemy."""

    def __init__(self, session):
        self.session = session

    def find_by_id(self, user_id: str) -> User | None:
        model = self.session.query(UserModel).filter(UserModel.id == user_id).first()
        if not model:
            return None
        return User(
            id=model.id,
            email=model.email,
            name=model.name,
            password_hash=model.password_hash,
            role=UserRole(model.role),
            is_active=model.is_active,
            created_at=model.created_at,
        )

    def save(self, user: User) -> User:
        model = UserModel(
            id=user.id,
            email=user.email,
            name=user.name,
            password_hash=user.password_hash,
            role=user.role.value,
            is_active=user.is_active,
            created_at=user.created_at,
        )
        self.session.add(model)
        self.session.commit()
        return user
```

### Capa 4: Frameworks & Drivers

```python
# main.py — Punto de entrada (configuración de frameworks)
from fastapi import FastAPI
from adapters.controllers.order_controller import router as order_router

app = FastAPI(title="Clean Architecture App")
app.include_router(order_router, prefix="/api")

# Container de DI (usando dependency_injector)
from dependency_injector import containers, providers
from adapters.database import Database

class Container(containers.DeclarativeContainer):
    config = providers.Configuration()
    db = providers.Singleton(Database, url=config.db.url)
    session = providers.Resource(db.provided.session)
    user_repo = providers.Factory(SQLUserRepository, session=session)
    order_repo = providers.Factory(SQLOrderRepository, session=session)
    payment_service = providers.Factory(StripePaymentService, api_key=config.stripe.key)
    inventory_service = providers.Factory(InventoryService)
    create_order_usecase = providers.Factory(
        CreateOrderUseCase,
        user_repo=user_repo,
        order_repo=order_repo,
        payment_service=payment_service,
        inventory_service=inventory_service,
    )

container = Container()
```

## Interfaces (Abstract Base Classes)

```python
# domain/interfaces/repositories.py
from abc import ABC, abstractmethod
from domain.entities.user import User
from domain.entities.order import Order

class UserRepository(ABC):
    @abstractmethod
    def find_by_id(self, user_id: str) -> User | None: ...
    @abstractmethod
    def find_by_email(self, email: str) -> User | None: ...
    @abstractmethod
    def save(self, user: User) -> User: ...

class OrderRepository(ABC):
    @abstractmethod
    def find_by_id(self, order_id: str) -> Order | None: ...
    @abstractmethod
    def find_by_user_id(self, user_id: str) -> list[Order]: ...
    @abstractmethod
    def save(self, order: Order) -> Order: ...

# domain/interfaces/services.py
class PaymentService(ABC):
    @abstractmethod
    def process_payment(self, user_id: str, amount: Decimal) -> PaymentResult: ...
    @abstractmethod
    def refund(self, transaction_id: str) -> RefundResult: ...

class InventoryService(ABC):
    @abstractmethod
    def reserve_items(self, items: list[OrderItem]) -> bool: ...
    @abstractmethod
    def release_items(self, items: list[OrderItem]) -> None: ...
```

## Testeabilidad

```python
# tests/use_cases/test_create_order.py
from unittest.mock import Mock
from application.use_cases.create_order import CreateOrderUseCase, CreateOrderInput

def test_create_order_success():
    # Arrange: mocks de interfaces
    user_repo = Mock()
    order_repo = Mock()
    payment_service = Mock()
    inventory_service = Mock()

    user_repo.find_by_id.return_value = User(
        id="user_1", email="a@b.com", name="Alice",
        password_hash="hash", role=UserRole.USER,
        is_active=True, created_at=datetime.now(),
    )
    payment_service.process_payment.return_value = PaymentResult("confirmed", None)
    order_repo.save.return_value = Order(
        id="order_1", user_id="user_1", items=[],
        status=OrderStatus.CONFIRMED, total=Decimal("100"),
        created_at=datetime.now(),
    )

    usecase = CreateOrderUseCase(user_repo, order_repo, payment_service, inventory_service)
    input_data = CreateOrderInput(
        user_id="user_1",
        items=[{"product_id": "p1", "product_name": "T-Shirt", "quantity": 2, "unit_price": "50.00"}],
    )

    # Act
    result = usecase.execute(input_data)

    # Assert
    assert result.order_id == "order_1"
    assert result.status == "confirmed"
    user_repo.find_by_id.assert_called_once_with("user_1")
    payment_service.process_payment.assert_called_once()
    order_repo.save.assert_called_once()
```

## Best Practices

1. **Dependency Inversion**: Las capas externas dependen de interfaces definidas en las capas internas. Nunca imports de capas externas hacia adentro.
2. **Casos de uso atómicos**: Cada use case encapsula una sola operación de negocio. No mezclar lógica de múltiples casos.
3. **DTOs de entrada/salida**: Los use cases reciben y devuelven DTOs simples (dataclasses/Pydantic). No exponen entidades directamente.
4. **Inyección de dependencias**: Usar DI container (FastAPI Depends, dependency_injector, Spring). No instanciar dependencias dentro de use cases.
5. **Pruebas sin infraestructura**: Los use cases se prueban con mocks/fakes de las interfaces. No necesitan base de datos ni servidor web.
6. **Entidades ricas**: Las entidades contienen lógica de negocio (validación, reglas). No son solo data classes anémicas.
7. **No exponer implementaciones**: La capa de frameworks (ej: FastAPI) no debe aparecer en use cases o entities. Usar adaptadores.
8. **Capa de aplicación delgada**: Los use cases solo orquestan. No deben contener lógica de infraestructura, SQL, HTTP, etc.
9. **Mantener boundaries**: Las interfaces entre capas deben ser explícitas. Un cambio en la base de datos solo afecta al repositorio concreto.
10. **Evolución pragmática**: No aplicar Clean Architecture dogmáticamente en proyectos pequeños empezar con estructura simple y evolucionar cuando la complejidad lo justifique.
