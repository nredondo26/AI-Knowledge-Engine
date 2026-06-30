# SAP — Sistema de Planificación de Recursos Empresariales

## Visión General

SAP (Systeme, Anwendungen, Produkte in der Datenverarbeitung) es el líder mundial en sistemas ERP. Fundada en 1972 en Alemania, SAP ofrece soluciones modulares que integran todos los procesos de negocio de una organización: finanzas, logística, RRHH, manufactura, ventas y más. Su suite principal actual es SAP S/4HANA, construida sobre la base de datos in-memory HANA.

## Arquitectura Técnica

### SAP S/4HANA — Arquitectura de Tres Capas

```
┌─────────────────────────────────────┐
│         Capa de Presentación         │
│  SAP Fiori UI5, SAP GUI, Web / Móvil │
├─────────────────────────────────────┤
│       Capa de Aplicación (ABAP)      │
│  Gateway / NetWeaver / Cloud Foundry  │
├─────────────────────────────────────┤
│     Capa de Base de Datos (HANA)     │
│   In-Memory Columnar / Row Store     │
└─────────────────────────────────────┘
```

### Componentes Clave

| Componente | Propósito |
|------------|-----------|
| SAP NetWeaver | Plataforma tecnológica y middleware |
| SAP HANA | Base de datos in-memory columnar |
| SAP Fiori | UX moderna basada en roles |
| SAP Cloud Platform | PaaS para extensiones cloud |
| SAP BTP | Business Technology Platform (integración, IA, analytics) |

## Modelo de Datos en SAP HANA

SAP HANA utiliza un motor columnar in-memory que elimina la necesidad de índices secundarios y agregaciones precalculadas.

```sql
-- Crear una tabla columnar en HANA
CREATE COLUMN TABLE Z_VENTAS (
  MANDT NVARCHAR(3) NOT NULL,
  VBELN NVARCHAR(10) NOT NULL,
  POSNR NVARCHAR(6) NOT NULL,
  MATNR NVARCHAR(40),
  NETWR DECIMAL(15,2),
  ERNAM NVARCHAR(12),
  ERZET TIME,
  PRIMARY KEY (MANDT, VBELN, POSNR)
) UNLOAD PRIORITY 5;
```

## ABAP — Lenguaje Corporativo

ABAP (Advanced Business Application Programming) es el lenguaje propietario de SAP para desarrollo en el stack on-premise.

```abap
REPORT z_consulta_ventas.

PARAMETERS: p_vbeln TYPE vbeln_va OBLIGATORY.

DATA: lt_ventas TYPE TABLE OF vbak,
      ls_ventas TYPE vbak.

START-OF-SELECTION.
  SELECT * FROM vbak
    INTO TABLE lt_ventas
    WHERE vbeln = p_vbeln.

  LOOP AT lt_ventas INTO ls_ventas.
    WRITE: / 'Documento:', ls_ventas-vbeln,
           / 'Cliente:',  ls_ventas-kunnr,
           / 'Importe:',  ls_ventas-netwr.
  ENDLOOP.
```

## Módulos Principales de SAP ERP

### SAP FI (Financial Accounting)
- Libro mayor (GL), cuentas por pagar (AP), cuentas por cobrar (AR)
- Activos fijos (AA), consolidaciones, reporting financiero

### SAP CO (Controlling)
- Contabilidad de centros de costo y beneficio
- Product costing, profitability analysis (CO-PA)

### SAP SD (Sales & Distribution)
- Procesos de preventa, pedidos, entregas y facturación
- Gestión de precios, descuentos e impuestos

### SAP MM (Materials Management)
- Compras, gestión de inventarios, valuación de materiales
- MRP (Material Requirements Planning)

### SAP PP (Production Planning)
- Planificación de producción, órdenes de fabricación
- Kanban, repetitivo, planificación de capacidad

### SAP HCM (Human Capital Management)
- Nómina, gestión de talento, time management
- SuccessFactors (cloud HCM)

## Integración mediante IDoc y RFC

```xml
<!-- Estructura de un IDoc de SAP -->
<IDOC BEGIN="1">
  <EDI_DC40 SEGMENT="1">
    <IDOCTYP>ORDERS05</IDOCTYP>
    <MESTYP>ORDERS</MESTYP>
    <SNDPOR>SAPPRD</SNDPOR>
    <SNDPRT>LS</SNDPRT>
    <RCVPOR>WMS01</RCVPOR>
    <RCVPRT>LS</RCVPOT>
  </EDI_DC40>
  <E1EDK01 SEGMENT="1">
    <BSART>OR</BSART>
    <BEDAT>20250115</BEDAT>
  </E1EDK01>
</IDOC>
```

## SAP BTP — Business Technology Platform

SAP BTP unifica integración, analytics, IA y desarrollo de aplicaciones en una plataforma única.

```yaml
# CAP (Cloud Application Programming) Model — schema.cds
namespace sap.fe.demo;

entity Products {
  key ID        : UUID;
      title     : String(100);
      price     : Decimal(10,2);
      stock     : Integer;
      category  : Association to Categories;
}

entity Categories {
  key ID   : Integer;
      name : String(50);
}
```

## Buenas Prácticas de Implementación

1. **SAP Activate** — Metodología ágil para implementaciones S/4HANA: Discover, Prepare, Explore, Realize, Deploy, Run.
2. **Sizing** — Calcular correctamente la memoria HANA basada en el volumen de datos y la compresión esperada.
3. **Seguridad** — Usar roles PFCG, autorizaciones a nivel de campo y cifrado TLS en comunicación RFC.
4. **Transporte** — Utilizar CTS+ y chaquetas de transporte para mover objetos entre sistemas (DEV → QAS → PRD).
5. **Performance** — Optimizar consultes ABAP con SLT, particionamiento de tablas y uso de índices HANA.
6. **Clean Core** — Mantener el núcleo S/4HANA limpio, usando extensibilidad in-app y side-by-side en BTP.

## Monitoreo y Alertas

```sql
-- Monitoreo de rendimiento de consultas HANA
SELECT SCHEMA_NAME, TABLE_NAME, RECORD_COUNT,
       MEMORY_SIZE_IN_TOTAL / 1024 / 1024 AS MB
FROM M_CS_TABLES
WHERE RECORD_COUNT > 10000
ORDER BY MEMORY_SIZE_IN_TOTAL DESC;
```

## SAP y la Inteligencia Artificial

SAP AI Core y AI Launchpad permiten integrar modelos de machine learning directamente en procesos SAP. Casos de uso comunes:
- Predicción de demanda (SCM)
- Detección de anomalías financieras (FI)
- Clasificación automática de materiales (MM)
- Chatbots de soporte Fiori con SAP Conversational AI
