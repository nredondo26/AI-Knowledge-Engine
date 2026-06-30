# 002-Frameworks: Frameworks y Librerías

## Descripción ampliada del dominio

Los frameworks y librerías proporcionan arquitecturas reutilizables y abstracciones que aceleran el desarrollo de software, evitando reinventar la rueda. Un framework define la estructura y el flujo de control (Inversión de Control — IoC), mientras que una librería ofrece funciones específicas que el desarrollador invoca bajo su propio control. Este módulo cubre los frameworks más influyentes del desarrollo web, mobile, desktop, científico y empresarial. La distinción fundamental entre framework y librería radica en quién controla el flujo: con una librería, tú llamas al código; con un framework, el framework llama a tu código (Hollywood Principle). Los frameworks modernos tienden a ser meta-frameworks que integran frontend, backend, base de datos y despliegue en una sola herramienta (Next.js, Nuxt, SvelteKit). La evolución ha ido de frameworks monolíticos pesados (Spring, Rails) a frameworks ligeros y componibles (FastAPI, Express), con tendencia actual hacia Server Components, edge computing y frameworks isomórficos que ejecutan el mismo código en cliente y servidor.

## Tabla de conceptos clave

| Concepto | Descripción | Frameworks representativos |
|----------|-------------|---------------------------|
| MVC (Model-View-Controller) | Separación en capas: modelo (datos), vista (UI), controlador (lógica) | Django, Rails, Spring MVC, ASP.NET MVC |
| MVVM (Model-View-ViewModel) | Vista ligada a ViewModel que expone datos reactivos | Angular, Vue 3, WPF, MAUI |
| Inversión de Control (IoC) | El framework controla el flujo, no el desarrollador | Spring, Angular, ASP.NET Core |
| Inyección de Dependencias (DI) | Contenedor provee dependencias automáticamente | Spring, Angular, NestJS, ASP.NET Core |
| Middleware/Pipeline | Cadena de procesamiento de peticiones | Express, FastAPI, Django, ASP.NET Core |
| Reactividad | Actualización automática de UI ante cambios de estado | React (hooks), Vue 3 (ref/reactive), Svelte (signals) |
| Virtual DOM | Representación en memoria del DOM para reconciliación eficiente | React, Vue 3 |
| Shadow DOM | Encapsulación de estilos y marcado en componentes web | Web Components, Angular (View Encapsulation) |
| SSR (Server-Side Rendering) | Renderizado de HTML en servidor para mejor SEO y primera carga | Next.js, Nuxt, Remix, SvelteKit |
| SSG (Static Site Generation) | Generación de HTML estático en build time | Next.js, Gatsby, Astro, 11ty |
| ORM/ODM | Mapeo objeto-relacional/documental | Prisma, TypeORM, Django ORM, Sequelize, Mongoose |
| Micro-frontends | Composición de frontend con múltiples frameworks independientes | Module Federation, single-spa, qiankun |

## Tecnologías principales

| Framework | Lenguaje | Tipo | Rendimiento | Ecosistema | Caso de uso principal |
|-----------|----------|------|------------|------------|----------------------|
| React 19 | JS/TS | Librería UI | Alto (Virtual DOM) | Extenso (npm) | SPAs, web apps interactivas, React Native |
| Angular 18 | JS/TS | Framework completo | Alto (Change Detection optimizado) | Completo (RxJS, Material) | Apps empresariales, dashboards complejos |
| Vue 3 | JS/TS | Framework progresivo | Alto (compilador optimizado) | Modular (Pinia, Vite) | Apps medianas, prototipado rápido |
| Next.js 15 | JS/TS | Meta-framework React | Muy alto (RSC, Edge) | Extenso | SSR/SSG/ISR, full-stack, ecommerce |
| Nuxt 3 | JS/TS | Meta-framework Vue | Alto | Modular (módulos) | SSR/SSG con Vue, contenido dinámico |
| SvelteKit | JS/TS | Meta-framework Svelte | Muy alto (compilado) | Creciente | Apps ligeras, alto rendimiento |
| Django 5 | Python | Full-stack | Medio-alto | Muy extenso | Apps CRUD, admin automático, APIs |
| FastAPI | Python | Async API | Muy alto (asyncio) | Bueno | APIs REST/GraphQL, streaming |
| Spring Boot 3 | Java | Enterprise | Alto | Muy extenso | Microservicios, transacciones, seguridad |
| Laravel 11 | PHP | Web | Medio | Extenso | Apps web, contenido dinámico |
| ASP.NET Core 8 | C# | Web/API | Muy alto (nativo) | Completo (.NET) | APIs, enterprise, rendimiento |
| Express.js | JS/TS | Backend minimal | Medio-alto | Muy extenso | APIs REST, middlewares |
| Ruby on Rails 7 | Ruby | Full-stack | Medio | Maduro | Prototipado rápido, convención |
| Flutter 3 | Dart | UI multiplataforma | Muy alto (Skia) | Creciente | Mobile, web, desktop |
| Tauri 2 | Rust/JS | Desktop nativo | Muy alto | Creciente | Apps nativas ligeras y seguras |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Elegir un stack inicial (React + Node.js/Express o Django + Python). Entender componentes, props, estado local. Routing básico (React Router, Django URLs). Formularios, manejo de eventos, peticiones HTTP (fetch, axios). Templates o JSX. Estructura de proyecto recomendada.
   - Proyecto: Aplicación CRUD de tareas (Todo List) con frontend y backend. Blog simple con panel admin.
   - Lectura: Documentación oficial del framework + tutorial interactivo.

2. **Intermedio (3-6 meses)**: State management (Redux, Zustand, Pinia, NgRx). Hooks avanzados (useEffect, useMemo, useCallback, custom hooks) / directivas personalizadas. Middlewares y pipelines. ORM/ODM (Prisma, Django ORM, TypeORM) con migraciones. Autenticación JWT/sessions. Testing de componentes (Testing Library, Cypress). Despliegue básico (Vercel, Railway, Render). Validación de formularios con librerías (React Hook Form, Zod, Pydantic).
   - Proyecto: Aplicación de chat en tiempo real con WebSockets. Panel de administración con métricas.
   - Lectura: Documentación avanzada, libros del framework ("Fullstack React", "Two Scoops of Django").

3. **Avanzado (6-12 meses)**: SSR, SSG, ISR (Incremental Static Regeneration). Optimización de rendimiento: lazy loading, code splitting, tree shaking, bundle analysis. Micro-frontends con Module Federation. Patrones avanzados: HOC, render props, composición, slots, mixins. Arquitectura en módulos/clean architecture dentro del framework. Server Components (RSC en React). Edge computing (Vercel Edge, Cloudflare Workers). Caché y CDN integration. Internationalization (i18n). Testing E2E (Playwright, Cypress).
   - Proyecto: Plataforma multi-tenant SaaS con SSR. Dashboard en tiempo real con datos streaming.
   - Lectura: "Patterns of Enterprise Application Architecture" (Fowler), documentación avanzada.

4. **Experto (12+ meses)**: Creación de un framework o librería propia. Contribuciones core al framework (bug fixes, features). Implementación de Module Federation avanzada. Integración profunda con Server Components y streaming SSR. Diseño de DSL dentro del framework. Optimización de bundle específica del framework a nivel de compilación. Estrategias avanzadas de caché y revalidación. Frameworks isomórficos y edge rendering. Seguridad a nivel framework (CSP, nonce, XSS prevention). Empaquetado de librerías con soporte ESM/CJS/UMD.
   - Proyecto: Plug-in/plugin system para el framework. Herramienta de scaffolding CLI. Integración con plataformas cloud.
   - Lectura: Código fuente del framework, RFCs, propuestas de diseño ("React Design Principles", "Vue RFCs").

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [001-Languages](../001-Languages/) | Frameworks construidos sobre cada lenguaje |
| [003-Databases](../003-Databases/) | Conexión vía ORMs, drivers nativos, pooling |
| [005-Cloud](../005-Cloud/) | Despliegue en AWS, GCP, Azure; Elastic Beanstalk, Cloud Run |
| [006-Containers](../006-Containers/) | Docker multi-stage builds, optimización de imágenes |
| [007-Orchestration](../007-Orchestration/) | Orquestación de microservicios en Kubernetes |
| [008-Networking](../008-Networking/) | Proxies reversos (nginx, Caddy), balanceo, SSL |
| [009-Security](../009-Security/) | Protección CSRF, XSS, SQL injection, auth |
| [011-DesignPatterns](../011-DesignPatterns/) | Patrones implementados dentro de frameworks |
| [012-Testing](../012-Testing/) | Testing de componentes, integración, E2E |
| [025-Mobile](../025-Mobile/) | React Native, Flutter como frameworks mobile |
| [026-Web](../026-Web/) | Frameworks web como core del desarrollo frontend |

## Recursos recomendados

- **React**: react.dev, "The Road to React" (Wieruch), "React Design Patterns and Best Practices" (Carlos Santana).
- **Angular**: angular.dev, "Angular Up & Running" (Seshadri), Angular University courses.
- **Vue**: vuejs.org, Vue Mastery, "Vue.js Design Patterns" (Geng), "Learning Vue 3" (Hanchett).
- **Django**: djangoproject.com, "Two Scoops of Django" (Feldroy), Django Girls Tutorial, REVSYS blog.
- **Spring Boot**: spring.io, "Spring in Action" (Walls, 6ª ed.), Baeldung, Spring Academy, Marco Behler blog.
- **Laravel**: laravel.com, Laracasts, "Laravel: Up & Running" (Stauffer), Laravel News.
- **Next.js**: nextjs.org, "The Next.js Handbook" (Flavio Copes), Vercel blog, Next Conf videos.
- **FastAPI**: fastapi.tiangolo.com, "FastAPI: Modern Python Web Development" (Amatya).
- **Rails**: rubyonrails.org, "Agile Web Development with Rails 7" (Ruby Sam, MongoDB bookshelf).
- **general**: "Framework Design Guidelines" (Cwalina, Barton), Patterns of Enterprise Application Architecture.

## Notas adicionales

La elección del framework debe basarse en: requerimientos del proyecto, experiencia del equipo, ecosistema y comunidad, rendimiento necesario, y mantenibilidad a largo plazo. No existe el "mejor framework"; cada uno tiene fortalezas para casos de uso específicos. Se recomienda dominar un framework completo antes de explorar alternativas, para entender los conceptos fundamentales que todos comparten.
