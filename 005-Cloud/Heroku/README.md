# Heroku

## Servicios Principales

Heroku es una plataforma cloud PaaS (Platform as a Service) adquirida por Salesforce. Permite desplegar aplicaciones sin gestionar infraestructura subyacente. Soportaba múltiples runtimes: Node.js, Ruby, Python, Java, PHP, Go, Scala, Clojure, y contenedores Docker.

> ⚠️ **Importante**: A partir del 28 de noviembre de 2022, Heroku eliminó su plan gratuito (Free Dynos). Los planes actuales comienzan en $5/mes (Eco) o $7/mes (Basic). Heroku sigue siendo operativo y funcional con sus planes de pago.

| Categoría | Servicios Clave |
|-----------|----------------|
| Cómputo (Dynos) | Web Dynos (servidores web), Worker Dynos (tareas background), One-off Dynos (tareas ad-hoc, migrations, console) |
| Runtimes | Node.js, Ruby on Rails, Python (Django, Flask), Java (Spring Boot), PHP (Laravel), Go, Scala, Clojure, Custom (Docker con heroku.yml) |
| Buildpacks | Buildpacks oficiales (Node, Ruby, Python, Java, PHP, Go, Scala, Clojure), Buildpacks de terceros (apt, ffmpeg, wkhtmltopdf), Buildpacks personalizados |
| Postgres | Heroku Postgres (planes Essential, Standard, Premium, Private/Tokyo) con forking, followers, datalips, point-in-time recovery |
| Redis | Heroku Data for Redis (Mini, Premium, Private, Enterprise) con TLS, HA, persistence |
| Kafka | Heroku Apache Kafka (planes Enterprise) con topics, producers, consumers, Schema Registry |
| Add-ons | Marketplace con 150+ add-ons: SendGrid, Mailgun, New Relic, Papertrail, Logentries, Redis, Postgres, CloudAMQP, Algolia, Meilisearch, Rollbar, Scout, Bugsnag |
| Networking | Heroku Private Spaces (VPC), Heroku Shield (HIPAA, PCI), Trusted IPs, SSL/TLS automático (ACM), Let's Encrypt |
| CI/CD | Heroku Pipelines (review apps, staging, production), Heroku CI, GitHub/GitLab Integration, Auto-deploy from branches |
| Observability | Heroku Metrics (CPU, memory, response time, throughput), Heroku Logs (Logplex, real-time log tail), PaperTrail add-on, Datadog integration, New Relic add-on |
| Features | Review Apps (apps temporales por PR), Release Phase (run tasks before release), Config Vars, Procfile, Environment Variables, Release API, Platform API |

---

## Arquitectura de Dynos

### Tipos de Dynos

| Tipo | CPU | Memoria | Costo | Caso de uso |
|------|-----|---------|-------|-------------|
| Eco | Compartido | 512 MB | $5/mes (2 dynos incluidos) | Apps muy pequeñas, side projects |
| Basic | Compartido | 512 MB | $7/mes | Apps pequeñas, demos, MVPs |
| Standard-1X | Compartido | 512 MB | $25/mes | Aplicaciones en producción con tráfico moderado |
| Standard-2X | Compartido | 1 GB | $50/mes | Apps con más demanda de memoria |
| Performance-M | Dedicado | 2.5 GB | $250/mes | Apps con requisitos de rendimiento |
| Performance-L | Dedicado | 14 GB | $500/mes | Apps de alto tráfico, machine learning |
| Private-M | Dedicado | 2.5 GB | $500/mes (Private Spaces) | Cumplimiento, VPC aislada |
| Private-L | Dedicado | 14 GB | $1000/mes (Private Spaces) | Enterprise, alta seguridad |

### Procfile
Archivo que define los tipos de dynos y sus comandos:
```
web: gunicorn app.wsgi --log-file -
worker: python manage.py consume_tasks
release: python manage.py migrate
clock: python manage.py schedule_jobs
```

- **web**: recibe tráfico HTTP, Heroku asigna un puerto (PORT env var)
- **worker**: procesos background (colas, procesos batch)
- **release**: se ejecuta una vez antes de cada deploy (migraciones, assets)
- **clock**: procesos scheduleados (cron)

```bash
# Crear app
heroku create mi-app-unica

# Desplegar desde Git
git push heroku main

# Escalar dynos
heroku ps:scale web=2 worker=1

# Ver estado de dynos
heroku ps

# Ejecutar proceso one-off (como rails console)
heroku run bash
heroku run "python manage.py createsuperuser"
heroku run "node -e 'console.log(process.env)' "

# Ver logs
heroku logs --tail

# Verificar configuración
heroku config

# Establecer variables de entorno
heroku config:set DATABASE_URL=postgres://...
heroku config:set SECRET_KEY=mi-clave-secreta

# Ver información de la app
heroku info
```

---

## IAM & Access Control

### Roles en Heroku Teams (Enterprise Teams)
- **Member**: puede desplegar, configurar, acceder a recursos compartidos
- **Admin**: todo excepto billing
- **Owner**: control total

### Enterprise Teams
- Equipos multi-usuario con facturación compartida
- **Single Sign-On (SSO)**: SAML (Okta, OneLogin, Azure AD)
- **Two-Factor Auth (2FA)**: requerido para cuentas con tarjeta registrada
- **Audit Log**: registro de cambios y accesos en el dashboard
- **Data Residency**: Private Spaces en regiones específicas (EU, US, APAC)

### Heroku Shield
Capa de seguridad para entidades reguladas:
- **HIPAA**: Protected Health Information (PHI)
- **PCI**: Payment Card Industry compliance
- **ISO 27001, SOC 1, SOC 2, SOC 3**
- **Private Spaces**: VPC aislada, cifrado en reposo (KMS)
- **Shield Private Spaces**: logging cifrado, audit logging avanzado
- **Dynos en Shield**: incluyen cifrado de disco, access control estricto

```bash
# Acceso de colaboradores
heroku access:add user@email.com

# Revocar acceso
heroku access:remove user@email.com

# Ver lista de colaboradores
heroku access

# Transferir app a otro owner
heroku apps:transfer --recipient user@email.com mi-app

# Crear equipo (Enterprise)
heroku teams:create mi-equipo
heroku members:add user@email.com --team mi-equipo --role admin
```

---

## Compute & Deployment

### Git-based Deploy (Git Push)
```bash
# Crear app en Heroku
heroku create mi-app-ejemplo

# Conectar repositorio Git remoto
heroku git:remote -a mi-app-ejemplo

# Desplegar
git push heroku main

# Desplegar branch específica
git push heroku feature-branch:main
```

### Container Registry & Runtime (Docker)
```dockerfile
# Dockerfile
FROM node:20-slim
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
CMD ["node", "server.js"]
```

```yaml
# heroku.yml
build:
  docker:
    web: Dockerfile
run:
  web: node server.js
```

```bash
# Crear app container-based
heroku create mi-app-container --stack container

# Desplegar con container registry
heroku container:login
heroku container:push web
heroku container:release web

# Construir y desplegar
heroku container:push web --app mi-app-container
```

### Buildpacks
Heroku detecta automáticamente el buildpack:
```bash
# Ver buildpacks activos
heroku buildpacks

# Agregar buildpack (orden importa)
heroku buildpacks:add heroku/python
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-apt

# Quitar buildpack
heroku buildpacks:remove heroku/nodejs

# Usar buildpack específico en deploy
heroku create mi-app --buildpack heroku/python
```

### Release Phase
Tareas que se ejecutan ANTES de que el nuevo release reciba tráfico:
```
release: python manage.py migrate
release: npm run build
release: bundle exec rails db:migrate
```

Si falla, el release NO se despliega (rollback automático).

### Review Apps
Apps temporales efímeras por cada pull request:
- **Auto-creación**: al abrir PR, se crea app con su propia DB y recursos
- **Auto-destrucción**: al cerrar/rechazar PR, se elimina app
- **Config Vars**: herencia de producción con overrides
- **Add-ons**: copia de add-ons (o shared add-ons para ahorrar)

### Heroku Pipelines
Flujo CI/CD completo:
```
develop → review app → staging → production
```

```bash
# Crear pipeline
heroku pipelines:create mi-pipeline --app mi-app-staging --stage staging

# Agregar app al pipeline
heroku pipelines:add mi-pipeline --app mi-app-prod --stage production

# Promover de staging a producción
heroku pipelines:promote --app mi-app-staging

# Conectar pipeline a GitHub
heroku pipelines:connect mi-pipeline --github usuario/repo
```

---

## Databases (Heroku Postgres)

Heroku Postgres es el servicio de base de datos más popular de Heroku. Planes:

| Plan | Alta Disponibilidad | Forks | Memoria | Storage | Costo |
|------|-------------------|-------|---------|---------|-------|
| Essential-0 | No | No | Compartido | 1 GB | $5/mes (Eco) |
| Essential-1 | No | Sí | Compartido | 1 GB | $9/mes |
| Essential-2 | No | Sí | Compartido | 4 GB | $30/mes |
| Standard-0 | No | Sí | 4 GB RAM | 64 GB | $50/mes |
| Standard-2 | No | Sí | 8 GB RAM | 256 GB | $200/mes |
| Standard-3 | No | Sí | 15 GB RAM | 512 GB | $400/mes |
| Premium-0 | Sí (sync replica) | Sí | 4 GB RAM | 64 GB | $200/mes |
| Premium-4 | Sí (sync replica) | Sí | 61 GB RAM | 1 TB | $1200/mes |
| Private/Tokyo | Sí | Sí | Personalizado | Personalizado | Custom |

### Características
- **Forking**: clon instantáneo de la base de datos (ideal para staging/testing)
- **Followers**: réplicas de lectura asíncronas (escalar queries de lectura)
- **Dataclips**: queries SQL compartibles via URL (reportes, dashboards)
- **Point-in-time Recovery**: restore a cualquier punto en los últimos N días
- **Credits**: $1 = 1 credit (facturación por hora, solo cuando está provisionado)
- **Connection Pooling**: PgBouncer integrado (plan Standard+)
- **Encryption**: SSL/TLS en tránsito, cifrado en reposo (Premium+)

```bash
# Crear base de datos Postgres
heroku addons:create heroku-postgresql:essential-1

# Ver DATABASE_URL automático
heroku config | grep DATABASE_URL

# Obtener información del Postgres
heroku pg:info

# Ver conexiones activas
heroku pg:connections

# Hacer fork de la DB (para staging)
heroku pg:fork DATABASE_URL --app mi-app-staging

# Crear follower (réplica de lectura)
heroku pg:follow DATABASE_URL --app mi-app-reader

# Ver queries lentas
heroku pg:outliers

# Hacer backup manual
heroku pg:backups:capture

# Descargar backup
heroku pg:backups:download

# Restaurar backup
heroku pg:backups:restore <backup-id> DATABASE_URL --app mi-app

# Ejecutar SQL directo
heroku pg:psql
# > SELECT * FROM users LIMIT 5;

# KILL conexiones
heroku pg:killall

# Hacer dataclip
heroku pg:dataclips:create --app mi-app "SELECT COUNT(*) FROM users"
```

---

## Add-ons

Marketplace de 150+ servicios integrados:

| Categoría | Add-ons Populares |
|-----------|------------------|
| Monitoring | New Relic, Scout, Papertrail, Logentries, Rollbar, Bugsnag, Sentry, AppSignal |
| Email | SendGrid, Mailgun, SparkPost, Postmark |
| Search | Algolia, Meilisearch, Searchify, Elasticsearch (Bonsai, SearchBox) |
| Caching | Redis (Heroku Data for Redis, RedisCloud, RedisGreen) |
| Message Queues | CloudAMQP (RabbitMQ), Heroku Kafka, IronMQ, RabbitMQ Bigwig |
| Performance | CloudFlare, Fastly, MemCachier, CDN |
| Security | Auth0, Okta, SecureNet, Snyk, Sqreen |

```bash
# Listar add-ons disponibles
heroku addons

# Proximal a crear add-on (ej: Redis)
heroku addons:create heroku-redis:mini

# Ver add-ons instalados
heroku addons --all

# Abrir dashboard de un add-on
heroku addons:open heroku-postgresql

# Destruir add-on
heroku addons:destroy heroku-postgresql

# Promocionar add-on (cambiar plan)
heroku addons:upgrade heroku-postgresql:standard-0
```

---

## Networking & Security

### SSL/TLS
- **Heroku SSL (Automated Certificate Management - ACM)**: certificados gratuitos automáticos (Let's Encrypt) para dominios personalizados
- **Manual SSL**: subir certificados propios
- **SSL/TLS Endpoint**: terminación SSL en el borde de Heroku
- **Heroku Shield Endpoint**: terminación SSL en Private Spaces

### Private Spaces
Entorno VPC aislado:
- **Dedicated Network**: IPs privadas, subred dedicada
- **Data Residency**: cumplimiento de localización de datos
- **Trusted IPs**: restringir acceso a rangos IP específicos
- **VPC Peering**: conectar Private Space con VPC de AWS (cliente)
- **Private App**: acceso privado sin exponer IPs públicas

### Custom Domains
```bash
# Agregar dominio personalizado
heroku domains:add midominio.com

# Verificar DNS
heroku domains

# Agregar varios dominios
heroku domains:add midominio.com
heroku domains:add www.midominio.com

# Configurar DNS (apuntar CNAME a <app>.herokudns.com)
# Heroku DNS Target: <app>.herokudns.com (no herokuapp.com)

# SSL automático
heroku certs:auto:enable

# Ver certificado
heroku certs:auto
```

---

## Cost Optimization

- **Eco Plan**: $5/mes por 2 dynos compartidos + Postgres Essential-0 $5/mes — la opción más barata
- **Basic**: $7/mes por dyno, ideal para apps pequeñas
- **Sleeping dynos**: en Eco/Basic, el dyno "duerme" tras 30 min sin tráfico (se reactiva al recibir request)
- **Worker dynos**: solo se escalan cuando hay trabajo en cola
- **Review Apps**: destruir apps de PR al cerrar PR para no gastar
- **Heroku Postgres Essential-0**: solo $5/mes, suficiente para apps pequeñas
- **Add-ons no usados**: eliminar add-ons que no se necesiten
- **Performance dynos**: solo para apps de alto tráfico, usar Standard para moderado

```bash
# Estimar costo mensual
heroku ps

# Ver uso actual de dynos y add-ons
heroku apps:info

# Ver facturación
# Abrir dashboard: https://dashboard.heroku.com/account/billing

# Poner app en mantenimiento (evitar tráfico costoso)
heroku maintenance:on

# Quitar add-on innecesario
heroku addons:destroy sendgrid --confirm mi-app
```

---

## Ejemplos CLI Adicionales

```bash
# Instalar Heroku CLI
# Linux:
curl https://cli-assets.heroku.com/install.sh | sh
# macOS:
brew install heroku
# Windows: descargar installer

# Login
heroku login
heroku login --interactive  # para CI sin browser

# Crear app con stack específico
heroku create mi-app --stack heroku-22
heroku create mi-app --stack container

# Renombrar app
heroku apps:rename nuevo-nombre

# Eliminar app (no reversible)
heroku apps:destroy --app mi-app --confirm mi-app

# Clonar app (config, buildpacks, add-ons)
heroku apps:clone mi-app --new-name mi-app-staging

# Logs multi-line
heroku logs -n 100

# Logs en tiempo real
heroku logs --tail

# Logs de un proceso específico (solo web)
heroku logs --ps web --tail

# Ver métricas detalladas
heroku metrics:web

# Establecer variabless de entorno desde archivo
heroku config:push --file .env.production

# Descargar variables de entorno
heroku config:pull --file .env.local

# Run en un dyno específico
heroku run "python manage.py shell" --size standard-2x

# Run SSH
heroku run bash --app mi-app

# Crear cron job (Con Heroku Scheduler add-on)
heroku addons:create scheduler:standard
heroku addons:open scheduler
# En la UI: agregar tarea "python manage.py daily_report" cada 24h

# Monitorear releases
heroku releases

# Rollback a versión anterior
heroku releases:rollback v42

# Ver features habilitados
heroku features

# Habilitar feature preview
heroku features:enable http-dyno-sleep-timeout

# Configurar git remote existente
heroku git:remote -a mi-app

# Crear app desde un template
heroku create --template https://github.com/heroku/node-js-getting-started

# HTTP caching con Varnish (automático)
# Las apps web tienen caché Varnish integrada (herokuapp.com domain)
# Para usar con dominio personalizado: usar Fastly o CloudFlare como CDN

# Ejemplo de .env para desarrollo local
cat .env
# DATABASE_URL=postgres://localhost:5432/mi-app
# REDIS_URL=redis://localhost:6379
# SECRET_KEY=dev-key-123
# STORAGE_PATH=./uploads
```
