# 019-CRM (Customer Relationship Management)

## Descripción del dominio

Un sistema CRM (Customer Relationship Management) es una plataforma que centraliza y gestiona todas las interacciones de una organización con sus clientes actuales y potenciales a lo largo del ciclo de vida comercial. Abarca desde la captación de leads, la gestión de oportunidades, la automatización de ventas y marketing, hasta el soporte postventa y la retención de clientes. Los CRM modernos proporcionan una vista unificada del cliente (360°), inteligencia de negocio para identificar tendencias, automatización de procesos comerciales y herramientas de colaboración. Los principales proveedores son Salesforce, HubSpot, Microsoft Dynamics 365 y Zoho CRM.

## Conceptos clave

- **Lead (prospecto)**: persona o empresa que ha mostrado interés inicial en los productos/servicios pero aún no ha sido calificada como oportunidad.
- **Oportunidad**: lead calificado con alta probabilidad de cierre, asociado a un valor estimado, etapa del pipeline y fecha estimada de cierre.
- **Pipeline de ventas**: representación visual de las etapas del proceso de venta (prospección, calificación, propuesta, negociación, cierre) con el valor agregado esperado.
- **Cuenta (Account)**: organización con la que la empresa tiene una relación comercial; puede tener múltiples contactos y oportunidades asociados.
- **Contacto**: persona individual dentro de una cuenta con quien se interactúa comercialmente.
- **Automatización de ventas**: reglas y flujos que automatican tareas repetitivas: asignación de leads, envío de correos de seguimiento, actualización de etapas, creación de tareas.
- **Automatización de marketing (Marketing Automation)**: campañas automatizadas basadas en el comportamiento del lead (email nurturing, scoring, segmentación dinámica).
- **CRM 360°**: visión completa del cliente que integra datos de ventas, marketing, soporte, redes sociales y otros canales en un solo perfil.
- **Customer Journey**: mapa de todas las interacciones del cliente con la marca desde el primer contacto hasta la fidelización y renovación.
- **Workflow y Process Builder**: herramientas de automatización dentro del CRM que ejecutan acciones en respuesta a cambios en registros (envío de emails, actualización de campos, creación de tareas).
- **AppExchange / Marketplaces**: ecosistemas de aplicaciones y extensiones que amplían la funcionalidad del CRM (Salesforce AppExchange, HubSpot App Marketplace, Zoho Marketplace).
- **Governance de datos CRM**: políticas de calidad, deduplicación, estandarización y enriquecimiento de datos de clientes.

## Tecnologías principales

- **Plataformas**: Salesforce (Sales Cloud, Service Cloud, Marketing Cloud), HubSpot (Sales Hub, Marketing Hub, Service Hub), Microsoft Dynamics 365 Sales, Zoho CRM, Oracle CX (Siebel), Pipedrive, Freshsales, SugarCRM.
- **Lenguajes de plataforma**: Apex (Salesforce, similar a Java), JavaScript (HubSpot custom objects/code), C# (Dynamics 365), Deluge (Zoho), SOQL/SOSL (Salesforce Query Language).
- **Herramientas de integración**: Salesforce Connect, MuleSoft, Dell Boomi, Workato, Zapier, Power Automate, APIs REST/SOAP.
- **Automatización**: Salesforce Flow, Process Builder, Workflow Rules; HubSpot Workflows; Dynamics Power Automate; Zoho Blueprint.
- **BI y Analytics**: Tableau CRM (Salesforce), HubSpot Analytics, Power BI (Dynamics), Zoho Analytics.
- **Customer Data Platform (CDP)**: Salesforce Data Cloud, HubSpot CDP, Segment (Twilio), mParticle para unificar datos de clientes.
- **AI/ML**: Einstein AI (Salesforce), HubSpot Breeze (AI nativa), Copilot (Dynamics 365), Zoho Zia.
- **E-commerce y Commerce Cloud**: Salesforce Commerce Cloud, HubSpot CMS Hub, Dynamics 365 Commerce.

## Hoja de ruta

1. **Principiante**: entender la estructura de datos básica del CRM (contactos, cuentas, leads, oportunidades, casos); navegar la interfaz de Salesforce/HubSpot/Dynamics; crear y gestionar registros manualmente; generar reportes y dashboards simples.
2. **Intermedio**: configurar pipelines de ventas con etapas y probabilidades; crear workflows y reglas de automatización (asignación de leads, actualización de campos); integrar el CRM con el correo electrónico (Outlook/Gmail) y calendario; importar/exportar datos masivos.
3. **Avanzado**: diseñar procesos de automatización complejos con SalesForce Flow o Power Automate; implementar scoring de leads y nurture campaigns; personalizar objetos, campos, layouts y reglas de negocio; integrar el CRM con el ERP (SAP, Dynamics Finance) y sistemas de MFT para sincronización maestro-detalle.
4. **Experto**: gestionar la arquitectura de datos y la governance del CRM (deduplicación, calidad, seguridad); implementar Customer Data Platform (CDP) para unificar datos de múltiples fuentes; aplicar IA (Einstein, Copilot) para predicción de oportunidades y recomendaciones; liderar proyectos de migración o consolidación de CRM en organizaciones globales; diseñar centros de excelencia CRM.

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — la arquitectura del CRM (multi-tenant en Salesforce, extensible en HubSpot, integrada con Microsoft en Dynamics) afecta cómo se diseñan las integraciones.
- [011-DesignPatterns](../011-DesignPatterns/) — patrones como Adapter (integración con sistemas externos), Observer (notificaciones de cambios), Strategy (múltiples canales de comunicación) y Repository (capa de abstracción de datos).
- [012-Testing](../012-Testing/) — las pruebas en CRM incluyen validación de procesos automatizados, integraciones con ERP y migraciones de datos; herramientas como Salesforce DX, QATTS.
- [013-DevOps](../013-DevOps/) — Salesforce DX, GitHub Actions y Azure DevOps gestionan pipelines para metadata de CRM (paquetes gestionados, cambios de configuración, implementación entre entornos).
- [014-CICD](../014-CICD/) — los cambios en CRM (perfiles, procesos, personalizaciones) se despliegan mediante pipelines CI/CD con control de versiones.
- [015-Automation](../015-Automation/) — la automatización de ventas y marketing son parte del CRM; Power Automate y Zapier conectan CRM con cientos de aplicaciones.
- [016-RPA](../016-RPA/) — los bots RPA pueden automatizar la introducción masiva de datos en el CRM, la extracción de reportes y la interacción con interfaces web.
- [017-MFT](../017-MFT/) — MFT transfiere datos maestros de clientes y transacciones entre CRM y ERP o sistemas de datos externos.
- [018-ERP](../018-ERP/) — CRM → ERP: pedidos de venta, clientes, contratos; ERP → CRM: stocks, facturas, estados de pago, disponibilidad de producto.

## Recursos recomendados

- *Salesforce Admin Certification Guide* — Justin Edelstein
- *Salesforce Developer Guide* — developer.salesforce.com
- *HubSpot Academy* — academy.hubspot.com (cursos gratuitos de CRM, ventas, marketing)
- *Microsoft Dynamics 365 Sales Implementation Guide* — learn.microsoft.com
- *Zoho CRM Documentation* — zoho.com/crm/help
- *CRM at the Speed of Light* — Paul Greenberg
- *The Salesforce Architect's Handbook* — Dipanker Jyoti, James A. Hutcherson
- *Salesforce Flow: The Official Guide* — Salesforce
- *HubSpot: Inbound Marketing and Sales* — HubSpot Resources
- *Implementing Microsoft Dynamics 365* — Mark Carrington, Rebecca Lauer, John O'Donnell
