# Edge Computing — Computación en el Borde

## Descripción del dominio

Edge Computing (computación en el borde) es un paradigma que procesa datos cerca de la fuente de generación (sensores, dispositivos IoT, cámaras) en lugar de enviarlos a la nube centralizada. Reduce la latencia, el ancho de banda necesario y la dependencia de conectividad cloud, permitiendo respuestas en tiempo real y operación offline. La arquitectura edge abarca desde MCUs con ML embebido (TinyML) hasta servidores edge (gateways, fog nodes, edge clusters). Es fundamental para aplicaciones tiempo real: vehículos autónomos, robótica, videoanalítica, automatización industrial, realidad aumentada y salud digital.

## Áreas clave

- **Fog Computing vs Edge Computing**: Fog es una capa intermedia entre edge y cloud; edge es el dispositivo final (o gateway inmediato). Fog agrega y procesa datos de múltiples edges
- **Edge AI / TinyML**: Inferencia de ML en dispositivos limitados (MCUs, DSPs). TensorFlow Lite Micro, Edge Impulse, ONNX Runtime, Apache TVM. Cuantización, pruning, distillation para reducir modelos
- **Gateways IoT**: Dispositivos que conectan sensores locales (Zigbee, BLE, LoRa, Modbus) a internet (MQTT, HTTP, cloud). Ejecutan lógica edge, caching, filtrado, agregación
- **Edge Kubernetes (K3s, KubeEdge)**: Orquestación de contenedores en el edge. K3s (ligero, <100MB), KubeEdge (extensión K8s para edge), MicroK8s. Ideal para gateways y edge servers
- **5G Edge (MEC)**: Multi-access Edge Computing — servidores en estaciones base 5G. Latencia <10ms, computación cerca del usuario móvil. ETSI MEC estándar
- **Edge Storage**: Almacenamiento local en el edge con sincronización asíncrona a cloud. CouchDB/PouchDB (replicación), SQLite, EdgeFS, MinIO Edge
- **Protocolos edge**: MQTT (Edge → Cloud con bridging), gRPC (intra-edge), WebSocket (real-time), OPC UA (industrial), DDS (tiempo real distribuido)
- **Seguridad edge**: TPM (Trusted Platform Module), secure enclave, trusted execution environment (TEE), remote attestation, zero-trust edge, hardware root of trust

## Ejemplo: Gateway edge con Python y MQTT

```python
import paho.mqtt.client as mqtt
import json

def on_sensor_data(client, userdata, msg):
    payload = json.loads(msg.payload)
    # Procesamiento edge: filtrar, agregar, detectar anomalías
    if payload["temperature"] > 80:
        # Actuación inmediata en el edge (sin esperar cloud)
        activate_cooling()
        # Enviar alerta a cloud
        client.publish("alert/temperature", json.dumps({
            "device": payload["device_id"],
            "value": payload["temperature"],
            "action": "cooling_activated"
        }))
    # Forward a cloud con agregación periódica
    buffer.append(payload)

client = mqtt.Client()
client.on_message = on_sensor_data
client.connect("broker.local")
client.subscribe("sensors/#")
client.loop_forever()
```

## Ejemplo: Edge ML con TensorFlow Lite Micro

```c
// Inferencia de clasificación en MCU (TFLM)
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"

static tflite::MicroMutableOpResolver<10> resolver;
static tflite::MicroInterpreter static_interpreter(
    g_model, resolver, tensor_arena, kTensorArenaSize);

void run_inference(float *input) {
    TfLiteTensor *input_tensor = interpreter.input(0);
    memcpy(input_tensor->data.f, input, input_tensor->bytes);
    interpreter.Invoke();
    TfLiteTensor *output = interpreter.output(0);
    float *predictions = output->data.f;
    // predictions[0..N-1] contiene las probabilidades de clase
}
```

## Tecnologías principales

| Plataforma | Descripción |
|------------|-------------|
| NVIDIA Jetson (Orin, Xavier, Nano) | Edge AI GPU, hasta 275 TOPS |
| Google Coral (TPU) | Acelerador USB/M.2 para inferencia edge |
| Intel Movidius (Neural Compute Stick) | VPU para visión por computadora |
| Raspberry Pi / Rock Pi | Single-board computers para prototipado edge |
| AWS IoT Greengrass | Edge runtime de AWS con Lambda, ML, MQTT |
| Azure IoT Edge | Runtime edge de Azure con módulos contenedores |
| Google Anthos Edge | K8s híbrido edge-cloud |
| Balena | Plataforma edge para flota de dispositivos Linux |
| K3s / KubeEdge | Kubernetes ligero para edge |
| OpenYurt / StarlingX | Plataformas edge cloud-native |

## Buenas prácticas

- Procesar todo lo posible en el edge antes de enviar a cloud (filtrado, agregación, detección de eventos)
- Usar modelos ML cuantizados (INT8) para inferencia en MCUs con TFLite Micro o Edge Impulse
- Implementar almacenamiento local con sincronización asíncrona para tolerancia a desconexiones
- Diseñar capacidad offline-first: el sistema edge debe funcionar sin conexión cloud
- Usar MQTT Sparkplug para integración edge-to-cloud con estado y tags
- Contenerizar aplicaciones edge con Docker/K3s para gestión y actualización remota
- Implementar health checks y watchdog en el edge para auto-recuperación
- Para aplicaciones tiempo real crítico, usar DDS (Data Distribution Service) en lugar de MQTT/HTTP
- Evaluar 5G MEC para aplicaciones móviles con requisitos de latencia ultra baja (<10ms)
