# Event Sourcing — Almacenamiento Basado en Eventos

## Conceptos Fundamentales

Event Sourcing es un patrón arquitectónico donde el estado actual de una entidad se deriva de una secuencia inmutable de eventos que han ocurrido en el pasado. En lugar de almacenar solo el estado actual, se almacena cada cambio como un evento. El estado actual es simplemente la proyección de todos los eventos pasados.

### Principios Clave

- **Eventos inmutables**: Una vez almacenados, los eventos nunca se modifican ni eliminan.
- **Estado derivado**: El estado actual se calcula reproduciendo (replaying) los eventos.
- **Auditoría completa**: Cada cambio tiene un registro inmutable con quién, cuándo y por qué.
- **Separación de lecturas**: Se pueden crear diferentes proyecciones (read models) a partir de los mismos eventos.

### Evento vs Estado Tradicional

```
Tradicional (CRUD):
  Usuario { id: 1, nombre: "Ana", email: "ana@correo.com" }
  - Actualización in-place: nombre pasa a ser "Ana María"
  - Se pierde el historial de cambios

Event Sourcing:
  Eventos para Usuario #1:
  [2025-01-01] UserRegistered: id=1, nombre="Ana", email="ana@correo.com"
  [2025-03-15] UserRenamed:    id=1, nuevo_nombre="Ana María"
  [2025-04-10] EmailChanged:   id=1, nuevo_email="anamaria@correo.com"
  
  Estado actual = reproyectar todos los eventos:
  => Usuario { id: 1, nombre: "Ana María", email: "anamaria@correo.com" }
```

## Estructura de un Event Store

```sql
-- Tabla de eventos (event store)
CREATE TABLE events (
    id              BIGSERIAL PRIMARY KEY,
    aggregate_type  VARCHAR(100) NOT NULL,   -- 'order', 'user', 'payment'
    aggregate_id    VARCHAR(50) NOT NULL,     -- ID de la entidad
    event_type      VARCHAR(100) NOT NULL,    -- 'OrderPlaced', 'OrderShipped'
    event_data      JSONB NOT NULL,           -- Payload del evento
    metadata        JSONB,                    -- Who, when, correlation_id
    version         INTEGER NOT NULL,         -- Número de versión del aggregate
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(aggregate_type, aggregate_id, version)
);

CREATE INDEX idx_events_aggregate ON events(aggregate_type, aggregate_id);
CREATE INDEX idx_events_type ON events(event_type);
```

## Implementación en Python

### Definición de Eventos

```python
from dataclasses import dataclass, field
from datetime import datetime
from abc import ABC, abstractmethod

@dataclass
class Event(ABC):
    aggregate_id: str
    timestamp: datetime = field(default_factory=datetime.utcnow)

@dataclass
class OrderPlaced(Event):
    user_id: str
    items: list
    total: float

@dataclass
class OrderItemAdded(Event):
    product_id: str
    quantity: int
    price: float

@dataclass
class OrderPaymentProcessed(Event):
    payment_id: str
    amount: float

@dataclass
class OrderShipped(Event):
    tracking_number: str
    carrier: str

@dataclass
class OrderCancelled(Event):
    reason: str
```

### Aggregate Root

```python
class Order:
    def __init__(self, aggregate_id: str):
        self.id = aggregate_id
        self.items = []
        self.total = 0.0
        self.status = "pending"
        self.version = 0
        self.changes = []

    def place(self, user_id: str, items: list):
        self.apply_change(OrderPlaced(
            aggregate_id=self.id,
            user_id=user_id,
            items=items,
            total=sum(item.price * item.qty for item in items)
        ))

    def add_item(self, product_id: str, quantity: int, price: float):
        self.apply_change(OrderItemAdded(
            aggregate_id=self.id,
            product_id=product_id,
            quantity=quantity,
            price=price
        ))

    def ship(self, tracking: str, carrier: str):
        if self.status != "paid":
            raise ValueError("Solo se pueden enviar pedidos pagados")
        self.apply_change(OrderShipped(
            aggregate_id=self.id,
            tracking_number=tracking,
            carrier=carrier
        ))

    def apply_change(self, event: Event):
        self.mutate(event)
        self.changes.append(event)
        self.version += 1

    def mutate(self, event: Event):
        if isinstance(event, OrderPlaced):
            self.status = "placed"
            self.items = event.items
            self.total = event.total
        elif isinstance(event, OrderPaymentProcessed):
            self.status = "paid"
        elif isinstance(event, OrderShipped):
            self.status = "shipped"
        elif isinstance(event, OrderCancelled):
            self.status = "cancelled"

    @staticmethod
    def replay(events: list[Event]) -> "Order":
        order = Order(events[0].aggregate_id)
        for event in events:
            order.mutate(event)
        return order
```

### Event Store Repository

```python
class PostgresEventStore:
    def __init__(self, conn):
        self.conn = conn

    def save_events(self, aggregate_type: str, aggregate_id: str,
                    events: list[Event], expected_version: int):
        async with self.conn.transaction():
            for i, event in enumerate(events):
                version = expected_version + i + 1
                await self.conn.execute("""
                    INSERT INTO events
                        (aggregate_type, aggregate_id, event_type,
                         event_data, metadata, version)
                    VALUES ($1, $2, $3, $4, $5, $6)
                """, aggregate_type, aggregate_id,
                    type(event).__name__,
                    dataclasses.asdict(event),
                    {"recorded_by": "system"},
                    version)

    async def load_events(self, aggregate_type: str,
                          aggregate_id: str) -> list[Event]:
        rows = await self.conn.fetch("""
            SELECT event_type, event_data
            FROM events
            WHERE aggregate_type = $1 AND aggregate_id = $2
            ORDER BY version ASC
        """, aggregate_type, aggregate_id)
        return [deserialize_event(row["event_type"], row["event_data"])
                for row in rows]
```

### Proyecciones (Read Models)

```python
class OrderSummaryProjection:
    """Mantiene una tabla desnormalizada con resúmenes de pedidos."""

    def __init__(self, db):
        self.db = db

    async def handle_event(self, event: Event):
        if isinstance(event, OrderPlaced):
            await self.db.execute("""
                INSERT INTO order_summaries
                    (order_id, user_id, status, total, item_count, created_at)
                VALUES ($1, $2, 'placed', $3, $4, $5)
            """, event.aggregate_id, event.user_id,
                event.total, len(event.items), event.timestamp)

        elif isinstance(event, OrderShipped):
            await self.db.execute("""
                UPDATE order_summaries
                SET status = 'shipped',
                    tracking = $2,
                    carrier = $3
                WHERE order_id = $1
            """, event.aggregate_id, event.tracking_number, event.carrier)

        elif isinstance(event, OrderCancelled):
            await self.db.execute("""
                UPDATE order_summaries
                SET status = 'cancelled',
                    cancel_reason = $2
                WHERE order_id = $1
            """, event.aggregate_id, event.reason)
```

## Tecnologías Principales

| Herramienta | Lenguaje | Descripción |
|-------------|----------|-------------|
| EventStoreDB | Multi | Base de datos especializada para Event Sourcing |
| Axon Server | Java | Event Store + bus para Axon Framework |
| Kafka | Multi | Event store distribuido con retención configurable |
| PostgreSQL | SQL | Event store con tablas nativas y JSONB |
| Marten | C# | Document DB sobre PostgreSQL, con soporte ES |
| Eventuate | Java | Framework CQRS/ES para microservicios |

## Relaciones

- [CQRS](../CQRS/) — CQRS y Event Sourcing son complementos ideales
- [DDD](../DDD/) — Aggregates definen los límites de consistencia de eventos
- [Hexagonal](../Hexagonal/) — El event store es un adaptador de salida
- [Monolith](../Monolith/) — Event Sourcing funciona bien incluso en monolitos

## Recursos Recomendados

- Martin Fowler — Event Sourcing (martinfowler.com)
- Greg Young — "Why Event Sourcing?" (YouTube)
- EventStoreDB Documentation — eventstore.com/docs
- "Implementing Event Sourcing" — Vaughn Vernon (DDD)
- "Event Sourcing Made Simple" — Kacper Gunia (Domain-Driven Design Europe)
- Dapr Event Sourcing Building Block — docs.dapr.io
