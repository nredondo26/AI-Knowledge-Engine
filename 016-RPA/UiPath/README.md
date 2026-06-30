# UiPath — Automatización Robótica de Procesos (RPA)

## Visión General

UiPath es la plataforma líder de RPA (Robotic Process Automation). Permite automatizar tareas repetitivas mediante robots de software que interactúan con aplicaciones Windows, web, mainframe y APIs.

## Arquitectura de la Plataforma

```
┌──────────────────────────────────────────────────┐
│                  UiPath Platform                 │
├──────────────────────────────────────────────────┤
│  Studio        Orchestrator         Robots       │
│  (Desarrollo)  (Gestión central)   (Ejecución)   │
│  ┌────────┐    ┌───────────────┐   ┌─────────┐   │
│  │ Procesos│   │ Queue          │   │Attended │   │
│  │Activities│   │ Triggers       │   │(asistido)│   │
│  │Variables│   │ Jobs           │   ├─────────┤   │
│  │Workflows│   │ Assets         │   │Unattended│   │
│  └────────┘    │ Monitoring     │   │(no asist.)│   │
│                │ Multi-tenant   │   └─────────┘   │
│                └───────────────┘                  │
└──────────────────────────────────────────────────┘
```

## Componentes Clave

| Componente | Propósito |
|------------|-----------|
| **UiPath Studio** | IDE para diseñar automatizaciones (XAML) |
| **UiPath Robot** | Ejecuta los procesos (Service Mode / User Mode) |
| **UiPath Orchestrator** | Gestión centralizada (web-based) |
| **UiPath Assistant** | Lanzador de procesos para el usuario |
| **AI Center** | Modelos de ML integrados en automatizaciones |
| **Test Manager** | Gestión de pruebas de automatización |
| **Document Understanding** | Extracción de datos de documentos no estructurados |
| **Task Capture** | Grabador de procesos (requisitos → automatización) |

## Tipos de Proyectos

```yaml
Process:
  - Secuencia lineal de actividades
  - Ideal para automatizaciones simples
  - Archivo principal: Main.xaml

Library:
  - Componentes reutilizables
  - Actividades, workflows y templates
  - Publicable en feed interno

State Machine:
  - Flujos con múltiples estados y transiciones
  - Para procesos complejos con condiciones

Orchestration Process:
  - Orchestrator + Robot
  - Reflective journaling, pauses, resumption

Test Automation:
  - Pruebas automatizadas de UI
  - Basado en Test Manager
```

## Actividades Fundamentales

```xml
<!-- Ejemplo: Secuencia simple (Main.xaml) -->
<Sequence DisplayName="Proceso de Login">
  <Log Message="Iniciando proceso"/>
  <OpenBrowser Url="https://portal.example.com">
    <TypeInto Target="input#username" Text="user01"/>
    <TypeInto Target="input#password" Text="pass123"/>
    <Click Target="button#login"/>
  </OpenBrowser>
  <If Condition="IsVisible(Target: div.error-message)">
    <Then>
      <Log Message="Login fallido"/>
      <Throw Exception="Credenciales inválidas"/>
    </Then>
    <Else>
      <Log Message="Login exitoso"/>
      <TakeScreenshot SaveAs="login_ok.png"/>
    </Else>
  </If>
</Sequence>
```

## Selectores (UI Automation)

Los selectores identifican elementos de la interfaz de usuario mediante atributos.

```
# Selector de ejemplo para Chrome
<webctrl tag='INPUT' aaname='Usuario' type='text' />

# Selector para Windows Forms
<ctrl name='txtEmail' role='editable text' />

# Selector dinámico (wildcard)
<webctrl tag='INPUT' aaname='*Factura*' />

# Selector con variables
<webctrl tag='INPUT' aaname='{strUser}' />
```

### Buenas Prácticas con Selectores

1. Usar atributos estables (`id`, `name`, `title`) sobre atributos dinámicos
2. Evitar `idx` (índice) — cambia con cada ejecución
3. Usar wildcards `*` para texto parcial
4. Preferir selectores parciales sobre completos (menos frágiles)
5. Validar selectores con **UI Explorer**

## Manejo de Variables y Argumentos

```
Scope:
  Variables:  Dentro del workflow actual
  Arguments:  Entre workflows (In/Out/InOut)

Tipos comunes:
  String, Int32, Boolean, DateTime
  DataTable, List<T>, Dictionary<T>
  GenericValue (autodetecta tipo)
  
Propiedades especiales:
  Autosave (Settings): Guarda valor entre sesiones
  Default value: Valor por defecto
```

## Manejo de Tablas (DataTable)

```vb
' Crear DataTable
Dim dt = New DataTable()
dt.Columns.Add("Nombre", GetType(String))
dt.Columns.Add("Edad", GetType(Integer))
dt.Rows.Add("Ana", "30")
dt.Rows.Add("Luis", "25")

' Filtrar
Dim filtrados = dt.Select("Edad > 25")

' Ordenar
dt.DefaultView.Sort = "Nombre ASC"

' Exportar a CSV
Dim csv = dt.ToCSV()
```

## Manejo de Excel

```vb
' Leer rango
Dim data = ReadRange WorkbookPath:="datos.xlsx"
              SheetName:="Sheet1"
              Range:="A1:C10"

' Escribir DataTable
WriteRange WorkbookPath:="output.xlsx"
           SheetName:="Resultados"
           DataTable:="dtResultados"

' Fórmulas
SetCell WorkbookPath:="reporte.xlsx"
         SheetName:="Sheet1"
         Cell:="D2"
         Value:="=SUM(A2:C2)"
```

## API Integration (HTTP Request)

```vb
' GET request
Dim response = HttpRequest(
    Method:=HttpMethod.Get,
    EndPoint:="https://api.example.com/users",
    Headers:=New Dictionary(Of String, String) From {
        {"Authorization", "Bearer " + token}
    }
)

' POST con JSON
Dim payload = "{""name"":""test""}"
Dim postResponse = HttpRequest(
    Method:=HttpMethod.Post,
    EndPoint:="https://api.example.com/users",
    Body:=payload,
    Headers:=New Dictionary(Of String, String) From {
        {"Content-Type", "application/json"}
    }
)
```

## Document Understanding

Pipeline típico de Document Understanding:

```
Digitalizar (OCR)  →  Classify (Tipo doc)  →  Extract (Campos)  →  Validate (Revisión)  →  Export (Datos)
```

```xml
<Sequence>
  <Log Message="Procesando factura"/>
  <OCR DocumentPath="factura.pdf" ProfileName="Spanish"/>
  <DocumentClassifier TaxonomyPath="taxonomy.json"/>
  <DataExtraction ExtractorType="Regex">
    <Field Name="InvoiceNumber" Pattern="INV-\d{6}"/>
    <Field Name="Total" Pattern="Total:\s*(\d+[.,]\d{2})"/>
  </DataExtraction>
  <ExportToExcel OutputPath="facturas.csv"/>
</Sequence>
```

## Manejo de Errores

```vb
Try
    ' Actividad que puede fallar
    Click "button#submit"
Catch ex As Exception
    Log Message:="Error: " + ex.Message
    TakeScreenshot "error.png"
    Throw ex
Finally
    ' Siempre ejecuta
    CloseApplication "Chrome"
End Try
```

## Orquestación (Orchestrator)

```yaml
Queue Management:
  - Transacciones: Items individuales a procesar
  - Priority: Alta, Media, Baja
  - Retry: Número de reintentos
  - Deadline: Tiempo máximo

Triggers:
  - Time trigger: Horario definido (cron)
  - Queue trigger: Nuevo item en cola
  - System event: Archivo creado, email recibido

Assets:
  - Credenciales encriptadas
  - Configuraciones sensitivas
  - Alcance: Global o por robot

Process Scheduling:
  - Ejecución en horario laboral
  - Maintenance windows
  - Load balancing entre robots
```

## AI Center — ML Skills

```yaml
ML Skills disponibles:
  - Form Extraction: Facturas, formularios
  - Document Classification: Tipos de documento
  - Document Understanding: Extracción semántica
  - DU Action Center: Revisión humana de bordercases

Entrenamiento:
  - Data labeling (Action Center)
  - Pipeline de entrenamiento
  - Evaluación vs ground truth
  - Despliegue como skill
```

## Monitoring y Logs

```vb
' Logging estructurado
Log Message:="Nivel INFO" Level:=LogLevel.Info
Log Message:="Advertencia" Level:=LogLevel.Warn
Log Message:="Error crítico" Level:=LogLevel.Error

' Tracing (Verbose)
Trace "Valor de variable: " + variable.ToString()

' Performance counter
StartTimer "proceso_completo"
' ... actividades ...
StopTimer "proceso_completo"
```

## Mejores Prácticas

1. **Modularizar** — Workflows pequeños y reutilizables
2. **Naming conventions** — `btnSubmit`, `txtEmail`, `dtClientes`
3. **Gestión de errores** — Try/Catch/Finally siempre
4. **Logging** — Suficiente para depuración post-mortem
5. **Selectores estables** — Validar con UI Explorer
6. **Configuración externa** — Assets/Config files, no hardcode
7. **Versioning** — Orchestrator packages + git
8. **Testing** — Test Manager + Mock activities

## Referencias

- [UiPath Documentation](https://docs.uipath.com/)
- [UiPath Studio Guide](https://docs.uipath.com/studio/)
- [UiPath Orchestrator Guide](https://docs.uipath.com/orchestrator/)
- [UiPath Community](https://community.uipath.com/)
- [UiPath Academy](https://academy.uipath.com/)
- [UiPath Marketplace](https://marketplace.uipath.com/)
