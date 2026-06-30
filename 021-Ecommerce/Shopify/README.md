# Shopify — Plataforma de Comercio Electrónico SaaS

## Visión General

Shopify es una plataforma de e-commerce SaaS fundada por Tobias Lütke en 2006. Permite crear tiendas online con modelo suscripción, ofreciendo hosting, checkout seguro (Shopify Payments), gestión de inventario, SEO y una amplia tienda de apps. Su motor de plantillas Liquid, la API REST/GraphQL y Shopify Functions permiten personalización profunda.

## Arquitectura Técnica

```
┌──────────────────────────────────────────────────┐
│             Tienda Online Storefront              │
│  Dawn Theme · Liquid Templates · Hydrogen/React  │
├──────────────────────────────────────────────────┤
│          Shopify Core (Ruby on Rails)             │
│   Checkout · Cart · Inventory · Orders · Pago    │
├──────────────────────────────────────────────────┤
│              Shopify Admin                        │
│  Dashboard · Productos · Clientes · Analytics    │
├──────────────────────────────────────────────────┤
│              APIs de Integración                  │
│  REST API · GraphQL Admin · Storefront · Webhooks│
└──────────────────────────────────────────────────┘
```

## Shopify Liquid — Motor de Plantillas

Liquid es el lenguaje de templates de Shopify, creado por Shopify mismo y ahora open source.

```liquid
{% layout 'theme' %}
{% assign productos_destacados = collections.frontpage.products %}

<section class="product-grid">
  <h1>{{ page_title }}</h1>

  {% paginate collections.all.products by 12 %}
    <div class="grid">
      {% for product in collections.all.products %}
        <div class="product-card">
          <a href="{{ product.url }}">
            <img
              src="{{ product.featured_image | image_url: width: 400 }}"
              alt="{{ product.title | escape }}"
              loading="lazy"
              width="400"
              height="400"
            >
            <h3>{{ product.title }}</h3>
            <p class="price">
              {% if product.compare_at_price > product.price %}
                <span class="compare-at">
                  {{ product.compare_at_price | money_with_currency }}
                </span>
              {% endif %}
              <span class="current">
                {{ product.price | money_with_currency }}
              </span>
            </p>

            {% if product.available %}
              <span class="badge badge-success">Disponible</span>
            {% else %}
              <span class="badge badge-danger">Agotado</span>
            {% endif %}
          </a>

          {% form 'product', product, class: 'add-to-cart-form' %}
            <input type="hidden" name="id" value="{{ product.selected_or_first_available_variant.id }}">
            <button type="submit" class="btn btn-primary"
              {% unless product.available %}disabled{% endunless %}>
              {% if product.available %}
                Añadir al carrito
              {% else %}
                Agotado
              {% endif %}
            </button>
          {% endform %}
        </div>
      {% else %}
        <p>No hay productos disponibles.</p>
      {% endfor %}
    </div>

    {% if paginate.pages > 1 %}
      <div class="pagination">
        {{ paginate | default_pagination }}
      </div>
    {% endif %}
  {% endpaginate %}
</section>
```

## Shopify GraphQL Admin API

```graphql
# Obtener productos con variantes e inventario
query ProductosInventario($first: Int!, $after: String) {
  products(first: $first, after: $after) {
    edges {
      node {
        id
        title
        vendor
        productType
        status
        totalInventory
        variants(first: 10) {
          edges {
            node {
              id
              title
              sku
              price
              inventoryQuantity
              inventoryItem {
                id
                tracked
                locations(first: 5) {
                  edges {
                    node {
                      id
                      name
                      quantity
                    }
                  }
                }
              }
            }
          }
        }
        images(first: 1) {
          edges {
            node {
              url(transform: { maxWidth: 400, maxHeight: 400 })
              altText
            }
          }
        }
      }
      cursor
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

```javascript
// Consulta GraphQL desde Node.js
const { shopifyApi, LATEST_API_VERSION } = require('@shopify/shopify-api');

async function getProducts(session) {
  const client = new shopifyApi.clients.Graphql({
    session,
    apiVersion: LATEST_API_VERSION
  });

  let allProducts = [];
  let hasNextPage = true;
  let cursor = null;

  while (hasNextPage) {
    const response = await client.query({
      data: {
        query: PRODUCTS_QUERY,
        variables: { first: 250, after: cursor }
      }
    });

    const { edges, pageInfo } = response.body.data.products;
    allProducts.push(...edges.map(e => e.node));
    hasNextPage = pageInfo.hasNextPage;
    cursor = pageInfo.endCursor;
  }

  return allProducts;
}
```

## Shopify Functions — Lógica Serverless

Shopify Functions permite personalizar descuentos, envíos, pagos y flujo de checkout usando WASM.

```rust
// Extensión de descuento con Shopify Functions (Rust)
use shopify_function::prelude::*;
use shopify_function::types::*;

generate_types!(
    src = "./input.graphql",
    query_path = "./input.graphql"
);

#[shopify_function_target]
fn discount(input: input::InputData) -> output::FunctionRunResult {
    let discounts = input.cart.lines.iter().filter_map(|line| {
        let product = line.merchandise.as_product().unwrap();
        let quantity = line.quantity;

        // Descuento por volumen: 10% si >= 5 unidades
        if quantity >= 5 {
            let percentage = 10.0;
            let target = output::DiscountTarget {
                cart_line: Some(output::CartLineTarget {
                    id: line.id.clone(),
                    quantity: Some(quantity),
                }),
                ..Default::default()
            };

            Some(output::Discount {
                message: Some(format!("10% de descuento por volumen")),
                targets: vec![target],
                value: output::DiscountValue {
                    percentage: Some(output::Percentage { value: percentage }),
                    ..Default::default()
                },
            })
        } else {
            None
        }
    }).collect();

    output::FunctionRunResult { discounts }
}
```

```graphql
// input.graphql para la Function
query Input {
  cart {
    lines {
      id
      quantity
      merchandise {
        __typename
        ... on ProductVariant {
          id
          product {
            id
            hasTags(tags: ["volumen-descuento"])
          }
        }
      }
    }
  }
  discountNode {
    metafield(namespace: "$app", key: "volume-discount-config") {
      value
    }
  }
}
```

## Shopify Webhooks

```javascript
// Manejo de webhooks con Express.js
const express = require('express');
const crypto = require('crypto');

const app = express();
const SHOPIFY_SECRET = process.env.SHOPIFY_WEBHOOK_SECRET;

app.post(
  '/webhooks/shopify',
  express.raw({ type: 'application/json' }),
  (req, res) => {
    const hmac = req.headers['x-shopify-hmac-sha256'];
    const topic = req.headers['x-shopify-topic'];
    const shop = req.headers['x-shopify-shop-domain'];

    // Verificar firma
    const computedHmac = crypto
      .createHmac('sha256', SHOPIFY_SECRET)
      .update(req.body)
      .digest('base64');

    if (computedHmac !== hmac) {
      return res.status(401).send('HMAC inválido');
    }

    const data = JSON.parse(req.body.toString());

    switch (topic) {
      case 'orders/create':
        handleNewOrder(data, shop);
        break;
      case 'products/update':
        handleProductUpdate(data, shop);
        break;
      case 'app/uninstalled':
        handleAppUninstall(shop);
        break;
      default:
        console.log(`Topic no manejado: ${topic}`);
    }

    res.status(200).send('OK');
  }
);
```

## Shopify Polaris — Sistema de Diseño

```jsx
// Componente React con Polaris
import {
  Page,
  Card,
  DataTable,
  Badge,
  Button,
  Toast,
  Frame,
  ResourceList,
  ResourceItem,
  TextStyle,
  Thumbnail
} from '@shopify/polaris';
import { useState, useCallback } from 'react';

export function ProductList({ products }) {
  const [selected, setSelected] = useState([]);

  const promotedBulkActions = [
    {
      content: 'Activar productos',
      onAction: () => bulkUpdateStatus('ACTIVE', selected)
    },
    {
      content: 'Archivar productos',
      onAction: () => bulkUpdateStatus('ARCHIVED', selected)
    }
  ];

  return (
    <Page title="Productos">
      <Card>
        <ResourceList
          resourceName={{ singular: 'producto', plural: 'productos' }}
          items={products}
          selectedItems={selected}
          onSelectionChange={setSelected}
          promotedBulkActions={promotedBulkActions}
          renderItem={(product) => (
            <ResourceItem
              id={product.id}
              accessibilityLabel={`Ver ${product.title}`}
            >
              <div style={{ display: 'flex', gap: '1rem' }}>
                <Thumbnail
                  source={product.images[0]?.url}
                  alt={product.title}
                  size="small"
                />
                <div>
                  <TextStyle variation="strong">{product.title}</TextStyle>
                  <div>
                    SKU: {product.variants[0]?.sku || 'N/A'}
                  </div>
                  <div>
                    <Badge status={product.status === 'ACTIVE' ? 'success' : 'warning'}>
                      {product.status}
                    </Badge>
                  </div>
                </div>
              </div>
            </ResourceItem>
          )}
        />
      </Card>
    </Page>
  );
}
```

## Shopify Hydrogen — Framework Headless

```jsx
// Componente en Hydrogen (Remix + React)
import {
  useShopQuery,
  useRouteParams,
  Seo,
  gql,
  CacheLong,
  flattenConnection,
} from '@shopify/hydrogen';
import {ProductCard} from '~/components/ProductCard';

export default function Collection() {
  const {handle} = useRouteParams();

  const {data} = useShopQuery({
    query: COLLECTION_QUERY,
    variables: {handle},
    cache: CacheLong(),
  });

  const collection = data.collection;
  const products = flattenConnection(collection.products);

  return (
    <div className="collection">
      <Seo type="collection" data={collection} />
      <h1>{collection.title}</h1>
      {collection.description && <p>{collection.description}</p>}
      <div className="product-grid">
        {products.map((product) => (
          <ProductCard product={product} key={product.id} />
        ))}
      </div>
    </div>
  );
}

const COLLECTION_QUERY = gql`
  query CollectionDetails($handle: String!) {
    collection(handle: $handle) {
      title
      description
      seo {
        title
        description
      }
      products(first: 48) {
        edges {
          node {
            id
            title
            handle
            priceRange {
              minVariantPrice {
                amount
                currencyCode
              }
            }
            images(first: 1) {
              edges {
                node {
                  url(transform: {maxWidth: 400})
                  altText
                }
              }
            }
          }
        }
      }
    }
  }
`;
```

## CLI de Shopify

```bash
# Instalación
npm install -g @shopify/cli @shopify/theme

# Iniciar proyecto Hydrogen
shopify hydrogen init my-store

# Desarrollar tema local
shopify theme dev --store=mystore.myshopify.com

# Desplegar tema
shopify theme push --store=mystore.myshopify.com

# Crear app
shopify app init my-app --template node
shopify app dev
shopify app deploy

# Comandos de producto
shopify product list --limit=50
shopify product create --title="Nuevo Producto" --price=29.99
```

## Buenas Prácticas

1. **API Rate Limits** — 40 solicitudes por segundo (REST) / 1000 puntos por consulta (GraphQL).
2. **Checkout extensible** — Usar Shopify Functions en lugar de checkout.liquid para personalizaciones.
3. **SEO** — Implementar metadatos estructurados (JSON-LD), sitemap.xml y robots.txt.
4. **Rendimiento** — Optimizar imágenes con `image_url` y CDN de Shopify. Minimizar Liquid.
5. **App Bridge** — Usar Shopify App Bridge para integraciones fluidas en el admin.
6. **Testing** — Usar `@shopify/jest-polaris` para componentes Polaris y QUnit para temas.
7. **Seguridad** — Storefront API con tokens públicos, Admin API con OAuth y tokens privados.
8. **Metafields** — Almacenar datos personalizados con metafields en lugar de modificar schema.
