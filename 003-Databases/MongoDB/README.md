# MongoDB

## Modelado

MongoDB es una base NoSQL documental. El modelado se centra en documentos embebidos vs referencias, patrones de acceso y esquemas flexibles.

### Principios de diseño

```javascript
// Documento embebido (lectura: 1 consulta en vez de N joins)
const user = {
  _id: ObjectId("..."),
  username: "jdoe",
  email: "j@example.com",
  profile: {
    display_name: "John",
    avatar_url: "/avatars/jdoe.png",
    bio: "Engineer"
  },
  addresses: [
    { type: "home", street: "123 Main", city: "NYC", zip: "10001" }
  ],
  created_at: new Date("2025-01-01")
};

// Referencia (cuando el subdocumento crece sin límite)
const post = {
  _id: ObjectId("..."),
  author_id: ObjectId("..."),
  title: "MongoDB Modeling",
  tags: ["database", "nosql"],
  comments_count: 0  // denormalizado para evitar COUNT()
};
```

### Patrón de diseño de series temporales

```javascript
// Bucket pattern: agrupar lecturas por hora
{
  sensor_id: "sensor_01",
  date: ISODate("2025-06-01T00:00:00Z"),
  readings: [
    { t: ISODate("2025-06-01T00:00:05Z"), v: 22.5 },
    { t: ISODate("2025-06-01T00:00:10Z"), v: 22.7 }
  ],
  count: 120,
  avg: 22.6
}
```

## Consultas

### Operaciones CRUD y agregación

```javascript
// Búsqueda con proyección y ordenamiento
db.users.find(
  { status: "active", "profile.bio": { $exists: true } },
  { username: 1, email: 1, "profile.display_name": 1 }
).sort({ created_at: -1 }).limit(20);

// Pipeline de agregación
db.posts.aggregate([
  { $match: { created_at: { $gte: ISODate("2025-01-01") } } },
  { $lookup: {
      from: "users",
      localField: "author_id",
      foreignField: "_id",
      as: "author"
  }},
  { $unwind: "$author" },
  { $group: {
      _id: "$author.username",
      total_posts: { $sum: 1 },
      avg_views: { $avg: "$view_count" }
  }},
  { $sort: { total_posts: -1 } }
]);

// Text search
db.posts.createIndex({ title: "text", body: "text" });
db.posts.find(
  { $text: { $search: "inteligencia artificial", $language: "spanish" } },
  { score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" } });
```

### Updates atómicos

```javascript
db.posts.updateOne(
  { _id: ObjectId("...") },
  {
    $inc: { view_count: 1 },
    $set: { last_viewed: new Date() },
    $addToSet: { tags: "popular" }
  }
);
```

## Índices

```javascript
// Índice compuesto (cubre consultas de ordenamiento)
db.posts.createIndex({ author_id: 1, created_at: -1, view_count: -1 });

// Índice TTL (expira documentos automáticamente)
db.logs.createIndex({ created_at: 1 }, { expireAfterSeconds: 604800 });

// Índice parcial (solo documentos activos)
db.posts.createIndex(
  { user_id: 1, created_at: -1 },
  { partialFilterExpression: { status: "published" } }
);

// Índice hash (sharding)
db.users.createIndex({ email: "hashed" });

// Índice geoespacial
db.places.createIndex({ location: "2dsphere" });

// Índice wildcard (campos dinámicos)
db.products.createIndex({ "attributes.$**": 1 });
```

## Configuración

### YAML de mongod.conf

```yaml
storage:
  dbPath: /data/db
  wiredTiger:
    engineConfig:
      cacheSizeGB: 4  # 50% RAM
      journalCompressor: snappy
    collectionConfig:
      blockCompressor: zstd
replication:
  replSetName: rs0
  oplogSizeMB: 10240
net:
  bindIp: 0.0.0.0
  port: 27017
  compression:
    compressors: snappy,zstd
setParameter:
  enableLocalhostAuthBypass: false
  failIndexKeyTooLong: false
operationProfiling:
  mode: slowOp
  slowOpThresholdMs: 100
```

## Conexión desde aplicación

```python
from motor.motor_asyncio import AsyncIOMotorClient

client = AsyncIOMotorClient(
    "mongodb://user:pass@localhost:27017/knowledge?replicaSet=rs0&retryWrites=true&w=majority",
    maxPoolSize=50,
    connectTimeoutMS=5000
)
db = client.knowledge

async def get_feed(user_id: str, page: int = 1):
    pipeline = [
        { "$match": { "author_id": ObjectId(user_id) } },
        { "$sort": { "created_at": -1 } },
        { "$skip": (page - 1) * 20 },
        { "$limit": 20 }
    ]
    cursor = db.posts.aggregate(pipeline)
    return await cursor.to_list(length=20)
```

## Monitoreo

```javascript
// Estadísticas del servidor
db.serverStatus().wiredTiger.cache;
db.serverStatus().connections;

// Operaciones lentas profileadas
db.system.profile.find({
  op: { $in: ["query", "command"] },
  millis: { $gt: 500 }
}).sort({ ts: -1 }).limit(10);

// Tamaño de colecciones
db.posts.totalSize();
db.posts.stats().indexSizes;
```
