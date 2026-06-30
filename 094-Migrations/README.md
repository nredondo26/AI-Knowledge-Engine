# 094-Migrations — Migraciones Técnicas

## Descripción del dominio

Directorio que cubre estrategias, metodologías y casos prácticos de migraciones técnicas. Incluye migraciones de base de datos (schema, datos, proveedor), migraciones a la nube (lift-and-shift, re-platforming, re-architecting), migraciones de lenguaje/framework, refactoring de sistemas legacy, cambio de proveedor de servicios y estrategias de transición con mínimo downtime. Cada entrada documenta el antes, el proceso paso a paso, los riesgos y las lecciones aprendidas.

## Conceptos clave

- **Lift-and-shift**: Migrar una aplicación on-premise a la nube sin modificar su arquitectura
- **Re-platforming** (lift-tinker-shape): Migrar con optimizaciones mínimas (ej. RDS en vez de DB auto-gestionada)
- **Re-architecting** (re-factor): Rediseñar la aplicación para aprovechar nube nativa (microservicios, serverless)
- **Strangler Fig Pattern**: Reemplazar gradualmente funcionalidades del sistema legacy hasta su extinción
- **Blue-Green Deployment**: Dos entornos idénticos (azul = viejo, verde = nuevo) con conmutación instantánea
- **Rolling Migration**: Actualización progresiva por lotes para evitar downtime completo
- **Canary Release**: Migrar primero a un pequeño subconjunto de usuarios para validar
- **Schema migration**: Cambios en estructura de base de datos con control de versiones (Flyway, Liquibase, Alembic)
- **Data migration**: Transformación y traslado de datos entre sistemas con validación de integridad
- **ETL/ELT**: Extract, Transform, Load vs Extract, Load, Transform — patrones de migración de datos
- **Backfill**: Población retroactiva de datos en el nuevo sistema desde el origen
- **Rollback plan**: Estrategia para revertir la migración si algo sale mal
- **Cutover**: Momento exacto de la transición del sistema viejo al nuevo
- **Parallel run**: Ambos sistemas operando simultáneamente para validar equivalencia
- **Idempotencia**: Propiedad que permite re-ejecutar la migración sin efectos secundarios

## Tecnologías principales

| Tipo de migración | Herramientas y plataformas |
|---|---|
| **Bases de datos relacionales** | Flyway, Liquibase, Alembic (Python), Sqitch, Prisma Migrate, DBMate |
| **Bases de datos NoSQL** | MongoDB Atlas Live Migration, DynamoDB Import/Export, Cassandra SSTable |
| **Cloud — AWS** | AWS DMS (Database Migration Service), AWS MGN (Application Migration Service), CloudEndure, AWS Migration Hub |
| **Cloud — Azure** | Azure Migrate, Azure Database Migration Service, Azure Site Recovery |
| **Cloud — GCP** | Migrate for Compute Engine, Database Migration Service, Transfer Appliance |
| **Contenedores** | Docker registry migration, containerd migration, image conversion (skopeo), Helm chart migration |
| **Orquestación** | kube-migrate, velero (backup/migrate), cluster-api, Karbon, Rancher |
| **Lenguajes/frameworks** | 2to3 (Python 2→3), ts-migrate (JS→TS), j2cl (Java→Closure), Go rewrites, Kotlin→Java interop |
| **Infraestructura como código** | Terraform state migration, Terragrunt, Pulumi import, CDK migrate, ConfigCraft |
| **Almacenamiento/archivos** | rsync, rclone, AWS DataSync, Azure File Sync, GCP Transfer Service, Storage Transfer |
| **CI/CD** | Jenkins→GitHub Actions, GitLab CI, CircleCI migration, Drone CI |
| **Legado mainframe** | Micro Focus Enterprise Suite, AWS Mainframe Modernization, BluAge, Astadia, TmaxSoft OpenFrame |
| **ERP/CRM** | SAP S/4HANA migration, Salesforce to HubSpot, Oracle EBS to NetSuite |
| **Mensajería/streaming** | RabbitMQ→Kafka, Kafka→Pulsar, ActiveMQ→Amazon MQ, Kinesis→Pub/Sub |
| **Search** | Elasticsearch version migration, Solr to Elasticsearch, AWS CloudSearch→Elasticsearch Service |

## Hoja de ruta

### Principiante
1. **Schema migrations básicas** — PL/SQL, Flyway, Alembic para cambios incrementales
2. **Git migration** — Migrar de SVN/CVS a Git con `git-svn`
3. **Paquetería** — Migrar de pip a poetry/uv, npm a pnpm/yarn, Maven a Gradle
4. **Lenguaje** — Python 2→3 con `2to3`, JavaScript→TypeScript básico
5. **CI/CD simple** — Migrar de Jenkins declarativo a GitHub Actions

### Intermedio
1. **Lift-and-shift a cloud** — Migrar VM on-premise a EC2/GCE/VM con AWS MGN
2. **Base de datos a cloud** — Migrar PostgreSQL/MySQL on-premise a RDS/Cloud SQL con DMS
3. **Migración de contenedores** — Migrar de Docker Swarm a Kubernetes, registry migration
4. **Refactoring progresivo** — Strangler Fig Pattern para monolith→microservicios
5. **Blue-Green deployment** — Configurar pipelines con entornos paralelos y switch de tráfico
6. **ETL de datos** — Migrar data warehouse on-premise a Snowflake/Redshift/BigQuery

### Avanzado
1. **Migración multi-cloud** — Estrategia híbrida entre AWS-Azure-GCP con failover
2. **Re-architecting cloud-native** — De monolith on-premise a serverless/microservicios en nube
3. **Migración de mainframe** — De COBOL/CICS a Java/Node.js con emulación y refactor
4. **Zero-downtime migration** — Estrategias de corte sin ventana de mantenimiento
5. **Consistencia de datos en migración** — Verificación checksum, reconciliación, shadow reads
6. **Migración de mensajería** — RabbitMQ→Kafka con mirroring y re-procesamiento

### Experto
1. **Migración de sistemas financieros** — Core bancario legacy a moderno, transaccionalidad, compliance
2. **Migración de datos PB-scale** — Transfer Appliance, Snowmobile, Direct Connect, sharding
3. **Migración de identidades/IAM** — Federación, SAML/OIDC, SCIM, migración de directorio activo
4. **Migración regulatoria** — GDPR data residency, SOC2, PCI-DSS, HIPAA zone migration
5. **Chaos migration testing** — Validar migración con fallos inyectados (network partition, data corruption)
6. **Automated migration verification** — Property-based testing, differential testing, golden files

## Relaciones con otros módulos

- `../003-Databases/` — Migraciones de schema y datos específicas por DB
- `../005-Cloud/` — Migraciones a AWS, Azure, GCP con herramientas nativas
- `../006-Containers/` — Migración de imágenes, registries, Dockerfiles
- `../007-Orchestration/` — Migración entre clústeres y plataformas K8s
- `../010-Architecture/` — Patrones arquitectónicos para migraciones (strangler fig, event storming)
- `../013-DevOps/` — Estrategias DevOps para migraciones con mínimo downtime
- `../014-CICD/` — Pipelines de migración automatizados
- `../046-BestPractices/` — Buenas prácticas para planificar migraciones
- `../053-Compliance/` — Requisitos regulatorios durante migraciones
- `../095-Performance/` — Benchmarks pre/post migración para validar mejora

## Recursos recomendados

- [AWS Migration Hub](https://aws.amazon.com/migration-hub/) — Centro de migraciones AWS
- [Azure Migrate](https://azure.microsoft.com/products/azure-migrate) — Herramientas de migración Azure
- [Google Cloud Migration](https://cloud.google.com/migration) — Guías de migración GCP
- [Flyway Documentation](https://flywaydb.org/documentation/) — Migraciones de base de datos
- [Liquibase](https://www.liquibase.com) — Gestión de cambios en DB con control de versiones
- [Strangler Fig Application](https://martinfowler.com/bliki/StranglerFigApplication.html) — Patrón de Fowler
- [12 Factor App](https://12factor.net) — Principios para apps modernas post-migración
- [Cloud Adoption Framework](https://aws.amazon.com/what-is/cloud-adoption-framework/) — Estrategia de adopción cloud
