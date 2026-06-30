# 026-Web: Desarrollo Web

## Descripción ampliada del dominio

El desarrollo web abarca la creación y mantenimiento de sitios web y aplicaciones web que se ejecutan en navegadores. Se divide en frontend (interfaz de usuario, HTML/CSS/JavaScript), backend (lógica del servidor, APIs, bases de datos) y full-stack (ambos). La web moderna ha evolucionado desde páginas estáticas (1990s) → web 2.0 dinámica (2000s, AJAX) → SPA (Single Page Applications, 2010s, React/Angular) → SSR/SSG (Next.js, Nuxt, 2020s) → Edge computing (2022+, Vercel Edge Functions, Cloudflare Workers). Los estándares web (W3C, WHATWG) definen HTML, CSS, DOM y APIs web. Los navegadores principales son Chrome (65% market share), Safari (18%), Firefox (3%), Edge (5%). Las tendencias actuales incluyen: Server Components (React Server Components, streaming SSR), Edge computing, WebAssembly (WASM) en el frontend, aplicaciones web progresivas (PWAs), una creciente importancia de Core Web Vitals (LCP, FID, CLS), y Web3/blockchain d-apps. El desarrollo web es el área más accesible para empezar en programación — solo se necesita un navegador y editor de texto — y al mismo tiempo extremadamente profunda.

## Tabla de conceptos clave

| Concepto | Descripción | Estándares/Tecnologías |
|----------|-------------|----------------------|
| HTML5 | Lenguaje de marcado semántico para estructura web | HTML Living Standard (WHATWG) |
| CSS3 | Estilos visuales, layouts, animaciones, responsividad | CSS Grid, Flexbox, Custom Properties, Media Queries |
| JavaScript | Lenguaje de programación del navegador (y servidor con Node.js) | ES6+, TypeScript, Web APIs (DOM, Fetch, Canvas) |
| DOM (Document Object Model) | Representación en árbol de la página web | Manipulación DOM, eventos, shadow DOM |
| SPA Single Page Application | App que carga una sola página HTML y actualiza contenido dinámicamente | React, Vue, Angular, Svelte |
| SSR Server-Side Rendering | Renderizado HTML en servidor, hydrated en cliente | Next.js, Nuxt, Remix, SvelteKit |
| SSG Static Site Generation | Generar HTML estático en build time | Next.js (export), Gatsby, Astro, 11ty |
| PWA Progressive Web App | App web instalable con capacidades nativas (offline, push) | Service Workers, Web App Manifest |
| Web Components | Componentes reutilizables de navegador nativo | Custom Elements, Shadow DOM, HTML Templates |
| Responsive Design | Diseño adaptable a diferentes tamaños de pantalla | Media queries, fluid grids, mobile-first |
| WebAssembly (WASM) | Código binario ejecutable en navegador (C, Rust, Go) | WASM, Emscripten, AssemblyScript, Blazor |
| WebSockets | Comunicación bidireccional en tiempo real | ws, Socket.IO, WebSocket API, SSE |
| Web APIs | APIs de navegador (geolocation, camera, bluetooth, etc.) | Web API MDN reference |

## Tecnologías principales

| Capa | Tecnologías | Frameworks populares | Testing | Bundler |
|------|-------------|---------------------|---------|---------|
| Frontend Framework | React, Vue, Angular, Svelte, Solid | Next.js, Nuxt, Astro, Remix, Gatsby | Jest, Vitest, Testing Library, Cypress, Playwright | Vite, Webpack, esbuild, Turbopack |
| CSS | Tailwind, CSS Modules, Styled Components, SASS, PostCSS | Bootstrap, Material UI, Chakra, Radix UI, DaisyUI | Percy, Chromatic, Storybook | Vite PostCSS |
| Backend | Node.js, Python (Django, FastAPI), Java (Spring), Go, Rust | Express, Next.js, Fastify, Hono, Koa | pytest, Vitest, JUnit, Supertest | — |
| State Management | Redux, Zustand, Pinia, Jotai, Recoil, Signals | TanStack Query, SWR, Apollo Client | MSW (Mock Service Worker) | — |
| GraphQL | Apollo, Relay, Yoga, GraphQL Mesh | Hasura, Prisma, TypeGraphQL | — | — |
| Database | PostgreSQL, MySQL, MongoDB, SQLite, Redis | Prisma, TypeORM, Drizzle, Mongoose | Testcontainers, pg-mem | — |
| Cloud | Vercel, Netlify, Cloudflare, AWS Amplify | SST, AWS CDK, Terraform | — | — |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: HTML5: estructura semántica (header, main, section, article, nav, aside, footer), elementos (h1-h6, p, a, img, ul/ol/li, table, form, input, button), atributos (class, id, href, src, alt, data-*). CSS3: selectors (class, id, element, attribute, pseudo-classes, pseudo-elements), box model (margin, border, padding, content), display (block, inline, inline-block, none), Flexbox (container: display flex, justify-content, align-items, flex-direction; items: flex, order), Grid (display grid, grid-template-columns/rows, gap), responsive design (media queries, mobile-first, rem/em units, viewport). JavaScript básico: variables (let, const), tipos (string, number, boolean, array, object, null, undefined), operators, conditionals (if, else, switch), loops (for, for..of, while), functions (declaration, arrow, parameters, return), DOM manipulation (querySelector, addEventListener, template literals).
   - Proyecto: Página web personal (HTML + CSS responsive) con Flexbox/Grid. Página interactiva (to-do list, contador) con JS puro.
   - Lectura: MDN Web Docs, freeCodeCamp Responsive Web Design, JavaScript.info, "Eloquent JavaScript" (Haverbeke).

2. **Intermedio (3-8 meses)**: Frontend framework: React (components, props, state, hooks: useState, useEffect, useContext, custom hooks). TypeScript: types, interfaces, enums, generics, utility types. State management: Redux Toolkit (createSlice, configureStore, useSelector, useDispatch), Zustand. Routing: React Router DOM (BrowserRouter, Routes, Route, Link, useParams, useNavigate). HTTP client: fetch API, Axios, TanStack Query (useQuery, useMutation, caching, stale-while-revalidate). Forms: React Hook Form + Zod (validation). Testing: Vitest (unit), Testing Library (React Testing Library), MSW (API mocking). Styling: Tailwind CSS (utility-first, responsive, custom config). Bundler: Vite (config, plugins, HMR). Git y GitHub Pages / Vercel deployment.
   - Proyecto: Dashboard con React + TypeScript + Vite + Tailwind + TanStack Query. CRUD app con API mockeada (MSW) o real (JSON Server). Publicado en Vercel.
   - Lectura: "The Road to React" (Wieruch), "TypeScript Handbook" (typescriptlang.org), React docs, Vite docs.

3. **Avanzado (6-12 meses)**: Full-stack: Next.js (pages router vs app router, server components, client components, server actions, API routes, middleware). Autenticación: NextAuth.js/Auth.js, Clerk, Supabase Auth. Database: Prisma ORM (models, migrations, queries, relations) + PostgreSQL (planetscale, neon, supabase). SSR/SSG/ISR: getStaticProps, getServerSideProps, incremental static regeneration (revalidate), server components. Performance: Core Web Vitals optimization (LCP: image optimization, preload; FID: reduce JS; CLS: size attributes, layout shifts), lazy loading (dynamic import, Suspense), code splitting, lighthouse 90+ scores. Web APIs: Canvas, WebGL, Web Workers, WebSockets (Socket.IO), Service Workers (PWA), Geolocation, File API. GraphQL: Apollo Client, GraphQL Yoga, Hasura. Security: CORS, CSP (Content Security Policy), XSS prevention, CSRF, HTTPS, secure cookies, input sanitization. CI/CD: GitHub Actions (lint + test + build + deploy). Accessibility: WCAG 2.1 AA, semantic HTML, ARIA attributes, keyboard navigation, screen reader testing.
   - Proyecto: Full-stack Next.js app (e-commerce, SaaS dashboard, blog platform) con Prisma + PostgreSQL + auth + search + payment (Stripe). Lighthouse 90+.
   - Certificación: Meta Front-End Developer (Coursera), Google Web Developer certification (no oficial), AWS Cloud Practitioner.

4. **Experto (12+ meses)**: Edge computing: Vercel Edge Functions, Cloudflare Workers, Deno Deploy, Edge Middleware (geolocation, A/B testing, i18n). Monorepo: Turborepo (build caching, task orchestration), Nx (code generation, dependency graph). Micro-frontends: Module Federation (Webpack 5), single-spa, qiankun. WebAssembly: WASM in browser (Rust + wasm-pack, Go + WASM), WASM for compute-intensive tasks (video processing, ML inference). Advanced patterns: Server Components + streaming SSR (React 19), React Server Actions, concurrent rendering (Suspense, startTransition, useDeferredValue). Performance at scale: CDN strategies (Fastly, Cloudflare), ISR at scale, incremental builds (Turbopack), stale-while-revalidate caching. Web security: OAuth 2.0 (PKCE), session management, rate limiting (Upstash), bot detection, IP blocking. Observability: OpenTelemetry (web vitals, custom spans), Sentry (error tracking), PostHog (analytics). Web real-time: WebSockets at scale (WebSocket load balancers, Redis pub/sub), WebRTC (video/audio calls). AI/ML web: TensorFlow.js (in-browser ML), Hugging Face Inference API, integration con LLMs (streaming chat, AI features). Auth0 / Clerk / WorkOS enterprise auth.
   - Proyecto: Micro-frontends with Module Federation. Edge-deployed app with Cloudflare Workers + D1. WASM module for video processing. AI-powered web app.
   - Certificación: AWS Solutions Architect Associate, Google Cloud Certified, Kubernetes CKA.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [001-Languages](../001-Languages/) | HTML, CSS, JavaScript/TypeScript como lenguajes web |
| [002-Frameworks](../002-Frameworks/) | React, Vue, Angular, Next.js como frameworks web |
| [003-Databases](../003-Databases/) | DB persistencia para aplicaciones web |
| [005-Cloud](../005-Cloud/) | Vercel, Netlify, Cloudflare, AWS para hosting y edge |
| [006-Containers](../006-Containers/) | Docker para entornos de desarrollo y producción |
| [008-Networking](../008-Networking/) | HTTP/2, HTTP/3, WebSockets, CDN, DNS |
| [009-Security](../009-Security/) | CORS, CSP, OWASP Top 10, HTTPS, Auth |
| [011-DesignPatterns](../011-DesignPatterns/) | Component patterns, hooks patterns, render props |
| [012-Testing](../012-Testing/) | Testing unitario, integración, E2E |
| [025-Mobile](../025-Mobile/) | PWAs, responsive design, mobile web |
| [031-AI](../031-AI/) | TensorFlow.js, AI-powered web features |

## Recursos recomendados

- **Documentación**: MDN Web Docs (developer.mozilla.org), web.dev (Google), CSS-Tricks, React docs (react.dev), Next.js docs.
- **Libros**: "Eloquent JavaScript" (Haverbeke, 4ª ed.), "The Road to React" (Wieruch), "Fullstack React" (Accomazzo), "CSS: The Definitive Guide" (Meyer, Weyl), "Designing Web APIs" (Jin, Sahni, Shevat).
- **Cursos**: freeCodeCamp (free), The Odin Project (free), Frontend Masters, Epic React (Kent C. Dodds), Scrimba.
- **Herramientas**: Chrome DevTools, VS Code, React DevTools, Redux DevTools, Lighthouse, PageSpeed Insights, web.dev/measure.
- **Estándares**: WHATWG HTML Living Standard, W3C CSS specs, TC39 ECMAScript proposals, W3C Web Platform.

## Notas adicionales

El desarrollo web es el entry point más común en tecnología. React/Next.js es el stack más demandado actualmente. Vite ha reemplazado a Webpack como bundler por defecto. TypeScript es estándar en proyectos web modernos. Core Web Vitals son críticos para SEO y experiencia de usuario. El futuro incluye server components, edge computing, y WASM. El ecosistema web evoluciona rápidamente: mantenerse actualizado con newsletters y blogs es esencial. La especialización (frontend, backend, full-stack) es una decisión personal; el conocimiento full-stack proporciona una visión integral valiosa.
