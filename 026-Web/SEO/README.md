# SEO — Optimización para Motores de Búsqueda

## Descripción General

SEO (Search Engine Optimization) es el conjunto de técnicas para mejorar la visibilidad y posicionamiento de un sitio web en los resultados orgánicos de buscadores como Google, Bing y DuckDuckGo. Abarca aspectos técnicos, de contenido y de autoridad.

---

## Pilares del SEO

1. **SEO Técnico**: Estructura, velocidad, indexabilidad, datos estructurados.
2. **SEO On-Page**: Contenido, palabras clave, meta tags, headings.
3. **SEO Off-Page**: Backlinks, autoridad de dominio, redes sociales.
4. **SEO Local**: Google My Business, reseñas, NAP consistency.

---

## Meta Tags Esenciales

```html
<title>Curso de JavaScript 2026 | Aprende JS desde cero</title>
<meta name="description" content="Aprende JavaScript desde cero con ejemplos prácticos. Curso actualizado 2026 con ES2024, async/await, DOM y más." />
<meta name="robots" content="index, follow" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="canonical" href="https://ejemplo.com/curso-js" />

<!-- Open Graph (Facebook, LinkedIn) -->
<meta property="og:title" content="Curso de JavaScript 2026" />
<meta property="og:description" content="Aprende JS desde cero" />
<meta property="og:image" content="https://ejemplo.com/img/curso-js.png" />
<meta property="og:type" content="website" />
<meta property="og:url" content="https://ejemplo.com/curso-js" />

<!-- Twitter Cards -->
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="Curso de JavaScript 2026" />
```

---

## Estructura de Encabezados

```html
<h1>Curso de JavaScript 2026</h1>
  <h2>Fundamentos</h2>
    <h3>Variables y tipos de datos</h3>
    <h3>Funciones</h3>
  <h2>DOM Manipulation</h2>
    <h3>Selectores</h3>
    <h3>Eventos</h3>
  <h2>Proyecto Final</h2>

<!-- Nunca: múltiples <h1>, saltar niveles -->
```

---

## Datos Estructurados (Schema.org)

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Course",
  "name": "Curso de JavaScript 2026",
  "description": "Aprende JavaScript desde cero con ejemplos prácticos.",
  "provider": {
    "@type": "Organization",
    "name": "Academia Web",
    "url": "https://ejemplo.com"
  },
  "educationalLevel": "Beginner",
  "teaches": ["JavaScript", "DOM", "Async/Await", "ES2024"],
  "timeRequired": "PT20H",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  }
}
</script>

<!-- Otros tipos comunes: Article, Product, FAQPage, BreadcrumbList, LocalBusiness -->
```

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "Inicio", "item": "https://ejemplo.com" },
    { "@type": "ListItem", "position": 2, "name": "Cursos", "item": "https://ejemplo.com/cursos" },
    { "@type": "ListItem", "position": 3, "name": "JavaScript" }
  ]
}
</script>
```

---

## SEO Técnico — robots.txt y Sitemap

```txt
# robots.txt
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/
Disallow: /*?sort=*
Sitemap: https://ejemplo.com/sitemap.xml
```

```xml
<!-- sitemap.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://ejemplo.com/</loc>
    <lastmod>2026-06-30</lastmod>
    <changefreq>monthly</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://ejemplo.com/curso-js</loc>
    <lastmod>2026-06-28</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.9</priority>
  </url>
</urlset>
```

---

## Velocidad y Core Web Vitals

```html
<!-- Carga de recursos crítica -->
<link rel="preload" href="/fonts/inter.woff2" as="font" crossorigin />
<link rel="preconnect" href="https://api.ejemplo.com" />

<!-- Lazy loading -->
<img src="foto.jpg" loading="lazy" alt="Descripción" />
<iframe loading="lazy" src="video.html"></iframe>

<!-- Critical CSS inline -->
<style>
  /* Estilos del above-the-fold */
</style>
```

| Métrica | Bueno | Mejorable | Malo |
|---------|-------|-----------|------|
| LCP | ≤ 2.5s | 2.5–4s | > 4s |
| FID/INP | ≤ 200ms | 200–500ms | > 500ms |
| CLS | ≤ 0.1 | 0.1–0.25 | > 0.25 |

---

## URLs Amigables

```
✅ /curso-javascript-2026
✅ /productos?categoria=electronica&page=2
❌ /p?id=123&cat=5&ref=abc
❌ /curso_javascript_2026?session=true

<!-- Estructura: corta, descriptiva, guiones, lowercase -->
```

---

## SEO para SPAs (Next.js/Nuxt)

```javascript
// Next.js App Router - Metadata API
export const metadata = {
    title: 'Curso JS 2026',
    description: 'Aprende JavaScript desde cero',
    openGraph: {
        title: 'Curso JS 2026',
        images: ['/img/og.png']
    },
    alternates: {
        canonical: 'https://ejemplo.com/curso-js'
    }
};

// Generate static params
export async function generateStaticParams() {
    const posts = await getPosts();
    return posts.map((post) => ({ slug: post.slug }));
}
```

---

## Monitoreo

```bash
# Google Search Console
# Bing Webmaster Tools
# Lighthouse (Performance + SEO audit)
# Screaming Frog (crawler técnico)
# Ahrefs / Semrush (keyword research, backlinks)
```

---

## Mejores Prácticas

1. **Contenido único y útil**: E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness).
2. **Velocidad**: Optimizar imágenes, minificar CSS/JS, CDN.
3. **Mobile-first**: Google indexa versión móvil desde 2020.
4. **HTTPS**: Obligatorio, señal de confianza.
5. **Internal linking**: Enlazar contenido relacionado con anchors descriptivos.
6. **Evitar contenido duplicado**: Canónico, redirecciones 301.

---

## Referencias

- [Google Search Central](https://developers.google.com/search/docs)
- [Schema.org](https://schema.org)
- [Web.dev SEO](https://web.dev/learn/seo)
- [Ahrefs Blog](https://ahrefs.com/blog)
