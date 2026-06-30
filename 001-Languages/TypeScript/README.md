# TypeScript

Superset de JavaScript con tipado estático y estructural. Creado por Anders Hejlsberg (Microsoft, 2012). Compila a JavaScript limpio. Estandariza tipos en el ecosistema JS.

## Sintaxis básica

```typescript
// Hola mundo
console.log("Hola, mundo");

// Variables con tipos explícitos e inferidos
let nombre: string = "Ana";
const edad = 30; // inferido: number
let activo: boolean = true;
let datos: any = null; // any: evitar, desactiva el checker

// Tipos primitivos: string, number, boolean, null, undefined, void, never, unknown, bigint, symbol
let id: symbol = Symbol("id");
let grande: bigint = 9007199254740991n;

// Uniones, intersecciones, literales
type Estado = "activo" | "inactivo" | "pendiente";
type ID = string | number;
type ConNombre = { nombre: string };
type ConEdad = { edad: number };
type Persona = ConNombre & ConEdad; // intersección

const estado: Estado = "activo";
function buscar(id: ID): Persona | null {
  return id ? { nombre: "Ana", edad: 30 } : null;
}

// Type guards
function esString(val: unknown): val is string {
  return typeof val === "string";
}
```

## Tipado (profundidad)

```typescript
// Genéricos
function identidad<T>(arg: T): T {
  return arg;
}

// Constrained generics
function longitud<T extends { length: number }>(arg: T): number {
  return arg.length;
}

// Mapped types
type Readonly2<T> = { readonly [K in keyof T]: T[K] };
type Optional2<T> = { [K in keyof T]?: T[K] };

// Conditional types
type IsString<T> = T extends string ? "sí" : "no";
type Resultado = IsString<"hola">; // "sí"

// Template literal types
type EventName = `on${Capitalize<string>}`;

// infer (pattern matching sobre tipos)
type Retorno<T> = T extends (...args: any[]) => infer R ? R : never;
type R = Retorno<() => string>; // string

// satisfies (TS 4.9+)
const config = {
  api: "https://api.example.com",
  timeout: 5000,
} satisfies Record<string, string | number>;
// config.api es string, no string|number

// Branded types (nominal simulation)
type EUR = number & { __brand: "EUR" };
type USD = number & { __brand: "USD" };
function toEur(usd: USD): EUR {
  return (usd * 0.92) as EUR;
}
```

## POO / Funcional

```typescript
// POO con modificadores de acceso
abstract class Vehiculo {
  constructor(protected marca: string) {}

  get Marca(): string {
    return this.marca;
  }

  abstract mover(): string;
}

class Coche extends Vehiculo {
  #velocidad: number = 0; // campo privado ES2022

  constructor(marca: string, private modelo: string) {
    super(marca);
  }

  override mover(): string {
    return `${this.marca} ${this.modelo} acelera`;
  }

  get velocidad() {
    return this.#velocidad;
  }
}

// Interfaces (structural typing)
interface Volable {
  volar(): void;
}

class Aguila implements Volable {
  volar() {
    console.log("Volando");
  }
}

// Funcional: tipos first-class para funciones
type Mapper<T, R> = (item: T) => R;
type Predicate<T> = (item: T) => boolean;

const map = <T, R>(arr: T[], fn: Mapper<T, R>): R[] => arr.map(fn);
const filter = <T>(arr: T[], pred: Predicate<T>): T[] => arr.filter(pred);

// Discriminated unions (pattern matching)
type Figura =
  | { tipo: "circulo"; radio: number }
  | { tipo: "rectangulo"; ancho: number; alto: number }
  | { tipo: "triangulo"; base: number; altura: number };

function area(figura: Figura): number {
  switch (figura.tipo) {
    case "circulo": return Math.PI * figura.radio ** 2;
    case "rectangulo": return figura.ancho * figura.alto;
    case "triangulo": return (figura.base * figura.altura) / 2;
  }
}
// El exhaustiveness check asegura que cubrimos todos los casos
```

## Concurrencia

```typescript
// TypeScript hereda el modelo de JS: event loop, promesas, async/await
// Tipado fuerte para async

async function fetchData<T>(url: string): Promise<T> {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.json() as Promise<T>;
}

interface User {
  id: number;
  name: string;
}

async function main(): Promise<void> {
  const users = await Promise.all([
    fetchData<User>("https://api.example.com/users/1"),
    fetchData<User>("https://api.example.com/users/2"),
  ]);
  console.log(users.map(u => u.name));
}

// Workers con tipado (TS compila a JS, luego se ejecuta)
// Se puede compartir tipos entre main y worker via imports

// AbortController para cancelación tipada
async function fetchConTimeout(url: string, ms: number): Promise<Response> {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), ms);
  try {
    return await fetch(url, { signal: controller.signal });
  } finally {
    clearTimeout(timeout);
  }
}
```

## Ecosistema

- **npm** — gestor de paquetes (mismo ecosistema que JS)
- **tsx** / **ts-node** — ejecución directa de TS
- **tsc** — compilador oficial (lento, completo)
- **swc** / **esbuild** — transpilación ultrarrápida en Rust/Go
- **Bun** — runtime con TS nativo
- **Web**: React + TS (estándar), Next.js, Astro, SvelteKit, SolidStart
- **Backend**: NestJS (opinionado), Hono (ligero), Express + typings
- **Testing**: Vitest (compatible Jest, rápido), Jest con ts-jest
- **Linting**: ESLint + typescript-eslint, Biome
- **ORM**: Prisma (tipado automático), Drizzle, TypeORM

## Herramientas

```bash
# Inicializar proyecto
npm create vite@latest . -- --template react-ts
# o
npx create-next-app@latest . --typescript

# Compilar
npx tsc --noEmit  # solo type check
npx tsc            # compilar a JS

# Sin compilación (directo)
npx tsx script.ts

# Configuración tsconfig.json
# {
#   "compilerOptions": {
#     "target": "ES2022",
#     "module": "NodeNext",
#     "moduleResolution": "NodeNext",
#     "strict": true,
#     "outDir": "dist"
#   }
# }

# Declaraciones (d.ts)
tsc --declaration --emitDeclarationOnly
```

## Relaciones

- [JavaScript](../JavaScript/README.md)
- [Frameworks](../../002-Frameworks/README.md)
- [Web](../../026-Web/README.md)
