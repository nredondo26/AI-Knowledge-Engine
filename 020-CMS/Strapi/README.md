# Strapi — CMS Headless de Código Abierto

## Visión General

Strapi es un CMS headless (sin frontend acoplado) construido con Node.js y React. Fundado en 2015, permite a desarrolladores y creadores de contenido gestionar contenido estructurado mediante una API REST o GraphQL generada automáticamente. Utiliza una arquitectura de plugins y un panel de administración altamente personalizable.

## Arquitectura Técnica

```
┌──────────────────────────────────────────────────┐
│          Panel de Administración (React)          │
│  Content Manager · Content Type Builder · Media  │
├──────────────────────────────────────────────────┤
│          Strapi Server (Node.js / Koa)            │
│  Core Bootstrap · Middleware · Lifecycles        │
├──────────────────────────────────────────────────┤
│      Capa de API (REST + GraphQL)                 │
│  Controladores · Servicios · Políticas            │
├──────────────────────────────────────────────────┤
│     Base de Datos (PostgreSQL / MySQL / SQLite)   │
│  ORM: Knex.js · Modelos dinámicos                 │
└──────────────────────────────────────────────────┘
```

## Estructura del Proyecto Strapi

```
my-strapi-project/
├── config/
│   ├── admin.js
│   ├── api.js
│   ├── database.js
│   ├── middlewares.js
│   └── plugins.js
├── database/
│   └── migrations/
├── public/
│   └── uploads/
├── src/
│   ├── admin/
│   │   ├── app.js
│   │   └── extensions/
│   ├── api/
│   │   └── proyecto/
│   │       ├── controllers/
│   │       ├── routes/
│   │       ├── services/
│   │       ├── content-types/
│   │       ├── policies/
│   │       └── middlewares/
│   ├── extensions/
│   ├── middlewares/
│   └── plugins/
├── package.json
├── .env
└── .strapi/
```

## Modelo de Contenido — Content Types

```json
// src/api/proyecto/content-types/proyecto/schema.json
{
  "kind": "collectionType",
  "collectionName": "proyectos",
  "info": {
    "singularName": "proyecto",
    "pluralName": "proyectos",
    "displayName": "Proyecto",
    "description": "Gestión de proyectos empresariales"
  },
  "options": {
    "draftAndPublish": true,
    "increments": true,
    "timestamps": true
  },
  "pluginOptions": {},
  "attributes": {
    "titulo": {
      "type": "string",
      "required": true,
      "maxLength": 200,
      "minLength": 3
    },
    "descripcion": {
      "type": "richtext",
      "required": true
    },
    "presupuesto": {
      "type": "decimal",
      "required": true,
      "min": 0,
      "default": 0
    },
    "fecha_inicio": {
      "type": "date",
      "required": true
    },
    "activo": {
      "type": "boolean",
      "default": true
    },
    "categoria": {
      "type": "relation",
      "relation": "manyToOne",
      "target": "api::categoria.categoria",
      "inversedBy": "proyectos"
    },
    "equipo": {
      "type": "relation",
      "relation": "manyToMany",
      "target": "api::miembro.miembro",
      "mappedBy": "proyectos"
    },
    "documentos": {
      "type": "media",
      "multiple": true,
      "required": false,
      "allowedTypes": ["images", "files", "videos"]
    },
    "metadata": {
      "type": "json",
      "default": {}
    }
  }
}
```

## Controladores y Servicios

```javascript
// src/api/proyecto/controllers/proyecto.js
'use strict';

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::proyecto.proyecto', ({ strapi }) => ({
  // Sobrescribir método find personalizado
  async find(ctx) {
    const user = ctx.state.user;

    // Filtro por usuario autenticado
    if (user) {
      ctx.query = {
        ...ctx.query,
        filters: {
          ...ctx.query.filters,
          owner: user.id
        }
      };
    }

    const { data, meta } = await super.find(ctx);

    // Enriquecer respuesta con cálculos
    const enrichedData = data.map(proyecto => ({
      ...proyecto,
      attributes: {
        ...proyecto.attributes,
        presupuestoFormateado: new Intl.NumberFormat('es-ES', {
          style: 'currency',
          currency: 'EUR'
        }).format(proyecto.attributes.presupuesto),
        duracionEstimada: calcularDuracion(
          proyecto.attributes.fecha_inicio,
          proyecto.attributes.fecha_fin
        )
      }
    }));

    return { data: enrichedData, meta };
  },

  // Endpoint custom
  async presupuestoTotal(ctx) {
    const proyectos = await strapi.db.query('api::proyecto.proyecto').findMany({
      select: ['presupuesto']
    });

    const total = proyectos.reduce((sum, p) =>
      sum + parseFloat(p.presupuesto || 0), 0
    );

    return { total, moneda: 'EUR', count: proyectos.length };
  }
}));

function calcularDuracion(inicio, fin) {
  if (!inicio || !fin) return null;
  const start = new Date(inicio);
  const end = new Date(fin);
  const diff = Math.abs(end - start);
  return Math.ceil(diff / (1000 * 60 * 60 * 24));
}
```

```javascript
// src/api/proyecto/services/proyecto.js
'use strict';

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::proyecto.proyecto', ({ strapi }) => ({
  // Hook after create
  async afterCreate(event) {
    const { result } = event;

    // Enviar notificación
    await strapi.plugin('email').service('email').send({
      to: 'admin@empresa.com',
      subject: `Nuevo proyecto: ${result.titulo}`,
      template: 'nuevo-proyecto',
      data: { proyecto: result }
    });

    // Crear entrada en logging
    await strapi.db.query('api::auditoria.auditoria').create({
      data: {
        accion: 'CREACION_PROYECTO',
        entidad: 'proyecto',
        entidad_id: result.id,
        usuario: result.createdBy?.id,
        metadata: JSON.stringify(result)
      }
    });
  }
}));
```

## Rutas Personalizadas

```javascript
// src/api/proyecto/routes/proyecto.js
'use strict';

const { createCoreRouter } = require('@strapi/strapi').factories;

module.exports = createCoreRouter('api::proyecto.proyecto', {
  config: {
    find: {
      middlewares: ['api::proyecto.presupuesto-filter'],
      policies: ['global::is-authenticated']
    },
    findOne: {
      policies: ['api::proyecto.is-owner']
    },
    create: {
      policies: ['global::is-admin']
    }
  }
});

// Rutas adicionales
module.exports = {
  routes: [
    {
      method: 'GET',
      path: '/proyectos/presupuesto-total',
      handler: 'proyecto.presupuestoTotal',
      config: {
        policies: [],
        middlewares: []
      }
    },
    {
      method: 'POST',
      path: '/proyectos/:id/asignar-equipo',
      handler: 'proyecto.asignarEquipo',
      config: {
        policies: ['global::is-admin']
      }
    }
  ]
};
```

## Middlewares Personalizados

```javascript
// src/api/proyecto/middlewares/presupuesto-filter.js
'use strict';

module.exports = (config, { strapi }) => {
  return async (ctx, next) => {
    const { min, max } = ctx.query;

    if (min || max) {
      ctx.query.filters = {
        ...ctx.query.filters,
        presupuesto: {
          ...(min && { $gte: parseFloat(min) }),
          ...(max && { $lte: parseFloat(max) })
        }
      };

      delete ctx.query.min;
      delete ctx.query.max;
    }

    await next();
  };
};
```

## Políticas de Seguridad

```javascript
// src/api/proyecto/policies/is-owner.js
'use strict';

module.exports = async (policyContext, config, { strapi }) => {
  const { id } = policyContext.params;
  const userId = policyContext.state.user?.id;

  if (!userId) return false;

  const proyecto = await strapi.db.query('api::proyecto.proyecto').findOne({
    where: { id },
    populate: ['owner']
  });

  return proyecto?.owner?.id === userId;
};
```

## GraphQL en Strapi

```graphql
# Query GraphQL con Strapi
query ProyectosAvanzados {
  proyectos(
    filters: {
      presupuesto: { gte: 100000 }
      activo: { eq: true }
    }
    sort: "presupuesto:desc"
    pagination: { limit: 10, start: 0 }
    publicationState: LIVE
  ) {
    data {
      id
      attributes {
        titulo
        presupuesto
        fecha_inicio
        categoria {
          data {
            attributes {
              nombre
            }
          }
        }
        equipo {
          data {
            attributes {
              nombre
              email
            }
          }
        }
      }
    }
    meta {
      pagination {
        total
        page
        pageSize
      }
    }
  }
}
```

## Webhooks de Strapi

```javascript
// Configuración de webhook en config/server.js
module.exports = ({ env }) => ({
  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 1337),
  webhooks: {
    defaultHeaders: {
      'X-Strapi-Event': ''
    },
    retry: 3
  }
});
```

Payload del webhook:

```json
{
  "event": "entry.create",
  "model": "proyecto",
  "entry": {
    "id": 1,
    "titulo": "Migración Cloud",
    "presupuesto": 150000,
    "activo": true
  }
}
```

## Despliegue con Docker

```yaml
# docker-compose.yml
version: '3.8'
services:
  strapi:
    image: strapi/strapi:4.25
    environment:
      NODE_ENV: production
      DATABASE_CLIENT: postgres
      DATABASE_HOST: db
      DATABASE_PORT: 5432
      DATABASE_NAME: strapi
      DATABASE_USERNAME: strapi
      DATABASE_PASSWORD: secret
      JWT_SECRET: ${JWT_SECRET}
      ADMIN_JWT_SECRET: ${ADMIN_JWT_SECRET}
      APP_KEYS: ${APP_KEYS}
      API_TOKEN_SALT: ${API_TOKEN_SALT}
    ports:
      - "1337:1337"
    volumes:
      - strapi-uploads:/app/public/uploads
      - ./config:/app/config
      - ./src:/app/src
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:16
    environment:
      POSTGRES_DB: strapi
      POSTGRES_USER: strapi
      POSTGRES_PASSWORD: secret
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  strapi-uploads:
  postgres-data:
```

## Buenas Prácticas

1. **Versionado** — Usar migraciones de base de datos para cambios en modelos de contenido.
2. **Cache** — Implementar CDN y Redis para las consultas API más frecuentes.
3. **Seguridad** — Configurar roles y permisos con Users & Permissions plugin.
4. **Backups** — Automatizar backup de base de datos y carpeta `public/uploads`.
5. **Rendimiento** — Deshabilitar populate automáticos y especificar campos necesarios en queries.
6. **Testing** — Usar Jest con supertest para tests de integración de endpoints.
7. **Plugins** — Desarrollar funcionalidad reutilizable como plugins internos.
