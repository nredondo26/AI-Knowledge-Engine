# 008-Networking: Redes

## Descripción ampliada del dominio

Las redes de computadoras permiten la comunicación entre dispositivos mediante protocolos estandarizados. Este módulo cubre desde los fundamentos (modelo OSI, TCP/IP, direccionamiento) hasta conceptos avanzados (enrutamiento, switching, SDN, redes definidas por software, virtualización de redes, seguridad de red, cloud networking, content delivery). La pila TCP/IP es el estándar universal de comunicación en Internet. La evolución de las redes incluye: redes conmutadas por circuito (telefonía) → conmutación de paquetes (Internet) → ethernet y WiFi → cloud networking (VPC, SDN) → service mesh (Cilium, Istio) → edge networking y 5G. El pipeline de datos desde la aplicación hasta el cable físico involucra múltiples capas de abstracción: aplicación (HTTP, DNS), transporte (TCP, UDP), red (IP), enlace (Ethernet, WiFi) y física (fibra, cobre, ondas). La latencia, throughput, jitter y packet loss son las métricas fundamentales de rendimiento de red. Las tendencias actuales incluyen eBPF para networking programable, zero-trust networking (ZTNA), SASE (Secure Access Service Edge) y redes deterministas para 5G y IoT.

## Tabla de conceptos clave

| Concepto | Descripción | Protocolo/Tecnología | Capa OSI/ TCP/IP |
|----------|-------------|----------------------|------------------|
| Direccionamiento IP | Identificador único de dispositivo en la red | IPv4 (32 bits), IPv6 (128 bits) | Red (3) |
| Enrutamiento | Determinación de la ruta de paquetes entre redes | OSPF, BGP, IS-IS, RIP | Red (3) |
| Switching | Reenvío de tramas dentro de una LAN | Ethernet, VLAN, STP, VXLAN | Enlace (2) |
| TCP | Transporte confiable orientado a conexión | TCP (Reno, NewReno, Cubic, BBR) | Transporte (4) |
| UDP | Transporte no confiable sin conexión | UDP, QUIC | Transporte (4) |
| DNS | Resolución de nombres de dominio a IP | DNS (UDP/53), DNSSEC | Aplicación (7) |
| HTTP/HTTPS | Protocolo de transferencia de hipertexto | HTTP/1.1, HTTP/2, HTTP/3 (QUIC) | Aplicación (7) |
| NAT | Traducción de direcciones IP privadas a públicas | SNAT, DNAT, PAT (masquerading) | Red (3) |
| Firewall | Filtrado de tráfico basado en reglas | iptables, nftables, PF, AWS NACL/SG | Red-Transporte (3-4) |
| VPN | Red privada virtual cifrada sobre red pública | IPsec, WireGuard, OpenVPN, TLS VPN | Red-Aplicación (3-7) |
| Proxy | Intermediario entre cliente y servidor | Squid, HAProxy, Nginx, Envoy | Aplicación (7) |
| Load Balancer | Distribución de tráfico entre múltiples servidores | NLB, ALB, HAProxy, Envoy | Transporte-aplicación (4-7) |
| CDN | Distribución de contenido en servidores geodistribuidos | CloudFront, Akamai, Fastly, Cloudflare | Aplicación (7) |
| SDN | Red definida por software: control desacoplado del hardware | OpenFlow, Cisco ACI, VMware NSX | Todas |
| eBPF | Ejecución de programas sandbox en el kernel para red | Cilium, XDP, TC BPF | Enlace-Red (2-3) |

## Tecnologías principales

| Tecnología | Propósito | Implementaciones | Nivel |
|------------|-----------|------------------|-------|
| Switches | Conmutación de tramas en LAN | Cisco Catalyst, Arista, Juniper EX, MikroTik | Capa 2/3 |
| Routers | Enrutamiento entre redes | Cisco ISR, Juniper MX, Ubiquiti EdgeRouter, VyOS | Capa 3 |
| Firewalls | Filtrado de tráfico y seguridad perimetral | pfSense, Fortinet, Palo Alto, AWS WAF, Cloudflare WAF | Capa 3-7 |
| Load Balancers | Balanceo de carga y alta disponibilidad | HAProxy, Nginx, AWS ALB/NLB, Google LB, F5 | Capa 4-7 |
| DNS | Resolución de nombres | CoreDNS, Bind9, Unbound, AWS Route 53, Cloudflare DNS | Capa 7 |
| CDN | Aceleración de contenido | CloudFront, Cloudflare, Fastly, Akamai, Azure CDN | Capa 7 |
| SDN | Virtualización de redes | Open vSwitch, Cilium, Calico, VMware NSX | Capa 2-3 |
| Service Mesh | Comunicación entre microservicios | Istio, Linkerd, Cilium, Consul Connect | Capa 4-7 |
| VPN | Conexiones cifradas | WireGuard, OpenVPN, Tailscale, AWS VPN | Capa 3-4 |
| Monitorización | Visibilidad de red | Prometheus + blackbox exporter, Zabbix, PRTG, Wireshark | Todas |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: modelo OSI (7 capas), modelo TCP/IP (4-5 capas). Direccionamiento IP: IPv4 (clases, CIDR, subnetting, VLSM), máscaras de red, broadcast/multicast/unicast. IPv6 básico: formato, tipos de direcciones (link-local, global unicast, multicast), diferencias IPv4/IPv6. TCP vs UDP: características (orientado a conexión, confiabilidad, ordenamiento, control de flujo/congestión). Puertos: well-known (0-1023), registered (1024-49151), ephemeral (49152-65535). DNS: cómo funciona, resolución recursiva vs iterativa, tipos de registros (A, AAAA, CNAME, MX, TXT, NS). HTTP: request/response, métodos (GET, POST, PUT, DELETE, PATCH), status codes (1xx, 2xx, 3xx, 4xx, 5xx), headers, cookies, caching. Herramientas: ping, traceroute/tracert, nslookup/dig, curl, telnet, ip/ifconfig, ss/netstat.
   - Práctica: Configurar red local con IP estática/dinámica (DHCP). Capturar y analizar paquetes con Wireshark.
   - Lectura: "Computer Networking: A Top-Down Approach" (Kurose, Ross) — capítulos 1-4.

2. **Intermedio (3-8 meses)**: Ethernet: tramas, MAC addresses, CSMA/CD, full duplex, auto-negociación, VLANs (802.1Q), STP/RSTP/MSTP, link aggregation (LACP). Switching: CAM table, VLAN trunking (trunk/access ports), intervlan routing (router-on-a-stick, L3 switches). ARP: resolución de MAC, gratuito, proxy ARP, ARP spoofing. TCP en profundidad: handshake (SYN, SYN-ACK, ACK), sequence/ack numbers, window scaling, TCP options (MSS, WS, SACK, Timestamp), retransmission (RTO), congestion control (slow start, congestion avoidance, fast retransmit, fast recovery). Algoritmos: TCP Reno, NewReno, Cubic (default Linux), BBR (Google). DHCP: DORA (Discover, Offer, Request, Ack), relay agent, scope, lease. NAT/PAT: sobrecarga de puertos, tipos (static, dynamic, PAT/masquerade). Enrutamiento estático: rutas por defecto, rutas flotantes, ECMP. Firewalling: stateful vs stateless, iptables/nftables (chains, tables, rules), default policies, connection tracking. VPN: site-to-site (IPsec IKEv1/v2, tunnel/transport mode), remote access (WireGuard, OpenVPN).
   - Práctica: Configurar VLANs, STP, enrutamiento inter-VLAN con switch L3 o router. Firewall con iptables/nftables.
   - Lectura: Kurose & Ross capítulos 5-7, "TCP/IP Illustrated" (Stevens, vol 1), Linux networking docs.

3. **Avanzado (8-14 meses)**: Enrutamiento dinámico: OSPF (áreas, LSA types, DR/BDR, SPF algorithm, link-state database), BGP (AS, path vector, iBGP/eBGP, route reflectors, attributes: AS_PATH, MED, LOCAL_PREF, communities, route selection algorithm). MPLS/VPN: LDP, RSVP-TE, VRF, BGP/MPLS IP VPN (RFC 4364). SDN: OpenFlow, P4 (programmable data plane), Open vSwitch, VXLAN (tunnel overlay, VTEP). QoS: DiffServ, CoS (802.1p), ToS/DSCP, traffic shaping, policing, queuing (FIFO, WFQ, CBQ, HTB). HTTP/2 y HTTP/3: multiplexing, server push, HPACK, QUIC (UDP-based, 0-RTT, connection migration). CDN: edge servers, origin pull, cache control, purge, CDN security (WAF, DDoS mitigation). Cloud networking: VPC design, subnets (public/private), security groups, NACLs, routing tables, Internet Gateway, NAT Gateway, Transit Gateway, VPC peering, PrivateLink, AWS Direct Connect/Azure ExpressRoute. IPv6 en profundidad: SLAAC, DHCPv6, neighbor discovery (NDP), tunneling (6to4, Teredo, NAT64/DNS64), transition mechanisms. Network automation: Ansible networking modules, NETCONF/YANG (RFC 6241, 6020), RESTCONF, NAPALM, pyATS.
   - Práctica: Configurar BGP con VyOS/Bird o en lab GNS3/EVE-NG. Desplegar VXLAN overlay. Automatizar config de switches con Ansible.
   - Lectura: "Network Warrior" (Donahue), "BGP" (Halabi), "Routing TCP/IP" (Doyle, vol 1 y 2).

4. **Experto (14+ meses)**: eBPF networking: XDP (expresar packet processing en kernel), TC BPF, Cilium (network policies, service mesh sin sidecar, observability), katran (L4 load balancer), Falco/Tetragon (security). High-performance networking: DPDK (Intel), AF_XDP, io_uring, RDMA/RoCE, InfiniBand. Zero Trust Networking (ZTN): ZTNA (Cloudflare Access, Zscaler, Tailscale, Twingate), BeyondCorp (Google), BeyondProd. SASE: SSE (Security Service Edge), SWG, CASB, DLP. Service Mesh: Istio (Envoy), mTLS, L7 policies, traffic splitting, fault injection, circuit breaking, observabilidad. Data center networking: CLOS fabric (leaf-spine), VXLAN + EVPN (RFC 7432), BGP EVPN Type-2/3/5, VXLAN ECN. Wireless: WiFi 6/6E/7 (802.11ax/be), DFS, MIMO, OFDMA. Optical networking: DWDM, coherent optics, ROADM, OTN. QUIC y HTTP/3 en profundidad: implementación, performance, 0-RTT, connection migration. Network security: DDoS mitigation (Cloudflare, AWS Shield), WAF, bot management, IP reputation, geo-blocking, rate limiting. Benchmarking: iperf3, sockperf, netperf, perf, pktgen, netmap. Network telemetry: sFlow, NetFlow/IPFIX, gNMI, OpenTelemetry.
   - Práctica: Programa eBPF/XDP para DDoS mitigation. Diseñar arquitectura zero-trust (Tailscale/Cloudflare). Contribuir a Cilium o similar.
   - Lectura: "BPF Performance Tools" (Gregg), "Understanding Linux Network Internals" (Benoit), Cilium docs, RFCs, IETF drafts.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Algoritmos de routing, checksums, error detection |
| [004-OperatingSystems](../004-OperatingSystems/) | Network stack del kernel, sockets, syscalls |
| [005-Cloud](../005-Cloud/) | VPC, DNS, CDN, LB, Direct Connect, Cloud networking |
| [006-Containers](../006-Containers/) | CNI, container networking, overlay networks |
| [007-Orchestration](../007-Orchestration/) | Service mesh, Ingress, Network Policies |
| [009-Security](../009-Security/) | Firewalls, WAF, DDoS, VPN, mTLS, IDS/IPS |
| [010-Architecture](../010-Architecture/) | Network topology, arquitectura de sistemas distribuidos |
| [029-IoT](../029-IoT/) | IoT networking (MQTT, LoRaWAN, 6LoWPAN, Zigbee) |
| [031-AI](../031-AI/) | Networking para training distribuido (RDMA, NCCL) |

## Recursos recomendados

- **Libros**: "Computer Networking: A Top-Down Approach" (Kurose, Ross, 8ª ed.), "TCP/IP Illustrated" (Stevens, vol 1), "Network Warrior" (Donahue), "BGP" (Halabi), "Routing TCP/IP" (Doyle), "Computer Networks" (Tanenbaum, Feamster).
- **Cursos**: Coursera "Computer Networking" (Georgia Tech / Kurose), Udemy "GNS3 Labs", INE CCNA/CCNP, Stanford CS144.
- **Práctica**: GNS3, EVE-NG, VirtualBox + VyOS/Cumulus VX, Packet Tracer, Wireshark, iperf3, AWS/Azure free tier.
- **Herramientas**: Wireshark, tcpdump, nmap, netcat, iperf3, mtr, traceroute, dig, curl, HTTPie, mitmproxy, ngrok, tc (traffic control).
- **Certificaciones**: CCNA, CCNP, AWS Advanced Networking, Cilium Certified.
- **Comunidad**: NetworkToCode, ipSpace.net, Reddit /r/networking, /r/netdev.

## Notas adicionales

Las redes son un campo vasto. Se recomienda dominar los fundamentos (CCNA-level) antes de especializarse. Para DevOps/SRE, el networking cloud (VPC, DNS, LB, CDN, Direct Connect) y service mesh son lo más relevante. Para desarrolladores, entender HTTP, DNS, TCP, TLS y API gateway es esencial. El futuro del networking está en eBPF (programable, seguro, observable) y zero-trust architectures. Linux es la plataforma de elección para networking avanzado.
