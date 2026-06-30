# DynamoDB

## Modelado

DynamoDB es una base NoSQL clave-valor administrada. El modelado se centra en **single-table design**: una sola tabla que sirve múltiples patrones de acceso mediante composite keys (PK + SK).

### Single-Table Design

```
PK                SK                          Entity
USER#<id>         METADATA#<username>         User
USER#<id>         ARTICLE#<ts>#<aid>          Article (por usuario)
ARTICLE#<aid>     METADATA#<ts>               Article metadata
ARTICLE#<aid>     COMMENT#<ts>#<cid>          Comment

GSI1PK             GSI1SK
EMAIL#<email>      USER#<id>                  Lookup por email

GSI2PK             GSI2SK
TAG#<tag>          ARTICLE#<ts>               Artículos por tag
```

### Ejemplo de items

```json
{
  "PK": "USER#a1b2c3",
  "SK": "METADATA#jdoe",
  "username": "jdoe",
  "email": "j@example.com",
  "role": "admin",
  "created_at": "2025-01-01T00:00:00Z"
}

{
  "PK": "USER#a1b2c3",
  "SK": "ARTICLE#2025-06-01T12:00:00Z#art001",
  "article_id": "art001",
  "title": "DynamoDB Advanced Patterns",
  "status": "published",
  "view_count": 1500
}
```

## Consultas

```python
import boto3
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal

dynamodb = boto3.resource("dynamodb", region_name="us-east-1")
table = dynamodb.Table("knowledge")

# Query por PK (artículos de un usuario)
response = table.query(
    KeyConditionExpression=Key("PK").eq("USER#a1b2c3") &
        Key("SK").begins_with("ARTICLE#"),
    ScanIndexForward=False,
    Limit=20
)

# Get directo por PK + SK
item = table.get_item(
    Key={"PK": "ARTICLE#art001", "SK": "METADATA#2025-06-01T12:00:00Z"}
)["Item"]

# Query por GSI (email lookup)
response = table.query(
    IndexName="GSI1",
    KeyConditionExpression=Key("GSI1PK").eq("EMAIL#j@example.com")
)

# Scan con filtro (solo administración, evitar en producción)
response = table.scan(
    FilterExpression=Attr("status").eq("published") &
        Attr("view_count").gte(Decimal("1000")),
    Limit=100
)
```

### Transacciones

```python
client = boto3.client("dynamodb", region_name="us-east-1")
client.transact_write_items(
    TransactItems=[
        {
            "Put": {
                "TableName": "knowledge",
                "Item": {
                    "PK": {"S": "ARTICLE#art003"},
                    "SK": {"S": "METADATA#2025-06-15"},
                    "title": {"S": "New Article"}
                }
            }
        },
        {
            "Update": {
                "TableName": "knowledge",
                "Key": {"PK": {"S": "USER#a1b2c3"}, "SK": {"S": "METADATA#jdoe"}},
                "UpdateExpression": "SET article_count = if_not_exists(article_count, :zero) + :inc",
                "ExpressionAttributeValues": {
                    ":inc": {"N": "1"}, ":zero": {"N": "0"}
                }
            }
        }
    ]
)
```

## Índices

```json
{
  "IndexName": "GSI1",
  "KeySchema": [
    { "AttributeName": "GSI1PK", "KeyType": "HASH" },
    { "AttributeName": "GSI1SK", "KeyType": "RANGE" }
  ],
  "Projection": { "ProjectionType": "KEYS_ONLY" }
}
```

## Configuración (Terraform)

```hcl
resource "aws_dynamodb_table" "knowledge" {
  name         = "knowledge"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  attribute {
    name = "PK"; type = "S"
  }
  attribute {
    name = "SK"; type = "S"
  }
  attribute {
    name = "GSI1PK"; type = "S"
  }
  attribute {
    name = "GSI1SK"; type = "S"
  }

  global_secondary_index {
    name            = "GSI1"
    hash_key        = "GSI1PK"
    range_key       = "GSI1SK"
    projection_type = "KEYS_ONLY"
  }

  point_in_time_recovery { enabled = true }
  server_side_encryption  { enabled = true }
  ttl { attribute_name = "ttl"; enabled = true }

  tags = { Name = "knowledge-engine", Environment = "production" }
}
```

## Conexión desde aplicación

```python
config = boto3.Config(
    retries={"max_attempts": 3, "mode": "adaptive"},
    connect_timeout=5,
    read_timeout=10
)
dynamodb = boto3.resource("dynamodb", config=config)
table = dynamodb.Table("knowledge")

# UPSERT condicional
table.update_item(
    Key={"PK": "ARTICLE#art001", "SK": "METADATA#2025-06-01"},
    UpdateExpression="SET view_count = if_not_exists(view_count, :zero) + :inc",
    ConditionExpression="attribute_exists(PK)",
    ExpressionAttributeValues={":inc": 1, ":zero": 0}
)
```

## Monitoreo

```bash
# Métricas de consumo
aws cloudwatch get-metric-statistics \
  --namespace AWS/DynamoDB \
  --metric-name ConsumedReadCapacityUnits \
  --dimensions Name=TableName,Value=knowledge \
  --period 300 --statistics Sum

# Throttling detectado
aws dynamodb describe-table --table-name knowledge \
  --query 'Table.ProvisionedThroughput'
```
