# 019-CRM: Customer Relationship Management

## Descripción ampliada del dominio

Los sistemas CRM (Customer Relationship Management) gestionan las interacciones de una empresa con sus clientes actuales y potenciales, centralizando información de contactos, cuentas, oportunidades de venta, casos de servicio, marketing y analítica. El objetivo es mejorar las relaciones comerciales, aumentar la retención de clientes e impulsar el crecimiento de ventas. Los principales proveedores son Salesforce (líder global, ~24% market share), Microsoft Dynamics 365 (~5%), Oracle CX, HubSpot (líder en inbound marketing), SAP CX, Zoho CRM y SugarCRM. La evolución de CRM: sistemas de contactos y seguimiento de ventas (1980s-90s, ACT!, GoldMine) → CRM operacional (1990s-2000s, Siebel, Salesforce fundado 1999) → CRM analítico (2000s, BI integrado) → Social CRM (2010s, redes sociales, engagement) → CRM en cloud/SaaS (2010s, Salesforce, HubSpot, Zoho) → Intelligent CRM (2020s, AI/Copilot integrado, predictive scoring, sentiment analysis, automation). El mercado CRM es el más grande del software empresarial (>$70B en 2025). La tendencia actual es CRM como plataforma (Salesforce Platform, Power Platform) que permite construir aplicaciones personalizadas, automatización con IA (Copilot, Einstein GPT), y Customer Data Platform (CDP) unificando datos de múltiples fuentes.

## Tabla de conceptos clave

| Concepto | Descripción | Módulo CRM |
|----------|-------------|------------|
| Contacto | Persona individual con datos de contacto y comunicación | Contact Management |
| Cuenta | Organización (empresa) asociada a contactos | Account Management |
| Oportunidad | Negocio potencial en pipeline de ventas con valor y etapa | Sales Pipeline / Opportunity Management |
| Lead | Prospecto no calificado (marketing) → cualificado → oportunidad | Lead Management |
| Caso | Ticket de servicio al cliente (soporte, queja, consulta) | Service / Case Management |
| Campaña | Acción de marketing dirigida a segmento de clientes | Marketing Automation |
| Pipeline (Tubería) | Flujo de oportunidades por etapas (prospecting → negotiation → closed won/lost) | Sales Forecasting |
| Customer 360 | Vista unificada del cliente (ventas, servicio, marketing, e-commerce) | Data Platform / CDP |
| SLA (Service Level Agreement) | Acuerdo de nivel de servicio para casos de soporte | Service Management |
| Workflow/Automation | Automatización de procesos (asignación de leads, email triggers) | Automation Engine |
| Forecasting | Pronóstico de ventas basado en pipeline histórico | Sales Forecasting |
| Customer Journey | Mapa de interacciones del cliente con la empresa (todos los touchpoints) | Journey Analytics |

## Tecnologías principales

| Plataforma | Licencia | Arquitectura | Lenguaje/Customización | AI/Copilot | Fuerte en |
|------------|----------|-------------|------------------------|------------|-----------|
| Salesforce Sales/Service Cloud | Proprietaria (SaaS) | Multi-tenant cloud | Apex (Java-like), Lightning Web Components, Flow | Einstein GPT, Copilot | Enterprise sales, Service, Platform PaaS |
| Microsoft Dynamics 365 Sales | Proprietaria (SaaS) | Multi-tenant cloud | Power Platform (Power Apps, Automate), C#/JS | Dynamics 365 Copilot, Sales Copilot | Enterprise, integración Office 365 |
| HubSpot CRM | Freemium/SaaS | Multi-tenant cloud | HubL (templates), JS, HS API | HubSpot AI, ChatSpot | Inbound marketing, SMB, mid-market |
| Oracle CX Cloud | Proprietaria (SaaS) | Multi-tenant cloud | Visual Builder, Process Cloud Service | Oracle AI, Digital Assistant | Enterprise CX suite |
| SAP Sales Cloud | Proprietaria (SaaS) | Cloud/Hybrid | SAP UI5, Fiori, BTP | SAP AI Core, Joule | SAP ecosystem, B2B sales |
| Zoho CRM | Freemium/SaaS | Multi-tenant cloud | Deluge (scripting), Zoho Creator | Zia (AI assistant) | SMB, affordability, comprehensive |
| SugarCRM | Proprietaria/SaaS | Cloud/On-prem | Sugar Logic, SugarBPM, JS | Sugar Predict (ML) | Mid-market, customization |
| Pipedrive | SaaS | Cloud | Apps (marketplace), APIs | Sales Assistant AI | Pipeline visual, SMB sales |
| Freshsales | SaaS | Cloud | Workflows, APIs | Freddy AI | SMB, ease of use, integrated Freshworks |
| SuiteCRM | Open Source | Self-hosted/Cloud | PHP, JS, SuiteCRM API | No nativo | Open source, customization total |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos CRM: qué es CRM, diferencia con ERP (CRM: clientes; ERP: operaciones internas). Modelo de datos CRM: Contactos, Cuentas, Oportunidades, Leads, Casos. Pipeline de ventas: etapas (Lead → Contact → Qualify → Proposal → Negotiation → Closed Won/Lost). Ciclo de venta B2B vs B2C. Registro manual de clientes. Actividades: llamadas, reuniones, tareas, notas. Reportes básicos: cantidad de leads por fuente, valor de pipeline, tasa de conversión. Email integration: Gmail/Outlook sync. Explorar Salesforce Trailhead playground, HubSpot free CRM, Zoho CRM free.
   - Práctica: Crear cuenta en Salesforce Developer Edition o HubSpot free. Configurar pipeline de ventas. Registrar 5 leads, convertirlos a oportunidades, cerrar 2. Generar reporte de pipeline.
   - Certificación: Salesforce Certified Administrator fundamentals (ADM201 base). HubSpot CRM Software Certification.
   - Lectura: "CRM for Dummies" (Helm), Salesforce Trailhead (trailhead.salesforce.com) módulos básicos.

2. **Intermedio (2-6 meses)**: Automatización de procesos: reglas de asignación de leads (territorio, producto, round-robin), workflows de email (triggers por etapa), approval processes (descuentos). Marketing automation: campañas de email (HubSpot marketing, Mailchimp, Pardot), listas segmentadas, lead scoring (puntuación basada en comportamiento/compatibilidad). Sales forecasting: rolling forecast, commit/upside scenarios, historical trend analysis. Service management: casos, colas de casos, SLA, escalaciones, artículos de conocimiento (Knowledge Base), portal de autoservicio. Integraciones: sincronización con ERP (pedidos, facturas, inventario), email marketing, calendario, telephony (CTI), social media. Reports y dashboards avanzados: reports dinámicos (sales by region, by product, by rep), dashboards ejecutivos, embedded analytics. Security: role hierarchy (manager can see subordinate's records), sharing rules (compartir por criterios), field-level security, record types.
   - Proyecto: Implementar proceso de lead-to-opportunity con workflow automático y email alerts en Salesforce/HubSpot. Dashboard de ventas para equipo.
   - Certificación: Salesforce Certified Administrator, HubSpot Sales Software, Dynamics 365 Sales Functional Consultant (MB-210).

3. **Avanzado (6-12 meses)**: Customer Data Platform (CDP): unificación de datos de clientes desde múltiples fuentes (web, mobile, POS, call center, email, social), identity resolution, segmentación avanzada, perfiles 360. AI/ML en CRM: Predictive Lead Scoring, Opportunity Scoring, Next Best Action (recomendación de próxima acción), Sentiment Analysis (análisis de sentimiento en interacciones), churn prediction, propensity to buy. Sales enablement: content management, proposal generation, CPQ (Configure-Price-Quote), contract lifecycle. API-first CRM: REST APIs para integración con sistemas externos, webhooks, eventos en tiempo real, cambio de datos (CDC). Customización: objetos personalizados, campos, relaciones (lookup, master-detail), páginas (Lightning App Builder, Power Apps), flujos (Salesforce Flow, Power Automate). Mobile CRM: Salesforce Mobile, Dynamics 365 Mobile, offline capability, push notifications. Extensibilidad avanzada: Apex triggers (before/after insert, update, delete), validation rules, formula fields, roll-up summary. Multi-cloud integration: Sales + Service + Marketing + Commerce Cloud. Data management: deduplication (matching rules), data import/export, data quality tools.
   - Proyecto: Implementar predictive lead scoring con Einstein (Salesforce) o Dynamics 365 Sales Insights. CDP proof-of-concept con segmentación y personalización. Portal de autoservicio para clientes.
   - Certificación: Salesforce Advanced Administrator, Salesforce Sales Cloud Consultant, Marketing Cloud Administrator, Dynamics 365 Customer Insights.

4. **Experto (12+ meses)**: CRM Platform Architecture: diseño de solución integral en Salesforce (Sales + Service + Marketing + Commerce + Experience Cloud), Dynamics 365 (Sales + Customer Insights + Marketing + Power Platform). Composable CRM: CRM headless — APIs headless + microservicios + frontend personalizado. Large-scale CRM: data volumes (millones de registros), performance optimization (indexing, query optimization, skinny tables), async processing (batch, queueable, scheduled Apex), governor limits. AI transformation en CRM: Copilot (Microsoft), Einstein GPT (Salesforce), HubSpot AI — generative AI para contenido de ventas, respuestas automáticas, coaching, resúmenes de reuniones. Customer Journey Analytics: tracking omnicanal completo, attribution modeling, customer lifetime value (CLV) calculation, churn modeling. Data ethics and privacy: GDPR compliance, consent management, data retention policies, data anonymization, right to be forgotten. CRM para industrias específicas: financial services (compliance, suitability), healthcare (HIPAA), pharma (sample management), real estate, nonprofit (Constituent Relationship Management). Emerging trends: Conversational CRM (WhatsApp, Messenger, chatbots), Video CRM (Loom, Vidyard en CRM), Community-driven CRM.
   - Proyecto: Arquitectura CRM multi-cloud (Sales Cloud + Service + Marketing + Commerce). AI personalization engine basado en customer 360. Migración de CRM legacy a Salesforce/Dynamics 365.
   - Certificación: Salesforce Certified Technical Architect (CTA — la más alta certificación Salesforce), Microsoft Dynamics 365 Solution Architect.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | Almacenamiento de datos de CRM, CDP, analytics |
| [005-Cloud](../005-Cloud/) | CRM SaaS (Salesforce, Dynamics 365, HubSpot en cloud) |
| [009-Security](../009-Security/) | Seguridad de datos de clientes, roles, GDPR |
| [010-Architecture](../010-Architecture/) | Arquitectura de plataforma CRM, integraciones |
| [013-DevOps](../013-DevOps/) | CI/CD para customizaciones CRM, metadata deployment |
| [016-RPA](../016-RPA/) | RPA para automatizar tareas en CRM |
| [018-ERP](../018-ERP/) | Integración CRM-ERP (pedidos, facturas, clientes) |
| [021-Ecommerce](../021-Ecommerce/) | Integración con e-commerce (clientes, carritos, historial) |
| [025-Mobile](../025-Mobile/) | Mobile CRM apps, offline capabilities |
| [031-AI](../031-AI/) | Predictive scoring, sentiment analysis, AI Copilot |
| [037-AgenticAI](../037-AgenticAI/) | CRM agents para ventas/servicio autónomo |

## Recursos recomendados

- **Plataformas de aprendizaje**: Salesforce Trailhead (trailhead.salesforce.com), Microsoft Learn (CRM path), HubSpot Academy, Zoho Learn.
- **Libros**: "CRM at the Speed of Light" (Greenberg), "Salesforce Platform Enterprise Architecture" (Kurtz), "The CRM Handbook" (Dyche), "HubSpot Inbound Marketing Certification" ebook.
- **Certificaciones**: Salesforce Administrator, Advanced Admin, Sales/Service Cloud Consultant, CTA; Dynamics 365 Sales/Service Consultant; HubSpot Sales/Service/Marketing certifications.
- **Comunidad**: Salesforce Success Community, Power Platform Community, HubSpot Community, Reddit r/salesforce, r/Dynamics365.
- **Herramientas**: Salesforce CLI, Workbench, Data Loader, Power Platform CLI, HubSpot CLI, Copado (DevOps for Salesforce), GearSet.

## Notas adicionales

Salesforce es la plataforma CRM líder y la más demandada en el mercado, con su propio ecosistema de certificaciones y una comunidad extensa. HubSpot es la mejor opción para inbound marketing y SMB. Dynamics 365 se integra mejor con el ecosistema Microsoft (Office 365, Power Platform). La tendencia de AI Copilot en CRM está transformando la productividad de ventas y servicio. El rol de Salesforce Administrator/Developer es uno de los mejor pagados en tecnología empresarial. Las implementaciones CRM exitosas requieren tanto habilidad técnica como comprensión de procesos de negocio.
