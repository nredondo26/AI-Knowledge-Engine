# CQRS — Command Query Responsibility Segregation

## Conceptos Fundamentales

CQRS (Command Query Responsibility Segregation) es un patrón arquitectónico que separa las operaciones de **lectura (queries)** de las de **escritura (commands)** en modelos distintos. Mientras que en una arquitectura tradicional el mismo modelo sirve para leer y escribir, CQRS optimiza cada operación por separado.

### Principios Clave

- **Commands**: Cambian el estado. No retornan datos (solo confirmación). Usan verbos en imperativo: CreateUser, PlaceOrder, CancelInvoice.
- **Queries**: Retornan datos. No cambian el estado. Usan preguntas: GetUserById, ListOrdersByDate.
- **Modelos separados**: El modelo de escritura puede tener una estructura completamente diferente al de lectura.
- **Comunicación asíncrona (opcional)**: El modelo de lectura se actualiza mediante eventos después de que el modelo de escritura persiste los cambios.

## Separación de Modelos

```
+------------------+     +------------------+
|   Command Side   |     |    Query Side    |
|  (Write Model)   |     |  (Read Model)    |
+------------------+     +------------------+
| - CreateOrder    |     | - GetOrders      |
| - AddItem        |     | - GetOrderById   |
| - ProcessPayment |     | - ListByUser     |
| - CancelOrder    |     | - OrderSummary   |
|                  |     |                  |
| DB: PostgreSQL   |     | DB: Elasticsearch|
| (normalizado)    |     | (desnormalizado) |
+--------+---------+     +--------+---------+
         |                        |
         +------- Event Bus ------+
           (Command > Event > Query Update)
```

## Implementación en Python

### Commands

```python
from dataclasses import dataclass
from abc import ABC, abstractmethod

@dataclass
class Command:
    pass

@dataclass
class PlaceOrderCommand(Command):
    user_id: str
    items: list[dict]
    payment_token: str

@dataclass
class CancelOrderCommand(Command):
    order_id: str
    reason: str

class CommandHandler(ABC):
    @abstractmethod
    def handle(self, command: Command): ...

class PlaceOrderHandler(CommandHandler):
    def __init__(self, repository, event_bus):
        self.repository = repository
        self.event_bus = event_bus

    def handle(self, command: PlaceOrderCommand):
        order = Order.create(command.user_id, command.items)
        order.process_payment(command.payment_token)
        self.repository.save(order)
        self.event_bus.publish(OrderPlacedEvent(
            order_id=order.id,
            user_id=order.user_id,
            total=order.total,
            items=order.items
        ))
```

### Queries

```python
from dataclasses import dataclass

@dataclass
class GetOrderSummaryQuery:
    order_id: str

@dataclass
class ListUserOrdersQuery:
    user_id: str
    page: int = 1
    limit: int = 20

@dataclass
class OrderSummary:
    order_id: str
    user_id: str
    total: float
    status: str
    items_count: int
    created_at: str

class GetOrderSummaryHandler:
    def __init__(self, read_db):
        self.read_db = read_db

    def handle(self, query: GetOrderSummaryQuery) -> OrderSummary:
        return self.read_db.find_summary(query.order_id)
```

### Proyección (Sincronización Read Model)

```python
class OrderProjection:
    def __init__(self, read_db):
        self.read_db = read_db

    def on_order_placed(self, event):
        self.read_db.save_summary(OrderSummary(
            order_id=event.order_id,
            user_id=event.user_id,
            total=float(event.total),
            status="placed",
            items_count=len(event.items),
            created_at=datetime.utcnow().isoformat()
        ))

    def on_order_cancelled(self, event):
        self.read_db.update_status(event.order_id, "cancelled")
```

### API Layer

```python
from fastapi import FastAPI, APIRouter

router = APIRouter()
command_bus = CommandBus()
command_bus.register(PlaceOrderCommand, PlaceOrderHandler(...))
query_bus = QueryBus()
query_bus.register(GetOrderSummaryQuery, GetOrderSummaryHandler(...))

@router.post("/orders")
def place_order(request: PlaceOrderRequest):
    command = PlaceOrderCommand(
        user_id=request.user_id,
        items=request.items,
        payment_token=request.payment_token
    )
    command_bus.dispatch(command)
    return {"status": "accepted"}

@router.get("/orders/{order_id}")
def get_order_summary(order_id: str):
    query = GetOrderSummaryQuery(order_id=order_id)
    result = query_bus.dispatch(query)
    return result
```

## Implementación en C# (Axon Framework)

```csharp
// Command
public record PlaceOrderCommand(string UserId, List<OrderItemDto> Items, string PaymentToken);

[CommandHandler]
public class PlaceOrderCommandHandler : ICommandHandler<PlaceOrderCommand>
{
    private readonly IOrderRepository _repository;
    private readonly IEventBus _eventBus;

    public async Task Handle(PlaceOrderCommand command, CancellationToken ct)
    {
        var order = Order.Create(command.UserId, command.Items);
        await _repository.SaveAsync(order, ct);
        await _eventBus.PublishAsync(new OrderPlacedEvent(order.Id, order.UserId, order.Total), ct);
    }
}

// Query
public record GetOrderSummaryQuery(string OrderId);

[QueryHandler]
public class GetOrderSummaryQueryHandler : IQueryHandler<GetOrderSummaryQuery, OrderSummary>
{
    private readonly IOrderReadRepository _readRepo;

    public async Task<OrderSummary> Handle(GetOrderSummaryQuery query, CancellationToken ct)
    {
        return await _readRepo.FindSummaryAsync(query.OrderId, ct);
    }
}
```

## Cuándo Usar CQRS

| Úsalo si... | No lo uses si... |
|-------------|------------------|
| El modelo de lectura y escritura son muy diferentes | El CRUD es simple y simétrico |
| Necesitas optimizar lecturas y escrituras por separado | El equipo es pequeño o el dominio es simple |
| Tienes alta concurrencia en escritura | No hay beneficios claros en separar |
| Quieres escalar lecturas y escrituras independientemente | La complejidad adicional no se justifica |
| Usas Event Sourcing (CQRS es complemento natural) | Solo necesitas un CRUD estándar |

## Tecnologías Principales

| Herramienta | Lenguaje | Descripción |
|-------------|----------|-------------|
| Axon Framework | Java/Kotlin | Framework completo CQRS + Event Sourcing |
| EventFlow | C# | Biblioteca CQRS + ES para .NET |
| CQRS.NET | C# | Framework CQRS ligero |
| MassTransit | C# | Bus de mensajes con soporte CQRS |
| MediatR | C# | Implementación de mediator para CQRS |
| Dapr | Multi-lenguaje | Runtime distribuido con building blocks CQRS |

## Relaciones

- [EventSourcing](../EventSourcing/) — CQRS y Event Sourcing son complementos naturales
- [DDD](../DDD/) — Los aggregates definen los límites de los commands
- [Hexagonal](../Hexagonal/) — CQRS se implementa dentro de puertos/adaptadores
- [SOA](../SOA/) — Cada servicio puede tener su propio CQRS interno

## Recursos Recomendados

- Martin Fowler — CQRS (martinfowler.com/bliki/CQRS.html)
- Greg Young — CQRS Documents (cqrs.files.wordpress.com)
- Udi Dahan — Clarified CQRS (udidahan.com)
- AxonIQ — Guía de CQRS en Java y Spring
- "CQRS Journey" — Microsoft patterns & practices
- Dapr CQRS Building Block — docs.dapr.io
