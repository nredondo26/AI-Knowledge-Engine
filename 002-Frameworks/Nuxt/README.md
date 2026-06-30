# Nuxt

## Descripción

Nuxt es un meta-framework construido sobre Vue 3 que simplifica el desarrollo de aplicaciones universales. Proporciona SSR, SSG, auto-importación de componentes, enrutamiento basado en archivos, capa de datos con `useFetch`/`$fetch`, y un sistema de módulos extensible. Nuxt 3 usa Nitro como servidor backend, Vite como bundler y Vue 3 con Composition API.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Routing basado en archivos** | El sistema de archivos en `pages/` define las rutas automáticamente. |
| **Auto-importación** | Componentes, composables y utilidades se importan automáticamente. |
| **Nitro** | Servidor cross-platform (Node, Deno, Cloudflare Workers). |
| **Data fetching** | `useFetch`, `useAsyncData`, `$fetch` con SSR automático. |
| **Módulos** | Extienden Nuxt con funcionalidades (Auth, Pinia, Tailwind, i18n). |
| **Layouts** | Plantillas reutilizables que envuelven páginas. |

---

## Ejemplos de código

### Página con data fetching

```vue
<!-- pages/index.vue -->
<script setup lang="ts">
const { data: usuarios, pending, error } = await useFetch(
  'https://jsonplaceholder.typicode.com/users'
);
</script>

<template>
  <div>
    <h1>Usuarios</h1>
    <p v-if="pending">Cargando...</p>
    <p v-else-if="error">Error: {{ error }}</p>
    <ul v-else>
      <li v-for="u in usuarios" :key="u.id">{{ u.name }} — {{ u.email }}</li>
    </ul>
  </div>
</template>
```

### Endpoint API

```typescript
// server/api/posts/[slug].ts
export default defineEventHandler(async (event) => {
  const slug = getRouterParam(event, 'slug');
  const posts = [
    { slug: 'nuxt-3', title: 'Nuxt 3', content: 'Guía de Nuxt 3' }
  ];
  const post = posts.find((p) => p.slug === slug);
  if (!post) throw createError({ statusCode: 404 });
  return post;
});
```

### Layout y middleware

```vue
<!-- layouts/admin.vue -->
<template>
  <div class="admin-layout">
    <aside><NuxtLink to="/dashboard">Dashboard</NuxtLink></aside>
    <main><slot /></main>
  </div>
</template>
```

```typescript
// middleware/auth.ts
export default defineNuxtRouteMiddleware((to) => {
  const token = useCookie('token');
  if (!token.value && to.path !== '/login') return navigateTo('/login');
});
```

---

## Hoja de ruta

```
1. Vue 3 Composition API (ref, reactive, computed, watch)
2. Fundamentos Nuxt (nuxi, pages/, routing, layouts)
3. Data fetching (useFetch, useAsyncData, $fetch, caché)
4. Nitro (server/api/, server/middleware/, adaptadores)
5. Estado (useState, Pinia, useCookie)
6. Módulos (UI, i18n, Tailwind, Auth, SEO)
7. SEO y rendimiento (useHead, route rules, NuxtImg)
8. Testing (Vitest + @nuxt/test-utils)
```
