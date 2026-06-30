# Windows

## Descripción

Windows es un sistema operativo de Microsoft basado en el kernel NT (híbrido). Es el SO de escritorio más utilizado e integra WSL2, Hyper-V, contenedores, Active Directory y DirectX.

| Aspecto | Descripción |
|---------|-------------|
| Kernel | NT (híbrido) |
| Shell | PowerShell, CMD |
| Filesystem | NTFS, ReFS, exFAT |
| Paquetes | winget, Chocolatey |
| Virtualización | Hyper-V, WSL2 |

---

## PowerShell

```powershell
Get-ChildItem                       # ls
Get-Content archivo.txt             # cat
Copy-Item origen destino            # cp
Remove-Item archivo                 # rm
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
Get-Service | Where-Object Status -eq 'Running'
```

## Procesos y Servicios

```powershell
Get-Process -Name notepad           # proceso por nombre
Stop-Process -Name notepad          # matar proceso
Start-Process notepad.exe           # iniciar proceso

Get-Service                          # listar servicios
Start/Stop/Restart-Service -Name W3SVC
Set-Service -Name W3SVC -StartupType Automatic
```

### CMD Legacy

```cmd
tasklist                          :: listar procesos
taskkill /F /IM notepad.exe       :: matar proceso
net start W3SVC                   :: iniciar servicio
sc query W3SVC                    :: consultar servicio
```

## NTFS

```powershell
Get-PSDrive                       # unidades disponibles
Get-Disk                          # discos físicos
Get-Acl C:\ruta                   # ver permisos
icacls C:\ruta /grant "usuario:(R,W)" /T
New-Item -ItemType SymbolicLink -Path "C:\enlace" -Target "C:\origen"
```

## Networking

```powershell
Get-NetAdapter                    # interfaces de red
Get-NetIPAddress                  # direcciones IP
Get-NetRoute                      # tabla de enrutamiento
Test-Connection google.com        # ping
Test-NetConnection google.com -Port 443
Resolve-DnsName google.com        # consulta DNS
```

```cmd
ipconfig /all                     :: configuración
ipconfig /flushdns                :: limpiar caché DNS
ping google.com -t                :: ping continuo
netstat -anob                     :: conexiones con PID
```

## WSL2

```powershell
wsl --install                     # instalar WSL2 + Ubuntu
wsl -l -v                         # distribuciones instaladas
wsl --set-version Ubuntu 2        # convertir a WSL2
wsl ls -la                        # ejecutar comando Linux
# Archivos en \\wsl.localhost\Ubuntu\home\user
```

## Hyper-V

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
New-VM -Name "UbuntuVM" -MemoryStartupBytes 4GB
Start-VM -Name "UbuntuVM"
Checkpoint-VM -Name "UbuntuVM" -SnapshotName "Backup"
```

## Active Directory

```powershell
Import-Module ActiveDirectory
Get-ADUser -Filter *
New-ADUser -Name "Juan Perez" -SamAccountName jperez -Enabled $true
Get-ADGroup -Filter *
Add-ADGroupMember -Identity "Domain Admins" -Members jperez
```

---

## Relaciones

- [Kernel](../Kernel/) — Arquitectura NT kernel vs Linux
- [FileSystems](../FileSystems/) — NTFS vs ext4, journaling, ACLs
- [005-Cloud/Azure](../../005-Cloud/Azure/) — Windows Server, Azure AD
- [009-Security](../../009-Security/) — Defender, BitLocker, AppLocker

## Recursos

- **Documentación**: learn.microsoft.com/windows, learn.microsoft.com/powershell
- **Libros**: "Windows Internals" (Russinovich), "PowerShell in Action" (Jones)
- **Herramientas**: Sysinternals Suite (Process Explorer, Process Monitor)
