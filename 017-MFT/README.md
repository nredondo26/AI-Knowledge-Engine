# 017-MFT (Managed File Transfer)

## Descripción del dominio

Managed File Transfer (MFT) es una tecnología y conjunto de prácticas que garantizan la transferencia segura, confiable y auditable de archivos entre sistemas, organizaciones y personas. A diferencia del FTP tradicional o los archivos adjuntos por correo, las soluciones MFT proporcionan cifrado en tránsito y en reposo, autenticación robusta, compresión, reintentos automáticos, notificaciones, logging detallado y cumplimiento normativo (GDPR, HIPAA, PCI-DSS, SOX). Se utiliza en sectores como banca, salud, retail y gobierno para intercambiar datos financieros, órdenes de compra, facturas, informes regulatorios y cualquier información sensible entre socios comerciales.

## Conceptos clave

- **Protocolos de transferencia**: SFTP (SSH File Transfer Protocol, cifrado basado en SSH), FTPS (FTP sobre SSL/TLS), AS2 (Applicability Statement 2, usado en EDI), HTTPS, SCP, FTP (solo redes internas seguras).
- **Cifrado en tránsito y en reposo**: protección de datos durante la transferencia (TLS/SSL, SSH) y cuando están almacenados en el servidor MFT (AES-256).
- **Autenticación y autorización**: métodos para verificar la identidad del remitente/destinatario: usuario/contraseña, claves SSH, certificados X.509, autenticación de dos factores (2FA), integración con LDAP/AD, SSO (SAML, OAuth).
- **EDI (Electronic Data Interchange)**: formato estándar para intercambio de documentos comerciales (facturas, órdenes de compra). AS2 es el protocolo más usado para EDI sobre internet.
- **Centro de confianza (DMZ)**: arquitectura de red donde se ubican los servidores MFT para aislar las transferencias de la red interna y exponer solo los servicios necesarios.
- **Auditoría y trazabilidad**: registro detallado de cada transferencia (quién, qué, cuándo, destino, tamaño, checksum, éxito/fallo) para cumplimiento normativo y forense digital.
- **Automatización de flujos (workflows)**: secuencias de acciones que se disparan tras una transferencia: validación de archivo, transformación (criptografía, conversión de formato), notificación, enrutamiento a sistemas downstream.
- **Alta disponibilidad (HA) y failover**: configuración de clústeres MFT para garantizar que las transferencias continúen incluso si un servidor falla.
- **PGP (Pretty Good Privacy)**: cifrado asimétrico de archivos antes de la transferencia, usado para proteger datos altamente sensibles.
- **Velocidad y rendimiento**: optimización de transferencias mediante compresión, paralelismo, throttling (límite de ancho de banda) y reanudación de transferencias interrumpidas.

## Tecnologías principales

- **Plataformas MFT**: GoAnywhere MFT (HelpSystems), MOVEit (Ipswitch/Progress), Axway MFT, IBM Sterling B2B Integrator, Cleo Harmony, Globalscape EFT, Jscape MFT Server, TIBCO MFT.
- **Protocolos**: SFTP (puerto 22), FTPS (puerto 990), AS2 (puerto 443/80), HTTPS (puerto 443), SCP, FTP.
- **Cifrado**: OpenSSL, GnuPG/PGP, AES-256, TLS 1.2/1.3, SSH-2.
- **Integración con EDI**: OpenText Trading Grid, IBM Sterling B2B, Cleo VLTrader, TrueCommerce.
- **Logging y auditoría**: integración con SIEM (Splunk, ELK, QRadar, Sentinel) para correlacionar eventos de transferencia con otros eventos de seguridad.
- **Cloud y SaaS**: MOVEit Cloud, GoAnywhere Cloud, Axway Managed File Transfer Cloud, AWS Transfer Family (SFTP/FTPS/AS2), Google Transfer Appliance.

## Hoja de ruta

1. **Principiante**: entender los protocolos SFTP, FTPS y FTP, sus diferencias y usos; instalar y configurar un servidor SFTP básico (OpenSSH); conectarse desde un cliente (WinSCP, FileZilla, lftp); transferir archivos manualmente.
2. **Intermedio**: implementar una solución MFT comercial (GoAnywhere o MOVEit) en un entorno de prueba; configurar cuentas de usuario, claves SSH y certificados; automatizar transferencias recurrentes con scripts o workflows; habilitar logging básico y alertas.
3. **Avanzado**: diseñar una arquitectura MFT de alta disponibilidad con clúster y balanceo de carga; integrar MFT con sistemas de autenticación corporativa (LDAP, AD, SSO); implementar flujos EDI con AS2; aplicar cifrado PGP antes de la transferencia; integrar con SIEM para auditoría centralizada.
4. **Experto**: establecer políticas de gobierno y retención de datos transferidos; diseñar estrategias de disaster recovery y continuidad de negocio para MFT; evaluar y seleccionar entre MFT on-premise, cloud o híbrido según requisitos de latencia, cumplimiento y volumen.

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — MFT se integra como adaptador en una arquitectura hexagonal; la DMZ y el aislamiento de red son decisiones arquitectónicas.
- [011-DesignPatterns](../011-DesignPatterns/) — los flujos MFT siguen patrones como Pipeline (transformación secuencial), Strategy (selección de protocolo) y Observer (notificaciones post-transferencia).
- [012-Testing](../012-Testing/) — es necesario probar transferencias, reintentos, interrupciones y recuperación; pruebas de integración con sistemas origen y destino.
- [013-DevOps](../013-DevOps/) — MFT se despliega como parte de la infraestructura; las configuraciones se gestionan como código (IaC) y se versionan.
- [014-CICD](../014-CICD/) — los pipelines CI/CD pueden disparar transferencias MFT para distribuir artefactos o reportes entre entornos.
- [015-Automation](../015-Automation/) — los workflows MFT se integran con orquestadores (Airflow, Ansible) para automatizar flujos de datos de extremo a extremo.
- [016-RPA](../016-RPA/) — RPA puede procesar los archivos transferidos por MFT o ser el origen/destino de una transferencia automatizada.
- [018-ERP](../018-ERP/) — MFT se usa para transferir interfaces de ERP (órdenes de compra, facturas, avisos de pago) con socios comerciales.
- [019-CRM](../019-CRM/) — importación/exportación masiva de datos de CRM (contactos, cuentas, leads) mediante archivos transferidos por MFT.

## Recursos recomendados

- *GoAnywhere MFT Documentation* — goanywhere.com/documentation
- *MOVEit MFT Documentation* — docs.ipswitch.com
- *Axway MFT Documentation* — docs.axway.com
- *IBM Sterling B2B Integrator Documentation* — ibm.com/docs/sterling-b2b-integrator
- *Understanding AS2* — RFC 4130, RFC 6017
- *OpenSSH SFTP Server Configuration Guide* — openssh.com
- *MFT Security Best Practices* — Gartner, Forrester reports
- *AWS Transfer Family Documentation* — aws.amazon.com/aws-transfer-family
