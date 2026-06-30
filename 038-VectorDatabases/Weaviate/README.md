# Weaviate

## Descripción

Weaviate es una base de datos vectorial open source con capacidades nativas de búsqueda híbrida (vectorial + por palabras clave), graph y generación aumentada. Escrita en Go, Weaviate se destaca por su integración directa con módulos de IA (OpenAI, Cohere, Hugging Face, Google AI) que permiten generar embeddings automáticamente al insertar datos, sin necesidad de un pipeline externo. Soporta búsqueda vectorial ANN (HNSW y otros índices), búsqueda por palabras clave (BM25), búsqueda híbrida con RRF nativo, y filtrado por metadatos con pre-filter y post-filter. Weaviate también incluye capacidades de GraphQL (API nativa), clasificación automática, Q&A modular, y generación de texto aumentada por contexto. Es adecuado tanto para prototipado como para producción a escala media, con soporte para replicación, sharding y multi-tenancy.

## Características principales

- **Módulos de IA Integrados**: OpenAI, Cohere, Hugging Face, Google PaLM, GPT4All. Generan embeddings automáticamente al hacer upsert de datos.
- **Búsqueda Híbrida Nativa**: Combina vector search (nearVector, nearText) con keyword search (BM25) mediante `hybrid`, usando RRF (Reciprocal Rank Fusion) con parámetro alpha ajustable.
- **GraphQL API**: API nativa basada en GraphQL para queries flexibles y eficientes. También soporta RESTful API.
- **Multi-Tenancy**: Aislamiento de datos por tenant dentro de una misma clase, sin necesidad de colecciones separadas.
- **Módulo Q&A**: Permite hacer preguntas sobre documentos almacenados. Weaviate recupera los chunks relevantes y usa un LLM para generar la respuesta.
- **Módulo Generative**: Generación de texto basada en contexto recuperado. Integración con OpenAI, Cohere, LLM locales.
- **Replicación y Sharding**: Replicación asíncrona para alta disponibilidad. Sharding automático para escalado horizontal.
- **CRA (Contextual Retrieval Augmentation)**: Clasificación automática de objetos basada en contexto vectorial.
- **Backups**: Backup y restore nativos a disco o a sistemas externos (S3, GCS).

## Estructura de datos

- **Class**: Similar a una tabla. Define el esquema con propiedades y su tipo de dato. Ej: `Document`, `Product`, `User`.
- **Property**: Campo de un objeto. Puede ser texto, número, booleano, fecha, geo-coordenadas, o vector. Cada propiedad puede ser indexada para filtrado o búsqueda.
- **Vector**: Generado automáticamente por un módulo de IA o provisto explícitamente. Dimensionalidad definida por el modelo.
- **Cross-Reference**: Referencias entre objetos de diferentes clases. Soporta navegación tipo graph en queries.
- **Object**: Instancia de una clase con propiedades y vector. Almacenada con un UUID único.

## Ejemplo: Operaciones básicas

```python
import weaviate

client = weaviate.connect_to_local()

# Crear clase con módulo de embedding
client.collections.create(
    "Document",
    vectorizer_config=weaviate.config.Configure.Vectorizer.text2vec_openai(
        model="text-embedding-3-small"
    ),
    generative_config=weaviate.config.Configure.Generative.openai(
        model="gpt-4o-mini"
    ),
    properties=[
        weaviate.config.Property(name="title", data_type=weaviate.data.DataType.TEXT),
        weaviate.config.Property(name="content", data_type=weaviate.data.DataType.TEXT),
        weaviate.config.Property(name="category", data_type=weaviate.data.DataType.TEXT),
        weaviate.config.Property(name="year", data_type=weaviate.data.DataType.INT),
    ]
)

# Insertar objetos (embeddings se generan automáticamente)
collection = client.collections.get("Document")
collection.insert([
    {"title": "Introducción a RAG", "content": "RAG combina...", "category": "IA", "year": 2024},
    {"title": "Embeddings densos", "content": "Los embeddings...", "category": "IA", "year": 2023}
])

# Búsqueda vectorial
response = collection.query.near_text(
    query="sistemas de recuperación de información",
    limit=5
)

# Búsqueda híbrida
response = collection.query.hybrid(
    query="sistemas de recuperación",
    alpha=0.75,  # 0 = solo BM25, 1 = solo vector
    limit=5
)

# Búsqueda con filtro
response = collection.query.near_text(
    query="machine learning",
    filters=weaviate.classes.query.Filter.by_property("year").greater_or_equal(2024),
    limit=10
)

# Q&A
response = collection.query.near_text(
    query="¿Qué es RAG?",
    limit=3,
    return_metadata=["answer"]
)
```

## Configuración

```yaml
# docker-compose.yml
version: '3.8'
services:
  weaviate:
    image: semitechnologies/weaviate:1.25
    ports:
      - "8080:8080"
    environment:
      AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED: 'true'
      PERSISTENCE_DATA_PATH: '/var/lib/weaviate'
      DEFAULT_VECTORIZER_MODULE: 'text2vec-openai'
      ENABLE_MODULES: 'text2vec-openai,generative-openai,qna-openai'
      OPENAI_APIKEY: '${OPENAI_API_KEY}'
      CLUSTER_HOSTNAME: 'node1'
```

## Relaciones con otros módulos

- `../Chroma/`: Alternativa open source embebida vs. Weaviate como servidor.
- `../Qdrant/`: Competidor directo con enfoque en rendimiento en Rust.
- `../Milvus/`: Alternativa para escalas masivas (billones de vectores).
- `../Pinecone/`: Alternativa SaaS gestionada vs. Weaviate self-hosted.
- `../../035-RAG/`: Vector database para almacenar chunks en pipelines RAG.
- `../../037-AgenticAI/Memory/`: Memoria a largo plazo de agentes almacenada en Weaviate.

## Recursos recomendados

- **Documentación**: weaviate.io/developers/weaviate.
- **Repositorio**: weaviate/weaviate (GitHub).
- **Curso**: "Weaviate Academy" (weaviate.io/academy).
- **Blog**: weaviate.io/blog.
- **Video**: "Weaviate in 5 Minutes" (Weaviate YouTube).
