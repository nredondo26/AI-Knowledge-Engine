# macOS

## Descripción

macOS es el SO de Apple para Mac, basado en el kernel XNU (híbrido: Mach + FreeBSD + IOKit). Destaca por su integración con el ecosistema Apple, seguridad (SIP, Gatekeeper) y rendimiento optimizado para Apple Silicon (M1–M4).

| Aspecto | Descripción |
|---------|-------------|
| Kernel | XNU (Mach + FreeBSD + IOKit) |
| Shell | zsh (default) |
| Filesystem | APFS |
| Paquetes | Homebrew, MacPorts |
| Arquitecturas | ARM64 (Apple Silicon), x86-64 (Intel) |

---

## Terminal y zsh

```bash
echo $SHELL                        # shell actual
chsh -s /bin/zsh                   # cambiar a zsh
open .                             # abrir Finder
open archivo.txt                   # abrir con app default
pbcopy < archivo.txt               # copiar al portapapeles
pbpaste                            # pegar
say "Hola mundo"                   # sintetizar voz
```

## Procesos

```bash
ps aux                             # todos los procesos
top -o cpu                         # ordenado por CPU
launchctl list                     # servicios launchd
launchctl load ~/Library/LaunchAgents/mi.app.plist
sudo dtruss ls                     # syscalls (DTrace)
```

## APFS (Apple File System)

```bash
diskutil list                      # discos y volúmenes
df -h                              # espacio disponible
du -sh ~/Documentos                # tamaño directorio
diskutil apfs list                 # contenedores APFS
diskutil apfs listSnapshots /      # snapshots
mdls archivo.txt                   # metadatos Spotlight
xattr -l archivo.txt               # atributos extendidos
csrutil status                     # estado de SIP
```

## Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update                        # actualizar lista
brew search python                 # buscar
brew install python                # instalar
brew install --cask firefox        # app GUI
brew services start postgresql     # servicio PostgreSQL
brew doctor                        # diagnosticar
```

## Networking

```bash
networksetup -getinfo Wi-Fi                  # IP Wi-Fi
networksetup -setdnsservers Wi-Fi 8.8.8.8    # DNS
ping -c 4 google.com                         # conectividad
nslookup google.com                          # DNS
lsof -i :8080                                # proceso en puerto
sudo pfctl -s rules                          # reglas firewall
```

## Apple Silicon (M1–M4)

```bash
uname -m                           # arm64 o x86_64
arch                               # arquitectura del shell
softwareupdate --install-rosetta   # instalar Rosetta 2
arch -x86_64 /bin/bash             # shell modo Intel
lipo -info /usr/bin/file           # ver arquitecturas binario
```

## Automatización

```bash
osascript -e 'tell app "Finder" to make new folder at desktop'
osascript -e 'tell app "Safari" to set URL of document 1 to "https://google.com"'
shortcuts list                     # listar atajos
shortcuts run "Mi Atajo"
system_profiler SPHardwareDataType # información de hardware
```

## Seguridad

| Mecanismo | Descripción |
|-----------|-------------|
| SIP | Protege archivos del sistema |
| Gatekeeper | Verifica apps notarizadas |
| FileVault 2 | Cifrado completo del disco (XTS-AES-128) |
| XProtect | Antimalware integrado |

```bash
csrutil status                     # SIP enabled/disabled
fdesetup status                    # FileVault activo
spctl --status                     # Gatekeeper activo
codesign -dv --verbose=4 /Applications/Safari.app  # verificar firma
```

---

## Relaciones

- [Kernel](../Kernel/) — XNU kernel, Mach microkernel, IOKit
- [FileSystems](../FileSystems/) — APFS, copy-on-write, snapshots
- [025-Mobile/iOS](../../025-Mobile/iOS/) — Tecnologías compartidas (Darwin, UIKit Catalyst)

## Recursos

- **Documentación**: developer.apple.com/documentation, support.apple.com
- **Libros**: "macOS Support Essentials" (Apple Training), "macOS Internals" (Levin)
- **Herramientas**: Xcode, Instruments, Console.app, Activity Monitor
