# 029-IoT: Internet of Things

## Descripción del dominio

El Internet de las Cosas (IoT) conecta dispositivos físicos a internet para recopilar, intercambiar y actuar sobre datos. Abarca desde sensores industriales y wearables hasta ciudades inteligentes y agricultura de precisión. La arquitectura típica incluye dispositivos (sensores/actuadores), conectividad (WiFi, BLE, LoRaWAN, Zigbee, NB-IoT), edge computing, protocolos de comunicación (MQTT, CoAP, HTTP), plataformas cloud de IoT, procesamiento de datos y analítica. La seguridad, interoperabilidad y escalabilidad son desafíos centrales.

## Conceptos clave

- **Sensor**: Dispositivo que mide magnitudes físicas (temperatura, presión, humedad, movimiento)
- **Actuador**: Dispositivo que ejecuta acciones físicas (relé, motor, válvula, servo)
- **Gateway (Puerta de enlace)**: Dispositivo que conecta sensores locales a internet
- **Edge computing**: Procesamiento de datos en el dispositivo o gateway, no en la nube
- **Fog computing**: Capa intermedia entre edge y cloud para procesamiento distribuido
- **MQTT**: Protocolo de mensajería ligero publish/subscribe sobre TCP, estándar en IoT
- **CoAP**: Protocolo REST-like sobre UDP optimizado para dispositivos limitados
- **LoRaWAN**: Protocolo LPWAN para comunicaciones de largo alcance y bajo consumo
- **NB-IoT / LTE-M**: Tecnologías celulares para IoT masivo y de baja potencia
- **Zigbee**: Protocolo de red mesh para domótica e industrial de corto alcance
- **BLE (Bluetooth Low Energy)**: Bluetooth de bajo consumo para wearables y beacons
- **Digital Twin**: Gemelo digital — réplica virtual de un dispositivo o sistema físico
- **Device twin**: Representación digital del estado de un dispositivo en la nube
- **OTA (Over-The-Air)**: Actualización de firmware remota para dispositivos
- **Time-series data**: Datos secuenciales en el tiempo (temperatura cada 5 min)
- **Data pipeline**: Flujo de ingesta, procesamiento, almacenamiento y visualización de datos IoT
- **Dashboard IoT**: Visualización en tiempo real de métricas de dispositivos
- **Smart Home**: Automatización del hogar (luces, termostatos, cerraduras, cámaras)
- **Industrial IoT (IIoT)**: IoT en fábricas, mantenimiento predictivo, control de procesos
- **Digital Twin**: Réplica virtual para simulación, monitoreo y optimización

## Tecnologías principales

- **AWS IoT Core**: Plataforma cloud IoT (device shadows, rules engine, MQTT broker)
- **Azure IoT Hub**: Ingesta y gestión de dispositivos, edge runtime, DPS
- **Google Cloud IoT**: Cloud IoT Core (discontinuado, migrar a partner), Pub/Sub, Edge TPU
- **ThingWorx (PTC)**: Plataforma IIoT industrial con conectividad y analytics
- **Cumulocity (Software AG)**: Plataforma IoT para gestión de dispositivos y aplicaciones
- **Node-RED**: Herramienta visual de flujos para IoT, low-code, conectores múltiples
- **Mosquitto**: Broker MQTT open-source, ligero, ideal para edge y cloud
- **HiveMQ**: Broker MQTT enterprise, escalable, con clustering
- **InfluxDB**: Base de datos time-series optimizada para datos IoT
- **Grafana**: Visualización y dashboards para series temporales
- **ThingsBoard**: Plataforma IoT open-source, gestión de dispositivos, dashboards
- **ESP32 / ESP8266**: SoCs WiFi/BLE más usados en prototipado IoT
- **Raspberry Pi**: SBC para gateways y edge computing IoT
- **LoRa / LoRaWAN**: Tecnología LPWAN open, larga distancia (>10 km), bajo consumo
- **Zephyr / FreeRTOS**: RTOS para dispositivos IoT con conectividad
- **Matter**: Nuevo estándar de conectividad para smart home (unifica Zigbee, Thread, WiFi)
- **OPC UA**: Protocolo de comunicación industrial M2M, seguridad integrada

## Hoja de ruta

1. **Principiante**: Conectar sensor (DHT22) a ESP32 y publicar datos por MQTT. Consumir con Node-RED y mostrar en dashboard Grafana. Entender arquitectura dispositivo → gateway → cloud.
2. **Intermedio**: Gestión de dispositivos con AWS IoT Core o Azure IoT Hub. Device twins, jobs, OTA. Edge computing con análisis local. Protocolos LoRaWAN y BLE. Time-series database con InfluxDB.
3. **Avanzado**: Arquitectura IoT escalable con millones de dispositivos. Seguridad integral (certificados, TPM, cifrado extremo a extremo). Digital Twins para simulación. Mantenimiento predictivo con machine learning. Procesamiento de streams con Kafka/Flink.
4. **Experto**: Diseño de plataforma IoT completa. Edge AI con modelos embebidos (TinyML). Redes mesh para entornos industriales. Interoperabilidad entre protocolos (OPC UA, MQTT, Modbus). Sistemas críticos con redundancia y tolerancia a fallos. Estándares y certificaciones (IEC 62443 para seguridad industrial).

## Relaciones con otros módulos

- [Embedded](../028-Embedded/) — Firmware, MCUs, RTOS, sensores, actuadores en dispositivos IoT
- [Networking](../008-Networking/) — Protocolos de comunicación (MQTT, CoAP, LoRaWAN, BLE, Zigbee)
- [Cloud](../005-Cloud/) — IoT platforms cloud (AWS IoT, Azure IoT Hub, Google Cloud IoT)
- [Databases](../003-Databases/) — Time-series (InfluxDB, TimescaleDB, QuestDB)
- [Security](../009-Security/) — Cifrado IoT, autenticación de dispositivos, secure boot
- [Observability](../097-Observability/) — Monitoreo de flota de dispositivos, alertas
- [AI](../031-AI/) — TinyML, mantenimiento predictivo, analytics en edge
- [Automation](../015-Automation/) — Automatización industrial (IIoT), smart homes, smart cities
- [Architecture](../010-Architecture/) — Arquitecturas edge/fog/cloud, pipelines de datos

## Recursos recomendados

- [AWS IoT Documentation](https://docs.aws.amazon.com/iot)
- [Azure IoT Documentation](https://learn.microsoft.com/azure/iot)
- [MQTT.org](https://mqtt.org)
- [LoRa Alliance](https://lora-alliance.org)
- [Eclipse IoT](https://iot.eclipse.org)
- [InfluxDB Documentation](https://docs.influxdata.com)
- [Grafana IoT Dashboards](https://grafana.com/oss/grafana)
- "Building the Internet of Things" — Maciej Kranz
- "Designing Connected Products" — Claire Rowland et al.
- "IoT, AI, and Blockchain for .NET" — Packt
- [ThingsBoard Docs](https://thingsboard.io/docs)
- [ESP-IDF Programming Guide](https://docs.espressif.com/projects/esp-idf)
