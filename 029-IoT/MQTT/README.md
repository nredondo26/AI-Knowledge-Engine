# MQTT — Protocolo de Mensajería IoT

## Visión General

MQTT (Message Queuing Telemetry Transport) es un protocolo de mensajería publish/subscribe ligero diseñado para IoT. Opera sobre TCP/IP y es ideal para dispositivos con recursos limitados y redes de baja confiabilidad.

## Características Clave

- **Modelo publish/subscribe** — Desacopla productores y consumidores
- **Tres QoS (Quality of Service)** — 0, 1 y 2
- **Retained messages** — Último valor conocido persistente
- **Will message** — Mensaje de último testamento
- **Clean/Persistent session** — Reanudación de sesión
- **TLS/SSL** — Seguridad en la capa de transporte

## Componentes del Sistema

```
┌──────────┐     publish(topic, payload)     ┌───────────┐
│  Sensor  │ ──────────────────────────────▶ │  Broker   │
│ (Publisher)│                                │           │
└──────────┘                                  │  Mosquitto│
                                              │  EMQX    │
┌──────────┐     subscribe(topic)             │  HiveMQ  │
│  App     │ ◀────────────────────────────── │           │
│(Subscriber)│   publish(topic, payload)      └───────────┘
└──────────┘
```

## Calidad de Servicio (QoS)

| QoS | Nivel | Garantía | Uso |
|-----|-------|----------|-----|
| 0 | At most once | Sin confirmación | Telemetría rápida, pérdidas tolerables |
| 1 | At least once | Confirmado, puede duplicar | Comandos críticos |
| 2 | Exactly once | Cuatro handshakes | Transacciones financieras |

### Flujo QoS 2

```
Publisher ── PUBLISH (QoS 2) ──▶ Broker
Publisher ◀── PUBREC ────────── Broker
Publisher ── PUBREL ──────────▶ Broker
Publisher ◀── PUBCOMP ──────── Broker
```

## Broker Mosquitto — Instalación y Configuración

```bash
# Instalación
sudo apt install mosquitto mosquitto-clients

# Iniciar servicio
sudo systemctl enable mosquitto
sudo systemctl start mosquitto
```

```ini
# /etc/mosquitto/mosquitto.conf
listener 1883 0.0.0.0
protocol mqtt

listener 8883 0.0.0.0
protocol mqtt
certfile /etc/mosquitto/certs/server.crt
keyfile /etc/mosquitto/certs/server.key
tls_version tlsv1.2

listener 9001 0.0.0.0
protocol websockets

allow_anonymous false
password_file /etc/mosquitto/passwd

persistence true
persistence_location /var/lib/mosquitto/
```

```bash
# Crear usuario
mosquitto_passwd -c /etc/mosquitto/passwd sensor01

# Probar conexión
mosquitto_sub -h localhost -t "test/#" -u sensor01 -P password
mosquitto_pub -h localhost -t "test/hello" -m "Hola MQTT" -u sensor01 -P password
```

## Publicación y Suscripción desde CLI

```bash
# Suscribirse con QoS 1
mosquitto_sub -h broker.example.com \
  -t "dispositivos/+/temperatura" \
  -q 1 \
  -v

# Publicar con retain
mosquitto_pub -h broker.example.com \
  -t "casa/salon/luz" \
  -m "on" \
  -r

# Publicar desde archivo
mosquitto_pub -h broker.example.com \
  -t "sensores/datos" \
  -f datos.json
```

## Cliente Python con paho-mqtt

```bash
pip install paho-mqtt
```

```python
import paho.mqtt.client as mqtt
import json
import time

BROKER = "broker.example.com"
PORT = 1883
TOPIC = "sensores/temperatura"
CLIENT_ID = "sensor-001"

def on_connect(client, userdata, flags, rc, properties=None):
    if rc == 0:
        print(f"Conectado a {BROKER}")
        client.subscribe(f"{TOPIC}/response", qos=1)
    else:
        print(f"Error de conexión: {rc}")

def on_message(client, userdata, msg):
    print(f"[{msg.topic}] {msg.payload.decode()}")

client = mqtt.Client(
    client_id=CLIENT_ID,
    protocol=mqtt.MQTTv5,
    callback_api_version=mqtt.CallbackAPIVersion.VERSION2
)

client.username_pw_set("sensor01", "password123")
client.tls_set("/etc/ssl/certs/ca-certificates.crt")
client.on_connect = on_connect
client.on_message = on_message

client.connect(BROKER, PORT, 60)
client.loop_start()

while True:
    payload = json.dumps({
        "device": CLIENT_ID,
        "temperature": 22.5,
        "humidity": 60,
        "timestamp": time.time()
    })
    client.publish(TOPIC, payload, qos=1)
    time.sleep(10)
```

## Cliente en ESP32 (Arduino)

```cpp
#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>

const char* ssid = "MiWiFi";
const char* password = "contraseña";
const char* mqtt_server = "broker.example.com";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++)
    message += (char)payload[i];

  Serial.printf("Mensaje [%s]: %s\n", topic, message.c_str());

  if (String(topic) == "casa/luz") {
    digitalWrite(2, message == "on" ? HIGH : LOW);
  }
}

void reconnect() {
  while (!client.connected()) {
    if (client.connect("ESP32_Sensor", "sensor01", "password123")) {
      client.subscribe("casa/#");
      client.publish("status/esp32", "online", true);
    } else {
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) delay(500);

  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) reconnect();
  client.loop();
}
```

## Topic Design — Buenas Prácticas

```
# Jerarquía recomendada
dominio/dispositivo/sensor/tipo

# Ejemplos
casa/salon/temperatura
casa/salon/luminosidad
fabrica/robot-01/motor/velocidad
fabrica/robot-01/motor/temperatura

# Wildcards
+ (single level): casa/+/temperatura
# (multi level):  fabrica/#
```

## MQTT vs MQTT-SN

MQTT-SN (Sensor Networks) es una variante para redes no TCP como Zigbee o LoRa:

| Característica | MQTT | MQTT-SN |
|---------------|------|---------|
| Transporte | TCP/IP | UDP |
| Header | 2-14 bytes | 2-4 bytes |
| Gateway requerido | No | Sí |
| Topic ID | String | ID numérico (2 bytes) |
| Discovery | No | Sí (GW advertisement) |

## Seguridad

### TLS y Autenticación

```python
import ssl

# TLS con certificado de cliente
client.tls_set(
    ca_certs="ca.crt",
    certfile="client.crt",
    keyfile="client.key",
    cert_reqs=ssl.CERT_REQUIRED,
    tls_version=ssl.PROTOCOL_TLSv1_2
)
```

### ACL (Mosquitto)

```ini
# /etc/mosquitto/acl.conf
per topic read casa/salon/#
per topic write sensores/#

user sensor01
topic write sensores/#
topic read status/#

user app01
topic read sensores/#
topic write casa/#
topic write status/#
```

## MQTT 5.0 Novedades

- **Reason codes** — Códigos explícitos en ACKs
- **Session Expiry** — Sesiones persistentes con TTL
- **Message Expiry** — TTL por mensaje
- **Topic Alias** — IDs numéricos para topics (ahorro de ancho de banda)
- **User Properties** — Metadatos arbitrarios en el header
- **Payload Format Indicator** — Content-type

## Monitoreo con MQTT Explorer

```bash
# Docker
docker run -d -p 8080:80 -p 1883:1883 thomasjohannes/mqtt-explorer

# Web-based
# Navegar a http://localhost:8080
```

## Referencias

- [MQTT 5.0 Specification (OASIS)](https://docs.oasis-open.org/mqtt/mqtt/v5.0/os/mqtt-v5.0-os.html)
- [Mosquitto Official](https://mosquitto.org/)
- [Paho Python Client](https://github.com/eclipse/paho.mqtt.python)
- [PubSubClient (Arduino)](https://github.com/knolleary/pubsubclient)
- [MQTT Essentials (HiveMQ)](https://www.hivemq.com/mqtt-essentials/)
