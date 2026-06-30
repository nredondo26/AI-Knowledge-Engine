# RTOS — Sistemas Operativos en Tiempo Real

## Descripción del dominio

Un RTOS (Real-Time Operating System) es un sistema operativo diseñado para aplicaciones con restricciones de tiempo real, donde las operaciones deben completarse dentro de plazos deterministas (deadlines). Los RTOS son esenciales en sistemas embebidos críticos: automoción (brakes, airbags), aeroespacial (aviónica, satélites), robótica (control de motores), equipos médicos (infusores, marcapasos), automatización industrial (PLC) y defensa. A diferencia de Linux o Windows, los RTOS priorizan la predictibilidad temporal sobre el throughput, con planificación basada en prioridades, latencia de interrupción mínima y gestión determinista de memoria.

## Áreas clave

- **Planificación (scheduling)**: Rate-Monotonic (RMS), Earliest Deadline First (EDF), Priority-based Preemptive, Round Robin, Time-Triggered, Deadline Monotonic
- **Gestión de tareas (tasks/threads)**: Task Control Block (TCB), prioridades, estados (ready, running, blocked, suspended), stack per-task
- **Sincronización**: Semáforos (binario, contador), mutexes (con herencia de prioridad), colas de mensajes, event flags, mailboxes, condition variables
- **Comunicación entre tareas (IPC)**: Message queues, pipes, shared memory, signals, event flags, rendezvous
- **Gestión de interrupciones**: ISR, prioridad de interrupción, anidamiento, diferimiento (deferred interrupt handling), bottom halves
- **Timers**: Software timers (tick-based, one-shot/periodic), hardware timers, watchdog timers
- **Protección de prioridad**: Priority Inversion → Priority Inheritance Protocol (PIP), Priority Ceiling Protocol (PCP), Stack Resource Policy (SRP)
- **Determinismo**: Worst-Case Execution Time (WCET), Response Time Analysis, Blocking Time, Release Jitter
- **RTOS vs GPOS**: Diferencias clave: planificación determinista, latencia de interrupción acotada, bajo jitter, sin swap/virtual memory

## RTOS principales

| RTOS | Tipo | Características | Licencia |
|------|------|-----------------|----------|
| FreeRTOS | Open source | Más popular, portable (ARM, RISC-V, ESP32), AWS IoT integration | MIT |
| Zephyr | Open source | Modular, Bluetooth 5, Linux Foundation, Device Tree, Posix-like | Apache 2.0 |
| RT-Thread | Open source | Escalable, soporte IoT, componentes (AT, MQTT, lwIP, GUI) | Apache 2.0 |
| NuttX | Open source | Compatible POSIX, usado por Sony (cámaras), Qualcomm | BSD |
| μC/OS-III | Commercial | Determinista, certificado DO-178C (aeroespacial), SIL (industrial) | Comercial |
| TI-RTOS | Propietario | Para MCUs TI (MSP430, Tiva C, CC32xx) | Comercial |
| VxWorks | Commercial | Líder en sistemas críticos (Mars rovers, F-35, CERN) | Comercial |
| QNX | Commercial | Microkernel, POSIX, certificado ISO 26262 (automoción) | Comercial |

## Ejemplo: Tareas con FreeRTOS

```c
#include "FreeRTOS.h"
#include "task.h"

void vTask1(void *pvParameters) {
    while (1) {
        vTaskDelay(pdMS_TO_TICKS(500));
        // Código de la tarea 1
    }
}

void vTask2(void *pvParameters) {
    while (1) {
        vTaskDelay(pdMS_TO_TICKS(1000));
        // Código de la tarea 2
    }
}

int main(void) {
    xTaskCreate(vTask1, "Task1", 128, NULL, 1, NULL);
    xTaskCreate(vTask2, "Task2", 128, NULL, 2, NULL);
    vTaskStartScheduler();
    while (1); // Nunca llega aquí
}
```

## Ejemplo: Cola de mensajes FreeRTOS

```c
QueueHandle_t xQueue;

void vSender(void *pvParams) {
    int32_t value = *(int32_t*)pvParams;
    while (1) {
        xQueueSend(xQueue, &value, portMAX_DELAY);
        vTaskDelay(pdMS_TO_TICKS(100));
    }
}

void vReceiver(void *pvParams) {
    int32_t received;
    while (1) {
        if (xQueueReceive(xQueue, &received, portMAX_DELAY)) {
            // Procesar received
        }
    }
}
```

## Buenas prácticas

- Asignar prioridades según el análisis Rate-Monotonic (tareas más frecuentes = mayor prioridad)
- Usar mutex con herencia de prioridad para evitar priority inversion
- Mantener ISR lo más corta posible (solo ack + flags); delegar procesamiento a tareas
- Dimensionar correctamente los stacks de cada tarea (configCHECK_FOR_STACK_OVERFLOW)
- Evitar `vTaskDelay()` en ISR; usar `xQueueSendFromISR` para comunicación con tareas
- Usar `configUSE_TIME_SLICING` para planificación round-robin entre tareas de igual prioridad
- Realizar análisis de WCET para tareas críticas certificables
- Medir latencia de interrupción y jitter con oscilloscope lógico o GPIO toggles
