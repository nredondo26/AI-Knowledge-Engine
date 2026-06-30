# 018-ERP (Enterprise Resource Planning)

## Descripción del dominio

Un sistema ERP (Enterprise Resource Planning) es una plataforma de software empresarial que integra y gestiona los procesos de negocio principales de una organización en un sistema unificado: finanzas, contabilidad, compras, inventarios, producción, recursos humanos, ventas, logística y más. Al centralizar los datos en una única base de datos compartida, los ERP eliminan silos de información, mejoran la visibilidad interdepartamental, automatizan flujos de trabajo y proporcionan reportes en tiempo real para la toma de decisiones. Los principales proveedores incluyen SAP, Oracle, Microsoft Dynamics, Odoo e Infor.

## Conceptos clave

- **Módulos**: componentes funcionales del ERP que cubren áreas de negocio específicas (FI/CO: Finanzas y Controlling, MM: Material Management, SD: Sales & Distribution, PP: Production Planning, HR: Human Resources, WM: Warehouse Management).
- **Datos maestros**: datos centrales compartidos por múltiples módulos (clientes, proveedores, materiales, cuentas contables, centros de costo) que deben ser gestionados con alta calidad y consistencia.
- **Implementación**: proceso de configurar y desplegar un ERP en una organización, que incluye blueprinting (mapeo de procesos), parametrización, desarrollo de personalizaciones, migración de datos, pruebas, formación y puesta en marcha (go-live).
- **Customizing vs. Development**: customizing es configurar el ERP usando parámetros estándar (tablas de configuración); development implica escribir código (ABAP en SAP, C# en Dynamics, Python en Odoo) para funcionalidades no cubiertas.
- **Metodologías de implementación**: ASAP (SAP), Sure Step (Dynamics), Oracle Unified Method, Odoo Implementation Methodology. Ágiles vs. waterfall para ERP.
- **Cambio de negocio (Change Management)**: los proyectos ERP son transformaciones organizacionales; el cambio cultural y la adopción por parte de los usuarios son factores críticos de éxito.
- **Integración**: conexión del ERP con otros sistemas (CRM, MFT, EDI, portales de proveedores, bancos, sistemas fiscales) mediante APIs, middleware (PI/PO, MuleSoft), IDocs (SAP), RFCs o web services.
- **On-premise vs. Cloud (SaaS)**: SAP S/4HANA Cloud, Oracle Fusion Cloud, Microsoft Dynamics 365 son opciones cloud; SAP ECC, Oracle E-Business Suite son on-premise tradicionales.
- **Localización**: adaptación del ERP a requisitos legales, fiscales y contables de cada país (facturación electrónica, libros contables, retenciones, reportes fiscales).
- **SAP S/4HANA**: la evolución moderna de SAP, construida sobre la base de datos in-memory HANA, con simplificaciones de datos y UX Fiori.

## Tecnologías principales

- **Plataformas**: SAP S/4HANA (ABAP, Fiori, HANA DB), Oracle ERP Cloud (Java, Oracle DB), Microsoft Dynamics 365 (C#, .NET, Azure SQL), Odoo (Python, PostgreSQL), Infor CloudSuite (Mongoose), IFS, Epicor.
- **Lenguajes de personalización**: ABAP (SAP), C# (Dynamics), Python (Odoo), Java (Oracle), PL/SQL (Oracle DB).
- **Integración**: SAP PI/PO (Process Integration/Orchestration), MuleSoft, Dell Boomi, Workato, SAP BTP, Azure Integration Services.
- **Bases de datos**: SAP HANA (in-memory, columnar), Oracle DB, SQL Server, PostgreSQL.
- **Herramientas de reportes**: SAP Fiori Analytics, SAP BW/4HANA, Power BI (Dynamics), Oracle BI Publisher, Odoo Studio.
- **Metodologías**: SAP Activate, Dynamics Sure Step, Oracle Unified Method, PMI, Scrum/SAFe para proyectos ERP.
- **Migración de datos**: SAP Migration Cockpit, LSMW, Odoo Data Migration, Dynamics Data Migration Framework.

## Hoja de ruta

1. **Principiante**: entender la arquitectura y módulos de un ERP; aprender navegación básica en SAP Fiori o Dynamics 365; conocer los conceptos de datos maestros (clientes, materiales, cuentas); realizar ejercicios en un sistema de training (IDES SAP, Odoo demo).
2. **Intermedio**: profundizar en un módulo específico (FI, MM, SD); aprender a configurar parametrizaciones básicas (sociedades, centros, almacenes); entender los procesos de integración entre módulos (venta → entrega → factura → contabilización); crear reportes simples (FBL1N, FBL5N en SAP o informes en Power BI conectados a Dynamics).
3. **Avanzado**: participar en una implementación real (blueprinting, configuración, pruebas); aprender a personalizar con ABAP (SAP) o Python (Odoo); integrar ERP con sistemas externos mediante APIs, IDocs o web services; gestionar migración de datos maestros y transaccionales.
4. **Experto**: liderar proyectos de implementación ERP; diseñar la estrategia de transición de ECC a S/4HANA (system conversion o greenfield); gestionar el change management organizacional; establecer centros de excelencia (CoE) ERP y mejores prácticas de gobierno post-implementación.

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — los ERP tradicionales son monolíticos; las estrategias de modernización (strangler fig, microservicios periféricos) se basan en principios arquitectónicos.
- [011-DesignPatterns](../011-DesignPatterns/) — los ERP internamente usan patrones como Domain Model, Repository, Aggregate, Service Layer, y Template Method para BAdIs (Business Add-Ins en SAP).
- [012-Testing](../012-Testing/) — las pruebas en ERP son complejas: requieren datos maestros, configuraciones y escenarios de negocio realistas; se usan herramientas como SAP CBTA (Component-Based Test Automation) y Tosca.
- [013-DevOps](../013-DevOps/) — los pipelines DevOps para ERP gestionan transportes (SAP CTS+), personalizaciones y parches en entornos (DEV → QAS → PRD).
- [014-CICD](../014-CICD/) — SAP BTP, Azure DevOps y GitHub Actions se usan para automatizar el despliegue de desarrollos ABAP y Fiori.
- [015-Automation](../015-Automation/) — automatización de procesos de negocio en ERP (aprovisionamiento automático, generación de pedidos, conciliación bancaria).
- [016-RPA](../016-RPA/) — RPA se usa intensivamente para interactuar con ERPs legacy (SAP GUI automation) que carecen de APIs modernas.
- [017-MFT](../017-MFT/) — los intercambios EDI (órdenes de compra, facturas) entre el ERP y socios comerciales se realizan mediante MFT con protocolo AS2.
- [019-CRM](../019-CRM/) — el CRM y el ERP se integran estrechamente: clientes, pedidos, facturas y stocks fluyen entre ambos sistemas.

## Recursos recomendados

- *SAP S/4HANA: An Introduction* — Bertram Schulze, Ravi Sureddy, Sven Weimer
- *Configuring SAP S/4HANA Finance* — Stojko Markov, Maxim Chuprinov
- *Microsoft Dynamics 365 Enterprise Edition: Financial Management* — J.J. Little
- *Odoo 14 Development Cookbook* — Parth Gajjar, Alexandre Fayolle, Holger Brunn
- *Oracle E-Business Suite: The Full Picture* — Melanie Cameron
- *ERP: Making It Happen* — Thomas F. Wallace, Michael H. Kremzar
- *SAP Activate Project Management* — S. P. Singh
- *SAP Fiori: Implementation and Development* — Anil Bavaraju
