# CSS — Cascading Style Sheets

## Descripción General

CSS describe la presentación visual de HTML. **CSS3** modularizó el lenguaje en especificaciones: Selectors Level 4, Flexbox, Grid, Custom Properties, Animaciones.

---

## La Cascada y Especificidad

1. **Importancia**: `!important` > estilos normales.
2. **Origen**: Animaciones > usuario > autor > agente (navegador).
3. **Especificidad**: ID > Clase/Atributo/Pseudoclase > Elemento/Pseudoelemento.
4. **Orden**: Gana la última regla declarada.

```
#id         → (1,0,0,0)
.clase      → (0,1,0,0)
[attr]      → (0,1,0,0)
h1          → (0,0,1,0)
::before    → (0,0,1,0)
*           → (0,0,0,0)
```

```css
/* (0,2,1,0) */
nav ul.list a:hover { color: red; }
```

---

## Selectores

```css
/* Básicos */ * { } h1 { } .clase { } #id { }
/* Combinatorios */ div p { } div > p { } h1 + p { } h1 ~ p { }
/* Pseudoclases */ :first-child :last-child :nth-child(2n+1) :hover :focus :checked :disabled :valid :invalid
/* Funcionales */ :is(.a, .b) :where(.a, .b) :has(div) :not(.x)
```

---

## Box Model

```css
.box { width: 300px; box-sizing: border-box; padding: 16px; border: 2px solid #333; margin: 24px auto; }
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
```

---

## Flexbox

```css
.container { display: flex; flex-wrap: wrap; justify-content: center; align-items: center; gap: 16px; }
.item { flex: 1 1 200px; align-self: flex-end; order: 2; }
```

---

## CSS Grid

```css
.grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: auto 1fr auto;
  grid-template-areas: "header header header" "sidebar main main" "footer footer footer";
  gap: 16px;
}
header { grid-area: header; } aside { grid-area: sidebar; } main { grid-area: main; } footer { grid-area: footer; }
.item { grid-column: 2 / 4; grid-row: 1 / 3; }
```

---

## Responsive Design

```css
.container { display: grid; grid-template-columns: 1fr; }
@media (min-width: 768px) { .container { grid-template-columns: 250px 1fr; } }
@media (min-width: 1024px) { .container { grid-template-columns: 250px 1fr 300px; } }
.fluid { width: clamp(300px, 80vw, 1200px); }
.text { font-size: clamp(1rem, 2.5vw, 1.5rem); }
```

---

## Custom Properties

```css
:root { --color-primary: #2563eb; --spacing: 8px; --radius: 8px; }
.card { background: color-mix(in srgb, var(--color-primary) 10%, white); border-radius: var(--radius); padding: calc(var(--spacing) * 3); }
```

---

## Animaciones y Transiciones

```css
.button { background: var(--color-primary); transition: background 0.3s ease, transform 0.2s cubic-bezier(0.4, 0, 0.2, 1); }
.button:hover { background: #1d4ed8; transform: translateY(-2px); }

@keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
.hero-title { animation: fadeIn 0.8s ease-out forwards; }
```

---

## Funciones Modernas

```css
font-size: clamp(1rem, 2vw + 1rem, 2rem);
width: min(100%, 1200px);
height: max(400px, 50vh);
grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
width: calc(100% - 40px);
background: color-mix(in oklch, red 50%, blue);
```

---

## Container Queries

```css
.card-container { container-type: inline-size; }
@container (min-width: 400px) { .card { display: flex; } }
```

---

## Metodologías

| Metodología | Principio | Ejemplo |
|-------------|-----------|---------|
| **BEM** | Bloque__Elemento--Modificador | `card__title--large` |
| **SMACSS** | base, layout, module, state, theme | `is-active` |
| **Utility-first** | Atomic CSS | `d-flex`, `p-16` |

---

## Buenas Prácticas

Reset de box-model global. Mobile-first con media queries. Variables para colores y espaciado. Evitar `!important`. Usar Grid para layout 2D, Flexbox para 1D.

---

## Referencias

- [MDN Web Docs — CSS](https://developer.mozilla.org/es/docs/Web/CSS)
- [Can I Use](https://caniuse.com)
