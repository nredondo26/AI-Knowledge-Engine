# 021-Ecommerce: Comercio Electrónico

## Descripción ampliada del dominio

El comercio electrónico (e-commerce) comprende la compra y venta de bienes y servicios a través de plataformas digitales. Este módulo cubre plataformas de e-commerce (Magento, Shopify, WooCommerce, BigCommerce), arquitectura de tiendas online, gestión de productos, carrito de compras, procesamiento de pagos, logística, fulfillment, marketing digital, analítica, y mejores prácticas. El mercado global de e-commerce superó los $6.3B en 2024 y se proyecta a $8B para 2027. Las plataformas líderes son Shopify (SaaS, ~10% market share), WooCommerce (WordPress plugin, ~3%), Magento/Adobe Commerce (enterprise), BigCommerce (mid-market), y Salesforce Commerce Cloud (B2C enterprise). La evolución del e-commerce: catálogos online estáticos (1990s, primera ola: Amazon, eBay) → plataformas monolíticas (2000s, Magento, osCommerce) → SaaS e-commerce (2010s, Shopify, BigCommerce, Salesforce Commerce) → Headless/Composable Commerce (2018+, API-first, MACH) → Unified Commerce (2020+, omnicanal: online + physical + mobile + social).

## Tabla de conceptos clave

| Concepto | Descripción | Tecnologías/Estándares |
|----------|-------------|----------------------|
| Plataforma e-commerce | Software para operar tienda online | Shopify, Magento, WooCommerce, BigCommerce |
| Headless Commerce | Frontend separado del backend e-commerce via API | Shopify Hydrogen, Magento PWA, commercetools |
| PWA (Progressive Web App) | App web con funcionalidades nativas para e-commerce | Vue Storefront, Magento PWA Studio, Shopware PWA |
| Composable Commerce | Arquitectura MACH: Microservicios + API-first + Cloud-native + Headless | commercetools, Elastic Path, Saleor |
| Product Catalog | Gestión de productos, variantes, SKUs, categorías, atributos | PIM (Akeneo, Pimcore, inRiver) |
| Cart & Checkout | Carrito de compras, proceso de pago, guest checkout | Shopify Checkout, custom checkout (Stripe Elements) |
| Payment Gateway | Procesamiento de pagos online | Stripe, Adyen, PayPal, Square, Mercado Pago |
| OMS (Order Management) | Gestión de pedidos, fulfillment, envíos, devoluciones | Shopify OMS, CommerceTools, Fluent Commerce |
| WMS (Warehouse Mgmt) | Gestión de almacenes, pick/pack/ship | Manhattan, SAP EWM, Fishbowl |
| PIM (Product Info Mgmt) | Gestión centralizada de información de producto | Akeneo, Pimcore, TradeGecko |
| SEO E-commerce | Optimización para buscadores en tiendas online | Schema.org Product, Google Shopping feed, reviews |
| Conversión Rate | Porcentaje de visitantes que completan compra | CRO (Conversion Rate Optimization), A/B testing |

## Tecnologías principales

| Plataforma | Tipo | Licencia | Lenguaje | DB | Cloud/Self | Ideal para |
|------------|------|----------|----------|-----|------------|------------|
| Shopify | SaaS | SaaS (mensual + %) | Liquid + JS | Cloud (managed) | Cloud | SMB a Mid-market, dropshipping |
| WooCommerce | Plugin WordPress | Open Source (GPL) | PHP + JS | MySQL | Self-hosted / Cloud | SMB, WordPress users, customización |
| Magento (Adobe Commerce) | Plataforma | Open Source / Enterprise | PHP + JS | MySQL/MariaDB | Self / Cloud | Enterprise, B2B, alta customización |
| BigCommerce | SaaS | SaaS | Twig + JS | Cloud | Cloud | Mid-market, B2B, multichannel |
| Salesforce Commerce Cloud | SaaS (multi-tenant) | SaaS | ISML + JS | Cloud | Cloud | Enterprise B2C, grandes marcas |
| commercetools | Headless (MACH) | SaaS (API) | Java/Kotlin | Cloud | Cloud | Enterprise headless, composable |
| Shopware | Plataforma | Open Source / SaaS | PHP + Vue.js | MySQL | Self / Cloud | Mid-market (Strong en Europa) |
| Saleor | Headless | Open Source (BSD) | Python + GraphQL | PostgreSQL | Self / Cloud | Custom headless, mid-market |
| VTEX | SaaS | SaaS | VTEX IO (JS) | Cloud | Cloud | Enterprise, B2B + B2C, Latin America |
| Medusa | Headless | Open Source (MIT) | Node.js + Express | PostgreSQL | Self / Cloud | Custom e-commerce headless |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos e-commerce: tipos (B2C, B2B, D2C, C2C, marketplace), modelos de negocio (direct-to-consumer, dropshipping, subscription, wholesale). Plataformas: Shopify (crear tienda, temas, productos, colecciones, descuentos, envíos, pagos, dominio), WooCommerce (instalar en WordPress, configurar productos, variantes, categorías, shipping zones, pagos). Productos: SKU, precio, inventario, variantes (talla, color), imágenes, descripciones, categorías. Órdenes: visualizar, procesar, enviar, marcar como completado. Pagos: configurar Stripe, PayPal. Envíos: zonas, tarifas, tracking. SEO básico: títulos, meta descripciones, URLs amigables, sitemap XML.
   - Proyecto: Crear tienda Shopify o WooCommerce con 10 productos + variantes + colecciones + shipping zones + payment gateway. Simular compra completa.
   - Lectura: "Shopify for Dummies", WooCommerce docs, "E-commerce 2023" (Laudon, Traver).

2. **Intermedio (2-6 meses)**: E-commerce avanzado: descuentos y promociones (códigos, % off, BOGO, free shipping, tiered pricing), impuestos (configuración, tax rates, VAT/GST), shipping avanzado (zonas, carriers, tracking, multicurrency). Marketplace integration: Amazon (Amazon Marketplace Web Service), eBay (API), Google Shopping (feed management, Merchant Center). Marketing automation: email marketing (abandoned cart, welcome series, post-purchase), retargeting (Meta Pixel, Google Ads), social media integration (Instagram Shopping, Pinterest). Analytics: Google Analytics 4, e-commerce tracking (purchase events, add_to_cart, view_item), conversion funnels, customer lifetime value (CLV/ LTV). SEO avanzado: schema.org/Product structured data, Google Shopping feed optimization, canonical tags, hreflang for multi-language. Checkout optimization: guest checkout, one-page checkout, express checkout (Shop Pay, Apple Pay, Google Pay). Customer service: returns & refunds management, order tracking portal, live chat integration.
   - Proyecto: Shopify/WooCommerce con descuentos avanzados, Google Shopping feed, Google Analytics 4 + enhanced e-commerce, multi-currency, abandoned cart email.
   - Certificación: Shopify Partner Academy, Google Digital Garage e-commerce, WooCert.

3. **Avanzado (6-12 meses)**: Headless e-commerce: Shopify Hydrogen (React framework), Magento PWA Studio (Vue Storefront), commercetools (microservicios headless). Composable Commerce (MACH Alliance): API-first, microservicios, cloud-native, headless. Custom storefronts con Next.js + Shopify Storefront API / Magento GraphQL APIs. PIM integration: Akeneo PIM (product data syndication, enrichment, family, attribute groups, channels, locales). OMS (Order Management System): order orchestration (multi-warehouse, multi-vendor), dropshipping automation, returns management, rMA workflow. WMS integration: warehouse logistics, picking (wave, batch, zone), packing, shipping label generation. ERP integration: synchronize orders, inventory, customers, invoices con SAP, Oracle, Dynamics 365. B2B e-commerce: company accounts, tiered pricing, quote management, requisition lists, approval workflows, credit limits, invoice payment. Subscription e-commerce: recurring orders, subscription plans, billing cycles, product swaps (Recharge, Bold, Ordergroove). Multi-tenant marketplace: vendor management, commission calculation, vendor dashboard, marketplace payments (Stripe Connect, Adyen for Platforms). Tax automation: Avalara, TaxJar, Vertex (automated tax calculation, filing).
   - Proyecto: Headless storefront (Next.js + Shopify Storefront API + Algolia search). B2B store with company accounts and quote management. Multi-vendor marketplace.
   - Certificación: Shopify Certified Developer, Adobe Commerce Certified Developer, commercetools Certified.

4. **Experto (12+ meses)**: Enterprise e-commerce architecture: composable commerce with commercetools (project settings, tax categories, shipping methods, API extensions, subscriptions, audit log), Elastic Path (catalog, pricing, inventory, cart, orders, promotions). Unified Commerce: omnicanal integration (online + physical POS + mobile + social + marketplace), buy-online-pick-up-in-store (BOPIS), ship-from-store, endless aisle, real-time inventory visibility across channels. AI in e-commerce: product recommendations (AI-powered: frequently bought together, also viewed, personalized recommendations), visual search (search by image), AI copywriting (product descriptions), dynamic pricing (ML-based price optimization), demand forecasting (inventory planning), fraud detection (ML for transaction scoring). Performance optimization: CDN for product images (Cloudinary, Imgix, Fastly), Core Web Vitals optimization (LCP, FID, CLS), caching strategies (edge caching, storefront caching, API caching), image optimization (next-gen formats, lazy loading). Security: PCI DSS compliance (Stripe/Adyen reduce scope), fraud detection (Signifyd, Riskified), 3D Secure (EMV 3DS), session security, GDPR for customer data. Mobile commerce: mobile app (Shopify Mobile Buy SDK, custom Flutter/React Native app), mobile-optimized checkout, push notifications, wallet passes. Social commerce: TikTok Shop, Instagram Shopping, Pinterest Shopping, Facebook Shops.
   - Proyecto: Composable commerce on commercetools + Next.js + Algolia + Cloudinary + Stripe. AI product recommendations engine. Unified commerce: online + POS + mobile.
   - Certificación: commercetools Architect, Adobe Commerce Solution Architect, Salesforce Commerce Cloud B2C Architect.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | DB de productos, pedidos, clientes, inventario |
| [005-Cloud](../005-Cloud/) | Cloud hosting e-commerce (Shopify Cloud, Magento Cloud), CDN |
| [006-Containers](../006-Containers/) | Contenedores para custom e-commerce (Medusa, Saleor) |
| [008-Networking](../008-Networking/) | CDN, caching, DNS, WAF (protección DDoS) |
| [009-Security](../009-Security/) | PCI DSS, fraud detection, 3DS, data protection |
| [010-Architecture](../010-Architecture/) | Headless, composable, MACH, omnicanal |
| [018-ERP](../018-ERP/) | Integración ERP para pedidos, inventario, finanzas |
| [019-CRM](../019-CRM/) | Integración CRM para customer 360 |
| [020-CMS](../020-CMS/) | CMS para contenido de producto y marketing |
| [022-PaymentGateways](../022-PaymentGateways/) | Procesamiento de pagos en checkout |
| [025-Mobile](../025-Mobile/) | Mobile commerce apps, PWA, push notifications |
| [031-AI](../031-AI/) | Product recommendations, visual search, dynamic pricing |

## Recursos recomendados

- **Plataformas**: Shopify (shopify.com), WooCommerce (woocommerce.com), Magento/Adobe Commerce (commerce.adobe.com), BigCommerce (bigcommerce.com), commercetools (commercetools.com).
- **Libros**: "E-commerce 2023: Business, Technology, Society" (Laudon, Traver), "Shopify: The Ultimate Guide" (various), "Magento 2 Developer's Guide" (Gupta).
- **Cursos**: Shopify Partner Academy, Magento U (Adobe Digital Learning), "Headless Commerce" (MACH Alliance), Coursera "E-commerce" (University of Minnesota).
- **Estándares**: PCI DSS v4.0, EMV 3DS, ISO 27001 (e-commerce security), MACH Alliance, PWA standards.
- **Herramientas**: Google Analytics 4, Google Search Console, Google Merchant Center, Hotjar, Crazy Egg, VWO (A/B testing).

## Notas adicionales

Shopify es la plataforma más fácil para empezar y escalar. WooCommerce es ideal para quienes ya usan WordPress y quieren control total. Magento es el estándar enterprise, pero requiere más inversión técnica. El comercio headless/composable es la tendencia para empresas que necesitan experiencias de cliente únicas. La omnicanalidad (unified commerce) es la estrategia dominante. La IA está transformando el e-commerce: recomendaciones, búsqueda visual, creación de contenido y prevención de fraude.
