# Unix — Sistemas Operativos Unix

## Descripción del dominio

Unix es una familia de sistemas operativos multitarea y multiusuario originada en los laboratorios Bell de AT&T en los años 1970. Su filosofía de diseño —herramientas pequeñas y modulares que hacen una sola cosa bien, conectadas mediante pipes y archivos de texto— sentó las bases de Linux, macOS y BSD. Este módulo cubre la historia de Unix, su arquitectura de kernel, el sistema de archivos, la shell, las utilidades estándar, scripting en shell, señales, procesos, permisos, y el estándar POSIX.

## Áreas clave

- **Historia y versiones**: Unix V1–V7, System V (AT&T), BSD (Berkeley), Solaris (Sun), AIX (IBM), HP-UX (HP), Tru64 (DEC)
- **Estandarización POSIX**: IEEE 1003.1 — interfaz portable del sistema operativo, syscalls, shell, utilidades
- **Shell y scripting**: sh (Bourne), bash, ksh, zsh, csh/tcsh — scripting con variables, pipes, redirección, subshells, jobs
- **Permisos y seguridad**: chmod, chown, chgrp, umask, ACLs, sticky bit, setuid/setgid, capabilities (Linux)
- **Procesos y señales**: fork/exec/wait, foreground/background, jobs, señales (SIGKILL, SIGTERM, SIGHUP, SIGUSR1/2), nohup, daemons
- **Sistema de archivos**: jerarquía FHS, /etc, /var, /usr, /tmp, /dev, /proc, /sys — inodos, hard/soft links (ln), mount/umount, fstab
- **Pipes y redirección**: |, >, >>, <, 2>, &>, tee, xargs, named pipes (mkfifo)
- **Expresiones regulares**: grep, sed, awk, regex básica (BRE) y extendida (ERE)
- **Utilidades fundamentales**: find, sort, uniq, cut, tr, diff, patch, tar, gzip, ps, top, kill, nice, renice, df, du, dd, file, which, whereis

## Ejemplo: Script básico de Unix

```bash
#!/bin/sh
# Script: backup.sh — respaldo con tar y compresión
BACKUP_DIR="/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
tar czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" \
  --exclude='*.log' \
  --exclude='node_modules' \
  /home/user/documents
echo "Backup completado: backup_$TIMESTAMP.tar.gz"
```

## Ejemplo: Manejo de señales

```bash
#!/bin/bash
cleanup() {
    echo "Recibida señal. Limpiando..."
    rm -f /tmp/tempfile_$$
    exit 0
}
trap cleanup SIGINT SIGTERM
echo "PID: $$. Esperando señal..."
while true; do sleep 1; done
```

## Tecnologías principales

- **Solaris 11**: Unix de Oracle con ZFS, DTrace, zones/containers
- **FreeBSD**: Unix derivado de BSD, conocido por estabilidad, ZFS, jails, pf
- **OpenBSD**: Enfoque en seguridad, auditoría de código, OpenSSH, pf
- **macOS**: Unix certificado POSIX (XNU kernel, basado en Mach + FreeBSD)
- **AIX**: Unix de IBM para servidores Power, con LVM, SMIT, WPARs
- **HP-UX**: Unix de HP para servidores Itanium/PA-RISC

## Herramientas de desarrollo

| Herramienta | Propósito |
|-------------|-----------|
| make | Automatización de compilación |
| lex/yacc | Generación de analizadores léxicos/sintácticos |
| SCCS/RCS | Control de versiones históricos |
| dbx / gdb | Depuradores |
| prof / gprof | Perfilado de rendimiento |
| lint | Análisis estático de código C |

## Buenas prácticas

- Usar `#!/bin/sh` para scripts portables (POSIX sh), `#!/bin/bash` solo si se necesitan extensiones
- Capturar señales con `trap` para limpieza de recursos temporales
- Citar variables siempre: `"$var"` en lugar de `$var`
- Usar `set -e` para fallar en errores, `set -u` para variables no definidas
- Preferir `printf` sobre `echo` para salida portable

## Recursos de aprendizaje

- *The Unix Programming Environment* (Kernighan & Pike) — clásico indispensable
- *Advanced Programming in the UNIX Environment* (Stevens) — referencia de sistemas
- POSIX Shell: https://pubs.opengroup.org/onlinepubs/9699919799/
- TLDP (The Linux Documentation Project): guías y HOWTOs de shell scripting
- Unix history: https://www.bell-labs.com/usr/dmr/www/hist.html

## Herramientas de diagnóstico

| Comando | Propósito |
|---------|-----------|
| strace | Traza syscalls de un proceso |
| ltrace | Traza llamadas a librerías compartidas |
| lsof | Lista archivos abiertos por proceso |
| vmstat | Estadísticas de memoria virtual y procesos |
| iostat | Estadísticas de entrada/salida de discos |
| netstat / ss | Estadísticas de red y sockets |
| tcpdump | Captura de paquetes de red |
| dmesg | Mensajes del kernel y drivers |
