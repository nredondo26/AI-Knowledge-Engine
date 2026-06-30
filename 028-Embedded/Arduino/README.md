# Arduino — Embedded Systems

## Visión General

Arduino es una plataforma de prototipado electrónico open-source basada en microcontroladores ATMega (AVR) y ARM. El entorno de desarrollo (Arduino IDE) simplifica la programación en C++ para aplicaciones embebidas.

## Hardware Común

| Placa | MCU | Flash | SRAM | Pines I/O | Voltaje |
|-------|-----|-------|------|-----------|---------|
| Uno R3 | ATmega328P | 32 KB | 2 KB | 14 digital, 6 analog | 5V |
| Nano | ATmega328P | 32 KB | 2 KB | 22 pines | 5V |
| Mega 2560 | ATmega2560 | 256 KB | 8 KB | 54 digital, 16 analog | 5V |
| Leonardo | ATmega32U4 | 32 KB | 2.5 KB | 20 pines | 5V |
| Due | ATSAM3X8E (ARM) | 512 KB | 96 KB | 54 digital, 12 analog | 3.3V |
| RP2040 | Raspberry Pi RP2040 | 16 MB | 264 KB | 26 pines | 3.3V |

## Estructura de un Sketch

```cpp
// Blink — Hello World de Arduino

const int LED_PIN = 13;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  digitalWrite(LED_PIN, HIGH);
  delay(1000);
  digitalWrite(LED_PIN, LOW);
  delay(1000);
}
```

## Lectura de Sensor Analógico

```cpp
const int SENSOR_PIN = A0;
const float VREF = 5.0;
const int ADC_RES = 1024;  // 10 bits

void setup() {
  Serial.begin(115200);
  analogReference(DEFAULT);
}

void loop() {
  int raw = analogRead(SENSOR_PIN);
  float voltage = (raw * VREF) / ADC_RES;
  float temperature = voltage * 100.0;  // LM35: 10mV/°C

  Serial.print("Raw: ");
  Serial.print(raw);
  Serial.print(" | Temp: ");
  Serial.println(temperature, 2);

  delay(500);
}
```

## Comunicación I2C (Wire)

```cpp
#include <Wire.h>

#define MPU6050_ADDR 0x68

void setup() {
  Wire.begin();
  Serial.begin(115200);

  Wire.beginTransmission(MPU6050_ADDR);
  Wire.write(0x6B);  // Power management register
  Wire.write(0x00);  // Wake up
  Wire.endTransmission();
}

void loop() {
  Wire.beginTransmission(MPU6050_ADDR);
  Wire.write(0x3B);  // Accel X high byte
  Wire.endTransmission(false);
  Wire.requestFrom(MPU6050_ADDR, 14, true);

  while (Wire.available() < 14);

  int16_t ax = Wire.read() << 8 | Wire.read();
  int16_t ay = Wire.read() << 8 | Wire.read();
  int16_t az = Wire.read() << 8 | Wire.read();

  Serial.print("Accel: ");
  Serial.print(ax); Serial.print(", ");
  Serial.print(ay); Serial.print(", ");
  Serial.println(az);

  delay(100);
}
```

## Comunicación SPI

```cpp
#include <SPI.h>

const int CS_PIN = 10;

void setup() {
  SPI.begin();
  pinMode(CS_PIN, OUTPUT);
  digitalWrite(CS_PIN, HIGH);
  Serial.begin(9600);
}

uint8_t readRegister(uint8_t reg) {
  digitalWrite(CS_PIN, LOW);
  SPI.transfer(reg | 0x80);  // Read bit
  uint8_t value = SPI.transfer(0x00);
  digitalWrite(CS_PIN, HIGH);
  return value;
}

void writeRegister(uint8_t reg, uint8_t value) {
  digitalWrite(CS_PIN, LOW);
  SPI.transfer(reg & 0x7F);  // Write bit
  SPI.transfer(value);
  digitalWrite(CS_PIN, HIGH);
}
```

## Interrupciones

```cpp
volatile unsigned long pulseCount = 0;
const int IRQ_PIN = 2;

void setup() {
  pinMode(IRQ_PIN, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(IRQ_PIN), onPulse, FALLING);
  Serial.begin(115200);
}

void loop() {
  noInterrupts();
  unsigned long count = pulseCount;
  interrupts();

  Serial.print("Pulsos: ");
  Serial.println(count);
  delay(1000);
}

void onPulse() {
  pulseCount++;
}
```

## PWM (Pulse Width Modulation)

```cpp
const int MOTOR_PIN = 9;   // Pin compatible con PWM (~)

void setup() {
  pinMode(MOTOR_PIN, OUTPUT);
}

void loop() {
  // Aceleración progresiva
  for (int duty = 0; duty <= 255; duty++) {
    analogWrite(MOTOR_PIN, duty);
    delay(10);
  }
  for (int duty = 255; duty >= 0; duty--) {
    analogWrite(MOTOR_PIN, duty);
    delay(10);
  }
}
```

## FreeRTOS en Arduino (ESP32/ARM)

```cpp
#include <FreeRTOS.h>
#include <task.h>

void readSensor(void *param) {
  while (1) {
    // Leer sensor
    vTaskDelay(pdMS_TO_TICKS(100));
  }
}

void sendData(void *param) {
  while (1) {
    // Enviar por serial/WiFi
    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}

void setup() {
  xTaskCreatePinnedToCore(readSensor, "Sensor", 2048, NULL, 1, NULL, 0);
  xTaskCreatePinnedToCore(sendData, "Sender", 2048, NULL, 1, NULL, 1);
}
```

## Ahorro de Energía (Sleep Modes)

```cpp
#include <avr/sleep.h>
#include <avr/power.h>

void enterSleep() {
  set_sleep_mode(SLEEP_MODE_PWR_DOWN);
  sleep_enable();
  sleep_mode();
  sleep_disable();
  power_all_enable();
}

void setup() {
  pinMode(2, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(2), wakeUp, LOW);
}

void loop() {
  delay(5000);  // 5s de trabajo
  enterSleep(); // Sleep profundo
}

void wakeUp() {
  // ISR vacío, solo despierta
}
```

## Depuración con Serial

```cpp
#define DEBUG 1

#if DEBUG
  #define LOG(x) Serial.print(x)
  #define LOGLN(x) Serial.println(x)
#else
  #define LOG(x)
  #define LOGLN(x)
#endif
```

## Librerías Comunes

| Librería | Propósito |
|----------|-----------|
| Wire | Comunicación I2C |
| SPI | Comunicación SPI |
| SD | Tarjetas SD |
| WiFi | ESP8266/ESP32 WiFi |
| Ethernet | W5100/W5500 |
| SDL_Arduino_INA3221 | Medición de corriente |
| Adafruit_SSD1306 | Display OLED |
| DHT sensor | Temperatura/humedad |
| Servo | Control de servomotores |
| Stepper | Motores paso a paso |
| EEPROM | Almacenamiento no volátil |
| ArduinoJson | Parsing JSON |
| PubSubClient | MQTT client |

## Optimización de Memoria

```cpp
// PROGMEM: almacenar constantes en flash en lugar de SRAM
const char msg[] PROGMEM = "Mensaje largo en flash";

// F() macro para strings en flash
Serial.println(F("Esto no ocupa SRAM"));
```

## Referencias

- [Arduino Official](https://www.arduino.cc/)
- [Arduino Language Reference](https://www.arduino.cc/reference/en/)
- [Arduino Project Hub](https://projecthub.arduino.cc/)
- [AVR Libc](https://www.nongnu.org/avr-libc/user-manual/)
