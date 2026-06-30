# Firestore

## Modelado

Firestore es una base NoSQL documental en tiempo real de Google Cloud. El modelado se basa en **colecciones**, **documentos** y **subcolecciones**. Optimizar para el número de lecturas, no para evitar duplicación.

### Estructura

```
/users/{userId}
  ├── username, email, displayName
  ├── stats: { articles, followers }
  └── /articles/{articleId}
       ├── title, slug, body, tags
       ├── viewCount, status
       └── /comments/{commentId}
            ├── userId, userName, text

/articles/{articleId}          ← colección raíz (búsqueda global)
  ├── authorId, authorName     ← denormalizado
  ├── title, body, tags, status
```

### Patrones clave

```javascript
// 1. Contadores atómicos (evitar COUNT())
db.doc("articles/art001").update({
  viewCount: FieldValue.increment(1)
});

// 2. Sharded counters para alta concurrencia
const shard = Math.floor(Math.random() * 10);
db.doc(`counters/articles/views/shard_${shard}`)
  .update({ count: FieldValue.increment(1) });

// 3. Denormalización controlada (actualizar en cascada)
async function updateUsername(uid, newUsername) {
  const articles = await db.collection("articles")
    .where("authorId", "==", uid).get();
  const batch = db.batch();
  articles.forEach(doc => batch.update(doc.ref, { authorName: newUsername }));
  await batch.commit();
}
```

## Consultas

### Lecturas y filtros

```javascript
const { Timestamp, FieldValue } = require("@google-cloud/firestore");
const db = new Firestore({ projectId: "knowledge-engine" });

// Filtros compuestos
const snapshot = await db.collection("articles")
  .where("status", "==", "published")
  .where("tags", "array-contains", "firestore")
  .orderBy("publishedAt", "desc")
  .limit(20)
  .get();

// Paginación cursor
let lastDoc;
async function getPage(pageSize) {
  let query = db.collection("articles")
    .orderBy("createdAt", "desc").limit(pageSize);
  if (lastDoc) query = query.startAfter(lastDoc);
  const snap = await query.get();
  lastDoc = snap.docs[snap.docs.length - 1];
  return snap.docs.map(d => ({ id: d.id, ...d.data() }));
}
```

### Tiempo real (onSnapshot)

```javascript
const unsubscribe = db.collection("articles")
  .where("status", "==", "published")
  .orderBy("publishedAt", "desc")
  .limit(10)
  .onSnapshot((snapshot) => {
    snapshot.docChanges().forEach(change => {
      if (change.type === "added")
        console.log("Nuevo:", change.doc.data().title);
    });
  });
```

### Transacciones y batches

```javascript
// Transacción atómica
await db.runTransaction(async (t) => {
  const artRef = db.doc("articles/art001");
  const userRef = db.doc("users/user01");
  const art = await t.get(artRef);
  if (!art.exists) throw new Error("Not found");
  t.update(artRef, { viewCount: FieldValue.increment(1) });
  t.update(userRef, { "stats.articles": FieldValue.increment(1) });
});

// Batch write (500 ops máximo)
const batch = db.batch();
for (let i = 0; i < 100; i++) {
  batch.set(db.collection("articles").doc(), { title: `Article ${i}` });
}
await batch.commit();
```

## Índices

```json
// firestore.indexes.json
{
  "indexes": [
    {
      "collectionGroup": "articles",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "publishedAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "articles",
      "fields": [
        { "fieldPath": "tags", "arrayConfig": "CONTAINS" },
        { "fieldPath": "publishedAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

## Reglas de seguridad

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    match /articles/{articleId} {
      allow read: if resource.data.status == 'published'
                  || request.auth.uid == resource.data.authorId;
      allow write: if request.auth.uid == resource.data.authorId;
      allow create: if request.resource.data.title is string;
    }
  }
}
```

## Conexión desde aplicación

```python
from google.cloud import firestore
from google.cloud.firestore_v1 import Increment

db = firestore.AsyncClient(project="knowledge-engine")

async def publish_article(data: dict, user_id: str):
    batch = db.batch()
    user_art_ref = db.collection("users").document(user_id) \
        .collection("articles").document()
    batch.set(user_art_ref, data)

    global_ref = db.collection("articles").document(user_art_ref.id)
    batch.set(global_ref, {**data, "authorId": user_id})

    batch.update(db.collection("users").document(user_id),
                 {"stats.articles": Increment(1)})
    await batch.commit()
    return user_art_ref.id
```

## Monitoreo

```bash
# Estadísticas de Firebase Console
gcloud firestore operations list --database=production

# Índices compuestos
gcloud firestore indexes composite list --database=production

# Métricas de lectura/escritura
gcloud monitoring metrics list \
  --filter="metric.type=firestore.googleapis.com/document/read_count"
```
