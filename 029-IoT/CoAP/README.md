# CoAP — Constrained Application Protocol

## Descripción del dominio

CoAP (Constrained Application Protocol) es un protocolo de aplicación diseñado para dispositivos IoT con recursos limitados (baja potencia, poca memoria, baja velocidad de red). Está definido en RFC 7252 y sigue el modelo REST (GET, POST, PUT, DELETE) similar a HTTP, pero optimizado para redes de baja potencia y con pérdidas (como 802.15.4, LoWPAN o LPWAN). CoAP utiliza UDP como transporte base (con soporte opcional de DTLS para seguridad), tiene sobrecarga mínima (4 bytes de cabecera), soporta multicast, observación de recursos (pub/sub) y descubrimiento de servicios.

## Áreas clave

- **Modelo REST**: Endpoints identificados por URI (coap://host/resource). Métodos: GET (lectura), POST (creación), PUT (actualización), DELETE (borrado). Códigos de respuesta análogos a HTTP (2.05 Content, 4.00 Bad Request, 5.00 Internal Server Error)
- **Mensajes CoAP**: cuatro tipos: CON (confirmable), NON (non-confirmable), ACK (acknowledgement), RST (reset). Retransmisión con backoff exponencial para CON
- **Observación (Observe)**: Suscripción a cambios en un recurso (RFC 7641). El servidor notifica al cliente cuando el recurso cambia. Similar a pub/sub con notificaciones periódicas
- **Descubrimiento**: Recurso `/.well-known/core` lista los recursos disponibles con atributos (rt=resource type, if=interface, ct=content-type)
- **Block-wise transfer**: Transferencia de payloads grandes mediante bloques (Block1/Block2 options), definido en RFC 7959. Esencial para actualizaciones OTA
- **Seguridad (DTLS)**: CoAP sobre DTLS (CoAPs). Modos: NoSec (sin seguridad), PreSharedKey (PSK), RawPublicKey (RPK), Certificate (X.509). CoAP también soporta OSCORE (Object Security for CoAP, RFC 8613)
- **Proxy y caching**: Cross-proxy entre CoAP y HTTP (RFC 8075). Caching con freshness y max-age. Observación de recursos en caché
- **CoAP over TCP**: Extensión (RFC 8323) para transporte sobre TCP, WebSockets y TLS. Útil cuando UDP no está disponible

## Ejemplo: Servidor CoAP con libcoap (C)

```c
#include <coap3/coap.h>

static void hola_handler(coap_resource_t *resource,
                         coap_session_t *session,
                         const coap_pdu_t *request,
                         const coap_string_t *query,
                         coap_pdu_t *response) {
    coap_add_data_blocked_response(resource, session, request, response,
                                   query,
                                   COAP_MEDIATYPE_TEXT_PLAIN, 0,
                                   (const uint8_t*)"Hola CoAP!", 10);
}

int main() {
    coap_context_t *ctx = coap_new_context(NULL);
    coap_address_t addr;
    coap_resolve_address("0.0.0.0", "5683", &addr);
    coap_session_t *session = coap_new_server_session(ctx, NULL,
        COAP_PROTO_UDP, &addr, NULL);

    coap_resource_t *res = coap_resource_init(
        coap_make_str_const("hola"), 0);
    coap_register_handler(res, COAP_REQUEST_GET, hola_handler);
    coap_add_resource(ctx, res);

    while (1) { coap_io_process(ctx, COAP_IO_WAIT); }
    coap_free_context(ctx);
    return 0;
}
```

## Ejemplo: Cliente CoAP con aiocoap (Python)

```python
import asyncio
from aiocoap import *

async def main():
    protocol = await Context.create_client_context()
    request = Message(code=GET, uri="coap://localhost/hola")
    response = await protocol.request(request).response
    print(f"Código: {response.code}, Payload: {response.payload}")

asyncio.run(main())
```

## Tecnologías principales

| Implementación | Lenguaje | Características |
|---------------|----------|-----------------|
| libcoap | C | Madura, completa, soporta CoAP/DTLS/OSCORE/TCP |
| CoAPthon | Python | Ligera, educativa, soporta Observe |
| aiocoap | Python | Asíncrona (asyncio), completa, DTLS |
| Californium (Cf) | Java | Alto rendimiento, escalable, pluggable |
| microcoap | C | Mínima, para MCUs muy limitados |
| CoAP.NET | C# | .NET Standard, multiplataforma |
| CoAP.js | JS | Node.js, simple |

## CoAP vs HTTP

| Característica | CoAP | HTTP |
|---------------|------|------|
| Transporte | UDP (principal), TCP opcional | TCP |
| Cabecera | 4 bytes | ~100+ bytes |
| Overhead | Mínimo | Alto |
| Confiabilidad | CON/ACK opcional | TCP inherente |
| Multicast | Sí | No |
| Observación | Sí (Observe) | Long polling, SSE, WebSocket |
| Descubrimiento | /.well-known/core | Enlaces, registro |
| Seguridad | DTLS, OSCORE | TLS |
| Ideal para | MCUs limitados, LPWAN, sensores | Servidores, browsers, APIs |

## Buenas prácticas

- Usar NON (no confirmable) para lecturas frecuentes no críticas; CON para comandos importantes
- Implementar Observe para lecturas periódicas en lugar de polling
- Usar Block-wise transfer para payloads > 64 bytes (OTA, logs grandes)
- Configurar DTLS con PSK para dispositivos sin capacidad de PKI
- Implementar descubrimiento en /.well-known/core para interoperabilidad
- Usar proxy CoAP↔HTTP para integración con APIs REST tradicionales
- Mantener URIs cortas para minimizar tamaño de paquetes
- Usar Content-Format (application/cbor, application/json, text/plain) adecuado al tamaño
