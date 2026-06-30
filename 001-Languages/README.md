# 001-Languages: Lenguajes de Programación

## Descripción ampliada del dominio

Los lenguajes de programación son el vehículo mediante el cual los desarrolladores traducen la lógica computacional en instrucciones ejecutables. Este módulo cubre los lenguajes más relevantes de la industria actual, incluyendo sus paradigmas, ecosistemas, herramientas de compilación/interpretación, gestores de paquetes y mejores prácticas. Comprender múltiples lenguajes permite seleccionar la herramienta adecuada para cada problema y facilita la adaptación a nuevas tecnologías. La evolución de los lenguajes refleja la historia de la computación: desde el ensamblador y Fortran (años 50-60), pasando por C (70s), C++ y Java (80s-90s), hasta lenguajes modernos como Rust, Go y TypeScript (2010s-presente). Cada lenguaje representa un conjunto de compensaciones (trade-offs) entre rendimiento, seguridad, productividad y expresividad. La tendencia actual incluye lenguajes con tipado estático con inferencia (Rust, Go, TypeScript), concurrencia como ciudadano de primera clase (Go, Kotlin), y sistemas de ownership para seguridad de memoria sin GC (Rust). Special mention merecen los DSLs (Domain-Specific Languages) incorporados o externos, y los lenguajes de scripting para automatización y glue code.

## Tabla de conceptos clave

| Concepto | Descripción | Lenguajes representativos |
|----------|-------------|--------------------------|
| Tipado estático | Tipos verificados en compilación, menor error en runtime | Java, C++, Rust, TypeScript, Go |
| Tipado dinámico | Tipos verificados en runtime, mayor flexibilidad | Python, Ruby, JavaScript, PHP |
| Tipado fuerte | No hay coerción implícita entre tipos incompatibles | Python, Rust, Java, Go |
| Tipado débil | Coerción implícita entre tipos | JavaScript, PHP, C |
| Inferencia de tipos | El compilador deduce tipos automáticamente | Rust, Go, TypeScript, Kotlin, Haskell |
| Gestión manual de memoria | malloc/free, new/delete, sin GC | C, C++, Zig |
| GC (Garbage Collection) | Recolección automática de basura | Java, Go, Python, JS, C# |
| Ownership/Borrowing | Propiedad única con préstamo verificado por compilador | Rust |
| ARC (Auto Reference Counting) | Conteo de referencias automático | Swift, ObjC |
| Compilación AOT | Compilación anticipada a código nativo | C, C++, Rust, Go, Swift |
| Compilación JIT | Compilación en tiempo de ejecución | Java (HotSpot), JS (V8), C# (RyujIT) |
| Interpretación pura | Ejecución directa sin compilación previa | Python, Ruby, Bash |
| FFI (Foreign Function Interface) | Llamada a funciones de otro lenguaje | Rust, Python (ctypes), Java (JNI) |
| WASM | WebAssembly: ejecución en navegador y servidor | Rust, C/C++, Go, AssemblyScript |

## Tecnologías principales

| Lenguaje | Paradigma | Tipado | Runtime | GC | Gestión memoria | Uso principal | Índice TIOBE (2025) |
|----------|-----------|--------|--------|-----|-----------------|--------------|-------------------|
| Python | Multiparadigma | Dinámico fuerte | CPython/PyPy | Sí | GC | Ciencia datos, web, scripting, IA | #1 |
| JavaScript | Multiparadigma | Dinámico débil | V8/SpiderMonkey | Sí | GC | Web, Node.js, full-stack | #3 |
| TypeScript | OOP+Funcional | Estático (inferido) | V8/SpiderMonkey | Sí | GC | Web apps empresariales, full-stack | #4 |
| Java | OOP | Estático fuerte | JVM (HotSpot) | Sí | GC | Enterprise, Android, backend | #2 |
| Go | Concurrente | Estático fuerte | Nativo (GC) | Sí | GC | Microservicios, CLI, red, cloud | #6 |
| Rust | Multiparadigma | Estático fuerte | LLVM (Nativo) | No | Ownership | Sistemas, WASM, rendimiento crítico | #10 |
| C++ | Multiparadigma | Estático débil | LLVM/GCC (Nativo) | No | Manual | Videojuegos, motores, sistemas | #5 |
| C# | OOP+Funcional | Estático fuerte | .NET CLR | Sí | GC | Windows, Unity, enterprise | #7 |
| Kotlin | OOP+Funcional | Estático fuerte | JVM/Native/JS | Sí | GC | Android, backend, multiplataforma | #12 |
| Swift | OOP+Funcional | Estático fuerte | LLVM/ObjC | No | ARC | Apple ecosistema (iOS, macOS) | #11 |
| Ruby | OOP puro | Dinámico fuerte | YARV/CRuby | Sí | GC | Web (Rails), scripting | #15 |
| PHP | Procedural+OOP | Dinámico débil | Zend Engine | Sí | GC | Web (WordPress, Laravel) | #8 |
| Zig | Multiparadigma | Estático fuerte | Nativo (LLVM) | No | Manual | Sistemas, reemplazo moderno de C | #30 |

## Hoja de ruta detallada

1. **Principiante (0-4 meses)**: Elegir un lenguaje inicial (Python o JavaScript recomendado por su curva de aprendizaje suave). Sintaxis básica: variables, tipos, operadores, estructuras de control (if, for, while, switch). Funciones: parámetros, retorno, ámbito de variables (scope). Estructuras de datos básicas: listas/arrays, diccionarios/objetos, sets. Entrada/salida estándar y manejo de archivos. Debugging básico con prints y debugger.
   - Proyecto: Script de procesamiento de CSV. Juego de adivinanza. Agenda de contactos en terminal.
   - Lectura: Documentación oficial del lenguaje elegido + curso interactivo (Codecademy, freeCodeCamp).

2. **Intermedio (4-8 meses)**: Programación orientada a objetos: clases, herencia, polimorfismo, encapsulación, interfaces/traits. Manejo de errores: excepciones, Result/Option, try/catch/finally. Colecciones avanzadas: iteradores, generadores, comprehensions. Módulos y paquetes: importación, namespaces, publicación de paquetes. Testing unitario con frameworks del lenguaje (pytest, Jest, JUnit). Uso de gestores de paquetes (pip, npm, cargo, go mod). Expresiones regulares. Fechas, tiempos y formatos.
   - Proyecto: API REST simple con framework del lenguaje. CLI tool con argumentos y flags.
   - Lectura: Libro canónico del lenguaje ("Fluent Python", "Effective Java", "The Rust Book").

3. **Avanzado (8-14 meses)**: Concurrencia: threads, async/await, corrutinas, goroutines, canales, futures/promises, actor model. Patrones de diseño en el lenguaje. Metaprogramación: macros, decoradores, anotaciones, reflection, eval. Optimización y profiling: benchmarks, memory profiling, CPU profiling, cache misses. Integración continua y pipelines para el lenguaje. Empaquetado y distribución. Interoperabilidad: FFI, WASM, JNI. Tipos avanzados: genéricos, uniones discriminadas, pattern matching. Serialización (JSON, Protobuf, MessagePack, Avro). Concurrencia con estado compartido y locks.
   - Proyecto: Servidor web concurrente procesando peticiones. Compilador/transpilador simple. Base de datos embebida.
   - Lectura: Patrones de concurrencia, "Effective" series, documentación avanzada del runtime.

4. **Experto (14+ meses)**: Compiladores e intérpretes: análisis léxico, sintáctico, semántico; generación de código; optimización. Implementación de runtime: GC, scheduler, memory allocator. Contribuciones al compilador o runtime del lenguaje (CPython, V8, LLVM, rustc). Diseño e implementación de DSLs. Análisis estático: linters avanzados, type checkers, verificación formal. Frameworks de testing de propiedad (QuickCheck). Seguridad a nivel de lenguaje: memory safety, type safety, constant-time operations. Ecosistema WASM: compilación de lenguajes a WASM, optimización. Implementación de lenguajes de programación (creación de un lenguaje nuevo).
   - Proyecto: Contribución a un compilador open source. Implementación de un lenguaje de programación turing-completo. Optimizador de bytecode.
   - Lectura: "Engineering a Compiler" (Cooper, Torczon), "Crafting Interpreters" (Nystrom), papers de diseño de lenguajes.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Implementación concreta de estructuras y algoritmos en cada lenguaje |
| [002-Frameworks](../002-Frameworks/) | Frameworks construidos sobre estos lenguajes para acelerar desarrollo |
| [003-Databases](../003-Databases/) | Drivers y ORMs específicos de cada lenguaje para persistencia |
| [006-Containers](../006-Containers/) | Dockerización de aplicaciones según runtime de cada lenguaje |
| [009-Security](../009-Security/) | Prácticas de seguridad específicas por lenguaje (memory safety, injection) |
| [004-OperatingSystems](../004-OperatingSystems/) | Syscalls, procesos, hilos y gestión de memoria nativa |
| [026-Web](../026-Web/) | Lenguajes frontend (JS/TS) y backend (Python, Java, Go, Rust, etc.) |
| [030-Robotics](../030-Robotics/) | C++, Python para ROS; Rust para sistemas embebidos en robótica |
| [031-AI](../031-AI/) | Python como lenguaje dominante en IA; Julia para investigación |
| [041-CodeGeneration](../041-CodeGeneration/) | LLMs generan código en estos lenguajes; Copilot, Codex |

## Recursos recomendados

- **Python**: "Fluent Python" (Ramalho, 2ª ed.), Python.org, Real Python, PyCon videos, "Python Cookbook" (Beazley).
- **JavaScript/TypeScript**: "You Don't Know JS Yet" (Simpson), MDN Web Docs, TypeScript Handbook, "Effective TypeScript" (Vanderkam).
- **Java**: "Effective Java" (Bloch, 3ª ed.), Baeldung, Oracle Java Docs, Spring Academy, "Java Concurrency in Practice" (Goetz).
- **Go**: "The Go Programming Language" (Donovan, Kernighan), go.dev, Go by Example, "Concurrency in Go" (Cox-Buday).
- **Rust**: "The Rust Programming Language" (Klabnik, Nichols), rust-lang.org, Rust Cookbook, "Rust for Rustaceans" (Gjengset).
- **C++**: "The C++ Programming Language" (Stroustrup, 4ª ed.), cppreference.com, "Effective Modern C++" (Meyers).
- **C#**: "C# in Depth" (Skeet), Microsoft Docs, "CLR via C#" (Richter), .NET official blog.
- **Kotlin**: "Kotlin in Action" (Jemerov, Isakova), kotlinlang.org, Kotlin Weekly newsletter.
- **Swift**: "The Swift Programming Language" (Apple), Hacking with Swift, Swift by Sundell.

## Notas adicionales

La poliglotía (dominio de múltiples lenguajes) es una habilidad altamente valorada en la industria. Se recomienda aprender al menos un lenguaje de cada paradigma: uno con tipado estático (Java, Rust), uno dinámico (Python, JS), uno funcional (Haskell, Elixir), y uno de sistemas (C, Rust). Esto proporciona una perspectiva amplia y facilita el aprendizaje de nuevos lenguajes en el futuro.
