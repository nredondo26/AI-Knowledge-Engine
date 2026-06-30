# 018-ERP: Enterprise Resource Planning

## Descripción ampliada del dominio

Los sistemas ERP (Enterprise Resource Planning) integran y gestionan los procesos de negocio fundamentales de una organización en un sistema unificado: finanzas, contabilidad, compras, inventario, producción, recursos humanos, cadena de suministro, ventas y servicio al cliente. Un ERP proporciona una base de datos centralizada (single source of truth) que elimina silos de información y permite visibilidad transversal de la organización. Los principales proveedores son SAP (líder global, 26% market share), Oracle (16%), Microsoft Dynamics 365 (7%), Infor (5%), y Epicor (3%). La evolución de los ERP: MRP (Material Requirements Planning, 1960s-70s) → MRP II (Manufacturing Resource Planning, 1980s) → ERP (1990s, con SAP R/3) → ERP II (extended ERP con e-business, 2000s) → ERP Cloud/SaaS (2010s, SAP S/4HANA Cloud, Oracle Fusion Cloud, Workday) → Intelligent ERP (2020s, con IA integrada, automation, analytics). La implementación de un ERP es un proyecto complejo que puede durar meses o años. La tendencia actual es la migración a ERP en cloud (SaaS), con IA incorporada para automatización de procesos, predicción y análisis avanzado.

## Tabla de conceptos clave

| Concepto | Descripción | Módulo ERP |
|----------|-------------|------------|
| Planificación de Recursos | Gestión integral de recursos empresariales (financieros, humanos, materiales) | Cross-module |
| Gestión Financiera | Contabilidad general, cuentas por pagar/cobrar, activos fijos, tesorería | Finance/Controlling (FI/CO en SAP) |
| Gestión de Compras | Adquisición de bienes y servicios, RFQ, pedidos, recepción, facturación | Procurement/MM (Materials Management) |
| Gestión de Inventarios | Control de stock, almacenes, valoración, movimientos, inventario cíclico | Inventory/Warehouse (WM) |
| Planificación de Producción | Plan maestro de producción, MRP, capacidad, órdenes de producción, ruta | Production Planning (PP) |
| Gestión de Ventas | Pedidos de clientes, precios, contratos, facturación, envíos | Sales & Distribution (SD) |
| Gestión de RRHH | Nómina, reclutamiento, evaluación, capacitación, organización | Human Capital (HCM) |
| Cadena de Suministro | Logística, transporte, planificación de demanda, distribución | Supply Chain (SCM) |
| Business Intelligence | Reportes, dashboards, analytics, KPIs en tiempo real | BI/Reporting |
| Compliance y Auditoría | Controles internos, pistas de auditoría, segregación de funciones | Governance, Risk & Compliance (GRC) |
| Integración | Conexión con otros sistemas (CRM, e-commerce, bancos, third-party) | Middleware, APIs, iDoc, RFC |

## Tecnologías principales

| Plataforma | Licencia | Arquitectura | Base de datos | Lenguaje | Cloud | Fuerte en |
|------------|----------|-------------|---------------|----------|-------|-----------|
| SAP S/4HANA | Proprietaria | In-memory (HANA) | SAP HANA | ABAP + Fiori/UI5 | Sí | Manufacturing, Finance, Enterprise grade |
| Oracle Fusion Cloud ERP | Proprietaria | Cloud-native | Oracle DB | Java + ADF | Sí (cloud first) | Finance, Procurement, HCM |
| Microsoft Dynamics 365 | Proprietaria (SaaS) | Microservicios modular | Azure SQL + Dataverse | C# + Power Platform | Sí (SaaS) | Mid-market, Finance, Sales, HCM |
| Infor CloudSuite | Proprietaria | Cloud-native (AWS) | PostgreSQL | Java + Infor OS | Sí | Manufacturing, Distribution |
| Epicor ERP | Proprietaria | Cloud/híbrida | SQL Server | C# + Epicor | Sí | Manufacturing (discrete), Distribution |
| Sage Intacct | Proprietaria (SaaS) | Multi-tenant cloud | Cloud DB | Python/bespoke | Sí (Cloud-only) | Finance, Accounting (mid-market) |
| Odoo | Open Source + Enterprise | Modular | PostgreSQL | Python | Sí | SMB, modular, customización |
| ERPNext | Open Source | Modular | MariaDB | Python (Frappe) | Sí (self-host/cloud) | SMB, manufacturing, services |
| NetSuite (Oracle) | Proprietaria (SaaS) | Multi-tenant cloud | Oracle DB | SuiteScript (JS) | Sí (Cloud-only) | Finance, Distribution, SaaS |
| Acumatica | Proprietaria | Cloud/xML | SQL Server | C# + Acumatica Framework | Sí (cloud) | Mid-market, manufacturing, distribution |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos ERP: qué es, módulos principales, cómo integra procesos de negocio. Diferencia entre ERP, CRM, MRP, SCM. Modelo de datos de ERP: maestro (clientes, proveedores, materiales, empleados) vs transaccional (pedidos, facturas, órdenes de producción). Ciclo de vida de implementación: blueprint → configuración → pruebas → go-live → soporte. Procesos clave: Order-to-Cash (ventas → envío → facturación → cobro), Procure-to-Pay (compra → recepción → factura → pago), Record-to-Report (contabilidad → cierre → reportes). Ejemplos concretos en sistema demo: SAP IDES, Odoo demo, MS Dynamics 365 free trial.
   - Práctica: Explorar sistema Odoo demo — crear cliente, pedido, factura. Seguir flujo Order-to-Cash. Configurar producto y lista de precios.
   - Lectura: "Concepts in Enterprise Resource Planning" (Monk, Wagner), documentación introductoria de SAP, Odoo, Dynamics 365.

2. **Intermedio (3-8 meses)**: Modelado de datos en ERP: estructuras maestras (clientes, materiales, cuentas contables, centros de costos), transacciones comerciales y su impacto contable. Configuración de módulos: Finanzas (plan de cuentas, año fiscal, monedas, impuestos, métodos de pago, grupo de tesorería), Compras (proveedores, condiciones de compra, esquemas de precios, grupos de compras), Ventas (clientes, condiciones de precios, descuentos, rutas de envío, materiales peligrosos). Automatización: workflows de aprobación (órdenes de compra, facturas), validaciones de datos, reglas de pricing. Reporting básico y analytics: listas estándar, reportes financieros (balance, P&L, cash flow), dashboard de ventas. Seguridad: roles y perfiles (segregación de funciones), autorizaciones a nivel de transacción y datos. Inteligencia de Negocios integrada: SAP Analytics Cloud, Oracle Analytics, Power BI con Dynamics.
   - Proyecto: Configurar módulo Finance en Odoo o Dynamics 365 trial. Implementar flujo Procure-to-Pay completo. Crear reporte de ventas por cliente.
   - Certificación: SAP Certified Application Associate (diferentes módulos), Dynamics 365 Fundamentals (MB-910), Oracle Cloud ERP Foundations.

3. **Avanzado (8-14 meses)**: Integración ERP con sistemas externos: APIs REST/SOAP, SAP iDoc (Intermediate Documents), BAPI (Business APIs), RFC (Remote Function Call), OData. EDI en ERP: pedidos y facturas electrónicas (X12/EDIFACT/XML). Customización: SAP ABAP (reportes, user exits, BAdIs, enhancements), Odoo Studio (módulos custom), Dynamics 365 Power Platform (Power Apps, Power Automate). Migración de datos: ETL desde legacy a ERP (data cleansing, mapping, validation, load). Gestión de cambios: transports en SAP (Change Request Management), soluciones de versionado. Arquitectura de sistemas ERP: development, quality, production landscapes; client strategy. Cloud ERP: migración on-premise → cloud, SAP S/4HANA Cloud, Oracle Fusion Cloud, private vs public cloud options.
   - Proyecto: Integrar ERP con e-commerce (Magento/Shopify) via API para sincronización de pedidos e inventario. EDI mapping para pedidos 850.
   - Certificación: SAP Certified Development Specialist, Dynamics 365 Finance Functional Consultant (MB-310), Oracle Cloud Financials.

4. **Experto (14+ meses)**: ERP para industrias específicas: SAP IS-Auto (automotriz), SAP Retail, SAP IS-Oil (petróleo), Oracle Retail, Microsoft Dynamics para manufacturing. Implementación SAP S/4HANA: system conversion vs new implementation, SAP Activate methodology, Fit-to-Standard analysis, BTP (Business Technology Platform). Intelligent ERP: AI/ML integrado (SAP AI Core, Oracle AI, Dynamics 365 Copilot) para predicción de demanda, detección de anomalías financieras, automatización de procesos, asistentes virtuales. Performance optimization: SAP HANA optimization (columnar DB, in-memory), SQL tuning, batch processing parallelization. Security: SAP security (roles, profiles, auth objects, RFC security, secure configuration), GRC (Governance, Risk & Compliance) for SAP, SoD (Segregation of Duties). Global implementations: multi-company, multi-currency, multi-language, localizations (tax, legal). ERP y la transformación digital: composable ERP (Gartner: ERP descompuesto en microservicios), headless commerce + ERP, ERP + IoT + AI en manufacturing 4.0.
   - Proyecto: Diseño de landscape SAP S/4HANA multi-entity. Implementation de AI-based demand forecasting en Dynamics 365. Estrategia de migración a cloud ERP.
   - Certificación: SAP Certified Technology Professional, Oracle Certified Master, Microsoft Dynamics 365 Architect.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | Bases de datos subyacentes de ERP (HANA, SQL, Oracle) |
| [005-Cloud](../005-Cloud/) | Cloud ERP (SAP BTP, Oracle Cloud, Dynamics 365) |
| [015-Automation](../015-Automation/) | Automatización de procesos de negocio en ERP |
| [016-RPA](../016-RPA/) | RPA para automatizar tareas en ERP (Bot que crea pedidos) |
| [017-MFT](../017-MFT/) | Transferencia de documentos EDI, facturas electrónicas |
| [019-CRM](../019-CRM/) | Integración CRM-ERP (clientes, pedidos, facturación) |
| [021-Ecommerce](../021-Ecommerce/) | Integración e-commerce-ERP (catálogo, inventario, pedidos) |
| [023-Banking](../023-Banking/) | Integración bancaria (pagos, extractos, conciliación) |
| [024-Fintech](../024-Fintech/) | Fintech + ERP para pagos digitales, contabilidad |

## Recursos recomendados

- **Plataformas de prueba**: SAP IDES / SAP Cloud Appliance Library, Odoo Community/Online Demo, Dynamics 365 free trial, ERPNext online demo.
- **Libros**: "Concepts in Enterprise Resource Planning" (Monk, Wagner), "SAP ERP: The Complete Guide" (Anderson), "Implementing SAP S/4HANA" (Vogedes, Kretz).
- **Cursos**: SAP Learning Hub, Microsoft Learn (Dynamics 365 path), Oracle University, Odoo Academy.
- **Comunidad**: SAP Community (community.sap.com), Reddit r/SAP, Odoo Community Association, Microsoft Dynamics Community.
- **Estándares**: EDI X12/EDIFACT, iDoc, BAPI, RFC, SOAP, OData, OpenAPI.

## Notas adicionales

SAP es el estándar en grandes empresas (Fortune 500), Dynamics 365 domina el mid-market, Odoo/ERPNext son opciones open source para SMB. La experiencia en implementación y configuración de ERP es altamente valorada, con consultores SAP bien remunerados. La tendencia es cloud ERP (SaaS) con inteligencia incorporada. La integración de ERP con otros sistemas (CRM, e-commerce, bancos) es un área de alta demanda. El futuro es el composable ERP: componentes modulares conectados por APIs, en lugar del ERP monolítico tradicional.
