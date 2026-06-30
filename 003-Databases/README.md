# 003-Databases: Bases de Datos

## Descripción ampliada del dominio

Las bases de datos son sistemas organizados para almacenar, gestionar y recuperar información de manera eficiente, confiable y segura. Este módulo cubre bases de datos relacionales (SQL), no relacionales (NoSQL), NewSQL, bases de datos en memoria, modelos de datos, lenguajes de consulta, optimización, transacciones, replicación, particionamiento y mejores prácticas. La evolución de las bases de datos ha pasado de los sistemas jerárquicos y de red (1960s-70s) al modelo relacional (Codd, 1970, comercializado con Oracle, DB2, SQL Server en los 80s-90s), hasta la revolución NoSQL (2000s) impulsada por web scale (Google Bigtable, Amazon DynamoDB, MongoDB). La década de 2010 trajo NewSQL (CockroachDB, Spanner) y bases de datos especializadas (series temporales, grafos, vectores). En los 2020s, las bases de datos vectoriales se han vuelto críticas para IA generativa y RAG, y bases de datos serverless (PlanetScale, Neon, Supabase) han democratizado el acceso a infraestructura escalable. La elección del tipo de base de datos depende del modelo de datos, patrones de acceso, consistencia requerida y escalabilidad necesaria.

## Tabla de conceptos clave

| Concepto | Descripción | Productos/Sistemas representativos |
|----------|-------------|-----------------------------------|
| Relacional (SQL) | Datos en tablas con esquema fijo, joins, ACID | PostgreSQL, MySQL, SQLite, SQL Server, Oracle |
| Documental | Datos como documentos JSON/BSON con esquema flexible | MongoDB, Couchbase, Firestore, DynamoDB |
| Clave-Valor | Almacenamiento simple de pares clave-valor, alta velocidad | Redis, Memcached, Riak, Amazon DynamoDB |
| Columna ancha | Tablas con millones de columnas, optimizado para analytics | Cassandra, HBase, ScyllaDB, ClickHouse |
| Grafos | Datos como nodos y aristas con relaciones explícitas | Neo4j, Amazon Neptune, ArangoDB, Dgraph |
| Timeseries | Optimizado para datos temporales con alto volumen de escritura | InfluxDB, TimescaleDB, Prometheus, QuestDB |
| Vectorial | Almacenamiento y búsqueda de vectores de embeddings | Pinecone, Weaviate, Chroma, Qdrant, Milvus |
| NewSQL | SQL con escalabilidad horizontal y consistencia fuerte | CockroachDB, YugabyteDB, Google Spanner |
| En memoria | Datos residentes en RAM para latencia ultra baja | Redis, Memcached, Hazelcast, Apache Ignite |
| Embedded | Base de datos que se ejecuta dentro del proceso de la app | SQLite, DuckDB, RocksDB, LevelDB |

## Tecnologías principales

| Base de datos | Tipo | Licencia | Lenguaje | Protocolo | Caso de uso principal | Ranking DB-Engines (2025) |
|---------------|------|----------|----------|-----------|----------------------|--------------------------|
| PostgreSQL | Relacional | Open Source | C | SQL | Aplicaciones web, analytics, geoespacial, vectorial | #4 |
| MySQL | Relacional | Open Source | C++ | SQL | Web apps, LAMP stack, WordPress | #2 |
| SQLite | Embedded | Public Domain | C | SQL (embedded) | Mobile, IoT, aplicaciones desktop, testing | #1 |
| MongoDB | Documental | SSPL | C++ | Query API + drivers | Catálogos, logs, aplicaciones con esquema dinámico | #5 |
| Redis | KV + estructuras | Open Source | C | RESP (TCP) | Caché, sesiones, rate limiting, colas | #6 |
| Cassandra | Columna ancha | Open Source | Java | CQL | IoT, time series, alta disponibilidad multi-región | #9 |
| Neo4j | Grafos | Community/Enterprise | Java | Cypher | Redes sociales, recomendaciones, detección fraude | #22 |
| Elasticsearch | Búsqueda/texto | Elastic License | Java | RESTful (JSON) | Búsqueda full-text, logs, SIEM | #7 |
| ClickHouse | Columna analítica | Open Source | C++ | SQL nativo + HTTP | OLAP, analytics en tiempo real, telemetría | #30 |
| InfluxDB | Time series | MIT/Closed | Go | Flux/SQL | Monitoring, IoT, métricas de infraestructura | #41 |
| Pinecone | Vectorial | Comercial | Go | RESTful/gRPC | Búsqueda semántica, RAG, recomendaciones | Vector #1 |
| DuckDB | Embedded analítica | MIT | C++ | SQL (embedded) | Analytics embebido, ETL ligero, notebooks | Top #10 OLAP |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: tablas, filas, columnas, tipos de datos, claves primarias y foráneas. SQL básico: SELECT, INSERT, UPDATE, DELETE con WHERE, ORDER BY, LIMIT. JOINs: INNER, LEFT, RIGHT, FULL OUTER, CROSS. Funciones de agregación (COUNT, SUM, AVG, MAX, MIN) y GROUP BY + HAVING. Subconsultas y CTEs (WITH) básicos. Normalización: 1NF, 2NF, 3NF, BCNF. Índices básicos B-tree. Clientes SQL (psql, TablePlus, DBeaver, DataGrip).
   - Proyecto: Base de datos para biblioteca con libros, autores, préstamos. Consultas de reportes.
   - Lectura: "SQL for Data Analysis" (Tanimura), documentación PostgreSQL.

2. **Intermedio (3-8 meses)**: Modelado de datos avanzado: normalización vs desnormalización, esquemas estrella y copo de nieve. Índices avanzados: compuestos, parciales, funcionales, covering, GiST, GIN. Transacciones ACID, aislamiento (READ COMMITTED, REPEATABLE READ, SERIALIZABLE), MVCC, deadlocks. Vistas, vistas materializadas, funciones y procedimientos almacenados. Triggers y eventos. Planes de ejecución (EXPLAIN ANALYZE). Migraciones de esquema. Conexión desde lenguajes de programación (drivers, connection pooling, ORMs). Backup y restore (pg_dump, mysqldump, WAL archiving). Replicación (streaming, cascading, logical). Full-text search.
   - Proyecto: Sistema de inventario con historial de transacciones. Optimización de consultas lentas con EXPLAIN.
   - Lectura: "Use the Index, Luke!" (Ertl), "High Performance MySQL" (Schwartz, Zaitsev, Tkachenko).

3. **Avanzado (8-14 meses)**: NoSQL: fundamentos de modelos (documental, clave-valor, columna, grafo, vectores), teorema CAP, consistencia eventual, quorum, vector clocks. Sharding/particionamiento horizontal (hash-based, range-based, consistent hashing). Replicación multi-región. Bases de datos distribuidas: Raft/Paxos consensus (CockroachDB, YugabyteDB), Spanner TrueTime, Cassandra gossip protocol. Bases de datos vectoriales: índices ANN (HNSW, IVF, PQ), métricas de distancia, hybrid search. Time series: retention policies, continuous queries, downsampling, compression. Graph databases: property graph model, Cypher, Gremlin, SPARQL. Performance tuning: buffer pool, WAL, checkpointing, vacuum, autovacuum, query rewrite, index only scans, parallel query execution. Connection pooling con PgBouncer, ProxySQL.
   - Proyecto: Sistema de recomendaciones con grafos (Neo4j). Time series dashboard con InfluxDB/Grafana. Pipeline ETL con cambio de schema y migración entre DB.
   - Lectura: "Designing Data-Intensive Applications" (Kleppmann), "Database Internals" (Petrov).

4. **Experto (14+ meses)**: Implementación de engine de base de datos: storage engines (B-tree, LSM-tree, append-only log), buffer pool management, WAL, crash recovery, MVCC internals. Optimizador de consultas: cost model, join ordering, cardinality estimation, statistics. Sistemas de consensus: implementación Raft, Paxos, Zab. Bases de datos distribuidas: leaderless replication, CRDTs, conflict-free replication. Data warehousing: OLAP vs OLTP, columnar storage, vectorized execution, MPP. Streaming databases: Kafka + ksqlDB, Materialize, RisingWave. Seguridad: TDE (Transparent Data Encryption), data masking, row-level security, audit logging. Database benchmarking: TPC-C, TPC-H, YCSB, sysbench.
   - Proyecto: Implementar un storage engine LSM-tree simple. Benchmark comparativo de DB bajo carga. Contribución a base de datos open source (PostgreSQL, DuckDB, Redis).
   - Lectura: "Readings in Database Systems" (Stonebraker, Hellerstein), "The Art of SQL" (Faroult), Papers: Bigtable, Dynamo, Spanner, Aurora.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | B-tree, hash indexes, algoritmos de ordenamiento para queries |
| [001-Languages](../001-Languages/) | Drivers, ORMs, lenguajes de consulta específicos |
| [002-Frameworks](../002-Frameworks/) | ORMs como capa de abstracción entre app y DB |
| [005-Cloud](../005-Cloud/) | DBaaS (RDS, Cloud SQL, DynamoDB, Aurora, Spanner) |
| [006-Containers](../006-Containers/) | Contenedores para desarrollo local (Docker compose con DB) |
| [007-Orchestration](../007-Orchestration/) | StatefulSets en K8s para bases de datos distribuidas |
| [008-Networking](../008-Networking/) | Conexiones, timeouts, pool de conexiones, SSL/TLS |
| [009-Security](../009-Security/) | Cifrado en reposo y tránsito, RBAC, SQL injection |
| [010-Architecture](../010-Architecture/) | Patrones de persistencia, CQRS, Event Sourcing, saga |
| [024-Fintech](../024-Fintech/) | Transacciones financieras, consistencia, ledger |
| [032-MachineLearning](../032-MachineLearning/) | Feature stores (Feast, Tecton), ML pipelines |
| [038-VectorDatabases](../038-VectorDatabases/) | Bases de datos vectoriales para embeddings |

## Recursos recomendados

- **Libros**: "Designing Data-Intensive Applications" (Kleppmann), "Database Internals" (Petrov), "High Performance MySQL" (Schwartz), "SQL Antipatterns" (Karwin), "Readings in Database Systems" (Stonebraker).
- **Cursos**: Stanford CS145 (Intro to Databases), CMU 15-445 (Database Systems - Andy Pavlo), MIT 6.830, Coursera "Databases" (Stanford).
- **Bases de datos para aprender**: PostgreSQL (mejor para aprender conceptos), SQLite (simplicidad), DuckDB (analítica local), Redis (cache), MongoDB (NoSQL).
- **Herramientas**: pgAdmin, TablePlus, DBeaver, DataGrip, EXPLAIN.depse.net, PgHero (performance), pgBadger (log analysis).
- **Papers**: "A Relational Model of Data for Large Shared Data Banks" (Codd), "Dynamo: Amazon's Highly Available Key-value Store", "Bigtable: A Distributed Storage System for Structured Data", "Spanner: Google's Globally-Distributed Database".

## Notas adicionales

PostgreSQL es ampliamente considerada la base de datos más avanzada y completa para aprender conceptos de bases de datos, ya que implementa virtualmente todas las características SQL, tiene extensiones poderosas (PostGIS para geoespacial, pgvector para vectores, TimescaleDB para series temporales) y su optimizador de consultas es uno de los más sofisticados. Se recomienda aprender SQL estándar primero antes de especializarse en NoSQL.
