# Hexagonal Architecture — Arquitectura Hexagonal (Ports & Adapters)

## Conceptos Fundamentales

La Arquitectura Hexagonal, también conocida como **Ports & Adapters**, fue propuesta por Alistair Cockburn. Su objetivo es aislar la lógica de negocio del mundo exterior (bases de datos, APIs, interfaces de usuario, sistemas externos), haciendo que el núcleo de la aplicación sea independiente de los detalles técnicos.

### Principios Clave

- **Puertos (Ports)**: Interfaces que definen cómo el mundo exterior se comunica con el núcleo.
- **Adaptadores (Adapters)**: Implementaciones concretas de los puertos (controladores REST, repositorios SQL, clientes HTTP).
- **Inversión de dependencias**: El núcleo define los puertos; los adaptadores dependen de los puertos, no al revés.
- **Núcleo aislado**: La lógica de negocio no importa nada de infraestructura.

## Estructura de Paquetes

```
src/
├── domain/                      # Núcleo (Core)
│   ├── model/                   # Entidades del negocio
│   ├── port/                    # Puertos (interfaces)
│   │   ├── inbound/             # Puertos de entrada (casos de uso)
│   │   └── outbound/            # Puertos de salida (repositorios)
│   └── service/                 # Implementación de casos de uso
│
├── adapter/                     # Adaptadores
│   ├── inbound/                 # Adaptadores de entrada
│   │   ├── rest/                # Controladores HTTP
│   │   ├── graphql/             # Resolvers GraphQL
│   │   └── cli/                 # Interfaz de línea de comandos
│   └── outbound/                # Adaptadores de salida
│       ├── persistence/         # Base de datos (SQL, NoSQL)
│       └── messaging/           # Mensajería (Kafka, RabbitMQ)
│
└── config/                      # Configuración de la aplicación
```

## Ejemplo en Java (Spring Boot)

### Domain — Modelo y Puertos

```java
// domain/model/Order.java
public class Order {
    private OrderId id;
    private List<OrderItem> items;
    private Money total;
    private OrderStatus status;

    public void addItem(Product product, int quantity) {
        items.add(new OrderItem(product, quantity));
        recalculateTotal();
    }

    private void recalculateTotal() {
        total = items.stream()
            .map(OrderItem::subtotal)
            .reduce(Money.ZERO, Money::add);
    }
}

// domain/port/inbound/CreateOrderUseCase.java
public interface CreateOrderUseCase {
    Order createOrder(CreateOrderCommand command);
}

// domain/port/outbound/OrderRepository.java
public interface OrderRepository {
    Order save(Order order);
    Optional<Order> findById(OrderId id);
    List<Order> findByUserId(UserId userId);
}
```

### Domain — Servicio (Caso de Uso)

```java
// domain/service/OrderService.java
public class OrderService implements CreateOrderUseCase {
    
    private final OrderRepository orderRepository;
    private final PaymentGateway paymentGateway;
    private final InventoryService inventoryService;

    public OrderService(
            OrderRepository orderRepository,
            PaymentGateway paymentGateway,
            InventoryService inventoryService) {
        this.orderRepository = orderRepository;
        this.paymentGateway = paymentGateway;
        this.inventoryService = inventoryService;
    }

    @Override
    public Order createOrder(CreateOrderCommand command) {
        // Validar inventario
        for (var item : command.items()) {
            if (!inventoryService.checkAvailability(item.productId(), item.quantity())) {
                throw new InsufficientStockException(item.productId());
            }
        }

        var order = new Order(command.userId());
        command.items().forEach(i -> order.addItem(i.product(), i.quantity()));
        
        // Cobrar
        var paymentId = paymentGateway.charge(order.total(), command.paymentToken());
        order.markAsPaid(paymentId);

        return orderRepository.save(order);
    }
}
```

### Adapter — Controlador REST

```java
// adapter/inbound/rest/OrderController.java
@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final CreateOrderUseCase createOrderUseCase;

    public OrderController(CreateOrderUseCase createOrderUseCase) {
        this.createOrderUseCase = createOrderUseCase;
    }

    @PostMapping
    public ResponseEntity<OrderResponse> createOrder(
            @RequestBody @Valid CreateOrderRequest request) {
        
        var command = new CreateOrderCommand(
            request.userId(),
            request.items().stream()
                .map(i -> new OrderItem(i.productId(), i.quantity()))
                .toList(),
            request.paymentToken()
        );

        var order = createOrderUseCase.createOrder(command);
        return ResponseEntity.ok(OrderResponse.from(order));
    }
}
```

### Adapter — Repositorio JPA

```java
// adapter/outbound/persistence/JpaOrderRepository.java
@Repository
public class JpaOrderRepository implements OrderRepository {

    private final SpringDataOrderRepository jpaRepository;
    private final OrderMapper mapper;

    public JpaOrderRepository(
            SpringDataOrderRepository jpaRepository,
            OrderMapper mapper) {
        this.jpaRepository = jpaRepository;
        this.mapper = mapper;
    }

    @Override
    public Order save(Order order) {
        var entity = mapper.toEntity(order);
        var saved = jpaRepository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<Order> findById(OrderId id) {
        return jpaRepository.findById(id.value())
            .map(mapper::toDomain);
    }
}
```

## Ejemplo en Python (FastAPI)

```python
# domain/ports.py
from abc import ABC, abstractmethod

class OrderRepository(ABC):
    @abstractmethod
    def save(self, order: "Order") -> "Order": ...
    @abstractmethod
    def find_by_id(self, order_id: str) -> "Order | None": ...

class PaymentGateway(ABC):
    @abstractmethod
    def charge(self, amount: Decimal, token: str) -> str: ...

# domain/service.py
class OrderService:
    def __init__(
        self,
        order_repo: OrderRepository,
        payment_gw: PaymentGateway,
    ):
        self._order_repo = order_repo
        self._payment_gw = payment_gw

    def create_order(self, command: CreateOrderCommand) -> Order:
        order = Order(user_id=command.user_id)
        for item in command.items:
            order.add_item(item.product_id, item.quantity)
        
        payment_id = self._payment_gw.charge(order.total, command.payment_token)
        order.mark_as_paid(payment_id)
        
        return self._order_repo.save(order)

# adapter/inbound/api.py
from fastapi import APIRouter, Depends
from adapter.outbound.sql_repository import SqlOrderRepository

router = APIRouter()

def get_order_service() -> OrderService:
    return OrderService(
        order_repo=SqlOrderRepository(),
        payment_gw=StripePaymentGateway()
    )

@router.post("/orders")
def create_order(
    request: CreateOrderRequest,
    service: OrderService = Depends(get_order_service)
):
    command = CreateOrderCommand(
        user_id=request.user_id,
        items=request.items,
        payment_token=request.payment_token
    )
    order = service.create_order(command)
    return OrderResponse.from_domain(order)
```

## Beneficios

- **Testabilidad**: El núcleo se prueba sin infraestructura; los adaptadores se prueban por separado.
- **Flexibilidad tecnológica**: Cambiar de base de datos o framework no afecta el dominio.
- **Domain-driven**: La lógica de negocio vive en el centro, sin distracciones técnicas.
- **Evolución gradual**: Se pueden cambiar adaptadores uno por uno sin reescribir todo.

## Relaciones

- [CleanArchitecture](../CleanArchitecture/) — Hexagonal es conceptualmente similar a Clean Architecture
- [DDD](../DDD/) — Hexagonal es el vehículo técnico ideal para DDD
- [Solid](../Solid/) — Principio de inversión de dependencias (DIP) es fundamental aquí
- [CQRS](../CQRS/) — Se puede implementar CQRS dentro de una arquitectura hexagonal
- [Monolith](../Monolith/) — Hexagonal mantiene ordenado incluso un monolito

## Recursos Recomendados

- "Hexagonal Architecture" — Alistair Cockburn (alistair.cockburn.us)
- "Ports & Adapters Pattern" — Alistair Cockburn
- "Get Your Hands Dirty on Clean Architecture" — Tom Hombergs
- "Architecture Hexagonale" — Vídeo explicativo (YouTube)
- DDD, Hexagonal, Onion Architecture — Comparativa en awesome-architecture
