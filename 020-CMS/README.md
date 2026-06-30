# 020-CMS: Sistemas de Gestión de Contenidos

## Descripción del dominio

Los Sistemas de Gestión de Contenidos (CMS) permiten crear, gestionar y publicar contenido digital sin requerir conocimientos técnicos profundos. Van desde plataformas tradicionales como WordPress hasta arquitecturas headless/decoupled donde el backend y frontend están separados. Los CMS modernos exponen APIs (REST, GraphQL) y se integran con frameworks JAMstack, CDNs y servicios en la nube. El mercado incluye soluciones open-source, SaaS y enterprise.

## Conceptos clave

- **CMS tradicional**: Sistema monolítico con frontend y backend acoplados (WordPress, Drupal)
- **Headless CMS**: Backend de contenido con API, frontend independiente (Strapi, Contentful, Sanity)
- **Decoupled CMS**: Variante híbrida con entrega de contenido via API pero con capacidades de renderizado
- **WYSIWYG**: Editor visual "What You See Is What You Get"
- **JAMstack**: Arquitectura con JavaScript, APIs y Markup pre-renderizado
- **API-first**: Diseño donde la API es el producto principal del CMS
- **Content modeling**: Definición de tipos de contenido, campos y relaciones
- **Versionado de contenido**: Historial de cambios y capacidad de rollback
- **Headless preview**: Vista previa en tiempo real del contenido en el frontend
- **Webhooks**: Notificaciones automáticas ante cambios de contenido
- **Digital Asset Management (DAM)**: Gestión centralizada de imágenes, vídeos y documentos
- **Multi-tenancy**: Soporte para múltiples sitios desde una sola instalación
- **Plugins/extensiones**: Ecosistema de módulos que extienden funcionalidades

## Tecnologías principales

- **WordPress**: CMS más usado del mundo (~43% de la web), PHP + MySQL, ecosistema masivo de plugins
- **Strapi**: Headless CMS open-source basado en Node.js, personalizable via API
- **Contentful**: Headless CMS SaaS con SDKs múltiples y potente content delivery network
- **Drupal**: CMS enterprise, robusto en seguridad y escalabilidad, usado por gobiernos
- **Sanity**: Headless CMS con editor en tiempo real y GROQ como lenguaje de consulta
- **Ghost**: CMS enfocado en publicaciones y suscripciones, Node.js
- **Joomla**: CMS tradicional con capacidades multilingüe nativas
- **Directus**: Headless CMS que envuelve cualquier base de datos SQL
- **Webiny**: CMS serverless sobre AWS, basado en React y Node.js
- **Prismic**: Headless CMS con slices y modelado visual
- **Magnolia**: CMS enterprise Java con capacidades de personalización
- **AEM (Adobe Experience Manager)**: Suite enterprise de gestión de experiencias digitales

## Hoja de ruta

1. **Principiante**: Comprender diferencias entre CMS tradicional y headless. Instalar WordPress, crear temas y plugins básicos. Publicar contenido con editores WYSIWYG.
2. **Intermedio**: Implementar Strapi o Directus como headless CMS. Conectar con frontend React/Next.js. Modelar tipos de contenido complejos con relaciones. Usar webhooks y APIs REST/GraphQL.
3. **Avanzado**: Arquitecturas multicapa con CDN, caching y preview. Integración con DAM y flujos de aprobación. Personalización de contenido basada en audiencias. Migraciones entre CMS. Implementar SSO y roles avanzados.
4. **Experto**: Diseñar CMS propio headless. Optimizar rendimiento de consultas GraphQL. Estrategias de federación de contenido entre múltiples CMS. Integración con IA para generación y tagging automático de contenido.

## Relaciones con otros módulos

- [Web](../026-Web/) — Frontend que consume contenido del CMS (Next.js, Nuxt, Gatsby)
- [Databases](../003-Databases/) — Almacenamiento persistente de contenido (MySQL, PostgreSQL, MongoDB)
- [Cloud](../005-Cloud/) — Despliegue, CDN, escalado automático del CMS
- [APIs](../079-APIs/) — REST y GraphQL para exponer contenido headless
- [Security](../009-Security/) — Autenticación, autorización, protección contra inyecciones
- [Architecture](../010-Architecture/) — Patrones de arquitectura headless, decoupled y JAMstack
- [DesignPatterns](../011-DesignPatterns/) — Patrones de composición y contenido

## Recursos recomendados

- [Strapi Documentation](https://docs.strapi.io)
- [Contentful Developer Center](https://www.contentful.com/developers/)
- [WordPress Developer Resources](https://developer.wordpress.org)
- [Ghost Docs](https://ghost.org/docs/)
- [Sanity.io Learn](https://www.sanity.io/learn)
- [Drupal API](https://api.drupal.org)
- "Modern CMS Architecture" — O'Reilly Media
- "Headless CMS: A definitive guide" — Contentful blog
