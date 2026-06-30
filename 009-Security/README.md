# 009-Security: Seguridad Informática

## Descripción ampliada del dominio

La seguridad informática protege sistemas, redes y datos contra amenazas internas y externas mediante controles técnicos, organizativos y legales. Este módulo cubre seguridad ofensiva y defensiva, criptografía, seguridad en aplicaciones, redes, cloud, identidad, cumplimiento normativo y mejores prácticas. El panorama de amenazas evoluciona constantemente: desde virus y gusanos clásicos (1980s-90s), pasando por malware avanzado (Stuxnet, 2010), ransomware moderno (WannaCry, 2017; Colonial Pipeline, 2021), ataques a la cadena de suministro (SolarWinds, 2020; Log4j, 2021), hasta APT (Advanced Persistent Threats) patrocinados por estados. Las tendencias actuales incluyen Zero Trust Architecture ("never trust, always verify"), SASE (Secure Access Service Edge), SSE (Security Service Edge), XDR (Extended Detection and Response), SOAR (Security Orchestration Automation and Response), y Security as Code (Policy as Code). La ciberseguridad es un campo multidisciplinario que combina tecnología, procesos y personas. El marco NIST Cybersecurity Framework (CSF) y ISO 27001 son los estándares de referencia para programas de seguridad empresarial.

## Tabla de conceptos clave

| Concepto | Descripción | Ejemplos/Estándares |
|----------|-------------|---------------------|
| Criptografía simétrica | Misma clave para cifrar y descifrar | AES (256), ChaCha20, 3DES (obsoleto) |
| Criptografía asimétrica | Par de claves pública y privada | RSA (2048-4096), ECC (P-256, P-384), Ed25519 |
| Hashing | Función unidireccional para integridad | SHA-256, SHA-3, BLAKE2, bcrypt, argon2 |
| PKI | Infraestructura de clave pública: certificados X.509 | Let's Encrypt, Entrust, DigiCert, mTLS |
| Autenticación | Verificación de identidad | Passwords, MFA, WebAuthn/FIDO2, SSO/SAML/OIDC |
| Autorización (ABAC/RBAC) | Control de acceso basado en atributos/roles | AWS IAM, Azure RBAC, OPA, Casbin |
| OWASP Top 10 | Principales riesgos en aplicaciones web | Injection, XSS, Broken Auth, SSRF, XXE |
| Network Security | Protección de perímetro de red | Firewalls, IDS/IPS, NAC, VPN, WAF, DDoS |
| Seguridad en la nube | Protección de infraestructura cloud | CSPM, CWPP, CIEM, CASB, SASE |
| DevSecOps | Seguridad integrada en el pipeline CI/CD | SAST, DAST, SCA, secrets scanning, IaC scanning |
| SIEM | Gestión de eventos e información de seguridad | Splunk, Sentinel, Elastic Security, QRadar |
| SOAR | Orquestación, automatización y respuesta | Palo Alto XSOAR, Splunk SOAR, Tines |
| Threat Intelligence | Información contextual sobre amenazas | MITRE ATT&CK, STIX/TAXII, OpenCTI |

## Tecnologías principales

| Categoría | Herramientas | Propósito |
|-----------|-------------|-----------|
| SAST (Static Analysis) | SonarQube, Checkmarx, Fortify, Semgrep, CodeQL | Análisis de seguridad en código fuente |
| DAST (Dynamic Analysis) | OWASP ZAP, Burp Suite, Acunetix | Análisis de seguridad en aplicaciones en ejecución |
| SCA (Software Composition) | Snyk, Dependabot, Trivy, OWASP Dependency-Check | Vulnerabilidades en dependencias |
| Secrets Scanning | GitGuardian, truffleHog, Gitleaks, detect-secrets | Detección de credenciales expuestas |
| IaC Scanning | Checkov, tfsec, Terrascan, KICS | Seguridad en infraestructura como código |
| Container Security | Trivy, Grype, Clair, Anchore, Docker Scout | Vulnerabilidades en imágenes |
| WAF (Web App Firewall) | Cloudflare WAF, AWS WAF, ModSecurity, Coraza | Protección de aplicaciones web |
| Endpoint Security | CrowdStrike, SentinelOne, Defender, osquery | Protección de endpoints |
| EDR/XDR | CrowdStrike, SentinelOne, Palo Alto Cortex, Microsoft 365 Defender | Detección y respuesta en endpoints |
| Identity/Access | Okta, Azure AD, Auth0, Keycloak, Ory | Gestión de identidades y acceso |
| Cloud Security | AWS Security Hub, Azure Defender, GCP SCC | Seguridad cloud unificada |
| Vulnerability Management | Tenable, Qualys, Rapid7, OpenVAS | Gestión de vulnerabilidades |
| SIEM | Splunk, Sentinel, Elastic, QRadar, Wazuh | Correlación de eventos de seguridad |
| Secrets Management | HashiCorp Vault, AWS Secrets Manager, CyberArk | Gestión de secretos |
| PKI/Certificates | cert-manager, Smallstep, EJBCA, Let's Encrypt | Gestión de certificados |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: CIA (Confidencialidad, Integridad, Disponibilidad), AAA (Autenticación, Autorización, Accounting), non-repudiation. Criptografía básica: cifrado simétrico (AES) vs asimétrico (RSA), hashing (SHA-256), firmas digitales, certificados X.509, TLS/SSL (handshake, cipher suites, HSTS). OWASP Top 10: entender cada vulnerabilidad (Injection, XSS, Broken Authentication, Sensitive Data Exposure, XXE, Broken Access Control, Security Misconfiguration, Insecure Deserialization, Components with Known Vulnerabilities, Insufficient Logging). Autenticación: passwords (hashing con bcrypt/argon2), MFA, OAuth 2.0 básico, JWT (estructura, firma, mejores prácticas). Seguridad en redes: firewalls básicos (iptables/nftables), TLS/HTTPS, VPN (WireGuard). Herramientas básicas: nmap (escaneo de puertos), Wireshark (análisis de tráfico), OpenSSL (certificados), curl.
   - Práctica: Configurar HTTPS con Let's Encrypt en un servidor web. Implementar autenticación JWT en API. Escaneo básico con nmap.
   - Certificación: CompTIA Security+, ISC2 CC, o Google Cybersecurity Certificate.

2. **Intermedio (3-8 meses)**: Seguridad en aplicaciones web: SQL injection (prevención con prepared statements, ORM, WAF), XSS (reflected, stored, DOM-based — Content-Security-Policy, input sanitization), CSRF (tokens, SameSite cookies), SSRF, XXE, IDOR, path traversal, Log4j/LFI, RCE. OWASP ASVS (Application Security Verification Standard). API security: API keys, OAuth 2.0 + OpenID Connect en profundidad (grant types: authorization code, PKCE, client credentials, implicit — deprecated), rate limiting, API gateways (Kong, Apigee, Tyk), JWT validation, API key rotation. DevSecOps: SAST en CI/CD (Semgrep, CodeQL), dependency scanning (Dependabot, Renovate, Snyk), secrets detection (GitGuardian, pre-commit hooks), IaC scanning (Checkov, tfsec), container scanning (Trivy). Security Headers: CSP, HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy, CORS. Seguridad en la nube: IAM (least privilege, roles, policies), S3 bucket policies (block public access), security groups, NACLs, KMS (customer managed keys, envelope encryption), CloudTrail (logging), AWS Config (compliance), secrets management (AWS Secrets Manager, Parameter Store). Autenticación MFA: TOTP, WebAuthn/FIDO2 (passkeys, hardware tokens, biometrics).
   - Práctica: SAST + SCA + DAST pipeline en GitHub Actions. Configurar IAM y seguridad de red en AWS/GCP. Implementar OAuth 2.0 + OIDC.
   - Certificación: CompTIA CySA+, GIAC GSEC, AWS Security Specialty, Azure Security Engineer (AZ-500).

3. **Avanzado (8-14 meses)**: Zero Trust Architecture (ZTA): microsegmentación, identity-aware proxy (BeyondCorp, Tailscale), device trust, continuous verification, least privilege, NIST SP 800-207. Seguridad en Kubernetes: Pod Security Standards, OPA/Gatekeeper, Kyverno policies, seccomp/AppArmor profiles, image signing (Cosign), network policies (Cilium eBPF), runtime security (Falco), Kubernetes CIS benchmark, CKS exam topics. Cryptography avanzado: ECC (Curve25519, P-256), Ed25519, post-quantum cryptography (Kyber, Dilithium), TLS 1.3 (0-RTT, PSK), end-to-end encryption (Signal Protocol, MLS), key derivation (HKDF, PBKDF2, argon2), AEAD (AES-GCM, ChaCha20-Poly1305). Threat modeling: STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, DoS, Elevation), PASTA, attack trees, threat matrix (MITRE ATT&CK). Security operations: SIEM rule creation (Splunk SPL, KQL, Elastic EQL), incident response (NIST SP 800-61), forensic analysis (Autopsy, Volatility), malware analysis (sandbox, Ghidra, IDA). Offensive security: Metasploit, Burp Suite Professional, SQLMap, BeEF, hydra, hashcat. Reverse engineering: PE/ELF analysis, disassembly (Ghidra, IDA, Binary Ninja), debugging (x64dbg, GDB), packer detection.
   - Práctica: Laboratorio Zero Trust con Tailscale + OPA + Cilium. Writeup de máquina HackTheBox/TryHackMe. Análisis de malware en sandbox.
   - Certificación: OSCP, OSCE, GPEN, GCIH, CKS, AWS Security Professional (SCS-C02).

4. **Experto (14+ meses)**: Advanced persistent threats (APT): detección y respuesta, threat hunting (YARA, Sigma, Zeek). Hardware security: TPM, Secure Enclave, SGX/TDX, SEV-SNP, HSM, TrustZone, secure boot, measured boot, attestation. Supply chain security: SBOM (CycloneDX, SPDX), SLSA (Supply chain Levels for Software Artifacts), in-toto attestations, Sigstore (Cosign, Fulcio, Rekor). Security automation: SOAR workflows, automated incident response, Tines/Splunk SOAR, XDR correlation. Compliance automation: compliance as code, AWS Config rules, Azure Policy, Inspec, compliance frameworks (PCI DSS, HIPAA, SOC 2, FedRAMP, ISO 27001, GDPR, SOX). AI security: adversarial ML, model poisoning, model inversion, data poisoning, prompt injection (OWASP Top 10 for LLMs), jailbreaking, model security (RLHF robustness). Blockchain security: smart contract auditing, formal verification, DeFi exploits. Bug bounty: programa de recompensas (HackerOne, Bugcrowd), disclosure policies, report writing, CVE assignment. Fuzzing: AFL++/libFuzzer, HonggFuzz, OSS-Fuzz, coverage-guided fuzzing. Formal verification: seL4 certification, TLA+, Coq, Isabelle.
   - Práctica: Implementar y verificar seL4 proof. Análisis de smart contract vulnerability. Participar en bug bounty program.
   - Certificación: CISSP, OSCE3, OSED, GXPN, GIAC GSE, CCSK (cloud security).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Algoritmos criptográficos, hashing, complejidad de ataque |
| [001-Languages](../001-Languages/) | Memory safety (Rust), type safety, input validation |
| [002-Frameworks](../002-Frameworks/) | Seguridad en frameworks: CSRF, XSS, auth implícita |
| [003-Databases](../003-Databases/) | SQL injection, cifrado en reposo, RBAC, audit logs |
| [004-OperatingSystems](../004-OperatingSystems/) | SELinux, AppArmor, seccomp, kernel hardening |
| [005-Cloud](../005-Cloud/) | Cloud IAM, KMS, network security, SIEM, compliance |
| [006-Containers](../006-Containers/) | Image scanning, runtime security, seccomp profiles |
| [007-Orchestration](../007-Orchestration/) | Pod security, network policies, RBAC, secrets |
| [008-Networking](../008-Networking/) | Firewalls, VPN, WAF, network segmentation, mTLS |
| [010-Architecture](../010-Architecture/) | Secure architecture, threat modeling, trust boundaries |
| [012-Testing](../012-Testing/) | Security testing (SAST, DAST, pentest, fuzzing) |
| [014-CICD](../014-CICD/) | DevSecOps pipeline, security gates, artifact signing |
| [035-RAG](../035-RAG/) | RAG security: prompt injection, data leakage |
| [037-AgenticAI](../037-AgenticAI/) | AI agent security, tool access control, sandboxing |

## Recursos recomendados

- **Libros**: "The Web Application Hacker's Handbook" (Stuttard, Pinto), "The Tangled Web" (Zalewski), "Practical Malware Analysis" (Sikorski, Honig), "Cryptography Engineering" (Ferguson, Schneier), "Zero Trust Networks" (Gillman, Reichel, Osborn).
- **Cursos**: Cybrary, Pluralsight (Dale Meredith), SANS courses (muy caros, pero Gold Standard), PortSwigger Web Security Academy (gratis), TryHackMe, HackTheBox Academy.
- **Plataformas**: HackTheBox, TryHackMe, PortSwigger Labs, OWASP WebGoat/Juice Shop, PentesterLab, RootMe.
- **Frameworks**: MITRE ATT&CK, OWASP Top 10, NIST Cybersecurity Framework, CIS Controls, OWASP ASVS.
- **Herramientas**: Burp Suite, OWASP ZAP, nmap, Metasploit, Wireshark, Ghidra, Hashcat, John the Ripper, SQLMap.
- **Comunidad**: DEFCON, BlackHat, BSides, OWASP meetups, HackerOne, Bugcrowd, /r/netsec.

## Notas adicionales

La seguridad no es un producto sino un proceso. Se recomienda comenzar con fundamentos (Security+, OWASP Top 10) y luego especializarse en offensive o defensive. El ethical hacking y bug bounty son excelentes formas de práctica. Conocer MITRE ATT&CK es esencial para entender el panorama de amenazas. La demanda de profesionales de seguridad es extremadamente alta. La ética es fundamental: solo pentestear sistemas con autorización explícita.
