# GoAnywhere MFT — Managed File Transfer

## Visión General

GoAnywhere MFT (Managed File Transfer) de Fortra es una plataforma empresarial para automatizar, asegurar y gestionar la transferencia de archivos. Proporciona interfaces web, cifrado robusto e integración con múltiples protocolos.

## Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                  GoAnywhere Services                     │
├────────────────┬──────────────┬─────────────────────────┤
│  Web Client    │  Admin       │  REST API               │
│  (HTTPS)       │  Interface   │  (Swagger/OpenAPI)      │
├────────────────┼──────────────┼─────────────────────────┤
│  File Transfer Server (FTS)   │  Gateway (DMZ)          │
│  ┌──────────────────────────┐ │  ┌──────────────────┐   │
│  │ Project Engine           │ │  │ Reverse Proxy    │   │
│  │ Scheduler                │ │  │ TLS Termination  │   │
│  │ Encryption Engine        │ │  │ Port Forwarding  │   │
│  │ PGP/GPG Processing       │ │  └──────────────────┘   │
│  └──────────────────────────┘ │                          │
├────────────────────────────────┴─────────────────────────┤
│  Database (HSQLDB / MySQL / SQL Server / Oracle)          │
│  File System / S3 / Azure Blob / SFTP                     │
└──────────────────────────────────────────────────────────┘
```

## Protocolos Soportados

| Protocolo | Puerto | Cifrado | Dirección |
|-----------|--------|---------|-----------|
| FTP(S) | 21 / 990 | TLS/SSL | Bidireccional |
| SFTP (SSH) | 22 | SSH-2 | Bidireccional |
| HTTP(S) | 80 / 443 | TLS/SSL | Bidireccional |
| AS2 | 80 / 443 | S/MIME + TLS | Bidireccional |
| AS3 | 80 / 443 | S/MIME | Upload |
| AS4 | 80 / 443 | WS-Security | Bidireccional |
| WebDAV | 80 / 443 | TLS/SSL | Bidireccional |
| Azure Blob | 443 | HTTPS | Download / Upload |
| Amazon S3 | 443 | HTTPS | Download / Upload |
| Google Cloud Storage | 443 | HTTPS | Download / Upload |

## Instalación (Linux)

```bash
# Prerequisitos
sudo apt update
sudo apt install openjdk-11-jdk unzip

# Descargar GoAnywhere (requiere cuenta)
wget https://downloads.goanywhere.com/goanywhere-mft-linux64-7.x.x.zip
unzip goanywhere-mft-linux64-7.x.x.zip -d /opt/goanywhere

# Instalar como servicio
cd /opt/goanywhere
./InstallAsService.sh

# Iniciar
sudo systemctl start goanywhere
sudo systemctl enable goanywhere

# Logs
tail -f /opt/goanywhere/logs/goanywhere.log
```

## Configuración de Project (XML)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<GoAnywhereProject version="7.0">
  <Resources>
    <Resource name="ClienteSFTP" type="SFTP">
      <Property name="hostname">sftp.cliente.com</Property>
      <Property name="port">22</Property>
      <Property name="username">${sftp.user}</Property>
      <Property name="authenticationType">PUBLIC_KEY</Property>
      <Property name="privateKey">${sftp.key}</Property>
    </Resource>

    <Resource name="BucketS3" type="S3">
      <Property name="bucketName">mi-bucket</Property>
      <Property name="region">eu-west-1</Property>
      <Property name="accessKey">${aws.access.key}</Property>
    </Resource>
  </Resources>

  <Tasks>
    <Task name="DescargarFacturas" schedule="0 0 3 * * ?">
      <Download source="ClienteSFTP" remotePath="/outbound/facturas/"
                localPath="/data/incoming/" fileMask="*.csv"
                archiveOnSuccess="true" archivePath="/data/archive/"/>
      <PGPDecrypt localPath="/data/incoming/" fileMask="*.pgp"
                  privateKey="${pgp.private}" passphrase="${pgp.pass}"/>
      <Upload target="BucketS3" localPath="/data/processed/"
              remotePath="facturas/" fileMask="*.csv"/>
      <SendEmail to="admin@empresa.com" subject="Facturas procesadas">
        <Body>Se procesaron ${ga.files.transferred} archivos.</Body>
      </SendEmail>
    </Task>
  </Tasks>
</GoAnywhereProject>
```

## Comandos CLI (gacl)

```bash
# Ejecutar proyecto
gacl -project /opt/projects/descarga-facturas.xml -variables env=prod

# Listar proyectos disponibles
gacl -listProjects

# Ver estado de ejecución
gacl -status -project "DescargaFacturas"

# Probar conexión a recurso
gacl -testConnection -resource "ClienteSFTP"
```

## REST API

```bash
# Autenticación
curl -X POST https://mft.empresa.com:8040/goanywhere/rest/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"secret"}'
# Response: {"token": "eyJhbGci..."}

# Ejecutar proyecto
curl -X POST https://mft.empresa.com:8040/goanywhere/rest/projects/run \
  -H "Authorization: Bearer eyJhbGci..." \
  -H "Content-Type: application/json" \
  -d '{"projectPath":"/opt/projects/descarga-facturas.xml"}'

# Listar archivos en un recurso
curl -X POST https://mft.empresa.com:8040/goanywhere/rest/resources/list \
  -H "Authorization: Bearer eyJhbGci..." \
  -H "Content-Type: application/json" \
  -d '{"resourceName":"ClienteSFTP","path":"/outbound"}'
```

## PGP Encryption

```bash
# Generar par de llaves PGP
gpg --gen-key
gpg --export -a "user@empresa.com" > public.key
gpg --export-secret-keys -a "user@empresa.com" > private.key

# Importar llave de socio comercial
gpg --import socio_public.key
gpg --list-keys
```

```xml
<PGPEncrypt localPath="/data/salida/" fileMask="*.csv"
            publicKey="${socio.public.key}"
            asciiArmor="true"
            signingKey="${mi.private.key}"
            signingPassphrase="${mi.passphrase}"/>
```

## AS2 Configuration

```xml
<AS2Receive localPath="/data/as2/incoming/"
            partnerName="ClienteA"
            certificateFile="/etc/certs/as2.p12"
            certificatePassword="${as2.cert.pass}"
            mdnMode="SYNC"/>
```

## Alta Disponibilidad (Cluster)

Configuración de cluster activo-pasivo con sesión replicada:

```yaml
# cluster.properties
cluster.enabled=true
cluster.node.id=node1
cluster.peer.nodes=node2.mft.empresa.com:8040
cluster.replication.port=7800
cluster.session.replication=true
cluster.data.sync=true
```

## Seguridad

```yaml
Hardening recomendado:
  - TLS 1.2+ obligatorio, deshabilitar SSLv3/TLSv1.0
  - Ciphers: ECDHE-RSA-AES256-GCM-SHA384
  - Autenticación 2FA en consola admin
  - IP whitelist en Gateway
  - Auditoría de todas las transferencias
  - Rotación de llaves PGP cada 90 días
  - Almacenamiento de contraseñas en vault externo (CyberArk, HashiCorp Vault)
```

## Logging y Auditoría

```xml
<LoggingConfiguration>
  <Appender name="FILE" type="RollingFile">
    <File>/var/log/goanywhere/mft.log</File>
    <Pattern>%d{ISO8601} [%t] %-5p %c - %m%n</Pattern>
  </Appender>

  <AuditLog>
    <Events>LOGIN, DOWNLOAD, UPLOAD, DELETE, ENCRYPT, DECRYPT</Events>
    <Output type="DATABASE"/>
    <Output type="SYSLOG" host="syslog.empresa.com" port="514"/>
  </AuditLog>
</LoggingConfiguration>
```

## Referencias

- [GoAnywhere MFT Documentation](https://www.goanywhere.com/managed-file-transfer/documentation)
- [GoAnywhere REST API](https://www.goanywhere.com/developers/rest-api)
- [Fortra Support](https://support.fortra.com/)
- [GoAnywhere Community](https://community.goanywhere.com/)
