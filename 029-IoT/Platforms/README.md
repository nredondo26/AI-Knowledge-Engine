# Plataformas IoT

## Descripción del dominio

Las plataformas IoT son conjuntos de servicios cloud y edge que facilitan la conexión, gestión, procesamiento y análisis de dispositivos IoT. Proporcionan funcionalidades como registro y autenticación de dispositivos, ingesta de datos (MQTT, HTTP, CoAP), almacenamiento de series temporales, dashboards, reglas de negocio, alertas, actualizaciones OTA y analítica ML. Este módulo cubre las principales plataformas IoT del mercado (AWS IoT, Azure IoT Hub, Google Cloud IoT), plataformas open source (ThingsBoard, Node-RED, Home Assistant) y plataformas especializadas para nichos específicos.

## Áreas clave

- **Conectividad y protocolos**: MQTT (pub/sub, QoS 0/1/2), HTTP REST, CoAP, LoRaWAN, AMQP — device gateways, bridges, protocol adapters
- **Device Registry y autenticación**: Registro de dispositivos con credenciales (X.509, tokens SAS, API keys), shadow/device twin (estado deseado vs reportado)
- **Ingesta y procesamiento de datos**: Pipelines de datos (IoT Core → Stream → Analytics → Storage), rules engine, edge computing, time-series databases (InfluxDB, TimescaleDB, Timestream)
- **Gestión de dispositivos**: OTA updates, configuración remota, remote commands (direct methods), monitoring de salud, logging, geolocalización
- **Dashboards y visualización**: Grafana, ThingsBoard dashboards, AWS IoT SiteWise, Azure Time Series Insights, Home Assistant Lovelace
- **Analítica y ML en IoT**: Anomaly detection, predictive maintenance, forecasting (temperatura, vibración), ML en edge (Greengrass, Azure IoT Edge)
- **Seguridad IoT**: Autenticación mutua (mTLS), cifrado extremo a extremo, secure boot, TPM/HSM, just-in-time provisioning, certificate rotation
- **IoT y Serverless**: AWS IoT + Lambda, Azure IoT Hub + Functions, Google IoT + Cloud Functions — event-driven processing sin servidores

## Plataformas cloud principales

| Plataforma | MQTT | OTA | Edge | Integraciones |
|------------|------|-----|------|---------------|
| AWS IoT Core | Sí | Sí | Greengrass | Lambda, Kinesis, S3, Timestream, SiteWise |
| Azure IoT Hub | Sí | Sí | IoT Edge | Functions, Stream Analytics, Time Series Insights |
| Google Cloud IoT | Sí (Gateway) | No | Edge TPU + IoT Edge | Pub/Sub, Dataflow, BigQuery |
| IBM Watson IoT | Sí | Sí | Edge | Cloud Pak for Data, Maximo |

## Plataformas open source / auto-gestionadas

| Plataforma | Protocolos | Base de datos | UI | Características |
|------------|-----------|---------------|-----|-----------------|
| ThingsBoard | MQTT, CoAP, HTTP | PostgreSQL, Cassandra | Dashboards widgets | Rule engine, OTA, alarms |
| Node-RED | MQTT, HTTP, TCP/UDP | Flow-based | Editor visual flow | 5000+ nodos comunitarios |
| Home Assistant | MQTT, Zigbee, Z-Wave | SQLite/MySQL | Lovelace UI | Automatización hogar, add-ons |
| Mainflux | MQTT, CoAP, HTTP, WS | PostgreSQL, InfluxDB | REST API | Arquitectura microservicios |
| Eclipse Hono | MQTT, CoAP, HTTP, AMQP | InfluxDB/Prometheus | Consola web | Tenancy multi-tenant, protocol adapters |
| Kaa IoT | MQTT, HTTP | MongoDB, Cassandra | Dashboard | Endpoint management, ML |

## Ejemplo: Suscripción MQTT con regla en Node-RED

```json
// Flow Node-RED (representación JSON)
[
  {
    "id": "mqtt-in",
    "type": "mqtt in",
    "topic": "sensors/+/temperature",
    "qos": "1",
    "broker": "iot.eclipse.org"
  },
  {
    "id": "function-rule",
    "type": "function",
    "func": "const t = msg.payload;\nif (t > 80) {\n    msg.alert = true;\n    msg.topic = 'alerts/temperature';\n} else {\n    msg.alert = false;\n}\nmsg.threshold = 80;\nreturn msg;"
  },
  {
    "id": "debug-out",
    "type": "debug"
  }
]
```

## Tecnologías complementarias

| Categoría | Tecnologías |
|-----------|-------------|
| Time-series DB | InfluxDB, TimescaleDB, QuestDB, Prometheus (monitoring) |
| Message brokers | EMQX, Mosquitto, VerneMQ, HiveMQ, NATS |
| Edge frameworks | EdgeX Foundry, K3s, Balena, AWS Greengrass |
| OTA | Eclipse Hawkbit, balena, Mender, SWUpdate |
| Visualización | Grafana, ThingsBoard, Superset, Redash |
| Simulación | AWS IoT Device Simulator, Azure IoT Device Simulation |

## Buenas prácticas

- Usar MQTT con QoS 1 para telemetría (balance entre fiabilidad y overhead)
- Implementar device twin/shadow para estado deseado (configuración) vs reportado (estado real)
- Usar reglas de enrutamiento en cloud para filtrar y procesar datos cerca de la ingesta
- Almacenar datos de sensores en time-series DB con retención gradual (raw → aggregated → deleted)
- Implementar provisioning automático (just-in-time) para flotas grandes de dispositivos
- Separar dashboards por roles (operador → técnico → administrador)
- Usar edge computing para filtrar datos ruidosos y reducir ancho de banda a cloud
- Para OTA, implementar A/B updates con rollback automático y verificación de firma
- Monitorear métricas de la plataforma (conexiones activas, throughput, errores de protocolo)
