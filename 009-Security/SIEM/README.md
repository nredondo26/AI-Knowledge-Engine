# SIEM — Security Information and Event Management

## Conceptos Fundamentales

Un SIEM (Security Information and Event Management) es un sistema que recolecta, normaliza, correlaciona y analiza eventos de seguridad de múltiples fuentes (firewalls, servidores, aplicaciones, endpoints) para detectar amenazas, investigar incidentes y cumplir con requisitos de auditoría.

### Funciones Clave

- **Recolección centralizada de logs**: Agregar logs de toda la infraestructura en un solo lugar.
- **Normalización**: Convertir logs de diferentes formatos a un esquema común.
- **Correlación**: Detectar patrones de ataque combinando múltiples eventos.
- **Alertas**: Notificar en tiempo real sobre eventos sospechosos.
- **Dashboards y reportes**: Visualización para análisis y compliance.
- **Retención de logs**: Almacenamiento a largo plazo para forense y auditoría.

## ELK Stack (Elasticsearch + Logstash + Kibana)

### Configuración de Filebeat (recolección)

```yaml
# filebeat.yml
filebeat.inputs:
  - type: filestream
    enabled: true
    paths:
      - /var/log/auth.log
      - /var/log/syslog
    fields:
      service: linux-syslog
    fields_under_root: true

  - type: filestream
    enabled: true
    paths:
      - /var/log/nginx/access.log
    fields:
      service: nginx-access
    fields_under_root: true

output.elasticsearch:
  hosts: ["https://elasticsearch:9200"]
  username: "filebeat_user"
  password: "${ES_PASSWORD}"
  ssl.verification_mode: certificate

setup.kibana:
  host: "https://kibana:5601"
```

### Pipeline de Logstash (normalización)

```ruby
# logstash.conf
input {
  beats {
    port => 5044
    ssl => true
    ssl_certificate_authorities => ["/etc/logstash/ca.crt"]
  }
}

filter {
  if [service] == "nginx-access" {
    grok {
      match => {
        "message" => "%{COMBINEDAPACHELOG}"
      }
    }
    geoip {
      source => "clientip"
      target => "geo"
    }
    mutate {
      convert => { "[bytes]" => "integer" }
    }
  }

  if [service] == "linux-syslog" {
    grok {
      match => {
        "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:hostname} %{DATA:process}: %{GREEDYDATA:message}"
      }
    }
  }
}

output {
  elasticsearch {
    hosts => ["https://elasticsearch:9200"]
    index => "siem-logs-%{+YYYY.MM.dd}"
    ssl => true
    cacert => "/etc/logstash/ca.crt"
  }
}
```

### Regla de Detección en Elastic SIEM

```kql
# Detectar múltiples fallos de autenticación SSH
event.category: authentication
  and event.type: failure
  and process.name: sshd
  and source.ip: *

# Agrupar por IP origen, alertar si > 5 fallos en 5 minutos
| stats count_failures = count() by source.ip
| where count_failures > 5
```

## Wazuh (Open Source SIEM)

### Configuración del agente Wazuh

```xml
<!-- /var/ossec/etc/ossec.conf -->
<ossec_config>
  <client>
    <server>
      <address>wazuh-manager.ejemplo.com</address>
      <protocol>tcp</protocol>
      <port>1514</port>
    </server>
    <config-profile>ubuntu, linux</config-profile>
    <notify_time>10</notify_time>
    <time-reconnect>60</time-reconnect>
  </client>

  <syscheck>
    <frequency>3600</frequency>
    <scan_on_start>yes</scan_on_start>
    <directories check_all="yes">/etc,/usr/bin,/usr/sbin</directories>
    <directories check_all="yes" realtime="yes">/var/www</directories>
  </syscheck>

  <rootcheck>
    <frequency>43200</frequency>
  </rootcheck>
</ossec_config>
```

### Regla de correlación personalizada

```xml
<group name="web_attacks,">
  <rule id="100001" level="10">
    <if_group>web|accesslog</if_group>
    <match>union.*select|select.*from|insert into|drop table</match>
    <description>Posible SQL Injection detectada</description>
    <mitre>
      <id>T1190</id>
    </mitre>
  </rule>

  <rule id="100002" level="8">
    <if_group>web|accesslog</if_group>
    <match>.env|.git/config|wp-config|web.config</match>
    <description>Intento de acceso a archivos sensibles</description>
  </rule>
</group>
```

## Correlación de Eventos

### Reglas de correlación (Sigma)

```yaml
# sigma_rule.yaml
title: Brute Force SSH Detection
id: a1b2c3d4-e5f6-7890-abcd-ef1234567890
status: experimental
description: Detecta múltiples fallos de autenticación SSH

logsource:
  category: authentication
  product: linux

detection:
  selection:
    EventID: 4648  # Windows
    LogName: Security
  keywords:
    - "failed password"
    - "authentication failure"
  condition: selection | count() > 10 by SourceIp

falsepositives:
  - Administradores legítimos olvidando contraseñas

level: high
```

## Dashboard de Monitoreo (Kibana)

```json
{
  "attributes": {
    "title": "Resumen de Seguridad - Últimas 24h",
    "panels": [
      { "visualization": "eventos-por-tipo", "gridData": { "x": 0, "y": 0, "w": 24, "h": 15 } },
      { "visualization": "top-ips-atacantes", "gridData": { "x": 24, "y": 0, "w": 24, "h": 15 } },
      { "visualization": "alertas-por-severidad", "gridData": { "x": 0, "y": 15, "w": 48, "h": 15 } },
      { "visualization": "evolucion-temporal", "gridData": { "x": 0, "y": 30, "w": 48, "h": 20 } }
    ]
  }
}
```

## Tecnologías Principales

| Herramienta | Tipo | Descripción |
|-------------|------|-------------|
| Wazuh | Open Source | SIEM + XDR (FIM, vulnerabilidades, compliance) |
| ELK Stack | Open Source | Elasticsearch + Logstash + Kibana + Fleet |
| Splunk | Comercial | SIEM enterprise con correlación avanzada |
| Chronicle | Google Cloud | SIEM serverless con detección por IA |
| Microsoft Sentinel | Azure | SIEM cloud-native con analítica de amenazas |
| QRadar | IBM | SIEM tradicional con UEBA integrado |

## Relaciones

- [IncidentResponse](../IncidentResponse/) — Los alertas del SIEM disparan el proceso de respuesta
- [NetworkSecurity](../NetworkSecurity/) — Logs de firewalls, IDS/IPS alimentan el SIEM
- [CloudSecurity](../CloudSecurity/) — CloudTrail, GuardDuty logs enviados al SIEM
- [DevSecOps](../DevSecOps/) — Pipelines de seguridad envían eventos al SIEM

## Recursos Recomendados

- Wazuh Documentation — documentation.wazuh.com
- Elastic Security Docs — elastic.co/security
- Sigma HQ — Reglas de correlación abiertas (sigmahq.io)
- MITRE ATT&CK — Mitre ATT&CK framework para mapping de reglas
- "SIEM Implementation Best Practices" — SANS Reading Room
