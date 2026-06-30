# Chroma — Base de Datos Vectorial Open-Source

## Concepto

**Chroma** es una base de datos vectorial open-source escrita en Python, diseñada para ser ligera, fácil de usar e integrar directamente en aplicaciones de IA. A diferencia de soluciones administradas (Pinecone, Weaviate), Chroma corre localmente como librería embebida o como servidor, siendo ideal para prototipado, desarrollo local y despliegues pequeños a medianos.

Chroma se destaca por su API simple, persistencia automática, integración nativa con LangChain y capacidad de ejecutarse en memoria sin infraestructura externa.

## Arquitectura de Chroma

```
Aplicación
  │
  ├─► Chroma Client (Embedded or HTTP)
  │     ├─ Embedded: import chromadb → en proceso
  │     └─ HTTP: ChromaClient("http://localhost:8000")
  │
  ├─► Collection (equivalente a tabla/índice)
  │     ├─ Nombre + metadata
  │     ├─ Función de embedding (por defecto all-MiniLM-L6-v2)
  │     └─ Espacio de métrica (cosine, l2, ip)
  │
  ├─► Tenant & Database (multi-tenencia)
  │     ├─ default tenant
  │     └─ bases de datos aisladas
  │
  └─► Storage
        ├─ DuckDB (metadatos)
        ├─ Parquet (vectores, persistencia)
        └─ SQLite (alternativa ligera)
```

## Implementación

### 1. Configuración y Conexión

```python
import chromadb

# Cliente embebido (en proceso, persistente)
cliente = chromadb.PersistentClient(path="./chroma_data")

# Cliente en memoria (volátil)
cliente_mem = chromadb.EphemeralClient()

# Cliente HTTP (servidor separado)
cliente_http = chromadb.HttpClient(host="localhost", port=8000)

# Obtener o crear colección
coleccion = cliente.get_or_create_collection(
    name="rag_docs",
    metadata={"hnsw:space": "cosine"},  # métrica: cosine, l2, ip
    embedding_function=None  # usar embedding manual o el default
)
```

### 2. Embedding Manual vs Automático

```python
# Opción A: Embedding manual (recomendado con modelos externos)
from sentence_transformers import SentenceTransformer

modelo_emb = SentenceTransformer("all-MiniLM-L6-v2")

def add_docs_manual(coleccion, documentos):
    textos = [d["texto"] for d in documentos]
    embeddings = modelo_emb.encode(textos).tolist()
    ids = [d["id"] for d in documentos]
    metadatas = [{"fuente": d.get("fuente", "")} for d in documentos]

    coleccion.add(
        documents=textos,
        embeddings=embeddings,
        metadatas=metadatas,
        ids=ids
    )

# Opción B: Embedding automático (Chroma usa all-MiniLM-L6-v2 por defecto)
# pip install chromadb[embeddings]

def add_docs_auto(coleccion, documentos):
    coleccion.add(
        documents=[d["texto"] for d in documentos],
        metadatas=[{"fuente": d.get("fuente", "")} for d in documentos],
        ids=[d["id"] for d in documentos]
    )
    # Chroma genera embeddings automáticamente
```

### 3. Búsqueda Básica

```python
# Búsqueda por texto (Chroma embediza la consulta automáticamente)
resultados = coleccion.query(
    query_texts=["¿Qué es RAG?"],
    n_results=5,
    include=["documents", "metadatas", "distances"]
)

for i, doc in enumerate(resultados["documents"][0]):
    dist = resultados["distances"][0][i]
    meta = resultados["metadatas"][0][i]
    print(f"[dist={dist:.3f}] {doc[:100]}... | fuente: {meta.get('fuente')}")

# Búsqueda por embedding (cuando ya tienes el vector)
emb_consulta = modelo_emb.encode(["¿Qué es RAG?"]).tolist()
resultados_emb = coleccion.query(
    query_embeddings=emb_consulta,
    n_results=5
)
```

### 4. Filtrado con Metadatos

```python
# Filtros exactos
resultados = coleccion.query(
    query_texts=["RAG"],
    n_results=10,
    where={"fuente": {"$eq": "documentacion"}},
    where_document={"$contains": "chunking"}  # filtro sobre contenido
)

# Filtros combinados (operadores lógicos)
resultados = coleccion.query(
    query_texts=["tutorial"],
    n_results=20,
    where={
        "$and": [
            {"categoria": {"$eq": "avanzado"}},
            {"fecha": {"$gte": "2024-01-01"}}
        ]
    }
)

# Operadores disponibles: $eq, $ne, $gt, $gte, $lt, $lte, $in, $nin, $and, $or
```

### 5. Actualización y Eliminación

```python
# Actualizar documento
coleccion.update(
    ids=["doc_1"],
    documents=["Nuevo texto actualizado"],
    metadatas=[{"version": 2, "revisado": True}],
    embeddings=modelo_emb.encode(["Nuevo texto actualizado"]).tolist()
)

# Eliminar por ID
coleccion.delete(ids=["doc_1", "doc_2"])

# Eliminar por filtro
coleccion.delete(where={"categoria": {"$eq": "temporal"}})

# Obtener documentos por ID
docs = coleccion.get(
    ids=["doc_1", "doc_3"],
    include=["documents", "metadatas"]
)

# Contar documentos
count = coleccion.count()
print(f"Total documentos: {count}")
```

## Comparativa Chroma vs Pinecone

| Aspecto | Chroma | Pinecone |
|---------|--------|----------|
| Licencia | Apache 2.0 (open-source) | Propietaria (SaaS) |
| Despliegue | Local / Self-hosted | Administrado |
| Embedding nativo | Sí (all-MiniLM-L6-v2) | No (debes proveerlo) |
| Escalabilidad | Vertical | Horizontal automática |
| Costo | Gratuito | Por uso (pods/serverless) |
| Latencia | µs (embebido) | ms (red) |

## Buenas Prácticas

1. **Batch operations**: Usar batches de 100-500 documentos para add.
2. **Persistencia**: Usar `PersistentClient` para no perder datos.
3. **Embedding function personalizada**: Para producción, usa modelos externos.
4. **Colecciones separadas**: Un índice por dominio/proyecto.
5. **HNSW params**: Ajustar `ef_construction` y `M` para equilibrio velocidad/precisión.

```python
# Colección con parámetros HNSW personalizados
coleccion = cliente.create_collection(
    name="rendimiento",
    metadata={
        "hnsw:space": "cosine",
        "hnsw:construction_ef": 200,  # calidad de construcción
        "hnsw:M": 32,  # conexiones por nodo
        "hnsw:search_ef": 100  # profundidad de búsqueda
    }
)
```
