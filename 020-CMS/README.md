# 020-CMS: Content Management Systems

## Descripción ampliada del dominio

Los sistemas de gestión de contenidos (CMS) permiten crear, gestionar, modificar y publicar contenido digital sin necesidad de conocimientos técnicos profundos. Separando la gestión de contenido (back-office) de la presentación (front-end), los CMS facilitan que equipos de contenido (editores, redactores, marketers) mantengan sitios web dinámicos, portales y aplicaciones. El mercado CMS incluye tanto soluciones tradicionales (WordPress, Drupal, Joomla) como headless CMS (Contentful, Strapi, Sanity) y plataformas de experiencia digital (DXPs: Sitecore, Adobe Experience Manager, Optimizely). WordPress domina el mercado con más del 43% de todos los sitios web. La evolución de CMS: páginas estáticas HTML (1990s) → CMS dinámicos con DB (2000s, PHP-based: WordPress, Drupal, Joomla) → CMS SaaS (2010s, Wix, Squarespace, Webflow) → Headless/Decoupled CMS (2015+, APIs + frontend independiente) → Composable CMS/DXP (2020+, microservicios, MACH architecture: Microservices, API-first, Cloud-native, Headless). La tendencia actual es composable DXP, AI-powered content creation, y CMS headless con frameworks modernos (Next.js, Gatsby, Astro).

## Tabla de conceptos clave

| Concepto | Descripción | Ejemplos/Tecnologías |
|----------|-------------|---------------------|
| CMS Tradicional | CMS que gestiona contenido y presentación juntos | WordPress, Drupal, Joomla |
| Headless CMS | CMS que provee contenido via API, frontend separado | Contentful, Strapi, Sanity, Storyblok |
| DXP (Digital Experience Platform) | Plataforma completa para experiencias digitales | Sitecore, Adobe Experience Manager, Optimizely |
| WCM (Web Content Management) | Gestión de contenido web específicamente | AEM Web, Sitecore XP |
| DAM (Digital Asset Management) | Gestión de activos digitales (imágenes, videos, docs) | Adobe AEM Assets, Bynder, Cloudinary |
| MACH Architecture | Microservicios + API-first + Cloud-native + Headless | Composable commerce/CMS platforms |
| GraphQL | API query language alternativo a REST | Contentful, Strapi, Sanity |
| Content Modeling | Definición de tipos de contenido y sus campos | Content model, schema definition, JSON/Rich Text |
| Editorial Workflow | Flujo de edición → revisión → aprobación → publicación | Workflows, revisions, staging |
| Multi-language | Gestión de contenido en múltiples idiomas | i18n, translation management, content versioning |
| SSR/SSG | Server-Side Rendering / Static Site Generation | Next.js (SSG/SSR), Gatsby (SSG), Astro |
| Live Preview | Vista previa del contenido antes de publicar | Contentful preview, Sanity vision, WordPress preview |

## Tecnologías principales

| CMS | Tipo | Lenguaje | Licencia | Base de datos | Frontend | Casos de uso |
|-----|------|----------|----------|---------------|----------|--------------|
| WordPress | Tradicional | PHP | GPLv2 (Open Source) | MySQL | PHP + JS + blocks | Blogs, SMB, e-commerce (WooCommerce), media |
| Drupal | Tradicional | PHP | GPLv2 (Open Source) | MySQL/PostgreSQL | Twig + JS | Enterprise, government, universities |
| Strapi | Headless | Node.js | MIT (Open Source) | SQLite/PostgreSQL/MySQL | API + any framework | Startups, mid-market, custom frontends |
| Contentful | Headless SaaS | Cloud | SaaS (API) | Cloud (managed) | API + any framework | Enterprise, multi-channel content |
| Sanity | Headless (Composable) | Node.js (Sanity Studio) | SaaS + Open Source Studio | Cloud (real-time) | GROQ/GraphQL + any framework | Enterprise, real-time collaboration |
| Ghost | Headless/Legacy | Node.js | MIT (Open Source) | SQLite/MySQL | Handlebars + API | Publishing, newsletters, membership |
| Sitecore XP | DXP | .NET/C# | Proprietaria | SQL Server + SOLR | Sitecore JSS, Next.js | Enterprise, marketing, personalization |
| AEM (Adobe Experience Manager) | DXP | Java/AEM | Proprietaria | JCR (Apache Jackrabbit) | AEM Sites, SPA editor | Enterprise, large-scale content & assets |
| Webflow | SaaS (Visual) | Cloud | SaaS | Cloud managed | Visual editor + export | Designers, agencies, landing pages |
| Wix/Squarespace | SaaS (All-in-one) | Cloud | SaaS | Cloud managed | Visual builder + templates | SMB, personal websites, e-commerce |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos CMS: qué es, diferencia entre CMS, DXP, Web builder. Arquitectura: back-end (admin panel) + front-end (website) + database. WordPress: instalación (local con LocalWP o Docker), panel de administración (Dashboard: posts, pages, media, comments, plugins, appearance, settings), temas (instalar, personalizar, widgets, menús), plugins (instalar, configurar, SEO con Yoast), Gutenberg editor (bloques, patrones, reutilizables), usuarios y roles (admin, editor, author, contributor, subscriber). Jerarquía de contenido: posts (blog, categorías, tags, autor, fecha) vs pages (estáticas, jerarquía padre-hijo). Medios: imágenes, galerías, formatos. Ajustes: permalinks, lectura, discusión, privacidad.
   - Proyecto: Instalar WordPress local. Crear sitio con 3 páginas + 5 posts con categorías y tags. Instalar tema Astra + plugin Yoast SEO.
   - Lectura: WordPress.org documentation, "WordPress for Dummies" (Mulder), WPBeginner tutorials.

2. **Intermedio (2-6 meses)**: Headless CMS: Contentful (content modelling, entries, assets, locales), Strapi (Content Types Builder, Users & Permissions, API tokens, media library), Sanity (schemas, Sanity Studio, GROQ queries). Content modeling: definición de tipos de contenido (article, product, landing_page), campos (string, rich text, image, reference, array, block), validaciones. APIs: RESTful endpoints, queries paramétricas, GraphQL endpoints. Frontend integration: consumir headless CMS con Next.js (getStaticProps, getServerSideProps, ISR), Gatsby (source plugins, GraphQL layer), Astro. Static Site Generation: generar HTML estático desde CMS content (Gatsby, Next.js SSG, Astro). Draft & Preview modes: content preview antes de publicación (Next.js Preview Mode, Contentful preview). Webhooks: triggers cuando contenido cambia (re-build estático, invalidación de caché CDN), automatización de deploys. Media optimization: Cloudinary, Imgix, responsive images, WebP/AVIF, lazy loading. SEO avanzado: Yoast/RankMath (WordPress), schema.org structured data (JSON-LD), Open Graph, sitemaps. CDN optimization para contenido: Cloudflare, Fastly, Vercel Edge.
   - Proyecto: Headless CMS (Strapi/Sanity) + Next.js frontend. Content model para blog + productos. Preview + deploy automático en Vercel. Image optimization con Cloudinary.
   - Lectura: "Modern Content Management Systems" (various), Contentful/Strapi docs, Next.js docs.

3. **Avanzado (6-12 meses)**: DXP (Digital Experience Platform): Sitecore (Experience Editor, Personalization, xConnect, xDB, SXA), AEM (AEM Sites, Components, Templates, Content Fragments, Experience Fragments, Launches, MSM). Personalization: segment-based content (auditorías, comportamiento), A/B testing, recommendation engines, user journey analytics. Multi-site and multi-language management: MSM (Multi-Site Manager) en AEM, language fallback, translation workflows, localized URLs. DAM (Digital Asset Management): asset metadata, renditions, dynamic media, smart crop, AI tagging, brand guidelines. Performance optimization: caching strategy (CDN, application cache, Redis), lazy loading, critical CSS, code splitting, lighthouse scoring. Custom development: WordPress custom plugin development (hooks, filters, shortcodes, custom post types, custom fields ACF), Drupal custom module (Routing, Controllers, Forms, Entities), AEM Core Components extensión. Content-as-a-Service: API-first content delivery, federated content, content mesh, edge-side rendering (Vercel Edge Functions). Accessibility (a11y): WCAG 2.1 AA compliance, semantic HTML, ARIA attributes, keyboard navigation.
   - Proyecto: Site personalizado multi-idioma con WordPress + WPML. DXP proof-of-concept con Sitecore o AEM (licencia trial). Headless CMS con personalización por segmento.
   - Certificación: Sitecore Certified Developer, Adobe Certified Expert (AEM), WordPress Certified Developer.

4. **Experto (12+ meses)**: Composable CMS / MACH Alliance: arquitectura CMS compuesta por microservicios (Contentful + Algolia + commercetools + Vercel + Fastly). Enterprise CMS migration: migración de contenido desde CMS legacy (WordPress) a headless (Contentful/Strapi/Sanity) con scripts ETL, data mapping, content transformation. AI in CMS: AI-powered content generation (GPT-4 integration for content creation), AI content tagger, automated translation, content summarization, SEO optimization con AI. Content operations at scale: content governance & workflows, approval matrices, audit trails, compliance (GDPR content deletion, accessibility compliance). Edge CMS: Vercel + Contentful/Sanity, contenido servido en edge (ISR + CDN), distributed content mesh. Content Federation: unificación de contenido desde múltiples CMS/headless en un endpoint GraphQL unificado (Apollo Federation, GraphQL Mesh). CMS security: WordPress hardening (WAF, login protection, plugin vulnerability scanning, 2FA, file permissions, database prefix, salts). CMS in the age of generative AI: AI-assisted editorial workflows, personalized content generation, dynamic content optimization.
   - Proyecto: MACH architecture: Contentful + Next.js + GraphQL + Fastly + commercetools. AI content generation plugin for WordPress/Contentful. CMS migration plan and execution.
   - Certificación: Sitecore Certified Architect, AEM Architect, MACH Alliance certification.
   - Lectura: "Composable DXP" (MACH Alliance), "Sitecore 10 Foundations", "Adobe Experience Manager Architect".

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [002-Frameworks](../002-Frameworks/) | Frameworks frontend (Next.js, Gatsby, Astro) consumen headless CMS |
| [003-Databases](../003-Databases/) | DB subyacente para contenido (MySQL, PostgreSQL, JCR) |
| [005-Cloud](../005-Cloud/) | CMS hosting (WP Engine, Pantheon, Vercel, Cloudinary) |
| [008-Networking](../008-Networking/) | CDN, caching, edge delivery, DNS |
| [009-Security](../009-Security/) | WordPress hardening, WAF, content security |
| [010-Architecture](../010-Architecture/) | Composable vs tradicional, headless vs coupled |
| [021-Ecommerce](../021-Ecommerce/) | WooCommerce + WordPress, CMS + e-commerce |
| [026-Web](../026-Web/) | CMS como base de la web moderna |
| [031-AI](../031-AI/) | AI content generation, personalization, smart tagging |
| [032-MachineLearning](../032-MachineLearning/) | Content recommendations, personalization models |

## Recursos recomendados

- **Plataformas**: WordPress.org (auto-hosted), Contentful (headless SaaS), Strapi (open source headless), Sanity (composable), Sitecore (DXP), AEM (enterprise DXP).
- **Libros**: "WordPress: The Missing Manual" (MacDonald), "Modern WordPress Development" (Eisinger), "Strapi Headless CMS", "Contentful: A Practical Guide".
- **Cursos**: WordPress Academy (learn.wordpress.org), Contentful Academy, Strapi/Next.js tutorials, Sitecore Learning Hub, AEM Adobe Experience League.
- **Comunidad**: WordPress Slack, Drupal Community, Strapi Discord, Contentful Community Forum, Sitecore Community.
- **Estándares**: WCAG 2.1, schema.org, Open Graph, AMP, PWA, Core Web Vitals, MACH Alliance.

## Notas adicionales

WordPress es la opción más accesible y con mayor ecosistema (plugins + themes + comunidad). Headless CMS (Contentful, Strapi, Sanity) es la elección moderna para equipos de desarrollo que quieren libertad de frontend. DXP (Sitecore, AEM) es para empresas que necesitan personalización y analítica avanzada. La tendencia de composable DXP (MACH) está reemplazando a los CMS monolíticos enterprise. La integración de IA generativa en CMS es la tendencia más transformadora actual. Para desarrolladores, Strapi (Node.js open source) y Contentful (SaaS) son los puntos de entrada más recomendados.
