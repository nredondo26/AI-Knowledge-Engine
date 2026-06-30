# 017-MFT: Managed File Transfer

## Descripción ampliada del dominio

Managed File Transfer (MFT) es una tecnología que proporciona transferencia segura, confiable y auditable de archivos entre sistemas, organizaciones y personas. A diferencia de protocolos de transferencia básicos como FTP, las soluciones MFT ofrecen cifrado en tránsito y reposo, automatización de flujos de trabajo, monitoreo en tiempo real, informes de auditoría, manejo de errores, reintentos y cumplimiento normativo (PCI DSS, HIPAA, SOX, GDPR). Los casos de uso incluyen intercambio B2B (facturas electrónicas, órdenes de compra, EDI), transferencia de datos entre sistemas financieros, intercambio de datos con partners externos (proveedores, clientes), backups y replicación entre sitios, y distribución de archivos de gran tamaño. La evolución de MFT: FTP (1971, RFC 959) → FTP/S (FTP sobre SSL/TLS, 1990s) → SFTP/SSH (Secure Shell File Transfer, 1990s) → AS2/AS3/AS4 (Applicability Statement para EDI, 2000s) → Managed File Transfer (plataforma integrada, 2000s+) → Cloud MFT (SaaS, AWS Transfer Family, 2018+) → MFT-as-a-Service (consume model, 2020+). Las soluciones modernas MFT soportan múltiples protocolos, workflows complejos, integración con APIs REST y nube, y automatización inteligente.

## Tabla de conceptos clave

| Concepto | Descripción | Protocolos/Estándares |
|----------|-------------|----------------------|
| FTP/S | File Transfer Protocol sobre SSL/TLS (explícito FTPS o implícito FTP over TLS) | FTP, FTPS (FTP over SSL) |
| SFTP/SSH | File transfer sobre Secure Shell (no FTP sobre SSH, protocolo separado) | SFTP (SSH File Transfer Protocol) |
| AS2 | Applicability Statement 2: EDI sobre HTTP/S con firma y cifrado | AS2 (RFC 4130), EDI (X12, EDIFACT) |
| AS4 | Applicability Statement 4: EDI sobre web services seguros | AS4 (ebMS3), perfil MIME |
| PeSIT | Protocolo de transferencia seguro bancario | PeSIT D, PeSIT E |
| HTTPS | Transferencia de archivos sobre HTTP con TLS | HTTP/HTTPS multipart upload |
| CipherTrust | Transferencia cifrada de archivos con gestión de claves integrada | OpenPGP (RFC 4880), S/MIME |
| Ad-hoc Transfer | Transferencia temporaria a usuarios externos (portal web) | Portal MFT, link sharing expirable |
| PGP | Pretty Good Privacy para cifrado de archivos | OpenPGP, GPG |
| EDI (Electronic Data Interchange) | Intercambio electrónico de documentos de negocio en formato estructurado | X12, EDIFACT, XML, JSON |

## Tecnologías principales

| Plataforma | Licencia | Protocolos | Cloud/Hybrid | Caso de uso principal |
|------------|----------|------------|--------------|----------------------|
| IBM Sterling File Gateway | Enterprise | FTP/S, SFTP, AS2, PeSIT, HTTP/S, Connect:Direct | Sí (Hybrid) | Banca, retail, enterprise B2B |
| Axway SecureTransport | Enterprise | FTP/S, SFTP, AS2, PeSIT, HTTP/S | Sí (Hybrid) | Banca, gobierno, B2B |
| MOVEit (Progress) | Enterprise | FTP/S, SFTP, AS2, HTTP/S, DMZ Gateway | Sí (Hybrid, Cloud) | Enterprise, healthcare (HIPAA) |
| GoAnywhere MFT | Enterprise/Cloud | FTP/S, SFTP, AS2, HTTP/S, WebDAV | Sí (Cloud, Hybrid) | SMB, mid-market, enterprise |
| SolarWinds Serv-U | Enterprise | FTP/S, SFTP, HTTP/S, WebDAV | Sí (Cloud, Hybrid) | Mid-market, IT departments |
| AWS Transfer Family | Cloud (SaaS) | FTP, FTPS, SFTP, AS2 (SFTP connector) | Cloud nativo | AWS-native MFT, S3 integration |
| Azure MFT | Cloud | SFTP (Preview), Azure Data Factory + SFTP/S | Cloud nativo | Azure-native integration |
| Google Cloud MFT | Cloud | SFTP (Private/Public Cloud) | Cloud nativo | GCP-native MFT |
| Citrix ShareFile | Cloud | SFTP, HTTPS (portal), Outlook plugin | Cloud | Intercambio ad-hoc con clientes |
| Cyberuk | Enterprise | SFTP, FTPS, HTTPS, AS2 | Sí | Enterprise security-focused |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos fundamentales de transferencia de archivos: FTP básico, modos (activo vs pasivo), FTPS (FTP sobre SSL/TLS, explícito vs implícito), SFTP (protocolo separado sobre SSH). Protocolos de seguridad: TLS 1.2/1.3 vs SSL (obsoleto), cifrado simétrico vs asimétrico en tránsito, certificados X.509 para FTPS. Autenticación: password-based, key-based (SSH keys para SFTP), host key verification (known_hosts). Configuración básica: instalar servidor SFTP (OpenSSH), crear usuarios, configurar chroot (jail), limitar a SFTP sin shell. Clientes: FileZilla, WinSCP (GUI), sftp CLI (OpenSSH), curl para FTPS, lftp (Linux). Automatización básica: scripts Bash con sftp/curl, manejo de errores, logging.
   - Práctica: Configurar servidor OpenSSH SFTP con chroot. Transferir archivos con sftp, curl, FileZilla. Automatizar transferencia con script bash.
   - Lectura: OpenSSH manual, "SFTP: The Secure File Transfer Protocol" (Barrett, Silverman).

2. **Intermedio (2-6 meses)**: Cifrado PGP: generación de claves GPG (pública/privada), cifrado/descifrado asimétrico, firma y verificación, key servers, passphrase management. Integración PGP con transferencia: cifrar antes de enviar, descifrar al recibir. AS2 protocolo: EDI sobre HTTP/S con receipt (MDN), firma digital, cifrado, compresión. Configurar AS2 con partners trading. EDI basics: X12 (850 Purchase Order, 810 Invoice, 856 ASN), EDIFACT, segmentos, elementos, loops, traducción. Workflows MFT: reglas de enrutamiento (carpeta → procesar → cifrar → transferir → confirmar), triggers (carpeta watcher, schedule, API). Scheduling: cron-based, time-based triggers, file arrival triggers. Logging y alertas: logs de transferencia (éxito/fallo), notificaciones email/Slack, re-intentos con backoff, dead letter handling. Automatización con scripts/CLI: lftp (mirror, parallel, retry), sftp batch files.
   - Práctica: PGP automation (cifrar con GPG + transferir SFTP). Flujo AS2 básico con servidor MFT trial. Automatizar transferencia programada con Airflow/Prefect.
   - Lectura: "OpenPGP" (RFC 4880), AS2 specification (RFC 4130), EDI basics tutorials.

3. **Avanzado (6-12 meses)**: Plataformas MFT enterprise: IBM Sterling File Gateway, Axway SecureTransport, MOVEit — arquitectura, componentes (gateways, DMZ, load balancing, clustering), alta disponibilidad y failover. High Availability y escalabilidad: active-active clustering, load balancing (F5, HAProxy), multi-site replication. API-first MFT: REST APIs para transferencia, monitoreo, administración (Axway API, IBM Sterling APIs). Automatización avanzada: flujos de trabajo complejos (multi-step: recibir → validar → transformar → enrutar → cifrar → transferir → archivar → notificar). Transformación de datos: EDI to XML, XML to CSV, XSLT, Avro, Parquet. Monitoreo enterprise: dashboards (número de transferencias, volumen, tasa de éxito, latencia), SLA tracking, reportes regulatorios. Cumplimiento: PCI DSS para transferencias de datos de tarjetas, HIPAA para datos de salud, SOX para registros financieros — logging inmutable, retention policies, audit trails. Security hardening: DMZ deployment, bastion hosts, IP whitelisting, rate limiting, DDoS protection, incident response playbooks.
   - Proyecto: Implementar flujo MFT enterprise: partner sube EDI → validación → transformación → PGP encrypt → transferencia segura → acknowledgment.
   - Certificación: IBM Sterling Certified Admin, Axway MFT certification.

4. **Experto (12+ meses)**: Cloud MFT: AWS Transfer Family (SFTP/FTPS/AS2 endpoints con S3 backend), Azure MFT (SFTP with Blob Storage), Google Cloud MFT (SFTP with Cloud Storage). Integración cloud-native: serverless MFT (Lambda triggers after transfer, S3 event notifications, EventBridge rules). Multi-cloud MFT: orquestación de transferencia entre AWS-GCP-Azure. MFT-as-a-Service: modelos consumption-based, auto-scaling, pay-per-transfer. Secure data exchange: B2B integration hubs, API-based data exchange (MFT + API Management), IPaaS integration (MuleSoft, Workato, Boomi). Zero Trust File Transfer: identity-aware proxy, short-lived credentials, session recording, IP allow-listing dinámico, attribute-based access control (ABAC). Emerging protocols: AS4 (ebMS3 with WS-Security), FTP/ES (FTP sobre SSH, enfoque diferente). MFT en arquitecturas event-driven: Kafka + MFT (transferir archivos como eventos), streaming file processing. Large file optimization: parallel streaming, compression on the fly, resumable transfers (Rsync-like en MFT). AI-driven MFT: predictive failure detection, intelligent routing, auto-tuning de parámetros de transferencia.
   - Proyecto: Cloud-native MFT con AWS Transfer Family + S3 + Lambda. MFT-as-a-Service plataforma multi-tenant. Zero-trust MFT architecture.
   - Lectura: Cloud provider MFT docs, "B2B Integration and MFT" (Axway), MFT industry analyst reports.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | Extracción/carga de datos desde/hacia DB vía MFT |
| [005-Cloud](../005-Cloud/) | AWS Transfer Family, Azure MFT, Cloud MFT services |
| [008-Networking](../008-Networking/) | Protocolos de transferencia, firewalls, DMZ, TLS/SSH |
| [009-Security](../009-Security/) | Cifrado, PGP, certificados, compliance, audit trails |
| [013-DevOps](../013-DevOps/) | Automatización de transferencias en pipelines |
| [015-Automation](../015-Automation/) | Workflows automatizados de transferencia |
| [016-RPA](../016-RPA/) | Bots RPA que inician/consumen transferencias MFT |
| [018-ERP](../018-ERP/) | EDI/integración de documentos con sistemas ERP |
| [019-CRM](../019-CRM/) | Intercambio de datos con partners via MFT |

## Recursos recomendados

- **Plataformas**: IBM Sterling File Gateway, Axway SecureTransport, Progress MOVEit, Fortra GoAnywhere MFT, AWS Transfer Family.
- **Protocolos**: SFTP (SSH File Transfer Protocol), FTPS (FTP over SSL/TLS), AS2 (RFC 4130), AS4 (ebMS3), PGP (RFC 4880).
- **Estándares**: EDI X12, EDIFACT, HIPAA 834/837, PCI DSS for file transfer.
- **Lectura**: "PGP & GPG: Email for the Practical Paranoid" (Lucas), AS2/AS4 specification, RFCs 959 (FTP), 4217 (FTPS), 4253 (SSH Transport), 4254 (SSH Connection).
- **Certificaciones**: IBM Sterling Certified Admin, Axway SecureTransport Professional, AWS Certified Solutions Architect (para cloud MFT).

## Notas adicionales

MFT es crítico para industrias reguladas (financiero, salud, retail) y B2B. Aunque protocolos como SFTP y FTPS existen hace décadas, las plataformas MFT añaden gestión, automatización, seguridad y cumplimiento. La tendencia es cloud MFT (AWS Transfer Family, Azure MFT) y MFT como servicio. Con la creciente importancia de la seguridad de supply chain, MFT bien implementado es esencial. EDI sigue siendo el formato B2B dominante y AS2 es el protocolo EDI más usado en Norteamérica.
