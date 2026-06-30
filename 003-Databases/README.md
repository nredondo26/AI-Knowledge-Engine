# 003-Databases: Bases de Datos

## Descripción del dominio

Las bases de datos son el pilar del almacenamiento persistente y la recuperación eficiente de información en cualquier sistema de software. Este módulo cubre tanto bases de datos relacionales (SQL) como NoSQL, incluyendo modelos de datos, motores de almacenamiento, optimización de consultas, replicación, particionamiento, índices, transacciones y control de concurrencia. También abarca sistemas de caching, búsqueda full-text y streaming de eventos.

## Conceptos clave

- **Modelo relacional (SQL)**: Tablas, filas, columnas, claves primarias/foráneas, constraints (CHECK, UNIQUE, NOT NULL), normalización (1NF, 2NF, 3NF, BCNF), desnormalización
- **Modelos NoSQL**: Documentos (JSON/BSON), key-value, column-family (wide-column), grafos (property graph, RDF)
- **Transacciones ACID**: Atomicidad, consistencia, aislamiento, durabilidad; niveles de aislamiento (READ UNCOMMITTED a SERIALIZABLE)
- **Teorema CAP**: Consistencia, disponibilidad, tolerancia a partición — trade-offs en sistemas distribuidos
- **Índices**: B-tree, B+tree, hash index, inverted index, GiST, GIN, bloom filters, índices compuestos, covering index, index-only scans
- **Planes de ejecución**: EXPLAIN/ANALYZE, sequential scan, index scan, bitmap scan, nested loop join, hash join, merge join
- **Particionamiento**: Horizontal (sharding) vs vertical (splitting), range partitioning, hash partitioning, list partitioning
- **Replicación**: Leader-follower, multi-leader, quorum-based read/write, synchronous vs asynchronous replication
- **Motores de almacenamiento**: InnoDB (MySQL), WiredTiger (MongoDB), LSM-tree (Cassandra, RocksDB), ARIES (write-ahead logging)
- **PostgreSQL avanzado**: MVCC, VACUUM, TOAST, pg_stat_statements, extensiones (PostGIS, pgvector, TimescaleDB, Citus)
- **OLTP vs OLAP**: Procesamiento transaccional vs analítico; columnar stores (ClickHouse, Redshift, Snowflake)
- **Streaming de eventos**: Apache Kafka, Redpanda, NATS, Pulsar; event sourcing, CQRS
- **Bases de datos vectoriales**: pgvector, Pinecone, Weaviate, Qdrant, Milvus — embeddings, búsqueda de similitud (ANN)

## Tecnologías principales

| Tipo | Tecnologías | Caso de uso |
|------|-------------|-------------|
| Relacional | PostgreSQL, MySQL 8, MariaDB, SQLite | Transacciones, datos estructurados, integridad referencial |
| Documentos | MongoDB 7, Couchbase, Firestore | Datos semiestructurados, schemas flexibles |
| Key-Value | Redis, DynamoDB, etcd, Riak, LevelDB | Caché, sesiones, configuraciones, colas |
| Column-Family | Apache Cassandra, ScyllaDB, HBase | Escritura intensiva, series temporales, IoT |
| Grafos | Neo4j, Amazon Neptune, ArangoDB, Dgraph | Redes sociales, recomendaciones, detección de fraudes |
| Búsqueda | Elasticsearch, OpenSearch, Meilisearch, Algolia | Búsqueda full-text, logs, analytics |
| Columnar/OLAP | ClickHouse, Snowflake, Redshift, BigQuery | Analytics, data warehousing, BI |
| Streaming | Kafka, Redpanda, Pulsar, Kinesis | Event sourcing, pipelines en tiempo real, CDC |

## Hoja de ruta

1. **Principiante**: SQL básico (SELECT, INSERT, UPDATE, DELETE, JOIN, GROUP BY, HAVING) — modelado ER — creación de tablas con constraints — índices básicos
2. **Intermedio**: Normalización, transacciones, niveles de aislamiento, índices compuestos, EXPLAIN, consultas anidadas, CTEs (WITH), window functions (ROW_NUMBER, RANK, LAG/LEAD)
3. **Avanzado**: Optimización de queries, sharding, replicación, backup/restore (pg_dump, WAL archiving), failover, migraciones, particionamiento, clustering, PostgreSQL performance tuning
4. **Experto**: Bases distribuidas (CAP, Raft, Paxos), motores LSM vs B-tree, HTAP (Hybrid Transactional/Analytical Processing), CDC (Debezium), materialized caches, diseño de sistemas de almacenamiento

## Relaciones con otros módulos

- [000-Core](../000-Core/) — Estructuras de datos subyacentes (B-tree, hash tables, LSM-tree)
- [001-Languages](../001-Languages/) — Drivers nativos, ORMs (Prisma, SQLAlchemy, Sequelize, Hibernate, TypeORM)
- [002-Frameworks](../002-Frameworks/) — Conexión e integración desde frameworks web y enterprise
- [005-Cloud](../005-Cloud/) — Bases de datos como servicio (RDS, Aurora, Cloud SQL, DynamoDB, Bigtable)
- [006-Containers](../006-Containers/) — Contenedorización de PostgreSQL, Redis, MongoDB (imágenes oficiales)
- [007-Orchestration](../007-Orchestration/) — StatefulSets en K8s para bases de datos, operadores (Strimzi, Zalando Postgres Operator)
- [008-Networking](../008-Networking/) — Conexiones TCP, SSL/TLS entre apps y DB, pooling (PgBouncer, ProxySQL)
- [038-VectorDatabases](../038-VectorDatabases/) — Bases vectoriales para búsqueda semántica y RAG
- [009-Security](../009-Security/) — Cifrado en reposo y tránsito, RBAC, SSL/TLS, inyección SQL

## Recursos recomendados

- **PostgreSQL**: postgresql.org/docs, "PostgreSQL: Up & Running" (Regina Obe), pganalyze, pgMustard
- **MySQL**: dev.mysql.com/doc, "High Performance MySQL" (Schwartz, Zaitsev, Tkachenko)
- **MongoDB**: mongodb.com/docs, "MongoDB: The Definitive Guide" (Shannon Bradshaw)
- **Cassandra**: cassandra.apache.org/doc, "Cassandra: The Definitive Guide" (Eben Hewitt)
- **Redis**: redis.io/docs, "Redis in Action" (Josiah L. Carlson), Redis University
- **Kafka**: kafka.apache.org/documentation, "Kafka: The Definitive Guide" (Narkhede, Shapira, Palino)
- **General**: "Designing Data-Intensive Applications" (Kleppmann) — OBLIGATORIO para arquitectos de datos
