# 002-Frameworks: Frameworks y Librerías

## Descripción del dominio

Los frameworks y librerías proporcionan arquitecturas reutilizables y abstracciones que aceleran el desarrollo de software, evitando reinventar la rueda. Un framework define la estructura y el flujo de control (Inversión de Control — IoC), mientras que una librería ofrece funciones específicas que el desarrollador invoca bajo su propio control. Este módulo cubre los frameworks más influyentes del desarrollo web, mobile, desktop, científico y empresarial.

## Conceptos clave

- **Arquitectura MVC/MVVM/MVP**: Separación en modelo, vista y controlador/viewmodel; flujo de datos unidireccional vs bidireccional
- **Inversión de Control (IoC) y DI**: Contenedores de dependencias, inyección por constructor/setter/interface
- **Middlewares y pipelines**: Interceptores, hooks, filtros, interceptors (AOP), cadena de responsabilidad
- **Reactividad**: Observables, signals, streams, state management reactivo (Redux, MobX, Zustand, NgRx)
- **Virtual DOM vs Real DOM**: Algoritmo de reconciliación, shadow DOM, change detection
- **Componentes web**: Web Components, Custom Elements, Shadow DOM, lit-html
- **ORM/ODM**: Object-Relational Mapping, lazy loading, Unit of Work, Identity Map, migrations
- **SSR (Server-Side Rendering) vs SSG vs CSR**: Next.js (SSR/SSG), Nuxt, Gatsby; hydration hidratación
- **Compilación y bundling**: Webpack, Vite, esbuild, turbopack, tree-shaking, code splitting
- **Meta-frameworks**: Capas completas que integran frontend + backend + DB (Next.js, Remix, Nuxt, SvelteKit)
- **Micro-frontends**: Module Federation (Webpack 5), single-spa, qiankun, iframes vs composición nativa
- **Frameworks empresariales**: Spring Boot (Java), ASP.NET Core (C#), Django (Python), Laravel (PHP)

## Tecnologías principales

| Framework | Lenguaje | Tipo | Caso de uso |
|-----------|----------|------|-------------|
| React | JS/TS | Librería UI | SPAs, web apps interactivas, mobile (React Native) |
| Angular | JS/TS | Framework full-featured | Apps empresariales, dashboards complejos |
| Vue 3 | JS/TS | Framework progresivo | Apps medianas, prototipado rápido |
| Next.js | JS/TS | Meta-framework React | SSR, SSG, full-stack con API routes |
| Nuxt 3 | JS/TS | Meta-framework Vue | SSR/SSG con Vue, módulos |
| SvelteKit | JS/TS | Meta-framework Svelte | Apps ligeras, rendimiento nativo |
| Django | Python | Framework web full-stack | Apps CRUD, APIs REST, admin automático |
| FastAPI | Python | Framework async APIs | APIs REST/GraphQL de alto rendimiento |
| Spring Boot | Java | Framework enterprise | Microservicios, transacciones, seguridad |
| Laravel | PHP | Framework web | Apps web con ecosistema rico |
| ASP.NET Core | C# | Framework web | APIs, enterprise, alto rendimiento |
| Express.js | JS/TS | Framework backend minimalista | APIs REST, middlewares |
| Rails | Ruby | Framework full-stack | Prototipado rápido, convención sobre configuración |
| Flutter | Dart | Framework UI multiplataforma | Mobile, web, desktop desde un código base |
| Tauri | Rust/JS | Framework desktop | Apps nativas ligeras, seguras |

## Hoja de ruta

1. **Principiante**: Elegir un stack (React + Node.js o Django + Python) — entender componentes/vistas — routing básico — formularios — peticiones HTTP
2. **Intermedio**: State management — hooks/directivas — middlewares — ORM — autenticación — testing de componentes — despliegue básico
3. **Avanzado**: SSR/SSG — optimización de rendimiento — lazy loading — micro-frontends — patrones avanzados (HOC, render props, composición) — arquitectura en módulos
4. **Experto**: Creación de un framework propio — contribución core — Module Federation — Server Components (RSC) — Edge computing — frameworks isomórficos

## Relaciones con otros módulos

- [001-Languages](../001-Languages/) — Frameworks construidos sobre cada lenguaje
- [003-Databases](../003-Databases/) — Conexión desde frameworks vía ORMs/ODMs y drivers nativos
- [005-Cloud](../005-Cloud/) — Despliegue de apps en AWS Elastic Beanstalk, Cloud Run, App Engine
- [006-Containers](../006-Containers/) — Contenedorización de aplicaciones con Docker multi-stage builds
- [007-Orchestration](../007-Orchestration/) — Orquestación de microservicios en Kubernetes
- [008-Networking](../008-Networking/) — Configuración de proxies reversos, balanceo y SSL frente a frameworks
- [009-Security](../009-Security/) — Protección CSRF, XSS, SQL injection en frameworks; autenticación/autorización
- [011-DesignPatterns](../011-DesignPatterns/) — Patrones de diseño implementados dentro de frameworks

## Recursos recomendados

- **React**: react.dev/docs, "The Road to React" (Wieruch), React Conf videos, React Patterns
- **Angular**: angular.dev, "Angular Up & Running" (Seshadri), NgRx docs, Angular University
- **Vue**: vuejs.org, Vue Mastery, "Vue.js Design Patterns" (Geng)
- **Django**: djangoproject.com, "Two Scoops of Django" (Feldroy), Django Girls Tutorial
- **Spring Boot**: spring.io, "Spring in Action" (Walls), Baeldung, Spring Academy
- **Laravel**: laravel.com/docs, Laracasts, "Laravel: Up & Running" (Stauffer)
