# Incident Management — Gestión de Incidentes

## Conceptos Fundamentales

La gestión de incidentes es el proceso de detectar, responder, mitigar y aprender de eventos que interrumpen o degradan un servicio. Su objetivo es restaurar el servicio lo antes posible y prevenir recurrencias.

### Ciclo de Vida de un Incidente

```
Detect → Triage → Respond → Mitigate → Resolve → Review
```

## Severidad de Incidentes

| Nivel | Descripción | SLA Respuesta | Ejemplo |
|-------|-------------|---------------|---------|
| **SEV-0** | Caída total del servicio | 5 min | Todos los servicios inaccesibles |
| **SEV-1** | Degradación mayor | 15 min | Módulo de pagos caído |
| **SEV-2** | Problema parcial | 1 hora | Error en feature no crítico |
| **SEV-3** | Problema menor | 24 horas | Bug visual sin impacto funcional |
| **SEV-4** | Cosmético / mejora | Siguiente sprint | Typo en UI |

## Canales de Comunicación

```yaml
# incident-response.yaml
channels:
  primary:
    type: slack
    channel: "#incidents"
    webhook: https://hooks.slack.com/services/...

  backup:
    type: pagerduty
    escalation_policy: "SRE Team"
    notification:
      - email: sre@example.com
      - sms: "+1234567890"

status_page:
  provider: statuspage.io
  page_id: abc123
  api_key: ${STATUSPAGE_API_KEY}
```

## Postmortem Template

```markdown
# Postmortem: Incidente #2024-06-15

## Detalles
- **Fecha**: 2024-06-15 14:30 UTC
- **Duración**: 38 minutos
- **Impacto**: 15% de usuarios afectados, 2.3K errores 502
- **Severidad**: SEV-1

## Timeline
| Hora | Evento |
|------|--------|
| 14:30 | Alerta de error rate > 5% |
| 14:32 | IC asignado, canal #incident-20240615 |
| 14:35 | Diagnóstico: DB connection pool agotado |
| 14:38 | Escalado de conexiones DB (100→300) |
| 14:42 | Error rate se estabiliza |
| 15:08 | Monitoreo confirma servicio normal |

## Causa Raíz
Timeout de conexión en PgBouncer (`server_idle_timeout = 600s`) causó acumulación de conexiones idle.

## Acciones Correctivas
- [ ] **P1**: Reducir `server_idle_timeout` a 60s
- [ ] **P1**: Alerta cuando conexiones activas > 80%
- [ ] **P2**: Load test con picos de tráfico
- [ ] **P3**: Automatizar escalado de pool de conexiones

## Lecciones Aprendidas
- El runbook de DB pool no estaba actualizado
- La alerta de conexiones no cubría el umbral correcto
- Buen tiempo de respuesta del equipo (5 min a diagnóstico)
```

## Best Practices

1. **Blameless culture**: Los incidentes son oportunidades de mejora del sistema, no para buscar culpables.
2. **IC claro**: Una única persona coordina el incidente (Incident Commander). Los demás siguen sus instrucciones.
3. **Canal dedicado**: Crear un canal de Slack/Discord por incidente para no contaminar canales generales.
4. **Documentar en tiempo real**: El Scribe documenta el timeline mientras ocurre el incidente.
5. **Comunicación a stakeholders**: El Comms Lead actualiza a usuarios afectados y management periódicamente.
6. **Postmortem sin excepción**: Todo incidente SEV-0/1 requiere postmortem en las siguientes 48 horas.
7. **Acciones correctivas trackeadas**: Cada postmortem genera tickets accionables con dueño y deadline.
8. **Game days**: Simular incidentes periódicamente para entrenar al equipo y validar runbooks.
