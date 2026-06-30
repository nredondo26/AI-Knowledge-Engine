# Zero Trust — Arquitectura de Confianza Cero

## Conceptos Fundamentales

Zero Trust es un modelo de seguridad que elimina la confianza implícita en cualquier entidad dentro o fuera de la red. Se basa en el principio **"never trust, always verify"** (nunca confíes, verifica siempre). NIST SP 800-207 define la arquitectura Zero Trust (ZTA).

### Principios Clave

- **Verificar explícitamente**: Toda solicitud debe ser autenticada y autorizada, independientemente de su origen.
- **Acceso con mínimo privilegio**: Conceder solo los permisos necesarios usando JIT (Just-In-Time) y JEA (Just-Enough-Access).
- **Asumir brecha**: Diseñar asumiendo que la red ya está comprometida. Microsegmentar todo.
- **Monitoreo continuo**: Validar confianza en cada acceso, no solo al inicio de sesión.

## Pilares de Zero Trust

```
                    ┌─────────────────────────┐
                    │   Control de Identidad   │
                    │  (SSO, MFA, dispositivos)│
                    └──────────┬──────────────┘
                               │
              ┌────────────────┼────────────────┐
              ▼                ▼                ▼
     ┌─────────────┐  ┌──────────────┐  ┌──────────────┐
     │ Dispositivos │  │   Red /      │  │   Datos /    │
     │ (Endpoint) │  │ Microsegment.│  │ Cifrado      │
     └─────────────┘  └──────────────┘  └──────────────┘
              │                │                │
              └────────────────┼────────────────┘
                               ▼
                    ┌─────────────────────────┐
                    │    Monitoreo Continuo    │
                    │  (UEBA, SIEM, SOAR)      │
                    └─────────────────────────┘
```

## Implementación con BeyondCorp (Google)

BeyondCorp es la implementación de Zero Trust de Google que elimina la VPN corporativa.

### Arquitectura

```
                    ┌──────────────┐
  Usuario ──────►   │  Identity-   │ ────► Aplicación
                    │  Aware Proxy │
                    │  (IAP)       │
                    └──────────────┘
                        │
                        ▼
               ┌──────────────────┐
               │ Policy Engine    │
               │ (Contexto: user, │
               │  device, loc,   │
               │  sensitivity)   │
               └──────────────────┘
```

### Google Cloud IAP (Identity-Aware Proxy)

```hcl
# Terraform: Habilitar IAP para App Engine
resource "google_iap_app_engine_service_iam_binding" "binding" {
  project = var.project_id
  app_id  = google_app_engine_standard_app_version.app.service
  service = google_app_engine_standard_app_version.app.service
  role    = "roles/iap.httpsResourceAccessor"
  members = [
    "user:admin@ejemplo.com",
    "group:developers@ejemplo.com",
  ]
}

# NEG (Network Endpoint Group) para acceso interno
resource "google_compute_region_network_endpoint_group" "neg" {
  name                  = "app-neg"
  region                = "us-central1"
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = google_cloud_run_service.app.name
  }
}
```

## Microsegmentación con Kubernetes NetworkPolicies

```yaml
# NetworkPolicy: solo frontend puede llamar a backend
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-allow-frontend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
---
# Denegar todo el tráfico entrante por defecto
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

## Policy Enforcement Point (PEP) con OPA

```rego
package zerotrust

# Política de acceso basada en contexto
default allow = false

allow {
    input.request.method == "GET"
    input.user.authenticated == true
    input.device.managed == true
    input.device.compliant == true
    input.location.country in ["US", "ES", "MX"]
    input.risk_score <= 0.3
}

# Acceso JIT: solo en horario laboral
allow {
    input.request.method == "POST"
    input.user.role == "admin"
    input.time.hour >= 9
    input.time.hour <= 18
    input.request.reason == "emergency"
    input.approval.justification != ""
}
```

## Continuous Verification con Falco (Runtime)

```yaml
# Regla Falco: detectar shell en contenedor
- rule: Shell in Container
  desc: Se detectó una shell interactiva en un contenedor
  condition: >
    spawned_process
    and container.id != ""
    and proc.name in (bash, sh, zsh, dash)
    and not proc.pname in (docker, kubectl)
  output: >
    Shell in container (user=%user.name
    container=%container.name
    cmdline=%proc.cmdline)
  priority: WARNING
  tags: [container, shell, mitre_execution]
```

## Tecnologías Principales

| Componente | Herramientas |
|------------|--------------|
| IAP / Proxy | Google IAP, Cloudflare Access, Zscaler, Okta |
| Microsegmentación | Calico, Cilium, VMware NSX, Illumio |
| Device Trust | FleetDM, Kolide, Jamf, Intune |
| Policy Engine | OPA, Kyverno, HashiCorp Sentinel |
| Continuous Auth | BeyondCorp API, Tailscale, Pomerium |
| Runtime Security | Falco, Tracee, Tetragon |
| Secrets | Vault, conjur, AWS Secrets Manager |

## Relaciones

- [Authentication](../Authentication/) — MFA, SSO, device trust como base de Zero Trust
- [Authorization](../Authorization/) — Políticas de acceso con OPA, RBAC/ABAC
- [NetworkSecurity](../NetworkSecurity/) — Microsegmentación, firewalls distribuidos
- [CloudSecurity](../CloudSecurity/) — IAP, IAM conditions, VPC Service Controls
- [SIEM](../SIEM/) — Correlación de eventos de verificación continua

## Recursos Recomendados

- NIST SP 800-207: Zero Trust Architecture
- "Zero Trust Networks" — Gilman & Barth (O'Reilly)
- Google BeyondCorp whitepapers — research.google/pubs
- Cloudflare Zero Trust docs — developers.cloudflare.com
- Cilium Network Policies docs — docs.cilium.io
- Tailscale.com — Zero Trust networking simplificado
