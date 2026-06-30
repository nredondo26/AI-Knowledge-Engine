# SOLID — Principios de Diseño Orientado a Objetos

## Conceptos Fundamentales

SOLID son cinco principios de diseño de software orientado a objetos introducidos por Robert C. Martin (Uncle Bob) que guían la creación de código mantenible, extensible y testeable. Son la base de muchos patrones de diseño y buenas prácticas arquitectónicas.

### Los Cinco Principios

| Sigla | Nombre | Descripción |
|-------|--------|-------------|
| **S** | Single Responsibility | Una clase debe tener una sola razón para cambiar |
| **O** | Open/Closed | Abierto para extensión, cerrado para modificación |
| **L** | Liskov Substitution | Subtipos deben ser sustituibles por sus tipos base |
| **I** | Interface Segregation | Interfaces específicas vs genéricas |
| **D** | Dependency Inversion | Depender de abstracciones, no de concreciones |

## S — Single Responsibility Principle (SRP)

**Una clase debe tener una sola razón para cambiar.** Cada clase debe tener una única responsabilidad bien definida.

```python
# ❌ VIOLA SRP: La clase hace demasiadas cosas
class OrderService:
    def create_order(self, data): ...
    def calculate_total(self, items): ...
    def save_to_database(self, order): ...
    def send_email_confirmation(self, order): ...
    def generate_invoice_pdf(self, order): ...
    def log_to_audit(self, order): ...

# ✅ CUMPLE SRP: Cada clase tiene una responsabilidad
class OrderCalculator:
    def calculate_total(self, items: list) -> Money: ...

class OrderRepository:
    def save(self, order: Order): ...

class EmailService:
    def send_order_confirmation(self, order: Order): ...

class InvoiceGenerator:
    def generate_pdf(self, order: Order) -> bytes: ...

class AuditLogger:
    def log(self, event: str, data: dict): ...

# Orquestación mediante un service de aplicación
class CreateOrderUseCase:
    def __init__(self, repo, calculator, email, invoice, logger):
        self.repo = repo
        self.calculator = calculator
        self.email = email
        self.invoice = invoice
        self.logger = logger

    def execute(self, data):
        order = self.repo.create(data)
        total = self.calculator.calculate_total(order.items)
        order.set_total(total)
        self.repo.save(order)
        self.email.send_order_confirmation(order)
        self.invoice.generate_pdf(order)
        self.logger.log("order_created", {"order_id": order.id})
```

## O — Open/Closed Principle (OCP)

**Las clases deben estar abiertas para extensión pero cerradas para modificación.** Se debe poder añadir nueva funcionalidad sin modificar código existente.

```python
from abc import ABC, abstractmethod

# ❌ VIOLA OCP: Hay que modificar la clase para añadir nuevos tipos
class PaymentProcessor:
    def process(self, payment_type: str, amount: float):
        if payment_type == "credit_card":
            self._process_credit_card(amount)
        elif payment_type == "paypal":
            self._process_paypal(amount)
        elif payment_type == "crypto":
            self._process_crypto(amount)  # Hay que añadir más elifs

# ✅ CUMPLE OCP: Usar polimorfismo para extender
class PaymentMethod(ABC):
    @abstractmethod
    def process(self, amount: float): ...

class CreditCardPayment(PaymentMethod):
    def process(self, amount: float):
        print(f"Procesando tarjeta: {amount}")

class PaypalPayment(PaymentMethod):
    def process(self, amount: float):
        print(f"Procesando PayPal: {amount}")

class CryptoPayment(PaymentMethod):
    def process(self, amount: float):
        print(f"Procesando crypto: {amount}")

# Nueva forma de pago: solo añadir una nueva clase
class TransferenciaBancaria(PaymentMethod):
    def process(self, amount: float):
        print(f"Procesando transferencia: {amount}")

class PaymentProcessor:
    def process(self, payment: PaymentMethod, amount: float):
        payment.process(amount)  # Sin modificaciones
```

## L — Liskov Substitution Principle (LSP)

**Los subtipos deben ser sustituibles por sus tipos base sin alterar la corrección del programa.**

```python
# ❌ VIOLA LSP: Rectángulo no es sustituible por Cuadrado
class Rectangle:
    def __init__(self, width, height):
        self._width = width
        self._height = height

    def set_width(self, w):
        self._width = w

    def set_height(self, h):
        self._height = h

    def area(self):
        return self._width * self._height

class Square(Rectangle):
    def set_width(self, w):
        self._width = w
        self._height = w  # Viola expectativas del cliente

    def set_height(self, h):
        self._width = h  # Viola expectativas del cliente
        self._height = h

def print_area(rect: Rectangle):
    rect.set_width(5)
    rect.set_height(10)
    # El cliente espera area = 50
    assert rect.area() == 50  # Square devuelve 100!

# ✅ CUMPLE LSP: Usar una abstracción común
class Shape(ABC):
    @abstractmethod
    def area(self): ...

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self): return self.width * self.height

class Square(Shape):
    def __init__(self, side):
        self.side = side

    def area(self): return self.side * self.side

# Ambos son sustituibles por Shape
shapes: list[Shape] = [Rectangle(3, 4), Square(5)]
total = sum(s.area() for s in shapes)  # 12 + 25 = 37
```

## I — Interface Segregation Principle (ISP)

**Las interfaces deben ser específicas para cada cliente.** Es mejor tener interfaces pequeñas y enfocadas que una grande y genérica.

```python
# ❌ VIOLA ISP: Interfaz demasiado grande
class Worker(ABC):
    @abstractmethod
    def work(self): ...
    @abstractmethod
    def eat(self): ...
    @abstractmethod
    def sleep(self): ...
    @abstractmethod
    def manage(self): ...

class Developer(Worker):
    def work(self): print("Codificando")
    def eat(self): print("Comiendo")     # Válido
    def sleep(self): print("Durmiendo")  # Válido
    def manage(self): raise NotImplementedError("Los devs no gestionan")

class Manager(Worker):
    def work(self): print("Gestionando")
    def eat(self): print("Comiendo")     # Válido
    def sleep(self): print("Durmiendo")  # Válido
    def manage(self): print("Revisando") # Válido

# ✅ CUMPLE ISP: Interfaces segregadas
class Workable(ABC):
    @abstractmethod
    def work(self): ...

class Eatable(ABC):
    @abstractmethod
    def eat(self): ...

class Sleepable(ABC):
    @abstractmethod
    def sleep(self): ...

class Manageable(ABC):
    @abstractmethod
    def manage(self): ...

class Developer(Workable, Eatable, Sleepable):
    def work(self): print("Codificando")
    def eat(self): print("Comiendo")
    def sleep(self): print("Durmiendo")

class Manager(Workable, Eatable, Sleepable, Manageable):
    def work(self): print("Gestionando")
    def eat(self): print("Comiendo")
    def sleep(self): print("Durmiendo")
    def manage(self): print("Revisando")
```

## D — Dependency Inversion Principle (DIP)

**Depender de abstracciones, no de implementaciones concretas.** Los módulos de alto nivel no deben depender de módulos de bajo nivel.

```python
# ❌ VIOLA DIP: Alto nivel depende de bajo nivel
class MySQLDatabase:
    def query(self, sql: str):
        return f"Ejecutando en MySQL: {sql}"

class UserService:
    def __init__(self):
        self.db = MySQLDatabase()  # Dependencia concreta

    def get_user(self, user_id: int):
        return self.db.query(f"SELECT * FROM users WHERE id = {user_id}")

# ✅ CUMPLE DIP: Inversión de dependencias
from abc import ABC, abstractmethod

class Database(ABC):
    @abstractmethod
    def query(self, sql: str): ...

class MySQLDatabase(Database):
    def query(self, sql: str):
        return f"Ejecutando en MySQL: {sql}"

class PostgreSQLDatabase(Database):
    def query(self, sql: str):
        return f"Ejecutando en PostgreSQL: {sql}"

class UserService:
    def __init__(self, db: Database):  # Dependencia abstracta
        self.db = db

    def get_user(self, user_id: int):
        return self.db.query(f"SELECT * FROM users WHERE id = {user_id}")

# Inyección de dependencias
mysql_service = UserService(MySQLDatabase())
postgres_service = UserService(PostgreSQLDatabase())
```

## Aplicación de SOLID en Conjunto

```python
from abc import ABC, abstractmethod

# S: Single Responsibility — cada clase tiene un propósito
# O: Open/Closed — extendemos con nuevas implementaciones
# L: Liskov — todas las implementaciones son intercambiables
# I: Interface Segregation — interfaces pequeñas
# D: Dependency Inversion — dependemos de interfaces

# Interfaces segregadas (ISP)
class Notifier(ABC):
    @abstractmethod
    def send(self, message: str, recipient: str): ...

class Logger(ABC):
    @abstractmethod
    def info(self, msg: str): ...

class OrderRepository(ABC):
    @abstractmethod
    def save(self, order): ...

# Implementaciones concretas (OCP: añadir nuevas sin modificar)
class EmailNotifier(Notifier):
    def send(self, message, recipient):
        print(f"Email a {recipient}: {message}")

class SMSNotifier(Notifier):
    def send(self, message, recipient):
        print(f"SMS a {recipient}: {message}")

class CloudWatchLogger(Logger):
    def info(self, msg):
        print(f"CloudWatch: {msg}")

class PostgresOrderRepo(OrderRepository):
    def save(self, order):
        print(f"Guardando {order.id} en PostgreSQL")

# Orquestación (DIP: depende de abstracciones)
class OrderService:
    def __init__(self, repo: OrderRepository,
                 notifier: Notifier,
                 logger: Logger):
        self.repo = repo
        self.notifier = notifier
        self.logger = logger

    def place_order(self, order_data):
        order = Order.create(order_data)
        self.repo.save(order)
        self.notifier.send(
            f"Pedido {order.id} creado",
            order.customer_email
        )
        self.logger.info(f"Order {order.id} placed")
        return order

# LSP: todas las implementaciones son intercambiables
service = OrderService(
    repo=PostgresOrderRepo(),
    notifier=SMSNotifier(),
    logger=CloudWatchLogger()
)
```

## Beneficios de SOLID

| Principio | Beneficio |
|-----------|-----------|
| SRP | Código más fácil de entender y mantener |
| OCP | Menos riesgo al añadir funcionalidad |
| LSP | Comportamiento predecible en jerarquías |
| ISP | Interfaces cohesivas, clientes no forzados |
| DIP | Bajo acoplamiento, alta testabilidad |

## Relaciones

- [Hexagonal](../Hexagonal/) — DIP es el fundamento de Ports & Adapters
- [DDD](../DDD/) — SRP guía el diseño de aggregates y services
- [CleanArchitecture](../CleanArchitecture/) — DIP es el principio central de Clean Architecture
- [EventSourcing](../EventSourcing/) — SRP separa eventos, proyecciones y commands
- [CQRS](../CQRS/) — ISP separa interfaces de lectura y escritura

## Recursos Recomendados

- "Clean Code" — Robert C. Martin (Capítulo sobre principios)
- "Clean Architecture" — Robert C. Martin (Parte II: Principios)
- "Agile Software Development, Principles, Patterns, and Practices" — Robert C. Martin
- "The Principles of OOD" — Robert C. Martin (butunclebob.com)
- "SOLID Principles" — Tutorial de Dan Vega (YouTube)
- Refactoring Guru — refactoring.guru (SOLID con ejemplos)
- DotNet MVC — SOLID en C# con ejemplos prácticos
