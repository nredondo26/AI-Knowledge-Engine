# Cloudflare

## Servicios Principales

Cloudflare es una plataforma de red global (Anycast) que ofrece seguridad, rendimiento y servicios de edge computing. Opera una de las redes más grandes del mundo (330+ ciudades, 12,000+ redes interconectadas).

| Categoría | Servicios Clave |
|-----------|----------------|
| CDN y Rendimiento | Cloudflare CDN, Argo Smart Routing, Railgun (optimización dinámica), Mirage (optimización imágenes), Polish, Brotli, Early Hints |
| DNS | Cloudflare DNS (autoritativo, gratuito), DNS Firewall, DNSSEC, NS Record management |
| Seguridad | WAF (Web Application Firewall), DDoS Protection, Bot Management, SSL/TLS, API Shield, Page Shield, Zero Trust (Cloudflare for Teams) |
| Serverless/Edge | Cloudflare Workers, Workers KV, Durable Objects, R2, Queues, D1, Caching API, Images, Stream |
| Red y Balanceo | Load Balancing, Smart Routing, Argo Tunnel (Cloudflare Tunnel), IPVS, Spectrum, Magic Transit, Magic WAN, Network Interconnect |
| Zero Trust | Cloudflare Access, Gateway (SWG), Browser Isolation, CASB, DLP, Remote Browser Isolation (RBI), WARP Client, Device Posture |
| AI/ML | Workers AI (GPU serverless), AI Gateway (proxy para LLMs), Vectorize (vector database), Stream AI |
| Optimización Web | Auto Minify, Rocket Loader, HTTP/2 & HTTP/3, IPv6, AMP Real URL, Signed Exchanges (SXG) |

---

## Red Global (Anycast Network)

Cloudflare opera sobre una arquitectura Anycast: cada servidor edge anuncia las mismas IPs, y el tráfico llega al PoP (Point of Presence) más cercano.

### Cómo funciona el proxy (Orange Cloud)
Cuando el DNS de un dominio apunta a Cloudflare con proxy habilitado (naranja): el tráfico pasa por Cloudflare, que termina TLS lo inspecciona, aplica reglas WAF, DDoS, caching, y lo reenvía al servidor de origen (a través de IPs de Cloudflare, no la IP real del visitante).

### Argo Smart Routing
Enruta tráfico dinámicamente a través de la ruta más rápida en la red de Cloudflare (no la ruta BGP estándar). Ahorra 30-40% en tiempo de descarga en promedio.

### Cloudflare Global Network
- 330+ ciudades en 120+ países
- 12,000+ peers (conexiones directas con ISPs, redes de distribución, hyperscalers)
- 300+ Tbps de capacidad total
- Conexión directa con Google, Amazon, Microsoft, Facebook, Netflix, Apple

```bash
# Curl para ver cabeceras de Cloudflare
curl -I https://ejemplo.com
# CF-Cache-Status: HIT/MISS/DYNAMIC/EXPIRED
# CF-Ray: identificador del PoP que sirvió la request
# Server: cloudflare
```

---

## DNS

### Cloudflare DNS (Autoritativo)
- **Velocidad**: resolución DNS global con Anycast (DNS lookups <10ms promedio mundial)
- **Tipos de registro**: A, AAAA, CNAME, MX, TXT, SRV, CAA, NS, DS, LOC, NAPTR, PTR, SMIMEA, SSHFP, SVCB, HTTPS, URI
- **DNSSEC**: firmado automáticamente con un clic
- **CNAME Flattening**: permite CNAME en root domain (sin necesidad de A record)
- **DNS Firewall**: protección DNS contra DDoS, proxy DNS, filtrado por política
- **Analytics**: tráfico DNS por registro, tipo de query, código de respuesta

### Ejemplos CLI (con API de Cloudflare)
```bash
# Obtener zonas (usando API Token)
curl -X GET "https://api.cloudflare.com/client/v4/zones" \
  -H "Authorization: Bearer MI_TOKEN" \
  -H "Content-Type: application/json" | jq .

# Crear registro DNS
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/dns_records" \
  -H "Authorization: Bearer MI_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"type":"A","name":"www","content":"192.0.2.1","ttl":120,"proxied":true}'

# Listar registros DNS
curl -s "https://api.cloudflare.com/client/v4/zones/ZONE_ID/dns_records?type=A" \
  -H "Authorization: Bearer MI_TOKEN" | jq '.result[] | {name, content, proxied}'
```

---

## Seguridad

### DDoS Protection
Protección integrada en todos los planes:
- **Capa 3/4**: mitigación de ataques volumétricos (UDP flood, SYN flood, NTP amplification, DNS amplification) en el edge — el tráfico malicioso nunca llega al origen
- **Capa 7**: mitigación de HTTP floods con rate limiting, challenge (JS, CAPTCHA), IP reputation
- **Magic Transit**: protección para infraestructura on-premises (BYOIP)
- **Advanced DDoS**: protección adaptativa con ML, perfiles de tráfico por zona

### WAF (Web Application Firewall)
Reglas de seguridad gestionadas y personalizables:
- **OWASP ModSecurity Core Rule Set**: CRS preconfigurado con thresholds
- **Cloudflare Managed Rulesets**: OWASP, Cloudflare (nuevos CVEs en horas), Exposed Credential Check
- **Custom Rules**: hasta 10 (Free) / ilimitadas (Enterprise), lógica if/then
- **Rate Limiting**: por IP, path, headers, query string (bloqueo o challenge)
- **Bot Management**: clasificación de bots (verified, malicious, spoofed), scoring 1-99
- **API Shield**: autenticación con mTLS, schema validation, endpoint protection
- **Page Shield**: monitoreo de scripts de terceros en el navegador (detección de MAGE cart attacks)

### SSL/TLS
- **Universal SSL**: certificados automáticos gratuitos (soportados por Let's Encrypt)
- **Edge Certificates**: administrados por Cloudflare (digicert, let's encrypt, google trust)
- **Custom Certificates**: subir certificados propios (PEM)
- **Full (Strict)**: cifrado completo desde visitante a origen con CA firmado
- **Authenticated Origin Pulls**: solo Cloudflare puede conectarse al origen (mTLS validado)
- **SSL for SaaS**: Custom Hostnames para SaaS providers (SNI)

### Zero Trust (Cloudflare for Teams)
Plataforma Zero Trust unificada:
- **Cloudflare Access**: autenticación SSO antes del acceso a aplicaciones (no VPN). Políticas condicionales (device posture, geo, hora, mfa)
- **Cloudflare Gateway**: Secure Web Gateway con DNS filtering, network filtering, CASB, DLP
- **WARP Client**: agente de dispositivo para enrutar tráfico (split-tunnel o full-tunnel) a través de Cloudflare
- **Browser Isolation**: ejecución remota del navegador en el edge (RBI), el dispositivo solo recibe píxeles renderizados
- **CASB (Cloud Access Security Broker)**: descubrimiento y monitoreo de aplicaciones SaaS (Google Workspace, Microsoft 365, GitHub, Slack)

```bash
# API: actualizar configuración SSL
curl -X PATCH "https://api.cloudflare.com/client/v4/zones/ZONE_ID/settings/ssl" \
  -H "Authorization: Bearer MI_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"value":"strict"}'

# Obtener eventos de seguridad (WAF, DDoS)
curl -s "https://api.cloudflare.com/client/v4/zones/ZONE_ID/security/events" \
  -H "Authorization: Bearer MI_TOKEN" | jq '.result[0:5]'
```

---

## Serverless / Edge Computing

### Cloudflare Workers
Plataforma serverless que ejecuta código JavaScript/WASM en el edge (330+ ubicaciones):
- **Runtime**: V8 isolates (no Node.js, no contenedores) — extremadamente rápido, cold start <5ms
- **Service Workers API**: fetch(), Cache API, crypto, encoding, streams (especificación estándar)
- **Lenguajes**: JavaScript, TypeScript, WASM (Rust, C/C++, Go, Zig compilado a WASM)
- **Límites**: 10ms CPU (Free), 50ms (Paid/Bundle), 30s (Unbound), 128 MB memoria
- **Variables de entorno**: secrets, KV namespaces, D1 databases, R2 buckets, Queues
- **Cron Triggers**: ejecución por schedule (crontab)
- **Tail Workers**: logs en tiempo real para debugging
- **Smart Placement**: Workers se ejecutan en la ubicación óptima (cerca del usuario o cerca del origen según configuración)
- **Wrangler**: CLI oficial para desarrollo y despliegue

### Workers KV
Almacenamiento clave-valor global consistente (eventualmente):
- **Casos de uso**: configuración remota, A/B testing, traducciones, redirecciones, datos de usuario
- **Latencia de lectura**: <50ms p95 en edge (caching en PoP)
- **Latencia de escritura**: ~5s consistencia global (propagación eventual)
- **Límite**: 25 MB por valor, 1 GB (Free), 50 GB+ (Paid)

### Durable Objects
Coordinación stateful en el edge (consistencia fuerte):
- **Storage local**: hasta 1 GB por objeto
- **WebSocket nativo**: conexiones persistentes, aplicaciones en tiempo real
- **Transactional**: una sola instancia por ID globalmente
- **Casos de uso**: multiplayer en tiempo real, locks distribuidos, contadores atómicos, chat rooms

### R2 (Object Storage)
Almacenamiento de objetos compatible con S3 API, sin costos de egress:
- **Sin cargos de salida**: a diferencia de S3, no paga por descarga
- **Clases**: Standard, Infrequent Access
- **Límites**: hasta 50 TB por cuenta (Free), ilimitado (Paid)
- **S3-compatible**: migración directa desde S3 con `rclone` o AWS SDK modificando endpoint
- **Workers bindings**: acceso directo desde Workers para servir archivos

### D1 (SQL Database)
Base de datos SQL serverless (SQLite):
- **Edge-read replication**: réplicas de lectura en PoPs para baja latencia
- **Backups automáticos**: point-in-time recovery
- **Integración directa con Workers**: binds nativos
- **Consistencia**: fuerte en escritura (global), eventual en replicación de lectura

### Queues
Colas de mensajes asíncronas totalmente administradas:
- **Retry con backoff**: configuración de reintentos (exponencial o fijo)
- **Dead-letter queue**: mensajes fallidos después de N reintentos
- **Batching**: hasta 100 mensajes por batch
- **Integración con Workers**: Producer y Consumer Workers

```bash
# npm install -g wrangler
wrangler --version

# Inicializar proyecto Workers
wrangler init mi-worker --yes

# Desplegar Worker
wrangler deploy

# Local development
wrangler dev

# Crear KV namespace
wrangler kv:namespace create "MI_KV"

# Crear R2 bucket
wrangler r2 bucket create mi-bucket

# Variables de entorno y secrets
wrangler secret put MI_SECRETO_DB

# Logs en tiempo real
wrangler tail

# Listar Workers desplegados
wrangler worker list

# Crear D1 database
wrangler d1 create mi-database
```

---

## Performance & Caching

### Caching
- **Cache modes**: Standard (archivos estáticos), Bypass (dinámico), Ignore Query String, Cache Key personalizado
- **Edge Cache TTL**: tiempo de vida en edge (por cabecera o de forma predeterminada)
- **Cache Reserve**: combina R2 + CDN para caché masiva económica
- **Cache Rules**: reglas condicionales personalizadas (path, cookie, device type, country, etc.)
- **Purge**: por URL, tag, prefix, host (instantáneo)
- **Prefetch**: precarga URLs en caché antes de que sean solicitadas

### Optimización automática
- **Auto Minify**: minifica HTML, CSS, JS automáticamente
- **Rocket Loader**: carga asíncrona de JS priorizando contenido visible (mejora LCP)
- **Mirage**: lazy loading de imágenes con placeholders de baja resolución
- **Polish**: compresión y optimización de imágenes (lossy/lossless, WebP/AVIF)
- **Brotli**: compresión de recursos estáticos y dinámicos
- **Early Hints**: envía preconnect/preload headers antes de la respuesta completa (mejora LCP)

```bash
# Purgar caché por URL
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/purge_cache" \
  -H "Authorization: Bearer MI_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"files":["https://ejemplo.com/index.html"]}'

# Purgar todo el caché
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/purge_cache" \
  -H "Authorization: Bearer MI_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"purge_everything":true}'

# Verificar estado de caché
curl -sI https://ejemplo.com/static/style.css | grep -i cf-cache
```

---

## Cost Optimization

- **Plan Free**: CDN ilimitada, DDoS, SSL, WAF básico, 3 reglas de página, 100k requests/día Workers — sin costo
- **Plan Pro ($20/mes)**: WAF mejorado, mitigación avanzada DDoS, 1M requests/día Workers, Page Rules, Polish, Mirage, Argo
- **Plan Business ($200/mes)**: WAF personalizado, Rate Limiting avanzado, 10M requests/día Workers, Image Resizing, Load Balancing, Workers Analytics
- **R2**: sin egress — costo de almacenamiento ($0.015/GB/mes Standard) + operaciones (Class A/B)
- **Workers**: 100k requests/día gratuitas, luego $0.30/millón
- **Argo Smart Routing**: $5/dominio/mes + $0.10/GB
- **Cloudflare Tunnel**: sin costo de software, paga solo por tráfico
- **Zero Trust**: Free hasta 50 usuarios (Access + Gateway), $7/usuario/mes (plataforma completa)

```bash
# API: obtener analytics de Workers
curl -s "https://api.cloudflare.com/client/v4/accounts/ACCOUNT_ID/workers/analytics" \
  -H "Authorization: Bearer MI_TOKEN" | jq '.result[0:3]'

# Obtener uso de ancho de banda
curl -s "https://api.cloudflare.com/client/v4/zones/ZONE_ID/analytics/dashboard" \
  -H "Authorization: Bearer MI_TOKEN" | jq '.result.totals.bandwidth'
```

---

## Ejemplos CLI Adicionales

```bash
# Configurar WAF rule personalizada (bloquear país)
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/rulesets/phases/http_request_firewall_custom/rules" \
  -H "Authorization: Bearer MI_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "action": "block",
    "expression": "(ip.geoip.country eq \"RU\" or ip.geoip.country eq \"CN\")",
    "description": "Bloquear tráfico de RU y CN"
  }'

# Crear regla de Page Rule (cache everything para /static/*)
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/pagerules" \
  -H "Authorization: Bearer MI_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "targets":[{"target":"url","constraint":{"operator":"matches","value":"*ejemplo.com/static/*"}}],
    "actions":[{"id":"cache_level","value":"cache_everything"}],
    "status":"active"
  }'

# Workers: desplegar desde API
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/ACCOUNT_ID/workers/scripts/mi-worker" \
  -H "Authorization: Bearer MI_TOKEN" \
  -H "Content-Type: application/javascript" \
  --data 'export default { async fetch(request, env, ctx) { return new Response("Hello Workers!"); } };'

# Obtener logs de auditoría de la cuenta
curl -s "https://api.cloudflare.com/client/v4/accounts/ACCOUNT_ID/audit_logs" \
  -H "Authorization: Bearer MI_TOKEN" | jq '.result[0:3]'

# Bulk DNS records (usando jq)
cat registros.json | \
  jq -c '.[] | {type, name, content, ttl, proxied}' | \
  while read record; do
    curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/dns_records" \
      -H "Authorization: Bearer MI_TOKEN" \
      -H "Content-Type: application/json" \
      --data "$record"
  done

# Crear regla de Rate Limiting
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/rate_limits" \
  -H "Authorization: Bearer MI_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "threshold": 100,
    "period": 60,
    "action": {"mode": "challenge"},
    "match": {"request": {"url": "ejemplo.com/login", "methods": ["POST"]}}
  }'
```
