# 062-Search: Sistemas de Búsqueda

## Descripción del dominio

Los sistemas de búsqueda constituyen la capa de recuperación de información que permite a usuarios y aplicaciones encontrar datos relevantes entre grandes volúmenes de contenido. Este módulo cubre motores de búsqueda modernos como Elasticsearch, Algolia y Meilisearch, la evolución desde búsqueda puramente textual (full-text, BM25) hacia búsqueda semántica basada en embeddings, y la combinación de ambas en sistemas híbridos. También incluye sistemas de ranking (relevance scoring, learning-to-rank), faceted search, autocomplete, y estrategias de indexación y consulta para baja latencia a escala web.

## Conceptos clave

- **Búsqueda full-text**: Indexación de texto completo con tokenización, stemming, lematización, stop words — scoring BM25, TF-IDF — Elasticsearch query DSL, Meilisearch search parameters
- **Búsqueda semántica**: Recuperación basada en significado usando embeddings de texto — similitud coseno entre query embeddings y document embeddings — supera limitaciones de matching exacto
- **Búsqueda híbrida**: Combinación ponderada de resultados textuales (BM25) y semánticos (vector similarity) — reciprocal rank fusion (RRF), score blending
- **Motores de búsqueda**: Elasticsearch (Lucene, distribuido, altamente configurable), Algolia (search-as-you-type, gestionado, baja latencia), Meilisearch (open-source, rápido, fácil), Typesense (open-source, tipado), Apache Solr (maduro, JVM-based)
- **Ranking**: Relevance scoring (TF-IDF, BM25, BM25F), learning-to-rank (pointwise, pairwise, listwise — LambdaRank, LambdaMART), recency boosting, personalization signals
- **Faceted search**: Navegación por facetas (categoría, precio, fecha) — filtros dinámicos que actualizan counts — Elasticsearch aggregations, Algolia faceting
- **Autocomplete / Search-as-you-type**: Tri-grams, edge n-grams, completion suggesters, prefix queries — Algolia instant search, Elasticsearch search-as-you-type field
- **Indexación distribuida**: Sharding, replication, routing — Elasticsearch clusters, SolrCloud — consistent hashing, rebalance
- **Re-ranking**: Etapa de post-procesamiento después de la recuperación inicial — modelos cross-encoder (BERT re-rankers), boosting contextual, diversificación de resultados
- **Synonyms y normalization**: Synonym graphs, filters (lowercase, ASCII folding, stemmers) — Elasticsearch synonym token filter, Meilisearch synonyms API

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Motores de búsqueda | Elasticsearch, Apache Solr, Meilisearch, Algolia, Typesense |
| Búsqueda semántica | Pinecone, Weaviate, Qdrant, Chroma, pgvector — combinados con modelos de embedding |
| Librerías de ranking | Ranklib (Learning-to-Rank), NMSLIB (Non-Metric Space Library), Elasticsearch Learning to Rank plugin |
| Procesamiento de lenguaje | Lucene analyzers, ICU tokenizer, NLTK, spaCy, Stanford CoreNLP |
| Análisis de logs | Elastic Stack (ELK: Elasticsearch, Logstash, Kibana), Grafana Loki, Splunk |
| SDKs cliente | elasticsearch-py, meilisearch-js, algoliasearch-client, typesense-js |
| Híbrido | RRF (Reciprocal Rank Fusion), weighted sum, ColBERT (late interaction), Sparrow (Google) |

## Hoja de ruta

1. **Principiante**: Conceptos de búsqueda full-text — TF-IDF y BM25 — uso de Elasticsearch con Docker — CRUD de documentos — queries básicas (match, term, range) — filtros y sorting — instalación y configuración básica de Meilisearch
2. **Intermedio**: Análisis de texto: tokenizers, filters, analyzers personalizados — mappings y settings — indexing strategies (bulk, refresh interval) — aggregations — search templates — synonyms — autocomplete y suggesters — búsqueda semántica con embeddings básicos
3. **Avanzado**: Búsqueda híbrida (BM25 + vector) con RRF — learning-to-rank con datos de click — sharding strategies y capacidades de clúster — tuning de scoring con function_score y boosting — performance tuning (segment merging, caching, filter cache) — cross-cluster search — hot-warm architecture
4. **Experto**: Re-ranking con cross-encoders (BERT, Cohere Rerank) — arquitecturas multi-modal search (texto + imagen + audio) — personalización en tiempo real del ranking — sistemas de búsqueda con latencia ultra-baja (<10ms) — geo-distributed search — búsqueda conversacional y generativa (Search-Augmented Generation)

## Relaciones con otros módulos

- [060-Indexes](../060-Indexes/) — Índices invertidos y vectoriales como base de los sistemas de búsqueda
- [061-Embeddings](../061-Embeddings/) — Embeddings para búsqueda semántica y modelos de representación
- [035-RAG](../035-RAG/) — Sistemas de búsqueda como componente de recuperación en pipelines RAG
- [063-Examples](../063-Examples/) — Ejemplos prácticos de implementación de búsqueda por tecnología
- [064-Agents](../064-Agents/) — Agentes que usan búsqueda como herramienta de recuperación de información
- [038-VectorDatabases](../038-VectorDatabases/) — Bases de datos vectoriales para búsqueda semántica a escala
- [039-PromptEngineering](../039-PromptEngineering/) — Ingeniería de prompts para mejorar queries de búsqueda semántica
- [001-Languages](../001-Languages/) — SDKs y clientes de búsqueda en cada lenguaje

## Recursos recomendados

- **Libros**: "Elasticsearch: The Definitive Guide" (Gormley & Tong); "Relevant Search" (Doug Turnbull & John Berryman); "Introduction to Information Retrieval" (Manning, Raghavan, Schütze)
- **Papers**: "The Probabilistic Relevance Framework: BM25 and Beyond" (Robertson & Zaragoza, 2009); "ColBERT: Efficient and Effective Passage Search via Contextualized Late Interaction" (Khattab & Zaharia, 2020); "Reciprocal Rank Fusion" (Cormack et al., 2009); "From Softmax to Sparsemax" (Martins & Astudillo, 2016)
- **Documentación oficial**: Elasticsearch Reference, Meilisearch Docs, Algolia Docs, Typesense Docs
- **Cursos**: Elasticsearch Engineer Training (Elastic), Algolia Search Fundamentals, Meilisearch Workshop
- **Benchmarks**: DB-Engines Ranking (Search Engines), VectorDBBench, BEIR Benchmark
