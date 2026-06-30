# Apache Cassandra

## Modelado

Cassandra es una base NoSQL column-family distribuida, masterless, con consistencia eventual y orientada a escrituras intensivas. El modelado sigue el enfoque **query-first**: cada tabla se diseña para responder una consulta específica.

```cql
CREATE KEYSPACE knowledge WITH replication = {
    'class': 'NetworkTopologyStrategy', 'datacenter1': 3
};

-- Posts por usuario (orden cronológico descendente)
CREATE TABLE posts_by_user (
    user_id     UUID,
    created_at  TIMESTAMP,
    post_id     UUID,
    title       TEXT,
    body        TEXT,
    tags        SET<TEXT>,
    view_count  COUNTER,
    PRIMARY KEY (user_id, created_at, post_id)
) WITH CLUSTERING ORDER BY (created_at DESC, post_id ASC);

-- Posts por slug (búsqueda exacta)
CREATE TABLE posts_by_slug (
    slug TEXT PRIMARY KEY,
    user_id UUID, title TEXT, body TEXT, created_at TIMESTAMP
);

-- Materialized view
CREATE MATERIALIZED VIEW posts_by_tag AS
    SELECT tag, created_at, post_id, title FROM posts
    WHERE tag IS NOT NULL AND created_at IS NOT NULL AND post_id IS NOT NULL
    PRIMARY KEY (tag, created_at, post_id) WITH CLUSTERING ORDER BY (created_at DESC);
```

## Consultas

```cql
INSERT INTO posts_by_user (user_id, created_at, post_id, title, body, tags)
VALUES (uuid(), toTimestamp(now()), uuid(), 'Introducción a Cassandra', 'contenido...', {'nosql'});

UPDATE posts_by_user SET view_count = view_count + 1
WHERE user_id = ? AND created_at = ? AND post_id = ?;

SELECT * FROM posts_by_user WHERE user_id = ? LIMIT 20;
SELECT * FROM posts_by_tag WHERE tag = 'nosql';
```

## Índices

```cql
CREATE INDEX idx_users_status ON users (status);

-- SASI (búsqueda por prefijo)
CREATE CUSTOM INDEX idx_posts_title ON posts (title) USING 'org.apache.cassandra.index.sasi.SASIIndex'
WITH OPTIONS = {'mode': 'PREFIX', 'analyzer_class': 'org.apache.cassandra.index.sasi.analyzer.NonTokenizingAnalyzer', 'case_sensitive': 'false'};

CREATE INDEX idx_posts_tags ON posts (tags);
```

## Configuración (cassandra.yaml)

```yaml
cluster_name: 'Knowledge Cluster'
num_tokens: 256
seed_provider: [{class_name: SimpleSeedProvider, parameters: [{seeds: "10.0.0.1,10.0.0.2"}]}]
listen_address: private_ip
endpoint_snitch: GossipingPropertyFileSnitch

concurrent_reads: 32
concurrent_writes: 32
memtable_heap_space_in_mb: 512
compaction_throughput_mb_per_sec: 64
hinted_handoff_enabled: true
```

## Conexión desde aplicación

```python
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from cassandra.query import ConsistencyLevel

cluster = Cluster(['10.0.0.1'], port=9042,
    auth_provider=PlainTextAuthProvider('app','secret'),
    default_consistency_level=ConsistencyLevel.LOCAL_QUORUM)
session = cluster.connect('knowledge')

stmt = session.prepare("INSERT INTO posts_by_user (user_id, created_at, post_id, title, body, tags) VALUES (?, ?, ?, ?, ?, ?)")
session.execute(stmt, [user_id, created_at, post_id, title, body, tags])
```

## Monitoreo

```bash
nodetool status
nodetool cfstats knowledge.posts_by_user
nodetool tpstats     # thread pools
nodetool compactionstats
```

```cql
SELECT * FROM system.compactions_in_progress;
SELECT keyspace_name, table_name, tombstone_gc_debug FROM system_schema.tables;
```
