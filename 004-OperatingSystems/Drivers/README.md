# Drivers — Controladores de Dispositivos

## Descripción del dominio

Los controladores de dispositivos (device drivers) son módulos de software que permiten al sistema operativo comunicarse con dispositivos hardware específicos. Actúan como una capa de abstracción entre el hardware y el kernel, traduciendo llamadas genéricas del sistema a comandos específicos del dispositivo. Este módulo cubre la arquitectura de drivers en Linux (la más relevante por su uso en servidores, embebidos y cloud), incluyendo módulos del kernel, modelo de dispositivos (device model), framework de drivers, buses (PCI, USB, I2C, SPI, platform), manejo de interrupciones, DMA, y escritura de drivers.

## Áreas clave

- **Módulos del kernel**: Módulos cargables (`.ko`), `insmod`/`rmmod`/`modprobe`, licencias (GPL, BSD), símbolos exportados (EXPORT_SYMBOL)
- **Modelo de dispositivos Linux**: Bus, device, driver — vinculación (binding) entre dispositivos y drivers
- **Archivos de dispositivo**: `/dev`, `/sys`, `/proc` — números major/minor, device nodes, udev, devtmpfs
- **Interrupciones**: IRQ, `request_irq()`/`devm_request_irq()`, top half (ISR rápida) / bottom half (tasklet, workqueue, threaded IRQ)
- **DMA (Direct Memory Access)**: DMA API, streaming vs coherent DMA, dma_alloc_coherent, dma_map_single
- **Buses**: PCI (struct pci_driver, probe, BAR, config space), USB (struct usb_driver, urb), I2C (struct i2c_driver, adapter/client), SPI (struct spi_driver, message/transfer), Platform (struct platform_driver, device tree)
- **Device Tree**: FDT (Flattened Device Tree) para plataformas embebidas ARM/RISC-V — .dts/.dtsi, bindings
- **GPIO y pinctrl**: GPIO descriptor API, gpiod_get, pinctrl para configuración de pines
- **Regmap**: API de registro genérico (I2C/SPI/MMIO) — regmap_init, regmap_read/write
- **Io memory**: ioremap, readl/writel, ioport_map para acceso a registros hardware
- **Timers y hrtimers**: struct timer_list, high-resolution timers, hrtimer, delay (udelay, mdelay, msleep)

## Ejemplo: Driver platform mínimo

```c
#include <linux/module.h>
#include <linux/platform_device.h>

static int my_probe(struct platform_device *pdev) {
    pr_info("Dispositivo detectado: %s\n", pdev->name);
    // Mapear memoria, registrar interrupción, etc.
    return 0;
}

static int my_remove(struct platform_device *pdev) {
    pr_info("Dispositivo removido\n");
    return 0;
}

static const struct of_device_id my_of_match[] = {
    { .compatible = "mycompany,mydevice" },
    { }
};
MODULE_DEVICE_TABLE(of, my_of_match);

static struct platform_driver my_driver = {
    .probe  = my_probe,
    .remove = my_remove,
    .driver = {
        .name = "mydevice",
        .of_match_table = my_of_match,
    },
};
module_platform_driver(my_driver);
MODULE_LICENSE("GPL");
```

## Ejemplo: Device Tree binding

```dts
/mydevice {
    compatible = "mycompany,mydevice";
    reg = <0x1000 0x100>;
    interrupts = <0x1e 0x2>;
    clocks = <&clk 42>;
};
```

## Tecnologías principales

| Framework/API | Propósito |
|---------------|-----------|
| platform_driver | Dispositivos en bus platform (no detectables) |
| pci_driver | Dispositivos PCI/PCIe |
| usb_driver | Dispositivos USB |
| i2c_driver | Periféricos I2C |
| spi_driver | Periféricos SPI |
| serdev | Dispositivos seriales |
| IIO | Industrial I/O (sensores, ADC, DAC) |
| Input subsystem | Teclados, touchscreens, ratones |
| ALSA SoC | Audio embebido (ASoC) |
| V4L2 | Video para Linux (cámaras) |
| DRM/KMS | Gráficos y display |
| NVMEM | Memoria no volátil (EEPROM, efuses) |
| watchdog | Watchdog timers |
| pwm | Pulse Width Modulation |
| remoteproc/rpmsg | Procesadores remotos (DSP, MCU) |

## Buenas prácticas

- Usar `devm_` (managed device resources) para gestión automática de memoria y recursos
- Implementar soporte para Device Tree en drivers platform
- Usar `dev_info()`/`dev_err()` para logging específico del dispositivo
- Separar top half (ISR rápida, solo ack) de bottom half (trabajo pesado)
- Verificar que el driver compile como módulo y como built-in
- Probar con `insmod`/`rmmod` y verificar en `dmesg` y `/sys/bus`
- Usar lockdep para detectar deadlocks y condiciones de carrera
