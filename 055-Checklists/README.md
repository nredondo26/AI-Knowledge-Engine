# 055-Checklists: Listas de Verificación

## Descripción del dominio

Las listas de verificación (checklists) son herramientas sistemáticas que garantizan la consistencia, calidad y seguridad en procesos repetitivos o de alta criticidad dentro del desarrollo de software. Inspiradas en la metodología del cirujano Atul Gawande (The Checklist Manifesto), estas listas reducen errores humanos causados por omisión, fatiga o distracción, especialmente en contextos de alta presión como despliegues a producción, revisiones de código, auditorías de seguridad o resolución de incidentes. Este módulo contiene checklists detalladas para code review, deployment, security review, pre-production go-live, incident response, release management, compliance auditing, onboarding de nuevos miembros, y más. Cada checklist es un documento vivo que debe actualizarse conforme evolucionan los sistemas, las amenazas y las prácticas del equipo.

## Conceptos clave

- **Checklist de Code Review**: verificación de estándares de código, lógica correcta, manejo de errores, seguridad, rendimiento, cobertura de pruebas, documentación y ausencia de código muerto o secretos expuestos
- **Checklist de Deployment**: confirmación de migraciones de base de datos, variables de entorno, health checks, rollback plan, feature flags, monitoreo post-despliegue, notificaciones al equipo
- **Checklist de Seguridad (Security Review)**: OWASP Top 10, autenticación y autorización, cifrado en reposo/tránsito, validación de inputs, dependencias vulnerables, headers de seguridad (CSP, HSTS, X-Frame-Options), rate limiting
- **Checklist de Pre-Production / Go-Live**: readiness review que cubre capacidad de infraestructura, escalado automático, backups, disaster recovery, SLAs/SLOs, monitoreo y alertas, documentación operativa, runbooks
- **Checklist de Incident Response**: detección, contención, erradicación, recuperación, lecciones aprendidas; incluye comunicación a stakeholders y cumplimiento de plazos regulatorios de notificación
- **Checklist de Release Management**: versionado semántico, changelog actualizado, artefactos firmados, pruebas de regresión, aprobación de QA, verificación de dependencias, etiquetado en Git
- **Checklist de Compliance (Auditoría)**: evidencias requeridas por GDPR, SOC 2, HIPAA, PCI-DSS o ISO 27001; acceso a logs, informes de penetración, políticas de seguridad, registros de capacitación
- **Checklist de Onboarding**: acceso a repositorios, herramientas configuradas, documentación leída, mentores asignados, objetivos de 30/60/90 días, revisión de seguridad y compliance
- **Principio de "no heroes"**: las checklists eliminan la dependencia de que una persona recuerde todos los pasos críticos; el proceso es tan fuerte como su eslabón más débil
- **Checklist de Performance Review**: revisión de consultas lentas, perfiles de CPU/memoria, caching, lazy loading, compresión, CDN, optimización de assets, tamaño de bundles

## Tecnologías principales

| Categoría | Herramientas |
|-----------|-------------|
| Doc. colaborativa | Notion, Confluence, Google Docs, Coda, GitHub Wiki, GitBook |
| Integración en CI/CD | GitHub Actions (checklist jobs), GitLab CI merge request templates, Jenkins pipeline checks |
| Issue tracking | GitHub Issues (templates), Jira (checklist plugins), Linear, Trello |
| Marcos de compliance | OneTrust, AuditBoard, Vanta, Drata, Secureframe |
| Pre-commit checks | husky, pre-commit hooks, commitlint, golangci-lint, eslint |
| Linters de seguridad | Semgrep, Trivy, Snyk, CodeQL, SonarQube, Checkmarx |
| Runbooks y playbooks | PagerDuty Runbooks, OpsGenie, FireHydrant, incident.io |
| Feature flags | LaunchDarkly, Unleash, Flagsmith (para deployments controlados) |

## Hoja de ruta

1. **Principiante**: crear una checklist simple de code review personal; documentar los pasos manuales de deployment; usar plantillas de issues en GitHub/GitLab; compartir la checklist con el equipo inmediato y recoger feedback.
2. **Intermedio**: integrar checklists en el pipeline de CI/CD (tareas obligatorias antes de merge); automatizar verificaciones de la checklist con linters y escáneres de seguridad; establecer una checklist de pre-production para lanzamientos mayores; mantener changelogs automatizados.
3. **Avanzado**: diseñar un programa de security review con checklist obligatoria para cada release; implementar checklists de compliance auditables con evidencias automáticas; crear runbooks de incident response con pasos de verificación; medir la adherencia a las checklists con métricas.
4. **Experto**: definir la estrategia de checklists a nivel organizacional; integrar checklists en la cultura de ingeniería (blameless post-mortems, continuous improvement); automatizar el cumplimiento de checklists mediante policy-as-code (OPA, Kyverno); auditar y mejorar periódicamente las checklists basándose en incidentes reales y lecciones aprendidas.

## Relaciones con otros módulos

- [009-Security](../009-Security/) — la checklist de seguridad se basa en OWASP Top 10, NIST, CIS Benchmarks
- [012-Testing](../012-Testing/) — la checklist de code review incluye verificación de cobertura de pruebas y calidad de tests
- [013-DevOps](../013-DevOps/) — checklist de deployment, release y monitoreo post-despliegue
- [014-CICD](../014-CICD/) — automatización de pasos de checklist en pipelines
- [015-Automation](../015-Automation/) — automatización de comprobaciones repetitivas de las checklists
- [042-Documentation](../042-Documentation/) — las checklists son documentación viva que debe mantenerse actualizada
- [046-BestPractices](../046-BestPractices/) — las mejores prácticas frecuentemente se materializan en checklists concretas
- [047-Troubleshooting](../047-Troubleshooting/) — checklists de diagnóstico y resolución de incidentes
- [053-Compliance](../053-Compliance/) — checklists de auditoría y cumplimiento normativo
- [059-Metadata](../059-Metadata/) — metadatos para versionar checklists, asignar responsables y fechas de revisión

## Recursos recomendados

- **Libro**: "The Checklist Manifesto: How to Get Things Right" (Atul Gawande) — obra fundacional sobre el poder de las checklists
- **OWASP ASVS (Application Security Verification Standard)**: owasp.org — checklist detallada de seguridad para aplicaciones web
- **Google SRE Books**: "Site Reliability Engineering" (Beyer, Jones, Petoff, Murphy) — capítulos sobre checklists operativas y playbooks
- **GitHub Issue Templates**: docs.github.com — plantillas de issues con checklists integradas
- **The Twelve-Factor App**: 12factor.net — checklist metodológica para construir aplicaciones como servicio
- **Kubernetes Production Readiness Checklist**: github.com/learnk8s/production-checklist — checklist completa para clusters K8s
- **Web Security Checklist**: securityheaders.com, CSP Evaluator, observatory.mozilla.org
