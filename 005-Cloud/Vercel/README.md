# Vercel

## Servicios Principales

Vercel es una plataforma frontend cloud optimizada para frameworks como Next.js, SvelteKit, Nuxt, Astro, Remix y Vite. Ofrece despliegues globales con Edge Functions, ISR (Incremental Static Regeneration), y analytics.

| Categoría | Servicios Clave |
|-----------|----------------|
| Deploy & Hosting | Vercel Hosting, Automatic Deploy, Preview Deployments, Production Deployments, Instant Rollback, Git Integration (GitHub, GitLab, Bitbucket) |
| Rendimiento | Vercel Edge Network (CDN global), Automatic Caching, Smart CDN, ES Modules, Brotli Compression, HTTP/3 |
| Frameworks | Next.js (creador), SvelteKit, Nuxt, Astro, Remix, Vite, Hugo, Jekyll, Hexo, Eleventy, Gatsby, Blitz, Redwood, Analog, Qwik, Angular, SolidStart, Docusaurus |
| Serverless | Vercel Serverless Functions (Node.js, Python, Go, Ruby, Rust), Edge Functions (V8 isolates, global), WebAssembly |
| Data & Storage | Vercel Postgres (Neon serverless Postgres), Vercel KV (Redis via Upstash), Vercel Blob (object storage), Vercel Edge Config |
| Imágenes | Vercel Image Optimization (next/image), AVIF/WebP, responsive images, remote patterns |
| Analytics | Vercel Analytics (Web Vitals), Speed Insights (Core Web Vitals), Web Analytics (privacy-first), Monitoring |
| Edge | Edge Middleware, Edge Config, Edge Functions, Edge Cache |
| Features | ISR (Incremental Static Regeneration), SSR (Server-Side Rendering), SSG (Static Site Generation), DPR (Distributed Persistent Rendering), On-Demand ISR, Route Groups, Middleware |

---

## Plataforma Edge (Vercel Edge Network)

### Edge Network
Red global de 100+ PoPs (Points of Presence) que ejecutan:
- **Static Cache**: archivos estáticos servidos desde CDN con caché inteligente
- **Edge Functions**: V8 isolates que ejecutan código cerca del usuario (100+ regiones)
- **Edge Middleware**: código ejecutado antes de la request (redirect, rewrite, A/B testing, i18n, authentication)
- **Smart CDN**: invalidación automática de caché por deployment, no por URL

### Edge Middleware vs Serverless Functions

| Aspecto | Edge Middleware | Serverless Functions |
|---------|---------------|-------------------|
| Runtime | V8 isolates (Edge Runtime) | Node.js, Python, Go, Ruby, Rust |
| Latencia | <1ms cold start | ~50-500ms cold start |
| Duración | Máx 30s | Máx 60s (Basic), 900s (Pro) |
| Memoria | 128 MB | 1 GB (Basic), 3 GB (Pro) |
| APIs | Web standard (Request, Response, URL) | Node.js full API |
| Ubicación | 100+ regions edge | 18 regions (us-east, iad, etc.) |
| Ideal | Redirects, headers, auth, geolocation, A/B testing | APIs, DB queries, auth flows, image processing, heavy compute |

### Serverless Functions
- **Runtimes**: Node.js (18, 20, 22), Python (3.9-3.12), Go (1.21+), Ruby (3.2+), Rust (via WASM), .NET (8)
- **Memory**: 1 GB (Hobby), 3 GB (Pro/Enterprise)
- **Timeout**: 10s (Hobby), 60s (Pro), 900s (Enterprise)
- **50k requests/month** gratuitas (Hobby), ilimitadas (Pro/Enterprise)

```bash
# Instalar Vercel CLI
npm install -g vercel

# Login
vercel login

# Desplegar proyecto (interactivo)
vercel

# Desplegar a producción
vercel --prod

# Crear preview deployment
vercel deploy

# Listar deployments
vercel list

# Ver logs de deployment
vercel logs <deployment-url>

# Ejecutar variables de entorno localmente
vercel env pull
```

---

## IAM (Vercel Access & Teams)

### Roles and Permissions
- **Owner**: control total, billing, miembros, settings
- **Admin**: todo excepto billing y eliminar equipo
- **Developer**: desplegar, configurar proyectos, ver analytics
- **Contributor**: desplegar, ver logs y analytics
- **Viewer**: solo lectura (deployments, analytics, settings)

### Vercel Teams
- Equipos multi-usuario con facturación compartida
- SAML/SSO (Enterprise): Okta, Azure AD, OneLogin, Google Workspace
- Directorio de miembros con roles granular por proyecto
- SAML JIT (Just-In-Time provisioning)

### Git Integration
- Conexión con GitHub, GitLab, Bitbucket
- Cada push genera un Preview Deployment automático
- Comment on commits con URLs de preview
- Branch auto-detection (main → production, feature/* → preview)
- Checks (GitHub Status Checks): bloquean merge si deployment falla

```bash
# Invitar miembro al equipo
vercel teams invite usuario@email.com --role developer

# Listar miembros del equipo
vercel teams list-members

# Cambiar rol de miembro
vercel teams change-role usuario@email.com admin

# Conectar proyecto a Git
vercel git connect --github
```

---

## Compute & Deployment

### Deployment Pipeline
1. Push a repositorio Git
2. Vercel detecta framework automáticamente
3. Build con comando personalizado o detección automática
4. Assets estáticos → CDN global
5. Serverless Functions → orquestación en regiones
6. Preview URL generada automáticamente
7. Producción desplegada al mergear a main/production branch

### Build
- **Build Command**: detección automática (next build, npm run build, etc.)
- **Output Directory**: detección automática (.next, dist, build, out)
- **Node.js Version**: configurable (18.x por defecto)
- **Environment Variables**: sincronizadas entre local, preview y producción
- **Build Cache**: persistent entre builds usando /vercel/.cache

### Prebuilt Lambda
Optimización para Serverless Functions:
- Prewarming: funciones mantenidas calientes para reducir cold starts
- Lambda con hasta 10 GB de memoria (Enterprise)
- Concurrency ilimitada (Pro/Enterprise)

```bash
# Variables de entorno
vercel env add PLAIN_TEXT_VAR
vercel env add SECRET_TOKEN --sensitive
vercel env pull .env.local

# Establecer framework
vercel project set --framework=nextjs

# Especificar versión de Node
# En vercel.json:
# {
#   "buildCommand": "NODE_VERSION=20 npm run build"
# }

# Ejecutar deployment sin esperar
vercel --no-wait

# Inspectar deployment
vercel inspect <deployment-id>
```

---

## Storage & Databases

### Vercel Postgres (Neon)
Base de datos PostgreSQL serverless:
- **Serverless**: pausa automática cuando inactiva (ahorro de costos)
- **Replicación**: branching (database branching como Git), réplicas de lectura
- **Conexiones**: pooler integrado (PgBouncer) para manejar conexiones concurrentes
- **SDK**: `@vercel/postgres` con query tagging y auto-pooling
- **Billing**: almacenamiento (GB/mes) + compute (horas activas)

### Vercel KV (Upstash Redis)
Cache y storage clave-valor (Redis compatible):
- **Durabilidad**: persistencia en disk (cada escritura se persiste)
- **Latencia**: <5ms (cercano a Serverless Functions)
- **Casos de uso**: sesiones, rate limiting, caché de API, feature flags, colas
- **SDK**: `@vercel/kv` con auto-conexión y retry

### Vercel Blob
Almacenamiento de objetos (similar a S3, R2):
- **REST API** pública para subir y servir archivos
- **Edge-serving**: archivos servidos desde CDN global
- **Casos de uso**: imágenes de usuario, uploads, archivos estáticos dinámicos
- **SDK**: `@vercel/blob` con upload y delete

### Vercel Edge Config
Almacenamiento de configuración global con lectura ultra-rápida (<1ms):
- **Feature flags**: cambio instantáneo sin redeploy
- **Redirects dinámicos**: lista de redirects modificable
- **i18n configuration**: paises, idiomas, traducciones
- **SDK**: `@vercel/edge-config`

```bash
# Postgres: conexión y query
psql "$POSTGRES_URL"
CREATE TABLE usuarios (id SERIAL PRIMARY KEY, nombre TEXT);

# En Next.js API route
# import { sql } from '@vercel/postgres';
# const { rows } = await sql`SELECT * FROM usuarios`;

# KV: desde CLI (vía Redis protocol)
redis-cli -u $KV_URL
SET usuario:1 '{"nombre":"Juan"}'
GET usuario:1

# Blob: subir archivo
curl -X POST "https://blob.vercel-storage.com/upload" \
  -H "Authorization: Bearer BLOB_READ_WRITE_TOKEN" \
  -F "file=@mi-imagen.jpg"
```

---

## Serverless & Edge

### Edge Functions
V8 isolates ejecutándose en el edge global:
```javascript
// /api/hello.js (Edge Runtime)
export const config = { runtime: 'edge' };

export default (req) => {
  const country = req.geo?.country || 'unknown';
  return new Response(`Hello from ${country}!`, {
    headers: { 'content-type': 'text/plain' }
  });
};
```

### Edge Middleware
```javascript
// middleware.ts en /src o raíz
export { default } from "next-auth/middleware";
export const config = { matcher: ["/dashboard/:path*"] };
```

### Serverless Functions (Node.js)
```javascript
// /api/users.js
export default async function handler(req, res) {
  const { name } = req.query;
  res.status(200).json({ message: `Hello ${name}` });
}
```

### Serverless Functions (Python)
```python
# /api/hello.py
from http.server import BaseHTTPRequestHandler

class handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'Hello from Python on Vercel!')
```

---

## Cost Optimization

- **Hobby (Free)**: 50k Serverless Functions requests/mes, 1 GB bandwidth, 100 GB Ancho de Banda, 2 deployments por segundo, Analytics (30 días), 1 equipo
- **Pro ($20/usuario/mes)**: Serverless Functions ilimitadas, 1 TB bandwidth, 6000 GB-hours de compute, Analytics (90 días), equipos multi-miembro, Preview deployments, Serverless Functions 60s timeout
- **Enterprise (custom)**: SLA 99.99%, SSO/SAML, Advanced Analytics, Concurrency ilimitada, 15 min Serverless timeout, Monitoreo avanzado

### Estrategias de optimización
- **ISR**: generar páginas en build y revalidarlas bajo demanda (mejor que SSR en todo)
- **Edge Functions**: más económicas que Serverless Functions (menos compute)
- **Cache bien configurado**: reducir Serverless Function invocations
- **Optimización de imágenes**: next/image auto responde con formatos modernos (AVIF, WebP)
- **Analytics**: Web Analytics no cuenta visitas bajo ad-blockers (sin costo oculto)

```bash
# Ver uso actual del plan
vercel billing ls

# Ver logs de uso de Serverless Functions
vercel logs --json | grep "duration"

# Cambiar a plan Pro
vercel billing upgrade

# Configurar límite de spending
vercel project set --spending-limit 50
```

---

## Ejemplos CLI Adicionales

```bash
# Configurar dominio personalizado
vercel domains add mipropio.com
vercel domains add www.mipropio.com

# Redirección desde www a root
vercel alias set mipropio.com www.mipropio.com

# Remover dominio
vercel domains rm mipropio.com

# Rollback a deployment anterior
vercel rollback

# Ver diferencias entre deployments
vercel diff <deployment-id-1> <deployment-id-2>

# Listar todos los proyectos
vercel project ls

# Obtener información del proyecto actual
vercel project inspect

# Crear nuevo proyecto (sin Git)
vercel project add mi-proyecto

# Configurar Framework preset
vercel project set --framework=sveltekit

# Disconnect Git
vercel git disconnect

# Crear deploy manual (sin Git)
vercel --cwd ./dist --name mi-proyecto

# Alias: asignar URLs amigables
vercel alias set <deployment-url> miproyecto.vercel.app

# Secrets management
vercel secrets add api-key "sk-xxxxx"
vercel secrets list
vercel secrets remove api-key

# Logs de Edge Functions
vercel logs edge

# Monitoreo de Web Vitals (requiere Analytics enabled)
vercel analytics

# Ejemplo de vercel.json completo
cat vercel.json
# {
#   "framework": "nextjs",
#   "buildCommand": "npm run build",
#   "outputDirectory": ".next",
#   "installCommand": "npm install",
#   "regions": ["iad1", "hkg1", "gru1"],
#   "functions": {
#     "api/**/*.py": {
#       "memory": 1024,
#       "maxDuration": 30
#     }
#   },
#   "headers": [
#     {
#       "source": "/(.*)",
#       "headers": [
#         { "key": "X-Frame-Options", "value": "DENY" },
#         { "key": "X-Content-Type-Options", "value": "nosniff" }
#       ]
#     }
#   ],
#   "redirects": [
#     { "source": "/old", "destination": "/new", "permanent": true }
#   ]
# }
```
