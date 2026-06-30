# Neo4j

## Modelado

Neo4j es una base de datos orientada a grafos (property graph). Almacena nodos (entidades), relaciones (aristas) y propiedades. Ideal para redes sociales, fraude, recomendaciones y grafos de conocimiento.

```cypher
CREATE (john:User {id: 'u1', name: 'John Doe', email: 'john@example.com'})
CREATE (post:Post {id: 'p1', title: 'Introducción a Neo4j', created_at: datetime()})
CREATE (john)-[:AUTHORED]->(post)
CREATE (john)-[:FOLLOWS]->(anna:User {name: 'Anna Smith'})
CREATE (anna)-[:LIKES {score: 5}]->(post);

-- Constraints e índices
CREATE CONSTRAINT unique_user_id FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE INDEX idx_user_name FOR (u:User) ON (u.name);
CREATE FULLTEXT INDEX ft_posts FOR (n:Post) ON EACH [n.title, n.body];
```

## Consultas

```cypher
-- Amigos de amigos (2 niveles)
MATCH (u:User {id: 'u1'})-[:FOLLOWS]->(f:User)-[:FOLLOWS]->(fof:User)
WHERE NOT (u)-[:FOLLOWS]->(fof)
RETURN fof.name LIMIT 20;

-- Recomendación basada en gustos similares
MATCH (u:User {id: 'u1'})-[:LIKES]->(p:Post)<-[:LIKES]-(other:User)
MATCH (other)-[:LIKES]->(rec:Post) WHERE NOT (u)-[:LIKES]->(rec)
RETURN rec.title, COUNT(other) AS common_likers ORDER BY common_likers DESC;

-- Path más corto
MATCH p = shortestPath((:User {id: 'u1'})-[:FOLLOWS*]-(:User {id: 'u50'}))
RETURN [n IN nodes(p) | n.name] AS path, length(p) AS depth;

-- Búsqueda textual
CALL db.index.fulltext.queryNodes('ft_posts', 'inteligencia artificial')
YIELD node, score RETURN node.title, score ORDER BY score DESC;
```

## Configuración (neo4j.conf)

```ini
server.memory.heap.initial_size = 4G
server.memory.heap.max_size = 8G
server.memory.pagecache.size = 4G
dbms.connector.bolt.listen_address=0.0.0.0:7687
dbms.connector.http.listen_address=0.0.0.0:7474
dbms.security.procedures.unrestricted=apoc.*
```

## Conexión desde aplicación

```python
from neo4j import AsyncGraphDatabase

driver = AsyncGraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "password"))

async with driver.session(database="knowledge") as session:
    result = await session.run("""
        MERGE (p:Post {slug: $slug}) SET p.title = $title
        WITH p MATCH (u:User {id: $uid}) CREATE (u)-[:AUTHORED]->(p)
        RETURN p.id
    """, uid="u1", slug="intro", title="Introducción a Neo4j")
    row = await result.single()

await driver.close()
```

## Monitoreo

```cypher
:sysinfo
CALL dbms.listConfig();
PROFILE MATCH (u:User)-[:FOLLOWS]->(f) RETURN u.name, COUNT(f) AS followers ORDER BY followers DESC;
CALL db.schema.visualization();
```

```bash
# Revisar logs de consultas lentas
tail -f logs/query.log

# Estadísticas de heap y page cache en neo4j.log
grep "heap" logs/neo4j.log
```
