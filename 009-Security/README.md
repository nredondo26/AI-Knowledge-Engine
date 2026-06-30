# 009-Security: Seguridad

## Descripción del dominio

La seguridad informática (ciberseguridad) abarca las prácticas, tecnologías y procesos diseñados para proteger sistemas, redes, datos y aplicaciones de accesos no autorizados, ataques, daños o riesgos. Este módulo cubre seguridad a nivel de aplicación web (OWASP Top 10), criptografía, autenticación y autorización (OAuth 2.0, OpenID Connect, SAML, SSO), seguridad en infraestructura (firewalls, IDS/IPS, SIEM), Zero Trust, seguridad en la nube (IAM, KMS, WAF, Shield), gestión de identidades, DevSecOps, cumplimiento normativo (GDPR, HIPAA, PCI-DSS, SOC 2) y seguridad en contenedores/Kubernetes.

## Conceptos clave

- **OWASP Top 10 2021**: Broken Access Control, Cryptographic Failures, Injection (SQL, NoSQL, OS, LDAP), Insecure Design, Security Misconfiguration, Vulnerable & Outdated Components, Identification & Authentication Failures, Software & Data Integrity Failures, Security Logging & Monitoring Failures, SSRF (Server-Side Request Forgery)
- **Criptografía simétrica**: AES (AES-128, AES-256, modos GCM, CBC, CTR), ChaCha20, 3DES (obsoleto); cifrado de flujo vs bloque; IV/nonce
- **Criptografía asimétrica (PKI)**: RSA (2048/4096 bits), ECC (Curva Elíptica — ECDSA, Ed25519), Diffie-Hellman (DH, ECDH) para intercambio de claves; TLS/SSL handshake
- **Hashing y HMAC**: SHA-2 (256/512), SHA-3, BLAKE2, bcrypt/scrypt/argon2 (para contraseñas), PBKDF2; HMAC para integridad con clave
- **Autenticación**: Factores (algo que sabes, tienes, eres); MFA/2FA (TOTP, HOTP, SMS, push, U2F/FIDO2/WebAuthn, passkeys); Single Sign-On (SSO)
- **Autorización**: OAuth 2.0 (flujos: authorization code, PKCE, client credentials, implicit), OpenID Connect (OIDC), SAML 2.0; RBAC (Role-Based), ABAC (Attribute-Based), ReBAC (Relationship-Based)
- **Zero Trust**: NIST SP 800-207 — nunca confiar, siempre verificar; microsegmentación, beyondcorp/identity-aware proxy, policy enforcement point (PEP), continuous verification
- **Seguridad en APIs**: Rate limiting, API keys, JWT (JSON Web Tokens), OAuth 2.0 scopes, input validation, Content-Type validation, CORS hardening
- **Seguridad en la nube**: IAM policies (least privilege), KMS (Key Management Service), Secrets Manager, WAF, Shield (DDoS), GuardDuty (threat detection), CloudTrail (audit), Security Hub (posture management)
- **Seguridad en contenedores/K8s**: PodSecurityStandards, NetworkPolicies, seccomp, AppArmor, SELinux, Falco (runtime security), Trivy (vulnerabilidades), OPA/Gatekeeper (policy as code), Kyverno, pod security context, user namespaces
- **DevSecOps**: Security as Code — SAST (SonarQube, Semgrep, Checkmarx), DAST (OWASP ZAP, Burp Suite), SCA (Snyk, Dependabot, Trivy, Syft), secret scanning (git-secrets, truffleHog, Gitleaks), container scanning
- **Cumplimiento y normativas**: GDPR (protección de datos, derecho al olvido, consentimiento), HIPAA (datos de salud), PCI-DSS (datos de tarjetas de crédito), SOC 2 (controles de seguridad), ISO 27001/27002 (SGSI), NIST CSF, CMMC
- **Seguridad en redes**: Firewalls (iptables/nftables, cloud security groups/NACL), IDS/IPS (Snort, Suricata), VPN (WireGuard, IPsec, OpenVPN), DDoS mitigation (Cloudflare, AWS Shield), WAF (ModSecurity, AWS WAF, Cloudflare WAF)

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Secretos y PKI | HashiCorp Vault, AWS KMS, Azure Key Vault, GCP Cloud KMS, cert-manager, Let's Encrypt, Step CA |
| IAM | AWS IAM, Azure AD / Entra ID, GCP IAM, Keycloak, Authentik, Okta, Auth0 |
| WAF | AWS WAF, Cloudflare WAF, ModSecurity (Coraza, libmodsecurity), Azure WAF |
| Escáneres | Trivy, Grype, Snyk, Dependabot, SonarQube, Semgrep, Checkov (IaC), Terrascan |
| Runtime security | Falco, Tracee, Falco Talon, Tetragon (Cilium/eBPF) |
| SIEM | Wazuh, ELK Stack (Elasticsearch + Logstash + Kibana), Splunk, Chronicle, Sentinel (Azure) |
| Pentesting | Burp Suite, OWASP ZAP, Metasploit, Nmap, sqlmap, Hydra, John the Ripper, Hashcat |

## Hoja de ruta

1. **Principiante**: Conceptos de seguridad — autenticación vs autorización — contraseñas seguras y hashing — HTTPS/TLS — OWASP Top 10 (cada vulnerabilidad, entender y mitigar) — CORS, CSP, XSS, SQL injection
2. **Intermedio**: OAuth 2.0 y OIDC (flujos, tokens, scopes) — JWT (estructura, validación, refresh tokens) — API security (rate limiting, input validation, API keys) — seguridad en contenedores (Trivy, Dockerfile best practices) — SAST (Semgrep, SonarQube) — TLS/SSL hardening
3. **Avanzado**: Zero Trust architecture — Seguridad en K8s (PodSecurityStandards, NetworkPolicies, Falco, OPA) — DAST (OWASP ZAP automation) — SCA (SBOM, dependencias) — DevSecOps pipeline (security gates, shift left) — cloud security posture management — secrets management (Vault)
4. **Experto**: Criptografía avanzada (curvas elípticas, cifrado homomórfico, ZKP) — exploit development — threat modeling (STRIDE, PASTA, Attack trees) — security architecture review — purple teaming — compliance automation (SOC 2, PCI-DSS, ISO 27001) — investigación de vulnerabilidades 0-day

## Relaciones con otros módulos

- [000-Core](../000-Core/) — Algoritmos criptográficos, hashing, complejidad de ataque (birthday attack, brute force)
- [001-Languages](../001-Languages/) — Bibliotecas criptográficas (cryptography, PyNaCl, ring, crypto/rsa, Java JCA/JCE)
- [002-Frameworks](../002-Frameworks/) — Middleware de autenticación/autorización (Spring Security, Django Guardian, Passport.js)
- [003-Databases](../003-Databases/) — Cifrado en reposo (TDE, pgcrypto), RBAC en DB, inyección SQL, SSL connections, Secrets Manager
- [004-OperatingSystems](../004-OperatingSystems/) — SELinux, AppArmor, seccomp, kernel hardening, Firewalls (iptables/nftables)
- [005-Cloud](../005-Cloud/) — IAM, KMS, WAF, Shield, GuardDuty, Security Hub, CloudTrail, Shared Responsibility Model
- [006-Containers](../006-Containers/) — Rootless containers, capabilities, seccomp, signing, scanning
- [007-Orchestration](../007-Orchestration/) — PodSecurityStandards, NetworkPolicies, RBAC, Falco, OPA, Kyverno, cert-manager
- [008-Networking](../008-Networking/) — TLS/mTLS, firewalls, WAF, VPN, DDoS, network segmentation, Zero Trust
- [053-Compliance](../053-Compliance/) — GDPR, HIPAA, PCI-DSS, SOC 2, ISO 27001, NIST CSF

## Recursos recomendados

- **OWASP**: owasp.org (OWASP Top 10, ASVS, Cheat Sheet Series, OWASP ZAP, Web Security Testing Guide)
- **Libros**: "The Web Application Hacker's Handbook" (Stuttard, Pinto); "Practical Cryptography" (Ferguson, Schneier); "Zero Trust Networks" (Gilman, Barth); "Hacking: The Art of Exploitation" (Erickson)
- **Plataformas**: TryHackMe, HackTheBox, PortSwigger Web Security Academy (Burp Suite, labs gratuitos)
- **Cursos**: Stanford CS255 (Cryptography), Coursera Cryptography I/II (Boneh), SANS training
- **Certificaciones**: CompTIA Security+, Certified Ethical Hacker (CEH), OSCP (Offensive Security), CISSP, AWS Security Specialty
