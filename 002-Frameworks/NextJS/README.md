# Next.js

## Descripción

Next.js es un framework de React para producción creado por Vercel. Ofrece renderizado híbrido (SSR, SSG, ISR, CSR), enrutamiento basado en el sistema de archivos, generación de API endpoints y optimización automática de assets. Desde la versión 13+, Next.js introdujo el **App Router** basado en React Server Components (RSC), cambiando radicalmente la forma de construir aplicaciones web.

Next.js es la opción dominante para sitios web modernos: landing pages, e-commerce, dashboards, blogs, aplicaciones full-stack y cualquier proyecto que necesite SEO, rendimiento y React.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **App Router** | Sistema de enrutamiento basado en `app/` con server components por defecto. |
| **Pages Router** | Sistema anterior basado en `pages/` (sigue soportado). |
| **Server Components (RSC)** | Componentes que se ejecutan y renderizan en el servidor. |
| **Client Components** | Componentes que se ejecutan en el navegador (con `"use client"`). |
| **Server Actions** | Funciones asíncronas que se ejecutan en el servidor, llamadas desde el cliente. |
| **SSR (Server-Side Rendering)** | Renderizado en cada petición. |
| **SSG (Static Site Generation)** | Renderizado en build time (páginas estáticas). |
| **ISR (Incremental Static Regeneration)** | Re-generación estática bajo demanda o por tiempo. |
| **Route Handlers** | Endpoints API dentro del App Router (`route.ts`). |
| **Middleware** | Código que se ejecuta antes de cada petición (edge). |
| **Layouts y Templates** | Layouts persistentes entre rutas; templates se re-montan. |
| **Loading UI y Suspense** | Estados de carga y streaming de contenido. |
| **Metadata API** | SEO y meta tags de forma declarativa. |

---

## Ejemplos de código

### App Router: layout y página

```tsx
// app/layout.tsx (layout raíz)
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Mi Tienda',
  description: 'Tienda online con Next.js',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body className={inter.className}>
        <nav>{/* Header */}</nav>
        <main>{children}</main>
        <footer>{/* Footer */}</footer>
      </body>
    </html>
  )
}
```

```tsx
// app/productos/page.tsx (SSR por defecto)
import { ProductoCard } from '@/components/ProductoCard'

interface Producto {
  id: string
  nombre: string
  precio: number
}

async function obtenerProductos(): Promise<Producto[]> {
  const res = await fetch('https://api.example.com/productos', {
    next: { revalidate: 60 }, // ISR cada 60s
  })
  return res.json()
}

export default async function ProductosPage() {
  const productos = await obtenerProductos()

  return (
    <div className="grid grid-cols-3 gap-4">
      {productos.map((p) => (
        <ProductoCard key={p.id} producto={p} />
      ))}
    </div>
  )
}
```

### Página dinámica con generación estática

```tsx
// app/productos/[id]/page.tsx
export async function generateStaticParams() {
  const productos = await fetch('https://api.example.com/productos').then(r => r.json())
  return productos.map((p: Producto) => ({ id: String(p.id) }))
}

async function obtenerProducto(id: string): Promise<Producto> {
  const res = await fetch(`https://api.example.com/productos/${id}`)
  if (!res.ok) throw new Error('Producto no encontrado')
  return res.json()
}

export default async function ProductoDetalle({ params }: { params: { id: string } }) {
  const producto = await obtenerProducto(params.id)

  return (
    <article>
      <h1>{producto.nombre}</h1>
      <p className="text-2xl font-bold">${producto.precio}</p>
    </article>
  )
}
```

### Client Component con estado

```tsx
'use client'

import { useState } from 'react'

export function CarritoButton({ productoId }: { productoId: string }) {
  const [agregado, setAgregado] = useState(false)

  async function agregarAlCarrito() {
    const res = await fetch('/api/carrito', {
      method: 'POST',
      body: JSON.stringify({ productoId }),
    })
    if (res.ok) setAgregado(true)
  }

  return (
    <button
      onClick={agregarAlCarrito}
      disabled={agregado}
      className="bg-blue-600 text-white px-4 py-2 rounded"
    >
      {agregado ? '✓ Agregado' : 'Agregar al carrito'}
    </button>
  )
}
```

### Server Action

```tsx
// app/productos/[id]/acciones.ts
'use server'

import { revalidatePath } from 'next/cache'
import { z } from 'zod'

const schema = z.object({
  nombre: z.string().min(1).max(200),
  precio: z.number().positive(),
})

export async function actualizarProducto(id: string, formData: FormData) {
  const data = schema.parse({
    nombre: formData.get('nombre'),
    precio: Number(formData.get('precio')),
  })

  await fetch(`https://api.example.com/productos/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })

  revalidatePath(`/productos/${id}`)
}
```

### Route Handler (API endpoint)

```tsx
// app/api/productos/route.ts
import { NextResponse } from 'next/server'

const productos = [
  { id: 1, nombre: 'Laptop', precio: 999.99 },
  { id: 2, nombre: 'Mouse', precio: 29.99 },
]

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url)
  const limit = Number(searchParams.get('limit')) || 10
  return NextResponse.json(productos.slice(0, limit))
}

export async function POST(request: Request) {
  const body = await request.json()
  const nuevo = { id: Date.now(), ...body }
  productos.push(nuevo)
  return NextResponse.json(nuevo, { status: 201 })
}
```

### Middleware para autenticación

```tsx
// middleware.ts
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value
  const { pathname } = request.nextUrl

  if (!token && pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/dashboard/:path*', '/admin/:path*'],
}
```

---

## Hoja de ruta

```
1. React sólido
   ├── Componentes, JSX, props, estado
   ├── Hooks (useState, useEffect, useContext)
   ├── Renderizado condicional y listas
   └── Server vs Client Components

2. Fundamentos de Next.js
   ├── create-next-app, estructura app/
   ├── Layouts, páginas, loading, error
   ├── Navegación con Link y useRouter
   └── Rutas dinámicas y catch-all

3. Estrategias de renderizado
   ├── Server Components (por defecto)
   ├── Static Site Generation (SSG)
   ├── Server-Side Rendering (SSR)
   ├── Incremental Static Regeneration (ISR)
   └── Client-Side Rendering (CSR)

4. Data Fetching
   ├── fetch nativo con caching
   ├── Server Actions (mutaciones)
   ├── React Query / SWR para cliente
   └── Route Handlers (API endpoints)

5. Optimización
   ├── Image (next/image)
   ├── Fonts (next/font)
   ├── Metadata y SEO (generateMetadata)
   ├── Scripts (next/script)
   └── Lazy loading de componentes

6. Autenticación
   ├── NextAuth.js / Auth.js
   ├── Middleware para proteger rutas
   ├── Server Actions con sesión
   └── JWT y cookies

7. Estilizado
   ├── CSS Modules / Tailwind CSS
   ├── CSS-in-JS (styled-components, vanilla-extract)
   └── Shadcn/ui (componentes reutilizables)

8. Base de datos y ORM
   ├── Prisma (type-safe ORM)
   ├── Drizzle ORM
   ├── SQLite / PostgreSQL
   └── Neon, PlanetScale (serverless)

9. Testing
   ├── Vitest + React Testing Library
   ├── Playwright (E2E)
   └── MSW para mock de APIs

10. Producción y despliegue
    ├── Build y optimización (next build)
    ├── Vercel (plataforma nativa)
    ├── Docker + auto-escalado
    └── Análisis con Next.js Analytics
```
