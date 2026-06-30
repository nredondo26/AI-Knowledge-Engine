# WebRTC — Comunicación en Tiempo Real entre Pares

## Descripción General

WebRTC (Web Real-Time Communication) es un estándar abierto para comunicación en tiempo real entre navegadores y dispositivos: video, audio y datos. Opera mediante conexiones peer-to-peer (P2P) usando protocolos como ICE, STUN y TURN.

---

## Arquitectura

- **MediaStream**: Captura de audio/video local (getUserMedia).
- **RTCPeerConnection**: Conexión P2P entre peers.
- **RTCDataChannel**: Canal de datos bidireccional (texto, binario).
- **ICE (Interactive Connectivity Establishment)**: Descubrimiento de rutas de red.
- **STUN**: Servidor que revela IP pública del peer.
- **TURN**: Relay de medios cuando P2P no es posible (NAT simétrica).

---

## Captura de Medios Local

```javascript
async function iniciarCamara() {
    try {
        const stream = await navigator.mediaDevices.getUserMedia({
            video: { width: 1280, height: 720 },
            audio: true
        });
        document.getElementById('video-local').srcObject = stream;
        return stream;
    } catch (err) {
        console.error('Error al acceder a cámara:', err);
    }
}

// Compartir pantalla
async function compartirPantalla() {
    const stream = await navigator.mediaDevices.getDisplayMedia({
        video: { mediaSource: 'screen' }
    });
    return stream;
}
```

---

## Señalización (Signaling)

WebRTC necesita un canal externo para intercambiar metadatos antes de establecer la conexión P2P (típicamente WebSocket):

```javascript
// Cliente de señalización
class SignalingClient {
    constructor(url) {
        this.ws = new WebSocket(url);
        this.ws.onmessage = (event) => {
            const msg = JSON.parse(event.data);
            this.onMessage?.(msg);
        };
    }

    sendOffer(offer) {
        this.ws.send(JSON.stringify({ type: 'offer', sdp: offer.sdp }));
    }

    sendAnswer(answer) {
        this.ws.send(JSON.stringify({ type: 'answer', sdp: answer.sdp }));
    }

    sendIceCandidate(candidate) {
        this.ws.send(JSON.stringify({ type: 'ice-candidate', candidate }));
    }
}
```

---

## Establecer Conexión (Oferta/Respuesta)

```javascript
const config = {
    iceServers: [
        { urls: 'stun:stun.l.google.com:19302' },
        { urls: 'turn:turn.ejemplo.com:3478', username: 'user', credential: 'pass' }
    ]
};

async function crearOferta(localStream, signaling) {
    const pc = new RTCPeerConnection(config);

    localStream.getTracks().forEach(track => {
        pc.addTrack(track, localStream);
    });

    pc.onicecandidate = (event) => {
        if (event.candidate) {
            signaling.sendIceCandidate(event.candidate);
        }
    };

    pc.ontrack = (event) => {
        document.getElementById('video-remoto').srcObject = event.streams[0];
    };

    const offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    signaling.sendOffer(offer);

    signaling.onMessage = async (msg) => {
        if (msg.type === 'answer') {
            await pc.setRemoteDescription(new RTCSessionDescription(msg));
        } else if (msg.type === 'ice-candidate') {
            await pc.addIceCandidate(new RTCIceCandidate(msg.candidate));
        }
    };

    return pc;
}

async function recibirOferta(offer, localStream, signaling) {
    const pc = new RTCPeerConnection(config);

    localStream.getTracks().forEach(track => pc.addTrack(track, localStream));

    pc.onicecandidate = (event) => {
        if (event.candidate) signaling.sendIceCandidate(event.candidate);
    };

    pc.ontrack = (event) => {
        document.getElementById('video-remoto').srcObject = event.streams[0];
    };

    await pc.setRemoteDescription(new RTCSessionDescription(offer));
    const answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);
    signaling.sendAnswer(answer);

    signaling.onMessage = async (msg) => {
        if (msg.type === 'ice-candidate') {
            await pc.addIceCandidate(new RTCIceCandidate(msg.candidate));
        }
    };

    return pc;
}
```

---

## DataChannel (Chat P2P)

```javascript
async function crearDataChannel(pc) {
    const channel = pc.createDataChannel('chat', {
        ordered: true,
        maxRetransmits: 3
    });

    channel.onopen = () => console.log('DataChannel abierto');
    channel.onclose = () => console.log('DataChannel cerrado');

    channel.onmessage = (event) => {
        mostrarMensaje(event.data);
    };

    return channel;
}

function enviarMensaje(channel, mensaje) {
    if (channel?.readyState === 'open') {
        channel.send(mensaje);
    }
}

// Recibir DataChannel del peer remoto
pc.ondatachannel = (event) => {
    const channel = event.channel;
    channel.onmessage = (e) => mostrarMensaje(e.data);
};
```

---

## Servidor TURN con Coturn

```bash
# Instalar coturn
apt-get install coturn

# Configuración básica /etc/turnserver.conf
listening-device=eth0
listening-port=3478
tls-listening-port=5349
realm=ejemplo.com
user=usuario:contraseña
total-quota=100
lt-cred-mech
```

---

## Restricciones de Ancho de Banda

```javascript
const sender = pc.getSenders().find(s => s.track.kind === 'video');
const parameters = sender.getParameters();
parameters.encodings[0].maxBitrate = 500000; // 500 kbps
parameters.encodings[0].maxFramerate = 30;
sender.setParameters(parameters);
```

---

## Codecs Soportados

```javascript
// Verificar codecs disponibles
RTCRtpSender.getCapabilities('video').codecs.forEach(codec => {
    console.log(codec.mimeType);
});
// H264, VP8, VP9, AV1 (según navegador)
```

---

## Pruebas

```javascript
// En Node.js con wrtc (polyfill)
const nodeDataChannel = require('node-datachannel');

const pc = new nodeDataChannel.PeerConnection('0.0.0.0');
const dc = pc.createDataChannel('test');
dc.onOpen(() => dc.sendMessage('Hola desde Node!'));
```

---

## Mejores Prácticas

1. **STUN público como fallback** y TURN propio para producción.
2. **Simulcast**: Enviar múltiples resoluciones para adaptarse al receptor.
3. **Reconexión**: Reiniciar ICE on connection loss.
4. **Codec prioritario**: VP9/AV1 para mejor calidad, H264 para compatibilidad.
5. **Estadísticas**: `pc.getStats()` para monitorear calidad.

---

## Referencias

- [WebRTC MDN](https://developer.mozilla.org/es/docs/Web/API/WebRTC_API)
- [WebRTC Spec (W3C)](https://www.w3.org/TR/webrtc)
- [Google STUN](https://developers.google.com/talk/openfire)
- [Coturn TURN Server](https://github.com/coturn/coturn)
