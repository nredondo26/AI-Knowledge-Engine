# JavaScript

Lenguaje interpretado, multiparadigma, tipado dinámico y débil. Creado por Brendan Eich (1995). Motor V8 (Chrome/Node), SpiderMonkey (Firefox), JavaScriptCore (Safari). Estandarizado como ECMAScript (ES6+ en adelante).

## Sintaxis básica

```javascript
// Hola mundo
console.log("Hola, mundo");

// Variables: let (mut), const (inmutable), var (obsoleto)
let nombre = "Ana";
const edad = 30;
var altura = 1.75; // function scope, evitar

// Tipos primitivos: string, number, boolean, null, undefined, symbol, bigint
let activo = true;
let id = Symbol("id");
let grande = 9007199254740991n;

// Estructuras de control
if (edad >= 18) {
  console.log("Mayor");
} else if (edad > 12) {
  console.log("Adolescente");
} else {
  console.log("Menor");
}

for (let i = 0; i < 5; i++) console.log(i);
for (const x of [1, 2, 3]) console.log(x);
for (const key in {a:1, b:2}) console.log(key);

while (activo) break;

// arrow functions, template literals, destructuring
const sumar = (a, b) => a + b;
const msg = `Hola, ${nombre}, tienes ${edad} años`;
const [x, y] = [10, 20];
const { nombre: n, edad: e } = { nombre: "Ana", edad: 30 };

// spread/rest
const arr = [1, ...[2, 3], 4];
function log(...args) { console.log(args); }
```

## Tipado

JavaScript es **dinámico** y **débil** (coerción implícita agresiva, ej. `"5" - 3` → `2`). No tiene type hints nativos; se usa JSDoc o TypeScript para verificación estática.

```javascript
// Coerción: fuente común de bugs
console.log(1 + "2");      // "12"
console.log("5" - 3);      // 2
console.log([] + {});      // "[object Object]"
console.log(null == undefined); // true (== con coerción)
console.log(null === undefined); // false (=== sin coerción)

// typeof (limitado)
typeof null;        // "object" (bug histórico)
typeof [];          // "object"
Array.isArray([]);  // true

// instanceof
class Foo {}
new Foo() instanceof Foo; // true

// Duck typing / type checking manual
function isString(val) {
  return typeof val === "string" || val instanceof String;
}

// JSDoc para type hints (usado por editors y TypeScript)
/**
 * @param {number} a
 * @param {number} b
 * @returns {number}
 */
function multiplicar(a, b) { return a * b; }
```

## POO / Funcional

```javascript
// POO: prototipos (no clases reales), clases sintácticas desde ES6
class Vehiculo {
  #marca; // campo privado (ES2022)

  constructor(marca) {
    this.#marca = marca;
  }

  get marca() { return this.#marca; }
  set marca(valor) {
    if (!valor) throw new Error("Marca requerida");
    this.#marca = valor;
  }

  mover() { return "Vehículo se mueve"; }
}

class Coche extends Vehiculo {
  mover() { return `${this.marca} acelera`; }
}

const coche = new Coche("Toyota");
console.log(coche.mover());

// Mixins (composición sobre herencia)
const Volable = {
  volar() { return `${this.nombre} vuela`; },
};

class Pato {
  constructor(nombre) { this.nombre = nombre; }
}
Object.assign(Pato.prototype, Volable);

// Funcional: funciones como ciudadanos de primera clase
const nums = [1, 2, 3, 4];
const doblados = nums.map(x => x * 2);
const pares = nums.filter(x => x % 2 === 0);
const suma = nums.reduce((a, b) => a + b, 0);

// Closures
const crearContador = () => {
  let count = 0;
  return () => ++count;
};
const contador = crearContador();
console.log(contador()); // 1

// Currying
const curry = (fn) => {
  const arity = fn.length;
  const resolver = (...args) =>
    args.length < arity
      ? (...next) => resolver(...args, ...next)
      : fn(...args);
  return resolver;
};
const suma3 = curry((a, b, c) => a + b + c);
console.log(suma3(1)(2)(3)); // 6
```

## Concurrencia

```javascript
// Event Loop: single-threaded, no bloqueante, I/O asíncrono
// Callbacks (callback hell, evitar)
setTimeout(() => console.log("Timeout"), 1000);

// Promesas (ES6)
const fetchData = (id) =>
  new Promise((resolve) =>
    setTimeout(() => resolve(`Datos ${id}`), 100)
  );

fetchData(1).then(console.log);

// async/await (ES8)
async function main() {
  const results = await Promise.all(
    [1, 2, 3].map(id => fetchData(id))
  );
  console.log(results);
}
main();

// Worker threads (CPU-bound, paralelismo real)
// main.js
const { Worker } = require("worker_threads");
const worker = new Worker(`
  const { parentPort } = require("worker_threads");
  parentPort.on("message", (n) => {
    parentPort.postMessage(n ** n);
  });
`);
worker.on("message", console.log);
worker.postMessage(10);

// Node.js: child_process, cluster
// Web: Web Workers, Service Workers, SharedArrayBuffer
```

## Ecosistema

- **npm** / **yarn** / **pnpm** / **bun** — gestores de paquetes (~2M+ paquetes en npm)
- **Node.js** — runtime server-side (LTS cada 18 meses)
- **Deno** — runtime moderno (TypeScript nativo, permisos)
- **Bun** — runtime ultrarrápido (bundler, test runner, package manager)
- **Web**: React, Vue, Svelte, Angular, Next.js, Nuxt, Astro
- **Backend**: Express, Fastify, Hono, NestJS, Koa
- **Testing**: Vitest, Jest, Mocha+Chai, Playwright, Cypress
- **Linting/Formato**: ESLint + Prettier (estándar), Biome (todo-en-uno)
- **Bundlers**: Vite (estándar moderno), Webpack, Turbopack, esbuild, Rollup
- **Transpiladores**: Babel (ES6+ → ES5), SWC (Rust, rápido)

## Herramientas

```bash
# Gestión de proyectos
npm init -y
npm install express

# Desarrollo con Vite (frontend moderno)
npm create vite@latest . -- --template react-ts

# Lint y formato
npx eslint src/
npx prettier --write src/

# Testing
npx vitest run
npx playwright test

# Ejecución
node index.js
npx tsx script.ts  # TypeScript directo
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [Web](../../026-Web/README.md)
- [Node.js](../../003-Runtimes/Node.js/README.md)
