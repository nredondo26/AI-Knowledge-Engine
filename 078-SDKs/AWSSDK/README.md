# AWS SDK — Desarrollo con Amazon Web Services

## ¿Qué es AWS SDK?

Conjunto de bibliotecas para interactuar programáticamente con los servicios de AWS. Proporciona abstracción sobre la API REST de AWS para múltiples lenguajes.

## Lenguajes Soportados

| SDK | Instalación |
|-----|-------------|
| **Python (boto3)** | `pip install boto3` |
| **JavaScript/TypeScript** | `npm install @aws-sdk/client-*` |
| **Java** | Maven: `software.amazon.awssdk:*` |
| **Go** | `go get github.com/aws/aws-sdk-go-v2` |
| **.NET** | `dotnet add package AWSSDK.*` |

## Configuración de Credenciales

Orden de resolución:
1. Variables de entorno (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
2. `~/.aws/credentials`
3. `~/.aws/config`
4. Rol IAM de instancia EC2

```bash
aws configure
```

## Ejemplos por Lenguaje

### Python (boto3)

```python
import boto3

s3 = boto3.client('s3', region_name='us-east-1')
for bucket in s3.list_buckets()['Buckets']:
    print(bucket['Name'])

s3.upload_file('local.txt', 'mi-bucket', 'remoto.txt')

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Usuarios')
item = table.get_item(Key={'id': '123'})['Item']

lambda_client = boto3.client('lambda')
response = lambda_client.invoke(
    FunctionName='mi-funcion',
    Payload=json.dumps({'key': 'value'})
)
```

### JavaScript (v3)

```javascript
import { S3Client, ListBucketsCommand } from "@aws-sdk/client-s3";
const client = new S3Client({ region: "us-east-1" });
const response = await client.send(new ListBucketsCommand({}));
```

### Java (v2)

```java
S3Client s3 = S3Client.builder().region(Region.US_EAST_1).build();
for (Bucket bucket : s3.listBuckets().buckets()) {
    System.out.println(bucket.name());
}
```

## Servicios Comunes

### S3

```python
s3 = boto3.client('s3')
s3.upload_file('file.txt', 'bucket', 'key.txt',
    ExtraArgs={'ACL': 'public-read'})
url = s3.generate_presigned_url('get_object',
    Params={'Bucket': 'bucket', 'Key': 'key.txt'},
    ExpiresIn=3600)
```

### DynamoDB

```python
table = boto3.resource('dynamodb').Table('mi-tabla')
table.put_item(Item={'id': '123', 'nombre': 'Juan'})
response = table.query(
    IndexName='email-index',
    KeyConditionExpression=Key('email').eq('juan@ex.com'))
```

### Lambda

```python
def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    return {'statusCode': 200}
```

### SQS

```python
sqs = boto3.client('sqs')
sqs.send_message(QueueUrl='url', MessageBody='{"order":"123"}')
response = sqs.receive_message(QueueUrl='url',
    MaxNumberOfMessages=10, WaitTimeSeconds=20)
```

## Manejo de Errores

```python
from botocore.exceptions import ClientError, NoCredentialsError
try:
    s3.get_object(Bucket='no-existe', Key='x')
except ClientError as e:
    error_code = e.response['Error']['Code']
```

## Paginación

```python
paginator = s3.get_paginator('list_objects_v2')
for page in paginator.paginate(Bucket='mi-bucket'):
    for obj in page.get('Contents', []):
        print(obj['Key'])
```

## Buenas Prácticas

1. Nunca hardcodear credenciales; usar IAM Roles
2. Configurar timeouts y retry policies
3. Habilitar logging del SDK
4. Manejar paginación siempre
5. Usar clientes modulares (JS v3) para reducir tamaño

## Recursos

- [AWS SDKs](https://aws.amazon.com/tools/)
- [boto3 docs](https://boto3.amazonaws.com/v1/documentation/api/latest/)
- [AWS SDK JS v3](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/)
