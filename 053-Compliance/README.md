# 053-Compliance: Cumplimiento Normativo

## Descripción del dominio

El cumplimiento normativo (compliance) es el conjunto de procesos, controles y prácticas que aseguran que una organización opere conforme a las leyes, regulaciones, estándares y políticas aplicables a su industria y ubicación geográfica. En el contexto del software, el compliance abarca desde la protección de datos personales (GDPR, CCPA, LGPD) hasta la seguridad de la información (ISO 27001, SOC 2), pasando por regulaciones sectoriales como HIPAA (salud), PCI-DSS (pagos), SOX (finanzas) y FedRAMP (gobierno). Implementar compliance no solo evita sanciones legales, sino que construye confianza con clientes, socios y reguladores, y demuestra un compromiso con la privacidad, la seguridad y la integridad de los datos.

## Conceptos clave

- **GDPR (General Data Protection Regulation)**: regulación europea de protección de datos que otorga derechos a los ciudadanos sobre sus datos personales y exige consentimiento explícito, notificación de brechas, portabilidad y derecho al olvido
- **SOC 2 (System and Organization Controls 2)**: marco de auditoría desarrollado por AICPA que evalúa controles de seguridad, disponibilidad, integridad de procesamiento, confidencialidad y privacidad en proveedores de servicios
- **HIPAA (Health Insurance Portability and Accountability Act)**: ley estadounidense que establece requisitos de privacidad y seguridad para la información médica protegida (PHI) en entidades de salud y sus asociados
- **PCI-DSS (Payment Card Industry Data Security Standard)**: estándar de seguridad para organizaciones que manejan, procesan o almacenan datos de tarjetas de crédito; consta de 12 requisitos agrupados en 6 objetivos
- **SOX (Sarbanes-Oxley Act)**: ley estadounidense que exige controles internos sobre la información financiera, incluyendo la seguridad de los sistemas que procesan datos financieros
- **ISO 27001**: estándar internacional para sistemas de gestión de seguridad de la información (SGSI/SMSI) que define requisitos para establecer, implementar, mantener y mejorar un SGSI
- **ISO 27701**: extensión de ISO 27001 específica para privacidad de la información, alineada con los requisitos del GDPR
- **NIST CSF (Cybersecurity Framework)**: marco de ciberseguridad del NIST organizado en cinco funciones: Identificar, Proteger, Detectar, Responder, Recuperar
- **DPO (Data Protection Officer)**: figura obligatoria en GDPR para organizaciones que procesan datos personales a gran escala; responsable de supervisar la estrategia de protección de datos
- **DPIA (Data Protection Impact Assessment)**: evaluación de impacto sobre la protección de datos, obligatoria cuando el procesamiento puede generar alto riesgo para los derechos de las personas
- **Auditoría de compliance**: revisión sistemática e independiente para determinar si la organización cumple con los requisitos normativos aplicables
- **SOX (Segregation of Duties)**: principio de separación de funciones para evitar que una misma persona realice acciones incompatibles (ej. crear y aprobar cambios en producción)
- **Data Retention Policy**: política que define cuánto tiempo se conservan los datos, cuándo y cómo se eliminan de forma segura
- **Breach Notification**: obligación legal de notificar a autoridades y/o afectados en un plazo determinado tras detectar una violación de seguridad

## Tecnologías principales

| Categoría | Tecnologías / Herramientas |
|-----------|---------------------------|
| Gestión de compliance | OneTrust, TrustArc, Compliance.ai, LogicGate, ServiceNow GRC |
| SIEM y logging | Splunk, ELK Stack, Sumo Logic, Azure Sentinel, AWS CloudTrail |
| IAM y control de acceso | Okta, Azure AD, Auth0, CyberArk, AWS IAM, Keycloak |
| DLP (Data Loss Prevention) | Symantec DLP, McAfee DLP, Digital Guardian, Varonis |
| Cifrado y HSM | AWS KMS, Azure Key Vault, HashiCorp Vault, Thales HSM |
| Auditoría y evidencia | AuditBoard, Workiva, Wdesk, ACL Analytics, Galvanize |
| Monitoreo continuo | AWS Config, Azure Policy, Google Cloud Security Command Center, Prisma Cloud |

## Hoja de ruta

1. **Principiante**: comprender los marcos normativos básicos (GDPR, ISO 27001, SOC 2); identificar datos personales y sensibles en un sistema; aplicar cifrado en reposo y en tránsito; implementar políticas de contraseñas y autenticación multifactor; documentar el procesamiento de datos.
2. **Intermedio**: realizar DPIAs para nuevos proyectos; configurar logging y monitoreo para cumplir con requisitos de auditoría; implementar controles de acceso basados en roles (RBAC); establecer políticas de retención y eliminación de datos; preparar evidencia para auditorías SOC 2.
3. **Avanzado**: diseñar un SGSI conforme a ISO 27001; automatizar controles de compliance en CI/CD (Infrastructure as Code scanning); gestionar incidentes de brecha con notificación regulatoria; coordinar auditorías externas con firmas certificadoras; implementar FedRAMP para entornos gubernamentales.
4. **Experto**: definir la estrategia de compliance a nivel organizacional; liderar la obtención y mantenimiento de certificaciones (ISO 27001, SOC 2 Type II, PCI-DSS Level 1); diseñar programas de compliance para múltiples jurisdicciones (GDPR + CCPA + LGPD); participar en la redacción de políticas sectoriales y contribuir a estándares de la industria.

## Relaciones con otros módulos

- [005-Cloud](../005-Cloud/) — compliance en cloud compartido (modelo de responsabilidad compartida AWS/Azure/GCP)
- [006-Containers](../006-Containers/) — escaneo de vulnerabilidades en imágenes, compliance de contenedores (CIS Benchmarks)
- [007-Orchestration](../007-Orchestration/) — políticas de red y seguridad en Kubernetes, Pod Security Standards
- [009-Security](../009-Security/) — controles técnicos de seguridad que implementan los requisitos de compliance
- [014-CICD](../014-CICD/) — pipelines que verifican compliance automáticamente (SAST, DAST, dependency scanning)
- [032-MachineLearning](../032-MachineLearning/) — compliance en modelos ML (sesgo, explicabilidad, datos de entrenamiento)
- [034-LLM](../034-LLM/) — regulaciones emergentes para modelos generativos (EU AI Act, Executive Order)
- [046-BestPractices](../046-BestPractices/) — mejores prácticas que facilitan el cumplimiento normativo
- [052-Standards](../052-Standards/) — estándares ISO, NIST y su relación directa con marcos de compliance
- [055-Checklists](../055-Checklists/) — listas de verificación para auditorías y preparación de compliance
- [059-Metadata](../059-Metadata/) — metadatos para clasificación de datos, etiquetado de retención y políticas

## Recursos recomendados

- **GDPR**: gdpr.eu, eur-lex.europa.eu (Reglamento 2016/679)
- **SOC 2**: aicpa.org/soc — guías y reportes del AICPA
- **ISO 27001**: iso.org/isoiec-27001-information-security.html
- **PCI-DSS**: pcisecuritystandards.org — documentación oficial del estándar
- **NIST CSF**: nist.gov/cyberframework — marco de ciberseguridad del NIST
- **Libro**: "Information Security Management Principles" (Alexander, Finch, Sutcliffe)
- **Libro**: "The Privacy Engineer's Manifesto" (Dennedy, Fox, Finneran)
- **CIS Benchmarks**: cisecurity.org — guías de hardening para compliance
- **OWASP**: owasp.org — guías de seguridad aplicables a compliance
