# GraphQL — Lenguaje de Consulta para APIs

## Descripción General

GraphQL (Meta/Facebook, 2015) es un lenguaje de consulta y runtime del lado del servidor. El cliente especifica exactamente los datos que necesita, y recibe solo eso. Un solo endpoint para todas las operaciones.

---

## Principios

1. **Declarativo**: El cliente define la forma de la respuesta.
2. **Jerárquico**: Las consultas reflejan el grafo de datos.
3. **Fuertemente tipado**: Schema define tipos y validaciones.
4. **Introspección**: Schema autodocumentado.
5. **Un solo endpoint**: `POST /graphql`.

---

## Schema Definition Language (SDL)

```graphql
type Usuario { id: ID!, nombre: String!, email: String!, activo: Boolean!, pedidos: [Pedido!]! }
type Pedido { id: ID!, total: Float!, items: [ItemPedido!]!, fecha: DateTime! }

input UsuarioInput { nombre: String!, email: String! }

type Query { usuarios(activo: Boolean, page: Int, limit: Int): [Usuario!]! usuario(id: ID!): Usuario }
type Mutation { crearUsuario(input: UsuarioInput!): Usuario! actualizarUsuario(id: ID!, input: UsuarioInput!): Usuario! eliminarUsuario(id: ID!): Boolean! }
type Subscription { usuarioCreado: Usuario! }
```

---

## Consultas

```graphql
query ObtenerUsuario($id: ID!, $incluirPedidos: Boolean!) {
  usuario(id: $id) {
    nombre, email
    pedidos @include(if: $incluirPedidos) { id, total }
  }
}

fragment CamposUsuario on Usuario { id, nombre, email }
query { activos: usuarios(activo: true) { ...CamposUsuario } }
```

---

## Mutaciones

```graphql
mutation CrearUsuario($input: UsuarioInput!) {
  crearUsuario(input: $input) { id, nombre, email, fechaRegistro }
}
# Variables: { "input": { "nombre": "Carlos Ruiz", "email": "carlos@ejemplo.com" } }
```

---

## Resolvers (Apollo Server)

```javascript
import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';
import { v4 as uuid } from 'uuid';

const typeDefs = `#graphql
  type Usuario { id: ID!, nombre: String!, email: String!, activo: Boolean! }
  type Query { usuarios: [Usuario!]!, usuario(id: ID!): Usuario }
  type Mutation { crearUsuario(nombre: String!, email: String!): Usuario! }
`;

let usuarios = [{ id: '1', nombre: 'Ana López', email: 'ana@e.com', activo: true }];

const resolvers = {
  Query: { usuarios: () => usuarios, usuario: (_, { id }) => usuarios.find(u => u.id === id) },
  Mutation: { crearUsuario: (_, { nombre, email }) => { const n = { id: uuid(), nombre, email, activo: true }; usuarios.push(n); return n; } },
};

const server = new ApolloServer({ typeDefs, resolvers });
const { url } = await startStandaloneServer(server, { listen: { port: 4000 } });
console.log(`🚀 GraphQL en ${url}`);
```

---

## DataLoader — Resolver N+1

```javascript
import DataLoader from 'dataloader';

const usuarioLoader = new DataLoader(async (ids) => {
  const usuarios = await db.query('SELECT * FROM usuarios WHERE id IN (?)', [ids]);
  return ids.map(id => usuarios.find(u => u.id === id));
});

// En resolver: usuario: (pedido) => usuarioLoader.load(pedido.usuarioId)
```

---

## Suscripciones (WebSockets)

```javascript
import { PubSub } from 'graphql-subscriptions';
const pubsub = new PubSub();

const resolvers = {
  Subscription: { usuarioCreado: { subscribe: () => pubsub.asyncIterator(['USUARIO_CREADO']) } },
  Mutation: { crearUsuario: async (_, args) => { const u = { id: uuid(), ...args }; pubsub.publish('USUARIO_CREADO', { usuarioCreado: u }); return u; } },
};
```

```graphql
subscription { usuarioCreado { id, nombre, email } }
```

---

## Directiva de Autenticación

```javascript
function authDirective(schema) {
  return mapSchema(schema, { [MapperKind.OBJECT_FIELD]: (config) => {
    const directive = getDirective(schema, config, 'auth')?.[0];
    if (directive) { const { resolve } = config; config.resolve = async (s, a, ctx, i) => { if (!ctx.user) throw new Error('No autenticado'); return resolve(s, a, ctx, i); }; }
    return config;
  }});
}
```

---

## Seguridad

```javascript
const server = new ApolloServer({
  validationRules: [
    createComplexityLimitRule(1000),
    depthLimit(5),
  ],
  introspection: process.env.NODE_ENV !== 'production',
});
```

---

## Buenas Prácticas

Persisted queries para reducir payload. Cost analysis anti-abuse. Cursor-based pagination (Relay). Deshabilitar introspection en producción. Fragmentar consultas grandes.

---

## Referencias

- [GraphQL Specification](https://spec.graphql.org)
- [Apollo Server Docs](https://www.apollographql.com/docs/apollo-server)
- [GraphQL Code Generator](https://the-guild.dev/graphql/codegen)
