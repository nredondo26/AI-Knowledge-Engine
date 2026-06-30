# Netlify

## Servicios Principales

Netlify es una plataforma de deployment y hosting para frontends web modernos con integración Git, funciones serverless, formularios, y edge computing (Edge Functions) basada en Deno.

| Categoría | Servicios Clave |
|-----------|----------------|
| Hosting & Deploy | Netlify Hosting, Git Integration (GitHub, GitLab, Bitbucket), Automatic Deploys, Deploy Previews, Branch-based deploys, Instant Rollback, Split Testing, Deploy Notifications |
| CDN & Rendimiento | Netlify Edge CDN, Asset Optimization, Prerendering, Subdomain-based CDN, HTTP/2, Brotli Compression, Geo-replicated static assets |
| Serverless | Netlify Functions (serverless, Node.js/Go), Edge Functions (Deno, global), Background Functions, Scheduled Functions (cron) |
| Forms | Netlify Forms (sin servidor, spam detection, webhooks, notifications) |
| Identity & Auth | Netlify Identity (autenticación, roles, JWT, SSO, MFA, Magic Links, social login, GoTrue API) |
| Storage | Netlify Large Media (Git LFS con CDN), Blob Storage (beta, edge-presistent store) |
| Edge | Edge Functions (Deno, 250+ locations), Edge Caching, Geolocation, A/B Testing, Redirects & Headers declarativos |
| Frameworks | Next.js, Nuxt, SvelteKit, Astro, Remix, Gatsby, Hugo, Jekyll, 11ty, Vite, Vue, React, Angular, SolidJS, Qwik |
| Analytics | Netlify Analytics (privacy-first, sin cookies, server-side), Split Testing Analytics, Deploy Analytics |
| Monitoreo | Deploy Status, Function Logs, Real-time Deploy Logs, Webhooks, Slack/Discord/Zapier Integration |

---

## Deployment Pipeline

### Git-based Deploy
Netlify se conecta a GitHub, GitLab o Bitbucket y despliega automáticamente:

1. **Push a repositorio** → Netlify detecta cambios
2. **Build** → ejecuta comando de build (npm run build, etc.)
3. **Deploy Preview** → URL única por PR/branch
4. **Production Deploy** → automático al mergear a main/production
5. **Atomic Deployments** → cada deploy es instantáneo: todos los archivos cambian al mismo tiempo (sin estado inconsistente)
6. **Instant Rollback** → revertir a cualquier deploy anterior con un clic

### Deploy Previews
Cada PR obtiene una URL pública única (ej: `deploy-preview-42--mysite.netlify.app`) con:
- Variables de entorno propias (CONTEXT=deploy-preview)
- Testing y QA antes de mergear
- Comentarios automáticos en PR con URL de preview
- Branch-based subdomains (opcional)

### Deploy Contexts
- **production**: branch principal (main, master)
- **deploy-preview**: pull requests
- **branch-deploy**: cualquier otra branch

```bash
# Instalar Netlify CLI
npm install -g netlify-cli

# Login
netlify login

# Inicializar proyecto (conectar a Git)
netlify init

# Desplegar manualmente
netlify deploy --build

# Desplegar a producción
netlify deploy --prod --build

# Desplegar preview
netlify deploy --build

# Listar deploys
netlify deployments:list

# Ver estado del deploy
netlify status

# Rollback
netlify deploy:rollback --deploy-id <id>

# Abrir sitio en navegador
netlify open
```

---

## IAM (Team & Access)

### Roles
- **Owner**: control total, billing, miembros, settings, eliminación del team
- **Admin**: todo excepto billing (Owner-only) y eliminación del team
- **Developer**: desplegar, configurar, logs, forms, functions
- **Contributor**: solo deploys (desde Git push), sin settings
- **Viewer**: lectura de deploys, analytics, forms, functions

### Single Sign-On (SSO)
- **SAML**: Okta, Azure AD, Google Workspace, OneLogin, cualquier IdP SAML 2.0
- **SCIM**: provisioning automático de usuarios (Okta, Azure AD)
- **Team Sync**: sincronización con grupos de Git (GitHub Teams, GitLab Groups)

### Audit Logs
Registro detallado de todas las acciones:
- Deploys, cambios de configuración, acceso de usuarios
- Exportable a SIEM (Splunk, Datadog, etc.)

```bash
# Invitar miembro
netlify sites:addons:auth:invite <email>

# Listar miembros
netlify team:members:list

# Remover miembro
netlify team:members:remove <email>

# Configurar SSO SAML
netlify sites:addons:auth:sso --provider saml --metadata-url <url>
```

---

## Functions (Serverless)

### Netlify Functions
Funciones serverless Node.js y Go con despliegue automático:
- **Directorio**: archivos en `/netlify/functions/` o configurable
- **Runtimes**: Node.js (18, 20), Go (1.21+)
- **Timeouts**: 10s (default), 26s (configurable), Background Functions 15 min
- **Memory**: 1 GB (Pro/Enterprise)
- **Invocaciones**: 125k/mes (Free), 2M/mes (Pro), personalizado (Enterprise)

```javascript
// netlify/functions/hello.js
exports.handler = async (event, context) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hello from Netlify!" })
  };
};
```

```go
// netlify/functions/hello.go
package main

import (
  "github.com/aws/aws-lambda-go/events"
  "github.com/aws/aws-lambda-go/lambda"
)

func handler(request events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
  return &events.APIGatewayProxyResponse{
    StatusCode: 200,
    Body:       "Hello from Go on Netlify!",
  }, nil
}
```

### Background Functions
Funciones asíncronas que se ejecutan en segundo plano (máx 15 min):
```javascript
// netlify/functions/process-background.js
exports.handler = async (event, context) => {
  // Este proceso se marca como background
  await longRunningTask();
  return { statusCode: 202 };
};
// Invocar con header: x-netlify-background: true
```

### Scheduled Functions (Cron)
Funciones ejecutadas por cron (Pro/Enterprise):
```javascript
// netlify/functions/daily-report.js
const { schedule } = require('@netlify/functions');

exports.handler = schedule("@daily", async (event) => {
  await generateReport();
  return { statusCode: 200 };
});
```

### Function Invocation
```bash
# Invocar function localmente
netlify functions:invoke hello --payload '{"name":"Juan"}'

# Listar functions desplegadas
netlify functions:list

# Ver logs de functions
netlify functions:logs hello

# Crear nueva function
netlify functions:create
```

---

## Edge Functions

Edge Functions se ejecutan en Deno (no Node.js) en la red global de Netlify (250+ locations).

### Características
- **Runtime**: Deno (TypeScript/JavaScript nativo, Web Standard APIs, WASM)
- **Contexto**: tiene acceso a `NetlifyContext` (geo, IP, cookies, headers, edge cache)
- **Casos de uso**: geolocation routing, A/B testing, authentication, URL rewriting, rate limiting, personalización de contenido
- **Latencia**: <1ms cold start (V8 isolates)
- **Límites**: 50ms CPU (Free), 100ms (Pro), 200ms (Enterprise)

```typescript
// netlify/edge-functions/hello.ts
import type { Context } from "https://edge.netlify.com/";

export default async (request: Request, context: Context) => {
  const country = context.geo?.country?.name || "unknown";
  return new Response(`Hello from ${country}!`, {
    headers: { "content-type": "text/plain" }
  });
};
```

### Edge Middleware (Declarativo)
Seleccionar qué rutas ejecutan Edge Functions:
```toml
# netlify.toml
[[edge_functions]]
function = "hello"
path = "/api/hello"
```

### Edge Cache
Control de caché desde Edge Functions:
```typescript
export default async (request: Request, context: Context) => {
  context.cache({
    maxAge: 60 * 60, // 1 hora
    swr: 60 * 5      // stale-while-revalidate 5 min
  });
  return new Response("Cached content");
};
```

```bash
# Crear Edge Function
netlify edge-functions:create

# Listar Edge Functions
netlify edge-functions:list

# Servir localmente con Edge
netlify dev
```

---

## Forms

Netlify Forms permite recibir datos de formularios HTML sin backend:
- **Spam Detection**: filtro Honeypot + Akismet + reCAPTCHA
- **Notifications**: email, Slack, Discord, webhooks
- **File uploads**: soporte multipart/form-data
- **Export**: CSV, JSON, API
- **Submissions**: 100/mes (Free), 1,000/mes (Pro), personalizado (Enterprise)

```html
<form name="contact" method="POST" data-netlify="true">
  <input type="text" name="name" placeholder="Nombre" required />
  <input type="email" name="email" placeholder="Email" required />
  <textarea name="message" placeholder="Mensaje"></textarea>
  <div data-netlify-recaptcha="true"></div>
  <button type="submit">Enviar</button>
</form>
```

```bash
# Listar submissions de un form
netlify forms:list

# Ver detalles de submissions
netlify forms:show <form-id>

# Exportar submissions a CSV
netlify forms:export --format csv --output ./submissions.csv
```

---

## Identity (Auth)

Netlify Identity proporciona autenticación completa:
- **Email/Password**: registro, login, cambio de contraseña, confirmación
- **Social Login**: Google, GitHub, GitLab, Bitbucket, Facebook (OAuth)
- **Magic Links**: login sin contraseña
- **MFA (TOTP)**: autenticación de dos factores
- **Roles**: asignación de roles por usuario, control de acceso en funciones
- **JWT**: tokens firmados para autenticación en funciones (context.clientContext.user)
- **Single Page Apps**: GoTrue.js client library

```bash
# Configurar Identity
netlify sites:addons:auth:enable

# Invitar usuario
netlify sites:addons:auth:invite <email>

# Listar usuarios
netlify sites:addons:auth:list
```

---

## Redirects, Headers & Cache

### _redirects
Archivo de reglas de redirección y rewrites:
```
# /public/_redirects
/*    /index.html    200
/blog/*    /blog/:splat    200
/news/*    https://news.example.com/:splat    301!
/old-page  /new-page    301
```

### _headers
Control de headers HTTP:
```
# /public/_headers
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: geolocation=(self)

/static/*
  Cache-Control: public, max-age=31536000, immutable

/sw.js
  Cache-Control: no-cache
```

### netlify.toml
Configuración declarativa del proyecto:
```toml
[build]
  command = "npm run build"
  publish = "dist"
  functions = "netlify/functions"
  edge_functions = "netlify/edge-functions"

[build.environment]
  NODE_VERSION = "20"
  NPM_FLAGS = "--legacy-peer-deps"

[[redirects]]
  from = "/api/*"
  to = "/.netlify/functions/:splat"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"

[[edge_functions]]
  function = "geo-redirect"
  path = "/*"
```

---

## Cost Optimization

| Plan | Precio | Serverless Functions | Edge Functions | Bandwidth | Forms | Identity |
|------|--------|---------------------|----------------|-----------|-------|----------|
| Starter | Gratis | 125k/mes, 10s timeout | 500k/mes, 50ms CPU | 100 GB | 100/mes | 1,000 usuarios |
| Pro | $19/usuario/mes | 2M/mes, 26s timeout | 5M/mes, 100ms CPU | 1 TB + $20/100GB extra | 1,000/mes | 10,000 usuarios |
| Enterprise | Personalizado | Ilimitado, 26s+ timeout | Ilimitado | Ilimitado | Personalizado | Ilimitado |

### Estrategias
- **Cache agresivo**: archivos estáticos con inmutabilidad (evita reintentos de función)
- **Split Testing**: sin costo adicional (pruebas A/B sin incrementar functions)
- **Netlify Analytics**: $9/site/mes (sin pagar por Google Analytics, sin cookies)
- **Blob Storage**: almacenamiento edge persistente con cache integrado

```bash
# Ver uso actual
netlify sites:usage

# Configurar límite de gasto
netlify sites:config:limits --bandwidth 50 --functions 100000

# Ver analytics
netlify sites:analytics
```

---

## Ejemplos CLI Adicionales

```bash
# Crear nuevo sitio
netlify sites:create --name mi-sitio

# Configurar dominio personalizado
netlify domains:add mipropio.com

# Configurar subdominio www
netlify domains:add www.mipropio.com

# Ver DNS
netlify domains:dns mipropio.com

# Habilitar HTTPS
netlify sites:config:https --domain mipropio.com

# Crear deploy desde directorio local
netlify deploy --dir=./dist --prod

# Deploy con mensaje
netlify deploy --prod --message "v2.0 - Nueva landing page"

# Ver historial de deploys
netlify deployments --limit 20

# Function logs en tiempo real
netlify dev --functions-port 8888
netlify functions:logs --since 5m

# Enlazar directorio local con Netlify
netlify link

# Desenlazar
netlify unlink

# Configurar redirección 301
netlify redirects:create --from "/old" --to "/new" --status 301

# Importar sitio existente
netlify sites:create --manual

# Netlify Large Media (Git LFS)
netlify sites:large-media:setup

# Limpiar cache de deploys
netlify sites:clear-cache

# Ejemplo de _redirects avanzado (protección de país)
cat public/_redirects
# /private/*  /.netlify/functions/auth 200
# /api/external*  https://api.externa.com/:splat  200!
# /downloads/*  https://s3.amazonaws.com/mi-bucket/:splat  302!
```
