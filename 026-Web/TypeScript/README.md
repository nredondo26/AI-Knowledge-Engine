# TypeScript — Superset tipado de JavaScript

## Descripción del dominio

TypeScript es un lenguaje de programación de código abierto desarrollado por Microsoft que extiende JavaScript añadiendo tipos estáticos opcionales. Compila a JavaScript limpio y ejecutable en cualquier runtime (navegadores, Node.js, Deno, Bun). TypeScript permite detectar errores en tiempo de compilación, mejorar la autocompletación del editor, documentar APIs con tipos, y facilitar la refactorización en proyectos grandes. Es el estándar de facto para el desarrollo web moderno del lado del cliente (React, Angular, Vue) y del servidor (Node.js, Express, NestJS, tRPC).

## Áreas clave

- **Sistema de tipos**: Tipos primitivos (string, number, boolean), arrays, tuples, enums, any, unknown, never, void, null, undefined
- **Interfaces y Types**: `interface` (extensible, declaration merging), `type` (uniones, intersecciones, literales, mapped types)
- **Genéricos**: `<T>`, constraints (`extends`), conditional types, infer, mapped types, template literal types
- **Utility Types**: Partial, Required, Pick, Omit, Record, Exclude, Extract, NonNullable, ReturnType, Parameters, Awaited
- **Módulos**: ES Modules (import/export), namespace (legacy), barrel exports, path aliases (paths en tsconfig)
- **Configuración**: tsconfig.json (strict, target, module, outDir, rootDir, paths, declaration, sourceMap)
- **Tipado avanzado**: Branded types, discriminated unions, type guards (typeof, instanceof, in, user-defined), assertion functions, satisfies operator
- **Decoradores**: Class decorators, property decorators, method decorators, parameter decorators (experimental vs TC39 stage 3)
- **JSX/TSX**: Soporte nativo de TypeScript para JSX (React, Preact, Solid). React.FC, JSX.Element, ComponentProps

## Ejemplo: Tipos avanzados

```typescript
// Uniones discriminadas
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "rectangle"; width: number; height: number }
  | { kind: "triangle"; base: number; height: number };

function area(shape: Shape): number {
  switch (shape.kind) {
    case "circle":    return Math.PI * shape.radius ** 2;
    case "rectangle": return shape.width * shape.height;
    case "triangle":  return (shape.base * shape.height) / 2;
  }
}

// Utility types personalizados
type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

// Template literal types
type EventName = `on${Capitalize<string>}`;
type HexColor = `#${string}`;
```

## Ejemplo: Genéricos con constraint

```typescript
interface HasId {
  id: string | number;
}

class Repository<T extends HasId> {
  private items = new Map<T["id"], T>();

  save(item: T): void {
    this.items.set(item.id, item);
  }

  findById(id: T["id"]): T | undefined {
    return this.items.get(id);
  }

  findAll(): T[] {
    return Array.from(this.items.values());
  }
}

// Uso
interface User extends HasId { id: string; name: string; email: string; }
const userRepo = new Repository<User>();
userRepo.save({ id: "u1", name: "Alice", email: "alice@example.com" });
```

## Tecnologías principales

| Herramienta | Propósito |
|-------------|-----------|
| **tsc** | Compilador oficial de TypeScript |
| **ts-node / tsx** | Ejecución directa de TypeScript en Node.js |
| **esbuild / swc** | Compilación ultrarrápida de TS (sin type-checking) |
| **Vite** | Bundler con soporte nativo TS (esbuild para dev, Rollup para prod) |
| **tsconfig.json** | Configuración del compilador (strict mode recomendado) |
| **ESLint + @typescript-eslint** | Linting con reglas específicas de TypeScript |
| **Prettier** | Formateo de código consistente |
| **Prisma / TypeORM / Drizzle** | ORMs con tipado fuerte para bases de datos |
| **zod / valibot / yup** | Validación de esquemas en runtime con inferencia de tipos |
| **tRPC** | End-to-end typesafe APIs (compartir tipos entre frontend y backend) |

## tsconfig.json recomendado

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "outDir": "dist",
    "declaration": true,
    "sourceMap": true
  },
  "include": ["src"]
}
```

## Buenas prácticas

- Activar `strict: true` en tsconfig (incluye noImplicitAny, strictNullChecks, etc.)
- Preferir `interface` sobre `type` para objetos que puedan extenderse (declaration merging)
- Usar `unknown` en lugar de `any` para valores de tipo desconocido (requiere type guard)
- Evitar `as` (type assertion); preferir type guards o satisfies
- Marcar funciones con tipos explícitos en parámetros y retorno
- Usar `ReadonlyArray<T>` y `Readonly<T>` para inmutabilidad
- Configurar path aliases en tsconfig (`@/` → `src/`) para imports limpios
- Ejecutar `tsc --noEmit` en CI para type-checking sin compilar
