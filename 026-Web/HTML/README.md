# HTML — HyperText Markup Language

## Descripción General

HTML es el lenguaje de marcado estándar para documentos web. **HTML5** introdujo elementos semánticos, APIs multimedia, Canvas/SVG, almacenamiento local y capacidades offline.

---

## Anatomía de un Documento HTML5

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mi página</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <header><nav aria-label="Principal"><ul><li><a href="/">Inicio</a></li></ul></nav></header>
  <main><article><h1>Artículo</h1><p>Contenido.</p></article></main>
  <footer>&copy; 2026</footer>
  <script src="app.js" defer></script>
</body>
</html>
```

---

## Elementos Semánticos

| Etiqueta | Propósito |
|----------|-----------|
| `<header>` | Cabecera de página/sección |
| `<nav>` | Navegación |
| `<main>` | Contenido principal único |
| `<article>` | Contenido independiente |
| `<section>` | Agrupación temática |
| `<aside>` | Contenido complementario |
| `<footer>` | Pie de página |

Beneficios: Accesibilidad (lectores de pantalla), SEO, mantenibilidad.

---

## Formularios HTML5

```html
<form action="/api/usuarios" method="POST" novalidate>
  <label for="nombre">Nombre:</label>
  <input type="text" id="nombre" name="nombre" required minlength="3" autocomplete="name">

  <label for="email">Email:</label>
  <input type="email" id="email" name="email" required multiple autocomplete="email">

  <label for="fecha">Fecha:</label>
  <input type="date" id="fecha" name="fecha" min="1900-01-01" max="2010-12-31">

  <label for="pais">País:</label>
  <select id="pais" name="pais" required>
    <option value="">Selecciona...</option>
    <option value="MX">México</option>
    <option value="ES">España</option>
  </select>

  <button type="submit">Enviar</button>
</form>
```

**Atributos de validación**: `required`, `minlength`, `maxlength`, `min`, `max`, `step`, `pattern`, `autocomplete`.

---

## APIs de HTML5

### Canvas

```html
<canvas id="c" width="400" height="300"></canvas>
<script>
  const ctx = document.getElementById('c').getContext('2d');
  const g = ctx.createLinearGradient(0, 0, 400, 300); g.addColorStop(0, '#ff6b6b'); g.addColorStop(1, '#4ecdc4');
  ctx.fillStyle = g; ctx.fillRect(0, 0, 400, 300);
  ctx.fillStyle = '#fff'; ctx.font = 'bold 32px sans-serif'; ctx.textAlign = 'center';
  ctx.fillText('Canvas', 200, 160);
</script>
```

### Web Storage

```javascript
localStorage.setItem('token', 'abc123');
localStorage.setItem('usuario', JSON.stringify({ id: 1, nombre: 'Ana' }));
const token = localStorage.getItem('token');
const usuario = JSON.parse(localStorage.getItem('usuario'));
localStorage.removeItem('token');
```

### Geolocalización

```javascript
if ('geolocation' in navigator) {
  navigator.geolocation.getCurrentPosition(
    (p) => console.log(`Lat: ${p.coords.latitude}, Lng: ${p.coords.longitude}`),
    (e) => console.error(e.message),
    { enableHighAccuracy: true, timeout: 5000 }
  );
}
```

### Web Workers

```javascript
// worker.js
self.onmessage = (e) => self.postMessage(e.data.reduce((a, b) => a + b, 0));
// main.js
const w = new Worker('worker.js'); w.postMessage([1,2,3,4,5]); w.onmessage = (e) => console.log(e.data);
```

---

## Elementos Embebidos

```html
<video controls width="640" poster="thumb.jpg">
  <source src="video.mp4" type="video/mp4">
  <source src="video.webm" type="video/webm">
  <track src="subtitles.vtt" kind="subtitles" srclang="es">
</video>

<audio controls>
  <source src="audio.mp3" type="audio/mpeg">
</audio>

<svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="steelblue"/></svg>
```

---

## Accesibilidad (A11y)

```html
<button aria-label="Cerrar" aria-expanded="false"><span aria-hidden="true">&times;</span></button>
<a href="#main" class="skip-link">Saltar al contenido</a>
<img src="foto.jpg" alt="Descripción">
<div role="alert" aria-live="assertive">Mensaje importante</div>
```

---

## SEO

```html
<meta property="og:title" content="Título">
<meta property="og:description" content="Descripción">
<meta name="twitter:card" content="summary_large_image">
<script type="application/ld+json">{ "@context": "https://schema.org", "@type": "Article", "headline": "Título" }</script>
```

---

## Buenas Prácticas

Siempre `<!DOCTYPE html>` y `UTF-8`. Incluir `lang` en `<html>`. Un solo `<h1>` por página. Scripts con `defer`. Etiquetas semánticas sobre `<div>`. Validar con [W3C Validator](https://validator.w3.org).

---

## Referencias

- [MDN Web Docs — HTML](https://developer.mozilla.org/es/docs/Web/HTML)
- [HTML Living Standard](https://html.spec.whatwg.org)
