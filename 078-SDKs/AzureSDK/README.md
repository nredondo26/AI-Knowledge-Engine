# Azure SDK — Desarrollo con Microsoft Azure

## ¿Qué es Azure SDK?

Conjunto de bibliotecas para interactuar programáticamente con servicios de Microsoft Azure. Proporciona abstracción sobre API REST con patrones de retry, paginación y manejo de credenciales.

## Lenguajes Soportados

| SDK | Instalación |
|-----|-------------|
| **Python** | `pip install azure-identity azure-storage-blob` |
| **JavaScript/TypeScript** | `npm install @azure/identity @azure/storage-blob` |
| **Java** | Maven: `com.azure:*` |
| **.NET** | `dotnet add package Azure.Identity Azure.Storage.Blobs` |
| **Go** | `go get github.com/Azure/azure-sdk-for-go/sdk/...` |

## Autenticación

### DefaultAzureCredential (Recomendado)

```python
from azure.identity import DefaultAzureCredential, ClientSecretCredential

# Orden: env → managed identity → CLI → VS Code
credential = DefaultAzureCredential()

# Service Principal
credential = ClientSecretCredential(
    tenant_id="t", client_id="c", client_secret="s")
```

## Ejemplos por Lenguaje

### Python

```python
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

credential = DefaultAzureCredential()
blob_client = BlobServiceClient(
    account_url="https://mystorage.blob.core.windows.net",
    credential=credential)
container = blob_client.get_container_client("mi-contenedor")
for blob in container.list_blobs():
    print(blob.name)
```

### JavaScript

```javascript
import { DefaultAzureCredential } from "@azure/identity";
import { BlobServiceClient } from "@azure/storage-blob";

const credential = new DefaultAzureCredential();
const client = new BlobServiceClient(
  "https://mystorage.blob.core.windows.net", credential);
for await (const blob of client.getContainerClient("mi-contenedor").listBlobsFlat()) {
  console.log(blob.name);
}
```

## Servicios Fundamentales

### Blob Storage

```python
client = BlobServiceClient.from_connection_string("conn-str")

# Subir
with open("local.txt", "rb") as data:
    client.upload_blob(container="c", name="r", data=data, overwrite=True)

# SAS Token
from azure.storage.blob import generate_blob_sas, BlobSasPermissions
sas = generate_blob_sas(
    account_name="s", container_name="c", blob_name="b",
    account_key="k", permission=BlobSasPermissions(read=True),
    expiry=datetime.utcnow() + timedelta(hours=1))
```

### Cosmos DB

```python
from azure.cosmos import CosmosClient
client = CosmosClient(url="https://mycosmos.documents.azure.com:443/", credential=credential)
database = client.create_database_if_not_exists(id="mi-db")
container = database.create_container_if_not_exists(id="c", partition_key=PartitionKey(path="/id"))
container.upsert_item({"id": "123", "nombre": "Juan"})
items = container.query_items(
    query="SELECT * FROM c WHERE c.status = @s",
    parameters=[{"name": "@s", "value": "activo"}])
```

### Key Vault

```python
from azure.keyvault.secrets import SecretClient
client = SecretClient(vault_url="https://myvault.vault.azure.net", credential=credential)
client.set_secret("api-key", "abc123")
secret = client.get_secret("api-key")
print(secret.value)
```

### Service Bus

```python
from azure.servicebus import ServiceBusClient, ServiceBusMessage
client = ServiceBusClient.from_connection_string("conn")
with client.get_queue_sender("cola") as sender:
    sender.send_messages(ServiceBusMessage("Hola"))
```

## Manejo de Errores

```python
from azure.core.exceptions import ResourceNotFoundError, HttpResponseError
try:
    client.get_blob_client(container="no-existe", blob="x")
except ResourceNotFoundError:
    print("No encontrado")
except HttpResponseError as e:
    print(f"Error {e.status_code}: {e.message}")
```

## Paginación

```python
blobs = client.get_container_client("c").list_blobs()
for blob in blobs:   # Iteración automática
    print(blob.name)
```

## Buenas Prácticas

1. Usar `DefaultAzureCredential` siempre
2. Reciclar clientes (no crear por petición)
3. Preferir RBAC sobre claves de acceso
4. Usar Managed Identity para recursos Azure
5. Configurar timeouts por operación

## Recursos

- [Azure SDK Python](https://learn.microsoft.com/python/api/overview/azure/)
- [Azure SDK JS/TS](https://learn.microsoft.com/javascript/api/overview/azure/)
- [Azure SDK Java](https://learn.microsoft.com/java/api/overview/azure/)
