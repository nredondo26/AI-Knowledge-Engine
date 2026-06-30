# Firmware — Software de Sistema Embebido

## Descripción del dominio

El firmware es el software de bajo nivel que controla el hardware de un dispositivo electrónico. Reside en memoria no volátil (flash, ROM, EEPROM) y se ejecuta directamente sobre el microcontrolador o procesador, sin un sistema operativo general (aunque puede ejecutarse sobre un RTOS). El firmware es responsable de inicializar el hardware, gestionar periféricos, implementar protocolos de comunicación, ejecutar la lógica de control y, en sistemas modernos, realizar actualizaciones OTA (Over-The-Air). Se escribe principalmente en C y ensamblador, aunque C++ y Rust ganan terreno.

## Áreas clave

- **Arquitectura de firmware**: Capas: Hardware Abstraction Layer (HAL) → Board Support Package (BSP) → Middleware (RTOS, stacks) → Application
- **Bucle principal (superloop)**: Arquitectura bare-metal cíclica: init → while(1) { poll periféricos, procesar, dormir }
- **Máquinas de estado (State Machines)**: FSMs (finite state machines), HSM (hierarchical state machines), ejecutadas en superloop o con RTOS. Ideal para lógica de control secuencial
- **Bootloader**: Código que se ejecuta al inicio: inicializa hardware mínimo, verifica integridad de firmware (CRC/firma), decide qué imagen arrancar (A/B updates), carga firmware principal
- **Drivers de periféricos**: Implementación de init, read/write, ioctl para GPIO, ADC, I2C, SPI, UART, PWM, Timer, DMA. Escritura directa a registros o mediante HAL
- **Protocolos de comunicación**: Serial (UART, RS-232/485, Modbus RTU), I2C (sensors, EEPROM), SPI (flash, displays, SD), CAN (automoción, industrial), USB (HID, MSD, CDC)
- **Actualización OTA**: Particiones A/B (swap), delta updates, fallback automático, verificación de firma, rollback, protocolo de descarga (HTTP, MQTT, CoAP)
- **Consumo energético**: Sleep modes (idle, stop, standby), wake-up sources (timer, GPIO, RTC), dynamic voltage/frequency scaling (DVFS), peripheral gating
- **Seguridad**: Secure boot, firmware encryption, trusted execution environment (TEE), anti-rollback, JTAG/SWD lock, secure storage de claves

## Ejemplo: Máquina de estados en C

```c
typedef enum { STATE_IDLE, STATE_MEASURING, STATE_SENDING, STATE_ERROR } state_t;

state_t current_state = STATE_IDLE;

void process() {
    switch (current_state) {
        case STATE_IDLE:
            if (sensor_ready()) {
                start_measurement();
                current_state = STATE_MEASURING;
            }
            break;
        case STATE_MEASURING:
            if (measurement_done()) {
                current_state = STATE_SENDING;
            }
            break;
        case STATE_SENDING:
            if (send_data()) {
                current_state = STATE_IDLE;
            } else {
                current_state = STATE_ERROR;
            }
            break;
        case STATE_ERROR:
            error_handler();
            if (retry_count++ < MAX_RETRIES) {
                current_state = STATE_MEASURING;
            }
            break;
    }
}
```

## Ejemplo: Bootloader A/B

```c
typedef struct {
    uint32_t magic;        // 0xDEADBEEF
    uint32_t version;
    uint32_t crc32;
    uint32_t size;
    uint8_t  active_slot;  // 0 = A, 1 = B
} firmware_header_t;

void bootloader_main(void) {
    firmware_header_t *header_a = (firmware_header_t*)SLOT_A_ADDR;
    firmware_header_t *header_b = (firmware_header_t*)SLOT_B_ADDR;

    if (header_a->crc32 == calculate_crc(SLOT_A_ADDR, header_a->size)) {
        if (header_b->crc32 == calculate_crc(SLOT_B_ADDR, header_b->size)) {
            // Elegir versión más reciente
            jump_to_slot(header_a->version >= header_b->version ? SLOT_A : SLOT_B);
        } else {
            jump_to_slot(SLOT_A); // Solo A válido
        }
    } else if (header_b->crc32 == calculate_crc(SLOT_B_ADDR, header_b->size)) {
        jump_to_slot(SLOT_B); // Solo B válido
    } else {
        error_handler(); // Ambos corruptos
    }
}
```

## Tecnologías principales

| Herramienta/Framework | Propósito |
|-----------------------|-----------|
| GCC / Clang | Compiladores C/C++ para target (ARM, RISC-V, AVR) |
| CMake / Make | Automatización de compilación |
| PlatformIO | IDE/CLI multiplataforma para embebido |
| Zephyr / FreeRTOS | RTOS modernos para firmware complejo |
| mcuboot | Bootloader seguro y actualizable (IETF SUIT) |
| TinyUSB | Stack USB portable para MCUs |
| lwIP / uIP | Stacks TCP/IP ligeros |
| Mbed TLS / WolfSSL | Criptografía ligera para firmware |
| Kconfig | Configuración de features (Linux Kernel / Zephyr) |
| OpenOCD / J-Link | Depuración y programación |

## Buenas prácticas

- Organizar firmware en capas: hardware → HAL → BSP → app, para portabilidad entre MCUs
- Usar máquinas de estado explícitas en lugar de flags booleanos para lógica de control compleja
- Implementar bootloader con slots A/B y verificación de integridad para OTA seguro
- Usar CRC32 o hash SHA-256 para verificar integridad de firmware en bootloader
- Desactivar JTAG/SWD en producción para protección contra ingeniería inversa
- Medir y optimizar el consumo energético: usar sleep modes y periféricos con wake-up
- Mantener un log de versión de firmware (semver) y changelog actualizado
- Usar asserts y fault handlers para diagnóstico en desarrollo
