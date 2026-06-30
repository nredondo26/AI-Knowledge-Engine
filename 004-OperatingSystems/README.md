# 004-OperatingSystems: Sistemas Operativos

## Descripción del dominio

Un sistema operativo es el software fundamental que gestiona el hardware y provee servicios a las aplicaciones. Este módulo cubre los conceptos esenciales de los sistemas operativos modernos: gestión de procesos e hilos (threads), planificación (scheduling), sincronización, gestión de memoria (virtual, paginación, segmentación), sistemas de archivos, entrada/salida (drivers, interrupciones), virtualización y seguridad a nivel de sistema. Se enfoca principalmente en Linux (por su relevancia en servidores, cloud y contenedores), Windows y macOS.

## Conceptos clave

- **Procesos vs hilos**: PCB (Process Control Block), espacio de direcciones, cambio de contexto, hilos a nivel de usuario vs kernel
- **Planificación (scheduling)**: FCFS, SJF, Round Robin, Multilevel Feedback Queue (MLFQ), CFS (Linux), O(1) scheduler
- **Concurrencia y sincronización**: Mutexes, semáforos, monitores, variables de condición, barriers, spinlocks, RCU (Read-Copy-Update)
- **Deadlocks**: Condiciones de Coffman, prevención, evasión (algoritmo del banquero), detección y recuperación
- **Memoria virtual**: Paginación (page tables, TLB, multi-level page tables), segmentación, swapping, page replacement (LRU, Clock, NRU, LFU)
- **Asignación de memoria**: Buddy system, slab allocator, malloc/free, mmap, brk, page faults, thrashing
- **Sistemas de archivos**: Inodos, VFS (Virtual File System), ext4, XFS, Btrfs, ZFS, NTFS, APFS; journaling, COW (Copy-on-Write)
- **Entrada/Salida**: Buffered vs unbuffered I/O, mmap, DMA, interrupciones, polling, SPOOLing, disk scheduling (Elevator/SCAN)
- **Llamadas al sistema (syscalls)**: read, write, open, close, fork, execve, mmap, sbrk, ioctl, select, epoll, io_uring
- **Espacio de usuario vs kernel**: Anillos de protección (ring 0-3), system calls, módulos del kernel, eBPF
- **Contenedores como procesos**: Namespaces (PID, NET, MNT, UTS, IPC, USER, CGROUP), cgroups v1/v2, unshare, pivot_root
- **POSIX**: Estándar de portabilidad, signals, pipes, FIFOs, sockets Unix, semáforos POSIX, shared memory POSIX

## Tecnologías principales

| Componente | Linux | Windows | macOS |
|------------|-------|---------|-------|
| Kernel | Linux kernel (monolítico modular) | NT kernel (híbrido) | XNU (híbrido, basado en Mach + FreeBSD) |
| Init system | systemd | NT (Session Manager) | launchd |
| Filesystem | ext4, XFS, Btrfs, ZFS | NTFS, ReFS | APFS |
| Package manager | apt, dnf, pacman, apk | winget, Chocolatey | Homebrew, MacPorts |
| Container support | Nativo (cgroups/namespaces) | Docker Desktop, WSL2 | Docker Desktop |
| Shell | bash, zsh, fish | PowerShell, CMD | zsh (por defecto desde Catalina) |
| Monitorización | top, htop, perf, strace, eBPF | Process Monitor, ETW | Activity Monitor, dtrace, Instruments |

## Hoja de ruta

1. **Principiante**: Comandos básicos de Linux (ls, cd, mv, cp, rm, chmod, chown, ps, top) — estructura del sistema de archivos (FHS) — pipes y redirección — bash scripting básico — gestores de paquetes
2. **Intermedio**: Procesos (ps, top, htop, kill, nice, renice) — permisos (u/g/o, ACL, sticky bit, SUID/SGID) — syscalls — systemd (unit files, journalctl) — networking (ip, ss, netstat, iptables/nftables) — cron/systemd timers
3. **Avanzado**: Planificación de procesos (CFS, nice values) — memoria virtual (vmstat, /proc/meminfo, OOM killer) — sistemas de archivos (mkfs, mount, tune2fs, fsck) — namespaces y cgroups — eBPF básico — strace, ltrace, perf, bpftrace
4. **Experto**: Módulos del kernel, escritura de device drivers — eBPF avanzado (XDP, TC) — KVM/QEMU virtualización — SELinux/AppArmor — rendimiento extremo (NUMA, huge pages, CPU pinning, io_uring) — RTOS para sistemas embebidos/tiempo real

## Relaciones con otros módulos

- [000-Core](../000-Core/) — Algoritmos de planificación y page replacement; gestión de memoria
- [001-Languages](../001-Languages/) — Compilación nativa, syscalls desde lenguajes (Go, Rust, C), FFI
- [005-Cloud](../005-Cloud/) — AMIs (Amazon Machine Images), imágenes de VM en cloud, optimización de SO
- [006-Containers](../006-Containers/) — Namespaces, cgroups, imágenes Docker, WSL2
- [007-Orchestration](../007-Orchestration/) — Nodos K8s, sistema operativo del nodo (Container-Optimized OS, Bottlerocket, Flatcar)
- [008-Networking](../008-Networking/) — TCP/IP stack del kernel, netfilter, eBPF/XDP, socket programming
- [009-Security](../009-Security/) — SELinux, AppArmor, seccomp, grsecurity, kernel hardening
- [028-Embedded](../028-Embedded/) — Linux embebido (Yocto, Buildroot), RTOS (FreeRTOS, Zephyr)

## Recursos recomendados

- **Libros**: "Operating Systems: Three Easy Pieces" (Arpaci-Dusseau) — excelente y gratuito online; "Modern Operating Systems" (Tanenbaum); "The Linux Programming Interface" (Kerrisk)
- **Cursos**: MIT 6.S081 (xv6), Stanford CS140, Udacity: Introduction to Operating Systems
- **Linux**: kernel.org/doc, "Linux Kernel Development" (Love), The Linux Documentation Project
- **Herramientas**: VirtualBox / QEMU para experimentar, Vagrant para entornos reproducibles
