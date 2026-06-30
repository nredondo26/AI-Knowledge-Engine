# Linux

## Descripción

Linux es un sistema operativo de código abierto basado en el kernel monolítico modular de Linux. Es el SO dominante en servidores, cloud, contenedores y supercomputación.

| Aspecto | Descripción |
|---------|-------------|
| Kernel | Monolítico modular |
| Init | systemd (mayoría) |
| Shell | bash, zsh, fish |
| Filesystem | ext4, XFS, Btrfs, ZFS |
| Paquetes | apt, dnf, pacman, apk |

---

## Gestión de Procesos

```bash
ps aux                              # procesos del sistema
pstree -p                           # árbol de procesos
top -o %MEM                         # monitoreo interactivo
htop                                # top mejorado
kill -9 PID                         # SIGKILL
kill -15 PID                        # SIGTERM
nice -n 10 ./script.sh              # prioridad baja
renice -n -5 -p PID                 # prioridad alta

systemctl status nginx              # servicio systemd
systemctl start/stop/restart nginx  # gestionar servicio
journalctl -u nginx -f              # logs en tiempo real
```

## Sistema de Archivos

```bash
df -h                               # espacio en discos
du -sh /var/log                     # tamaño directorio
mount /dev/sda1 /mnt                # montar partición
umount /mnt                         # desmontar
chmod 755 script.sh                 # permisos rwxr-xr-x
chown usuario:grupo archivo         # propietario
ln -s /ruta/origen enlace           # symlink

mkfs.ext4 /dev/sda1                 # formatear ext4
mkfs.xfs /dev/sda2                  # formatear XFS
fsck /dev/sda1                      # verificar y reparar
tune2fs -l /dev/sda1                # parámetros ext4
```

## Redes

```bash
ip addr                             # direcciones IP
ip route                            # tabla de enrutamiento
ss -tulpn                           # sockets escuchando
nft list ruleset                    # firewall nftables
ping -c 4 google.com               # conectividad
curl -I https://ejemplo.com         # headers HTTP
dig google.com A                    # consulta DNS
```

## Rendimiento y Diagnóstico

```bash
uname -a                            # información del kernel
lscpu                               # información de CPU
free -h                             # memoria RAM
vmstat 1                            # estadísticas cada 1s
iostat -xz 1                        # I/O de discos
strace -p PID                       # syscalls de proceso
perf top                            # perfil de CPU
```

## Contenedores (Namespaces y Cgroups)

```bash
unshare --pid --fork bash           # nuevo namespace PID
lsns                                # namespaces activos
systemd-run --user --scope -p MemoryMax=500M ./script.sh  # límite RAM
```

## eBPF

```bash
bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%s\n", comm); }'
execsnoop-bpfcc                     # monitorear nuevos procesos
opensnoop-bpfcc                     # archivos abiertos
```

---

## Relaciones

- [Kernel](../Kernel/) — Arquitectura, syscalls, scheduling
- [FileSystems](../FileSystems/) — ext4, XFS, Btrfs, inodos
- [006-Containers](../../006-Containers/) — Namespaces, cgroups, Docker
- [009-Security](../../009-Security/) — SELinux, AppArmor, seccomp

## Recursos

- **Libros**: "The Linux Programming Interface" (Kerrisk), "Linux Kernel Development" (Love)
- **Documentación**: kernel.org/doc, man7.org
- **Cursos**: Linux Foundation LFS201
