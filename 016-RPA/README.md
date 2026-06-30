# 016-RPA: Robotic Process Automation

## Descripción ampliada del dominio

La Automatización Robótica de Procesos (RPA) es una tecnología que utiliza software robótico (bots) para imitar las acciones humanas en sistemas digitales, automatizando tareas repetitivas, basadas en reglas y de alto volumen que antes requerían intervención humana. RPA interactúa con aplicaciones a través de la interfaz de usuario (UI automation), o mediante APIs e integraciones técnicas. A diferencia de la automatización tradicional de TI (que requiere integraciones técnicas programáticas), RPA opera sobre las mismas interfaces que los humanos: pantalla, teclado, mouse, archivos, correo electrónico. Las plataformas RPA líderes son UiPath, Automation Anywhere y Microsoft Power Automate. La evolución ha sido: RPA asistido (attended bots que colaboran con humanos, 2010s) → RPA no asistido (unattended bots que ejecutan sin supervisión, 2015+) → Hyperautomation (combinación de RPA + AI + ML + procesos, 2020+), → Process Mining + RPA + AI (intelligent automation, 2023+). RPA no reemplaza APIs ni integraciones técnicas; es una solución para sistemas sin API o cuando la integración técnica es demasiado costosa. El mercado RPA ha crecido explosivamente: se estima en $13B+ para 2025.

## Tabla de conceptos clave

| Concepto | Descripción | Herramientas/Estándares |
|----------|-------------|------------------------|
| Unattended Bot | Bot que ejecuta sin intervención humana en servidores | UiPath Robot, Automation Anywhere Bot Runner |
| Attended Bot | Bot que asiste al usuario en su estación de trabajo | UiPath Assistant, Power Automate Desktop |
| Orchestrator | Plataforma central que gestiona, monitorea y programa bots | UiPath Orchestrator, AA Control Room |
| UI Automation | Interacción con aplicaciones a través de su interfaz gráfica | Selectores (UI elements), image recognition, OCR |
| Screen Scraping | Extracción de datos de pantallas de aplicaciones | OCR (Tesseract), native scraping, image scraping |
| OCR (Optical Character Recognition) | Reconocimiento de texto en imágenes y documentos | UiPath Document Understanding, ABBYY FlexiCapture |
| Attended Automation | Bot que comparte escritorio con humano, activado manualmente | Procesos que requieren decisión humana intermedia |
| Unattended Automation | Bot que ejecuta automáticamente en background | Procesos batch 24/7 sin supervisión |
| Process Mining | Descubrimiento y análisis de procesos basado en logs de eventos | Celonis, UiPath Process Mining, Apromore |
| Task Mining | Grabación de acciones de usuario para identificar tareas automatizables | UiPath Task Capture, FortressIQ |
| Centro de Excelencia (CoE) | Equipo central que define estándares, governance y mejores prácticas RPA | Roles: RPA Developer, Architect, Business Analyst |
| Hyperautomation | Combinación de RPA + AI/ML + BPM + Low-Code para automatización integral | Gartner términos, plataformas low-code + RPA |

## Tecnologías principales

| Plataforma | Fundador | Licencia | Lenguaje scripting | Orquestador | AI integrada | Puesto Gartner MQ 2024 |
|------------|----------|----------|-------------------|-------------|-------------|----------------------|
| UiPath | Daniel Dines (Romania) | Enterprise/Community | VB.NET (workflows gráficos) | UiPath Orchestrator | AI Center, Document Understanding, Computer Vision | #1 Líder |
| Automation Anywhere | Mihir Shukla (USA) | Enterprise | BotScript | Control Room | AARI, IQ Bot, Document Automation | #2 Líder |
| Microsoft Power Automate | Microsoft | Enterprise/Per-user | Power Fx (low-code) | Power Platform Admin Center | AI Builder, Copilot | #3 Líder |
| Blue Prism | Enterprise (UK) | Enterprise | Blue Prism Object Studio | Blue Prism Hub | Decipher (IDP), Blue Prism AI | Adquirido por SS&C |
| NICE | Enterprise | Enterprise | NEVA (scripting) | NICE Robotic Automation | NEVA AI | Visionario |
| WorkFusion | Enterprise | Enterprise | WorkFusion RPA Express | WorkFusion Control Tower | AI Studio, Smart Automation | Visionario |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos RPA: qué es RPA, diferencia con automatización tradicional (API vs UI), cuándo usar RPA (sistemas sin API, procesos legacy, multi-sistema), cuándo no (procesos con alto juicio humano, APIs disponibles). Arquitectura RPA: Developer, Robot (Attended/Unattended), Orchestrator (control room). Instalación de UiPath Studio Community. Primeros pasos: grabar y reproducir acciones (Record → Playback). Actividades básicas: Type Into, Click, Get Text, Scrape, Selector editing. Variables y tipos de datos (String, Int, Boolean, Array, DataTable). Control flow: If/Else, Switch, For Each, While, Do While. Data manipulation: DataTable operations, Collection handling. Excel automation: Read Range, Write Range, Append Range, Workbook operations. Introducción a selectores: selectores de UI (atributos: name, role, control type), selectores parciales, wildcards (asterisk).
   - Proyecto: Bot de automatización de login a una web y extracción de datos a Excel.
   - Certificación: UiPath RPA Associate (UiARD) — examen gratuito con voucher. Microsoft PL-900 (Power Platform).
   - Lectura: UiPath Academy (academy.uipath.com), "Learning Robotic Process Automation" (Tripathi).

2. **Intermedio (2-6 meses)**: Selectores avanzados: selectores dinámicos (variables en selectores), wildcards, anclas (anchor base), fuzzy selectors, selectores para aplicaciones web, desktop y Java (AA, SAP, Citrix). Manejo de errores: Try/Catch/Finally, ContinueOnError, Timeout, Error logging, Retry Scope. Buena práctica: implementar logging estructurado, manejar excepciones específicas (ElementNotFound, ApplicationException). Excel/DataTable avanzado: filtrado, ordenamiento, operaciones con DataTables, Merge DataTable, Lookup DataTable. PDF automation: Read PDF, PDF extraction, Fill PDF Form. Email automation: Outlook, SMTP, IMAP — leer correos, extraer attachments, enviar correos con templates. Orchestrator: publish processes, crear environments, robots, queues, assets, triggers. Orchestrator Triggers: Time trigger, Queue trigger, System event trigger (file creation, email arrival). Queues: Transaction Items, process queued items con Queue Transaction activities, item states (New, InProgress, Failed, Successful, Retry). Assets: credenciales, configuraciones globales, strings, integers, booleanos. Reframework: UiPath ReFramework template (State Machine-based: Initialization → Get Transaction Data → Process → End Process). Orchestrator logging: serilog integration, log levels. SAP automation: SAP GUI Scripting + UiPath SAP Integration.
   - Proyecto: Bot unattended que procesa facturas desde email → extrae datos → escribe en Excel → sube a ERP. Con estado, queues y logging.
   - Certificación: UiPath RPA Developer Advanced (UiARD avanzado). Automation Anywhere Advanced RPA Professional.
   - Lectura: UiPath Documentation, "UiPath: The Complete Guide" (Gupta).

3. **Avanzado (6-12 meses)**: Document Understanding: UiPath Document Understanding framework — Taxonomy Manager, Digitization (OCR: Google Vision, Microsoft Read, Tesseract), Classification (ML Classifier, Taxonomy Classifier), Extraction (Data Extraction Scope, Regex, ML Extractor). Validation station y human-in-the-loop para documentos complejos. Computer Vision: UiPath Computer Vision (object detection, screen scraping con CV), OCR vs CV overhead. AI Center: ML Skills deployment (pre-built: Invoice, Receipt, Resume, Custom ML models), ML Skill integration in workflows. Automation as a Service: Api First RPA (triggers via REST API), Orchestrator API (automate process management). Performance optimization: timing, parallel execution, optimization of large loops, minimizing UI interactions. Testing and debugging: UiPath Test Suite, Test Automation, Test Data Queue, CI/CD integration (Azure DevOps, GitHub Actions). RPA Governance: CoE (Center of Excellence), RPA metrics (bots running, success rate, ROI), change management, version control (Git integration in UiPath Studio), code review process. Process Mining: Celonis/UiPath Process Mining — descubrir procesos reales desde event logs, identificar cuellos de botella y oportunidades de automatización. AARI (Action Center): attended automation triggers from web/mobile interface. Integración con sistemas enterprise: SAP (BAPI, RFC), Salesforce, Oracle, ServiceNow.
   - Proyecto: Document Understanding pipeline para facturas/contratos. AI Center custom model para clasificación de tickets. Governance framework + CI/CD para RPA.
   - Certificación: UiPath Document Understanding + AI Center Specialist, Automation Anywhere Master RPA Professional.

4. **Experto (12+ meses)**: Hyperautomation: combinación de RPA + AI/ML + BPM + Low-Code + Process Mining. Arquitectura de plataforma de automatización integral. RPA + LLM: integración de LLMs (GPT-4, Claude) para procesamiento de documentos no estructurados, toma de decisiones basada en lenguaje natural, automatización de procesos cognitivos. Intelligent Document Processing (IDP) avanzado: LLM-based extraction (prompting con few-shot), multi-modal RPA. RPA at scale: federated robot management, multi-tenant Orchestrators, high availability, disaster recovery. Automation mesh: orquestación cross-platform (UiPath + AA + Power Automate en misma empresa). Seguridad: credential management (CyberArk, Vault), secure execution, encryption, audit trails, compliance (SOC 2, SOX). Cost optimization: unattended vs attended economics, CoE staffing models, automation accounting. Emerging technologies: process orchestration, task mining + process mining → continuous discovery → continuous automation.
   - Proyecto: Hyperautomation platform con RPA + AI/ML + Process Mining + IDP. Integration con LLMs para cognitive automation.
   - Lectura: Gartner Magic Quadrant for RPA, "Hyperautomation" (Boulton), UiPath Forum blogs.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | Extracción desde DB legacy, CRM, ERP para automation |
| [005-Cloud](../005-Cloud/) | RPA en cloud (Automation Cloud, Azure Automation) |
| [009-Security](../009-Security/) | Credential management, secure automation, compliance |
| [013-DevOps](../013-DevOps/) | CI/CD para RPA, version control, testing |
| [015-Automation](../015-Automation/) | RPA como extensión de automation toolkit |
| [017-MFT](../017-MFT/) | Transferencia de archivos como parte de procesos RPA |
| [018-ERP](../018-ERP/) | Automatización de procesos en ERP (SAP, Oracle) |
| [019-CRM](../019-CRM/) | Automatización de procesos de CRM (Salesforce, Dynamics) |
| [031-AI](../031-AI/) | AI + RPA = cognitive automation, IA/ML en IDP |

## Recursos recomendados

- **Plataformas de aprendizaje**: UiPath Academy (academy.uipath.com), Automation Anywhere University, Microsoft Learn (Power Automate modules).
- **Libros**: "Learning Robotic Process Automation" (Tripathi), "Robotic Process Automation and Automation Anywhere" (Singh), "An Introduction to Robotic Process Automation" (Taulli).
- **Certificaciones**: UiPath Certified Professional (UiARD, UiARD Advanced, UiPath Document Understanding), Automation Anywhere Certified Master RPA, Microsoft PL-900 + PL-500.
- **Comunidad**: UiPath Community Forum, UiPath Go!, Automation Anywhere Community, Reddit r/rpa.
- **Herramientas**: UiPath Studio + Orchestrator, Process Mining (Celonis, UiPath), Task Capture, Document Understanding.

## Notas adicionales

RPA es una tecnología de transición: cuando un sistema legacy sea reemplazado, el RPA asociado debe migrarse o eliminarse. El ROI de RPA depende de la escala y la correcta selección de procesos. Los procesos ideales son: repetitivos, basados en reglas, con entradas digitales estructuradas, de alto volumen, y estables (no cambian frecuentemente). La combinación de RPA + AI (Hyperautomation) es la tendencia principal. Process Mining complementa RPA descubriendo qué procesos automatizar. UiPath es el líder indiscutible del mercado con la plataforma más completa; Power Automate es la mejor integración con Microsoft 365.
