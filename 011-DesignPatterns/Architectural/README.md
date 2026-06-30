# Patrones Arquitectónicos

## Descripción del dominio

Los patrones arquitectónicos definen la estructura fundamental de un sistema de software: cómo se organizan los componentes, cómo se relacionan y cómo fluyen los datos entre ellos. A diferencia de los patrones de diseño (GoF) que operan a nivel de clases, los patrones arquitectónicos operan a nivel de sistema o subsistema. Cubren desde arquitecturas monolíticas hasta microservicios, pasando por capas (layers), hexagonal (ports & adapters), CQRS, event sourcing, pipeline, microkernel, space-based, y arquitecturas orientadas a servicios (SOA). La elección del patrón arquitectónico depende de los requisitos de escalabilidad, mantenibilidad, velocidad de desarrollo, seguridad y costo.

## Áreas clave

- **Layered Architecture (N-tier)**: Separación en capas horizontales (presentación, negocio, datos). La más común, pero puede llevar a dependencias rígidas
- **Hexagonal Architecture (Ports & Adapters)**: El núcleo de negocio es independiente de infraestructura (BD, UI, APIs). Puertos son interfaces, adaptadores son implementaciones
- **Microservices**: Servicios pequeños, autónomos, desplegables independientemente, cada uno con su propia base de datos. Comunicación vía HTTP/REST o mensajería asíncrona
- **Event-Driven Architecture**: Componentes se comunican mediante eventos asíncronos. Desacoplamiento total. Patrones: Event Notification, Event-Carried State Transfer, Event Sourcing, CQRS
- **CQRS (Command Query Responsibility Segregation)**: Separación de operaciones de escritura (commands) y lectura (queries). Modelos optimizados independientemente
- **Event Sourcing**: Almacena el estado como secuencia de eventos, no como estado actual. Auditoría completa, time travel, reconstrucción de estado
- **Saga Pattern**: Gestión de transacciones distribuidas en microservicios. Coreografía (eventos) u orquestación (coordinador central)
- **Microkernel (Plug-in)**: Núcleo mínimo con funcionalidad extensible mediante plugins. Eclipse, Jenkins, Jira
- **Space-Based Architecture**: Elimina cuellos de botella de base de datos usando in-memory data grid, replicación y procesamiento paralelo
- **Service-Oriented Architecture (SOA)**: Servicios empresariales con ESB (Enterprise Service Bus), orquestación con BPEL, gobernanza centralizada

## Ejemplo: Arquitectura Hexagonal en Python

```python
# Puerto (interfaz)
from abc import ABC, abstractmethod

class UserRepository(ABC):
    @abstractmethod
    def save(self, user): ...
    @abstractmethod
    def find_by_id(self, id): ...

# Adaptador (implementación concreta - PostgreSQL)
class PostgresUserRepository(UserRepository):
    def __init__(self, connection):
        self.conn = connection
    def save(self, user):
        cur = self.conn.cursor()
        cur.execute("INSERT INTO users VALUES (%s, %s)", (user.id, user.name))
        self.conn.commit()
    def find_by_id(self, id):
        cur = self.conn.cursor()
        cur.execute("SELECT * FROM users WHERE id = %s", (id,))
        row = cur.fetchone()
        return User(*row) if row else None

# Núcleo de negocio (independiente de infraestructura)
class UserService:
    def __init__(self, repo: UserRepository):
        self.repo = repo
    def create_user(self, id, name):
        user = User(id, name)
        self.repo.save(user)
        return user
```

## Tecnologías principales

| Patrón | Tecnologías/Frameworks |
|--------|----------------------|
| Hexagonal | Spring Boot, NestJS, ASP.NET Core, Go kit, Python (dependency injection) |
| Microservices | Kubernetes, Docker, gRPC, REST, Kafka, NATS, service mesh (Istio) |
| CQRS/ES | Axon (Java), EventStoreDB, Marten (.NET), PostgreSQL with logical replication |
| Event-Driven | Kafka, RabbitMQ, AWS SQS/SNS, Azure Event Grid, GCP Pub/Sub |
| Saga | Temporal.io, Camunda, Apache Camel, AWS Step Functions |
| Microkernel | OSGi, Eclipse RCP, Jenkins plugins, VS Code extensions |
| Space-based | Hazelcast, Apache Ignite, GigaSpaces, Coherence |
| Pipeline | Apache Beam, Spring Cloud Data Flow, NiFi, Tekton |

## Buenas prácticas

- Preferir arquitectura hexagonal para sistemas con múltiples fuentes de datos o UIs
- Usar microservicios solo cuando haya clara delimitación de dominios (bounded contexts)
- Evitar shared database entre microservicios; cada servicio su propia base de datos
- Implementar CQRS solo si hay diferencias significativas entre modelos de lectura y escritura
- Usar Event Sourcing para sistemas que requieren auditoría completa o time travel
- Para sistemas pequeños/complejidad moderada, empezar con layered o hexagonal y evolucionar
- Documentar decisiones arquitectónicas con ADRs (Architecture Decision Records)

## Referencias

- *Software Architecture in Practice* (Bass, Clements, Kazman) — SEI Series
- *Building Evolutionary Architectures* (Ford, Parsons, Kua) — arquitectura adaptable
- *Pattern-Oriented Software Architecture* (POSA) — series de Wiley
- *Fundamentals of Software Architecture* (Richards, Ford) — O'Reilly
- Martin Fowler (martinfowler.com) — CQRS, Event Sourcing, Strangler Fig
- microservices.io (Chris Richardson) — catálogo de patrones microservicios
