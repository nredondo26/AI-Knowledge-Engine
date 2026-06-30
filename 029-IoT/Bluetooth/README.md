# Bluetooth — Tecnología de Comunicación Inalámbrica

## Descripción del dominio

Bluetooth es una tecnología de comunicación inalámbrica de corto alcance que opera en la banda ISM de 2.4 GHz. Existen dos variantes principales: Bluetooth Classic (BR/EDR, para audio y transferencia de archivos) y Bluetooth Low Energy (BLE o Bluetooth Smart, para IoT y dispositivos de bajo consumo). BLE se ha convertido en el estándar dominante para wearables, beacons, sensores IoT, dispositivos médicos, domótica y localización en interiores. El stack Bluetooth incluye capas: PHY/Radio, Link Layer, HCI, L2CAP, GATT, GAP, y perfiles estandarizados.

## Áreas clave

- **Bluetooth Classic (BR/EDR)**: Tasa hasta 3 Mbps (EDR), consumo mayor, utilizado para auriculares, altavoces, teclados, ratones. Perfiles: A2DP (audio), HFP (manos libres), SPP (serial), HID (human interface)
- **Bluetooth Low Energy (BLE)**: Consumo ultra bajo (0.01-0.5 mA promedio), tasa hasta 2 Mbps (LE 2M PHY). Ideal para sensores, beacons, wearables. Arquitectura: GAP (roles: Central/Peripheral, Broadcaster/Observer) + GATT (cliente/servidor, servicios y características)
- **GAP (Generic Access Profile)**: Define roles de dispositivo, modos de descubrimiento y conexión. Advertising (broadcast), scanning, initiating, connection
- **GATT (Generic Attribute Profile)**: Define cómo se estructuran los datos en servicios, características y descriptores. UUIDs estándar (16-bit) vs personalizados (128-bit)
- **Advertising**: Paquetes broadcast periódicos que anuncian presencia y datos. Extended Advertising (BLE 5.0) para más datos (hasta 1650 bytes)
- **BLE 5.x**: BLE 5.0 (2M PHY, Long Range/CODED PHY, Extended Advertising, Mesh), BLE 5.1 (Direction Finding/AoA/AoD), BLE 5.2 (LE Audio, Isochronous channels), BLE 5.3–5.4 (mejoras de rendimiento)
- **Bluetooth Mesh**: Topología de malla para IoT. Nodos relay, proxy, friend, low-power. Publicación/suscripción, modelos (servidor/cliente). Basado en BLE advertising bearer
- **Seguridad**: LE Legacy Pairing (TK), LE Secure Connections (ECDH, AES-CCM), Numeric Comparison, Passkey Entry, Out of Band (NFC). Bluetooth Classic: SSP (Secure Simple Pairing)
- **Perfiles BLE comunes**: HTS (Health Thermometer), BPM (Blood Pressure), HID over GATT, ANP (Alert Notification), PXP (Proximity), iBeacon/Eddystone (beacons), BAS (Battery Service)

## Ejemplo: Servicio GATT personalizado (nRF5 SDK)

```c
// Definición de servicio y característica
BLE_UUID_DEF(m_custom_service_uuid, 0x180D); // UUID 16-bit
BLE_UUID_DEF(m_custom_char_uuid, 0x2A37);    // Heart Rate Measurement

ble_uuid_t ble_uuid;
ble_uuid.type = BLE_UUID_TYPE_BLE;
ble_uuid.uuid = 0x180D;

// Añadir servicio
sd_ble_gatts_service_add(BLE_GATTS_SRVC_TYPE_PRIMARY, &ble_uuid, &m_service_handle);

// Añadir característica con notificación
ble_gatts_char_md_t char_md = {0};
char_md.char_props.notify = 1;

ble_gatts_attr_md_t attr_md = {0};
attr_md.vloc = BLE_GATTS_VLOC_STACK;

ble_gatts_attr_t attr = {0};
attr.p_uuid = &m_custom_char_uuid;
attr.p_attr_md = &attr_md;
attr.max_len = 2;

sd_ble_gatts_characteristic_add(m_service_handle, &char_md, &attr, &m_char_handle);
```

## Tecnologías principales

| Plataforma | SDK / Stack | Lenguaje |
|------------|------------|----------|
| Nordic nRF52/53 | nRF5 SDK, nRF Connect SDK (Zephyr) | C, C++ |
| ESP32 | ESP-IDF (Bluedroid, NimBLE) | C |
| TI CC2640/CC2650 | TI BLE-Stack | C |
| Cypress PSoC 6 | WICED Bluetooth | C |
| Android | android.bluetooth (Java/Kotlin) | Java/Kotlin |
| iOS | Core Bluetooth (Swift/ObjC) | Swift/ObjC |
| Python | Bleak, PyBluez | Python |
| Node.js | noble, bleno | JavaScript |

## Ejemplo: Escáner BLE en Python con Bleak

```python
import asyncio
from bleak import BleakScanner

async def main():
    devices = await BleakScanner.discover(timeout=5.0)
    for d in devices:
        print(f"Nombre: {d.name}, Dirección: {d.address}, RSSI: {d.rssi}")

asyncio.run(main())
```

## Buenas prácticas

- Preferir BLE sobre Classic para nuevos desarrollos IoT (menor consumo, mayor flexibilidad)
- Usar GATT services con UUIDs estándar siempre que sea posible (interoperabilidad)
- Para advertising, mantener el payload mínimo (menos de 31 bytes si no hay extended advertising)
- Implementar LE Secure Connections (BLE 4.2+) en lugar de Legacy Pairing
- En BLE Mesh, usar Friend Node para dispositivos de bajo consumo que necesiten dormir
- Para localización, usar Direction Finding (BLE 5.1) con matriz de antenas (AoA/AoD)
- Optimizar el intervalo de conexión (connection interval) según latencia y consumo deseados
- Usar Data Length Extension (DLE) y 2M PHY para mayor throughput en transferencias de datos
