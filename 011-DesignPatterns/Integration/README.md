# Patrones de Integración

## Descripción del dominio

Los patrones de integración (Enterprise Integration Patterns, EIPs) son soluciones probadas para conectar aplicaciones, servicios y sistemas heterogéneos en entornos distribuidos. Catalogados por Gregor Hohpe y Bobby Woolf en *Enterprise Integration Patterns*, estos patrones abordan los desafíos de enrutamiento, transformación, mediación y orquestación de mensajes entre sistemas que utilizan diferentes protocolos, formatos de datos y modelos de dominio. Cubren desde integración punto-a-punto hasta ESB, message broker, API gateway, y patrones modernos de integración cloud-native.

## Áreas clave

- **Canales de mensajería**: Channel, Publish-Subscribe, Point-to-Point Channel, Datatype Channel, Dead Letter Channel, Guaranteed Delivery
- **Enrutamiento**: Content-Based Router, Message Filter, Recipient List, Splitter, Aggregator, Resequencer, Routing Slip, Dynamic Router
- **Transformación**: Message Translator, Envelope Wrapper, Content Enricher, Claim Check, Normalizer, Canonical Data Model
- **Mediación**: Message Broker, Enterprise Service Bus (ESB), API Gateway, Message Bridge, Process Manager
- **Extremos**: Message Endpoint, Service Activator, Event-Driven Consumer, Polling Consumer, Competing Consumers, Messaging Gateway
- **Orquestación**: Process Manager (Workflow), Saga, State Machine, Aggregator with timeout
- **Patrones de resiliencia**: Circuit Breaker, Retry, Timeout, Bulkhead, Fallback, Throttling, Exponential Backoff
- **Integración cloud-native**: Event-Driven Architecture, Serverless (Lambda, Cloud Functions), Webhooks, Streaming (Kafka, Kinesis)

## Patrones principales

| Patrón | Descripción | Caso de uso |
|--------|-------------|-------------|
| **Message Router** | Enruta mensaje a diferentes canales según condiciones lógicas | Enrutamiento de pedidos por tipo |
| **Splitter** | Divide un mensaje compuesto en múltiples mensajes individuales | Procesamiento de pedidos con múltiples items |
| **Aggregator** | Combina múltiples mensajes relacionados en uno solo | Esperar respuestas de varios servicios |
| **Content Enricher** | Añade datos faltantes consultando una fuente externa | Enriquecer mensaje con datos de BD |
| **Claim Check** | Almacena mensaje grande y pasa solo referencia | Reducir tamaño de mensajes en el bus |
| **Canonical Data Model** | Formato de datos estándar para todos los servicios | Integración multi-sistema sin N transformaciones |
| **Circuit Breaker** | Protege sistema de fallos en cascada | Llamadas a servicios externos no críticos |
| **Competing Consumers** | Múltiples consumidores compiten por mensajes de una cola | Escalado horizontal de procesamiento |

## Ejemplo: Content-Based Router con Apache Camel (Java)

```java
from("direct:orders")
    .choice()
        .when(header("type").isEqualTo("book"))
            .to("jms:queue:bookOrders")
        .when(header("type").isEqualTo("electronics"))
            .to("jms:queue:electronicsOrders")
        .otherwise()
            .to("jms:queue:generalOrders");
```

## Ejemplo: Circuit Breaker con resilience4j (Java)

```java
CircuitBreakerConfig config = CircuitBreakerConfig.custom()
    .failureRateThreshold(50)
    .waitDurationInOpenState(Duration.ofMillis(1000))
    .slidingWindowSize(10)
    .build();

CircuitBreaker circuitBreaker = CircuitBreaker.of("paymentService", config);

Supplier<String> decorated = CircuitBreaker.decorateSupplier(
    circuitBreaker, () -> paymentService.charge(order));
Try<String> result = Try.ofSupplier(decorated)
    .recover(ex -> "fallback: payment declined");
```

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Message Brokers | Apache Kafka, RabbitMQ, ActiveMQ, Azure Service Bus, AWS SQS/SNS |
| Integration Frameworks | Apache Camel, Spring Integration, MuleSoft, WSO2, Dell Boomi |
| ESB | Apache ServiceMix, JBoss Fuse, Oracle SOA Suite, IBM Integration Bus |
| API Gateway | Kong, Apigee, AWS API Gateway, Traefik, NGINX, Envoy |
| Cloud Integration | AWS EventBridge, Azure Logic Apps, GCP Workflows |
| Streaming | Kafka Streams, Apache Flink, Apache Pulsar, Kinesis |
| Orchestration | Temporal, Camunda, Airflow, AWS Step Functions |

## Buenas prácticas

- Preferir integración asíncrona con mensajería sobre sincrónica (REST RPC) cuando sea posible
- Usar un Canonical Data Model para reducir el número de transformaciones (de N² a 2N)
- Implementar Circuit Breaker y Retry para resiliencia en integraciones externas
- Monitorear colas de mensajes (depth, error rates) y configurar Dead Letter Channels
- Usar idempotencia en consumidores para tolerar mensajes duplicados
- Versionar contratos de mensajes (JSON Schema, Avro, Protobuf) desde el inicio
- Preferir Event-Driven con Kafka/Pulsar sobre ESB tradicional para nuevos proyectos
