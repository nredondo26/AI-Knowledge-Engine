# gRPC — Remote Procedure Call de Alto Rendimiento

## Descripción General

gRPC (Google) es un framework RPC basado en **HTTP/2** y **Protocol Buffers**. Serialización binaria, streaming bidireccional, multiplexación y generación automática de código. Ideal para microservicios.

---

## Ventajas

- **Rendimiento**: Protobuf hasta 10× más rápido que JSON.
- **HTTP/2**: Multiplexación, server push, compresión de headers.
- **Streaming**: Unary, server, client, bidirectional.
- **Generación de código**: Clientes/servidores desde `.proto`.
- **Contratos fuertes**: Lenguaje-agnóstico vía `.proto`.
- **Deadlines/Timeouts**: Cancelación y propagación de contexto.

---

## Protocol Buffers (.proto)

```protobuf
syntax = "proto3";
package usuarios;

service UsuarioService {
  rpc ObtenerUsuario (ObtenerUsuarioRequest) returns (Usuario);
  rpc ListarUsuarios (ListarUsuariosRequest) returns (ListarUsuariosResponse);
  rpc ListarUsuariosStream (ListarUsuariosRequest) returns (stream Usuario);
  rpc CrearUsuariosLote (stream CrearUsuarioRequest) returns (CrearUsuariosLoteResponse);
  rpc ChatUsuario (stream MensajeRequest) returns (stream MensajeResponse);
}

message Usuario { int32 id = 1; string nombre = 2; string email = 3; bool activo = 4; }
message ObtenerUsuarioRequest { int32 id = 1; }
message ListarUsuariosRequest { int32 page = 1; int32 limit = 2; optional bool activo = 3; }
message ListarUsuariosResponse { repeated Usuario usuarios = 1; int32 total = 2; int32 pagina_actual = 3; int32 total_paginas = 4; }
message CrearUsuarioRequest { string nombre = 1; string email = 2; }
message CrearUsuariosLoteResponse { int32 creados = 1; repeated Usuario usuarios = 2; }
message MensajeRequest { string usuario_id = 1; string contenido = 2; }
message MensajeResponse { string usuario_id = 1; string contenido = 2; int64 timestamp = 3; }
```

---

## Servidor (Node.js)

```javascript
import grpc from '@grpc/grpc-js';
import protoLoader from '@grpc/proto-loader';

const pkg = grpc.loadPackageDefinition(protoLoader.loadSync('usuarios.proto')).usuarios;

let usuarios = [{ id: 1, nombre: 'Ana López', email: 'ana@e.com', activo: true }];
let nextId = 2;
const server = new grpc.Server();

server.addService(pkg.UsuarioService.service, {
  ObtenerUsuario: (call, cb) => { const u = usuarios.find(u => u.id === call.request.id); if (!u) return cb({ code: grpc.status.NOT_FOUND }); cb(null, u); },
  ListarUsuarios: (call, cb) => { cb(null, { usuarios, total: usuarios.length, pagina_actual: 1, total_paginas: 1 }); },
  ListarUsuariosStream: (call) => { usuarios.forEach(u => call.write(u)); call.end(); },
  CrearUsuariosLote: (call, cb) => { const n = []; call.on('data', r => { const u = { id: nextId++, nombre: r.nombre, email: r.email, activo: true }; usuarios.push(u); n.push(u); }); call.on('end', () => cb(null, { creados: n.length, usuarios: n })); },
  ChatUsuario: (call) => { call.on('data', m => call.write({ usuario_id: m.usuario_id, contenido: `Echo: ${m.contenido}`, timestamp: Date.now() })); call.on('end', () => call.end()); },
});

server.bindAsync('0.0.0.0:50051', grpc.ServerCredentials.createInsecure(), (err, p) => { if (err) throw err; console.log(`gRPC en :${p}`); server.start(); });
```

---

## Cliente (Node.js)

```javascript
const client = new pkg.UsuarioService('localhost:50051', grpc.credentials.createInsecure());

// Unary
client.ObtenerUsuario({ id: 1 }, (err, r) => console.log(r));

// Server streaming
const s = client.ListarUsuariosStream({}); s.on('data', u => console.log(u.nombre)); s.on('end', () => {});

// Client streaming
const c = client.CrearUsuariosLote((e, r) => console.log(`Creados ${r.creados}`));
c.write({ nombre: 'Carlos', email: 'c@e.com' }); c.write({ nombre: 'María', email: 'm@e.com' }); c.end();

// Bidirectional
const ch = client.ChatUsuario(); ch.write({ usuario_id: '1', contenido: 'Hola!' }); ch.on('data', m => console.log(m));
```

---

## Interceptores

```javascript
function loggingInterceptor(opts, nextCall) {
  return (method, message, metadata, options) => {
    console.log(`Llamando a ${method.name}`);
    const call = nextCall(method, message, metadata, options);
    call.on('status', s => console.log(`${method.name} → ${s.code}`));
    return call;
  };
}
```

---

## Códigos de Estado

| Código | Nombre | Significado |
|--------|--------|-------------|
| 0 | OK | Éxito |
| 1 | CANCELLED | Cancelado |
| 3 | INVALID_ARGUMENT | Argumento inválido |
| 4 | DEADLINE_EXCEEDED | Timeout |
| 5 | NOT_FOUND | No encontrado |
| 6 | ALREADY_EXISTS | Duplicado |
| 13 | INTERNAL | Error interno |
| 14 | UNAVAILABLE | No disponible |

---

## Deadline

```javascript
client.ObtenerUsuario({ id: 1 }, { deadline: Date.now() + 5000 }, callback);
```

---

## gRPC-Web

Requiere proxy Envoy para traducir HTTP/1.1 → HTTP/2:

```javascript
const client = new GrpcWebClientImpl('http://localhost:8080');
const req = new ObtenerUsuarioRequest(); req.setId(1);
client.obtenerUsuario(req, {}, (err, r) => console.log(r.getNombre()));
```

---

## gRPC vs REST vs GraphQL

| Característica | gRPC | REST | GraphQL |
|----------------|------|------|---------|
| Protocolo | HTTP/2 | HTTP/1.1/2 | HTTP/1.1/2 |
| Serialización | Protobuf binario | JSON/XML | JSON |
| Streaming | Nativo (4 modos) | Limitado | Subscripciones WS |
| Rendimiento | Muy alto | Medio | Medio |
| Browser | gRPC-Web + proxy | Nativo | Nativo |

---

## Referencias

- [gRPC Documentation](https://grpc.io/docs)
- [Protocol Buffers](https://protobuf.dev)
