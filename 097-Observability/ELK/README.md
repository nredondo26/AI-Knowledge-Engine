# ELK Stack — Elasticsearch, Logstash, Kibana

## Conceptos Fundamentales

ELK Stack (Elasticsearch, Logstash, Kibana) es el ecosistema más maduro para logging centralizado. Elasticsearch almacena e indexa datos, Logstash procesa y transforma logs, y Kibana visualiza. Se complementa con Beats (recolectores ligeros) y Elastic APM para trazas.

### Arquitectura

```
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  Filebeat    │──▶│  Logstash    │──▶│  Elasticsearch │──▶│  Kibana      │
│  (log files) │   │  (transform) │   │  (storage +   │   │  (visualize) │
├──────────────┤   │  + enrich)   │   │   indexing)   │   ├──────────────┤
│  Metricbeat  │──▶│              │   │               │   │  APM Server  │
├──────────────┤   └──────────────┘   │  /_search      │   ├──────────────┤
│  Auditbeat   │──▶                   │  /_cat/indices │   │  Fleet Server│
└──────────────┘                      └──────────────┘   └──────────────┘
```

### Componentes

- **Elasticsearch**: Motor de búsqueda y analítica distribuida basado en Apache Lucene. Almacena datos en documentos JSON indexados por campos, permitiendo búsqueda full-text y agregaciones en tiempo real.
- **Logstash**: Pipeline de procesamiento de datos con inputs, filters y outputs. Soporta más de 200 plugins.
- **Kibana**: UI de visualización, descubrimiento de datos, dashboards, Canvas, Maps, Machine Learning y Alerting.
- **Beats**: Agentes ligeros de recolección: Filebeat (logs), Metricbeat (métricas), Heartbeat (uptime), Auditbeat (auditoría), Winlogbeat (eventos Windows).
- **Elastic APM**: Servidor para trazas distribuidas, compatible con OpenTelemetry.

## Configuración

### Docker Compose — Stack Completo

```yaml
version: '3.8'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.12.0
    environment:
      - node.name=es01
      - cluster.name=elk-cluster
      - discovery.type=single-node
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms4g -Xmx4g"
      - xpack.security.enabled=true
      - xpack.security.enrollment.enabled=true
      - xpack.monitoring.collection.enabled=true
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - es-data:/usr/share/elasticsearch/data
      - es-config:/usr/share/elasticsearch/config
      - es-certs:/usr/share/elasticsearch/config/certs
    ports:
      - "9200:9200"
    healthcheck:
      test: curl -s https://localhost:9200 >/dev/null || exit 1
      interval: 30s
      timeout: 10s
      retries: 5

  logstash:
    image: docker.elastic.co/logstash/logstash:8.12.0
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline:ro
      - ./logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml:ro
    ports:
      - "5044:5044"
      - "5000:5000/udp"
    depends_on:
      elasticsearch:
        condition: service_healthy
    environment:
      - LS_JAVA_OPTS=-Xms2g -Xmx2g
      - xpack.monitoring.enabled=true

  kibana:
    image: docker.elastic.co/kibana/kibana:8.12.0
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=https://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=kibana_system
      - ELASTICSEARCH_PASSWORD=${KIBANA_PASSWORD}
      - XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY=${ENCRYPTION_KEY}
    depends_on:
      elasticsearch:
        condition: service_healthy
```

### Logstash Pipeline

```ruby
# logstash/pipeline/main.conf
input {
  beats {
    port => 5044
    ssl => true
    ssl_certificate_authorities => ["/etc/logstash/certs/ca.crt"]
    ssl_certificate => "/etc/logstash/certs/logstash.crt"
    ssl_key => "/etc/logstash/certs/logstash.key"
  }

  tcp {
    port => 5000
    codec => json
    tags => ["syslog"]
  }
}

filter {
  # Parseo de logs estructurados
  if [fields][log_type] == "json" {
    json {
      source => "message"
      target => "parsed"
    }
  }

  # Grok para logs no estructurados
  if [fields][log_type] == "apache" {
    grok {
      match => {
        "message" => "%{COMBINEDAPACHELOG}"
      }
    }
    geoip {
      source => "clientip"
      target => "geo"
      database => "/etc/logstash/geoip/GeoLite2-City.mmdb"
    }
    useragent {
      source => "agent"
      target => "user_agent"
    }
    mutate {
      convert => { "[bytes]" => "integer" }
      convert => { "[response]" => "integer" }
    }
  }

  # Enriquecimiento con datos de stack
  mutate {
    add_field => {
      "[@metadata][environment]" => "%{[fields][env]}"
      "ecs.version" => "8.12.0"
    }
  }

  # Data masking
  mutate {
    gsub => [
      "message", "\b\d{3}-\d{2}-\d{4}\b", "[SSN_REDACTED]",
      "message", "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b", "[EMAIL_REDACTED]"
    ]
  }
}

output {
  elasticsearch {
    hosts => ["https://elasticsearch:9200"]
    index => "logs-%{[fields][env]}-%{+YYYY.MM.dd}"
    user => "logstash_internal"
    password => "${LOGSTASH_PASSWORD}"
    ssl => true
    cacert => "/etc/logstash/certs/ca.crt"
    ilm_enabled => true
    ilm_rollover_alias => "logs"
    ilm_policy => "logs-policy"
  }

  # Debug en desarrollo
  stdout {
    codec => rubydebug
    stdout => false  # Deshabilitar en producción
  }
}
```

### Filebeat Config

```yaml
# filebeat.yml
filebeat.inputs:
  - type: container
    paths:
      - /var/lib/docker/containers/*/*.log
    json.message_key: log
    json.add_error_key: true
    json.keys_under_root: true
    processors:
      - add_docker_metadata:
          host: "unix:///var/run/docker.sock"
      - add_kubernetes_metadata:
          host: "unix:///var/run/secrets/kubernetes.io/serviceaccount/token"
          matchers:
            - logs_path:
                logs_path: "/var/log/containers/"

output.logstash:
  hosts: ["logstash:5044"]
  ssl.certificate_authorities: ["/etc/filebeat/certs/ca.crt"]
  ssl.certificate: "/etc/filebeat/certs/filebeat.crt"
  ssl.key: "/etc/filebeat/certs/filebeat.key"
```

## Consultas en Elasticsearch

### Búsqueda DSL

```json
GET logs-production-2024.01.15/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "level": "ERROR" } },
        { "term": { "service": "payment-svc" } },
        { "range": { "@timestamp": { "gte": "now-1h", "lte": "now" } } }
      ],
      "filter": [
        { "term": { "environment": "production" } }
      ],
      "must_not": [
        { "match": { "message": "healthcheck" } }
      ]
    }
  },
  "sort": [{ "@timestamp": "desc" }],
  "size": 100,
  "_source": ["@timestamp", "service", "level", "message", "trace.id", "error.stack_trace"]
}
```

### Agregaciones

```json
GET logs-production-*/_search
{
  "size": 0,
  "query": {
    "range": { "@timestamp": { "gte": "now-24h" } }
  },
  "aggs": {
    "errores_por_servicio": {
      "terms": {
        "field": "service",
        "size": 10,
        "order": { "_count": "desc" }
      },
      "aggs": {
        "errores_por_hora": {
          "date_histogram": {
            "field": "@timestamp",
            "fixed_interval": "1h"
          }
        },
        "top_errores": {
          "significant_text": {
            "field": "message"
          }
        }
      }
    },
    "latencia_p99": {
      "percentiles": {
        "field": "response_time",
        "percents": [50, 95, 99]
      }
    }
  }
}
```

## ILM — Index Lifecycle Management

```json
PUT _ilm/policy/logs-policy
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "rollover": {
            "max_size": "50GB",
            "max_age": "1d"
          },
          "set_priority": { "priority": 100 }
        }
      },
      "warm": {
        "min_age": "7d",
        "actions": {
          "shrink": { "number_of_shards": 1 },
          "forcemerge": { "max_num_segments": 1 },
          "allocate": { "number_of_replicas": 1 }
        }
      },
      "cold": {
        "min_age": "30d",
        "actions": {
          "searchable_snapshot": {
            "snapshot_repository": "my_backup"
          }
        }
      },
      "delete": {
        "min_age": "90d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```

## Best Practices

1. **Mapping explícito**: Definir mapeos (mappings) antes de ingerir datos. Evitar dynamic mapping para campos de alta cardinalidad. Usar `keyword` para filtros exactos y `text` para búsqueda full-text.
2. **Sharding adecuado**: 20-40 GB por shard. Calcular: `shards = (datos_diarios * días_retention) / 30GB`. No exceder 1000 shards por nodo.
3. **ILM obligatorio**: Siempre usar ILM para gestionar ciclo de vida. Hot → Warm → Cold → Delete según políticas de retención.
4. **Grok performance**: Preferir `dissect` sobre `grok` cuando el formato es fijo (disect es 2-3x más rápido). Usar `grok` solo para formatos variables.
5. **Pipeline Logstash**: Evitar hacer transformaciones complejas en Logstash si Elasticsearch Ingest Pipeline puede hacerlas. Usar Logstash para enriquecimiento (geoip, useragent).
6. **Security**: Activar xpack.security, usar TLS en todas las comunicaciones, autenticar con roles (logstash_writer, kibana_system). Nunca exponer Elasticsearch directamente.
7. **Circuit breakers**: Configurar `indices.breaker.total.limit: 70%` de heap. Monitorear `_nodes/stats` para OOM.
8. **Kibana Spaces**: Separar dashboards por equipo/usuario con espacios (Spaces) y roles (reader, editor, admin).
9. **Rollup**: Para datos históricos (>30 días), usar Elasticsearch Rollup o agendados para resumir datos y reducir almacenamiento.
10. **Monitoreo del stack**: Configurar Metricbeat para monitorear Elasticsearch, Logstash y Kibana. Usar Kibana Stack Monitoring.
