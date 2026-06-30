# STM32 — Microcontroladores ARM Cortex-M

## Descripción del dominio

STM32 es una familia de microcontroladores de 32 bits basados en núcleos ARM Cortex-M, fabricados por STMicroelectronics. Es la familia de MCUs más popular para desarrollo embebido profesional, utilizada en automatización industrial, robótica, IoT, electrónica de consumo, automoción y equipos médicos. Los STM32 cubren desde el Cortex-M0+ (ultra bajo consumo) hasta el Cortex-M7 (alto rendimiento con DSP y FPU). Se programan principalmente en C/C++ con HAL (Hardware Abstraction Layer), LL (Low Layer) o directo sobre registros, usando STM32CubeIDE, Keil o IAR.

## Áreas clave

- **Series principales**: STM32F0/1 (general purpose), STM32G0/4 (valor), STM32L0/1/4/5 (ultra-low-power), STM32F3/7 (rendimiento), STM32H7 (high-end Cortex-M7+M4), STM32WB (wireless BLE), STM32MP (MPU Cortex-A + M4)
- **STM32CubeMX**: Herramienta gráfica para configuración de pines (Pinout), periféricos, reloj (Clock Tree), DMA, middleware (FreeRTOS, USB, TCP/IP). Genera código de inicialización C
- **HAL/LL Libraries**: HAL (portable, orientado a funciones genéricas) vs LL (ligero, directo a registros, mayor rendimiento)
- **Periféricos comunes**: GPIO, EXTI (interrupciones externas), TIM (timers PWM, input capture, output compare), ADC, DAC, I2C, SPI, UART/USART, CAN, DMA, RTC, IWDG/WWDG (watchdog)
- **Comunicación**: USART, I2C, SPI, CAN, USB (device/host/OTG), Ethernet (MAC + PHY externo), SDIO (SD cards), SAI (audio I2S)
- **FreeRTOS**: RTOS integrado en STM32CubeMX. Tasks, queues, semaphores, mutexes, timers de software
- **TouchGFX/STM32Cube.AI**: STM32Cube expansion packs — TouchGFX para GUIs embebidas, Cube.AI para inferencia de ML en MCU
- **Depuración**: SWD (Serial Wire Debug) con ST-Link, J-Link, OpenOCD. SEGGER RTT para logging

## Ejemplo: Blink con HAL

```c
#include "stm32f4xx_hal.h"

void HAL_MspInit(void) {
    __HAL_RCC_GPIOA_CLK_ENABLE();
}

int main(void) {
    HAL_Init();
    GPIO_InitTypeDef gpio = {0};
    gpio.Pin = GPIO_PIN_5;
    gpio.Mode = GPIO_MODE_OUTPUT_PP;
    gpio.Pull = GPIO_NOPULL;
    gpio.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOA, &gpio);

    while (1) {
        HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_5);
        HAL_Delay(500);
    }
}
```

## Ejemplo: Configuración UART con CubeMX

```c
// Generado por STM32CubeMX
UART_HandleTypeDef huart2;

void MX_USART2_UART_Init(void) {
    huart2.Instance = USART2;
    huart2.Init.BaudRate = 115200;
    huart2.Init.WordLength = UART_WORDLENGTH_8B;
    huart2.Init.StopBits = UART_STOPBITS_1;
    huart2.Init.Parity = UART_PARITY_NONE;
    huart2.Init.Mode = UART_MODE_TX_RX;
    huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
    HAL_UART_Init(&huart2);
}

// Envío
HAL_UART_Transmit(&huart2, (uint8_t*)"Hola STM32\r\n", 12, HAL_MAX_DELAY);
```

## Tecnologías principales

| Herramienta | Propósito |
|-------------|-----------|
| STM32CubeIDE | IDE completo (Eclipse + GCC + ST-Link) |
| STM32CubeMX | Configurador gráfico (pines, clock, periféricos) |
| ST-Link/V3 | Depurador/programador SWD |
| OpenOCD | Depuración open source (gdb + ST-Link/J-Link) |
| FreeRTOS | RTOS integrado en CubeMX |
| TouchGFX | Framework GUI para pantallas táctiles |
| STM32Cube.AI | Conversión de modelos ML a C para MCU |
| STM32CubeProgrammer | Programación y configuración de MCUs |
| STM32CubeMonitor | Monitoreo en tiempo real de variables |

## Buenas prácticas

- Usar STM32CubeMX para configuración inicial y regeneración cuando se añadan periféricos
- Preferir interrupciones DMA para periféricos de alto throughput (ADC, SPI, UART)
- Verificar el clock tree con CubeMX para asegurar frecuencias correctas y evitar overclock
- Configurar watchdog (IWDG) para sistemas críticos (reset automático si se cuelga)
- Usar FreeRTOS para aplicaciones con múltiples tareas; configurar stack sizes adecuados
- Para bajo consumo, usar STOP/SLEEP modes y habilitar interrupciones para despertar
- Depurar con SEGGER RTT en lugar de UART para logging sin pines adicionales
- Organizar código en capas: HAL/LL → BSP (Board Support Package) → Application
