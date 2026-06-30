# PowerShell

Lenguaje interpretado, orientado a objetos (basado en .NET), tipado dinámico con tipado opcional. Creado por Microsoft (2006). Runtime: .NET (PowerShell Core 7+ multiplataforma, Windows PowerShell 5.1). Filosofía: trabajar con objetos (no texto), automatización, Verb-Noun naming.

## Sintaxis básica

```powershell
Write-Host "Hola, mundo"

$nombre = "Ana"
$edad = 30
$altura = 1.75
$activo = $true
$nulo = $null

$mensaje = "Hola, $nombre, tienes $edad años"

# Arrays
$frutas = @("manzana", "pera", "uva")
$frutas[0]                     # "manzana"
$frutas.Count                  # 4

# Hashtables
$capitales = @{ MX = "CDMX"; ES = "Madrid" }
$capitales.MX                  # "CDMX"

if ($edad -ge 18) {
    Write-Host "Mayor"
} elseif ($edad -gt 12) {
    Write-Host "Adolescente"
} else {
    Write-Host "Menor"
}

for ($i = 0; $i -lt 5; $i++) { $i }
foreach ($f in $frutas) { $f }

# Switch
switch ($edad) {
    {$_ -ge 18} { "Adulto" }
    {$_ -gt 12}  { "Adolescente" }
    default      { "Menor" }
}

function Sumar { param([int]$a, [int]$b) return $a + $b }

# Pipeline (objetos, no texto!)
Get-Process | Where-Object CPU -gt 10 | Sort-Object CPU -Descending
```

## Tipos y objetos

```powershell
# Todo es objeto .NET
$edad.GetType().FullName       # System.Int32
"texto".GetType().FullName     # System.String

# Casting
[int]"42"; [string]42; [double]"3.14"

# PSCustomObject
$usuario = [PSCustomObject]@{
    Nombre = "Ana"; Edad = 30; Activo = $true
}
$usuario.Nombre                # "Ana"
$usuario | ConvertTo-Json

# Clases (5.0+)
class Vehiculo {
    [string]$Marca
    Vehiculo([string]$m) { $this.Marca = $m }
    [string]Mover() { return "Vehículo se mueve" }
}

class Coche : Vehiculo {
    Coche([string]$m) : base($m) {}
    [string]Mover() { return "$($this.Marca) acelera" }
}

# Enum
enum Status { Activo; Inactivo; Pendiente }

# Validación
function Set-Edad {
    param(
        [ValidateRange(0,150)][int]$Edad,
        [ValidateSet("MX","ES")][string]$Pais
    )
}
```

## Pipeline y objetos

```powershell
# Pipeline pasa objetos entre cmdlets
Get-Service |
    Where-Object Status -eq 'Running' |
    Select-Object Name, DisplayName, Status |
    Export-Csv servicios.csv -NoTypeInformation

# Propiedades calculadas
Get-Process | Select-Object Name,
    @{N="MemoriaMB"; E={[math]::Round($_.WorkingSet/1MB, 2)}}

# Group-Object
Get-Process | Group-Object Company

# Custom objects en pipeline
1..5 | ForEach-Object {
    [PSCustomObject]@{ N = $_; C = $_ * $_ }
}
```

## Remoting y módulos

```powershell
# PowerShell Remoting (WinRM)
Invoke-Command -ComputerName servidor01 -ScriptBlock { Get-Service }

# PSSession
$s = New-PSSession -ComputerName servidor01
Invoke-Command -Session $s -FilePath script.ps1
Remove-PSSession $s

# WMI / CIM
Get-CimInstance Win32_Process
Get-CimInstance Win32_ComputerSystem

# Módulo
# modulo.psm1
function Get-MiFuncion { ... }
Export-ModuleMember -Function Get-MiFuncion

Import-Module ./modulo.psm1
Install-Module -Name Pester -Force

# Error handling
try {
    Get-Item ./no-existe.txt -ErrorAction Stop
} catch {
    Write-Error "Error: $_"
} finally {
    Write-Host "Siempre"
}
```

## Concurrencia

```powershell
# Jobs (procesos background)
$job = Start-Job -ScriptBlock { Start-Sleep 5; return "OK" }
Receive-Job -Job $job -Wait

# ForEach-Object -Parallel (PowerShell 7+)
1..10 | ForEach-Object -Parallel { $_ * 2 } -ThrottleLimit 5

# Runspaces (concurrencia avanzada)
$ps = [powershell]::Create()
$ps.AddScript({ Start-Sleep 2; "Async" })
$handle = $ps.BeginInvoke()
$result = $ps.EndInvoke($handle)
$ps.Dispose()
```

## Ecosistema

- **PowerShell Gallery** — repositorio de módulos (~3000+)
- **Módulos**: Pester (testing), PSScriptAnalyzer (linting), Dbatools (SQL)
- **Remoting**: WinRM (Windows), SSH (PowerShell Core 7+)
- **Cloud**: Azure PowerShell, AWS Tools for PowerShell
- **Formatos**: XML, JSON, CSV, CLIXML
- **IDE**: VS Code con PowerShell Extension

## Herramientas

```powershell
# Depuración
Set-PSDebug -Trace 1
Set-PSDebug -Strict

# Análisis
Invoke-ScriptAnalyzer -Path script.ps1 -Fix

# Testing con Pester
Invoke-Pester ./tests/ -Output Detailed

# Ejecución
.\script.ps1
pwsh -File script.ps1

# Execution Policy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Relaciones

- [Shell (POSIX)](../Shell/README.md)
- [Bash](../Bash/README.md)
- [Sistemas Operativos](../../004-OperatingSystems/README.md)
- [DevOps](../../013-DevOps/README.md)
```