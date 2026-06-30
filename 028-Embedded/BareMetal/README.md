# Bare-Metal — Programación sin Sistema Operativo

## Descripción del dominio

La programación bare-metal (también llamada superloop o firmware sin SO) consiste en ejecutar código directamente sobre el microcontrolador sin ningún sistema operativo ni RTOS. El programa tiene control total del hardware: acceso directo a registros, configuración de periféricos, manejo de interrupciones y gestión de memoria sin abstracciones intermedias. Bare-metal ofrece el máximo rendimiento, mínimo consumo de recursos (RAM/ROM) y latencia predecible, a costa de mayor complejidad de desarrollo. Es la opción ideal para MCUs pequeños (Cortex-M0, AVR, PIC), aplicaciones ultra-simples o cuando los recursos son extremadamente limitados.

## Áreas clave

- **Arquitectura superloop**: `main()` → init → `while(1) { poll(), process(), sleep() }`. Sencillo, pero sin concurrencia real
- **Interrupciones**: Vector table, ISR (Interrupt Service Routine), prioridad, anidamiento. ISR + main loop (deferred processing)
- **Acceso directo a registros**: Manipulación de direcciones de memoria mapeadas para configurar periféricos sin HAL
- **Gestión de tiempo**: Timers hardware, ciclos de CPU, delay por busy-wait, systick para timebase
- **Máquinas de estado**: FSMs (finite state machines) ejecutadas en el superloop. Alternativa a tareas de RTOS
- **Gestión de memoria**: Sin heap dinámico (malloc). Stack estático, bss, data, text. Pool de buffers fijos. Sin fragmentación
- **Protocolos por software**: Bit-banging (I2C, SPI, 1-Wire, WS2812) cuando no hay periférico hardware disponible
- **Arranque (startup)**: Reset vector → startup code (init .bss, .data) → main(). Linker script, vector table en assembly

## Ejemplo: Blink bare-metal en STM32 (Cortex-M4)

```c
// Acceso directo a registros (sin HAL)
#define RCC_BASE    0x40023800
#define RCC_AHB1ENR (*((volatile uint32_t*)(RCC_BASE + 0x30)))
#define GPIOA_BASE  0x40020000
#define GPIOA_MODER (*((volatile uint32_t*)(GPIOA_BASE + 0x00)))
#define GPIOA_ODR   (*((volatile uint32_t*)(GPIOA_BASE + 0x14)))

void delay(volatile uint32_t count) {
    while (count--) { __asm("nop"); }
}

int main(void) {
    RCC_AHB1ENR |= (1 << 0);          // Enable GPIOA clock
    GPIOA_MODER &= ~(0x3 << 10);      // Clear PA5 mode bits
    GPIOA_MODER |=  (0x1 << 10);      // PA5 = output (01)

    while (1) {
        GPIOA_ODR ^= (1 << 5);        // Toggle PA5
        delay(500000);
    }
}
```

## Ejemplo: ISR de botón (EXTI)

```c
// Vector table entry (ubicado en flash)
__attribute__((section(".isr_vector")))
void (*vector_table[])(void) = {
    [0] = (void*)0x20001000,  // SP initial
    [1] = Reset_Handler,      // Reset
    // ... otros handlers ...
    [16 + 0] = EXTI0_IRQHandler,  // EXTI0
};

void EXTI0_IRQHandler(void) {
    if (EXTI->PR & (1 << 0)) {        // Verificar flag
        EXTI->PR = (1 << 0);          // Limpiar flag
        button_pressed = 1;           // Flag para main loop
    }
}

int main(void) {
    // Configurar EXTI0 en PA0
    RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
    SYSCFG->EXTICR[0] |= SYSCFG_EXTICR1_EXTI0_PA;
    EXTI->IMR |= (1 << 0);
    EXTI->RTSR |= (1 << 0);
    NVIC_EnableIRQ(EXTI0_IRQn);

    while (1) {
        if (button_pressed) {
            button_pressed = 0;
            GPIOA->ODR ^= (1 << 5);
        }
    }
}
```

## Tecnologías principales

| Herramienta | Propósito |
|-------------|-----------|
| GCC (arm-none-eabi) | Compilador cruzado para ARM Cortex-M |
| Clang/LLVM | Compilador alternativo, mejor diagnóstico |
| Make / CMake | Build system |
| Linker Script (.ld) | Definición de layout de memoria (flash, RAM, stack) |
| Startup code (.s) | Código assembly de arranque (vector table, init) |
| OpenOCD / J-Link | Depuración y programación |
| Saleae Logic Analyzer | Depuración de protocolos y timings |
| Osciloscopio | Medición de timing de señales físicas |

## Buenas prácticas

- Usar volatile para variables compartidas entre ISR y main loop
- Mantener ISR lo más corta posible: solo leer flags y marcar eventos
- Preferir polling periódico en main loop sobre busy-wait en ISR
- No usar malloc/free — usar arrays estáticos o pools de buffers fijos
- Configurar el watchdog (IWDG) para sistemas que deben auto-recuperarse
- Documentar los registros y bitfields utilizados (referencia al reference manual)
- Usar linker script para colocar código crítico en RAM (ISR, funciones de alta velocidad)
- Para delays cortos, usar timer hardware o SysTick en lugar de busy-wait con NOP

## Cuándo usar bare-metal vs RTOS

| Bare-metal | RTOS |
|------------|------|
| 1-2 tareas simples | 5+ tareas concurrentes |
| MCU pequeño (< 16KB flash) | MCU mediano/grande (128KB+ flash) |
| Bajo consumo extremo | Tolerancia a overhead de RTOS |
| Sin deadline estrictos | Deadlines de tiempo real |
| Control total del hardware | Abstracción portable |
| Proyecto pequeño/personal | Proyecto industrial/complejo |
