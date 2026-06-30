# Protocolos IoT de Comunicación

## Descripción del dominio

Los protocolos IoT definen cómo los dispositivos, gateways y plataformas cloud se comunican entre sí en el ecosistema de Internet de las Cosas. Abarcan desde protocolos de capa de aplicación (MQTT, CoAP, HTTP/2, AMQP) hasta protocolos de capa de red y enlace (LoRaWAN, NB-IoT, Zigbee, BLE, 6LoWPAN, Thread). La elección del protocolo depende de factores: ancho de banda disponible, consumo energético, alcance, latencia requerida, calidad de servicio y modelo de comunicación (pub/sub, request/response, evento). Este módulo proporciona una visión comparativa de los protocolos más relevantes.

## Áreas clave

- **MQTT (Message Queuing Telemetry Transport)**: Protocolo pub/sub ligero sobre TCP. QoS 0/1/2. Retained messages, Last Will, topics jerárquicos. Broker central (Mosquitto, EMQX, HiveMQ). Estándar en IoT industrial y consumer. RFC 2024
- **MQTT-SN**: Variante para redes WSN (Zigbee, BLE, LoRa). Sin TCP, usa UDP, menos overhead
- **CoAP (Constrained Application Protocol)**: REST sobre UDP. 4 bytes de cabecera. Observe (pub/sub), Block-wise transfer, DTLS. Ideal para MCUs limitados. RFC 7252
- **HTTP/2 y HTTP/3**: Para dispositivos con capacidad suficiente. HTTP/2 (multiplexación, server push), HTTP/3 (QUIC/UDP, menor latencia de conexión). APIs RESTful comunes
- **AMQP (Advanced Message Queuing Protocol)**: Protocolo de mensajería empresarial. Enrutamiento flexible (exchanges, queues, bindings). QoS garantizado. RabbitMQ, Azure Service Bus
- **LoRaWAN**: LPWAN para largo alcance (2-15 km) y bajo consumo. Estrella de estrellas (gateway → network server). Clases A/B/C. Regionalizado (EU868, US915, AS923)
- **NB-IoT / LTE-M**: Celulares para IoT masivo (NB-IoT, 200 kbps) y banda ancha (LTE-M, 1 Mbps). Cobertura profunda interior. SIM cards, operadores móviles
- **Zigbee / Thread**: Protocolos de malla basados en IEEE 802.15.4. Zigbee (perfiles ZCL), Thread (IPv6/6LoWPAN, base de Matter). Bajo consumo, corto alcance
- **BLE (Bluetooth Low Energy)**: Corto alcance, ultra bajo consumo. GATT, advertising, mesh. Beacon (iBeacon, Eddystone). Wearables, sensores, beacons
- **DDS (Data Distribution Service)**: Middleware descentralizado publish-subscribe para tiempo real. QoS granular (latencia, fiabilidad, durabilidad). Usado en robótica (ROS2), defensa, automoción
- **OPC UA (Open Platform Communications Unified Architecture)**: Protocolo industrial para comunicación machine-to-machine. Modelo de información, seguridad integrada, pub/sub. Estándar Industrie 4.0
- **6LoWPAN**: IPv6 sobre redes IEEE 802.15.4. Compresión de cabecera, fragmentación. Base de Thread y Zigbee IP

## Comparativa de protocolos IoT

| Protocolo | Transporte | Modelo | QoS | Consumo | Alcance | Tasa |
|-----------|-----------|--------|-----|---------|---------|------|
| MQTT | TCP | Pub/Sub | 3 niveles | Bajo | Ilimitado (IP) | Depende |
| CoAP | UDP | REST | Confirmable | Muy bajo | Ilimitado (IP) | Depende |
| LoRaWAN | LoRa | Estrella | 3 niveles | Ultra bajo | 2-15 km | 50 kbps |
| NB-IoT | LTE | Celular | — | Bajo | 1-10 km | 200 kbps |
| Zigbee | 802.15.4 | Mesh | 2 niveles | Bajo | 10-100 m | 250 kbps |
| Thread | 802.15.4 | Mesh | — | Bajo | 10-100 m | 250 kbps |
| BLE | 2.4 GHz | Estrella | 2 niveles | Ultra bajo | 10-100 m | 2 Mbps |
| DDS | UDP/TCP | Pub/Sub | 22 QoS | Medio | Ilimitado | Depende |
| OPC UA | TCP/UDP | Client/Server/PubSub | Sí | Medio | Ilimitado | Depende |
| HTTP/2 | TCP | Request/Response | — | Alto | Ilimitado | Depende |

## Ejemplo: Publicación MQTT con Mosquitto

```bash
# Cliente MQTT publicando
mosquitto_pub -h broker.local -t "sensor/temperatura" -m "23.5" -q 1

# Cliente suscrito
mosquitto_sub -h broker.local -t "sensor/#" -q 1
```

## Ejemplo: Payload LoRaWAN (Cayenne LPP)

```c
// Cayenne Low Power Payload
typedef struct __attribute__((packed)) {
    uint8_t channel;    // 1
    uint8_t type;       // 0x67 = temperature
    int16_t value;      // °C * 10 (235 = 23.5°C)
} lpp_temperature_t;

lpp_temperature_t temp = {
    .channel = 1,
    .type = 0x67,
    .value = 235 // 23.5°C
};
// Enviar: lorawan_send((uint8_t*)&temp, sizeof(temp));
```

## Buenas prácticas

- Preferir MQTT como protocolo principal para la mayoría de aplicaciones IoT (maduro, amplio soporte)
- Usar CoAP para dispositivos con restricciones extremas de RAM/flash (< 50 KB RAM)
- LoRaWAN para sensores a batería que necesitan enviar pocos bytes/día a larga distancia
- NB-IoT/LTE-M para dispositivos en interiores profundos (sótanos) o con movilidad
- Zigbee/Thread para mallas de dispositivos en hogar o edificios (domótica, iluminación)
- DDS para sistemas distribuidos tiempo real con requisitos deterministas (robótica, defensa)
- OPC UA para integración con automatización industrial existente (PLC, SCADA)
- Usar PSH (Prime Size Header) en LoRaWAN para mantener paquetes pequeños (< 50 bytes)
- Implementar circuit breaker y retry en clientes MQTT para reconexión robusta

## Referencias adicionales

| Recurso | Descripción |
|---------|-------------|
| RFC 7252 | CoAP specification |
| RFC 2024 | MQTT specification |
| LoRaWAN 1.1 | LoRa Alliance specification |
| IEEE 802.15.4 | Estándar base para Zigbee y Thread |
| Bluetooth Core Spec 5.4 | BLE specification |
| OPC UA Part 1 | OPC Foundation specification |
| OMG DDS | DDS specification (Object Management Group) |
