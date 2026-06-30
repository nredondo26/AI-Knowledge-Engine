# 011-DesignPatterns: Patrones de Diseño

## Descripción ampliada del dominio

Los patrones de diseño son soluciones reutilizables y probadas para problemas recurrentes en el desarrollo de software, descritos en un formato estructurado que incluye nombre, problema, solución, consecuencias y ejemplos. El catálogo clásico de Gang of Four (GoF, 1994) definió 23 patrones organizados en tres categorías: creacionales (creación de objetos), estructurales (composición de clases/objetos) y de comportamiento (interacción y responsabilidad). Desde entonces, han surgido patrones adicionales: patrones enterprise (Martin Fowler, 2002), patrones de integración empresarial (Hohpe, Woolf, 2003), patrones de microservicios (Chris Richardson, 2018), patrones cloud (Microsoft, AWS, 2010s), patrones de arquitectura (Hexagonal, CQRS, Event Sourcing, Saga), y patrones para IA/ML (LLM patterns, agent patterns). Los patrones proporcionan un lenguaje común entre desarrolladores, documentan mejores prácticas, y aceleran el diseño al aplicar soluciones previamente validadas. No son recetas mágicas: deben aplicarse con criterio, considerando el contexto y evitando over-engineering. "Patterns" también incluye anti-patrones (soluciones comunes que parecen correctas pero tienen consecuencias negativas).

## Tabla de conceptos clave

| Patrón | Tipo | Propósito | Ejemplo de uso |
|--------|------|-----------|----------------|
| Singleton | Creacional | Garantizar una única instancia de una clase | Logger, connection pool, config manager |
| Factory Method | Creacional | Crear objetos sin especificar la clase concreta | Frameworks que crean objetos de UI |
| Abstract Factory | Creacional | Crear familias de objetos relacionados | Sistemas multi-tema (windows, mac, linux) |
| Builder | Creacional | Construir objetos complejos paso a paso | Objetos con muchos parámetros opcionales |
| Prototype | Creacional | Crear objetos clonando una instancia existente | Copia de objetos costosos de crear |
| Adapter | Estructural | Hacer que interfaces incompatibles trabajen juntas | Integrar librerías de terceros |
| Bridge | Estructural | Separar abstracción de implementación | Drivers de base de datos, renderers gráficos |
| Composite | Estructural | Tratar objetos individuales y compuestos uniformemente | Árboles de UI, sistemas de archivos |
| Decorator | Estructural | Añadir responsabilidades dinámicamente | Streams de I/O, middlewares |
| Facade | Estructural | Proporcionar interfaz simplificada a un subsistema complejo | APIs públicas que ocultan complejidad |
| Proxy | Estructural | Controlar acceso a otro objeto | Lazy loading, logging, caching, security |
| Strategy | Comportamiento | Definir familia de algoritmos intercambiables | Algoritmos de ordenamiento, validación |
| Observer | Comportamiento | Notificar cambios a múltiples objetos | Eventos, pub-sub, signals/slots |
| Command | Comportamiento | Encapsular petición como objeto | Undo/redo, colas de tareas, transacciones |
| Template Method | Comportamiento | Definir esqueleto de algoritmo, subclases implementan pasos | Frameworks que guían flujo de ejecución |
| Chain of Responsibility | Comportamiento | Pasar petición por cadena de handlers | Middlewares, logging levels, validación |
| Iterator | Comportamiento | Acceder secuencialmente a elementos de colección sin exponer estructura | Colecciones, streams |
| State | Comportamiento | Cambiar comportamiento según estado interno | Máquinas de estado, workflows |

## Tecnologías principales

| Patrón/Categoría | Frameworks/Lenguajes con soporte nativo | Implementación notable |
|-------------------|-----------------------------------------|----------------------|
| Inyección de Dependencias | Spring (Java), Angular (JS/TS), Dagger, Hilt, Guice | Contenedor IoC con DI automática |
| Observer (Reactividad) | React (hooks), Vue (watch/computed), RxJS, Svelte (reactivity) | Signals, Observables, Subjects |
| Strategy | Strategy pattern en Java Collections (Comparator) | Algoritmos intercambiables en runtime |
| Decorator | Python (@decorators), TypeScript, Java I/O | AOP, middleware pipeline |
| Proxy | ES6 Proxy, Java Dynamic Proxy, Spring AOP | Lazy loading, logging, caching |
| Chain of Responsibility | Express/Koa middlewares, ASP.NET Core pipeline | Http request pipeline |
| Command | Undo/Redo en editores, Redux (actions) | Command pattern + CommandBus |
| State | State machines: XState, Spring State Machine | Flujos de trabajo, procesos |
| Builder | Lombok (Java), Kotlin (apply), Python dataclasses | Objetos inmutables con muchos campos |
| Factory | Spring (BeanFactory), Guice (Module) | Creación centralizada de objetos |
| Singleton | Enumeraciones Java, module-level (JS/Python) | Gestión de estado global controlado |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos fundamentales: qué es un patrón, formato (nombre, problema, solución, consecuencias), catálogo GoF básico. Patrones creacionales: Singleton (implementación thread-safe, lazy vs eager initialization), Factory Method, Builder. Patrones estructurales: Adapter, Facade, Proxy. Patrones de comportamiento: Strategy, Template Method, Iterator. Identificar patrones en frameworks conocidos (Java I/O usa Decorator, Collections usa Iterator y Strategy). Anti-patrones básicos: God Object, Spaghetti Code, Golden Hammer.
   - Práctica: Implementar Factory Method y Strategy en un proyecto personal. Refactorizar código existente para usar patrón apropiado.
   - Lectura: "Head First Design Patterns" (Freeman, Robson) — mejor libro introductorio.

2. **Intermedio (2-6 meses)**: GoF completos: Abstract Factory, Prototype, Bridge, Composite, Decorator, Flyweight, Command, Chain of Responsibility, Mediator, Memento, Observer, State, Visitor, Interpreter. Patrones de integración empresarial (EIP): Message Channel, Message Router, Message Translator, Pipes and Filters, Publish-Subscribe, Dead Letter Channel, Guaranteed Delivery. Principios SOLID en relación con patrones: Dependency Inversion permite Strategy y Template Method; Interface Segregation favorece pequeños roles. Patrones de concurrencia: Active Object, Monitor Object, Half-Sync/Half-Async, Thread Pool, Scheduler. Patrones de testing: Test Double (Mock, Stub, Fake, Dummy, Spy), Object Mother, Test Builder. Patrones de refactorización a patrones: Replace Conditional with Strategy, Extract Composite, Replace Implicit Language with Interpreter.
   - Práctica: Analizar framework (Spring, Express, Django) e identificar patrones usados. Implementar sistema de plugins con Strategy + Factory. Escribir tests con mocks (Mockito, Jest).
   - Lectura: "Design Patterns: Elements of Reusable Object-Oriented Software" (GoF), "Patterns of Enterprise Application Architecture" (Fowler).

3. **Avanzado (6-12 meses)**: Patrones de microservicios: Database per Service, API Gateway (Backend for Frontend), Circuit Breaker, Bulkhead, Saga (Choreography/Orchestration), Event Sourcing, CQRS, Strangler Fig, Sidecar, Ambassador, Adapter (legacy), Service Mesh, Retry + Exponential Backoff, Idempotency. Patrones cloud: Cloud Design Patterns (Azure): Queue-Based Load Leveling, Competing Consumers, Priority Queue, Throttling, Cache-Aside, Sharding, Geodes, Health Endpoint, Valet Key. Patrones de integración moderna: Event Notification, Event-Carried State Transfer, event sourcing (ya listado), Transactional Outbox, Change Data Capture (CDC), Dual Write, Idempotent Receiver. Patrones de arquitectura de datos: CQRS (con y sin Event Sourcing), Saga, Polyglot Persistence, Shared Database, Domain Event, Transaction Log Tailing.
   - Práctica: Implementar Circuit Breaker con Resilience4j / Istio. Transactional Outbox con Debezium y Kafka. Migración de monolith a microservicios con Strangler Fig.
   - Lectura: "Microservices Patterns" (Richardson), "Cloud Design Patterns" (Microsoft), "Implementing Domain-Driven Design" (Vernon).

4. **Experto (12+ meses)**: Patrones de sistemas distribuidos: Consensus (Paxos, Raft), Gossip Protocols, Vector Clocks, CRDTs (Conflict-free Replicated Data Types), Two-Phase Commit, Three-Phase Commit, Paxos Made Simple, Raft (Understandable Consensus). Patrones de machine learning: Feature Store, Model Registry, Training Pipeline, Batch Inference, Online Inference, Shadow Deployment, A/B Testing, Canary Deployment para modelos, Data Versioning (DVC), MLflow patterns. Patrones de LLM/AI: Chain of Thought, Tree of Thought (prompting patterns), RAG (naive, advanced, agentic, graph), LLM Orchestrator (LangChain patterns), Router (gateway de modelos), Cache (semantic caching), Guardrails (output validation). Patrones de seguridad: OAuth 2.0 Flows, Federated Identity, Zero Trust, Secrets Management, Encryption at rest/in transit patterns. Patrones de observabilidad: Structured Logging, Distributed Tracing (OpenTelemetry), Metrics (RED method: Rate, Errors, Duration), Health Check, Liveness/Readiness Probe, Service Graph, SLA/SLI/SLO.
   - Práctica: Implementar CRDT para colaboración en tiempo real. Diseñar sistema de feature flags en producción. Construir pipeline de LLM con patterns avanzados.
   - Lectura: "Designing Data-Intensive Applications" (Kleppmann), "Building Microservices" (Newman), papers de sistemas distribuidos.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Algoritmos como Strategy pattern, estructuras como Composite/Iterator |
| [001-Languages](../001-Languages/) | Implementación de patrones en cada lenguaje |
| [002-Frameworks](../002-Frameworks/) | Frameworks construidos sobre patrones (Spring DI, Express middleware) |
| [003-Databases](../003-Databases/) | Repository, DAO, Unit of Work, Identity Map |
| [005-Cloud](../005-Cloud/) | Cloud design patterns: Cache-Aside, Queue-Based Load Leveling |
| [007-Orchestration](../007-Orchestration/) | Patrones de despliegue: blue/green, canary, service mesh |
| [009-Security](../009-Security/) | Security patterns: Proxy, Authenticator, Access Control |
| [010-Architecture](../010-Architecture/) | Patrones arquitectónicos: hexagon, clean, CQRS, event sourcing |
| [012-Testing](../012-Testing/) | Test patterns: Mock, Stub, Page Object, Test Builder |
| [031-AI](../031-AI/) | AI/LLM patterns: chain, router, orchestrator, agent |

## Recursos recomendados

- **Libros**: "Head First Design Patterns" (Freeman, 2ª ed.), "Design Patterns: Elements of Reusable Object-Oriented Software" (GoF — la biblia), "Patterns of Enterprise Application Architecture" (Fowler), "Microservices Patterns" (Richardson), "Cloud Design Patterns" (Microsoft), "Pattern-Oriented Software Architecture" (POSA, vol 1-5).
- **Cursos**: Coursera "Design Patterns" (U Alberta), Udemy "Design Patterns in Modern C++/Java/Python" (Dmitri Nesteruk), Pluralsight "C# Design Patterns".
- **Referencias**: refactoring.guru (excelente sitio con diagramas y ejemplos), sourcemaking.com, dofactory.com.
- **Práctica**: Refactoring Guru ejercicios, Coderbyte design patterns, aplicar patterns en proyectos personales.
- **Anti-patterns**: "AntiPatterns" (Brown et al.), "Anti-Patterns in Project Management", refactoring.guru anti-patterns.

## Notas adicionales

Los patrones de diseño no deben aplicarse indiscriminadamente; el over-engineering con patrones es un anti-patrón común. Se recomienda: (1) conocer los patrones GoF como lenguaje común, (2) especializarse en patrones de tu dominio (microservicios, cloud, data), (3) usar patrones cuando resuelvan un problema real, no por adelantado (YAGNI). El mejor libro para empezar es "Head First Design Patterns" seguido del GoF. Refactoring.guru tiene excelentes explicaciones y ejemplos multiclenguaje. En lenguajes funcionales (Haskell, Scala), los patrones difieren: functors, monads, applicatives reemplazan muchos patrones GoF.
