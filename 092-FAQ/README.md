# 092-FAQ — Preguntas Frecuentes

## Descripción del dominio

Directorio que centraliza preguntas frecuentes (FAQ) organizadas por dominio tecnológico. Cada FAQ responde de forma clara y concisa a dudas recurrentes, desmiente mitos comunes, aclara conceptos confusos y proporciona respuestas basadas en documentación oficial y experiencia práctica. Funciona como primera línea de resolución de dudas antes de escalar a troubleshooting profundo.

## Conceptos clave

- **FAQ** (Frequently Asked Questions): Lista estructurada de preguntas recurrentes con respuestas
- **Mito vs Realidad**: Corrección de creencias erróneas comunes en tecnología
- **Concepto confuso**: Aclaración de términos que suelen malinterpretarse (ej. commit vs push, scale-up vs scale-out)
- **Pregunta trampa**: Concepto que parece trivial pero tiene aristas técnicas importantes
- **Respuesta canónica**: Explicación autorizada basada en fuentes oficiales
- **TL;DR**: Versión de una línea de la respuesta para consulta rápida
- **Caso de borde**: Escenario específico donde la respuesta general no aplica
- **Referencia cruzada**: Enlace a documentación detallada dentro del repositorio
- **Benchmark anecdótico**: Comparación empírica basada en experiencia de uso real
- **Gotcha**: Detalle contra-intuitivo que causa errores frecuentes

## Tecnologías principales

| Dominio | Temas FAQ cubiertos |
|---|---|
| **Git** | Merge vs rebase, detached HEAD, force push, submodules, undo commits |
| **Docker** | Diferencia image/container, entrypoint vs cmd, volúmenes vs bind mounts, multi-stage |
| **Kubernetes** | Pod vs deployment vs statefulset, services vs ingress, probes, RBAC, namespaces |
| **Cloud** | AWS vs Azure vs GCP, costos, regiones vs zonas, VPC peering, landing zones |
| **Linux** | Diferencia bash/zsh/fish, hard link vs symlink, swap vs zram, systemd vs init |
| **Python** | pip vs conda, pyenv vs virtualenv, GIL, typing, async vs threading |
| **Bases de datos** | SQL vs NoSQL, ACID vs BASE, index types, sharding vs partitioning, read replicas |
| **IA/ML** | Supervised vs unsupervised vs RL, overfitting vs underfitting, fine-tuning vs RAG |
| **Seguridad** | HTTPS vs SSL/TLS, OAuth vs SAML, WAF vs firewall, HSM vs KMS |
| **Redes** | TCP vs UDP, IPv4 vs IPv6, DNS propagation, CORS, CDN vs edge computing |
| **Testing** | Unit vs integration vs e2e, mock vs stub vs fake, TDD vs BDD |
| **Arquitectura** | Monolith vs microservices, sync vs async, REST vs GraphQL vs gRPC, SOA vs EDA |

## Hoja de ruta

### Principiante
1. **Git FAQ** — ¿Cuál es la diferencia entre merge y rebase? ¿Cómo deshacer un commit?
2. **Linux FAQ** — ¿Diferencia entre soft link y hard link? ¿Qué es sudo? ¿Cómo funcionan los permisos?
3. **Python FAQ** — ¿Por qué usar virtualenv? ¿Qué es `__init__.py`? ¿Cómo funciona `if __name__ == '__main__'`?
4. **Web FAQ** — ¿Qué es CORS? ¿Diferencia entre cookies y localStorage? ¿Qué es un CDN?
5. **Docker FAQ** — ¿Cuál es la diferencia entre image y container? ¿Qué hace `docker compose`?

### Intermedio
1. **Kubernetes FAQ** — ¿Pod vs Deployment vs StatefulSet? ¿Cómo funcionan los probes? ¿Qué es RBAC?
2. **Cloud FAQ** — ¿AWS vs Azure vs GCP para qué caso? ¿Cómo optimizar costos? ¿Qué es una VPC?
3. **SQL vs NoSQL FAQ** — ¿Cuándo usar cada uno? ¿Qué es ACID? ¿Qué es CAP theorem?
4. **ML FAQ** — ¿Overfitting vs underfitting? ¿Qué métrica usar para clasificación? ¿Cómo elegir modelo?
5. **Seguridad FAQ** — ¿HTTPS es suficiente? ¿Qué es OWASP Top 10? ¿Cómo almacenar contraseñas?

### Avanzado
1. **Arquitectura FAQ** — ¿Microservicios o monolith primero? ¿Event-driven vs request-driven?
2. **Rendimiento FAQ** — ¿Cómo identificar cuellos de botella? ¿Caching en varias capas? ¿Connection pooling?
3. **DevOps FAQ** — ¿GitOps vs CI/CD tradicional? ¿Infraestructura inmutable vs mutable?
4. **Testing FAQ** — ¿Qué cubrir en unit vs integration? ¿Cómo testear async code? ¿Flaky tests?
5. **LLM FAQ** — ¿Fine-tuning vs RAG? ¿Qué es temperature? ¿Cómo evitar hallucinations?

### Experto
1. **Sistemas distribuidos FAQ** — ¿Consistencia eventual vs fuerte? ¿Raft vs Paxos? ¿Sagas?
2. **Database internals FAQ** — ¿MVCC? ¿LSM-tree vs B-tree? ¿Write-ahead logging? ¿Isolation levels?
3. **Kernel FAQ** — ¿Context switch? ¿System call overhead? ¿Interrupts vs polling?
4. **Compilers FAQ** — ¿JIT vs AOT? ¿IR? ¿SSA? ¿Garbage collection algorithms?
5. **Teoría de la computación FAQ** — ¿P vs NP? ¿Decidibilidad? ¿Lambda calculus? ¿Turing completeness?

## Relaciones con otros módulos

- `../047-Troubleshooting/` — Solución detallada de problemas específicos
- `../093-CommonErrors/` — Errores frecuentes con stack traces y soluciones
- `../056-Glossary/` — Definiciones de términos técnicos
- `../046-BestPractices/` — Buenas prácticas que responden FAQ implícitas
- `../048-Certifications/` — FAQ sobre certificación, examenes, renovación
- `../049-InterviewQuestions/` — Preguntas de entrevista que amplían las FAQ
- `../057-Taxonomy/` — Clasificación jerárquica de conceptos
- `../052-Standards/` — Estándares que generan preguntas frecuentes
- `../053-Compliance/` — FAQ sobre regulaciones (GDPR, SOC2, HIPAA)
- `../050-LearningPaths/` — Rutas que responden "¿por dónde empiezo?"

## Recursos recomendados

- [Stack Overflow](https://stackoverflow.com) — Comunidad de preguntas y respuestas técnicas
- [ExplainShell](https://explainshell.com) — Explicación de comandos bash
- [Let's Encrypt FAQ](https://letsencrypt.org/docs/faq/) — FAQ sobre certificados SSL/TLS
- [Kubernetes FAQ](https://kubernetes.io/docs/reference/faq/) — FAQ oficial de K8s
- [OWASP FAQ](https://owasp.org/about/) — Preguntas frecuentes sobre seguridad web
- [Docker FAQ](https://docs.docker.com/engine/faq/) — FAQ oficial de Docker
- [Git FAQ](https://git-scm.com/docs/gitfaq) — FAQ oficial de Git
- [AWS FAQ](https://aws.amazon.com/faqs/) — FAQ oficial por servicio de AWS
