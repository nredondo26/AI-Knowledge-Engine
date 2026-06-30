# BSD — Sistemas Berkeley Software Distribution

## Descripción del dominio

BSD (Berkeley Software Distribution) es una familia de sistemas operativos Unix derivados del código fuente de Unix desarrollado en la Universidad de California, Berkeley. Incluye FreeBSD, OpenBSD, NetBSD y DragonFly BSD. BSD es conocido por su licencia permisiva (BSD License), su estabilidad, su pila de red robusta, ZFS (en FreeBSD), su enfoque en seguridad (OpenBSD) y su portabilidad a múltiples arquitecturas (NetBSD). A diferencia de Linux, BSD tiene un kernel y userland desarrollados como un sistema integrado.

## Áreas clave

- **FreeBSD**: Sistema BSD más popular. Usado en servidores, dispositivos de red (pfSense, TrueNAS), almacenamiento (ZFS), contenedores (Jails), virtualización (bhyve)
- **OpenBSD**: Enfoque extremo en seguridad. Auditoría de código proactiva, OpenSSH, LibreSSL, pf (packet filter), memory protection, W^X, pledge, unveil
- **NetBSD**: Portabilidad extrema — soporta más de 50 arquitecturas hardware. Usado en sistemas embebidos, legacy hardware, investigación
- **DragonFly BSD**: Fork de FreeBSD 4.8 con enfoque en escalabilidad SMP y HAMMER (sistema de archivos con soporte de historial)

## Características distintivas

- **Kernel monolítico modular**: Cargable con `kldload` (FreeBSD), `modload` (OpenBSD)
- **Jails (FreeBSD)**: Contenedores ligeros similares a contenedores Linux, con su propio filesystem, red y procesos
- **ZFS**: Sistema de archivos y gestor de volúmenes avanzado (pool, snapshots, clones, compression, deduplication, checksums) — nativo en FreeBSD
- **pf (Packet Filter)**: Firewall stateful de OpenBSD, portable a FreeBSD y NetBSD
- **bhyve**: Hipervisor tipo 2 nativo de FreeBSD
- **DTRACE**: Herramienta de tracing dinámico (Solaris → FreeBSD)
- **Ports Collection**: Sistema de compilación de software desde fuente (similar a Gentoo)
- **pkg**: Gestor de paquetes binarios (FreeBSD)

## Ejemplo: Configuración de pf (OpenBSD/FreeBSD)

```pf
# /etc/pf.conf
ext_if = "em0"
int_if = "em1"
local_net = "10.0.0.0/24"

# Política por defecto: bloquear todo
block all

# Tráfico saliente permitido
pass out on $ext_if from $local_net to any nat-to ($ext_if)

# SSH entrante permitido
pass in on $ext_if proto tcp to port 22

# Regla de rdr (redirección de puertos)
rdr on $ext_if proto tcp to port 80 -> 10.0.0.10 port 8080
```

## Ejemplo: Jail en FreeBSD

```sh
# Crear jail básica
ezjail-admin create mi-jail '10.0.0.2'
ezjail-admin start mi-jail
ezjail-admin console mi-jail
```

## Tecnologías principales

| Sistema | Enfoque principal | Licencia |
|---------|-------------------|----------|
| FreeBSD | Servidores, almacenamiento, virtualización | BSD 2-clause |
| OpenBSD | Seguridad, criptografía, firewall | ISC / BSD |
| NetBSD | Portabilidad, sistemas embebidos | BSD 2-clause |
| DragonFly BSD | Escalabilidad SMP, HAMMER, clusters | BSD |

## Herramientas y comandos específicos

- `kldstat` / `kldload` / `kldunload` — gestión de módulos del kernel
- `jexec` / `jls` — gestión de jails
- `zfs list` / `zpool status` — administración ZFS
- `pfctl` — control del firewall pf
- `ifconfig` — configuración de red (más potente que en Linux)
- `pkg` / `pkgng` — gestión de paquetes
- `portsnap` / `gitup` — actualización del árbol de ports
- `beadm` — gestión de boot environments (ZFS snapshots del sistema)
- `camcontrol` — gestión de dispositivos SCSI/SATA

## Buenas prácticas

- Preferir ZFS para almacenamiento crítico por su integridad de datos y snapshots
- Usar jails para aislar servicios en FreeBSD
- Configurar pf para seguridad de red con reglas deny-by-default
- Seguir las recomendaciones de seguridad de OpenBSD (W^X, pledge, unveil)
- Usar boot environments (`beadm`) antes de actualizaciones mayores para poder revertir
