# WebSocket — Comunicación Bidireccional en Tiempo Real

## Descripción General

WebSocket (RFC 6455) es un protocolo que proporciona comunicación full-duplex sobre una única conexión TCP persistente. A diferencia de HTTP (request-response), WebSocket permite que servidor y cliente envíen mensajes en cualquier momento, ideal para chats, notificaciones, juegos y dashboards en tiempo real.

---

## Handshake HTTP → WebSocket

```
Cliente → Servidor:
GET /chat HTTP/1.1
Host: ejemplo.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13

Servidor → Cliente:
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
```

---

## Cliente WebSocket en Navegador

```javascript
const ws = new WebSocket('wss://api.ejemplo.com/ws');

ws.onopen = () => {
    console.log('Conectado');
    ws.send(JSON.stringify({ type: 'auth', token: 'abc123' }));
};

ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    console.log('Mensaje recibido:', data);
    actualizarUI(data);
};

ws.onerror = (error) => console.error('WebSocket error:', error);

ws.onclose = (event) => {
    console.log('Desconectado:', event.code, event.reason);
    if (event.code !== 1000) {
        setTimeout(reconectar, 3000);
    }
};

function reconectar() {
    // Lógica de reconexión con backoff exponencial
}

// Enviar mensajes
ws.send(JSON.stringify({ type: 'mensaje', content: '¡Hola!' }));

// Cerrar conexión
ws.close(1000, 'Cerrando normalmente');
```

---

## Servidor con Node.js (ws)

```javascript
import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 8080 });

wss.on('connection', (ws, req) => {
    console.log('Cliente conectado:', req.socket.remoteAddress);

    ws.on('message', (data) => {
        const msg = JSON.parse(data.toString());
        console.log('Recibido:', msg);

        // Broadcast a todos los clientes
        wss.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify({ from: msg.sender, text: msg.text }));
            }
        });
    });

    ws.on('close', () => console.log('Cliente desconectado'));

    // Heartbeat
    ws.isAlive = true;
    ws.on('pong', () => { ws.isAlive = true; });
});

// Ping interval
const interval = setInterval(() => {
    wss.clients.forEach((ws) => {
        if (ws.isAlive === false) return ws.terminate();
        ws.isAlive = false;
        ws.ping();
    });
}, 30000);

wss.on('close', () => clearInterval(interval));
console.log('WebSocket server en ws://localhost:8080');
```

---

## Servidor con FastAPI (Python)

```python
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from typing import List
import json

app = FastAPI()
active_connections: List[WebSocket] = []

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    active_connections.append(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            message = json.loads(data)
            # Broadcast
            for connection in active_connections:
                await connection.send_text(json.dumps({
                    "user": message["user"],
                    "message": message["text"],
                    "timestamp": __import__("time").time()
                }))
    except WebSocketDisconnect:
        active_connections.remove(websocket)
```

---

## Socket.IO (Node.js)

```bash
npm install socket.io
```

```javascript
// Servidor
import { Server } from 'socket.io';

const io = new Server(3000, {
    cors: { origin: '*' }
});

io.on('connection', (socket) => {
    console.log('Usuario conectado:', socket.id);

    socket.join('sala-general');

    socket.on('mensaje', (data) => {
        io.to(data.sala).emit('nuevo-mensaje', {
            user: data.user,
            text: data.text,
            timestamp: Date.now()
        });
    });

    socket.on('typing', (data) => {
        socket.broadcast.to(data.sala).emit('usuario-escribiendo', data.user);
    });

    socket.on('disconnect', () => {
        console.log('Usuario desconectado:', socket.id);
    });
});
```

```javascript
// Cliente
import { io } from 'socket.io-client';

const socket = io('http://localhost:3000');

socket.on('connect', () => console.log('Conectado:', socket.id));
socket.emit('mensaje', { sala: 'sala-general', user: 'Ana', text: '¡Hola!' });
socket.on('nuevo-mensaje', (msg) => console.log(msg));
```

---

## Conexiones Seguras (WSS)

```javascript
// Servidor con TLS
import { WebSocketServer } from 'ws';
import { createServer } from 'https';
import { readFileSync } from 'fs';

const server = createServer({
    cert: readFileSync('/etc/ssl/certs/cert.pem'),
    key: readFileSync('/etc/ssl/private/key.pem'),
});

const wss = new WebSocketServer({ server });
server.listen(443);
```

---

## Reconexión con Backoff

```javascript
class ReconnectingWebSocket {
    constructor(url, options = {}) {
        this.url = url;
        this.reconnectAttempts = 0;
        this.maxAttempts = options.maxAttempts || Infinity;
        this.baseDelay = options.baseDelay || 1000;
        this.maxDelay = options.maxDelay || 30000;
        this.connect();
    }

    connect() {
        this.ws = new WebSocket(this.url);
        this.ws.onopen = () => {
            this.reconnectAttempts = 0;
            this.onopen?.();
        };
        this.ws.onclose = () => {
            const delay = Math.min(
                this.baseDelay * Math.pow(2, this.reconnectAttempts),
                this.maxDelay
            );
            const jitter = delay * (0.5 + Math.random() * 0.5);
            this.reconnectAttempts++;
            setTimeout(() => this.connect(), jitter);
        };
    }

    send(data) { this.ws.send(data); }
    close() { this.ws.close(); }
}
```

---

## Pruebas

```javascript
import { WebSocket } from 'ws';

const ws = new WebSocket('ws://localhost:8080');
ws.on('open', () => {
    ws.send(JSON.stringify({ type: 'ping' }));
});
ws.on('message', (data) => {
    const msg = JSON.parse(data.toString());
    console.assert(msg.type === 'pong', 'Respuesta esperada');
    ws.close();
});
```

---

## Mejores Prácticas

1. **Heartbeat/Ping-Pong**: Detectar conexiones muertas.
2. **Reconexión**: Backoff exponencial con jitter.
3. **Autenticación**: Token en el primer mensaje o query param `?token=`.
4. **Rate limiting**: Limitar mensajes por segundo por conexión.
5. **Broadcast eficiente**: Usar rooms/salas para no enviar a todos.
6. **Cerrar limpiamente**: Enviar código 1000 al cerrar.

---

## Referencias

- [WebSocket RFC 6455](https://datatracker.ietf.org/doc/html/rfc6455)
- [MDN WebSocket API](https://developer.mozilla.org/es/docs/Web/API/WebSocket)
- [Socket.IO Docs](https://socket.io/docs/v4)
- [ws (Node.js)](https://github.com/websockets/ws)
