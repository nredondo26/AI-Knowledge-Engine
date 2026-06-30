# 001-Languages: Lenguajes de Programación

## Descripción del dominio

Los lenguajes de programación son el vehículo mediante el cual los desarrolladores traducen la lógica computacional en instrucciones ejecutables. Este módulo cubre los lenguajes más relevantes de la industria actual, incluyendo sus paradigmas, ecosistemas, herramientas de compilación/interpretación, gestores de paquetes y mejores prácticas. Comprender múltiples lenguajes permite seleccionar la herramienta adecuada para cada problema y facilita la adaptación a nuevas tecnologías.

## Conceptos clave

- **Tipado**: Estático vs dinámico, fuerte vs débil, inferencia de tipos, duck typing, tipado nominal vs estructural
- **Paradigmas**: Orientado a objetos, funcional, procedural, declarativo, multiparadigma
- **Gestión de memoria**: Manual (C/C++), garbage collector (Java, Go, JS), ownership/borrowing (Rust), ARC (Swift)
- **Sistema de módulos**: Paquetes, namespaces, módulos ES6, crates (Rust), packages (Go), módulos Python
- **Concurrencia**: Threads, async/await, corrutinas, goroutines, actor model, STM, parallelism
- **Compilación vs interpretación**: Compiladores AOT, intérpretes puros, JIT (V8, HotSpot, PyPy), transpilación
- **Tipos de datos primitivos vs compuestos**: Structs, enums, uniones, tuples, records, sealed classes
- **Genéricos y polimorfismo**: Templates, type erasure, monomorfización, traits, interfaces, protocols
- **Metaprogramación**: Macros (Rust, Elixir), generics, decoradores (Python), anotaciones (Java), eval
- **Manejo de errores**: Excepciones, Result/Either, Option/Optional, panic, error handling idiomático
- **Interoperabilidad**: FFI (Foreign Function Interface), WASM, JNI, language bridges

## Tecnologías principales

| Lenguaje | Paradigma | Tipado | Runtime | GC | Uso principal |
|----------|-----------|--------|--------|-----|--------------|
| Python | Multiparadigma | Dinámico fuerte | CPython/PyPy | Sí | Ciencia de datos, web, scripting |
| JavaScript | Multiparadigma | Dinámico débil | V8/SpiderMonkey | Sí | Web, Node.js, full-stack |
| TypeScript | OOP+Funcional | Estático fuerte (con inferencia) | V8/SpiderMonkey | Sí | Web apps empresariales |
| Java | OOP | Estático fuerte | JVM (HotSpot) | Sí | Enterprise, Android, backend |
| Go | Concurrente+Estructural | Estático fuerte | Nativo | Sí | Microservicios, CLI, red |
| Rust | Multiparadigma | Estático fuerte | LLVM (Nativo) | No | Sistemas, WASM, rendimiento crítico |
| C++ | Multiparadigma | Estático débil | Nativo (LLVM/GCC) | No | Videojuegos, motores, sistemas |
| C# | OOP+Funcional | Estático fuerte | .NET CLR | Sí | Windows, Unity, enterprise |
| Kotlin | OOP+Funcional | Estático fuerte | JVM/Native | Sí | Android, backend |
| Swift | OOP+Funcional | Estático fuerte | LLVM/ObjC runtime | No (ARC) | Apple ecosystem |
| Ruby | OOP puro | Dinámico fuerte | YARV/CRuby | Sí | Web (Rails), scripting |

## Hoja de ruta

1. **Principiante**: Elegir un lenguaje (Python o JS recomendado) — sintaxis básica — tipos y operadores — estructuras de control — funciones — entrada/salida
2. **Intermedio**: POO — manejo de errores — colecciones y streams — módulos y paquetes — testing unitario — debugger
3. **Avanzado**: Concurrencia (threads, async) — patrones de diseño — metaprogramación — optimización — integración continua
4. **Experto**: Compiladores/interpretes — FFI/WASM — contribución al runtime — DSLs — diseño de lenguajes

## Relaciones con otros módulos

- [000-Core](../000-Core/) — Implementación de estructuras de datos y algoritmos en cada lenguaje
- [002-Frameworks](../002-Frameworks/) — Frameworks construidos sobre estos lenguajes
- [003-Databases](../003-Databases/) — Drivers y ORMs para conectar desde cada lenguaje
- [006-Containers](../006-Containers/) — Dockerización de aplicaciones en distintos lenguajes
- [009-Security](../009-Security/) — Prácticas seguras específicas de cada lenguaje
- [004-OperatingSystems](../004-OperatingSystems/) — Syscalls, procesos y gestión de memoria nativa
- [026-Web](../026-Web/) — Lenguajes del lado cliente (JS/TS) y servidor (todos)

## Recursos recomendados

- **Python**: "Fluent Python" (Ramalho), Python.org, Real Python, PyCon talks
- **JavaScript/TS**: "You Don't Know JS" (Simpson), MDN Web Docs, TypeScript Handbook
- **Java**: "Effective Java" (Bloch), Baeldung, Oracle Java Docs, Spring Academy
- **Go**: "The Go Programming Language" (Donovan, Kernighan), go.dev, Go by Example
- **Rust**: "The Rust Programming Language" (Klabnik, Nichols), rust-lang.org, Rust Cookbook
- **C++**: "The C++ Programming Language" (Stroustrup), cppreference.com, ISO C++ standards
