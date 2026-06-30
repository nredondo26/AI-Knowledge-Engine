# Rendimiento Web — Velocidad y Experiencia de Usuario

## Descripción General

El rendimiento web mide qué tan rápido se carga, renderiza y responde una página o aplicación. Impacta directamente en la experiencia de usuario (UX), conversión, SEO y accesibilidad. Google utiliza Core Web Vitals como métricas clave de rendimiento.

---

## Core Web Vitals

| Métrica | Descripción | Bueno | Malo |
|---------|-------------|-------|------|
| **LCP** (Largest Contentful Paint) | Tiempo del contenido principal visible | ≤ 2.5s | > 4s |
| **FID** (First Input Delay) / **INP** | Latencia de interacción del usuario | ≤ 100ms | > 300ms |
| **CLS** (Cumulative Layout Shift) | Estabilidad visual del layout | ≤ 0.1 | > 0.25 |
| **TTFB** (Time to First Byte) | Tiempo hasta primer byte del servidor | ≤ 800ms | > 1.8s |
| **FCP** (First Contentful Paint) | Primer contenido pintado | ≤ 1.8s | > 3s |

---

## Optimización de Assets

```html
<!-- Imágenes modernas -->
<picture>
  <source srcset="img.avif" type="image/avif" />
  <source srcset="img.webp" type="image/webp" />
  <img src="img.jpg" loading="lazy" decoding="async"
       width="800" height="600" alt="Descripción" />
</picture>

<!-- Fuentes optimizadas -->
<link rel="preload" href="/fonts/inter.woff2" as="font" crossorigin />
<style>
  @font-face {
    font-family: 'Inter';
    src: url('/fonts/inter.woff2') format('woff2');
    font-display: swap;
  }
</style>
```

---

## Code Splitting y Lazy Loading

```javascript
// Dynamic imports (React.lazy)
const Dashboard = React.lazy(() => import('./Dashboard'));

<Suspense fallback={<Spinner />}>
  <Dashboard />
</Suspense>

// Intersection Observer para lazy loading de componentes
function LazySection({ children }) {
    const ref = useRef(null);
    const [visible, setVisible] = useState(false);

    useEffect(() => {
        const observer = new IntersectionObserver(
            ([entry]) => { if (entry.isIntersecting) { setVisible(true); observer.disconnect(); } },
            { rootMargin: '200px' }
        );
        if (ref.current) observer.observe(ref.current);
        return () => observer.disconnect();
    }, []);

    return <div ref={ref}>{visible ? children : <Placeholder />}</div>;
}
```

---

## Bundle Size Optimization

```javascript
// Vite - manual chunks
export default defineConfig({
    build: {
        rollupOptions: {
            output: {
                manualChunks: {
                    vendor: ['react', 'react-dom'],
                    ui: ['@radix-ui/react-dialog', '@radix-ui/react-dropdown-menu'],
                }
            }
        }
    }
});

// Webpack - Bundle Analyzer
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');
module.exports = {
    plugins: [new BundleAnalyzerPlugin()]
};
```

```bash
# Analizar bundle
npx vite-bundle-analyzer
npx source-map-explorer dist/assets/*.js
```

---

## Caching Estratégico

```javascript
// Service Worker - Cache First para assets
self.addEventListener('fetch', (event) => {
    const { request } = event;
    if (request.url.match(/\.(js|css|png|woff2)$/)) {
        event.respondWith(caches.match(request).then(cached =>
            cached || fetch(request).then(response => {
                const clone = response.clone();
                caches.open('assets-v1').then(cache => cache.put(request, clone));
                return response;
            })
        ));
    }
});

// HTTP Caching headers
// Cache-Control: public, max-age=31536000, immutable (assets con hash)
// Cache-Control: public, max-age=3600, stale-while-revalidate=86400 (HTML)
```

---

## Server-Side Rendering (SSR)

```javascript
// Next.js - Route Segment Config
export const dynamic = 'force-dynamic';  // SSR
export const revalidate = 3600;          // ISR (Incremental Static Regeneration)

// Streaming SSR
export default function Page() {
    return (
        <Suspense fallback={<Skeleton />}>
            <SlowComponent />
        </Suspense>
    );
}
```

---

## Optimización de CSS

```css
/* Contener pintado */
.card {
  contain: layout style paint;
  content-visibility: auto;
  contain-intrinsic-size: 300px;
}

/* Will-change (usar con moderación) */
.animated-element {
  will-change: transform, opacity;
}

/* Evitar reflows */
.element {
  transform: translateX(100px);  /* GPU acelerado */
  /* NO: left: 100px; (causa reflow) */
}
```

---

## Network Optimization

```javascript
// Preconnect y Prefetch
<link rel="preconnect" href="https://api.ejemplo.com" />
<link rel="dns-prefetch" href="https://fonts.googleapis.com" />
<link rel="prefetch" href="/next-page" as="document" />

// Resource Hints en JS
const link = document.createElement('link');
link.rel = 'preload';
link.as = 'image';
link.href = '/hero.webp';
document.head.appendChild(link);
```

---

## Budgets de Rendimiento

```json
// performance-budget.json
{
  "performance": {
    "maxBundleSize": 200,
    "maxImageSize": 300,
    "maxFontSize": 50,
    "maxRequests": 25,
    "maxTimeToInteractive": 3000
  }
}
```

```javascript
// Lighthouse CI config
module.exports = {
    ci: {
        collect: { url: ['https://ejemplo.com'] },
        upload: { target: 'temporary-public-storage' },
        assert: {
            assertions: {
                'categories:performance': ['error', { minScore: 0.9 }],
                'max-total-blocking-time': ['error', { maxNumericValue: 200 }],
            }
        }
    }
};
```

---

## Monitoreo en Producción

```javascript
// Web Vitals library
import { onLCP, onFID, onCLS, onINP } from 'web-vitals';

onLCP((metric) => sendToAnalytics(metric));
onINP((metric) => sendToAnalytics(metric));
onCLS((metric) => sendToAnalytics(metric));
```

```bash
# RUM (Real User Monitoring): Google Analytics, Datadog RUM, New Relic
# Synthetic: Lighthouse CI, WebPageTest, Sitespeed.io
# Profiling: Chrome DevTools Performance tab
```

---

## Mejores Prácticas

1. **Medir antes de optimizar**: Siempre benchmarkear (Lighthouse, Web Vitals).
2. **Cargar solo lo necesario**: Code splitting, tree shaking, lazy loading.
3. **Imágenes responsive**: `srcset`, `sizes`, formatos AVIF/WebP.
4. **CDN y edge caching**: Distribuir contenido geográficamente.
5. **SSR/SSG**: Usar framework con rendering estratégico (Next.js, Nuxt, Astro).
6. **Budgets**: Establecer límites de bundle y adherirse con CI.

---

## Referencias

- [web.dev/learn-core-web-vitals](https://web.dev/learn-core-web-vitals)
- [WebPageTest](https://www.webpagetest.org)
- [Lighthouse](https://developer.chrome.com/docs/lighthouse)
- [Web Vitals Library](https://github.com/GoogleChrome/web-vitals)
- [BundlePhobia](https://bundlephobia.com)
