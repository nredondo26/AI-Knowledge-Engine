# Elasticsearch — Búsqueda y Análisis

## Visión General

Elasticsearch es un motor de búsqueda y análisis distribuido basado en Apache Lucene. Ofrece búsqueda full-text en tiempo real, análisis agregado y escalabilidad horizontal. Es el componente central del Elastic Stack (ELK: Elasticsearch, Logstash, Kibana).

## Arquitectura

```
┌──────────────────────────────────────────────┐
│               Elastic Stack                  │
├──────────────────────────────────────────────┤
│  Kibana         Logstash        Beats        │
│  (Vis. + Dash)  (Pipeline)     (Agentes)     │
│       ▲              ▲              ▲        │
│       │              │              │        │
│       └──────────────┼──────────────┘        │
│                      │                       │
│              ┌───────┴───────┐               │
│              │ Elasticsearch │               │
│              │  (Cluster)    │               │
│              └───────────────┘               │
└──────────────────────────────────────────────┘
```

## Conceptos Fundamentales

| Elástico | Relacional (analogía) |
|----------|----------------------|
| Index | Database |
| Type (deprecated) | Table |
| Document | Row |
| Field | Column |
| Mapping | Schema |
| Shard | Partition |
| Replica | Replica |

### Cluster y Nodos

```yaml
Tipos de nodos:
  Master node:     Gestión del cluster (elegido)
  Data node:       Almacenamiento y consulta de datos
  Ingest node:     Pre-procesamiento de documentos
  Coordinating:    Balanceo de carga (routing)
  Machine Learning: Trabajos de ML (requiere licencia)

Configuración:
  cluster.name: mi-cluster-produccion
  node.name: data-node-01
  node.roles: [data, ingest]
  path.data: /var/lib/elasticsearch
  path.logs: /var/log/elasticsearch
  network.host: 0.0.0.0
  discovery.seed_hosts: ["node1:9300", "node2:9300"]
  cluster.initial_master_nodes: ["master-01"]
```

## Operaciones CRUD

### Indexar un Documento

```bash
# Crear/actualizar documento (id automático)
POST /productos/_doc
{
  "nombre": "Laptop Pro",
  "precio": 1299.99,
  "categoria": "electronica",
  "tags": ["laptop", "computadora"],
  "stock": 50,
  "fecha_creacion": "2024-01-15"
}

# Indexar con ID específico
PUT /productos/_doc/1001
{
  "nombre": "Monitor 27\"",
  "precio": 349.99
}
```

### Leer Documentos

```bash
# Obtener por ID
GET /productos/_doc/1001

# Buscar (Query DSL)
GET /productos/_search
{
  "query": {
    "match": {
      "nombre": "laptop"
    }
  }
}

# Búsqueda avanzada
GET /productos/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "categoria": "electronica" }},
        { "range": { "precio": { "gte": 500, "lte": 2000 }}}
      ],
      "filter": [
        { "term": { "tags": "laptop" }}
      ]
    }
  },
  "sort": [
    { "precio": { "order": "asc" }}
  ],
  "from": 0,
  "size": 10
}
```

### Actualizar

```bash
# Parcial
POST /productos/_update/1001
{
  "doc": {
    "precio": 299.99,
    "stock": 75
  }
}

# Por query
POST /productos/_update_by_query
{
  "script": {
    "source": "ctx._source.precio = ctx._source.precio * 1.1",
    "lang": "painless"
  },
  "query": {
    "term": { "categoria": "electronica" }
  }
}
```

### Eliminar

```bash
# Por ID
DELETE /productos/_doc/1001

# Por query
POST /productos/_delete_by_query
{
  "query": {
    "range": {
      "fecha_creacion": {
        "lt": "2023-01-01"
      }
    }
  }
}
```

## Mappings (Esquema)

```json
PUT /logs
{
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 2,
    "analysis": {
      "analyzer": {
        "spanish_analyzer": {
          "type": "spanish",
          "stopwords": "_spanish_"
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "message": {
        "type": "text",
        "analyzer": "spanish_analyzer",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      },
      "level": {
        "type": "keyword"
      },
      "user_id": {
        "type": "integer"
      },
      "request_duration_ms": {
        "type": "float"
      },
      "tags": {
        "type": "keyword"
      },
      "metadata": {
        "type": "object",
        "enabled": false
      }
    }
  }
}
```

## Aggregations

```bash
GET /productos/_search
{
  "size": 0,
  "aggs": {
    "por_categoria": {
      "terms": {
        "field": "categoria",
        "size": 10
      },
      "aggs": {
        "precio_promedio": {
          "avg": {
            "field": "precio"
          }
        },
        "precio_extremos": {
          "stats": {
            "field": "precio"
          }
        },
        "productos_mas_caros": {
          "top_hits": {
            "size": 3,
            "sort": [{ "precio": { "order": "desc" }}]
          }
        }
      }
    },
    "rango_precios": {
      "range": {
        "field": "precio",
        "ranges": [
          { "to": 100 },
          { "from": 100, "to": 500 },
          { "from": 500, "to": 1000 },
          { "from": 1000 }
        ]
      }
    },
    "ventas_por_mes": {
      "date_histogram": {
        "field": "fecha_creacion",
        "calendar_interval": "month",
        "format": "yyyy-MM"
      }
    }
  }
}
```

## Búsqueda Full-Text

```bash
# Match (análisis de texto)
GET /productos/_search
{
  "query": {
    "match": {
      "nombre": {
        "query": "laptop gaming",
        "operator": "or",
        "fuzziness": "AUTO"
      }
    }
  }
}

# Multi-match (varios campos)
GET /productos/_search
{
  "query": {
    "multi_match": {
      "query": "laptop pro",
      "fields": ["nombre^3", "descripcion", "tags"],
      "type": "best_fields"
    }
  }
}

# Query string (sintaxis Lucene)
GET /productos/_search
{
  "query": {
    "query_string": {
      "query": "(laptop AND gaming) OR (nombre:monitor)",
      "default_field": "nombre"
    }
  }
}
```

## Index Lifecycle Management (ILM)

```json
PUT _ilm/policy/logs_policy
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "rollover": {
            "max_size": "50GB",
            "max_age": "30d"
          },
          "set_priority": {
            "priority": 100
          }
        }
      },
      "warm": {
        "min_age": "30d",
        "actions": {
          "shrink": {
            "number_of_shards": 1
          },
          "forcemerge": {
            "max_num_segments": 1
          }
        }
      },
      "cold": {
        "min_age": "90d",
        "actions": {
          "freeze": {}
        }
      },
      "delete": {
        "min_age": "365d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```

## Monitoreo del Cluster

```bash
# Salud del cluster
GET _cluster/health

# Estadísticas de nodos
GET _nodes/stats

# Índices y su tamaño
GET _cat/indices?v&s=store.size:desc

# Hot threads
GET _nodes/hot_threads

# Performance de queries lentas
GET _settings
{
  "index.search.slowlog.threshold.query.warn": "10s",
  "index.search.slowlog.threshold.fetch.warn": "1s",
  "index.indexing.slowlog.threshold.index.warn": "10s"
}
```

## Cliente Python

```python
from elasticsearch import Elasticsearch
from datetime import datetime

es = Elasticsearch(
    "https://localhost:9200",
    basic_auth=("elastic", "password"),
    verify_certs=False
)

# Indexar
doc = {
    "timestamp": datetime.utcnow(),
    "level": "ERROR",
    "service": "api-gateway",
    "message": "Connection timeout to backend",
    "duration_ms": 5032,
}
resp = es.index(index="logs-app", document=doc)

# Buscar
resp = es.search(
    index="logs-app",
    query={
        "bool": {
            "must": [
                {"match": {"level": "ERROR"}},
                {"range": {"duration_ms": {"gte": 1000}}}
            ],
            "filter": [
                {"term": {"service": "api-gateway"}}
            ]
        }
    },
    aggregations={
        "errors_por_hora": {
            "date_histogram": {
                "field": "timestamp",
                "fixed_interval": "1h"
            }
        }
    },
    size=50
)

for hit in resp["hits"]["hits"]:
    print(hit["_source"]["message"])
```

## Rendimiento y Optimización

```yaml
Sharding:
  - 20-40 GB por shard (antes de forzar merge)
  - shards = (datos_proyectados * factor_crecimiento) / 30GB
  - Máximo 1000 shards por nodo (recomendado)

Refresh interval:
  - Por defecto 1s (near real-time)
  - Para ingesta masiva: 30s-60s

Bulk indexing:
  - 5-15 MB por batch
  - Usar el API _bulk

Circuit breaker:
  - indices.breaker.total.limit: 40% heap
  - indices.breaker.fielddata.limit: 40% heap
  
Segment merging:
  - Tiered merge policy (por defecto)
  - Force merge en índices estáticos (segmentos = 1)
```

## Referencias

- [Elasticsearch Reference](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Elasticsearch: The Definitive Guide](https://www.elastic.co/guide/en/elasticsearch/guide/current/index.html)
- [Elasticsearch Cheatsheet](https://elasticsearch-cheatsheet.jolicode.com/)
- [Elastic Community](https://discuss.elastic.co/)
- [Elastic Cloud](https://www.elastic.co/cloud/)
