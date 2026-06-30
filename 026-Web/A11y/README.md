# Accesibilidad Web (A11y) — Diseño para Todos

## Descripción General

La accesibilidad web (A11y, numeronimio de "Accessibility") garantiza que personas con discapacidades puedan percibir, entender, navegar e interactuar con la web. Se rige por las WCAG (Web Content Accessibility Guidelines) del W3C, que definen cuatro principios: Perceptible, Operable, Comprensible y Robusto.

---

## Niveles de Conformidad WCAG

| Nivel | Descripción | Puntos de verificación |
|-------|-------------|----------------------|
| **A** | Mínimo | 30 criterios |
| **AA** | Aceptable (legal) | 20 adicionales |
| **AAA** | Óptimo | 28 adicionales |

---

## HTML Semántico

```html
<!-- Mal -->
<div class="boton" onclick="submit()">Enviar</div>
<div class="nav">
  <div class="item">Inicio</div>
  <div class="item">Perfil</div>
</div>

<!-- Bien -->
<button type="submit">Enviar</button>
<nav aria-label="Navegación principal">
  <ul>
    <li><a href="/">Inicio</a></li>
    <li><a href="/perfil">Perfil</a></li>
  </ul>
</nav>

<!-- Landmarks -->
<header role="banner">
<nav role="navigation" aria-label="Principal">
<main role="main">
<aside role="complementary">
<footer role="contentinfo">
```

---

## Atributos ARIA

```html
<!-- Estados y propiedades -->
<button aria-expanded="false" aria-controls="menu">
  Menú
</button>
<ul id="menu" role="menu" hidden>
  <li role="menuitem">Opción 1</li>
</ul>

<!-- Regiones vivas (dynamic content) -->
<div aria-live="polite" aria-atomic="true">
  Nuevo mensaje recibido
</div>

<!-- Descripciones -->
<input type="text" aria-label="Buscar productos" />
<button aria-describedby="tooltip-1">Info</button>
<div id="tooltip-1" role="tooltip">Más información aquí</div>
```

---

## Contraste de Color

```css
/* WCAG AA: relación de contraste ≥ 4.5:1 (texto normal) */
/* WCAG AA: ≥ 3:1 (texto grande ≥ 18px o ≥ 14px bold) */
/* WCAG AAA: ≥ 7:1 (texto normal) */

:root {
  --text-primary: #1a1a1a;      /* #fff bg → 15.3:1  */
  --text-secondary: #595959;    /* #fff bg → 4.6:1   */
  --error: #d32f2f;             /* #fff bg → 4.8:1   */
  --disabled: #9e9e9e;          /* #fff bg → 2.9:1  */
}

/* Herramientas: axe DevTools, Lighthouse, Contrast Ratio */
```

---

## Navegación por Teclado

```html
<!-- Tabindex -->
<button tabindex="0">Accesible</button>
<div tabindex="-1">Focus programático</div>
<!-- Evitar tabindex > 0 -->

<!-- Skip to content -->
<a href="#main-content" class="skip-link">Saltar al contenido</a>
<main id="main-content">
```

```css
.skip-link {
  position: absolute;
  top: -40px;
}
.skip-link:focus {
  top: 0;
}

/* Focus visible */
:focus-visible {
  outline: 3px solid #2563eb;
  outline-offset: 2px;
}
```

---

## Formularios Accesibles

```html
<form>
  <label for="nombre">Nombre completo</label>
  <input type="text" id="nombre" name="nombre" required
         aria-describedby="nombre-hint" />

  <fieldset>
    <legend>Género</legend>
    <label><input type="radio" name="genero" value="f" /> Femenino</label>
    <label><input type="radio" name="genero" value="m" /> Masculino</label>
  </fieldset>

  <span id="nombre-hint" hidden>Mínimo 3 caracteres</span>
  <span role="alert" id="nombre-error" hidden>Campo requerido</span>
</form>
```

---

## Imágenes y Multimedia

```html
<!-- Imagen decorativa -->
<img src="decoracion.jpg" alt="" role="presentation" />

<!-- Imagen informativa -->
<img src="grafico.jpg" alt="Ventas Q1: $10K, Q2: $15K, Q3: $12K" />

<!-- Imagen compleja -->
<figure>
  <img src="organigrama.png" alt="Organigrama de la empresa" />
  <figcaption>CEO → VP Ingeniería → Dev Lead → Developers</figcaption>
</figure>

<!-- Video con subtítulos -->
<video controls>
  <source src="tutorial.mp4" type="video/mp4" />
  <track kind="captions" src="subtitulos.vtt" srclang="es" label="Español" />
</video>
```

---

## Pruebas Automatizadas

```javascript
// axe-core
import { axe, toHaveNoViolations } from 'jest-axe';
expect.extend(toHaveNoViolations);

test('home page no tiene violaciones A11y', async () => {
  const { container } = render(<Home />);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

```bash
# Lighthouse CLI
lighthouse https://ejemplo.com --output=json --output-path=./report.json

# axe DevTools (extensión navegador)
# WAVE (Web Accessibility Evaluation Tool)
```

---

## Mejores Prácticas

1. **Mobile first + 200% zoom**: La interfaz debe funcionar sin scroll horizontal.
2. **Reducir movimiento**: Respetar `prefers-reduced-motion`.
3. **Modo oscuro**: Soporte `prefers-color-scheme`.
4. **Tamaño mínimo de target**: 44x44px (botones, enlaces).
5. **No solo color**: Indicar estados también con iconos/subrayado.
6. **Lenguaje claro**: `lang="es"` en `<html>`, definir cambios idiomáticos.

---

## Referencias

- [WCAG 2.2](https://www.w3.org/TR/WCAG22)
- [WebAIM Checklist](https://webaim.org/standards/wcag/checklist)
- [MDN Accessibility](https://developer.mozilla.org/es/docs/Web/Accessibility)
- [axe-core](https://github.com/dequelabs/axe-core)
- [Inclusive Components](https://inclusive-components.design)
