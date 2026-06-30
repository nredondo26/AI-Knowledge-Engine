# Vue.js

## Descripción

Vue.js es un framework progresivo de JavaScript para construir interfaces de usuario. Creado por Evan You en 2014, Vue se destaca por su curva de aprendizaje suave, su flexibilidad y su excelente rendimiento. Se puede adoptar incrementalmente: desde una simple librería para mejorar una página existente hasta un framework completo para SPA (Single Page Applications) con enrutamiento, estado global y herramientas de build.

Vue 3, la versión actual, introduce la **Composition API** (inspirada en React Hooks), mejoras de rendimiento con Proxy-based reactivity y un ecosistema robusto con Vite como bundler oficial.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Componentes de un solo archivo (SFC)** | Archivos `.vue` que encapsulan template, script y styles. |
| **Reactividad** | Sistema basado en proxies que detecta cambios en datos y actualiza el DOM automáticamente. |
| **Directivas** | Atributos especiales como `v-if`, `v-for`, `v-bind`, `v-model`, `v-on`. |
| **Computed properties** | Propiedades derivadas que se recalculan solo cuando sus dependencias cambian. |
| **Watchers** | Observadores que ejecutan lógica cuando una propiedad reactiva cambia. |
| **Composition API** | API basada en funciones (`ref`, `reactive`, `computed`, `watch`) para organizar lógica. |
| **Options API** | API clásica basada en objetos con opciones como `data`, `methods`, `computed`. |
| **Slots** | Mecanismo de composición de contenido entre componentes padre e hijo. |
| **Provide / Inject** | Alternativa a props drilling para compartir datos en un árbol de componentes. |
| **Router** | Vue Router para navegación SPA con lazy loading. |
| **Pinia** | Biblioteca oficial y reactiva para manejo de estado global. |

---

## Ejemplos de código

### Componente SFC con Composition API

```vue
<script setup>
import { ref, computed } from 'vue'

const nombre = ref('Mundo')
const contador = ref(0)

const saludo = computed(() => `Hola, ${nombre.value}!`)

function incrementar() {
  contador.value++
}
</script>

<template>
  <div>
    <h1>{{ saludo }}</h1>
    <p>Contador: {{ contador }}</p>
    <button @click="incrementar">+1</button>
    <input v-model="nombre" placeholder="Escribe tu nombre" />
  </div>
</template>

<style scoped>
h1 { color: #42b883; }
</style>
```

### Renderizado condicional y listas

```vue
<script setup>
import { ref } from 'vue'

const mostrar = ref(true)
const items = ref(['Manzana', 'Banana', 'Cereza'])
</script>

<template>
  <button @click="mostrar = !mostrar">Toggle</button>
  <p v-if="mostrar">Este texto se muestra condicionalmente</p>
  <p v-else>Texto alternativo</p>

  <ul>
    <li v-for="(item, index) in items" :key="index">{{ item }}</li>
  </ul>
</template>
```

### Eventos y v-model

```vue
<script setup>
import { ref } from 'vue'

const email = ref('')
const acepta = ref(false)

function enviar() {
  alert(`Email: ${email.value}, Acepta: ${acepta.value}`)
}
</script>

<template>
  <form @submit.prevent="enviar">
    <input v-model="email" type="email" placeholder="Email" />
    <label>
      <input v-model="acepta" type="checkbox" /> Acepto términos
    </label>
    <button type="submit" :disabled="!acepta">Enviar</button>
  </form>
</template>
```

### Watchers y efectos

```vue
<script setup>
import { ref, watch } from 'vue'

const busqueda = ref('')

watch(busqueda, (nuevoValor, viejoValor) => {
  console.log(`Búsqueda cambió de "${viejoValor}" a "${nuevoValor}"`)
  // Aquí podrías llamar a una API
})
</script>

<template>
  <input v-model="busqueda" placeholder="Buscar..." />
</template>
```

### Pinia para estado global

```javascript
// stores/contador.js
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useContadorStore = defineStore('contador', () => {
  const cuenta = ref(0)
  const doble = computed(() => cuenta.value * 2)

  function incrementar() {
    cuenta.value++
  }

  return { cuenta, doble, incrementar }
})
```

```vue
<script setup>
import { useContadorStore } from './stores/contador'

const store = useContadorStore()
</script>

<template>
  <p>Cuenta: {{ store.cuenta }}</p>
  <p>Doble: {{ store.doble }}</p>
  <button @click="store.incrementar">+1</button>
</template>
```

---

## Hoja de ruta

```
1. Fundamentos de JavaScript moderno (ES6+)
   ├── Arrow functions, template literals
   ├── Promesas, async/await
   └── Import / export modules

2. Introducción a Vue 3
   ├── Creación de proyecto con Vite (npm create vue@latest)
   ├── Single File Components (.vue)
   ├── Plantillas y sintaxis de interpolación
   └── Directivas (v-bind, v-if, v-for, v-on, v-model)

3. Reactividad y estado
   ├── ref() y reactive()
   ├── computed()
   └── watch() y watchEffect()

4. Composition API (profundización)
   ├── setup() vs <script setup>
   ├── Ciclo de vida (onMounted, onUnmounted, etc.)
   └── Composición de funciones reutilizables (composables)

5. Comunicación entre componentes
   ├── Props y emits
   ├── Slots (default, named, scoped)
   ├── Provide / Inject
   └── v-model personalizado

6. Enrutamiento con Vue Router 4
   ├── Rutas dinámicas, nested routes
   ├── Navegación programática
   ├── Guards (beforeEach, meta fields)
   └── Lazy loading

7. Estado global con Pinia
   ├── Stores con setup syntax
   ├── Actions, getters y persistencia
   └── Integración con Vue Router

8. Estilizado
   ├── Scoped styles
   ├── Pre-procesadores (SCSS, PostCSS)
   └── Component libraries (PrimeVue, Vuetify, Naive UI)

9. Testing
   ├── Vitest + Vue Test Utils
   └── Component testing, store testing

10. Producción y avanzado
    ├── Lazy loading y code splitting
    ├── Render functions y JSX en Vue
    ├── Server-Side Rendering (Nuxt 3)
    └── Web Components con Vue
```
