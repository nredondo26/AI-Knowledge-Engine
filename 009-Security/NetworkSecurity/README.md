# NetworkSecurity — Seguridad en Redes

## Conceptos Fundamentales

La seguridad de redes abarca las políticas, tecnologías y prácticas para proteger la integridad, confidencialidad y disponibilidad de los datos en tránsito. Incluye firewalls, sistemas de detección/prevención de intrusiones (IDS/IPS), VPNs, segmentación de red y mitigación de DDoS.

### Principios Clave

- **Defense in depth**: Múltiples capas de defensa (firewall, IDS/IPS, cifrado, segmentación).
- **Least privilege**: Cada recurso solo tiene acceso a lo mínimo necesario.
- **Zero Trust**: No confiar en ninguna fuente sin verificación explícita.
- **Network segmentation**: Aislar cargas de trabajo críticas en subredes separadas.

## Firewall con iptables/nftables

### Reglas básicas en nftables

```bash
#!/bin/bash
# nftables firewall para servidor web
nft flush ruleset

nft add table inet filter
nft add chain inet filter input   { type filter hook input   priority 0 \; }
nft add chain inet filter forward { type filter hook forward priority 0 \; }
nft add chain inet filter output  { type filter hook output  priority 0 \; }

# Política por defecto: DROP en input
nft add rule inet filter input drop

# Permitir tráfico loopback
nft add rule inet filter input iif lo accept

# Permitir conexiones establecidas/relacionadas
nft add rule inet filter input ct state established,related accept

# Permitir SSH, HTTP, HTTPS
nft add rule inet filter input tcp dport {22,80,443} ct state new accept

# Rate limiting para SSH
nft add rule inet filter input tcp dport 22 \
    meter ssh-limit { ip saddr limit rate 5/minute } accept

# Logging de paquetes descartados
nft add rule inet filter input log prefix "DROP: " drop
```

## IDS/IPS con Suricata

### Configuración básica de Suricata

```yaml
# /etc/suricata/suricata.yaml
vars:
  address-groups:
    HOME_NET: "[192.168.1.0/24,10.0.0.0/8]"
    EXTERNAL_NET: "!$HOME_NET"

rule-files:
  - botcc.rules
  - ciarmy.rules
  - compromised.rules
  - emerging-threats.rules
  
af-packet:
  - interface: eth0
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
    tpacket-v3: yes

alert-action: syslog
```

### Regla Suricata personalizada

```
# Detectar SMBv1 (EternalBlue)
alert tcp $HOME_NET any -> $EXTERNAL_NET 445 \
    (msg:"ET EXPLOIT MS17-010 SMBv1 Trans2 Request"; \
     flow:to_server,established; \
     content:"|00 00 00 31|ff|53 4d 42|"; \
     byte_test:1,<,128,4,relative; \
     reference:cve,2017-0144; \
     classtype:attempted-admin; \
     sid:1000001; rev:1;)
```

## VPN con WireGuard

### Configuración servidor

```ini
# /etc/wireguard/wg0.conf (servidor)
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = <server_private_key>
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = <client_public_key>
AllowedIPs = 10.0.0.2/32
```

### Configuración cliente

```ini
# /etc/wireguard/wg0.conf (cliente)
[Interface]
PrivateKey = <client_private_key>
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = <server_public_key>
Endpoint = vpn.ejemplo.com:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
```

## DDoS Mitigation con Cloudflare

### Reglas de rate limiting

```http
# Cloudflare WAF Rule (expresivo)
(http.request.uri.path contains "/api/login"
 and http.request.method eq "POST"
 and ip.geoip.country eq "RU")
```

```
# Rate limiting rule
requests: 100
timeframe: 60 seconds
action: block
condition: (http.request.uri.path contains "/api")
```

## Segmentación de Red con AWS Security Groups

```hcl
# AWS Security Group para aplicación en capas
resource "aws_security_group" "alb" {
  name = "alb-sg"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name = "app-sg"
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
}

resource "aws_security_group" "db" {
  name = "db-sg"
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }
}
```

## Tecnologías Principales

| Herramienta | Propósito |
|-------------|-----------|
| iptables/nftables | Firewall de red en Linux |
| Suricata/Snort | IDS/IPS (detección/prevención) |
| WireGuard | VPN moderna, rápida y segura |
| OpenVPN | VPN tradicional con amplio soporte |
| Cloudflare WAF | WAF + DDoS mitigation en edge |
| AWS Shield | Protección DDoS a nivel de infraestructura |
| ModSecurity | WAF open source (OWASP CRS) |

## Relaciones

- [Cryptography](../Cryptography/) — TLS/SSL, cifrado de tráfico VPN
- [CloudSecurity](../CloudSecurity/) — Security Groups, WAF, DDoS Shield
- [ZeroTrust](../ZeroTrust/) — Microsegmentación, BeyondCorp, IAP
- [008-Networking](../../008-Networking/) — Conceptos base de redes

## Recursos Recomendados

- Suricata Documentation — suricata.io
- WireGuard Docs — wireguard.com
- OWASP Network Security Cheat Sheet
- "Network Security Assessment" — Chris McNab
- NIST SP 800-41 — Guía de Firewalls
- Cloudflare Learning Center — DDoS, WAF, DNS security
