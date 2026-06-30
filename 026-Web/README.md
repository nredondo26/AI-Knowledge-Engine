# 026-Web: Desarrollo Web

## Descripción del dominio

El desarrollo web abarca la creación de sitios y aplicaciones accesibles a través de navegadores. Incluye el frontend (HTML, CSS, JavaScript), backend (servidores, APIs), protocolos de comunicación (HTTP, WebSocket), almacenamiento (cookies, localStorage, IndexedDB), rendimiento (Core Web Vitals), accesibilidad (WCAG), seguridad (CORS, CSP, XSS) y experiencias inmersivas (WebGL, WebGPU, WASM). Las PWAs y las Single Page Applications (SPA) dominan el panorama actual.

## Conceptos clave

- **HTML5**: Última versión del lenguaje de marcado, semántica, elementos multimedia
- **CSS3**: Hojas de estilo modernas, Flexbox, Grid, animaciones, variables, custom properties
- **JavaScript (ES6+)**: Lenguaje de scripting de la web, async/await, módulos, proxies
- **DOM (Document Object Model)**: Representación en memoria de la estructura HTML manipulable via JS
- **SPA (Single Page Application)**: App que carga una sola página y actualiza contenido dinámicamente
- **SSR (Server-Side Rendering)**: Renderizado en servidor para mejor SEO y primera carga
- **SSG (Static Site Generation)**: Generación de HTML estático en build time
- **PWA (Progressive Web App)**: App web instalable con service workers, offline, push
- **WASM (WebAssembly)**: Binario compilado de bajo nivel ejecutable en navegadores (Rust, C++)
- **WebSocket**: Protocolo de comunicación bidireccional persistente en tiempo real
- **WebGL / WebGPU**: APIs de renderizado 3D acelerado por GPU en el navegador
- **REST vs GraphQL**: Estilos de arquitectura de APIs web
- **Core Web Vitals**: Métricas de rendimiento web (LCP, FID, CLS)
- **WCAG (Web Content Accessibility Guidelines)**: Estándares de accesibilidad web
- **CORS (Cross-Origin Resource Sharing)**: Mecanismo de seguridad para recursos entre orígenes
- **CSP (Content Security Policy)**: Cabecera de seguridad contra XSS
- **Microfrontends**: Arquitectura donde el frontend se compone de aplicaciones independientes
- **CDN (Content Delivery Network)**: Red de servidores distribuidos para entrega rápida de contenido

## Tecnologías principales

- **HTML5 / CSS3**: Fundamentos del desarrollo web, Canvas, SVG, Web Components
- **JavaScript (ES2024)**: Lenguaje base, TypeScript como superset tipado
- **React**: Biblioteca de UI declarativa, ecosistema masivo, Next.js para SSR/SSG
- **Vue.js**: Framework progresivo, Nuxt para SSR, Pinia para estado
- **Angular**: Framework completo de Google, TypeScript nativo, RxJS
- **Svelte**: Framework compilado, sin virtual DOM, código más pequeño
- **Solid.js**: Framework reactivo con rendimiento cercano a vanilla JS
- **Next.js**: Framework React con SSR, SSG, API routes, App Router
- **Nuxt.js**: Framework Vue con SSR, módulos, auto-import
- **Astro**: Static site builder con islands architecture y cero JS por defecto
- **Tailwind CSS**: Framework CSS utility-first, diseño rápido y consistente
- **Shadcn/ui**: Componentes React reutilizables sin instalar paquetes
- **Webpack / Vite / Turbopack**: Bundlers y build tools modernos
- **ESLint / Prettier**: Linting y formateo de código
- **Vitest / Playwright / Cypress**: Testing unitario y E2E
- **Vercel / Netlify / Cloudflare Pages**: Plataformas de deploy serverless

## Hoja de ruta

1. **Principiante**: HTML semántico, CSS (Flexbox, Grid), JavaScript (DOM, eventos, fetch). Crear sitio web estático responsive. Publicar con GitHub Pages.
2. **Intermedio**: Framework JS (React/Vue). Enrutamiento, estado global, consumo de APIs. Build tools (Vite). TypeScript básico. Formularios, validación, autenticación JWT. Despliegue en Vercel/Netlify.
3. **Avanzado**: SSR/SSG con Next.js/Nuxt. PWAs con service workers. Optimización de rendimiento (lazy loading, code splitting, Core Web Vitals). Testing (Vitest, Playwright). CI/CD web. Microfrontends.
4. **Experto**: WASM con Rust/Go. WebGPU para gráficos avanzados. Técnicas de performance al límite (virtual scrolling, streaming SSR). Arquitecturas de tiempo real (WebSockets, WebRTC). Edge computing con funciones serverless globales.

## Relaciones con otros módulos

- [Mobile](../025-Mobile/) — PWAs, diseño responsive, APIs compartidas web ↔ móvil
- [Desktop](../027-Desktop/) — Electron, Tauri (apps web como escritorio)
- [APIs](../079-APIs/) — REST, GraphQL, WebSockets, APIs del navegador
- [Frameworks](../002-Frameworks/) — Frameworks JS y CSS para desarrollo web
- [Languages](../001-Languages/) — JavaScript, TypeScript, HTML, CSS
- [Security](../009-Security/) — CORS, CSP, XSS, CSRF, OWASP Top 10
- [Cloud](../005-Cloud/) — Deploy, CDN, serverless, edge functions
- [Architecture](../010-Architecture/) — Microfrontends, SPA, SSR, JAMstack
- [DesignPatterns](../011-DesignPatterns/) — Patrones de UI, estado, composición

## Recursos recomendados

- [MDN Web Docs](https://developer.mozilla.org)
- [web.dev](https://web.dev)
- [React Documentation](https://react.dev)
- [Next.js Documentation](https://nextjs.org/docs)
- [Vue.js Guide](https://vuejs.org/guide)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- "Eloquent JavaScript" — Marijn Haverbeke
- "JavaScript: The Good Parts" — Douglas Crockford
- [WebGL Fundamentals](https://webglfundamentals.org)
- [Can I Use](https://caniuse.com)
