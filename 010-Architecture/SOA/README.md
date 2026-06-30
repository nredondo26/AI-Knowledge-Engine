# SOA — Arquitectura Orientada a Servicios

## Conceptos Fundamentales

La Arquitectura Orientada a Servicios (SOA) es un estilo arquitectónico donde los componentes de software son **servicios** que proporcionan funcionalidades a través de contratos bien definidos (interfaces). Los servicios son autónomos, débilmente acoplados y pueden distribuirse en diferentes dominios y plataformas.

### Principios Clave

- **Contrato formal**: Cada servicio define una interfaz explícita (WSDL, OpenAPI, IDL).
- **Débil acoplamiento**: Los servicios se comunican mediante mensajes estandarizados, sin dependencias directas.
- **Autonomía**: Cada servicio es independiente y gestiona su propio estado.
- **Abstracción**: La implementación interna está oculta tras la interfaz.
- **Reusabilidad**: Los servicios son diseñados para ser reutilizados en múltiples contextos.
- **Composición**: Los servicios se pueden combinar para formar procesos de negocio complejos.
- **Capacidad de descubrimiento**: Los servicios se publican en un registro (UDDI, Service Registry).

### SOA vs Microservicios

| Aspecto | SOA Tradicional | Microservicios |
|---------|----------------|----------------|
| Tamaño del servicio | Grandes (servicios de negocio completos) | Pequeños (una sola capacidad) |
| Comunicación | ESB (Enterprise Service Bus) | API directas, mensajería ligera |
| Base de datos | Compartida (canonical data model) | Por servicio (database per service) |
| Orquestación | Coreografiada/orquestada (BPEL) | Coreografiada (eventos) |
| Contrato | WSDL/SOAP (pesado) | REST/GraphQL/gRPC (ligero) |
| Gobierno | Centralizado (ESB, SOA governance) | Descentralizado (equipo autónomo) |
| Despliegue | Servidores de aplicaciones (JEE, .NET) | Contenedores, serverless |

## SOA con ESB (Enterprise Service Bus)

```
                   ┌─────────────────┐
                   │   Service       │
                   │   Registry      │
                   └────────┬────────┘
                            │
┌────────┐     ┌────────────┴────────────┐     ┌────────┐
│ Client │────▶│         ESB             │────▶│ Service│
│ (Web)  │     │                         │     │ (ERP)  │
└────────┘     │ - Routing               │     └────────┘
               │ - Transformation        │     ┌────────┐
┌────────┐     │ - Protocol conversion   │────▶│ Service│
│ Client │────▶│ - Mediation             │     │ (CRM)  │
│ (Mobile)│    │ - Orchestration         │     └────────┘
└────────┘     │ - Message enhancement   │     ┌────────┐
               └─────────────────────────┘────▶│Service │
                                                │ (Payment)
                                                └────────┘
```

### Configuración ESB con Apache Camel

```java
// Ruta Camel: orquestación de pedido
public class OrderRoute extends RouteBuilder {

    @Override
    public void configure() {
        from("jms:queue:orders")
            .routeId("order-processing")

            // Validación
            .to("bean:orderValidator?method=validate")

            // Enriquecer con datos de cliente
            .enrich("direct:customerService",
                    new CustomerDataEnricher())

            // Transformar al formato del ERP
            .process(exchange -> {
                Order order = exchange.getIn().getBody(Order.class);
                ErpOrder erpOrder = orderMapper.toErpFormat(order);
                exchange.getIn().setBody(erpOrder);
            })

            // Enviar a ERP
            .to("jms:queue:erp.inbound")

            // Notificar a CRM
            .to("direct:notifyCRM")

            // Registrar en auditoría
            .to("jpa:AuditLog");
    }
}
```

## SOAP vs REST en SOA

### Servicio SOAP (WSDL)

```xml
<!-- Definición de servicio SOAP -->
<definitions xmlns="http://schemas.xmlsoap.org/wsdl/"
             targetNamespace="http://ejemplo.com/pagos">
    <types>
        <schema>
            <element name="ProcesarPagoRequest">
                <complexType>
                    <sequence>
                        <element name="orderId" type="string"/>
                        <element name="amount" type="decimal"/>
                        <element name="currency" type="string"/>
                    </sequence>
                </complexType>
            </element>
        </schema>
    </types>

    <message name="ProcesarPagoInput">
        <part name="body" element="tns:ProcesarPagoRequest"/>
    </message>

    <portType name="PaymentPort">
        <operation name="procesarPago">
            <input message="tns:ProcesarPagoInput"/>
            <output message="tns:ProcesarPagoOutput"/>
        </operation>
    </portType>

    <binding name="PaymentSOAP" type="tns:PaymentPort">
        <soap:binding style="document"
                      transport="http://schemas.xmlsoap.org/soap/http"/>
        <operation name="procesarPago">
            <soap:operation soapAction="http://ejemplo.com/procesarPago"/>
        </operation>
    </binding>

    <service name="PaymentService">
        <port name="PaymentPort" binding="tns:PaymentSOAP">
            <soap:address location="http://ejemplo.com/payments"/>
        </port>
    </service>
</definitions>
```

### Servicio REST (OpenAPI)

```yaml
openapi: 3.0.3
info:
  title: Payment Service API
  version: 1.0.0
  description: Servicio de pagos corporativo (SOA)

paths:
  /payments:
    post:
      operationId: processPayment
      summary: Procesar un pago
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [orderId, amount, currency]
              properties:
                orderId:
                  type: string
                amount:
                  type: number
                currency:
                  type: string
                  enum: [EUR, USD, GBP]
      responses:
        '200':
          description: Pago procesado exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentResponse'
  
  /payments/{id}:
    get:
      operationId: getPaymentStatus
      summary: Obtener estado de un pago
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Estado del pago
```

## Service Registry y Discovery

```yaml
# Spring Cloud: Configuración de Eureka Client
eureka:
  client:
    serviceUrl:
      defaultZone: http://eureka-server:8761/eureka/
  instance:
    preferIpAddress: true
    instanceId: ${spring.application.name}:${random.value}

---
# Configuración de servicio REST con descubrimiento
spring:
  application:
    name: order-service
  cloud:
    loadbalancer:
      ribbon:
        enabled: true
```

```java
// Consumo de servicio con discovery
@Service
public class PaymentServiceClient {

    @Autowired
    private RestTemplate restTemplate;

    public PaymentResponse processPayment(PaymentRequest request) {
        // "payment-service" se resuelve via Eureka
        return restTemplate.postForObject(
            "http://payment-service/api/payments",
            request,
            PaymentResponse.class
        );
    }
}
```

## Orquestación con Camunda BPMN

```xml
<!-- BPMN: Proceso de pedido orquestado -->
<bpmn:process id="orderProcess" name="Procesar Pedido">
  <bpmn:startEvent id="start"/>
  
  <bpmn:serviceTask id="validateOrder"
    implementation="delegateExpression=${orderValidator}"/>
  
  <bpmn:serviceTask id="checkInventory"
    implementation="delegateExpression=${inventoryService}"/>
  
  <bpmn:exclusiveGateway id="inventoryOk"/>
  
  <bpmn:serviceTask id="processPayment"
    implementation="delegateExpression=${paymentService}"/>
  
  <bpmn:serviceTask id="notifyCustomer"
    implementation="delegateExpression=${notificationService}"/>
  
  <bpmn:endEvent id="end"/>
  
  <!-- Flujo -->
  <bpmn:sequenceFlow from="start" to="validateOrder"/>
  <bpmn:sequenceFlow from="validateOrder" to="checkInventory"/>
  <bpmn:sequenceFlow from="checkInventory" to="inventoryOk"/>
  <bpmn:sequenceFlow from="inventoryOk" to="processPayment">
    <bpmn:conditionExpression>${inventory > 0}</bpmn:conditionExpression>
  </bpmn:sequenceFlow>
  <bpmn:sequenceFlow from="processPayment" to="notifyCustomer"/>
  <bpmn:sequenceFlow from="notifyCustomer" to="end"/>
</bpmn:process>
```

## Tecnologías Principales

| Componente | Herramientas |
|------------|-------------|
| ESB | Apache Camel, MuleSoft, WSO2, IBM Integration Bus |
| Service Registry | Netflix Eureka, Consul, ZooKeeper, etcd |
| API Gateway | Kong, Apigee, AWS API Gateway, Zuul |
| Orquestación | Camunda BPM, jBPM, Apache Airflow |
| Mensajería | IBM MQ, ActiveMQ, RabbitMQ, Kafka |
| Contratos | WSDL, OpenAPI, AsyncAPI, gRPC IDL |
| Monitoreo | Prometheus, Grafana, ELK, Datadog |

## Relaciones

- [Microservices](../Microservices/) — Evolución moderna de SOA
- [CQRS](../CQRS/) — Patrón de comunicación entre servicios
- [EventSourcing](../EventSourcing/) — Eventos como contratos entre servicios
- [DDD](../DDD/) — Bounded contexts definen los límites de cada servicio
- [Hexagonal](../Hexagonal/) — Arquitectura interna de cada servicio SOA

## Recursos Recomendados

- "Service-Oriented Architecture: Concepts, Technology, and Design" — Thomas Erl
- "SOA Design Patterns" — Thomas Erl
- Martin Fowler — Service Discovery (martinfowler.com)
- Apache Camel Documentation — camel.apache.org
- Camunda BPMN Tutorial — camunda.com
- "Building Microservices" — Sam Newman (evolución de SOA a microservicios)
- SOA Manifesto — soa-manifesto.org
