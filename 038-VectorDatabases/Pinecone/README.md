# Pinecone — Base de Datos Vectorial Administrada

## Concepto

**Pinecone** es una base de datos vectorial totalmente administrada (SaaS) diseñada para aplicaciones de ML en producción. Proporciona indexación y búsqueda de alta dimensionalidad con latencias de milisegundos, escalabilidad horizontal automática, y filtrado de metadatos sin perder rendimiento.

Pinecone abstrae la complejidad de mantener infraestructura de ANN (Approximate Nearest Neighbors) como FAISS o ScaNN, ofreciendo una API simple REST/gRPC.

## Arquitectura de Pinecone

```
Aplicación
  │
  ├─► Pinecone Client
  │     ├─ Upsert (insertar/actualizar vectores)
  │     ├─ Query (búsqueda ANN + filtros)
  │     ├─ Fetch (recuperar por ID)
  │     ├─ Delete (eliminar vectores)
  │     └─ Update (actualizar metadatos/vectores)
  │
  ├─► Index (recurso lógico)
  │     ├─ Pod-based (índices dedicados)
  │     │     ├─ s1.x1 (1 pod, hasta 500K vectores)
  │     │     ├─ p1.x1 (1 pod, alto rendimiento)
  │     │     └─ p1.x2 (2 pods, replicación)
  │     │
  │     └─ Serverless (2024+)
  │           ├─ Auto-escalado bajo demanda
  │           └─ Pago por uso (sin pods fijos)
  │
  └─ Almacenamiento
        ├─ Vector Store (alta dimensionalidad)
        ├─ Metadata Store (filtros estructurados)
        └─ Namespace (segmentación lógica del índice)
```

## Implementación

### 1. Configuración Inicial

```python
# pip install pinecone-client
from pinecone import Pinecone, ServerlessSpec

pc = Pinecone(api_key="tu-api-key")

# Crear índice serverless
pc.create_index(
    name="rag-docs",
    dimension=1536,  # text-embedding-3-small
    metric="cosine",
    spec=ServerlessSpec(
        cloud="aws",
        region="us-east-1"
    )
)

# Conectar al índice
index = pc.Index("rag-docs")
```

### 2. Indexación de Documentos

```python
from openai import OpenAI
import uuid

openai = OpenAI()
modelo_embedding = "text-embedding-3-small"

def embed_text(texto):
    resp = openai.embeddings.create(
        input=texto,
        model=modelo_embedding
    )
    return resp.data[0].embedding

def indexar_documentos(documentos):
    vectores = []
    for doc in documentos:
        emb = embed_text(doc["texto"])
        vectores.append({
            "id": doc.get("id", str(uuid.uuid4())),
            "values": emb,
            "metadata": {
                "texto": doc["texto"][:1000],
                "fuente": doc.get("fuente", ""),
                "categoria": doc.get("categoria", ""),
                "fecha": doc.get("fecha", ""),
                "tokens": len(doc["texto"].split())
            }
        })

    # Upsert en batches de 100
    batch_size = 100
    for i in range(0, len(vectores), batch_size):
        batch = vectores[i:i + batch_size]
        index.upsert(vectors=batch, namespace="docs")

    return len(vectores)
```

### 3. Búsqueda Semántica

```python
def buscar(consulta, top_k=5, filtros=None):
    emb = embed_text(consulta)

    resultados = index.query(
        vector=emb,
        top_k=top_k,
        include_metadata=True,
        include_values=True,
        namespace="docs",
        filter=filtros  # opcional: {"categoria": {"$eq": "tutorial"}}
    )

    return [{
        "id": r["id"],
        "score": r["score"],
        "texto": r["metadata"]["texto"],
        "fuente": r["metadata"]["fuente"]
    } for r in resultados["matches"]]

# Ejemplo con filtros
resultados = buscar(
    "¿Cómo funciona RAG?",
    top_k=5,
    filtros={"categoria": {"$in": ["tutorial", "guia"]}}
)

for r in resultados:
    print(f"[{r['score']:.3f}] {r['texto'][:100]}...")
```

### 5. Manejo de Namespaces

Los namespaces permiten segmentar datos dentro de un mismo índice.

```python
# Namespace por cliente
def indexar_cliente(cliente_id, documentos):
    vectores = [{
        "id": str(uuid.uuid4()),
        "values": embed_text(d["texto"]),
        "metadata": {"texto": d["texto"][:1000]}
    } for d in documentos]

    index.upsert(vectors=vectores, namespace=f"cliente_{cliente_id}")

# Búsqueda aislada por cliente
def buscar_cliente(cliente_id, consulta):
    emb = embed_text(consulta)
    return index.query(
        vector=emb,
        top_k=5,
        include_metadata=True,
        namespace=f"cliente_{cliente_id}"
    )
```

## Métricas a Monitorear

| Métrica | Límite recomendado | Impacto |
|---------|-------------------|---------|
| Latencia p99 | < 50ms | Experiencia de usuario |
| Recall@10 | > 0.95 | Precisión de recuperación |
| Pod utilization | < 80% | Espacio para crecimiento |
| Upsert rate | < 1000/s por pod | Evitar throttling |

## Buenas Prácticas

1. **Dimensiones**: Usar 1536 (OpenAI) o 768 (cohere). Dimensiones mayores = más costo.
2. **Batches**: Upsert en batches de 100-200 vectores.
3. **IDs únicos**: Usar UUIDs o hashes de contenido para evitar duplicados.
4. **Metadata size**: Máximo 40KB por vector. No indexar texto completo en metadata.
5. **Serverless vs Pod-based**: Serverless para cargas variables, Pod-based para workloads predecibles.

```python
# Función de hash para IDs deterministas
import hashlib

def generar_id(texto):
    return hashlib.sha256(texto.encode()).hexdigest()[:16]
```
