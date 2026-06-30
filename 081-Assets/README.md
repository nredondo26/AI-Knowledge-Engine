# 081-Assets: Recursos Gráficos

## Descripción del dominio

Los assets o recursos gráficos son todos los elementos visuales que componen la interfaz y la identidad de un producto digital: logos, iconos, tipografías, imágenes, animaciones y archivos multimedia. Una gestión eficiente de assets es crítica para mantener consistencia visual, optimizar rendimiento y escalar el diseño en equipos multidisciplinarios.

## Conceptos clave

- **Design System**: Sistema unificado de componentes, estilos y assets reutilizables
- **SVG**: Formato vectorial escalable, ideal para iconos y logos
- **Sprite Sheet**: Hoja única que combina múltiples imágenes pequeñas para reducir peticiones HTTP
- **Responsive Images**: Técnicas de adaptación de imágenes a diferentes tamaños de pantalla (srcset, picture)
- **CDN for Assets**: Distribución de assets estáticos mediante redes de entrega de contenido
- **Lazy Loading**: Carga diferida de imágenes y multimedia para mejorar rendimiento
- **WebP / AVIF**: Formatos modernos de imagen con mejor compresión que PNG y JPEG
- **Favicon**: Icono de sitio web en múltiples tamaños y formatos
- **Icon Fonts**: Conjuntos de iconos tipográficos (Font Awesome, Material Icons)
- **Brand Guidelines**: Documento que define el uso correcto de colores, tipografías y assets de marca
- **Asset Pipeline**: Proceso de transformación, optimización y empaquetado de recursos

## Tecnologías principales

| Herramienta | Propósito |
|-------------|-----------|
| Figma | Diseño colaborativo de interfaces y exportación de assets |
| Adobe XD / Sketch | Alternativas para diseño de UI y gestión de assets |
| Inkscape | Editor SVG gratuito y open-source |
| ImageOptim | Compresión de imágenes sin pérdida de calidad |
| SVGO | Optimizador de archivos SVG para producción |
| Squoosh | Herramienta web de compresión y conversión de imágenes |
| Sharp | Librería Node.js para procesamiento de imágenes |
| Vite / Webpack Asset Modules | Bundling de assets en aplicaciones web |
| Storybook | Desarrollo aislado de componentes y visualización de assets |
| Cloudinary / imgix | Servicios cloud de gestión y transformación de imágenes |

## Hoja de ruta

**Nivel Principiante:**
1. Aprender formatos de imagen (PNG, JPEG, GIF, SVG, WebP)
2. Crear y exportar iconos SVG desde Figma
3. Optimizar imágenes con ImageOptim o Squoosh
4. Implementar favicon completo para web

**Nivel Intermedio:**
1. Diseñar un sprite sheet de iconos
2. Configurar responsive images con srcset y sizes
3. Implementar lazy loading nativo con loading="lazy"
4. Usar SVGO en pipeline de build para optimizar SVG

**Nivel Avanzado:**
1. Crear un design system completo con Storybook
2. Implementar asset pipeline automatizado con Vite
3. Diseñar estrategia de CDN con versionado de assets
4. Optimizar Core Web Vitals (LCP) mediante carga priorizada de assets

## Relaciones con otros módulos

- `../026-Web/` — Assets en aplicaciones web y rendimiento
- `../025-Mobile/` — Assets adaptados a plataformas móviles (iOS/Android)
- `../046-BestPractices/` — Buenas prácticas de optimización visual
- `../095-Performance/` — Impacto de assets en rendimiento y LCP
- `../052-Standards/` — Estándares de formatos de imagen y accesibilidad
- `../075-IDEs/` — Plugins de diseño y assets para IDEs

## Recursos recomendados

- [Google Web Fundamentals: Images](https://web.dev/learn/images/) — Guía completa de imágenes web
- [A Complete Guide to SVG](https://css-tricks.com/a-complete-guide-to-svg/) — Tutorial exhaustivo de SVG
- [Font Awesome](https://fontawesome.com) — Biblioteca de iconos más popular
- [Heroicons](https://heroicons.com) — Iconos SVG gratuitos del equipo de Tailwind
- [Unsplash](https://unsplash.com) — Banco de imágenes libres de derechos
- [Figma Community Assets](https://www.figma.com/community) — Assets y templates compartidos
- Libro: "Design Systems" — Alla Kholmatova
