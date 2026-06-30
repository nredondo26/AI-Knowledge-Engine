# 004-OperatingSystems: Sistemas Operativos

## Descripción ampliada del dominio

Los sistemas operativos actúan como intermediarios entre el hardware y el software de aplicación, gestionando recursos como CPU, memoria, almacenamiento y dispositivos de E/S. Este módulo cubre la teoría y práctica de los SO modernos incluyendo planificación de procesos, gestión de memoria virtual y física, sistemas de archivos, E/S, sincronización, interrupciones, llamadas al sistema, y los principales SO del mercado (Linux, Windows, macOS). Linux domina el mundo cloud, servidores y embebidos; Windows es estándar en desktop empresarial y gaming; macOS en el ecosistema creativo y de desarrollo. Los conceptos fundamentales son universales: un proceso es un programa en ejecución con su propio espacio de direcciones; un hilo (thread) es una unidad de ejecución dentro de un proceso; el kernel es el núcleo del SO que opera en modo privilegiado. La evolución incluye kernels monolíticos (Linux), microkernels (Minix, QNX), kernels híbridos (Windows NT, macOS XNU), y más recientemente unikernels (MirageOS) y sistemas operativos para contenedores (Container Linux, Flatcar).

## Tabla de conceptos clave

| Concepto | Descripción | Implementación destacada |
|----------|-------------|-------------------------|
| Proceso | Programa en ejecución con espacio de direcciones independiente | fork/exec (Linux), CreateProcess (Windows) |
| Hilo (Thread) | Unidad de ejecución ligera dentro de un proceso | pthreads (POSIX), Win32 threads, goroutines (Go) |
| Planificación (scheduling) | Algoritmo que decide qué proceso/hilo ejecuta la CPU | CFS (Linux), Round Robin, FIFO, MLFQ |
| Context switch | Cambio de ejecución entre procesos/hilos con guardado de estado | Interrupción de timer (100-1000 Hz) |
| Memoria virtual | Abstracción que da a cada proceso su propio espacio de direcciones | Page tables, TLB, MMU |
| Paginación | División de memoria en páginas fijas (4KB típicamente) | Page cache, swap, demand paging |
| Segmentación | División de memoria en segmentos lógicos | GDT/LDT (x86), segmentación en arquitecturas obsoletas |
| Sistema de archivos | Organización de datos en almacenamiento persistente | ext4, XFS, NTFS, APFS, Btrfs, ZFS |
| Llamada al sistema (syscall) | Interfaz entre espacio de usuario y kernel | syscall instrucción (x86-64), int 0x80 (legacy) |
| Interrupción | Señal hardware/software que cambia el flujo de ejecución | IRQ, trap, exception, APIC |
| DMA (Direct Memory Access) | Transferencia de datos sin intervención de CPU | Controlador DMA, PCIe DMA |
| Lock/Spinlock | Mecanismo de exclusión mutua para acceso concurrente | futex (Linux), mutex, semáforo, RWLock |
| Deadlock | Bloqueo permanente de procesos esperando recursos compartidos | Prevención, evitación, detección, recuperación |
| IPC (Inter-Process Communication) | Comunicación entre procesos | pipes, sockets, shared memory, message queues, signals |

## Tecnologías principales

| Sistema Operativo | Kernel | Licencia | Gestor paquetes | Sistema archivos | Init system | Caso de uso |
|-------------------|--------|----------|-----------------|-----------------|-------------|-------------|
| Linux (Ubuntu, Debian, RHEL, Arch) | Monolítico (Linux) | GPLv2 | apt, dnf, pacman | ext4, XFS, Btrfs, ZFS | systemd | Servidores, cloud, desarrollo, desktop |
| Windows 11/Server 2025 | Híbrido (NT) | Propietaria | winget, MSI, Chocolatey | NTFS, ReFS | Windows Service Manager | Desktop empresarial, gaming, servers |
| macOS 15 Sequoia | Híbrido (XNU) | APSL (open source partial) | Homebrew, .pkg, Mac App Store | APFS | launchd | Desarrollo, creativo, consumer |
| FreeBSD | Monolítico (BSD) | BSD | pkg, ports | UFS2, ZFS | init | Servidores, networking, storage |
| Android (AOSP) | Monolítico (Linux mod) | Apache 2.0 | APK, Google Play | f2fs, ext4 | init/systemd | Móviles, tablets, IoT |
| ChromeOS | Monolítico (Linux + Chromium) | BSD-like | Portage/Crostini | ext4 | systemd | Chromebooks, educación, kioskos |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos: qué es un SO, kernel, espacio de usuario vs kernel. Llamadas al sistema básicas (open, read, write, close, fork, exec). Procesos: creación, terminación, estados (running, ready, blocked, zombie, orphan). Señales Unix: SIGINT, SIGTERM, SIGKILL, signal handlers. Sistema de archivos: jerarquía Linux (/, /home, /etc, /var, /proc, /sys). Permisos: chmod, chown, ACLs. Usuarios y grupos. Terminal, shell (bash, zsh), scripting básico. pipes y redirección. Editores: vim/nano. Procesos foreground/background (&, fg, bg, jobs). Herramientas básicas: ps, top, kill, df, du, ls, cat, grep, find.
   - Práctica: Navegar sistema de archivos Linux, crear scripts bash, gestionar procesos.
   - Lectura: "The Linux Command Line" (Shotts), "Operating Systems: Three Easy Pieces" (capítulos 1-15).

2. **Intermedio (3-8 meses)**: Planificación de procesos: CFS, niceness, scheduling classes (SCHED_OTHER, SCHED_FIFO, SCHED_RR). Memoria virtual: page tables multinivel, TLB, page faults, swapping, OOM killer. Memoria caché: page cache, buffer cache, dentry cache. Sincronización: mutexes, semáforos, variables de condición, barriers, futex. Deadlocks: condiciones de Coffman, estrategias (prevención, evitación banquero, detección). Sistemas de archivos: ext4 (journaling), XFS, Btrfs (copy-on-write, snapshots, subvolumes), ZFS (pooled storage, checksums, deduplication). RAID: 0, 1, 5, 6, 10, JBOD. LVM: volúmenes lógicos, snapshots. Dispositivos de E/S: caracter, bloque, network. /proc y /sys: interfaces de información del kernel. IPC: pipes nombradas (FIFO), colas de mensajes POSIX, memoria compartida (shmget, mmap), señales. cgroups y namespaces (base de contenedores). systemd: units, services, timers, journald.
   - Práctica: Implementar productor-consumidor con threads y mutexes. Script de monitoreo de sistema. Configurar servicio systemd.
   - Lectura: "Operating Systems: Three Easy Pieces" (Remzi), "Linux Kernel Development" (Love).

3. **Avanzado (8-14 meses)**: Kernel internals: syscall dispatch, interrupt handling (IRQ, softirq, tasklets, workqueues), bottom halves. Gestión de memoria del kernel: slab allocator, kmalloc, vmalloc, CMA, huge pages. Control groups (cgroups v2): CPU, memory, IO, PID controllers. eBPF: programación en el kernel sin modificar el kernel, tracing, networking, security. Namespaces: PID, net, mount, user, IPC, UTS. Virtualización: KVM, QEMU, virtio, para-virtualización, hardware-assisted virtualization (Intel VT-x, AMD-V). Sistemas de archivos avanzados: FUSE (Filesystem in Userspace), tmpfs, overlayfs (Docker layers). Device drivers: character drivers, platform drivers, device tree, PCI/ACPI. Tiempo real: PREEMPT_RT, jitter, deadline scheduling. Performance tuning: perf, ftrace, flame graphs, strace, ltrace.
   - Práctica: Escribir un módulo kernel simple (hello world). Programa eBPF que trace syscalls. Driver de dispositivo virtual.
   - Lectura: "Linux Device Drivers" (Corbet, Rubini, Kroah-Hartman), "BPF Performance Tools" (Gregg).

4. **Experto (14+ meses)**: Diseño de SO: implementación de un kernel simple (xv6, OS/161). Microkernels vs monolithic kernels: seL4 (verificado formalmente), Minix, QNX. Sistemas operativos distribuidos: Plan 9, Inferno. Unikernels: MirageOS, OSv, IncludeOS — SO especializados para una sola aplicación. Real-time operating systems (RTOS): FreeRTOS, Zephyr, VxWorks — planificación determinista, latencia predecible. Trusted Execution: ARM TrustZone, Intel SGX/TDX, AMD SEV-SNP, confidential computing. Formal verification of OS: seL4 verification, CertiKOS. OS for ML/AI: GPU/NPU memory management, CUDA, ROCm, TensorRT. Optimización de rendimiento: cache coloring, NUMA awareness, CPU pinning, isolcpus, nohz_full. Live patching: ksplice, kpatch, live kernel updates. Filesystem benchmarking: fio, bonnie++, mdtest.
   - Práctica: Contribución al kernel Linux (driver, bug fix, eBPF program). Implementar microkernel simple. Portar SO a arquitectura RISC-V.
   - Lectura: "Understanding the Linux Kernel" (Bovet, Cesati), "Operating Systems Design and Implementation" (Tanenbaum), Linux kernel mailing list, LWN.net.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Memoria, procesos, algoritmos de scheduling, page replacement |
| [001-Languages](../001-Languages/) | Syscalls desde lenguajes, gestión de memoria nativa (C, Rust) |
| [006-Containers](../006-Containers/) | cgroups, namespaces, overlayfs como base de contenedores |
| [007-Orchestration](../007-Orchestration/) | K8s scheduling, node resources, Pod cgroups |
| [008-Networking](../008-Networking/) | Network stack TCP/IP en kernel, sockets, netfilter, eBPF |
| [009-Security](../009-Security/) | SELinux, AppArmor, seccomp, kernel hardening, LSM |
| [010-Architecture](../010-Architecture/) | Arquitecturas de SO, modos de operación, system calls |
| [028-Embedded](../028-Embedded/) | Linux embebido, Yocto, Buildroot, RTOS |
| [029-IoT](../029-IoT/) | SO para dispositivos IoT (FreeRTOS, Zephyr, Mbed OS) |

## Recursos recomendados

- **Libros**: "Operating Systems: Three Easy Pieces" (Arpaci-Dusseau) — mejor libro introductorio gratis online. "Linux Kernel Development" (Love, 3ª ed.). "Understanding the Linux Kernel" (Bovet, Cesati, 3ª ed.). "The Design of the UNIX Operating System" (Bach). "Modern Operating Systems" (Tanenbaum, 5ª ed.).
- **Cursos**: MIT 6.1810 (xv6), Stanford CS140, Georgia Tech CS6210 (Advanced OS), "Linux Kernel Programming" (linux-kernel-labs).
- **Práctica**: Implementar xv6 (MIT), contribuir a Linux kernel, escribir módulos kernel, programas eBPF.
- **Herramientas**: perf, ftrace, eBPF/bcc, strace, ltrace, bpftrace, SystemTap, Valgrind, GDB, QEMU.

## Notas adicionales

Linux es el SO más importante para aprender por su dominio en servidores, cloud, contenedores, embebidos y supercomputación. Se recomienda instalarlo como SO principal o en VM/WSL para práctica diaria. Los conceptos de SO son independientes del SO específico y transferibles entre plataformas. La comprensión profunda de sistemas operativos distingue a un ingeniero de sistemas de un desarrollador de aplicaciones.
