# 010-Arquitectura de Software

## Descripción del dominio

La arquitectura de software es la disciplina que define la estructura fundamental de un sistema: sus componentes, sus relaciones internas y externas, y los principios que guían su diseño y evolución. Abarca desde decisiones de alto nivel (estilo arquitectónico, división en módulos, patrones de comunicación) hasta decisiones tácticas que afectan el rendimiento, la seguridad, la mantenibilidad y la escalabilidad del sistema. Una buena arquitectura reduce la fricción del cambio, permite probar el sistema de forma aislada y alinea la implementación técnica con los objetivos del negocio.

## Conceptos clave

- **Monolito**: aplicación única donde todos los componentes (UI, lógica, datos) se despliegan juntos. Simple al inicio, pero difícil de escalar y mantener a gran escala.
- **Microservicios**: estilo arquitectónico que estructura la aplicación como un conjunto de servicios pequeños, independientes, desplegables por separado y organizados en torno a capacidades de negocio.
- **Arquitectura Hexagonal (Ports & Adapters)**: aísla el núcleo de la lógica de negocio de los detalles técnicos (bases de datos, APIs, UI) mediante puertos (interfaces) y adaptadores (implementaciones).
- **Clean Architecture**: propuesta por Robert C. Martin, organiza el código en capas concéntricas donde las dependencias apuntan hacia adentro (hacia las entidades y casos de uso), manteniendo el núcleo independiente de frameworks y bases de datos.
- **CQRS (Command Query Responsibility Segregation)**: separa las operaciones de lectura (queries) de las de escritura (commands) en modelos distintos, optimizando cada uno por separado.
- **Event Sourcing**: almacena el estado de un sistema como una secuencia inmutable de eventos en lugar de solo el estado actual. Permite auditoría completa, proyecciones múltiples y reconstrucción histórica.
- **Arquitectura orientada a eventos (EDA)**: los componentes se comunican mediante eventos asíncronos, lo que desacopla productores de consumidores y mejora la resiliencia.
- **Domain-Driven Design (DDD)**: enfoque que modela el software en torno al dominio del negocio, utilizando un lenguaje ubicuo, bounded contexts y agregados.
- **Arquitectura basada en capas**: organización jerárquica (presentación, negocio, datos) donde cada capa solo depende de la inferior.
- **Service Mesh**: capa de infraestructura para gestionar la comunicación entre microservicios (service discovery, balanceo, retry, circuit breaker).

## Tecnologías principales

- **Lenguajes**: Java, C#, TypeScript, Go, Python, Rust, Kotlin
- **Frameworks**: Spring Boot, .NET Core, NestJS, FastAPI, Axon Framework
- **Infraestructura**: Docker, Kubernetes, Istio, Consul, Envoy, NGINX
- **Bases de datos**: PostgreSQL, MongoDB, Cassandra, Redis, Kafka (event store)
- **Herramientas de diseño**: PlantUML, Draw.io, Structurizr, ArchUnit, C4 Model
- **Patrones de comunicación**: REST, gRPC, GraphQL, RabbitMQ, Apache Kafka, NATS

## Hoja de ruta

1. **Principiante**: aprender los fundamentos de la arquitectura basada en capas y monolítica; conocer los principios SOLID y cómo aplicarlos; diseñar APIs REST básicas; entender el modelo C4 para documentar arquitectura.
2. **Intermedio**: implementar Clean Architecture o hexagonal en un proyecto real; aplicar DDD con bounded contexts y agregados; introducir CQRS básico con separación de lecturas/escrituras; usar Docker para aislar componentes.
3. **Avanzado**: diseñar sistemas basados en microservicios con comunicación asíncrona (eventos, mensajería); implementar Event Sourcing con almacenamiento de eventos; adoptar Service Mesh (Istio/Linkerd) para gestionar tráfico; aplicar patrones de resiliencia (circuit breaker, bulkhead, retry with backoff).
4. **Experto**: definir estrategias de evolución arquitectónica (strangler fig, event storming); diseñar arquitecturas serverless y edge computing; contribuir a estándares y herramientas de arquitectura; evaluar trade-offs entre estilos arquitectónicos según el contexto del negocio.

## Relaciones con otros módulos

- [011-DesignPatterns](../011-DesignPatterns/) — los patrones de diseño GoF y modernos son el vocabulario táctico que implementa las decisiones arquitectónicas.
- [012-Testing](../012-Testing/) — la arquitectura determina qué tan testeable es el sistema (inyección de dependencias, puertos/adaptadores, mocks).
- [013-DevOps](../013-DevOps/) — la arquitectura influye en el despliegue (monolito vs. microservicios) y en las estrategias de observabilidad.
- [014-CICD](../014-CICD/) — los pipelines de CI/CD deben reflejar la topología de despliegue y las dependencias entre módulos.
- [015-Automation](../015-Automation/) — automatización de provisionamiento y configuración de infraestructura arquitectónica.
- [017-MFT](../017-MFT/) — la transferencia segura de archivos se integra como un adaptador en la arquitectura hexagonal.
- [018-ERP](../018-ERP/) — los sistemas ERP existentes suelen ser monolíticos; las estrategias de modernización usan patrones arquitectónicos como strangler fig.
- [019-CRM](../019-CRM/) — las integraciones con CRM requieren decisiones arquitectónicas sobre acoplamiento, sincronización y formatos de datos.

## Recursos recomendados

- *Clean Architecture* — Robert C. Martin
- *Patterns of Enterprise Application Architecture* — Martin Fowler
- *Building Microservices* — Sam Newman
- *Domain-Driven Design: Tackling Complexity in the Heart of Software* — Eric Evans
- *Fundamentals of Software Architecture* — Mark Richards, Neal Ford
- *Software Architecture in Practice* — Bass, Clements, Kazman
- *Implementing Domain-Driven Design* — Vaughn Vernon
- *CQRS by Martin Fowler* — martinfowler.com/bliki/CQRS.html
- *The C4 Model for Visualising Software Architecture* — c4model.com
