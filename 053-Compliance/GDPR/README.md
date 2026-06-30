# GDPR — Reglamento General de Protección de Datos

## Visión General

El GDPR (General Data Protection Regulation / RGPD) es el reglamento europeo (UE 2016/679) que regula el tratamiento de datos personales de ciudadanos de la Unión Europea. Se aplica desde el 25 de mayo de 2018.

## Ámbito de Aplicación

```
GDPR se aplica si:
┌─────────────────────────────────────────────────────┐
│ Establecimiento en UE  →  Todas las actividades      │
│                        →  Independientemente de      │
│                           dónde se procesen datos    │
├─────────────────────────────────────────────────────┤
│ Fuera de UE            →  Ofrece bienes/servicios    │
│                           a residentes UE            │
│                        →  Monitoriza su              │
│                           comportamiento             │
└─────────────────────────────────────────────────────┘
```

## Principios Fundamentales (Art. 5)

| Principio | Descripción |
|-----------|-------------|
| **Licitud, lealtad, transparencia** | Procesar datos de forma legal, justa y transparente |
| **Limitación de la finalidad** | Recoger datos con fines determinados, explícitos y legítimos |
| **Minimización de datos** | Solo datos adecuados, pertinentes y limitados |
| **Exactitud** | Datos exactos y actualizados |
| **Limitación del plazo de conservación** | Conservar solo el tiempo necesario |
| **Integridad y confidencialidad** | Seguridad adecuada contra accesos no autorizados |
| **Responsabilidad proactiva** | Demostrar cumplimiento (accountability) |

## Bases Legales para el Tratamiento (Art. 6)

```yaml
Consentimiento:
  - Afirmativo, específico, informado e inequívoco
  - Revocable en cualquier momento
  - No puede ser condición para un servicio

Ejecución de un contrato:
  - Necesario para cumplir un contrato con el interesado

Obligación legal:
  - Requerido por ley (ej. datos fiscales)

Interés vital:
  - Proteger la vida del interesado

Interés público:
  - Misión de interés público o ejercicio de poderes públicos

Interés legítimo:
  - Interés del responsable sin prevalecer sobre derechos del interesado
```

## Derechos del Interesado (Art. 12-23)

```
Derechos ARCO+:
  Acceso        → Saber qué datos se procesan y cómo
  Rectificación → Corregir datos inexactos
  Cancelación   → Suprimir datos (derecho al olvido)
  Oposición     → Oponerse al tratamiento

Derechos adicionales GDPR:
  Limitación del tratamiento
  Portabilidad de datos (Art. 20)
  No ser objeto de decisiones automatizadas (Art. 22)
```

### Procedimiento para Atender Solicitudes

```python
class GDPRRequestHandler:
    def __init__(self, db_connection):
        self.db = db_connection

    def handle_subject_request(self, user_id, request_type):
        """
        Maneja solicitudes de derechos ARCO+
        """
        if request_type == "ACCESS":
            return self._get_user_data(user_id)
        elif request_type == "DELETION":
            self._anonymize_user_data(user_id)
            return {"status": "deleted"}
        elif request_type == "PORTABILITY":
            data = self._get_user_data(user_id)
            return {"format": "json", "data": data}
        elif request_type == "RESTRICTION":
            self._restrict_processing(user_id)
            return {"status": "restricted"}

    def _get_user_data(self, user_id):
        return self.db.query("""
            SELECT personal_data, processing_purpose, retention_period
            FROM data_subjects
            WHERE user_id = ?
        """, (user_id,))

    def _anonymize_user_data(self, user_id):
        self.db.execute("""
            UPDATE data_subjects
            SET personal_data = NULL,
                anonymized_at = CURRENT_TIMESTAMP,
                retention_until = NULL
            WHERE user_id = ?
        """, (user_id,))

    def _restrict_processing(self, user_id):
        self.db.execute("""
            UPDATE data_subjects
            SET processing_restricted = 1
            WHERE user_id = ?
        """, (user_id,))
```

## Data Protection Officer (DPO)

```
Obligación de designar DPO cuando:
  - Autoridad u organismo público
  - Observación sistemática a gran escala de interesados
  - Tratamiento a gran escala de categorías especiales de datos
    (salud, religión, orientación sexual, datos biométricos, etc.)
```

## Evaluación de Impacto (DPIA — Art. 35)

Obligatoria cuando el tratamiento presente un alto riesgo para los derechos de las personas:

```yaml
Criterios de alto riesgo:
  - Evaluación automatizada con efectos jurídicos
  - Categorías especiales de datos a gran escala
  - Vigilancia sistemática de zonas de acceso público
  - Datos de personas vulnerables (menores, empleados)
  - Nuevas tecnologías

Contenido de la DPIA:
  - Descripción sistemática del tratamiento
  - Evaluaciión de necesidad y proporcionalidad
  - Evaluación de riesgos
  - Medidas previstas para mitigar riesgos
```

## Violaciones de Seguridad (Art. 33-34)

```python
import datetime
from dataclasses import dataclass

@dataclass
class DataBreach:
    id: str
    detected_at: datetime.datetime
    category: str  # confidentiality, integrity, availability
    data_types: list
    affected_individuals: int
    risk_level: str  # low, medium, high

class DataBreachNotifier:
    def __init__(self, dpa_contact, breach_db):
        self.dpa = dpa_contact
        self.db = breach_db

    def handle_breach(self, breach: DataBreach):
        self.db.insert_breach(breach)

        if breach.risk_level in ("high", "medium"):
            self._notify_dpa(breach)

        if breach.risk_level == "high":
            self._notify_individuals(breach)

    def _notify_dpa(self, breach):
        report = {
            "nature_of_breach": breach.category,
            "data_types": breach.data_types,
            "individuals_affected": breach.affected_individuals,
            "consequences": self._assess_consequences(breach),
            "measures_taken": self._get_mitigation_measures(breach),
        }
        # Enviar dentro de 72 horas
        self.dpa.send_notification(report)

    def _notify_individuals(self, breach):
        # Comunicar sin dilación indebida
        pass

    def _assess_consequences(self, breach):
        return {
            "loss_of_control": True,
            "discrimination_risk": breach.data_types.get("sensitive", False),
            "financial_loss": self._estimate_financial_risk(breach),
        }
```

## Medidas Técnicas Recomendadas

```yaml
Cifrado:
  - AES-256 para datos en reposo (bases de datos, backups)
  - TLS 1.3 para datos en tránsito
  - Pseudonimización donde sea posible

Control de acceso:
  - RBAC con mínimo privilegio
  - MFA obligatorio para acceso a datos personales
  - Auditoría de accesos (logs inmutables)

Data Retention:
  - Políticas automáticas de borrado
  - Anonimización de datos históricos
  - Backup con cifrado y rotación

Incident Response:
  - Equipo de respuesta a incidentes (CSIRT)
  - Playbook documentado para violaciones
  - Pruebas periódicas de detección
```

## Ejemplo: Configuración de Retención en Base de Datos

```sql
-- Política de retención por tipo de dato
CREATE TABLE data_retention_policies (
    data_category    VARCHAR(50) PRIMARY KEY,
    retention_days   INTEGER NOT NULL,
    action           VARCHAR(20) DEFAULT 'DELETE',
    legal_basis      VARCHAR(100)
);

INSERT INTO data_retention_policies VALUES
    ('PERSONAL_ID', 365,  'DELETE',    'Contract execution'),
    ('FINANCIAL',   2555, 'ARCHIVE',   'Legal obligation'),
    ('MARKETING',   730,  'DELETE',    'Consent'),
    ('SUPPORT_TICKET', 1095, 'DELETE', 'Legitimate interest');

-- Job diario de limpieza
CREATE OR REPLACE FUNCTION apply_retention_policy()
RETURNS void AS $$
BEGIN
    DELETE FROM personal_data pd
    USING data_retention_policies drp
    WHERE pd.category = drp.data_category
      AND pd.stored_at < NOW() - (drp.retention_days || ' days')::INTERVAL
      AND drp.action = 'DELETE';
END;
$$ LANGUAGE plpgsql;
```

## Data Processing Agreement (DPA)

```yaml
Cláusulas esenciales de un DPA:
  - Objeto y duración del tratamiento
  - Naturaleza y finalidad del tratamiento
  - Tipo de datos personales y categorías de interesados
  - Obligaciones y derechos del responsable
  - Subencargados autorizados (lista actualizable)
  - Medidas técnicas y organizativas
  - Notificación de violaciones
  - Auditorías y compliance reports
  - Ley aplicable y jurisdicción
```

## Sanciones (Art. 83)

```
Escala de multas administrativas:
  Menor gravedad:  hasta 10M EUR o 2% del
                     volumen de negocio anual global

  Mayor gravedad:  hasta 20M EUR o 4% del
                     volumen de negocio anual global
```

## Transferencias Internacionales (Art. 44-49)

```
Mecanismos para transferir datos fuera de la UE:
  ┌─────────────────────────────────────┐
  │ Adecuación          → País con nivel │
  │ (Art. 45)              adecuado     │
  ├─────────────────────────────────────┤
  │ Cláusulas           → SCCs (nuevas  │
  │ Contractuales         2021)         │
  │ (Art. 46)                           │
  ├─────────────────────────────────────┤
  │ Normas Corporativas → BCRs          │
  │ Vinculantes                          │
  │ (Art. 47)                           │
  ├─────────────────────────────────────┤
  │ Excepciones        → Consentimiento │
  │ (Art. 49)            explícito,     │
  │                      necesario      │
  │                      contractual    │
  └─────────────────────────────────────┘
```

## Herramientas de Cumplimiento

| Herramienta | Propósito |
|-------------|-----------|
| OneTrust | Plataforma de privacidad (DPIA, consent, DSR) |
| BigID | Discovery y clasificación de datos |
| DataGrail | Gestión de solicitudes de derechos |
| SecurePrivacy | Assessment y documentación |
| Ethyca | Infraestructura de privacidad (open-source) |

## Referencias

- [GDPR Full Text (EUR-Lex)](https://eur-lex.europa.eu/eli/reg/2016/679/oj)
- [AEPD (Agencia Española Protección Datos)](https://www.aepd.es/)
- [EDPB Guidelines](https://edpb.europa.eu/)
- [ICO Guide to GDPR](https://ico.org.uk/for-organisations/guide-to-data-protection/)
- [CNIL GDPR](https://www.cnil.fr/en/reglementation-europeenne-protection-des-donnees)
