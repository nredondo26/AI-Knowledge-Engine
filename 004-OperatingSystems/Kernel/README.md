# Kernel

## Descripción

El kernel es el núcleo del SO que gestiona el hardware y provee servicios a los procesos. Existen arquitecturas monolítica (Linux), microkernel (Minix, seL4), híbrida (Windows NT, XNU/macOS) y exokernel.

| Arquitectura | SO | Descripción |
|-------------|-----|-------------|
| Monolítico | Linux | Todo en kernel con módulos dinámicos |
| Híbrido | Windows NT | Microkernel + subsistemas en kernel |
| Híbrido | XNU (macOS) | Mach + BSD + IOKit |
| Microkernel | Minix, QNX, seL4 | Mínimo en kernel, servicios en usuario |

---

## Syscalls (Llamadas al Sistema)

```bash
strace -c ls                        # resumen de syscalls de ls
strace -e trace=open,openat,read ls # filtrar syscalls específicas
strace -e trace=network curl https://google.com  # syscalls de red
strace -e trace=memory python3 -c "x = [0]*1000000"  # syscalls de memoria
strace -p PID                       # trazar proceso en ejecución
```

## Gestión de Memoria

```bash
cat /proc/meminfo                   # toda la info de memoria
cat /proc/vmallocinfo               # áreas de memoria virtual
cat /proc/slabinfo                  # cachés slab del kernel
cat /proc/pagetypeinfo              # estado de page allocator
cat /proc/zoneinfo                  # zonas NUMA
cat /proc/PID/maps                  # mapa de memoria de un proceso
cat /proc/PID/smaps                 # detalle RSS/PSS por región

# Huge Pages
cat /proc/meminfo | grep Huge       # estado de huge pages

# OOM Killer
cat /proc/PID/oom_score             # puntuación OOM de un proceso
```

## Planificación de Procesos (Scheduler)

```bash
chrt -p PID                         # política de scheduling (FIFO, RR, OTHER)
chrt -f 50 ./realtime.sh            # SCHED_FIFO prioridad 50
chrt -r 50 ./realtime.sh            # SCHED_RR prioridad 50
nice -n -10 ./computo.sh            # prioridad alta (requiere root)
taskset -c 0,1 ./proceso            # CPU pinning (CPU 0 y 1)
taskset -p -c 2 PID                 # asignar CPU a proceso existente
vmstat 1                            # context switches (columna cs)
pidstat -w 1                        # context switches voluntarios/involuntarios
```

## VFS (Virtual File System)

```bash
cat /proc/filesystems               # sistemas de archivos soportados
cat /proc/PID/status                # estado del proceso
ls /proc/PID/fd                     # file descriptors abiertos
ls /proc/PID/ns                     # namespaces del proceso
cat /sys/class/net/eth0/address     # MAC address
```

## Interrupciones

```bash
cat /proc/interrupts                # IRQs por CPU
cat /proc/softirqs                  # softirqs (NET_TX, NET_RX, BLOCK, etc.)
echo 2 > /proc/irq/130/smp_affinity # asignar IRQ a CPU 1
```

## Módulos del Kernel

```bash
lsmod                               # módulos cargados
modinfo kvm                         # información del módulo
modprobe kvm                        # cargar módulo con dependencias
modprobe -r kvm                     # descargar módulo
insmod /ruta/mi_modulo.ko           # insertar módulo manual
depmod -a                           # regenerar dependencias
```

## eBPF

```bash
bpftrace -e 'tracepoint:syscalls:sys_enter_execve { printf("%s ejecutó %s\n", comm, str(args->filename)); }'
bpftrace -e 'profile:hz:99 { @[kstack] = count(); }'
bpftool prog list                   # programas eBPF cargados
bpftool map list                    # mapas eBPF
execsnoop-bpfcc                     # nuevos procesos
opensnoop-bpfcc                     # archivos abiertos
tcplife-bpfcc                       # conexiones TCP
biolatency-bpfcc                    # latencia de I/O
```

## Compilación del Kernel

```bash
git clone https://github.com/torvalds/linux.git
cd linux && git checkout v6.6
make defconfig                      # configuración por defecto
make -j$(nproc)                     # compilar kernel
make modules && make modules_install
make install                        # instalar en /boot
update-grub                         # actualizar GRUB
```

---

## Relaciones

- [Linux](../Linux/) — Kernel Linux, syscalls, módulos, eBPF, scheduling CFS
- [FileSystems](../FileSystems/) — VFS, ext4, XFS, Btrfs, page cache
- [008-Networking](../../008-Networking/) — Netfilter, eBPF/XDP, TCP stack
- [009-Security](../../009-Security/) — SELinux, AppArmor, seccomp

## Recursos

- **Libros**: "Linux Kernel Development" (Love), "Understanding the Linux Kernel" (Bovet/Cesati), "Linux Device Drivers" (Corbet)
- **Documentación**: kernel.org/doc, elixir.bootlin.com, lwn.net
- **eBPF**: ebpf.io, "BPF Performance Tools" (Gregg)
