# Cloud Design Patterns

## Descripción del dominio

Los Cloud Design Patterns son soluciones arquitectónicas para problemas recurrentes en aplicaciones cloud-native. Abordan los desafíos específicos de entornos distribuidos, efímeros y escalables: resiliencia a fallos, escalado elástico, gestión de configuración distribuida, descubrimiento de servicios, balanceo de carga, tolerancia a particiones de red y optimización de costos. Catalogados por Microsoft Azure, AWS y Google Cloud, estos patrones son independientes del proveedor cloud y aplicables a cualquier plataforma (Kubernetes, serverless, VM).

## Áreas clave

- **Resiliencia y tolerancia a fallos**: Circuit Breaker, Retry with Exponential Backoff, Bulkhead, Health Endpoint Monitoring, Timeout, Saga, Throttling, Leader Election
- **Escalabilidad y rendimiento**: Queue-Based Load Leveling, Competing Consumers, CQRS, Event Sourcing, Cache-Aside, Sharding, Static Content Hosting, Materialized View
- **Gestión de datos**: Database Sharding, Saga (gestión transacciones distribuidas), CQRS, Event Sourcing, Valet Key (acceso delegado a storage), Strangler Fig (migración incremental)
- **Mensajería y eventos**: Publisher-Subscriber, Event-Driven, Claim Check, Priority Queue, Routing Slip, Sequenced Message
- **Despliegue y operaciones**: Blue-Green Deployment, Canary Release, Feature Toggles, Sidecar, Ambassador, Adapter, Health Endpoint, External Configuration Store
- **Seguridad y identidad**: Gatekeeper, Federated Identity, Valet Key, Token-based Authentication, Secrets Management (Vault, AWS Secrets Manager)

## Patrones principales

| Patrón | Propósito | Ejemplo cloud |
|--------|-----------|---------------|
| **Circuit Breaker** | Evita llamadas a servicio que probablemente fallen | resilience4j, Hystrix |
| **Saga** | Gestiona transacciones distribuidas con compensación | Temporal, AWS Step Functions |
| **CQRS** | Separar lecturas de escrituras para escalar independientemente | EventStoreDB + read models |
| **Strangler Fig** | Migrar gradualmente un monolito a microservicios | API Gateway con enrutamiento progresivo |
| **Sidecar** | Desplegar componentes auxiliares junto al servicio principal | Istio Envoy, Cloud SQL Proxy |
| **Ambassador** | Proxy externo para abstraer conectividad | Envoy, NGINX como proxy de salida |
| **Health Endpoint** | Endpoint de salud (/health, /ready) para orquestación | Kubernetes liveness/readiness probes |
| **Queue-Based Load Leveling** | Buffer de cola para suavizar picos de carga | SQS + Lambda, Pub/Sub + Cloud Functions |
| **Cache-Aside** | Cargar datos en caché bajo demanda | Redis/Memcached + lazy loading |
| **Feature Toggles** | Activar/desactivar funcionalidades sin deploy | LaunchDarkly, Flagsmith, Unleash |

## Ejemplo: Circuit Breaker con resilience4j (Spring Boot)

```yaml
# application.yml
resilience4j.circuitbreaker:
  instances:
    paymentService:
      slidingWindowSize: 10
      minimumNumberOfCalls: 5
      failureRateThreshold: 50
      waitDurationInOpenState: 10s
      permittedNumberOfCallsInHalfOpenState: 3
```

```java
@CircuitBreaker(name = "paymentService", fallbackMethod = "fallback")
public PaymentResponse processPayment(PaymentRequest request) {
    return paymentClient.charge(request);
}

public PaymentResponse fallback(PaymentRequest request, Throwable t) {
    log.warn("Payment service unavailable, using fallback", t);
    return PaymentResponse.declined("Service unavailable");
}
```

## Ejemplo: Health Endpoint en Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-service
spec:
  template:
    spec:
      containers:
        - name: app
          image: my-service:1.0
          livenessProbe:
            httpGet:
              path: /healthz
              port: 8080
            initialDelaySeconds: 3
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 5
```

## Tecnologías principales

| Categoría | AWS | Azure | GCP | Open Source |
|-----------|-----|-------|-----|-------------|
| Service Mesh | App Mesh | Service Fabric | Anthos | Istio, Linkerd, Consul |
| API Gateway | API Gateway | API Management | Apigee | Kong, Tyk, NGINX |
| Message Queue | SQS | Queue Storage | Pub/Sub | RabbitMQ, Kafka |
| Orchestration | Step Functions | Logic Apps | Workflows | Temporal, Camunda |
| Config/Secrets | SSM + Secrets Mgr | Key Vault | Secret Manager | Vault, Consul |
| Feature Toggles | AppConfig | Feature Mgr | — | LaunchDarkly, Unleash |
| Observability | X-Ray | Application Insights | Cloud Ops | OpenTelemetry |

## Buenas prácticas

- Implementar Circuit Breaker para todas las llamadas a servicios externos
- Usar retry con exponential backoff + jitter para fallos transitorios
- Separar health checks de liveness (reinicio) y readiness (tráfico)
- Preferir event-driven con colas para desacoplar componentes
- Usar Strangler Fig para migraciones incrementales de monolitos
- Externalizar toda la configuración (External Configuration Store)
- Implementar feature toggles para releases graduales
- Diseñar para fallo: asumir que todo falla y planificar degradación graceful
