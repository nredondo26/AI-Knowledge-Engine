# Svelte

## Descripción

Svelte es un framework de UI compilado, creado por Rich Harris en 2016. A diferencia de React o Vue, Svelte traslada el trabajo del navegador al compilador, generando código JavaScript vanilla optimizado durante el build, eliminando la necesidad de un Virtual DOM. SvelteKit es el meta-framework oficial para aplicaciones full-stack con SSR, SSG y rutas API.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Reactividad** | `let` + asignación disparan automáticamente la actualización del DOM. |
| **Componentes** | Archivos `.svelte` con HTML, CSS y JS en un mismo bloque. |
| **Props** | Datos de padre a hijo mediante `export let` o `$props()`. |
| **Stores** | Estado reactivo global (`writable`, `readable`, `derived`). |
| **Transiciones** | `transition:fade`, `transition:slide`, `in:fly`, `out:scale`. |
| **SvelteKit** | Meta-framework con routing, SSR/SSG, endpoints API. |

---

## Ejemplos de código

### Componente básico

```svelte
<script>
  let nombre = 'Mundo';
  let cuenta = $state(0);
</script>

<h1>Hola {nombre}!</h1>
<p>Has hecho clic {cuenta} veces</p>
<button onclick={() => cuenta++}>+1</button>
```

### Store reactivo

```svelte
<!-- stores.js -->
import { writable, derived } from 'svelte/store';
export const tareas = writable([]);
export const pendientes = derived($tareas, ($t) => $t.filter((t) => !t.completada).length);
```

```svelte
<script>
  import { tareas, pendientes } from './stores.js';
  let nuevaTarea = '';

  function agregar() {
    $tareas = [...$tareas, { id: Date.now(), texto: nuevaTarea, completada: false }];
    nuevaTarea = '';
  }
</script>

<h1>Pendientes: {$pendientes}</h1>
<input bind:value={nuevaTarea} placeholder="Nueva tarea" />
<button on:click={agregar}>Agregar</button>

<ul>
  {#each $tareas as tarea}
    <li><input type="checkbox" bind:checked={tarea.completada} /> {tarea.texto}</li>
  {/each}
</ul>
```

### SvelteKit endpoint y página

```typescript
// src/routes/api/usuarios/+server.ts
import { json } from '@sveltejs/kit';

export async function GET() {
  const usuarios = [
    { id: 1, nombre: 'Ana', email: 'ana@email.com' }
  ];
  return json(usuarios);
}
```

```svelte
<!-- src/routes/+page.svelte -->
<script>
  let usuarios = $state([]);
  async function cargar() {
    const res = await fetch('/api/usuarios');
    usuarios = await res.json();
  }
</script>

<button onclick={cargar}>Cargar usuarios</button>
<ul>
  {#each usuarios as u}
    <li>{u.nombre} — {u.email}</li>
  {/each}
</ul>
```

---

## Hoja de ruta

```
1. Fundamentos JS/TS → 2. Reactividad y componentes
3. Props y eventos → 4. Stores y estado global
5. Ciclo de vida (onMount, $effect) → 6. Transiciones y animaciones
7. SvelteKit (routing, load, form actions, adaptadores)
8. Testing (Vitest + svelte-testing-library)
```
