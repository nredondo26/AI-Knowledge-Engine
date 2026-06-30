# 016-RPA (Robotic Process Automation)

## Descripción del dominio

La Automatización Robótica de Procesos (RPA) es una tecnología que permite crear software robots (bots) que imitan las acciones humanas al interactuar con aplicaciones y sistemas informáticos a través de sus interfaces de usuario. A diferencia de la automatización tradicional basada en APIs, RPA opera en la capa de presentación, simulando clics, escritura y navegación como lo haría un operador humano. Es especialmente útil para automatizar procesos manuales, repetitivos y basados en reglas en sistemas legacy sin APIs expuestas. Las plataformas líderes incluyen UiPath, Automation Anywhere, Blue Prism y Microsoft Power Automate.

## Conceptos clave

- **Bot**: agente de software que ejecuta procesos automatizados, ya sea atendido (asiste al usuario) o no atendido (se ejecuta en segundo plano sin supervisión).
- **Selector**: mecanismo para identificar elementos en la interfaz de usuario (por propiedades como ID, clase, texto, posición relativa). Los selectores robustos son clave para la estabilidad del bot.
- **Orquestador**: plataforma central que gestiona, monitorea, programa y coordina la ejecución de múltiples bots en diferentes máquinas o entornos.
- **Grabador (recorder)**: herramienta que captura las acciones del usuario (clics, escritura, navegación) y genera automáticamente los pasos del flujo de trabajo, que luego pueden refinarse manualmente.
- **Proceso estructurado vs. no estructurado**: los bots RPA son más efectivos en procesos estructurados (basados en reglas, datos predecibles); para procesos no estructurados (documentos, imágenes) se combina con OCR e IA.
- **Attended Automation**: bots que se ejecutan en el mismo escritorio que el usuario, generalmente activados por el usuario para asistir en tareas específicas.
- **Unattended Automation**: bots que se ejecutan en servidores o máquinas virtuales sin intervención humana, programados o disparados por eventos.
- **Centro de Excelencia (CoE) RPA**: equipo multidisciplinario que define estándares, selecciona herramientas, capacita y gobierna la automatización en una organización.
- **Excepción y manejo de errores**: los bots deben manejar casos excepcionales (ventanas emergentes inesperadas, cambios de interfaz, tiempos de espera) para ser robustos en producción.
- **OCR e IA**: tecnologías complementarias que permiten a los RPA leer y procesar documentos no digitalizados (facturas, formularios) mediante reconocimiento óptico de caracteres y modelos de IA.

## Tecnologías principales

- **Plataformas RPA**: UiPath (líder del mercado), Automation Anywhere, Blue Prism, Microsoft Power Automate, WorkFusion, NICE, Kofax, EdgeVerve.
- **Orquestadores**: UiPath Orchestrator, Automation Anywhere Control Room, Blue Prism Enterprise Control Room.
- **Complementos**: OCR (Tesseract, ABBYY, Google Vision), procesamiento de documentos (Document Understanding de UiPath), AI Center (UiPath), IQ Bot (Automation Anywhere).
- **Integración**: conectores para SAP, Salesforce, Microsoft Office (Excel, Outlook, SharePoint), bases de datos, APIs REST, servicios web.
- **Citizen Developer**: Power Automate permite a usuarios de negocio crear automatizaciones sin código profundo.

## Hoja de ruta

1. **Principiante**: entender qué es RPA y en qué se diferencia de la automatización tradicional; aprender la interfaz de UiPath o Power Automate; crear bots simples con grabador (recorder) para automatizar tareas en Excel o un navegador web.
2. **Intermedio**: diseñar selectores robustos y manejar excepciones; utilizar variables, argumentos y control de flujo (condicionales, bucles); trabajar con DataTables y manipulación de archivos; integrar bots con Outlook, bases de datos y APIs REST usando UiPath Studio.
3. **Avanzado**: implementar procesos de unattended automation gestionados desde Orchestrator; desplegar bots en entornos de producción con queues, assets y schedules; usar Document Understanding y AI Center para procesar documentos no estructurados; aplicar logging y monitoreo de rendimiento.
4. **Experto**: diseñar una arquitectura RPA empresarial con múltiples entornos, alta disponibilidad y disaster recovery; establecer un CoE RPA con métricas de ROI, governance y compliance; combinar RPA con chatbots y automatización de procesos inteligentes (IPA); evaluar y seleccionar entre RPA, APIs nativas y automatización tradicional para cada caso de uso.

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — la arquitectura de un centro RPA incluye bots, orquestador, repositorios y entornos; se integra con sistemas legacy que pueden carecer de APIs modernas.
- [011-DesignPatterns](../011-DesignPatterns/) — patrones como Template Method (workflows reutilizables), Strategy (múltiples selectores), Facade (simplificar interacción con APIs complejas) y State Machine (gestión de estados del bot).
- [012-Testing](../012-Testing/) — es fundamental probar los bots: pruebas unitarias de componentes, pruebas de integración con sistemas de destino y pruebas de regresión ante cambios de interfaz.
- [013-DevOps](../013-DevOps/) — los bots requieren control de versiones, pipelines de despliegue (UiPath tiene CI/CD con GitHub Actions) y monitoreo en producción.
- [014-CICD](../014-CICD/) — los paquetes de automatización (NuGet en UiPath, .aipkg en AA) se versionan y despliegan mediante pipelines.
- [015-Automation](../015-Automation/) — RPA complementa la automatización tradicional (scripts, Ansible) automatizando lo que no tiene API; la automatización general y RPA coexisten en un ecosistema.
- [017-MFT](../017-MFT/) — los bots RPA pueden procesar archivos recibidos mediante MFT (facturas, órdenes de compra) y automatizar su incorporación a sistemas transaccionales.
- [018-ERP](../018-ERP/) — RPA se usa extensamente para automatizar entradas en SAP, Oracle y ERPs legacy sin APIs modernas.
- [019-CRM](../019-CRM/) — los bots RPA automatizan la creación de contactos, cuentas, oportunidades y tareas repetitivas en CRMs.

## Recursos recomendados

- *UiPath Official Documentation* — docs.uipath.com
- *Automation Anywhere University* — automationanywhere.com/university
- *Blue Prism Documentation* — portal.blueprism.com
- *Learning Robotic Process Automation* — Packt Publishing
- *Robotic Process Automation: The Future of Business* — Aditya Tandon
- *The Robotic Process Automation Handbook* — Tom Taulli
- *Power Automate Documentation* — learn.microsoft.com/power-automate
- *UiPath StudioX: Citizen Developer Guide* — UiPath Academy
