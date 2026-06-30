# Certificaciones SAP

## Visión General

SAP es el líder global en sistemas ERP (Enterprise Resource Planning). Sus certificaciones cubren módulos funcionales y técnicos para implementar, configurar y mantener el ecosistema SAP.

## Categorías de Certificación

### SAP Certified Application Associate

Certificaciones funcionales por módulo SAP:

| Módulo | Área | Código típico |
|--------|------|---------------|
| SAP S/4HANA Finance | Contabilidad y controlling | C_TS4FI_2023 |
| SAP S/4HANA Sales (SD) | Ventas y distribución | C_TS460_2022 |
| SAP S/4HANA Procurement | Compras (MM) | C_TS452_2022 |
| SAP S/4HANA Production | Planificación (PP) | C_TS422_2022 |
| SAP SuccessFactors | HR / HXM | C_THR82_2305 |
| SAP Analytics Cloud | BI y reporting | C_SAC_2302 |

### SAP Certified Technology Associate

Profesionales técnicos:

| Certificación | Enfoque |
|---------------|---------|
| SAP BTP | Business Technology Platform (cloud) |
| SAP ABAP | Programación clásica en SAP |
| SAP Fiori | Desarrollo de UX moderna |
| SAP HANA | Base de datos in-memory |
| SAP Cloud Platform | Integración cloud |
| SAP Basis | Administración del sistema |

### SAP Certified Professional

Nivel experto (múltiples exámenes + proyecto):

```
SAP Certified Professional:
- SAP Activate Project Manager
- SAP S/4HANA Cloud (public/private)
- SAP Enterprise Architecture
```

## SAP S/4HANA Architecture

```
┌──────────────────────────────────────┐
│           Fiori Launchpad            │
├──────────────────────────────────────┤
│  Gateway / OData / REST / SOAP       │
├──────────────────────────────────────┤
│  Application Layer (ABAP / Java)     │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐   │
│  │ FI  │ │ CO  │ │ SD  │ │ MM  │...│
│  └─────┘ └─────┘ └─────┘ └─────┘   │
├──────────────────────────────────────┤
│  Database Layer (SAP HANA)           │
│  ┌─────────────────────────────┐     │
│  │  In-Memory Column Store     │     │
│  └─────────────────────────────┘     │
└──────────────────────────────────────┘
```

## SAP Activate Methodology

Metodología de implementación en fases:

```
Discover → Prepare → Explore → Realize → Deploy → Run
```

Cada fase tiene deliverables específicos. Explore incluye Best Practices explorer y Configuration using Expert Configuration. Realize usa SAP Cloud Application Lifecycle Management (CALM).

## ABAP: Ejemplo de Programa

```abap
REPORT z_hello_world.

PARAMETERS: p_name TYPE string LOWER CASE.

DATA lv_message TYPE string.

lv_message = |Hola, { p_name }! Bienvenido a SAP S/4HANA.|.

WRITE: / lv_message.

* Llamada a función remota
CALL FUNCTION 'Z_GET_MATERIAL_DETAILS'
  EXPORTING
    iv_matnr = '100-100'
  IMPORTING
    ev_desc  = lv_message.

* Lectura de tabla de base de datos
SELECT SINGLE matnr, maktx
  FROM makt
  WHERE matnr = '100-100'
  INTO @DATA(ls_material).
```

## CDS Views (Core Data Services)

```sql
@AbapCatalog.sqlViewName: 'ZCDS_MATERIAL'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Materiales activos'
define view Z_MATERIAL_ACTIVE as select from makt as a
  inner join mara as b on a.matnr = b.matnr
{
  key a.matnr as MaterialNumber,
  a.maktx   as MaterialDescription,
  b.mtart   as MaterialType,
  b.matkl   as MaterialGroup,
  b.meins   as BaseUnit
}
where b.lvorm = ''  -- No marcado para borrado lógico
```

## OData Services (Gateway)

```xml
<?xml version="1.0" encoding="utf-8"?>
<edmx:Edmx Version="4.0" xmlns:edmx="http://docs.oasis-open.org/odata/ns/edmx">
  <edmx:DataServices>
    <Schema Namespace="Z_MATERIAL_SRV" xmlns="http://docs.oasis-open.org/odata/ns/edm">
      <EntityType Name="Material">
        <Key>
          <PropertyRef Name="MaterialNumber"/>
        </Key>
        <Property Name="MaterialNumber" Type="Edm.String" MaxLength="18"/>
        <Property Name="Description" Type="Edm.String" MaxLength="40"/>
      </EntityType>
      <EntityContainer Name="Container">
        <EntitySet Name="MaterialSet" EntityType="Z_MATERIAL_SRV.Material"/>
      </EntityContainer>
    </Schema>
  </edmx:DataServices>
</edmx:Edmx>
```

## Fiori Elements

```json
{
  "sap.app": {
    "id": "z.material.list",
    "type": "application",
    "title": "Lista de Materiales"
  },
  "sap.ui5": {
    "dependencies": {
      "minUI5Version": "1.108.0",
      "libs": {
        "sap.m": {}
      }
    }
  },
  "sap.fiori": {
    "registrationIds": ["Z_MATERIAL_LIST"],
    "archeType": "transactional"
  }
}
```

## SAP BTP (Business Technology Platform)

Servicios principales de la plataforma cloud:

```yaml
Integration Suite:  Conectividad entre sistemas (Cloud Integration, API Management)
Extension Suite:    Desarrollo low-code (SAP Build) y pro-code
Analytics Cloud:    BI, planificación, predictive
AI Business Services: Document Information Extraction, Service Ticket Intelligence
Data Intelligence:  Data pipelines y orquestación
```

## Estrategia de Estudio

1. **SAP Learning Hub** — Suscripción con contenido oficial, libros y sandbox
2. **SAP Community** — Preguntas frecuentes y blogs técnicos
3. **Practice System** — Acceso a sistema SAP con datos de prueba
4. **SAP Press Books** — Guías de certificación (Rheinwerk Publishing)
5. **SAP Certification Dashboard** — Gestión de exámenes y resultados

## SAP Cloud ALM

Cloud Application Lifecycle Management es la herramienta de implementación para S/4HANA Cloud:

```
Requirements → Business Process → Test → Deployment → Monitoring
```

## SAP Signavio

Gestión de procesos de negocio (BPM):

- Modelado BPMN 2.0
- Process Intelligence (minería de procesos)
- Process Manager (colaboración)
- Process Insights (análisis de rendimiento)

## Referencias

- [SAP Certification](https://training.sap.com/certification/)
- [SAP Learning Hub](https://learninghub.sap.com/)
- [SAP Community](https://community.sap.com/)
- [SAP BTP Discovery Center](https://discovery-center.cloud.sap/)
