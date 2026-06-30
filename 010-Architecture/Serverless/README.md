# Serverless — Arquitectura Sin Servidor

## Conceptos Fundamentales

Serverless es un modelo de ejecución en la nube donde el proveedor (AWS, GCP, Azure) gestiona dinámicamente la asignación de recursos. El desarrollador escribe código en **funciones** que se ejecutan en respuesta a eventos, sin preocuparse por servidores, escalado o disponibilidad.

### Características Clave

- **Sin gestión de servidores**: No hay que aprovisionar, parchear o monitorear servidores.
- **Escalado automático**: Desde 0 a miles de instancias basado en la demanda.
- **Pago por uso**: Se cobra por ejecución y tiempo de cómputo (ms), no por capacidad reservada.
- **Event-driven**: Las funciones se disparan por eventos (HTTP, S3, SQS, DynamoDB Streams, CloudWatch, etc).
- **Stateless**: Las funciones son efímeras y sin estado. El estado se almacena externamente (DB, cache, object storage).

### FaaS vs PaaS vs IaaS

| Aspecto | IaaS (EC2) | PaaS (Heroku) | FaaS (Lambda) |
|---------|------------|---------------|----------------|
| Gestión de SO | Sí | No | No |
| Escalado | Manual/Auto | Auto | Auto (instantáneo) |
| Facturación | Por hora | Por mes | Por invocación + ms |
| Latencia en frío | No | No | Sí (cold start) |
| Timeout | Ninguno | Ninguno | 15 min (Lambda) |
| Estado | Persistente | Persistente | Efímero |

## AWS Lambda — Ejemplo Completo

### Función Lambda Básica (Python)

```python
import json
import os
import boto3
from datetime import datetime
from decimal import Decimal

dynamodb = boto3.resource("dynamodb")
sns = boto3.client("sns")

TABLE_NAME = os.environ["ORDERS_TABLE"]
SNS_TOPIC_ARN = os.environ["ORDER_TOPIC_ARN"]

def lambda_handler(event, context):
    """
    Procesa un pedido desde API Gateway.
    POST /orders
    Body: {"user_id": "123", "items": [{"product_id": "p1", "quantity": 2}]}
    """
    # Parsear evento
    body = json.loads(event["body"])
    order_id = context.aws_request_id

    # Validar entrada
    if not body.get("user_id") or not body.get("items"):
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Missing required fields"}),
            "headers": {"Content-Type": "application/json"},
        }

    # Calcular total
    table = dynamodb.Table(TABLE_NAME)
    total = Decimal("0")
    for item in body["items"]:
        product = table.get_item(Key={"pk": f"PRODUCT#{item['product_id']}"})
        price = Decimal(str(product["item"]["price"]))
        total += price * item["quantity"]

    # Guardar pedido en DynamoDB
    order = {
        "pk": f"ORDER#{order_id}",
        "sk": f"USER#{body['user_id']}",
        "user_id": body["user_id"],
        "items": body["items"],
        "total": str(total),
        "status": "CONFIRMED",
        "created_at": datetime.utcnow().isoformat(),
        "ttl": int(datetime.utcnow().timestamp()) + 86400 * 90,  # 90 días
    }
    table.put_item(Item=order)

    # Publicar evento
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Message=json.dumps(order),
        Subject=f"Nuevo pedido: {order_id}",
    )

    return {
        "statusCode": 201,
        "body": json.dumps({"order_id": order_id, "total": str(total)}),
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
    }
```

### Infraestructura como Código (CDK / Terraform)

```python
# cdk/app.py — AWS CDK
from aws_cdk import (
    Stack, Duration, aws_lambda as lambda_,
    aws_apigateway as apigw, aws_dynamodb as dynamodb,
    aws_sns as sns, RemovalPolicy,
)
from constructs import Construct

class OrderServiceStack(Stack):
    def __init__(self, scope: Construct, id: str, **kwargs):
        super().__init__(scope, id, **kwargs)

        # Tabla DynamoDB
        table = dynamodb.Table(
            self, "OrdersTable",
            partition_key=dynamodb.Attribute(name="pk", type=dynamodb.AttributeType.STRING),
            sort_key=dynamodb.Attribute(name="sk", type=dynamodb.AttributeType.STRING),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST,
            time_to_live_attribute="ttl",
            removal_policy=RemovalPolicy.DESTROY,
        )

        # Tópico SNS
        topic = sns.Topic(self, "OrderTopic")

        # Función Lambda
        order_function = lambda_.Function(
            self, "OrderFunction",
            runtime=lambda_.Runtime.PYTHON_3_12,
            handler="handler.lambda_handler",
            code=lambda_.Code.from_asset("src/functions/orders"),
            environment={
                "ORDERS_TABLE": table.table_name,
                "ORDER_TOPIC_ARN": topic.topic_arn,
            },
            memory_size=256,
            timeout=Duration.seconds(30),
            tracing=lambda_.Tracing.ACTIVE,
        )

        table.grant_write_data(order_function)
        topic.grant_publish(order_function)

        # API Gateway
        api = apigw.LambdaRestApi(
            self, "OrdersAPI",
            handler=order_function,
            proxy=False,
            deploy_options=apigw.StageOptions(stage_name="prod"),
        )
        orders = api.root.add_resource("orders")
        orders.add_method("POST")

        # Cache de API Gateway
        api.add_usage_plan(
            "UsagePlan",
            throttle=apigw.ThrottleSettings(burst_limit=100, rate_limit=50),
        )
```

```hcl
# main.tf — Terraform
resource "aws_lambda_function" "order_processor" {
  filename         = "function.zip"
  function_name    = "order-processor"
  role            = aws_iam_role.lambda_role.arn
  handler         = "handler.lambda_handler"
  runtime         = "python3.12"
  timeout         = 30
  memory_size     = 256
  source_code_hash = filebase64sha256("function.zip")

  environment {
    variables = {
      ORDERS_TABLE   = aws_dynamodb_table.orders.name
      ORDER_TOPIC_ARN = aws_sns_topic.order_topic.arn
    }
  }

  tracing_config {
    mode = "Active"
  }
}

resource "aws_dynamodb_table" "orders" {
  name           = "orders"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "pk"
  range_key      = "sk"

  attribute {
    name = "pk"
    type = "S"
  }
  attribute {
    name = "sk"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}
```

## Event-Driven Serverless

### SQS + Lambda (Procesamiento Asíncrono)

```python
import json
import boto3

def lambda_handler(event, context):
    """
    Procesa mensajes de SQS (máximo 10 por invocación).
    Encolado por: API Gateway o Step Functions.
    """
    for record in event["Records"]:
        message = json.loads(record["body"])
        order_id = message["order_id"]
        user_id = message["user_id"]

        try:
            # Llamar a servicio externo (Stripe, PayPal)
            result = process_payment(order_id, user_id, message["amount"])
            if result["status"] == "failed":
                # Enviar a DLQ para reintento manual
                raise Exception(f"Payment failed: {result['error']}")
        except Exception as e:
            # Lambda reintentará automáticamente hasta 3 veces
            # Fallo persistente → mensaje va a DLQ
            print(f"Error processing order {order_id}: {e}")
            raise  # Lambda retorna error → SQS no elimina mensaje
```

### Step Functions (Orquestación)

```json
{
  "Comment": "Orden de compra serverless",
  "StartAt": "ProcesarPedido",
  "States": {
    "ProcesarPedido": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "arn:aws:lambda:us-east-1:123456789:function:process-order",
        "Payload": { "orderId.$": "$.order_id" }
      },
      "Next": "ValidarPago"
    },
    "ValidarPago": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "arn:aws:lambda:us-east-1:123456789:function:validate-payment"
      },
      "Next": "ConfirmarOCancelar",
      "Catch": [
        {
          "ErrorEquals": ["PaymentError"],
          "Next": "CancelarPedido"
        }
      ]
    },
    "ConfirmarPedido": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "arn:aws:lambda:us-east-1:123456789:function:confirm-order"
      },
      "Next": "EnviarEmail"
    },
    "CancelarPedido": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "arn:aws:lambda:us-east-1:123456789:function:cancel-order"
      },
      "Next": "NotificarFallo"
    },
    "EnviarEmail": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "arn:aws:lambda:us-east-1:123456789:function:send-email"
      },
      "End": true
    },
    "NotificarFallo": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:us-east-1:123456789:order-failures",
        "Message.$": "$.error"
      },
      "End": true
    }
  }
}
```

## Patrones Serverless

### Cold Start Optimization

```python
# Inicializar conexiones fuera del handler (se reutilizan en warm starts)
import boto3
import json

# Ejecutado UNA VEZ por instancia (cold start o warm)
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("orders")
cache = {}  # Cache en memoria entre invocaciones warm

def lambda_handler(event, context):
    # Conexiones ya inicializadas, solo lógica de negocio
    body = json.loads(event["body"])
    order_id = body["order_id"]

    # Usar cache local
    if order_id in cache:
        return cache[order_id]

    result = table.get_item(Key={"pk": f"ORDER#{order_id}"})
    return {"statusCode": 200, "body": json.dumps(result["item"])}
```

### Lambda Layers (Dependencias Compartidas)

```python
# La layer contiene: requests, boto3, pydantic, etc.
# La función solo contiene código de negocio

# Las layers se despliegan por separado y se reutilizan
# entre múltiples funciones.
```

### API Gateway + Lambda Authorizer

```python
import json
import jwt

def lambda_handler(event, context):
    """Lambda Authorizer personalizado para API Gateway."""
    token = event["authorizationToken"].removeprefix("Bearer ")

    try:
        payload = jwt.decode(
            token, "public-key",
            algorithms=["RS256"],
            audience="api.example.com",
        )

        return {
            "principalId": payload["sub"],
            "policyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Action": "execute-api:Invoke",
                        "Effect": "Allow" if payload["role"] == "admin" else "Deny",
                        "Resource": event["methodArn"],
                    }
                ],
            },
            "context": {
                "userId": payload["sub"],
                "userRole": payload.get("role", "user"),
            },
        }
    except jwt.PyJWTError:
        raise Exception("Unauthorized")
```

## Observabilidad

```python
# Powertools para AWS Lambda (observabilidad nativa)
from aws_lambda_powertools import Logger, Tracer, Metrics
from aws_lambda_powertools.metrics import MetricUnit
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger()
tracer = Tracer()
metrics = Metrics(namespace="OrderService")

@tracer.capture_method
def process_order(order_data: dict):
    with tracer.subsegment("validate_order"):
        validate(order_data)

    with tracer.subsegment("save_to_db"):
        save(order_data)

    metrics.add_metric(
        name="OrderCreated",
        unit=MetricUnit.Count,
        value=1,
    )
    logger.info("Order processed", extra={"order_id": order_data["id"]})

@tracer.capture_lambda_handler
@logger.inject_lambda_context(log_event=True)
@metrics.log_metrics(capture_cold_start_metric=True)
def lambda_handler(event: dict, context: LambdaContext):
    logger.set_correlation_id(context.aws_request_id)
    order = json.loads(event["body"])
    process_order(order)
    return {"statusCode": 200, "body": json.dumps({"order_id": order["id"]})}
```

## Best Practices

1. **Stateless**: No almacenar estado en el sistema de archivos de Lambda (/tmp tiene 512 MB pero no es persistente). Usar DynamoDB/ElastiCache/S3.
2. **Cold starts minimizados**: Usar Node.js/Python (menor cold start). Para Java/C#, usar SnapStart (Lambda). Mantener funciones pequeñas (< 3 MB).
3. **Timeout adecuado**: API Gateway/Lambda timeout de 30s para APIs síncronas. Usar SQS + Lambda para procesos largos (hasta 15 min).
4. **DLQ obligatorio**: Configurar Dead Letter Queue para mensajes fallidos. Permite depurar fallos sin perder datos.
5. **Least privilege**: IAM roles con permisos mínimos. Una función solo tiene acceso a los recursos que necesita (tabla, topic, bucket).
6. **Environment variables para config**: No hardcodear nombres de tabla, ARN de SNS, URLs. Usar variables de entorno + Secrets Manager.
7. **Estructura de proyecto**: Organizar por dominio, no por tipo. `src/orders/handler.py`, `src/users/handler.py`, `src/shared/`.
8. **Reservas de concurrencia**: Configurar reserved concurrency para funciones críticas. Evitar que funciones no críticas consuman toda la capacidad.
9. **Costos**: Monitorear invocaciones y duración con CloudWatch Metrics. Optimizar memoria (más memoria = más CPU = menos duración = mismo costo).
10. **Pruebas locales**: Usar AWS SAM CLI, LocalStack, or Serverless Framework para emular Lambda/DynamoDB/API Gateway localmente.
