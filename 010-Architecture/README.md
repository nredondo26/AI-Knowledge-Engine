# 010-Architecture: Arquitectura de Software

## Descripción ampliada del dominio

La arquitectura de software define la estructura fundamental de un sistema: sus componentes, sus relaciones, sus principios de diseño y la evolución a lo largo del tiempo. Es la base sobre la cual se toman decisiones técnicas críticas que determinan la escalabilidad, mantenibilidad, rendimiento, seguridad y costo del sistema. Este módulo cubre estilos arquitectónicos (monolítico, microservicios, event-driven, hexagonal, clean architecture, CQRS, event sourcing), principios de diseño (SOLID, DRY, KISS, YAGNI, Law of Demeter), patrones arquitectónicos, documentación (C4 model, ADRs), evaluación de arquitecturas (ATAM, SAAM), y gobierno técnico. La evolución arquitectónica ha sido: mainframe (1960s) → cliente-servidor (1980s) → aplicaciones web (1990s) → SOA (2000s) → microservicios (2010s) → arquitecturas cloud-native, event-driven y serverless (2020s). La tendencia actual incluye arquitecturas modulares, domain-driven design (DDD), arquitecturas basadas en inteligencia artificial (AI-native architectures), y sistemas autónomos auto-gestionados.

## Tabla de conceptos clave

| Concepto | Descripción | Cuándo usarlo |
|----------|-------------|---------------|
| Monolítico | Una sola aplicación que contiene toda la funcionalidad | Equipos pequeños, MVP, aplicaciones simples |
| Microservicios | Servicios independientes desplegables, cada uno con un solo dominio | Equipos grandes, escalabilidad independiente, despliegue frecuente |
| Event-Driven | Comunicación asíncrona mediante eventos (broker) | Sistemas distribuidos, desacoplamiento, escalabilidad |
| CQRS | Separación de operaciones de lectura y escritura | Sistemas con diferentes cargas de lectura/escritura |
| Event Sourcing | Almacenamiento de eventos en lugar de estado actual | Auditoría completa, trazabilidad, reconstrucción de estado |
| Hexagonal (Ports & Adapters) | Aislamiento del núcleo de negocio de la infraestructura | Aplicaciones con múltiples fuentes de entrada/salida |
| Clean Architecture | Capas concéntricas con dependencias hacia adentro (Dominio → Aplicación → Infraestructura) | Aplicaciones empresariales que necesitan mantenibilidad a largo plazo |
| CQRS + ES (Event Storming) | Patrón combinado para sistemas complejos | Sistemas financieros, logísticos, colaborativos |
| Service Mesh | Capa de infraestructura para comunicación entre microservicios | Microservicios con necesidades de observabilidad, seguridad, tráfico |
| Strangler Fig | Migración gradual de monolitos a microservicios | Refactorización de sistemas legacy |
| API Gateway | Punto de entrada único para APIs con routing, auth, rate limiting | Sistemas de microservicios, seguridad unificada |
| Saga | Coordinación de transacciones distribuidas | Microservicios con operaciones multi-servicio |

## Tecnologías principales

| Enfoque | Tecnologías/Herramientas | Propósito |
|---------|-------------------------|-----------|
| Modelado | Structurizr (C4 model), PlantUML, Mermaid, Draw.io, ArchiMate | Documentación y visualización arquitectónica |
| Comunicación síncrona | REST (OpenAPI 3.1), gRPC, GraphQL, Apache Thrift | APIs, servicios |
| Comunicación asíncrona | Apache Kafka, RabbitMQ, AWS SQS/SNS, NATS, Pulsar, Redis Streams | Event-driven, mensajería |
| Service Mesh | Istio, Linkerd, Consul Connect, Cilium, AWS App Mesh | Comunicación, seguridad, observabilidad |
| API Gateway | Kong, AWS API Gateway, Apigee, Tyk, Traefik, HAProxy, Envoy | Punto de entrada, políticas |
| Observabilidad | OpenTelemetry, Prometheus, Grafana, Jaeger, ELK/Loki | Monitoreo, tracing, logs |
| Containers/K8s | Docker, Kubernetes, Helm, Kustomize | Despliegue y orquestación |
| Serverless | AWS Lambda, Cloud Functions, Azure Functions, Cloudflare Workers | Computación sin servidor, event-driven |
| DB/Storage | PostgreSQL, CockroachDB, S3, DynamoDB, Redis, Elasticsearch | Almacenamiento según patrón de acceso |
| CI/CD | GitHub Actions, GitLab CI/CD, ArgoCD, GitOps | Pipeline de entrega |
| Gobernanza | ArchUnit, SonarQube, ADR (Markdown Any Decision Records) | Reglas, calidad, documentación de decisiones |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Principios fundamentales: SOLID (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion), DRY (Don't Repeat Yourself), KISS (Keep It Simple), YAGNI (You Aren't Gonna Need It), Law of Demeter, Separation of Concerns, Composition over Inheritance. Estilos arquitectónicos básicos: monolítico vs capas (n-tier), MVC arquitectura (Model-View-Controller) y sus variantes. Modelado y documentación: C4 model (Context, Container, Component, Code diagrams), diagramas de componentes y despliegue UML básicos. Principios de acoplamiento y cohesión: high cohesion, low coupling, tipos de acoplamiento (content, common, control, stamp, data).
   - Práctica: Documentar la arquitectura de una aplicación existente usando C4 model. Identificar principios SOLID en código real.
   - Lectura: "Clean Architecture" (Martin) — capítulos 1-16, "Fundamentals of Software Architecture" (Richards, Ford) — parte I.

2. **Intermedio (3-8 meses)**: Domain-Driven Design (DDD): ubicuo language (lenguaje ubicuo), bounded context (contextos delimitados), entities, value objects, aggregates, domain events, repositories, domain services. Arquitectura hexagonal (Ports and Adapters): puertos (interfaces), adaptadores (implementaciones), dominio puro sin dependencias externas. Clean Architecture: capas (Entities, Use Cases, Interface Adapters, Frameworks/Drivers), dependency rule (las dependencias apuntan hacia adentro). Microservicios: principios (bounded context, database per service, decentralized data management, polyglot persistence), comunicación síncrona (REST, gRPC, GraphQL) y asíncrona (events, message queues). API design: RESTful APIs (OpenAPI 3.1), versionado (URI, header, content negotiation), paginación (cursor-based vs offset-based), HATEOAS. ADRs (Architecture Decision Records): estructura (Title, Context, Decision, Consequences, Status).
   - Práctica: Modelar un dominio con DDD (Event Storming). Implementar arquitectura hexagonal con Spring Boot / NestJS. Escribir ADRs para decisiones arquitectónicas.
   - Lectura: "Domain-Driven Design" (Evans), "Implementing Domain-Driven Design" (Vernon), "Building Microservices" (Newman, 2ª ed.), "Clean Architecture" (Martin) parte II.

3. **Avanzado (8-14 meses)**: Event-Driven Architecture: patrones (event notification, event-carried state transfer, event sourcing), garantías de entrega (at-least-once, exactly-once, idempotencia), event brokers (Kafka: topics, partitions, consumer groups, offsets, rebalancing). CQRS (Command Query Responsibility Segregation): commands vs queries, command bus, query handlers, proyecciones materializadas, eventual consistency. Sagas: coreografía (eventos) y orquestación (coordinador central), compensaciones (rollback), estado de saga. Evaluación de arquitectura: ATAM (Architecture Tradeoff Analysis Method), quality attributes (scalability, availability, modifiability, security, testability, performance, deployability), arquitectura vs requisitos no funcionales. Event Storming: técnica colaborativa de modelado de dominio (eventos, comandos, actores, políticas, read models). Arquitectura serverless: patrones (API Gateway + Lambda, Step Functions, SQS + Lambda, event-driven workflows), cold starts, observabilidad, vendor lock-in considerations.
   - Práctica: Implementar CQRS + Event Sourcing para un dominio financiero. Diseñar saga orquestada para e-commerce. Evaluar arquitectura con ATAM.
   - Lectura: "Building Event-Driven Microservices" (Bellemare), "Designing Data-Intensive Applications" (Kleppmann), "Software Architecture: The Hard Parts" (Ford, Richards).

4. **Experto (14+ meses)**: Arquitecturas distribuidas y la paradoja CAP: consistencia (linealizable, causal, eventual), disponibilidad (HA: 9s de uptime), tolerancia a partición, teorema PACELC (CAP + latencia). Transacciones distribuidas: 2PC, 3PC, TCC (Try-Confirm/Cancel), patrones de consenso (Paxos, Raft, Multi-Paxos, Zab). Escalabilidad: horizontal vs vertical, sharding, read replicas, caching tiers (CDN, Redis, Memcached, in-memory cache), cache invalidation strategies (write-through, write-behind, cache-aside, TTL). Chaos Engineering: principios de chaos, plataformas (Chaos Mesh, Litmus, Gremlin), experimentos controlados, steady state, hypothesis-driven chaos. Migration strategies: Strangler Fig pattern, feature flags, parallel run, dark launching, canary releases, blue/green, database migrations sin downtime. Architecture governance: arquitectura evolutiva (evolutionary architecture), fitness functions (automated architecture verification), ArchUnit, NetArchTest, governance boards. AI-native architecture: LLM-integration patterns (router, chain, orchestrator, RAG), agent architectures, Model-as-a-Service, ML pipelines.
   - Proyecto: System design interview — diseñar Twitter, Uber, YouTube, Netflix a alto nivel. Documentar architecture runway para startup. Implementar fitness function con ArchUnit.
   - Lectura: "Designing Data-Intensive Applications" (Kleppmann) — todo, "Software Architecture: The Hard Parts" (Ford, Richards), "Building Evolutionary Architectures" (Ford, Parsons, Kua).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Algoritmos y estructuras para diseño de sistemas |
| [002-Frameworks](../002-Frameworks/) | Implementación de patrones arquitectónicos en frameworks |
| [003-Databases](../003-Databases/) | Patrones de persistencia, CQRS, event sourcing |
| [005-Cloud](../005-Cloud/) | Arquitecturas cloud-native, Well-Architected Framework |
| [007-Orchestration](../007-Orchestration/) | Patrones de despliegue, service mesh |
| [008-Networking](../008-Networking/) | API Gateway, service mesh, latencia de red |
| [009-Security](../009-Security/) | Secure architecture, threat modeling, trust boundaries |
| [011-DesignPatterns](../011-DesignPatterns/) | Patrones de diseño como bloques de construcción |
| [012-Testing](../012-Testing/) | Test architecture, integration testing, contract testing |
| [013-DevOps](../013-DevOps/) | DevOps como facilitador de arquitecturas modernas |
| [031-AI](../031-AI/) | Arquitecturas de sistemas de IA, AI-native patterns |

## Recursos recomendados

- **Libros**: "Clean Architecture" (Martin), "Fundamentals of Software Architecture" (Richards, Ford), "Software Architecture: The Hard Parts" (Ford, Richards), "Building Microservices" (Newman, 2ª ed.), "Domain-Driven Design" (Evans), "Designing Data-Intensive Applications" (Kleppmann), "Building Event-Driven Microservices" (Bellemare), "Building Evolutionary Architectures" (Ford, Parsons).
- **Cursos**: Coursera "Software Design and Architecture" (U Alberta), Pluralsight "Software Architecture Path", O'Reilly Architecture Summit, "Grokking the System Design Interview" (DesignGurus).
- **Documentación**: C4 model (c4model.com), arc42 template, ISO/IEC 42010 (IEEE 1471), TOGAF, ArchiMate, Structurizr.
- **Práctica**: System design problems (systemdesign.one, bytebytego), EventStorming.com workshops, Architecture Katas, O'Reilly Architecture Katas.

## Notas adicionales

La arquitectura de software es tanto técnica como social; involucra comunicación con stakeholders, trade-offs y decisiones que afectan al equipo por años. El "software architect" no es un rol jerárquico sino una responsabilidad técnica. Practicar system design interviews es excelente ejercicio. El C4 model es el estándar de facto para documentación arquitectónica. ADRs capturan el "por qué" detrás de las decisiones. La arquitectura evolutiva (evolutionary architecture) reconoce que la arquitectura debe cambiar con el tiempo.
