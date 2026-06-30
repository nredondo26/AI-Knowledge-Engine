# 028-Embedded: Sistemas Embebidos

## Descripción ampliada del dominio

Los sistemas embebidos son sistemas informáticos especializados diseñados para realizar funciones dedicadas dentro de sistemas más grandes, con recursos limitados de computación, memoria y energía. Se encuentran en electrodomésticos, automóviles, equipos médicos, sistemas industriales, wearables, dispositivos IoT y electrónica de consumo. A diferencia de las computadoras de propósito general, los sistemas embebidos están optimizados para tareas específicas con restricciones de tiempo real, consumo energético y costo. La evolución: microcontroladores 8-bit (1970s, Intel 8048) → 16-bit/32-bit (1990s, ARM7, PIC) → sistemas embebidos conectados (2010s, IoT) → sistemas embebidos con AI (2020s, TinyML, edge AI). Los microcontroladores más comunes incluyen ARM Cortex-M (STM32, NXP, Raspberry Pi Pico), ESP32 (WiFi/BT integrado), AVR (Arduino), RISC-V (creciente). Para sistemas más complejos: ARM Cortex-A (Raspberry Pi, BeagleBone), x86 embebido (Intel Atom). La tendencia actual incluye TinyML (ML en microcontroladores), sistemas en chip (SoCs), RISC-V como alternativa open source a ARM, y sistemas embebidos seguros con TEE (Trusted Execution Environment).

## Tabla de conceptos clave

| Concepto | Descripción | Tecnologías |
|----------|-------------|-------------|
| Microcontrolador (MCU) | Computadora completa en un chip: CPU + RAM + ROM + I/O | ARM Cortex-M, AVR, ESP32, PIC, RISC-V |
| Microprocesador (MPU) | Solo CPU, requiere chips externos | ARM Cortex-A, x86, RISC-V |
| RTOS (Real-Time OS) | Sistema operativo con planificación determinista | FreeRTOS, Zephyr, RT-Thread, VxWorks |
| Bare Metal | Programación sin SO, control total del hardware | C directo, loops, ISR |
| GPIO | Pines de propósito general, entrada/salida digital | LED, button, relay control |
| ADC/DAC | Conversión analógica-digital y digital-analógica | Sensor lectura, audio output |
| PWM | Modulación por ancho de pulso para control analógico | Motor speed, LED dimming, servo |
| I2C / SPI / UART | Protocolos de comunicación serie entre dispositivos | Sensors, displays, memory |
| DMA | Acceso directo a memoria sin CPU | ADC, SPI, UART high throughput |
| Interrupt (ISR) | Señal hardware/software que interrumpe ejecución normal | Timer, GPIO, communication events |
| Watchdog Timer | Temporizador que resetea el sistema si no se alimenta | System recovery from hangs |
| Bootloader | Programa que carga la aplicación principal al encender | MCUboot, OpenBLT, ST Bootloader |
| TinyML | Machine Learning en microcontroladores (kB de RAM) | TensorFlow Lite Micro, Edge Impulse |

## Tecnologías principales

| Familia | Arquitectura | Bits | Frecuencia | RAM | Flash | Periféricos comunes | Herramientas | Precio |
|---------|-------------|------|-----------|-----|-------|---------------------|--------------|--------|
| ARM Cortex-M0+ | ARMv6-M | 32-bit | 48 MHz | 8-64KB | 32-256KB | UART, SPI, I2C, GPIO, ADC, Timer | Keil, IAR, GCC | $0.5-2 |
| ARM Cortex-M3/M4 | ARMv7-M | 32-bit | 72-168 MHz | 16-192KB | 64-1024KB | + DSP (M4), FPU (M4) | STM32Cube, HAL | $2-10 |
| ARM Cortex-M7 | ARMv7E-M | 32-bit | 400-600 MHz | 256KB-1MB | 1-2MB | + Cache, TCM, FPU DP | STM32Cube | $10-20 |
| ESP32 | Xtensa LX6 | 32-bit | 240 MHz | 320-512KB | 4-16MB | WiFi, BLE, I2C, SPI, UART, ADC, DAC, CAN | ESP-IDF, Arduino | $2-5 |
| RP2040 | ARM Cortex-M0+ dual | 32-bit | 133 MHz | 264KB | 2MB (flash) | PIO (Programmable I/O) | Pico SDK, Arduino, MicroPython | $1 |
| AVR (Arduino Uno) | AVR | 8-bit | 16 MHz | 2KB | 32KB | GPIO, ADC, UART, SPI, I2C | Arduino IDE, avr-gcc | $2-5 |
| Raspberry Pi (BCM2835/2711) | ARM Cortex-A | 64-bit | 1.2-1.8 GHz | 512MB-8GB | SD/eMMC | HDMI, USB, Ethernet, GPIO, CSI, DSI | Raspberry Pi OS | $15-75 |
| RISC-V (GD32VF103) | RISC-V RV32IMAC | 32-bit | 108 MHz | 32KB | 128KB | UART, I2C, SPI, ADC, Timer | GCC (RISC-V) | $1-3 |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: qué es un sistema embebido, diferencia MCU vs MPU vs CPU de propósito general. Entorno de desarrollo: Arduino IDE, PlatformIO (VS Code), STM32CubeIDE. Primer programa: Blink LED (GPIO output), leer botón (GPIO input), PWM para LED fading. Serial communication: UART para debug (Serial.print). Conceptos de tiempo: delay vs millis(), timers básicos. Conversión analógica: leer potenciómetro con ADC. Protocolos I2C/SPI: conectar display OLED (SSD1306), sensor de temperatura (BMP280). Data types y memoria: int, float, byte, arrays, PROGMEM (flash), RAM limits.
   - Proyecto: Estación meteorológica simple (DHT11/BMP280 sensor, OLED display, LED alerts). Arduino/ESP32.
   - Lectura: "Programming Arduino: Getting Started with Sketches" (Monk), ESP-IDF Programming Guide.

2. **Intermedio (3-8 meses)**: FreeRTOS: tasks, queues, semaphores, mutexes, timers, priority inversion, stack overflow detection. Periféricos avanzados: DMA (ADC → RAM → SPI without CPU), external interrupts, hardware timers (PWM input capture, output compare, encoder interface). Sistemas de archivos: SPIFFS/LittleFS (ESP32), FAT (SD card). Comunicación: WiFi (ESP32 WiFi client/server, OTA updates), Bluetooth (BLE: GATT server/client, advertising, services, characteristics). Protocolos: MQTT (IoT messaging), HTTP/HTTPS, WebSockets. Power management: deep sleep, wake-up sources (timer, GPIO, touch), power consumption measurement. Watchdog: IWDG (Independent), WWDG (Windowed), application watchdog. Debugging: serial debug, printf, semihosting (ARM), debugger (OpenOCD, GDB), logic analyzer (Saleae). Real-time constraints: interrupt latency, context switch overhead, worst-case execution time (WCET).
   - Proyecto: IoT sensor node: ESP32 + sensors (temp, humidity, pressure) + MQTT + deep sleep + OTA. Control app via BLE.
   - Lectura: "Mastering the FreeRTOS" (Amazon), "ESP32 Technical Reference Manual", "STM32 HAL/LL Cookbook".

3. **Avanzado (6-12 meses)**: RTOS en profundidad: Zephyr OS (device tree, kernel configuration, drivers, networking, Bluetooth, power management), RT-Thread. Low-level programming: linker scripts, startup code, vector table, ISR handlers. Device drivers: character drivers, GPIO/SPI/I2C via registers, DMA drivers, interrupt-driven drivers. Firmware update: bootloader design, MCUboot (image management, rollback, swap), secure boot. Security: secure boot, flash encryption, signed firmware, anti-rollback, TrustZone (ARM), HSM, side-channel attacks. Performance optimization: optimizing C code for MCU (volatile, static, const, section placement), assembly optimization, critical sections, measuring MIPS/MHz. Testing: unit tests on host (Cmock, Unity), hardware-in-the-loop testing, continuous integration for firmware (PlatformIO CI, GitHub Actions). Protocol implementation: CAN bus (automotive), Ethernet (Modbus TCP, HTTP), USB device/host. Multi-core: ARM Cortex-M7 + M4 (STM32H7), ESP32 dual-core, RP2040 dual-core PIO.
   - Proyecto: Custom bootloader for STM32/ESP32 with encryption and rollback. RTOS-based firmware with device drivers. CAN bus gateway for automotive/industrial.
   - Certificación: ARM Accredited Engineer, no muy común. Mejor: contribuciones open source y portafolio.

4. **Experto (12+ meses)**: FPGA + SoC: Zynq (ARM Cortex-A + FPGA fabric), MicroBlaze soft-core, C/C++ on FPGA (HLS). Mixed-signal: RF design, antenna matching, signal integrity, EMC/EMI compliance. Functional safety: ISO 26262 (automotive), IEC 61508 (industrial), IEC 62304 (medical), SIL 3/4, ASIL D. Safety-critical: safety patterns (watchdog, lockstep, ECC, CRC, redundancy), MISRA C/C++ coding standards, static analysis (Coverity, Polyspace). BR/RTOS certification: RTCA DO-178C (aviation), IEC 61508 certification. Formal verification: model checking, TLA+, SPIN. Ultra low power: nA sleep modes, energy harvesting, sub-threshold design, Always-On domain. TinyML: TensorFlow Lite Micro (model conversion, quantization, deployment to MCU), Edge Impulse (autoML for embedded), CMSIS-NN (ARM optimized NN kernels). RISC-V: custom RISC-V core in FPGA, Vector extension (RVV), RISC-V profile. Embedded Linux: Yocto (custom Linux distro), Buildroot, device tree, kernel modules, userspace drivers.
   - Proyecto: TinyML model on Cortex-M4 (keyword spotting, anomaly detection). RISC-V core design in FPGA. Safety-critical firmware with MISRA-C + static analysis.
   - Certificación: ISO 26262 / IEC 61508 functional safety training, MISRA C/C++ certified.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Algoritmos y estructuras con restricciones de memoria/tiempo |
| [001-Languages](../001-Languages/) | C, C++, Rust para sistemas embebidos |
| [004-OperatingSystems](../004-OperatingSystems/) | RTOS, Linux embebido, drivers, boot, device tree |
| [008-Networking](../008-Networking/) | TCP/IP stack embebido (lwIP), WiFi, BLE, Ethernet |
| [009-Security](../009-Security/) | Secure boot, flash encryption, TrustZone, side-channel |
| [012-Testing](../012-Testing/) | Hardware-in-the-loop testing, CI para firmware |
| [029-IoT](../029-IoT/) | IoT devices basados en MCUs embebidos |
| [030-Robotics](../030-Robotics/) | Control de motores, sensores, RTOS en robótica |
| [032-MachineLearning](../032-MachineLearning/) | TinyML, ML en MCUs, sensor analytics |

## Recursos recomendados

- **Libros**: "Making Embedded Systems" (White, 2ª ed.), "Embedded C" (Pont), "Mastering STM32" (Nouet), "FreeRTOS Book" (Barry), "TinyML" (Warden, Situnayake), "Programming Embedded Systems" (Barr).
- **Cursos**: "Embedded Systems" (UT Austin / Valvano on edX), "Embedded Software and Hardware Architecture" (Coursera/U of Colorado), "TinyML" (EdX/Harvard).
- **Hardware**: STM32 Nucleo/Discovery, ESP32 DevKit, Raspberry Pi Pico, Teensy 4.1, Arduino Uno R4, nRF52840 (BLE).
- **Herramientas**: VS Code + PlatformIO, STM32CubeIDE, Keil MDK, IAR EWARM, OpenOCD, J-Link, Saleae Logic, Sigrok/PulseView.
- **RTOS**: FreeRTOS, Zephyr, RT-Thread, ChibiOS, Azure RTOS (ThreadX).
- **Estándares**: MISRA C (2012, 2023), CERT C, ISO 26262, IEC 61508, IEC 62304, RTCA DO-178C.

## Notas adicionales

Los sistemas embebidos conectan el software con el mundo físico — hay una satisfacción especial en ver tu código controlar LEDs, motores y sensores reales. La seguridad es crítica en dispositivos conectados (IoT botnets como Mirai). El campo es muy amplio: desde Arduino para hobby hasta sistemas safety-critical certificados. TinyML es la frontera más emocionante: ML inferencia en MCUs con <100KB de RAM. Rust está ganando tracción para firmware seguro (Tock OS, Embassy). El conocimiento del hardware (leer schematics, datasheets) es tan importante como el software.
