# Zigbee — Protocolo de Comunicación IoT

## Descripción del dominio

Zigbee es un protocolo de comunicación inalámbrica de corto alcance, bajo consumo y baja tasa de datos, diseñado para aplicaciones IoT de domótica, automatización industrial, iluminación inteligente, sensores y control de edificios. Está basado en el estándar IEEE 802.15.4 para la capa física y MAC, operando en las bandas ISM de 2.4 GHz (global), 868 MHz (Europa) y 915 MHz (América). Zigbee utiliza topología de red mesh (malla), donde cada dispositivo puede actuar como router para extender el alcance. Define un stack completo desde la capa física hasta la de aplicación con perfiles y clusters estandarizados.

## Áreas clave

- **Topología de red**: Mesh (malla) — cada router puede reenviar paquetes. También soporta estrella y árbol. Un coordinador (coordinator) inicia la red, routers extienden el alcance, end devices ahorran energía durmiendo
- **Stack Zigbee**: Capas: PHY/MAC (IEEE 802.15.4) → NWK (Network) → APS (Application Support) → ZDO (Zigbee Device Object) → Application Framework (clusters y profiles)
- **Perfiles (Profiles)**: Zigbee Home Automation (ZHA), Zigbee Light Link (ZLL), Zigbee 3.0 (unificación), Zigbee Smart Energy (SE), Zigbee Green Power (energy harvesting)
- **Clusters**: Conjuntos de atributos y comandos estandarizados. Ej: On/Off (0x0006), Level Control (0x0008), Color Control (0x0300), Temperature Measurement (0x0402), IAS Zone (0x0500)
- **Binding**: Enlace lógico entre clusters de diferentes dispositivos. Un switch puede estar bindeado a una bombilla (On/Off cluster)
- **Grupos (Groups)**: Direccionamiento multicast. Un grupo de bombillas recibe comandos simultáneamente
- **Zigbee 3.0**: Estándar unificado (2016). Interoperabilidad entre perfiles ZHA, ZLL, ZSE. Seguridad mejorada (instal code, link key)
- **Green Power**: Dispositivos sin batería que recolectan energía (solar, piezoeléctrica, térmica). No necesitan unirse a la red, envían tramas directamente
- **OTA (Over-The-Air)**: Actualización de firmware de dispositivos Zigbee mediante clusters OTA Upgrade (0x0019)

## Ejemplo: Configuración de cluster On/Off (ZCL)

```c
// Ejemplo conceptual usando ZCL (Zigbee Cluster Library)
typedef struct {
    uint8_t on_off;      // 0=off, 1=on
    uint8_t global_scene;
    uint16_t on_time;
    uint16_t off_wait_time;
} on_off_server_t;

// Atributos del cluster On/Off (server side)
static on_off_server_t onoff_attr = { .on_off = 0 };

void zcl_onoff_toggle(void) {
    onoff_attr.on_off = !onoff_attr.on_off;
    // Actualizar hardware GPIO
    HAL_GPIO_WritePin(LED_GPIO, onoff_attr.on_off);
    // Reportar cambio a los bindings
    zcl_report_attr(ZCL_CLUSTER_ON_OFF, ZCL_ATTR_ON_OFF, &onoff_attr.on_off, 1);
}

// Manejo de comandos entrantes
uint8_t zcl_onoff_command_handler(uint8_t cmd) {
    switch (cmd) {
        case ZCL_CMD_OFF:     onoff_attr.on_off = 0; break;
        case ZCL_CMD_ON:      onoff_attr.on_off = 1; break;
        case ZCL_CMD_TOGGLE:  onoff_attr.on_off ^= 1; break;
        default: return ZCL_STATUS_UNSUP_CMD;
    }
    HAL_GPIO_WritePin(LED_GPIO, onoff_attr.on_off);
    return ZCL_STATUS_SUCCESS;
}
```

## Tecnologías principales

| Componente | Descripción |
|------------|-------------|
| NXP JN5189/88 | SoC Zigbee 3.0 de bajo consumo |
| Silicon Labs EFR32 | SoC multiprotocolo (Zigbee, Thread, BLE) |
| TI CC2530/CC2652 | SoCs Zigbee muy utilizados |
| Espressif ESP32-H2 | Zigbee/Thread/Matter con RISC-V |
| Zigbee2MQTT | Bridge Zigbee ↔ MQTT (popular en Home Assistant) |
| ZHA (Home Assistant) | Integración Zigbee nativa en Home Assistant |
| deCONZ | Software gateway Zigbee (Conbee/Phoscon) |
| Ubisys / IKEA / Philips Hue | Fabricantes de dispositivos Zigbee |

## Stack Zigbee vs Thread/Matter

| Característica | Zigbee 3.0 | Thread (Matter) |
|---------------|------------|-----------------|
| Estándar IEEE | 802.15.4 | 802.15.4 |
| Topología | Mesh | Mesh |
| Tasa | 250 kbps | 250 kbps |
| IP nativo | No | Sí (6LoWPAN) |
| Seguridad | AES-128 (APS layer) | AES-128 + IPsec |
| Perfiles | ZCL clusters | Matter data model |
| Interoperabilidad | Buena (Zigbee 3.0) | Excelente (multi-vendor) |
| Madurez | Muy maduro (2005+) | En crecimiento (2019+) |

## Buenas prácticas

- Usar Zigbee 3.0 para garantizar interoperabilidad entre dispositivos de diferentes fabricantes
- Configurar install code en la incorporación de nuevos dispositivos para seguridad (out-of-band)
- Implementar binding entre interruptores y actuadores para funcionamiento sin gateway
- Usar Green Power para sensores en ubicaciones sin acceso a batería
- Diseñar red mesh con routers de línea eléctrica (mains-powered) y end devices a batería
- Evitar más de 3 saltos (hops) en malla para mantener latencia baja
- Usar Zigbee2MQTT para integrar dispositivos Zigbee con sistemas modernos (Home Assistant, Node-RED)
- Para nuevos desarrollos, evaluar Matter (basado en Thread) como alternativa más interoperable
