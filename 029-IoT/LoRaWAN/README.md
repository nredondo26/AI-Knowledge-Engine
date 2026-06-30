# LoRaWAN — Redes IoT de Larga Distancia

## Visión General

LoRaWAN es un protocolo de red LPWAN (Low Power Wide Area Network) diseñado para dispositivos IoT de baja tasa de datos, largo alcance (>10 km en campo abierto) y ultra bajo consumo. Opera en bandas ISM sub-GHz (868 MHz Europa, 915 MHz América).

## Arquitectura de Red

```
┌──────────┐    LoRa RF     ┌──────────┐    IP     ┌──────────────┐
│ Sensor   │ ◀────────────▶ │ Gateway  │ ────────▶ │ Network      │
│ (End     │                │ (Concentrador)│       │ Server (NS)  │
│ Device)  │                │          │          │ (ChirpStack,│
└──────────┘                └──────────┘          │  TTN)       │
     ▲                                             └──────┬───────┘
     │ LoRa RF                                            │ HTTP/MQTT
     ▼                                                    ▼
┌──────────┐                                      ┌──────────────┐
│ Sensor   │                                      │ Application  │
│ (End     │                                      │ Server       │
│ Device)  │                                      │ (Dashboard)  │
└──────────┘                                      └──────────────┘
```

## Clases de Dispositivo

| Clase | Downlink | Consumo | Uso típico |
|-------|----------|---------|------------|
| **A** | Solo tras uplink (RX1/RX2) | Mínimo | Sensores con batería |
| **B** | Ventanas programadas (beacon) | Medio | Actuadores con schedule |
| **C** | Escucha continua | Alto | Actuadores en tiempo real |

### Clase A — Frame Completo

```
Uplink (End Device → Gateway)
  ↓
RX1 Delay (1s por defecto)
  ↓
RX1 Window (SF igual al uplink)
  ↓
RX2 Delay (2s)
  ↓
RX2 Window (SF12, frecuencia fija)
```

## Parámetros del Enlace (Spreading Factor)

| SF | Bits/símbolo | SNR mínimo | Rango aprox. | Tiempo en aire (51 bytes) |
|----|-------------|------------|--------------|--------------------------|
| SF7 | 4 | -7.5 dB | 2 km | 41 ms |
| SF8 | 5 | -10 dB | 4 km | 72 ms |
| SF9 | 6 | -12.5 dB | 6 km | 132 ms |
| SF10 | 7 | -15 dB | 8 km | 247 ms |
| SF11 | 8 | -17.5 dB | 10 km | 453 ms |
| SF12 | 9 | -20 dB | 14 km | 991 ms |

### Duty Cycle (Europa, 868 MHz)

| Sub-banda | Límite | Aplicación |
|-----------|--------|------------|
| 868.0-868.6 MHz | 1% | G1 (ej. SF7-12) |
| 868.7-869.2 MHz | 0.1% | G2 (SF9-12) |
| 869.4-869.65 MHz | 10% | G3 (SF9-12, alta duty) |

## Payload y Formato

```
┌─────┬────────┬──────┬──────┬──────┬──────┐
│ MHDR│ DevAddr│FCtrl │FCnt  │FOpts │FPort │
│ 1B  │  4B    │ 1B   │ 2B   │0-15B │ 1B   │
├─────┴────────┴──────┴──────┴──────┴──────┤
│            FRMPayload (max 51B SF7,       │
│             222B SF12 en 2s)             │
├─────┬────────────────────────────────────┤
│ MIC │                                     │
│ 4B  │                                     │
└─────┴─────────────────────────────────────┘
```

## The Things Network (TTN) — Configuración

```yaml
# device_config.yaml
application:
  id: temperatura-sensor
  name: Sensores de Temperatura

device:
  dev_eui: "70B3D57ED8000001"
  app_eui: "0000000000000000"
  app_key: "A1B2C3D4E5F6A7B8C9D0E1F2A3B4C5D6"
  frequency_plan: EU_863_870
  lorawan_version: 1.0.3
  class: A
  activation: OTAA

payload_format:
  type: custom
  converter: |
    function decodeUplink(input) {
      return {
        data: {
          temperature: (input.bytes[0] << 8 | input.bytes[1]) / 100.0,
          humidity: input.bytes[2],
          battery: input.bytes[3] * 0.05 + 2.5
        }
      };
    }
```

## ChirpStack — Network Server

```toml
# chirpstack.toml (configuración típica)
[general]
log_level = "info"

[integration.mqtt]
type = "mqtt"
marshaler = "json"
server = "tcp://localhost:1883"
event_topic_template = "application/{{ .ApplicationID }}/event/{{ .EventType }}"
command_topic_template = "application/{{ .ApplicationID }}/command/{{ .DeviceDevEUI }}"

[network.network]
enabled = true
band = "EU868"
```

## Dispositivo LoRa con ESP32 (Heltec / TTGO)

```cpp
#include <LoRa.h>
#include <CayenneLPP.h>

#define SS 18
#define RST 14
#define DIO0 26

CayenneLPP lpp(51);

void setup() {
  Serial.begin(115200);
  LoRa.setPins(SS, RST, DIO0);

  if (!LoRa.begin(868E6)) {
    Serial.println("Error iniciando LoRa");
    while (1);
  }

  LoRa.setSpreadingFactor(12);
  LoRa.setTxPower(20);
  LoRa.setSyncWord(0x34);
}

void loop() {
  lpp.reset();
  lpp.addTemperature(0, 22.5);
  lpp.addRelativeHumidity(1, 60);
  lpp.addBarometricPressure(2, 1013.25);

  LoRa.beginPacket();
  LoRa.write(lpp.getBuffer(), lpp.getSize());
  LoRa.endPacket();

  Serial.println("Paquete enviado");
  delay(60000);  // 1 minuto entre transmisiones
}
```

## Decodificación de Payload (CayenneLPP)

```javascript
function decodeCayenneLPP(bytes, port) {
  var decoded = {};
  var i = 0;

  while (i < bytes.length) {
    var channel = bytes[i++];
    var type = bytes[i++];
    var value;

    switch (type) {
      case 0x00: // Digital Input
        value = bytes[i] << 8 | bytes[i+1];
        i += 2;
        break;
      case 0x01: // Digital Output
        value = bytes[i] << 8 | bytes[i+1];
        i += 2;
        break;
      case 0x66: // Luminosity
        value = bytes[i] << 8 | bytes[i+1];
        i += 2;
        break;
      case 0x67: // Presence
        value = bytes[i];
        i += 1;
        break;
      case 0x68: // Temperature
        value = (bytes[i] << 8 | bytes[i+1]) / 10.0;
        i += 2;
        break;
      case 0x71: // Barometric Pressure
        value = (bytes[i] << 8 | bytes[i+1]) / 10.0;
        i += 2;
        break;
      default:
        return { error: "Unknown type: " + type };
    }

    decoded["channel_" + channel] = value;
  }

  return decoded;
}
```

## OTAA vs ABP

### OTAA (Over-The-Air Activation) — Recomendado

```
End Device ── Join Request ──▶ Network Server
  (DevEUI, AppEUI, DevNonce)
End Device ◀── Join Accept ── Network Server
  (DevAddr, NwkSKey, AppSKey)
```

### ABP (Activation By Personalization)

```cpp
// Configuración ABP (menos segura, sin join)
static const uint8_t devAddr[] = { 0x26, 0x01, 0x2A, 0x3B };
static const uint8_t nwkSKey[] = { 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                                   0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E,
                                   0x0F, 0x10 };
static const uint8_t appSKey[] = { /* similar 16 bytes */ };
```

## Cálculo de Batería

```python
# Estimación de vida de batería (2x AA, 2000 mAh)
current_tx = 120  # mA durante transmisión
current_rx = 10   # mA en recepción
current_sleep = 0.002  # 2 µA en sleep
tx_time = 0.1  # 100 ms
interval = 3600  # 1 hora

charge_per_cycle = (current_tx * tx_time + current_rx * 2 + current_sleep * interval) / 3600  # mAh
cycles = 2000 / charge_per_cycle
battery_life_years = cycles * interval / (365.25 * 24 * 3600)
print(f"Vida estimada: {battery_life_years:.1f} años")
```

## Gateways

| Gateway | Canales | Precio | Ideal para |
|---------|---------|--------|------------|
| Dragino LPS8 | 8 | ~$200 | Indoor, redes pequeñas |
| RAK7249 | 16 | ~$400 | Outdoor, alcance extendido |
| Kerlink iBTS | - | ~$800 | Industrial, carrier-grade |
| Multitech Conduit | 8 | ~$500 | Enterprise con LTE backup |
| DIY (SX1302 + RPi) | 8 | ~$100 | Prototipado, hobby |

## LoRaWAN vs NB-IoT vs Sigfox

| Característica | LoRaWAN | NB-IoT (3GPP) | Sigfox |
|---------------|---------|---------------|--------|
| Frecuencia | ISM (868/915 MHz) | LTE licenciado | ISM (868/915 MHz) |
| Alcance | 2-15 km | 1-10 km | 3-50 km |
| Throughput | 0.3-50 kbps | 20-200 kbps | 100 bps |
| Consumo | Muy bajo | Medio | Ultra bajo |
| Bidireccional | Sí (limitado) | Sí | Limitado (downlink caro) |
| Costo módulo | $2-5 | $5-10 | $1-3 |
| Red propia | Sí | No (operador) | No (operador) |

## Referencias

- [LoRa Alliance](https://lora-alliance.org/)
- [LoRaWAN 1.1 Specification](https://lora-alliance.org/wp-content/uploads/2020/11/lorawan1.1.pdf)
- [The Things Network](https://www.thethingsnetwork.org/)
- [ChirpStack](https://www.chirpstack.io/)
- [CayenneLPP](https://github.com/ElectronicCats/CayenneLPP)
- [Semtech LoRa Calculator](https://www.semtech.com/products/wireless-rf/lora-core/lora-calculator)
