# ESP32 — Microcontrolador IoT

## Visión General

ESP32 es un microcontrolador de Espressif Systems con WiFi y Bluetooth integrados. Basado en CPU Xtensa LX6 dual-core, es el estándar de facto para proyectos IoT que requieren conectividad inalámbrica.

## Especificaciones Técnicas

| Parámetro | Valor |
|-----------|-------|
| CPU | Xtensa dual-core 32-bit LX6 @ 240 MHz |
| SRAM | 520 KB + 4 MB PSRAM (según modelo) |
| Flash | 4-16 MB SPI flash |
| WiFi | 802.11 b/g/n (2.4 GHz), HT40 |
| Bluetooth | BR/EDR + BLE v4.2 |
| GPIO | 34 pines programables |
| ADC | 2 SAR ADC de 12 bits, 18 canales |
| DAC | 2 canales de 8 bits |
| Interfaces | UART, SPI, I2C, I2S, CAN, SDIO, Ethernet MAC |
| Temperatura | -40°C ~ 85°C |
| Consumo | 5 µA en deep sleep |

## Entornos de Desarrollo

### ESP-IDF (Framework oficial)

```c
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "esp_log.h"

#define BLINK_GPIO GPIO_NUM_2
static const char *TAG = "blink";

void app_main(void) {
    gpio_reset_pin(BLINK_GPIO);
    gpio_set_direction(BLINK_GPIO, GPIO_MODE_OUTPUT);

    while (1) {
        ESP_LOGI(TAG, "Encendiendo LED");
        gpio_set_level(BLINK_GPIO, 1);
        vTaskDelay(1000 / portTICK_PERIOD_MS);

        ESP_LOGI(TAG, "Apagando LED");
        gpio_set_level(BLINK_GPIO, 0);
        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
}
```

### Arduino Core para ESP32

```cpp
#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "MiWiFi";
const char* password = "contraseña";

WebServer server(80);

void handleRoot() {
  String html = "<h1>ESP32 Web Server</h1>";
  html += "<p>GPIO 2: ";
  html += digitalRead(2) ? "HIGH" : "LOW";
  html += "</p>";
  html += "<a href='/toggle'>Toggle LED</a>";
  server.send(200, "text/html", html);
}

void handleToggle() {
  digitalWrite(2, !digitalRead(2));
  server.sendHeader("Location", "/");
  server.send(303);
}

void setup() {
  Serial.begin(115200);
  pinMode(2, OUTPUT);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConectado, IP: " + WiFi.localIP().toString());

  server.on("/", handleRoot);
  server.on("/toggle", handleToggle);
  server.begin();
}

void loop() {
  server.handleClient();
}
```

### MicroPython

```python
import network
import machine
import time
import urequests
import json

led = machine.Pin(2, machine.Pin.OUT)

def connect_wifi():
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect("MiWiFi", "contraseña")
    while not wlan.isconnected():
        time.sleep(1)
    print("Conectado:", wlan.ifconfig())

def send_data(temperature, humidity):
    data = json.dumps({
        "temp": temperature,
        "hum": humidity,
        "device": "esp32-001"
    })
    headers = {"Content-Type": "application/json"}
    resp = urequests.post("http://api.example.com/sensors",
                         data=data, headers=headers)
    print(resp.status_code)
    resp.close()

connect_wifi()
led.on()
```

## WiFi y Conexiones

```cpp
// Escaneo de redes
#include "esp_wifi.h"

void scan_networks() {
    uint16_t ap_count = 0;
    esp_wifi_scan_start(NULL, true);
    esp_wifi_scan_get_ap_num(&ap_count);

    wifi_ap_record_t *list = malloc(ap_count * sizeof(wifi_ap_record_t));
    esp_wifi_scan_get_ap_records(&ap_count, list);

    for (int i = 0; i < ap_count; i++) {
        printf("SSID: %s, RSSI: %d, CH: %d\n",
               list[i].ssid, list[i].rssi, list[i].primary);
    }

    free(list);
}
```

## BLE (Bluetooth Low Energy)

```cpp
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define SERVICE_UUID        "12345678-1234-1234-1234-123456789abc"
#define CHARACTERISTIC_UUID "87654321-4321-4321-4321-cba987654321"

BLECharacteristic *pCharacteristic;
bool deviceConnected = false;

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        deviceConnected = true;
    }
    void onDisconnect(BLEServer* pServer) {
        deviceConnected = false;
    }
};

void setupBLE() {
    BLEDevice::init("ESP32_Sensor");
    BLEServer *pServer = BLEDevice::createServer();
    pServer->setCallbacks(new MyServerCallbacks());

    BLEService *pService = pServer->createService(SERVICE_UUID);
    pCharacteristic = pService->createCharacteristic(
        CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ |
        BLECharacteristic::PROPERTY_NOTIFY
    );
    pCharacteristic->addDescriptor(new BLE2902());
    pService->start();

    BLEAdvertising *pAdvertising = pServer->getAdvertising();
    pAdvertising->start();
}
```

## Deep Sleep (Ahorro de Energía)

```cpp
#include "esp_sleep.h"

#define WAKEUP_PIN GPIO_NUM_4
#define uS_TO_S_FACTOR 1000000ULL
#define SLEEP_INTERVAL 3600  // 1 hora

void setup() {
    Serial.begin(115200);

    // Configurar wakeup por timer
    esp_sleep_enable_timer_wakeup(SLEEP_INTERVAL * uS_TO_S_FACTOR);

    // Wakeup por GPIO (opcional)
    esp_sleep_enable_ext0_wakeup(WAKEUP_PIN, 0);

    Serial.println("Entrando en deep sleep...");
    esp_deep_sleep_start();
}

void loop() {
    // Nunca se ejecuta
}
```

## ADC (Conversión Analógica-Digital)

```cpp
#include "driver/adc.h"
#include "esp_adc_cal.h"

static esp_adc_cal_characteristics_t adc_chars;

void init_adc() {
    adc1_config_width(ADC_WIDTH_BIT_12);
    adc1_config_channel_atten(ADC1_CHANNEL_0, ADC_ATTEN_DB_11);
    esp_adc_cal_characterize(ADC_UNIT_1, ADC_ATTEN_DB_11,
                             ADC_WIDTH_BIT_12, 1100, &adc_chars);
}

float read_voltage() {
    uint32_t raw = adc1_get_raw(ADC1_CHANNEL_0);
    uint32_t mv = esp_adc_cal_raw_to_voltage(raw, &adc_chars);
    return mv / 1000.0f;
}
```

## Over-The-Air (OTA) Updates

```cpp
#include "esp_ota_ops.h"
#include "esp_http_client.h"

void perform_ota(const char *firmware_url) {
    esp_http_client_config_t config = {
        .url = firmware_url,
        .cert_pem = NULL,
    };

    esp_http_client_handle_t client = esp_http_client_init(&config);
    esp_ota_handle_t ota_handle;
    const esp_partition_t *update_partition = esp_ota_get_next_update_partition(NULL);

    esp_ota_begin(update_partition, OTA_SIZE_UNKNOWN, &ota_handle);

    char buffer[1024];
    int bytes_read;
    while ((bytes_read = esp_http_client_read(client, buffer, sizeof(buffer))) > 0) {
        esp_ota_write(ota_handle, buffer, bytes_read);
    }

    esp_ota_end(ota_handle);
    esp_ota_set_boot_partition(update_partition);
    esp_restart();
}
```

## Periféricos Comunes

| Periférico | Protocolo | Librería |
|------------|-----------|----------|
| DHT22 (temp/hum) | OneWire | DHT sensor library |
| BME280 (temp/pres/hum) | I2C | Adafruit BME280 |
| MPU6050 (IMU) | I2C | MPU6050.h |
| SSD1306 (OLED) | I2C | Adafruit SSD1306 |
| MAX31865 (PT100) | SPI | Adafruit MAX31865 |
| RC522 (RFID) | SPI | MFRC522 |
| WS2812B (LEDs) | OneWire | FastLED, NeoPixel |

## FreeRTOS en ESP-IDF

```c
void sensor_task(void *pvParameters) {
    while (1) {
        // Leer sensor
        vTaskDelay(pdMS_TO_TICKS(100));
    }
}

void wifi_task(void *pvParameters) {
    while (1) {
        // Gestionar WiFi
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

void app_main(void) {
    xTaskCreatePinnedToCore(sensor_task, "sensor", 4096, NULL, 5, NULL, 0);
    xTaskCreatePinnedToCore(wifi_task, "wifi", 4096, NULL, 5, NULL, 1);
}
```

## Referencias

- [ESP-IDF Programming Guide](https://docs.espressif.com/projects/esp-idf/en/latest/)
- [Arduino ESP32 Core](https://github.com/espressif/arduino-esp32)
- [ESP32 Datasheet](https://www.espressif.com/sites/default/files/documentation/esp32_datasheet_en.pdf)
- [FreeRTOS for ESP32](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/system/freertos.html)
- [MicroPython ESP32](https://docs.micropython.org/en/latest/esp32/quickref.html)
