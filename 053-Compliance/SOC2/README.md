# SOC 2 — System and Organization Controls

## Visión General

SOC 2 (System and Organization Controls 2) es un marco de auditoría desarrollado por el AICPA (American Institute of CPAs). Evalúa los controles de una organización en relación con cinco Trust Service Criteria (TSC). Es el estándar más común para proveedores SaaS que manejan datos de clientes.

## Trust Service Criteria (TSC)

| Criterio | Descripción | Sigla |
|----------|-------------|-------|
| **Security** | Protección contra acceso no autorizado | C (Common) |
| **Availability** | Disponibilidad del sistema según el compromiso | A |
| **Processing Integrity** | Procesamiento completo, preciso, autorizado y oportuno | PI |
| **Confidentiality** | Protección de información confidencial | C |
| **Privacy** | Recopilación, uso, retención y divulgación de información personal | P |

## Tipos de Informes SOC

```
SOC 1 ── Controles sobre informes financieros (SSAE 18 / ISAE 3402)
SOC 2 ── Controles sobre seguridad, disponibilidad, integridad, confidencialidad, privacidad
SOC 3 ── Versión pública del SOC 2 (sin detalles de controles)
SOC for Cybersecurity ── Programa de gestión de ciberseguridad
```

### SOC 2 Tipo I vs Tipo II

| Aspecto | Tipo I | Tipo II |
|---------|--------|---------|
| Evaluación | Diseño de controles | Diseño + Eficacia operativa |
| Período | Un momento en el tiempo | Mínimo 6 meses (típico 12) |
| Evidencia | Documentación de controles | Pruebas de operación continua |
| Costo | ~$15-30K | ~$40-100K+ |

## Common Criteria (Security) — Controles Esenciales

```yaml
CC1: Control Environment
  - Integridad y valores éticos
  - Compromiso con competencia
  - Estructura organizativa

CC2: Communication and Information
  - Comunicación de información de control
  - Canales de denuncia (whistleblower)
  - Políticas accesibles

CC3: Risk Assessment
  - Identificación de riesgos
  - Gestión de cambios
  - Evaluación de fraud

CC4: Monitoring Activities
  - Monitoreo continuo de controles
  - Evaluaciones periódicas
  - Remediation de deficiencias

CC5: Control Activities
  - Políticas y procedimientos
  - Segregación de funciones
  - Controles de acceso

CC6: Logical and Physical Access
  - Autenticación y autorización
  - Gestión de identidades (IAM)
  - Seguridad física de datacenters

CC7: System Operations
  - Gestión de incidencias
  - Detección de anomalías
  - Protección contra malware

CC8: Change Management
  - Controles de cambios en software/infraestructura
  - Pruebas antes de producción
  - Aprobaciones documentadas

CC9: Risk Mitigation
  - Business continuity / Disaster recovery
  - Vendor management
  - Seguros cibernéticos
```

## Requisitos Técnicos Comunes (Security Criterion)

### Control de Acceso

```python
import hashlib
import hmac
from datetime import datetime

class AccessControlSystem:
    def __init__(self):
        self.policies = {}

    def enforce_mfa(self, user_id, factors):
        """Requerir autenticación multifactor para acceso admin"""
        if not self._validate_password(factors["password"]):
            return False
        if not self._validate_totp(factors["totp"]):
            return False
        if not self._validate_device(factors["device_id"]):
            return False
        return True

    def enforce_segregation_of_duties(self, user_id, action):
        """Evitar que la misma persona apruebe y ejecute cambios"""
        recent_actions = self.get_recent_actions(user_id, window_minutes=30)
        if action == "DEPLOY" and "APPROVE_DEPLOY" in recent_actions:
            return False
        return True

    def revoke_access_on_termination(self, user_id):
        """Revocar acceso inmediato al terminar relación laboral"""
        self.disable_user(user_id)
        self.rotate_api_keys(user_id)
        self.invalidate_sessions(user_id)
        self.audit_log(user_id, "ACCESS_REVOKED", datetime.utcnow())
```

### Logging y Monitoreo

```python
import logging
import json
from datetime import datetime, timedelta

class AuditLogger:
    def __init__(self, log_storage):
        self.logger = logging.getLogger("soc2_audit")
        self.storage = log_storage

    def log_access(self, user_id, resource, action, success):
        entry = {
            "timestamp": datetime.utcnow().isoformat(),
            "user": user_id,
            "resource": resource,
            "action": action,
            "success": success,
            "source_ip": self._get_client_ip(),
        }
        self.storage.append(entry)

    def detect_anomalies(self, window_minutes=15):
        """CC7.1 — Detección de anomalías"""
        window = datetime.utcnow() - timedelta(minutes=window_minutes)
        recent = self._get_recent_logs(window)

        # Brute force detection
        failed_counts = {}
        for entry in recent:
            if not entry["success"]:
                key = entry["user"] + ":" + entry["source_ip"]
                failed_counts[key] = failed_counts.get(key, 0) + 1

        for key, count in failed_counts.items():
            if count > 5:
                self.trigger_alert(f"Brute force detected: {key}")

        return failed_counts

    def _get_recent_logs(self, since):
        return [e for e in self.storage
                if datetime.fromisoformat(e["timestamp"]) > since]

    def trigger_alert(self, message):
        """Enviar alerta a SIEM / SOC"""
        print(f"[ALERT] {message}")
```

### Change Management

```yaml
Proceso de cambio documentado:
  1. Solicitud de cambio (RFC)
  2. Revisión de impacto y riesgo
  3. Aprobación (diferente del solicitante)
  4. Pruebas en entorno staging
  5. Ventana de despliegue programada
  6. Rollback plan documentado
  7. Verificación post-despliegue
  8. Cierre y documentación
```

```python
from enum import Enum
from dataclasses import dataclass

class ChangeType(Enum):
    EMERGENCY = "emergency"
    STANDARD = "standard"
    NORMAL = "normal"

@dataclass
class ChangeRequest:
    id: str
    description: str
    requester: str
    change_type: ChangeType
    risk_level: str  # low, medium, high, critical

class ChangeManager:
    def __init__(self):
        self.requests = []

    def create_change(self, cr: ChangeRequest):
        if cr.change_type == ChangeType.EMERGENCY:
            cr.approved = self._emergency_approval(cr)
        else:
            cr.approved = self._standard_approval(cr)

        if cr.risk_level in ("high", "critical"):
            self._require_peer_review(cr)

        self.requests.append(cr)

    def _standard_approval(self, cr):
        # Aprobación por manager distinto al solicitante
        return cr.requester != cr.approved_by

    def _emergency_approval(self, cr):
        # Aprobación acelerada + post-mortem en 24h
        return True
```

## Evidence Collection para Auditoría

```python
class SOC2EvidenceCollector:
    def __init__(self):
        self.evidence = []

    def collect_access_reviews(self, db_connection):
        """CC6.2 — Revisiones periódicas de acceso"""
        cursor = db_connection.execute("""
            SELECT u.username, u.last_access_review, r.role_name
            FROM users u
            JOIN roles r ON u.role_id = r.id
            WHERE u.active = 1
        """)
        self.evidence.append({
            "control": "CC6.2",
            "description": "Access review - all active users",
            "data": cursor.fetchall(),
            "timestamp": datetime.utcnow(),
        })

    def collect_backup_verification(self, storage):
        """CC7.5 — Verificación de backups"""
        backups = storage.list_backups()
        for backup in backups:
            verified = storage.verify_backup(backup["id"])
            self.evidence.append({
                "control": "CC7.5",
                "description": f"Backup verification: {backup['id']}",
                "result": "PASS" if verified else "FAIL",
                "timestamp": backup["created_at"],
            })

    def collect_incident_reports(self, incident_db):
        """CC7.3 — Respuesta a incidentes"""
        incidents = incident_db.get_all()
        for inc in incidents:
            self.evidence.append({
                "control": "CC7.3",
                "description": f"Incident: {inc.id}",
                "classification": inc.classification,
                "response_time": inc.response_time,
                "resolution_time": inc.resolution_time,
                "post_mortem": inc.post_mortem_exists,
            })
```

## Vendor Management

```yaml
Evaluación de proveedores críticos:
  - Solicitar SOC 2 Tipo II (vigencia < 12 meses)
  - Revisar excepciones y planes de remediación
  - Evaluar subprocesadores (sub-service organizations)
  - Contrato con SLA, right-to-audit, cláusulas de seguridad
  - Re-evaluación anual

Categorías de proveedores:
  Tier 1: Infraestructura crítica (AWS, Azure, GCP)
  Tier 2: Procesamiento de datos (Stripe, Salesforce)
  Tier 3: Herramientas internas (Slack, Jira)
```

## Preguntas Frecuentes del Auditor

```yaml
Security:
  - ¿Cómo gestionan el acceso privilegiado?
  - ¿Tienen MFA en todos los sistemas críticos?
  - ¿Con qué frecuencia hacen pentesting?

Availability:
  - ¿Cuál es el RTO y RPO acordado?
  - ¿Tienen pruebas de DR documentadas?
  - ¿Qué métricas de uptime monitorizan?

Processing Integrity:
  - ¿Cómo verifican que los datos no se corrompen?
  - ¿Tienen reconciliaciones automáticas?

Confidentiality:
  - ¿Cómo clasifican los datos?
  - ¿Usan cifrado en reposo y tránsito?

Privacy:
  - ¿Tienen políticas de retención?
  - ¿Cómo gestionan el consentimiento?
```

## Herramientas de Cumplimiento SOC 2

| Herramienta | Uso |
|-------------|-----|
| Drata | Automatización SOC 2 continua |
| Vanta | Monitoreo de controles automatizado |
| Secureframe | Compliance-as-code |
| Laika | Gestión de evidencias y auditorías |
| AWS Artifact | Descargar SOC reports de AWS |
| Wiz | Postura de seguridad cloud |

## Referencias

- [AICPA SOC 2 Overview](https://www.aicpa.org/interestareas/frc/assuranceadvisoryservices/soc2.html)
- [SOC 2 Trust Services Criteria](https://www.aicpa.org/content/dam/aicpa/interestareas/frc/assuranceadvisoryservices/downloadabledocuments/trust-services-criteria.pdf)
- [SSAE No. 18](https://www.aicpa.org/interestareas/frc/assuranceadvisoryservices/downloadabledocuments/ssae-18.pdf)
- [Drata SOC 2 Guide](https://drata.com/soc-2)
- [Vanta SOC 2](https://www.vanta.com/soc-2)
