# 028-Embedded: Sistemas Embebidos

## Descripción del dominio

Los sistemas embebidos son sistemas de computación dedicados a funciones específicas dentro de dispositivos más grandes. Van desde pequeños microcontroladores (MCU) de 8 bits hasta potentes SoCs (System on Chip) con Linux empotrado. Se encuentran en electrodomésticos, automóviles, equipos médicos, drones, wearables y automatización industrial. El desarrollo embebido requiere conocimiento de hardware (GPIO, PWM, ADC, I2C, SPI, UART), firmware, RTOS (Real-Time Operating Systems) y optimización de recursos (memoria, energía, procesamiento).

## Conceptos clave

- **Microcontrolador (MCU)**: Chip completo con CPU, RAM, ROM, periféricos en un solo encapsulado
- **Microprocesador (MPU)**: CPU sin periféricos integrados, usado con chips externos
- **SoC (System on Chip)**: Integra CPU, GPU, periféricos, conectividad en un chip (Raspberry Pi, ESP32)
- **GPIO (General Purpose Input/Output)**: Pines programables para lectura/escritura digital
- **PWM (Pulse Width Modulation)**: Señal digital para control analógico (motores, LEDs)
- **ADC (Analog-to-Digital Converter)**: Conversión de señales analógicas a digitales (sensores)
- **I2C**: Protocolo de comunicación serial síncrono para periféricos (2 pines)
- **SPI**: Protocolo serial síncrono full-duplex (4 pines, más rápido que I2C)
- **UART**: Comunicación serial asíncrona (TX/RX, para depuración y módulos)
- **RTOS (Real-Time Operating System)**: SO con planificación determinista para tareas con restricciones de tiempo real
- **Interrupt (IRQ)**: Señal de hardware que interrumpe la ejecución normal del programa
- **Timer/Counter**: Periférico para medir tiempo, generar PWM, contar eventos
- **Watchdog Timer**: Temporizador que reinicia el sistema si no se actualiza periódicamente
- **DMA (Direct Memory Access)**: Transferencia de datos sin intervención de la CPU
- **Bootloader**: Código que inicializa el hardware y carga el firmware principal
- **Flash memory**: Memoria no volátil para almacenar firmware
- **Bare-metal**: Programación sin SO, control directo del hardware
- **JTAG / SWD**: Interfaces de depuración y programación de microcontroladores
- **Power management**: Gestión de consumo energético para dispositivos con batería
- **Firmware Over The Air (FOTA)**: Actualización de firmware remota
- **BSP (Board Support Package)**: Capa de soporte específica para una placa hardware

## Tecnologías principales

- **ARM Cortex-M**: Arquitectura dominante en MCUs (STM32, NXP, Nordic, Microchip)
- **ARM Cortex-A**: Procesadores para Linux embebido (Raspberry Pi, BeagleBone)
- **RISC-V**: Arquitectura open-source emergente, creciendo en embebidos
- **ESP32**: SoC WiFi/Bluetooth de Espressif, muy popular en IoT
- **Arduino (AVR)**: Plataforma educativa, ATmega328, fácil prototipado
- **STM32 (ARM Cortex-M)**: Familia de MCUs más usada en industria, ecosistema STM32Cube
- **Raspberry Pi**: SBC (Single Board Computer) con Linux, para prototipado y productos
- **FreeRTOS**: RTOS open-source líder, portable a múltiples MCUs
- **Zephyr RTOS**: RTOS moderno de Linux Foundation, con soporte para Bluetooth, WiFi
- **RT-Thread**: RTOS chino, compatible con POSIX, IoT-ready
- **Embedded Linux**: Yocto, Buildroot, OpenWrt para sistemas Linux empotrados
- **ESP-IDF**: SDK oficial de Espressif para ESP32, FreeRTOS + librerías
- **Arduino Framework**: Wiring simplificado, ideal para aprendizaje y prototipado
- **PlatformIO**: Ecosistema de desarrollo embebido cross-platform, multi-framework
- **CMake**: Build system estándar para proyectos embebidos modernos
- **Zephyr**: RTOS escalable con drivers, networking y seguridad integrados

## Hoja de ruta

1. **Principiante**: Blink LED con Arduino. Leer sensor (temperatura, distancia). PWM para LED RGB. Conceptos de GPIO, ADC, UART. Programación bare-metal básica.
2. **Intermedio**: STM32 con HAL/LL. FreeRTOS (tareas, colas, semáforos). Comunicación I2C/SPI con sensores. Interrupciones y timers. Depuración con ST-Link/JTAG. Bajo consumo (sleep modes).
3. **Avanzado**: SoCs con Linux embebido (Yocto/Buildroot). Drivers de dispositivo Linux. DMA para periféricos rápidos. Protocolos de comunicación avanzados (CAN, Ethernet, USB). FOTA. Seguridad embebida (secure boot, crypto acceleration).
4. **Experto**: Diseño de BSP completo. RTOS en tiempo real duro (sub-microsegundos). Arquitecturas multicore (AMP/SMP). RISC-V custom. Optimización de consumo para batería de larga duración. Certificación funcional safety (IEC 61508, ISO 26262).

## Relaciones con otros módulos

- [IoT](../029-IoT/) — Dispositivos conectados, sensores, MQTT, edge computing
- [OperatingSystems](../004-OperatingSystems/) — Linux embebido, RTOS, kernel drivers
- [Languages](../001-Languages/) — C, C++, Rust (embebido moderno), MicroPython
- [Security](../009-Security/) — Secure boot, cifrado en MCU, TPM, protección contra ataques físicos
- [Architecture](../010-Architecture/) — Arquitectura de firmware, capas HAL/BSP
- [Networking](../008-Networking/) — Protocolos (TCP/IP, UDP, MQTT, CoAP, BLE, Zigbee)
- [Observability](../097-Observability/) — Logging en sistemas con recursos limitados

## Recursos recomendados

- [STM32Cube Documentation](https://www.st.com/en/embedded-software/stm32cube-mcu-packages.html)
- [FreeRTOS Documentation](https://www.freertos.org/Documentation)
- [Zephyr Project Docs](https://docs.zephyrproject.org)
- [ESP-IDF Programming Guide](https://docs.espressif.com/projects/esp-idf)
- [ARM Cortex-M Documentation](https://developer.arm.com/Processors/Cortex-M)
- "Making Embedded Systems" — Elecia White (O'Reilly)
- "Embedded Systems: Real-Time Interfacing to ARM Cortex-M" — Jonathan Valvano
- "Mastering STM32" — Carmine Noviello
- [PlatformIO Documentation](https://docs.platformio.org)
