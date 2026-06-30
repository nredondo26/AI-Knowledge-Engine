# JavaScript — El Lenguaje de la Web

## Descripción General

JavaScript es un lenguaje interpretado, dinámico, débilmente tipado y basado en prototipos. Es uno de los tres pilares de la web. Con **Node.js** también se ejecuta del lado del servidor. El estándar es **ECMAScript** (ES2024, ES2025, ES2026).

---

## Tipos de Datos

```javascript
typeof "hola"       // "string"
typeof 42          // "number"
typeof true        // "boolean"
typeof undefined   // "undefined"
typeof null        // "object"  (error histórico)
typeof Symbol()    // "symbol"
typeof {}          // "object"
typeof []          // "object"
typeof function(){} // "function"
```

---

## ES6+ Features

```javascript
// let/const (block scope)
let v = 1; const c = 2;
// Arrow functions
const sum = (a, b) => a + b;
// Template literals
console.log(`Hola ${nombre}, son las ${new Date().toLocaleTimeString()}`);
// Destructuring
const { id, ...resto } = usuario;
const [x, y, z] = coords;
// Spread
const arr2 = [...arr1, 4, 5]; const obj2 = { ...obj1, c: 3 };
// Optional chaining
const email = usuario?.perfil?.email ?? 'default';
// Nullish coalescing
const val = nulo ?? 'por defecto';
```

---

## Programación Asíncrona

```javascript
// Callbacks
fs.readFile('archivo.txt', 'utf8', (err, data) => { if (err) throw err; });

// Promesas
fetch('/api/usuarios').then(r => { if (!r.ok) throw Error(`HTTP ${r.status}`); return r.json(); });

// Async/Await
async function obtener() {
  try { const [u, p] = await Promise.all([fetchUsuario(1), fetchPosts(1)]); return { u, p }; }
  catch (e) { console.error(e); throw e; }
}

// Event Loop
console.log('1');
setTimeout(() => console.log('2'), 0);    // Macrotask
Promise.resolve().then(() => console.log('3')); // Microtask
console.log('4');
// Salida: 1, 4, 3, 2
```

---

## Closures

```javascript
function crearContador() {
  let count = 0;
  return { inc: () => ++count, dec: () => --count, get: () => count };
}
const c = crearContador(); c.inc(); // 1
```

---

## Prototypes y Clases

```javascript
// Herencia prototípica
const animal = { respirar() { console.log('Respirando...'); } };
const perro = Object.create(animal); perro.ladrar = () => console.log('Guau!');

// Clases
class Vehiculo {
  #vin; // campo privado (ES2022)
  constructor(marca, modelo) { this.marca = marca; this.#vin = crypto.randomUUID(); }
  get vin() { return this.#vin; }
  static fromJSON(j) { return new Vehiculo(j.marca, j.modelo); }
  arrancar() { console.log(`${this.marca} arrancando...`); }
}
class Coche extends Vehiculo { constructor(m, mo, p) { super(m, mo); this.puertas = p; } }
```

---

## Módulos ES

```javascript
// math.js
export const PI = 3.14159;
export function suma(...n) { return n.reduce((a, b) => a + b, 0); }
export default class Calc {}

// app.js
import Calc, { PI, suma } from './math.js';
import * as MathUtils from './math.js';
```

---

## Patrón Observer / EventEmitter

```javascript
class EventEmitter {
  #events = new Map();
  on(e, fn) { if (!this.#events.has(e)) this.#events.set(e, []); this.#events.get(e).push(fn); }
  emit(e, ...a) { this.#events.get(e)?.forEach(fn => fn(...a)); }
}
```

---

## DOM Manipulation

```javascript
const $ = s => document.querySelector(s);
const $$ = s => document.querySelectorAll(s);
const div = document.createElement('div');
div.textContent = 'Nuevo'; div.classList.add('card'); div.dataset.id = '42';
$('#btn')?.addEventListener('click', e => { e.preventDefault(); }, { once: true });

// Intersection Observer
new IntersectionObserver((entries) => {
  entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('visible'); observer.unobserve(e.target); } });
}, { threshold: 0.1 }).observe(el);
```

---

## Fetch API

```javascript
const res = await fetch('/api/usuarios', { headers: { 'Authorization': `Bearer ${token}` } });
if (!res.ok) throw Error(`Error ${res.status}`);
const data = await res.json();

const crear = await fetch('/api/usuarios', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ nombre: 'Ana' }) });
```

---

## Web APIs Adicionales

```javascript
// Notificaciones
Notification.requestPermission().then(p => { if (p === 'granted') new Notification('¡Hola!'); });
// Service Worker
navigator.serviceWorker.register('/sw.js');
// Broadcast Channel
const ch = new BroadcastChannel('app'); ch.postMessage({ type: 'LOGOUT' });
```

---

## Buenas Prácticas

Usar `===` sobre `==`. Preferir `const` sobre `let`. Manejar errores con `try/catch`. Evitar mutaciones. Usar `AbortController` para cancelar fetch.

---

## Referencias

- [MDN Web Docs — JavaScript](https://developer.mozilla.org/es/docs/Web/JavaScript)
- [ECMAScript Spec](https://tc39.es/ecma262)
