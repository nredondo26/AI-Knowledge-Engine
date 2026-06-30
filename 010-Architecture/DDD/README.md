# Domain-Driven Design — Diseño Guiado por el Dominio

## Conceptos Fundamentales

Domain-Driven Design (DDD) es un enfoque de desarrollo de software creado por Eric Evans que pone el foco en el **dominio del negocio** como centro del diseño. El objetivo es crear modelos de software que reflejen fielmente la realidad del negocio, utilizando un **lenguaje ubicuo** compartido entre desarrolladores y expertos del dominio.

### Pilares del DDD

- **Lenguaje Ubicuo (Ubiquitous Language)**: Vocabulario compartido entre técnicos y negocio en todo el código, documentación y conversaciones.
- **Bounded Context**: Límite explícito donde un modelo de dominio es válido. Diferentes contextos pueden tener diferentes definiciones para el mismo concepto.
- **Entidades vs Value Objects**: Entidades (con identidad única, mutables) vs Value Objects (sin identidad, inmutables, intercambiables).
- **Aggregates**: Grupo de entidades y value objects tratados como una unidad de consistencia.
- **Domain Events**: Eventos que representan algo significativo que ocurrió en el dominio.
- **Repositories**: Abstracción para recuperar y persistir aggregates.
- **Services de dominio**: Operaciones que no encajan naturalmente en una entidad o value object.

## Estructura de un Módulo DDD

```
modulo-pedidos/
├── domain/
│   ├── model/
│   │   ├── entity/
│   │   │   ├── Order.java
│   │   │   ├── OrderItem.java
│   │   │   └── Customer.java
│   │   ├── valueobject/
│   │   │   ├── Money.java
│   │   │   ├── OrderId.java
│   │   │   └── ShippingAddress.java
│   │   └── event/
│   │       ├── OrderPlaced.java
│   │       └── OrderShipped.java
│   ├── service/
│   │   ├── PricingService.java
│   │   └── ShippingCostCalculator.java
│   ├── repository/
│   │   └── OrderRepository.java
│   └── spec/
│       └── OrderSpecification.java
├── application/
│   ├── service/
│   │   ├── PlaceOrderService.java
│   │   └── CancelOrderService.java
│   └── dto/
│       ├── PlaceOrderRequest.java
│       └── OrderResponse.java
├── infrastructure/
│   ├── persistence/
│   │   └── JpaOrderRepository.java
│   └── messaging/
│       └── RabbitMqEventPublisher.java
└── interfaces/
    ├── rest/
    │   └── OrderController.java
    └── graphql/
        └── OrderResolver.java
```

## Ejemplo en Java

### Value Object

```java
// domain/model/valueobject/Money.java
public record Money(BigDecimal amount, Currency currency) {

    public static final Money ZERO = new Money(BigDecimal.ZERO, Currency.EUR);

    public Money {
        if (amount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("El monto no puede ser negativo");
        }
    }

    public Money add(Money other) {
        if (!this.currency.equals(other.currency)) {
            throw new CurrencyMismatchException(this.currency, other.currency);
        }
        return new Money(this.amount.add(other.amount), this.currency);
    }

    public Money multiply(int factor) {
        return new Money(this.amount.multiply(BigDecimal.valueOf(factor)), this.currency);
    }
}
```

### Aggregate Root

```java
// domain/model/entity/Order.java
@Entity
@AggregateRoot
public class Order {

    @EmbeddedId
    private OrderId id;
    private CustomerId customerId;
    private OrderStatus status;

    @Embedded
    private Money total;

    @OneToMany(cascade = ALL, orphanRemoval = true)
    @JoinColumn(name = "order_id")
    private List<OrderItem> items = new ArrayList<>();

    private LocalDateTime placedAt;

    protected Order() {}

    public Order(CustomerId customerId) {
        this.id = new OrderId(UUID.randomUUID().toString());
        this.customerId = customerId;
        this.status = OrderStatus.PENDING;
        this.total = Money.ZERO;
    }

    public void addItem(ProductId productId, String productName,
                        Money unitPrice, int quantity) {
        var item = new OrderItem(productId, productName, unitPrice, quantity);
        items.add(item);
        total = total.add(item.subtotal());
    }

    public void place() {
        if (items.isEmpty()) {
            throw new IllegalStateException("No se puede colocar un pedido vacío");
        }
        this.status = OrderStatus.PLACED;
        this.placedAt = LocalDateTime.now();
        registerEvent(new OrderPlaced(this.id, this.customerId, this.total));
    }

    public void ship(TrackingNumber tracking) {
        if (this.status != OrderStatus.PAID) {
            throw new IllegalStateException("El pedido debe estar pagado para enviarse");
        }
        this.status = OrderStatus.SHIPPED;
        registerEvent(new OrderShipped(this.id, tracking));
    }
}
```

### Repository

```java
// domain/repository/OrderRepository.java
public interface OrderRepository {
    Optional<Order> findById(OrderId id);
    void save(Order order);
    void delete(OrderId id);
    List<Order> findByCustomerId(CustomerId customerId, Pageable pageable);
}

// infrastructure/persistence/JpaOrderRepository.java
@Repository
public class JpaOrderRepository implements OrderRepository {

    private final SpringDataOrderRepository jpaRepository;

    public JpaOrderRepository(SpringDataOrderRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public Optional<Order> findById(OrderId id) {
        return jpaRepository.findById(id);
    }

    @Override
    public void save(Order order) {
        jpaRepository.save(order);
    }
}
```

### Application Service

```java
// application/service/PlaceOrderService.java
@Service
@Transactional
public class PlaceOrderService {

    private final OrderRepository orderRepository;
    private final PricingService pricingService;
    private final DomainEventPublisher eventPublisher;

    public PlaceOrderService(OrderRepository orderRepository,
                             PricingService pricingService,
                             DomainEventPublisher eventPublisher) {
        this.orderRepository = orderRepository;
        this.pricingService = pricingService;
        this.eventPublisher = eventPublisher;
    }

    public OrderId execute(PlaceOrderRequest request) {
        var order = new Order(new CustomerId(request.customerId()));

        for (var item : request.items()) {
            var price = pricingService.calculatePrice(
                new ProductId(item.productId()), item.quantity());
            order.addItem(
                new ProductId(item.productId()),
                item.productName(),
                price,
                item.quantity()
            );
        }

        order.place();
        orderRepository.save(order);

        order.domainEvents().forEach(eventPublisher::publish);
        return order.id();
    }
}
```

## Estrategias de Modelado

### Event Storming

Event Storming es un taller colaborativo para descubrir el dominio:

```
+--------------------+       +--------------------+
| Domain Event       | ----> | Command            |
| "Order Placed"     |       | "Place Order"      |
+--------------------+       +--------------------+
                                     |
                                     v
                              +--------------------+
                              | Aggregate          |
                              | "Order"            |
                              +--------------------+
                                     |
                                     v
                              +--------------------+
                              | Read Model         |
                              | "OrderList"        |
                              +--------------------+
```

### Tácticas de Diseño

| Patrón | Propósito |
|--------|-----------|
| Entity | Objeto con identidad única que persiste en el tiempo |
| Value Object | Objeto inmutable sin identidad, definido por sus atributos |
| Aggregate | Grupo de objetos que deben ser consistentes juntos |
| Domain Event | Algo significativo que ocurrió en el dominio |
| Repository | Abstracción para persistencia de aggregates |
| Domain Service | Operación del dominio sin estado propio |
| Factory | Creación compleja de aggregates y entities |
| Specification | Regla de negocio encapsulada en un objeto |

## Tecnologías Principales

| Herramienta | Lenguaje | Propósito |
|-------------|----------|-----------|
| Axon Framework | Java/Kotlin | Framework DDD + CQRS + ES |
| JPA / Hibernate | Java | ORM para repositorios DDD |
| Arched | TypeScript | Framework DDD para Node.js |
| NestJS CQRS | TypeScript | Módulo CQRS/Event Sourcing |
| Aggregate.NET | C# | Biblioteca DDD para .NET |

## Relaciones

- [Hexagonal](../Hexagonal/) — DDD se implementa naturalmente en arquitectura hexagonal
- [CQRS](../CQRS/) — Los aggregates son la fuente de verdad para los commands
- [EventSourcing](../EventSourcing/) — Los domain events alimentan el event store
- [Solid](../Solid/) — Principios SOLID guían el diseño de los objetos del dominio
- [Monolith](../Monolith/) — DDD se aplica igual en monolitos con bounded contexts

## Recursos Recomendados

- "Domain-Driven Design: Tackling Complexity in the Heart of Software" — Eric Evans
- "Implementing Domain-Driven Design" — Vaughn Vernon
- "Domain-Driven Design Distilled" — Vaughn Vernon
- "Learning Domain-Driven Design" — Vlad Khononov
- Event Storming — Alberto Brandolini
- DDD Community — dddcommunity.org
- Awesome Domain-Driven Design — github.com/heynickc/awesome-ddd
