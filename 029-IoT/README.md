# 029-IoT: Internet de las Cosas

## Descripción ampliada del dominio

El Internet de las Cosas (IoT) conecta dispositivos físicos (sensores, actuadores, wearables, vehículos, electrodomésticos) a Internet para recopilar, intercambiar y actuar sobre datos, creando sistemas ciberfísicos inteligentes. La arquitectura típica IoT incluye dispositivos/edge, gateways, plataformas cloud, procesamiento de datos, y aplicaciones. El número de dispositivos IoT conectados superó los 15 billones en 2024 y se proyecta a 30 billones para 2030. Los sectores principales son: industria (Industry 4.0, IIoT), smart home, smart city, healthcare (IoMT), agriculture, automotive (connected cars), y energy (smart grid). La evolución IoT: sensores cableados (1980s-90s, SCADA) → RFID y sensores inalámbricos (2000s, M2M) → IoT plataformas cloud (2010s, AWS IoT, Azure IoT, Google Cloud IoT) → Edge computing + AI (2020s, IoT + AI/ML on edge, federated learning). Las tendencias actuales incluyen: IoT + AI (AI at the edge), 5G IoT (uRLLC, mMTC), digital twins (réplicas virtuales de sistemas físicos), IoT + blockchain (supply chain), y sostenibilidad (green IoT, energy harvesting).

## Tabla de conceptos clave

| Concepto | Descripción | Tecnologías/Estándares |
|----------|-------------|----------------------|
| Dispositivo IoT | Objeto físico con sensor/actuador + conectividad | ESP32, Raspberry Pi, Arduino, STM32, nRF52 |
| Gateway IoT | Dispositivo que conecta dispositivos locales a la nube | Raspberry Pi, Edge gateway (Lanner, Advantech) |
| Protocolo IoT | Protocolo de comunicación para dispositivos restringidos | MQTT, CoAP, HTTP, LwM2M, OPC UA, Modbus |
| MQTT | Protocolo publish-subscribe ligero sobre TCP/IP | MQTT 3.1.1, MQTT 5 (Mosquitto, EMQX, HiveMQ) |
| CoAP | Protocolo REST-like sobre UDP para dispositivos restringidos | CoAP (RFC 7252), OMA LwM2M |
| LPWAN | Low Power Wide Area Network para IoT de larga distancia/baja potencia | LoRaWAN, NB-IoT, LTE-M, Sigfox |
| Edge Computing | Procesamiento de datos cerca del dispositivo IoT | AWS IoT Greengrass, Azure IoT Edge, EdgeX Foundry |
| Digital Twin | Réplica virtual de un sistema físico actualizada en tiempo real | Azure Digital Twins, AWS IoT TwinMaker, Eclipse Ditto |
| OTA Update | Actualización de firmware inalámbrica | AWS IoT Device Management, MCUboot SWAP |
| IoT Platform | Plataforma cloud para gestionar dispositivos, datos, aplicaciones | AWS IoT Core, Azure IoT Hub, Google Cloud IoT Core |
| Device Shadow | Representación virtual del estado del dispositivo en la nube | AWS Device Shadow, Azure Device Twin |
| M2M | Machine to Machine communication | MQTT, OPC UA, Modbus, CAN bus |

## Tecnologías principales

| Plataforma IoT | Conectividad | Device Management | Edge Computing | Data Processing | Analytics/ML |
|----------------|-------------|-------------------|---------------|-----------------|--------------|
| AWS IoT Core | MQTT, HTTP, LoRaWAN, BLE | Device Shadow, Jobs, Fleet Hub | Greengrass (Lambda, ML) | IoT Analytics, Kinesis | IoT Events (Rule engines), SageMaker Edge |
| Azure IoT Hub | MQTT, AMQP, HTTP, MQTT over WebSockets | Device Twin, Direct Methods, Jobs | Azure IoT Edge (Modules) | Stream Analytics, Data Explorer | Time Series Insights, Cognitive Services |
| Google Cloud IoT | MQTT, HTTP | Device Registry, Config (legacy) | IoT Edge (legacy) | Pub/Sub + Dataflow | BigQuery ML, Vertex AI |
| ThingsBoard (Open Source) | MQTT, CoAP, HTTP | Device Provisioning, RPC | Edge (on-prem) | Rule Engine, SQL/NoSQL | Dashboards, Widgets |
| EMQX (MQTT Broker) | MQTT, CoAP, LwM2M | Plugins, Extensions | EMQX Edge | Bridge to Kafka, DB | Rule Engine |
| EdgeX Foundry (LF Edge) | MQTT, HTTP, Modbus | Device Services, Core Metadata | Sí (microservicios) | Core Data, Export | App Services |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: qué es IoT, arquitectura (device → gateway → cloud → app), sensores (activos/pasivos, digital/analógico), actuadores (relays, motores, servos, solenoids). Conectividad básica: ESP32 WiFi + MQTT. MQTT: broker (Mosquitto local o cloud), topic, publish, subscribe, QoS (0,1,2), last will. IoT Cloud: AWS IoT Core (crear Thing, policy, certificate), publicar datos de sensor a MQTT topic. Recibir datos en app: Node-RED (flow-based programming, MQTT input + dashboard). Protocolos HTTP: REST API para enviar datos (POST a endpoint). Formatos: JSON (estructurado), CSV.
   - Proyecto: ESP32 sensor (DHT22 temperatura/humedad) → MQTT → AWS IoT Core → Node-RED dashboard web.
   - Lectura: "IoT for Beginners" (Microsoft), "Getting Started with IoT" (Waher), AWS IoT docs, Node-RED docs.

2. **Intermedio (3-8 meses)**: Conectividad LPWAN: LoRaWAN (gateway, end-devices, ABP/OTAA, ChirpStack/TTN), NB-IoT / LTE-M (cellular IoT, SIM cards, data plans). Protocolos: CoAP (REST-like UDP, observe), Modbus RTU/TCP (industrial), OPC UA (IEC 62541, industrial automation). Edge computing: AWS IoT Greengrass (deploy Lambda functions to edge devices, ML inference at edge, stream manager), Azure IoT Edge (modules, local processing, offline capability). Device management: OTA updates (AWS IoT Jobs, MCUboot), device provisioning (AWS IoT Fleet Provisioning, X.509 certificates), remote commands. Data pipelines: IoT data → Kafka/MQTT bridge → stream processing (KSQL, Flink) → database (TimescaleDB, InfluxDB) → dashboard (Grafana). IoT security: X.509 certificates, TLS mutual authentication, secure element (ATECC608A), PKI for device identity, device attestation. Time series databases: InfluxDB, TimescaleDB (PostgreSQL time-series extension), QuestDB (for IoT analytics). FOTA (Firmware Over-The-Air): AWS IoT Jobs + MCUboot (swap, confirm, revert). Industrial IoT: SCADA, PLC, OPC DA/UA, Siemens S7, Allen Bradley.
   - Proyecto: LoRaWAN sensor node → TTN → MQTT → InfluxDB → Grafana. Edge AI (TensorFlow Lite on Raspberry Pi for object detection).
   - Certificación: AWS Certified IoT Specialty (AWS IoT), Microsoft Azure IoT Developer (AZ-220).

3. **Avanzado (6-12 meses)**: Edge AI: TensorFlow Lite / ONNX Runtime on edge (Raspberry Pi, NVIDIA Jetson, Coral TPU), ML inference at edge (object detection, anomaly detection, predictive maintenance), model optimization (quantization, pruning, distillation), federated learning (train across edge devices without central data). Digital twins: AWS IoT TwinMaker (3D scene, data connectors, entities, alarms), Azure Digital Twins (DTDL model, twin graph, query), Eclipse Ditto (open source). IoT protocols advanced: MQTT 5 (user properties, session expiry, reason codes), LwM2M (device management objects, firmware update, bootstrap). IoT data analytics: anomaly detection on time series (Amazon Lookout for Equipment, Azure Anomaly Detector), predictive maintenance (ML models + IoT data). Security: hardware security module (HSM), secure element (SE050, ATECC608), TPM, secure boot chain, firmware encryption, anti-cloning. Edge-native applications: containerized workloads on edge (K3s, KubeEdge, Balena), edge-native databases. IoT mesh: Thread/OpenThread (IPv6 mesh for smart home), Zigbee 3.0, Bluetooth Mesh. LPWAN at scale: LoRaWAN network server configuration (ChirpStack, The Things Stack), frequency plans, duty cycle, SF/spreading factor.
   - Proyecto: Predictive maintenance with IoT data + ML model. Digital twin of a manufacturing cell. Edge cluster with K3s for industrial IoT.
   - Certificación: AWS Machine Learning Specialty, Azure AI Engineer Associate, NVIDIA Jetson / DeepStream.

4. **Experto (12+ meses)**: IoT at massive scale: million-device architectures (device onboarding, MQTT topics best practices, device shadows, state management, data compression). 5G IoT: uRLLC (ultra-reliable low latency communications for industrial control), mMTC (massive machine type communications for massive IoT), network slicing. Satellite IoT: Iridium, Starlink direct-to-cell, LoRaWAN satellite backhaul. Automotive IoT: V2X (Vehicle-to-Everything: V2V, V2I, V2N, V2P), CAN bus integration, OBD-II telematics. Smart grid: DER (Distributed Energy Resources), AMI (Advanced Metering Infrastructure), Demand Response, IEC 61850. Energy harvesting: solar, thermal, vibration, RF harvesting — zero-power IoT. Battery-less IoT: BLE advertising + energy harvesting, backscatter communication. IoT standards: ISO/IEC 30141 (IoT Reference Architecture), oneM2M, OMA SpecWorks. IoT compliance: RED (Radio Equipment Directive), FCC, CE marking. Blockchain for IoT: IOTA Tangle (no-fee microtransactions), supply chain traceability, device identity. Digital twins at scale: City-scale digital twins, Digital twin simulation (AnyLogic, SimScale). IoT + Generative AI: LLMs interpreting sensor data, generating maintenance reports, conversational dashboards.
   - Proyecto: Million-scale IoT architecture design. OTA firmware update infrastructure for 100K+ devices. Digital twin of smart building with real-time sensor data + simulation.
   - Lectura: IoT reference architecture (ISO/IEC 30141), AWS IoT Solutions, Google Cloud IoT Core papers.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | Time series DB (InfluxDB, TimescaleDB), IoT data storage |
| [004-OperatingSystems](../004-OperatingSystems/) | Linux embebido, FreeRTOS para dispositivos IoT |
| [005-Cloud](../005-Cloud/) | AWS IoT Core, Azure IoT Hub, Cloud IoT platforms |
| [006-Containers](../006-Containers/) | Edge containers (K3s, Balena), IoT gateway containerization |
| [008-Networking](../008-Networking/) | MQTT, CoAP, LoRaWAN, 5G, Zigbee protocols |
| [009-Security](../009-Security/) | IoT security, device identity, secure boot, encryption |
| [015-Automation](../015-Automation/) | IoT + automation (smart homes, industrial automation) |
| [028-Embedded](../028-Embedded/) | Dispositivos IoT basados en MCUs embebidos |
| [030-Robotics](../030-Robotics/) | IoT + robotics en manufacturing, drones |
| [031-AI](../031-AI/) | Edge AI, TinyML, AI for IoT data analytics |
| [032-MachineLearning](../032-MachineLearning/) | ML en IoT: predictive maintenance, anomaly detection |

## Recursos recomendados

- **Plataformas cloud**: AWS IoT Core, Azure IoT Hub, Google Cloud IoT Core (legacy/alternatives), ThingsBoard, EMQX.
- **Hardware**: ESP32, Raspberry Pi, Arduino, NVIDIA Jetson, STM32 + LoRa, Raspberry Pi Pico W, nRF52840 (BLE), Heltec (LoRa+WiFi).
- **Protocolos**: MQTT (mqtt.org), CoAP, LoRaWAN, Zigbee, Z-Wave, Thread/Matter, Bluetooth LE.
- **Libros**: "IoT for Beginners" (Microsoft, free), "Designing the Internet of Things" (McEwen, Cassimally), "Building the Internet of Things" (Kranz), "IoT Inc." (Sinclair).
- **Cursos**: Coursera "IoT Specialization" (UCI), "IoT: Foundations and Applications" (Yonsei), AWS IoT training, Azure IoT Developer (AZ-220).
- **Comunidad**: Hackster.io, Instructables, The Things Network forum, Arduino Forum, ESP32 Forum.

## Notas adicionales

IoT une el mundo digital y el físico, lo que lo hace fascinante pero desafiante. La seguridad debe ser considerada desde el diseño (secure by design). AWS IoT Core es la plataforma cloud más madura. MQTT es el protocolo IoT dominante y debería ser el primero en aprender. Para alcance largo y baja potencia: LoRaWAN. Para alta velocidad: 4G/5G. Edge computing + AI (Edge AI) es la tendencia transformadora. Matter (antiguo Project CHIP) es el nuevo estándar para smart home interoperability entre Amazon, Apple, Google. El future del IoT es: 5G massive IoT + edge AI + digital twins + energy harvesting (zero-power IoT).
