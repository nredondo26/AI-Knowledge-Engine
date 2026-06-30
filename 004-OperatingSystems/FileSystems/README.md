# FileSystems

## Descripción

Un sistema de archivos organiza y almacena datos en dispositivos de almacenamiento. Define cómo se estructuran, nombran y recuperan archivos. El kernel provee VFS (Virtual File System) para que múltiples FS coexistan bajo una misma API.

| Filesystem | SO nativo | Journaling | COW | Snapshots | Compresión |
|-----------|-----------|-----------|-----|-----------|------------|
| ext4 | Linux | Sí | No | No | No |
| XFS | Linux | Sí | No | No | No |
| Btrfs | Linux | Sí | Sí | Sí | Sí (zstd) |
| ZFS | Linux/FreeBSD | Sí | Sí | Sí | Sí (lz4) |
| NTFS | Windows | Sí | No | No | Sí |
| APFS | macOS | Sí | Sí | Sí | Sí |
| FAT32 | Cross-platform | No | No | No | No |

---

## Inodos y Metadatos

```bash
ls -li archivo.txt                  # número de inodo (-i)
stat archivo.txt                    # toda la info del inodo
df -i                               # inodos totales/usados
df -hT                              # tipo de FS y espacio
debugfs /dev/sda1 -R "stat <12345>" # inspeccionar inodo en ext4
```

## Journaling

```bash
tune2fs -l /dev/sda1 | grep "Filesystem features"  # has_journal?
tune2fs -O ^has_journal /dev/sda1  # deshabilitar journal
tune2fs -j /dev/sda1                # habilitar journal
fsck.ext4 -f /dev/sda1             # verificar y reparar
```

## Copy-on-Write (COW)

```bash
# Btrfs
btrfs subvolume create /mnt/datos/@subvol
btrfs subvolume snapshot /mnt/datos/@subvol /mnt/datos/@snap
btrfs subvolume delete /mnt/datos/@snap
chattr +C /mnt/datos/db/            # deshabilitar COW en directorio

# ZFS
zfs create pool/datos
zfs snapshot pool/datos@hoy
zfs rollback pool/datos@hoy
zfs destroy pool/datos@hoy
zfs list -t snapshot
```

## Operaciones Comunes

```bash
# Crear sistemas de archivos
mkfs.ext4 /dev/sda1                 # ext4
mkfs.xfs /dev/sda2                  # XFS
mkfs.btrfs /dev/sda3                # Btrfs
mkfs.ntfs -f /dev/sda4              # NTFS
mkfs.fat -F32 /dev/sdb1             # FAT32

# Montaje
mount -t ext4 /dev/sda1 /mnt/disco
mount -o noatime,compress=zstd /dev/sda3 /mnt/btrfs
umount /mnt/disco

# fstab (/etc/fstab)
# UUID=abc-123 /mnt/disco ext4 defaults,noatime 0 2

# Redimensionar
resize2fs /dev/sda1                 # redimensionar ext4
xfs_growfs /mnt/disco               # redimensionar XFS
btrfs filesystem resize +10G /mnt   # crecer Btrfs
truncate -s 100M archivo.vhd        # extender archivo
fallocate -l 1G archivo.vhd         # pre-asignar archivo rápido
```

## Filesystems Avanzados

```bash
# Btrfs RAID
mkfs.btrfs -L "Pool" -d raid1 -m raid1 /dev/sda /dev/sdb
btrfs device add /dev/sdc /mnt/pool # agregar dispositivo
btrfs filesystem balance /mnt/pool  # rebalancear
mount -o compress=zstd:3 /dev/sda3 /mnt  # compresión

# ZFS RAID-Z
zpool create pool raidz /dev/sda /dev/sdb /dev/sdc /dev/sdd
zfs set compression=lz4 pool/datos
zfs set dedup=on pool/datos        # deduplicación (consume RAM)
zfs send pool/datos@snap1 | zfs receive backup/datos  # backup

# XFS
mkfs.xfs -b size=4096 -d agcount=4 /dev/sda1
xfs_info /mnt/disco                 # información del FS
xfs_repair /dev/sda1                # reparación
```

## Rendimiento

```bash
cat /sys/block/sda/queue/scheduler  # I/O scheduler (mq-deadline, none, kyber)
echo kyber > /sys/block/sda/queue/scheduler
blockdev --setra 4096 /dev/sda      # readahead de 2048KB
cat /proc/sys/vm/dirty_ratio        # % RAM dirty pages (default 20%)
cat /proc/sys/vm/vfs_cache_pressure # presión de cache VFS (default 100)
```

## Filesystems Virtuales

```bash
mount -t tmpfs -o size=2G tmpfs /mnt/ram      # RAM disk
mount -t overlay overlay -o lowerdir=/lower,... /merged  # overlayfs (Docker)
ls /proc                              # procfs (procesos)
ls /sys                               # sysfs (dispositivos)
ls /dev                               # devtmpfs (dispositivos)
```

---

## Relaciones

- [Kernel](../Kernel/) — VFS, page cache, block layer, I/O schedulers
- [Linux](../Linux/) — ext4, XFS, Btrfs, mount, fsck, LVM
- [006-Containers](../../006-Containers/) — OverlayFS (Docker), volúmenes

## Recursos

- **Libros**: "The Design and Implementation of the FreeBSD Operating System" (McKusick), "ZFS Mastery" (Peters)
- **Documentación**: kernel.org/doc/Documentation/filesystems, open-zfs.org, btrfs.wiki.kernel.org
- **Herramientas**: fio (benchmark), blktrace, iostat, iotop
