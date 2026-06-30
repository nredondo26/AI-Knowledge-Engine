# 008-Networking: Redes

## Descripción del dominio

Las redes de computadoras son la infraestructura que permite la comunicación entre dispositivos, servidores y servicios a través de protocolos estandarizados. Este módulo abarca desde los fundamentos del modelo TCP/IP, DNS, HTTP/1.1 a HTTP/3 (QUIC), balanceo de carga, proxies, redes cloud/VPC, redes en contenedores (CNI, Service Mesh), seguridad de red (firewalls, TLS, VPN) y monitoreo de red. Es un dominio transversal que impacta todos los aspectos de la ingeniería de software moderna.

## Conceptos clave

- **Modelo OSI vs TCP/IP**: Capas física, enlace, red, transporte, sesión, presentación, aplicación (OSI) vs modelo simplificado TCP/IP de 4 capas
- **TCP vs UDP**: Orientado a conexión vs no orientado; three-way handshake (SYN, SYN-ACK, ACK); control de congestión (slow start, congestion avoidance, fast retransmit); ventana deslizante; checksum
- **HTTP/1.1, HTTP/2, HTTP/3 (QUIC)**: HTTP/1.1 (keep-alive, pipelining), HTTP/2 (multiplexing, server push, HPACK header compression, binary framing), HTTP/3 sobre QUIC (UDP-based, 0-RTT, conexión multipath, mejor rendimiento en pérdida de paquetes)
- **DNS**: Sistema jerárquico (root, TLD, authoritative), registros (A, AAAA, CNAME, MX, TXT, NS, SOA, SRV), DNSSEC, resolución recursiva vs iterativa, DNS over HTTPS/TLS (DoH/DoT), EDNS, geolocation-based routing
- **Balanceo de carga**: Layer 4 (TCP/UDP) vs Layer 7 (HTTP/HTTPS/gRPC); algoritmos (round-robin, least connections, IP hash, consistent hashing, random con sticky sessions); health checks (active vs passive); slow start
- **Proxies**: Forward proxy (cliente), reverse proxy (servidor — nginx, HAProxy, Envoy, Traefik, Caddy); proxy vs gateway vs tunnel; transparente vs explícito
- **CDN (Content Delivery Network)**: CloudFront, Cloudflare, Akamai, Fastly, Azure CDN — edge caching, DDoS mitigation, origin shield, WAF, SSL termination
- **VPN y túneles**: IPsec (IKEv2, ESP, AH), WireGuard (moderno, simple, rápido), OpenVPN, site-to-site vs remote access; tunneling (GRE, VXLAN, Geneve)
- **SDN (Software-Defined Networking)**: Separación del plano de control y datos; OpenFlow, eBPF/XDP para programación de red
- **Redes en cloud**: VPC, subnets, NACLs (stateless), security groups (stateful), Internet Gateway, NAT Gateway, Transit Gateway, VPC Peering, VPC Endpoints, PrivateLink
- **Redes en Kubernetes**: CNI (Container Network Interface), Service (ClusterIP, NodePort, LoadBalancer), kube-proxy (iptables, IPVS), Ingress, Gateway API, NetworkPolicy, Cilium/eBPF, Service Mesh
- **gRPC y HTTP/2**: Protocolo RPC de alto rendimiento basado en HTTP/2, protobuf (Protocol Buffers), streaming bidireccional, multiplexing
- **WebSockets y SSE**: WebSocket (full-duplex sobre TCP, ws:// y wss://), Server-Sent Events (unidireccional, text/event-stream), polling vs long polling

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Balanceadores | nginx, HAProxy, Envoy, Traefik, AWS ALB/NLB, GCP HTTP(S) LB, Azure Load Balancer |
| Proxies reversos | nginx, Caddy, Apache httpd, Envoy, Traefik, Kong (API Gateway), Ambassador |
| CDN | Cloudflare, AWS CloudFront, Fastly, Akamai, Azure CDN, Google Cloud CDN |
| DNS | BIND, CoreDNS, Unbound, Route 53, Cloud DNS, Azure DNS, PowerDNS |
| Observabilidad | Wireshark, tcpdump, iperf3, mtr, traceroute, netstat, ss, nmap, tcpflow, mitmproxy |
| Service Mesh | Istio, Linkerd, Consul, Cilium, Kuma, Envoy como sidecar proxy |
| CNI | Calico, Cilium, Flannel, Weave Net, Antrea |
| VPN | WireGuard, OpenVPN, Tailscale (basado en WireGuard), StrongSwan (IPsec) |
| Firewall | iptables/nftables (Linux), pf (BSD), Windows Defender Firewall, AWS NACL/Security Groups |

## Hoja de ruta

1. **Principiante**: Modelo TCP/IP — direcciones IP (IPv4, IPv6, CIDR, subnets, máscaras) — puertos — TCP vs UDP — http (curl, wget) — DNS básico — herramientas (ping, traceroute, netstat, nmap)
2. **Intermedio**: HTTP/1.1 y HTTP/2 (headers, métodos, códigos de estado, cookies, CORS) — TLS/SSL (handshake, certificados) — proxy inverso (nginx o Caddy) — Wireshark y análisis de tráfico — firewalls (iptables básico, security groups)
3. **Avanzado**: HTTP/3/QUIC — gRPC — WebSockets — balanceo de carga avanzado (Envoy, HAProxy) — VPCs cloud (multi-AZ, peering, VPN) — redes K8s (CNI, Service, Ingress, NetworkPolicy) — eBPF/XDP — DoH/DoT
4. **Experto**: Protocolos de enrutamiento (BGP, OSPF) — SDN — Service Mesh (Istio con mTLS, AuthorizationPolicy) — tuning TCP (buffer sizes, congestion control — BBR, Cubic) — contribución a proyectos CNI — packet processing (DPDK, AF_XDP, XDP) — arquitecturas de red a escala ((Google Jupiter, Facebook Fabric)

## Relaciones con otros módulos

- [004-OperatingSystems](../004-OperatingSystems/) — TCP/IP stack del kernel, netfilter, eBPF, socket programming (syscalls)
- [005-Cloud](../005-Cloud/) — VPC, Route 53, CloudFront, ALB/NLB, Transit Gateway, PrivateLink
- [006-Containers](../006-Containers/) — Redes Docker (bridge, overlay, macvlan), port mapping, docker network
- [007-Orchestration](../007-Orchestration/) — CNI, Service Mesh, Ingress/Gateway API, CoreDNS, NetworkPolicy, Cilium
- [009-Security](../009-Security/) — TLS/SSL, firewalls, WAF, DDoS mitigation (CloudFront, Cloudflare), mTLS, IP whitelisting
- [026-Web](../026-WEB/) — HTTP/1.1, HTTP/2, WebSockets, SSE, CORS, cookies, Service Workers
- [097-Observability](../097-Observability/) — Network metrics, tracing (OpenTelemetry), packet capture

## Recursos recomendados

- **Libros**: "Computer Networking: A Top-Down Approach" (Kurose, Ross); "TCP/IP Illustrated" (Stevens); "HTTP: The Definitive Guide" (Gourley, Totty); "High Performance Browser Networking" (Grigorik)
- **Práctica**: TryHackMe: Network Fundamentals, Cisco Packet Tracer, GNS3 (simulación de redes)
- **Herramientas**: Wireshark (análisis de paquetes), curl + jq (API debugging), mkcert (certificados locales), ngrok (túneles públicos)
- **RFCs clave**: RFC 791 (IP), RFC 793 (TCP), RFC 768 (UDP), RFC 1034/1035 (DNS), RFC 7540 (HTTP/2), RFC 9000 (QUIC/HTTP/3)
