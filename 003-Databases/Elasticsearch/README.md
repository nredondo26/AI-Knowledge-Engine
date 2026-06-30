# Elasticsearch

## Modelado

Elasticsearch es un motor de búsqueda distribuido sobre Lucene. El modelado se define mediante **mappings** y **análisis** de texto.

### Mapping y análisis

```json
PUT /knowledge
{
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 1,
    "analysis": {
      "analyzer": {
        "spanish_advanced": {
          "tokenizer": "standard",
          "filter": ["lowercase", "asciifolding", "spanish_stop", "spanish_stemmer"]
        }
      },
      "filter": {
        "spanish_stop": { "type": "stop", "stopwords": "_spanish_" },
        "spanish_stemmer": { "type": "stemmer", "language": "spanish" }
      }
    }
  },
  "mappings": {
    "dynamic": "strict",
    "properties": {
      "title": {
        "type": "text",
        "analyzer": "spanish_advanced",
        "fields": { "keyword": { "type": "keyword" }, "suggest": { "type": "search_as_you_type" } }
      },
      "body": { "type": "text", "analyzer": "spanish_advanced" },
      "author": { "properties": { "id": { "type": "keyword" }, "username": { "type": "keyword" } } },
      "tags": { "type": "keyword" },
      "view_count": { "type": "integer" },
      "created_at": { "type": "date" },
      "status": { "type": "keyword" },
      "embedding": { "type": "dense_vector", "dims": 768, "similarity": "cosine" }
    }
  }
}
```

## Consultas

### Búsqueda full-text con filtros

```json
GET /knowledge/_search
{
  "query": {
    "bool": {
      "must": [{ "match": { "body": "inteligencia artificial" } }],
      "filter": [
        { "term": { "status": "published" } },
        { "range": { "view_count": { "gte": 100 } } }
      ],
      "should": [{ "rank_feature": { "field": "view_count", "boost": 0.1 } }]
    }
  },
  "highlight": {
    "fields": { "body": { "pre_tags": ["<mark>"], "post_tags": ["</mark>"] } }
  }
}
```

### Agregaciones por tag y tiempo

```json
GET /knowledge/_search
{
  "size": 0,
  "aggs": {
    "by_tag": {
      "terms": { "field": "tags", "size": 20 },
      "aggs": {
        "avg_views": { "avg": { "field": "view_count" } },
        "top_articles": { "top_hits": { "size": 3, "_source": ["title", "view_count"] } }
      }
    },
    "over_time": {
      "date_histogram": { "field": "created_at", "calendar_interval": "month" }
    }
  }
}
```

### Búsqueda semántica con vectores

```json
GET /knowledge/_search
{
  "query": {
    "script_score": {
      "query": { "match": { "status": "published" } },
      "script": {
        "source": "cosineSimilarity(params.query_vector, 'embedding') + 1.0",
        "params": { "query_vector": [0.12, 0.45, 0.78] }
      }
    }
  }
}
```

## Índices y optimización

```json
// Force-merge para reducir segmentos
POST /knowledge/_forcemerge?max_num_segments=1

// Rollover para índices time-based
POST /logs-2025.06.01/_rollover
{
  "conditions": { "max_age": "1d", "max_docs": 5000000 }
}
```

## Configuración (elasticsearch.yml)

```yaml
cluster.name: knowledge-cluster
node.name: node-1
path.data: /data/elasticsearch
bootstrap.memory_lock: true
network.host: 0.0.0.0
http.port: 9200
discovery.seed_hosts: ["node1:9300", "node2:9300"]
cluster.initial_master_nodes: ["node-1"]
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
indices.queries.cache.size: 10%
indices.fielddata.cache.size: 20%
index.search.slowlog.threshold.query.warn: 5s
index.indexing.slowlog.threshold.index.warn: 10s
```

## Conexión desde aplicación

```python
from elasticsearch import AsyncElasticsearch

es = AsyncElasticsearch(
    ["https://localhost:9200"],
    basic_auth=("elastic", "password"),
    verify_certs=False,
    max_retries=3,
    retry_on_timeout=True
)

async def search_articles(query: str, page: int = 1):
    resp = await es.search(
        index="knowledge",
        body={
            "from": (page - 1) * 20,
            "size": 20,
            "query": {
                "multi_match": { "query": query, "fields": ["title^3", "body"], "type": "most_fields" }
            }
        }
    )
    return [hit["_source"] for hit in resp["hits"]["hits"]]
```

## Monitoreo

```bash
# Health y estado
GET _cluster/health
GET _cat/indices?v

# Rendimiento de búsqueda
GET _nodes/stats/indices/search

# Cache de consultas
GET _nodes/stats/indices/query_cache

# Segmentos por índice
GET knowledge/_segments
```
