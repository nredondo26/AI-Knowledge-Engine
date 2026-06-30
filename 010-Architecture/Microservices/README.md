# Microservicios — Arquitectura de Servicios Distribuidos

## Conceptos Fundamentales

Los microservicios son un estilo arquitectónico donde una aplicación se estructura como una colección de servicios pequeños, autónomos, desplegables independientemente y organizados alrededor de capacidades de negocio. Cada servicio tiene su propio dominio, base de datos y ciclo de vida.

### Principios Clave

- **Single Responsibility**: Cada servicio encapsula una capacidad de negocio específica (pagos, usuarios, inventario, notificaciones).
- **Despliegue independiente**: Cada servicio puede ser desplegado, escalado y actualizado sin afectar a los demás.
- **Aislamiento de datos**: Cada servicio posee su propia base de datos (o esquema). No comparten tablas directamente.
- **Comunicación vía API**: Los servicios se comunican mediante APIs bien definidas (HTTP/gRPC/async messaging).
- **Polyglot persistence**: Cada servicio elige la base de datos más adecuada (PostgreSQL, MongoDB, Redis, Elasticsearch).
- **Descentralización**: Cada equipo es dueño de sus servicios y toma decisiones tecnológicas independientes.

### Patrón Monolito vs Microservicios

| Aspecto | Monolito | Microservicios |
|---------|----------|----------------|
| Despliegue | Una unidad | Múltiples unidades |
| Escalado | Todo o nada | Por servicio |
| Acoplamiento | Alto (todo junto) | Bajo (vía API) |
| Velocidad de desarrollo | Disminuye con tamaño | Constante |
| Complejidad operativa | Baja | Alta (red, descubrimiento, tracing) |
| Stack tecnológico | Único | Políglota |
| Testing | Unit + E2E | Unit + Contract + Integration |

## Comunicación entre Servicios

### HTTP/REST (Síncrono)

```python
# Servicio de Pagos
from fastapi import FastAPI, HTTPException
import httpx

app = FastAPI()

@app.post("/payments")
async def create_payment(payment: PaymentCreate):
    async with httpx.AsyncClient() as client:
        # Llamada al servicio de usuarios
        user_resp = await client.get(
            f"http://user-service/users/{payment.user_id}",
            timeout=5.0,
        )
        if user_resp.status_code != 200:
            raise HTTPException(status_code=400, detail="User not found")

        user = user_resp.json()

        # Procesar pago
        if user["credit"] < payment.amount:
            raise HTTPException(status_code=400, detail="Insufficient funds")

        payment_result = await process_payment(payment)
        return payment_result
```

### gRPC (Síncrono, binario, streaming)

```protobuf
// payments.proto
service PaymentService {
  rpc ProcessPayment (PaymentRequest) returns (PaymentResponse);
  rpc RefundPayment (RefundRequest) returns (RefundResponse);
  rpc PaymentStream (stream PaymentRequest) returns (stream PaymentStatus);
}

message PaymentRequest {
  string user_id = 1;
  double amount = 2;
  string currency = 3;
  string method = 4;  // card, transfer, crypto
}

message PaymentResponse {
  string transaction_id = 1;
  string status = 2;  // confirmed, declined, pending
  double fee = 3;
}
```

### Mensajería Asíncrona (Event-Driven)

```python
# Servicio de Pedidos (produce eventos)
from kafka import KafkaProducer
import json

producer = KafkaProducer(
    bootstrap_servers=["kafka:9092"],
    value_serializer=lambda v: json.dumps(v).encode(),
    acks="all",          # Esperar confirmación de todos los brokers
    retries=3,
    linger_ms=10,         # Batch de mensajes
)

@app.post("/orders")
async def create_order(order: OrderCreate):
    # Persistir pedido
    saved_order = await db.orders.insert_one(order.dict())
    # Publicar evento (evento de dominio)
    producer.send("orders.created", {
        "event_id": str(uuid4()),
        "event_type": "order.created",
        "order_id": str(saved_order.inserted_id),
        "user_id": order.user_id,
        "total": order.total,
        "items": [item.dict() for item in order.items],
        "timestamp": datetime.utcnow().isoformat(),
    })
    return {"status": "pending", "order_id": str(saved_order.inserted_id)}


# Servicio de Inventario (consume eventos)
from kafka import KafkaConsumer

consumer = KafkaConsumer(
    "orders.created",
    bootstrap_servers=["kafka:9092"],
    group_id="inventory-service",
    value_deserializer=lambda v: json.loads(v.decode()),
    auto_offset_reset="earliest",
    enable_auto_commit=False,
)

for message in consumer:
    event = message.value
    if event["event_type"] == "order.created":
        # Reservar inventario
        for item in event["items"]:
            inventory = db.inventory.find_one({"product_id": item["product_id"]})
            if inventory["stock"] >= item["quantity"]:
                db.inventory.update_one(
                    {"product_id": item["product_id"]},
                    {"$inc": {"stock": -item["quantity"]}},
                )
            else:
                # Publicar evento de fallo
                producer.send("inventory.failed", {
                    "order_id": event["order_id"],
                    "reason": f"Insufficient stock for {item['product_id']}",
                })
        consumer.commit()
```

## Service Discovery

```yaml
# Kubernetes Service + DNS
apiVersion: v1
kind: Service
metadata:
  name: payment-service
spec:
  selector:
    app: payment-svc
  ports:
    - name: http
      port: 80
      targetPort: 8000
---
apiVersion: v1
kind: Service
metadata:
  name: user-service
spec:
  selector:
    app: user-svc
  ports:
    - name: http
      port: 80
      targetPort: 8000
---
# Las llamadas internas usan DNS de K8s
# curl http://payment-service/payments
# curl http://user-service/users/123
```

### Consul Service Discovery

```python
import consul

consul_client = consul.Consul(host="consul:8500")

# Registrar servicio
consul_client.agent.service.register(
    name="payment-svc",
    service_id="payment-svc-v2-instance-1",
    address="10.0.1.50",
    port=8000,
    tags=["v2", "critical"],
    check=consul.Check.http("http://10.0.1.50:8000/health", interval="10s"),
)

# Descubrir servicio
services = consul_client.catalog.service("user-svc")
for service in services[1]:
    print(f"user-svc disponible en {service['Address']}:{service['ServicePort']}")
```

## API Gateway

```yaml
# Kong API Gateway
_format_version: "3.0"
services:
  - name: payment-service
    url: http://payment-service:8000
    routes:
      - name: payments-route
        paths:
          - /api/payments
        methods: [GET, POST, PUT]
        plugins:
          - name: key-auth
          - name: rate-limiting
            config:
              minute: 100
              hour: 1000
          - name: cors
            config:
              origins: ["https://app.example.com"]
              methods: ["GET", "POST", "PUT"]
              headers: ["Authorization", "Content-Type"]

  - name: user-service
    url: http://user-service:8000
    routes:
      - name: users-route
        paths:
          - /api/users
        methods: [GET, POST]
        plugins:
          - name: jwt-auth
          - name: rate-limiting
            config:
              minute: 200
```

## Sagas — Transacciones Distribuidas

### Coreografía

```python
# Saga: Crear pedido (coreografía, cada servicio reacciona a eventos)

# 1. Order Service: Crea pedido → publica `order.created`
# 2. Inventory Service: Escucha `order.created` → reserva stock → publica `inventory.reserved`
# 3. Payment Service: Escucha `inventory.reserved` → cobra → publica `payment.completed`
# 4. Shipping Service: Escucha `payment.completed` → inicia envío → publica `order.shipped`

# Compensación (si algo falla):
# Si Payment falla → publica `payment.failed`
# Inventory escucha `payment.failed` → libera stock (compensación)
```

### Orquestación

```python
class OrderSagaOrchestrator:
    """Orquestador central de la saga de pedidos."""

    async def execute(self, order_data: dict):
        saga_id = str(uuid4())
        await self.save_saga(saga_id, {"status": "started", "order_data": order_data})

        try:
            # Paso 1: Reservar inventario
            inventory_result = await self.call_service(
                "inventory-service", "/reserve", order_data
            )
            await self.save_step(saga_id, "inventory", inventory_result)

            # Paso 2: Procesar pago
            payment_result = await self.call_service(
                "payment-service", "/charge", order_data
            )
            await self.save_step(saga_id, "payment", payment_result)

            # Paso 3: Iniciar envío
            shipping_result = await self.call_service(
                "shipping-service", "/ship", order_data
            )
            await self.save_step(saga_id, "shipping", shipping_result)

            await self.save_saga(saga_id, {"status": "completed"})
            return {"status": "completed", "order_id": order_data["order_id"]}

        except Exception as e:
            # Compensar pasos completados
            await self.compensate(saga_id)
            raise

    async def compensate(self, saga_id: str):
        saga = await self.get_saga(saga_id)
        steps = saga.get("steps", [])
        for step in reversed(steps):
            if step["service"] == "payment":
                await self.call_service("payment-service", "/refund", step["data"])
            elif step["service"] == "inventory":
                await self.call_service("inventory-service", "/release", step["data"])
        await self.save_saga(saga_id, {"status": "compensated"})
```

## Observabilidad en Microservicios

```python
from opentelemetry import trace
from opentelemetry.propagate import inject

tracer = trace.get_tracer(__name__)

@app.get("/api/orders/{order_id}")
async def get_order(order_id: str, request: Request):
    with tracer.start_as_current_span("get-order") as span:
        span.set_attribute("order.id", order_id)

        # Propagación de contexto a otros servicios
        headers = {}
        inject(headers)

        async with httpx.AsyncClient() as client:
            user_resp = await client.get(
                f"http://user-service/users/{user_id}",
                headers=headers,  # traceparent header
            )
            payment_resp = await client.get(
                f"http://payment-service/payments/{payment_id}",
                headers=headers,
            )
        return {"order": order, "user": user_resp.json(), "payment": payment_resp.json()}
```

## Best Practices

1. **Domain-Driven Design (DDD)**: Modelar servicios alrededor de bounded contexts. Cada servicio es dueño de su dominio y lenguaje ubicuo.
2. **API First**: Definir contratos de API antes de implementar. Usar OpenAPI/Swagger para REST, protobuf para gRPC.
3. **Circuit Breaker**: Implementar circuit breaker (Resilience4j, Hystrix, Polly) para manejar fallos de servicios dependientes:
   ```python
   import pybreaker
   breaker = pybreaker.CircuitBreaker(fail_max=5, reset_timeout=30)
   @breaker
   async def call_payment_service(data):
       return await httpx.post("http://payment-service/charge", json=data)
   ```
4. **Bulkhead**: Aislar recursos por servicio (thread pools separados). Un servicio lento no debe agotar todos los threads.
5. **Retry con backoff**: Implementar retry exponencial (1s, 2s, 4s, 8s...) con jitter. No retry infinito.
6. **Observabilidad nativa**: Tracing distribuido (OpenTelemetry), logging estructurado (correlationId), métricas RED (Rate, Errors, Duration).
7. **Despliegue Blue/Green o Canary**: Cada servicio debe soportar múltiples versiones simultáneas para despliegues sin downtime.
8. **Base de datos por servicio**: Cada servicio tiene su propio esquema/BD. La integración es vía API o eventos, no vía joins.
9. **Eventos idempotentes**: Los consumidores de eventos deben ser idempotentes (mismo evento procesado múltiples veces produce mismo resultado).
10. **Health checks + Readiness**: Cada servicio expone `/health` (liveness) y `/ready` (readiness). Kubernetes usa estos probes para routing.
