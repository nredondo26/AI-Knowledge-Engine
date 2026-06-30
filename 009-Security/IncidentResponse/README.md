# IncidentResponse — Respuesta a Incidentes de Seguridad

## Conceptos Fundamentales

La respuesta a incidentes (IR) es el proceso estructurado para manejar ciberataques y brechas de seguridad. El objetivo es minimizar el daño, reducir el tiempo de recuperación y preservar evidencia para acciones legales o forenses.

### Ciclo de Vida del Incidente (NIST SP 800-61)

1. **Preparation**: Equipo, herramientas, playbooks, acuerdos
2. **Detection & Analysis**: Identificar, clasificar y priorizar
3. **Containment, Eradication & Recovery**: Contener, eliminar, restaurar
4. **Post-Incident Activity**: Lecciones aprendidas, mejora continua

## Playbook de Respuesta — Ransomware

### Fase 1: Detección y Clasificación

```python
# Script de detección temprana de ransomware
import os
import hashlib
import json
from datetime import datetime, timedelta

def detect_ransomware_indicators(path):
    indicators = {
        "file_renames": [],
        "high_iops": 0,
        "new_extensions": set(),
    }
    
    suspicious_extensions = {'.encrypted', '.locked', '.crypt',
                             '.enc', '.crypted'}
    
    for root, dirs, files in os.walk(path):
        for f in files:
            ext = os.path.splitext(f)[1].lower()
            if ext in suspicious_extensions:
                indicators["new_extensions"].add(ext)
                indicators["file_renames"].append(
                    os.path.join(root, f))
    
    return indicators

# Alertar si se detectan indicadores
def evaluate_alert(indicators):
    severity = "low"
    if len(indicators["file_renames"]) > 10:
        severity = "critical"
        print("⚠️ ALERTA CRÍTICA: Posible ransomware detectado")
        # Enviar a SIEM
        send_to_siem({
            "alert": "ransomware_detected",
            "severity": severity,
            "timestamp": datetime.utcnow().isoformat(),
            "indicators": indicators
        })
    return severity
```

### Fase 2: Contención

```bash
#!/bin/bash
# Playbook de contención para ransomware

# 1. Aislar el host comprometido
echo "[+] Aislando host ${HOSTNAME}"
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

# 2. Tomar snapshot forense de memoria
echo "[+] Capturando memoria"
sudo lime-forensics -d /dev/mem -f /tmp/forensic/mem_$(date +%s).lime

# 3. Desmontar shares de red sospechosos
echo "[+] Desmontando shares"
umount -f /mnt/share_suspicious 2>/dev/null

# 4. Revocar tokens y sesiones activas
echo "[+] Revocando tokens"
aws cognito-idp admin-revoke-token \
  --user-pool-id <pool_id> \
  --username <compromised_user>

# 5. Bloquear IP del atacante en el firewall
iptables -A INPUT -s <attacker_ip> -j DROP
```

### Fase 3: Erradicación

```yaml
# Ansible playbook: erradicar malware en servidores
- name: Erradicación de malware
  hosts: compromised_servers
  tasks:
    - name: Matar procesos maliciosos
      shell: |
        pkill -f miner
        pkill -f xmrig
        systemctl stop unknown_service

    - name: Eliminar archivos maliciosos
      file:
        path: "{{ item }}"
        state: absent
      with_items:
        - /tmp/malware.sh
        - /var/tmp/.systemd
        - /etc/cron.d/malicious

    - name: Verificar integridad de binarios críticos
      shell: sha256sum -c /usr/share/baseline/checksums.txt
      register: integrity_check
      failed_when: integrity_check.rc != 0
```

### Fase 4: Recuperación

```hcl
# Terraform: restaurar desde snapshot
resource "aws_ebs_snapshot" "pre_incident" {
  volume_id = aws_ebs_volume.db.id
  timestamp = "2025-12-01T000000Z"  # snapshot pre-incidente
}

resource "aws_volume" "restored_db" {
  availability_zone = "us-east-1a"
  snapshot_id = aws_ebs_snapshot.pre_incident.id
  
  tags = {
    Name = "db-restored-post-incident"
    IncidentID = "IR-2025-001"
  }
}
```

## Post-Mortem Template

```markdown
# Post-Mortem: IR-2025-001

## Resumen
- **Fecha del incidente**: 2025-12-15 14:30 UTC
- **Duración**: 3h 45m
- **Tipo**: Ransomware (LockBit 3.0)
- **Impacto**: 12 servidores cifrados, 5TB de datos
- **MTTR**: 4.5 horas
- **MTBF**: 180 días

## Timeline
| Hora | Evento |
|------|--------|
| 14:30 | Alerta SIEM: detección de archivos .encrypted |
| 14:35 | Confirmación de ransomware |
| 14:40 | Inicio de contención (aislar hosts) |
| 15:15 | Contención completada |
| 16:00 | Inicio de erradicación |
| 18:15 | Recuperación desde backups completada |

## Root Cause
Empleado descargó adjunto malicioso de phishing. El malware se propagó
vía SMB por falta de segmentación de red.

## Acciones Correctivas
- [ ] Implementar microsegmentación (NetworkPolicies)
- [ ] Desplegar Falco para detección runtime
- [ ] Bloquear macros de Office vía GPO
- [ ] Entrenamiento de phishing para todo el equipo
- [ ] Implementar MFA en todos los accesos
```

## Tecnologías Principales

| Herramienta | Propósito |
|-------------|-----------|
| TheHive | Plataforma de SOAR para gestión de casos |
| Cortex | Motor de análisis automatizado (TheHive) |
| Shuffle | SOAR open source con playbooks visuales |
| DFIR-IRIS | Plataforma de respuesta a incidentes |
| Velociraptor | Recolección forense en endpoints |
| GRR Rapid Response | Framework de respuesta remota (Google) |

## Relaciones

- [SIEM](../SIEM/) — Los alertas del SIEM inician el proceso de IR
- [AppSec](../AppSec/) — Vulnerabilidades detectadas → posibles incidentes
- [NetworkSecurity](../NetworkSecurity/) — Firewall y segmentación como controles preventivos
- [ZeroTrust](../ZeroTrust/) — Reduce el blast radius de incidentes
- [DevSecOps](../DevSecOps/) — Pipelines seguros reducen incidentes

## Recursos Recomendados

- NIST SP 800-61 Rev 2 — Computer Security Incident Handling Guide
- SANS Incident Handler's Handbook
- MITRE ATT&CK — Para mapeo de TTPs
- "Incident Response & Computer Forensics" — Luttgens, Pepe
- DFIR Report — dfirreport.com (análisis de incidentes reales)
- TheHive Project — thehive-project.org
