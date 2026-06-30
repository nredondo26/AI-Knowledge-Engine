# Sensores — Dispositivos de Medición IoT

## Descripción del dominio

Los sensores son dispositivos que convierten magnitudes físicas del entorno (temperatura, presión, luz, movimiento, sonido, etc.) en señales eléctricas medibles por un sistema electrónico. Son los "ojos y oídos" de los sistemas IoT, proporcionando los datos crudos que alimentan la lógica de control, monitoreo, analítica y ML. Este módulo cubre los tipos principales de sensores, sus interfaces de comunicación (analógica, I2C, SPI, digital), técnicas de acondicionamiento de señal, calibración, filtrado digital y estrategias de bajo consumo para sensores IoT.

## Áreas clave

- **Sensores de temperatura**: Termistores (NTC/PTC), RTD (PT100/PT1000), termopares (Tipo K, J, T), digitales (DS18B20, DHT22, SHT30, BMP280, BME280). Exactitud, precisión, rango, tiempo de respuesta
- **Sensores de presión**: MEMS (barométricos BMP390, LPS22), manométricos, diferenciales, absolutos. Aplicaciones: altitud, meteorología, neumática, nivel de líquidos
- **Sensores de humedad**: Capacitivos (HR202), resistivos, digitales (DHT22, SHT30, BME280). Precisión típica ±2-5% HR
- **Sensores de movimiento e inerciales**: Acelerómetros (ADXL345, MPU6050), giróscopos, IMUs (MPU9250, ICM-20948), magnetómetros (HMC5883L). Filtro complementario o Madgwick para fusión de sensores
- **Sensores ópticos**: Foto-resistencias (LDR), fotodiodos, sensores de luz ambiental (BH1750, TSL2561), sensores de color (TCS3472), sensores de proximidad (VL53L0X/ToF), cámaras (OV2640, Arducam)
- **Sensores de distancia**: Ultrasonido (HC-SR04), infrarrojo (GP2Y0A21), LiDAR (TFMini, VL53L1X), Time-of-Flight (ToF)
- **Sensores de gas**: MQ-2 (humo/GNL), MQ-135 (calidad del aire), CCS811 (CO2/VOC), SGP30 (VOC/eCO2)
- **Sensores de corriente/voltaje**: ACS712/ACS758 (efecto Hall), INA219/INA3221 (monitoreo de potencia), divisores resistivos para voltaje
- **Sensores de sonido**: Micrófonos electret (MAX9814, MAX4466), MEMS (SPH0645, INMP441), detección de nivel, FFT para análisis espectral
- **Acondicionamiento de señal**: Amplificación (op-amps), filtrado analógico (RC, Sallen-Key), ADC (resolución, sampling rate, referencia de voltaje), PGA (Programmable Gain Amplifier)

## Ejemplo: Lectura de sensor SHT30 (temperatura + humedad) con I2C

```c
#include <Wire.h>

#define SHT30_ADDR 0x44

void sht30_read(float *temp, float *hum) {
    // Comando de medición single shot (high repeatability)
    Wire.beginTransmission(SHT30_ADDR);
    Wire.write(0x2C); Wire.write(0x06);
    Wire.endTransmission();
    delay(20); // Esperar medición

    Wire.requestFrom(SHT30_ADDR, 6);
    if (Wire.available() < 6) return;

    uint16_t raw_temp = (Wire.read() << 8) | Wire.read();
    Wire.read(); // CRC saltado
    uint16_t raw_hum  = (Wire.read() << 8) | Wire.read();
    
    *temp = -45 + 175.0 * raw_temp / 65535.0;
    *hum  = 100.0 * raw_hum / 65535.0;
}
```

## Ejemplo: Filtro de media móvil para suavizar lecturas

```c
#define WINDOW_SIZE 10

typedef struct {
    float buffer[WINDOW_SIZE];
    uint8_t index;
    float sum;
} moving_avg_t;

float moving_average(moving_avg_t *ma, float sample) {
    ma->sum -= ma->buffer[ma->index];
    ma->buffer[ma->index] = sample;
    ma->sum += sample;
    ma->index = (ma->index + 1) % WINDOW_SIZE;
    return ma->sum / WINDOW_SIZE;
}
```

## Tecnologías principales

| Sensor | Interfaz | Precisión típica | Consumo |
|--------|----------|-----------------|---------|
| DS18B20 | 1-Wire | ±0.5°C | 1 mA |
| SHT30 | I2C | ±0.3°C, ±2% HR | 2 µA (idle) |
| BME280 | I2C/SPI | ±1°C, ±3% HR, ±1 hPa | 3.6 µA (idle) |
| MPU6050 | I2C | Acel ±3%, Giro ±1% | 3.5 mA |
| VL53L0X | I2C (ToF) | ±3% (hasta 2m) | 20 mA (activo) |
| HC-SR04 | GPIO (ultrasonido) | ±3 mm | 15 mA |
| INA219 | I2C | ±0.5% (corriente) | 1 mA |
| CCS811 | I2C | ±1% CO2 | 1.2 mA (idle) |
| ACS712 | Analógico | ±1.5% | 10 mA |

## Buenas prácticas

- Usar filtros digitales (media móvil, mediana, Kalman, complementario) para reducir ruido
- Calibrar sensores con referencia conocida; almacenar offset y ganancia en EEPROM
- Implementar detección de fallos (CRC, sanity checks, rango válido, stale data)
- Para batería, muestrear solo cuando sea necesario y dormir el sensor entre lecturas
- Usar interrupción por cambio de pin en lugar de polling para sensores de eventos (PIR, vibración)
- Desacoplar la fuente de alimentación de sensores analógicos (capacitor 100nF + 10µF)
- En I2C, usar pull-ups externos (2.2k–10k) y mantener cables cortos (<20 cm) para evitar ruido
- Para sensores industriales, usar RS-485 con protocolo Modbus RTU para largas distancias (>100m)
