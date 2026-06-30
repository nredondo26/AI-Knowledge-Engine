# ARM — Arquitectura de Procesadores ARM

## Descripción del dominio

ARM (Advanced RISC Machines) es una familia de arquitecturas de procesadores RISC de 32 y 64 bits, diseñadas por ARM Holdings (ahora parte de SoftBank/NVIDIA). ARM es la arquitectura más ubicua del mundo, presente en más de 200 mil millones de chips: smartphones (Snapdragon, Apple Silicon, Exynos), tablets, laptops (Apple M-series, Windows on ARM), microcontroladores (Cortex-M), sistemas embebidos (Cortex-A/R), servidores (Ampere, AWS Graviton), routers, TVs, wearables y sensores IoT. ARM licencia su diseño a fabricantes (Qualcomm, Apple, Samsung, NXP, ST, TI) que lo integran en sus SoCs.

## Áreas clave

- **Perfiles ARM**: Cortex-A (Application — Linux, Android, alto rendimiento), Cortex-R (Real-time — automoción, industrial, tiempo real crítico), Cortex-M (Microcontroller — embebido, bajo consumo, IoT), Cortex-X (Performance — custom, máximo rendimiento)
- **Arquitectura ARMv7/ARMv8/ARMv9**: ARMv7-A (32-bit), ARMv8-A (64-bit, AArch64/AArch32), ARMv9-A (confidencial computing, SVE2, MTE)
- **Conjunto de instrucciones**: A64 (64-bit ARM), A32/T32 (32-bit ARM/Thumb), Thumb-2 (densidad de código), NEON (SIMD), SVE/SVE2 (vectorización escalable), MVE (M-profile vector extension)
- **Modos de operación**: User, FIQ, IRQ, Supervisor (SVC), Abort, Undefined, System (ARMv7); EL0-EL3 excepción levels (ARMv8)
- **Sistema de memoria**: MMU (Cortex-A), MPU (Cortex-R/M con protección), cache L1/L2/L3, TLB, paginación, big.LITTLE / DynamIQ (heterogeneous computing)
- **Interrupciones**: GIC (Generic Interrupt Controller) v2/v3/v4, SPI, PPI, SGI, LPI — manejo de interrupciones en sistemas multi-core
- **TrustZone**: Tecnología de seguridad ARM — mundo seguro (Secure World) vs mundo normal (Normal World). TEE (Trusted Execution Environment), secure boot, secure storage
- **Power management**: P-states, C-states, DVFS, WFI/WFE, big.LITTLE migration, energy-aware scheduling (EAS)

## Ejemplo: Ensamblador AArch64

```asm
// Función suma: int add(int a, int b)
.global add
add:
    add w0, w0, w1    // w0 = w0 + w1
    ret
```

```asm
// Hello World en AArch64 con syscall
.global _start
_start:
    mov x0, #1          // fd = stdout
    ldr x1, =msg
    mov x2, #13         // length
    mov x8, #64         // syscall write
    svc #0
    mov x0, #0          // exit code
    mov x8, #93         // syscall exit
    svc #0

.data
msg: .ascii "Hello, ARM!\n"
```

## Tecnologías principales

| Componente | Descripción |
|------------|-------------|
| ARM DS/Keil | IDEs oficiales para desarrollo ARM |
| GCC ARM | Compilador GNU para ARM (arm-none-eabi-gcc, aarch64-linux-gnu-gcc) |
| LLVM/Clang | Compilador alternativo, mejor optimización |
| OpenOCD | Depuración open source |
| QEMU | Emulación de sistemas ARM (virt, versatilepb, raspi) |
| TF-A (Trusted Firmware) | Firmware de referencia para ARMv8-A (EL3, SMC, PSCI) |
| U-Boot | Bootloader universal para ARM |
| Device Tree | FDT para descripción de hardware ARM |

## Arquitecturas y SoCs representativos

| SoC | Procesador | Uso típico |
|-----|------------|------------|
| Apple M4 | ARMv9-A (Firestorm + Icestorm) | Mac, iPad |
| Qualcomm Snapdragon 8 Gen 3 | ARMv9-A (Oryon, Cortex-X4) | Smartphone flagships |
| NVIDIA Tegra Orin | ARMv8.2-A (Cortex-A78) | Robótica, automoción |
| Raspberry Pi 5 | ARMv8-A (Cortex-A76) | Single-board computer |
| STM32H7 | Cortex-M7 + M4 | MCU alto rendimiento |
| NXP i.MX RT | Cortex-M7 (cross-over) | MCU con rendimiento MPU |
| Ampere Altra | ARMv8.2-A (Neoverse N1) | Servidores cloud |
| AWS Graviton4 | ARMv9 (Neoverse V2) | Servidores cloud AWS |

## Buenas prácticas

- Para MCUs, usar Thumb-2 (instrucciones de 16 bits) para mejor densidad de código
- En Cortex-A, habilitar NEON para procesamiento SIMD (audio, video, ML)
- Configurar correctamente el MMU/MPU para protección de memoria entre tareas
- Usar TrustZone para aislar operaciones críticas de seguridad (DRM, pagos, biometrics)
- En sistemas multi-core, distribuir IRQs con GIC affinity para balanceo de carga
- Implementar secure boot con firma de imagen y verificación en ROM bootloader
- Para bajo consumo, usar WFI/WFE en idle loops y DVFS dinámico por carga de trabajo
- Usar perf (Linux) o ARM Streamline para perfilado de rendimiento
