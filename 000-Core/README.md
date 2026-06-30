# 000-Core: Fundamentos de Computación

## Descripción del dominio

Los fundamentos de computación constituyen la base teórica y práctica sobre la que se construye todo el conocimiento en ingeniería de software. Este módulo cubre desde el análisis de complejidad algorítmica (notación Big O) hasta estructuras de datos fundamentales, algoritmos clásicos, gestión de memoria y principios de arquitectura computacional. Dominar estos conceptos es esencial para escribir código eficiente, escalable y mantenible en cualquier lenguaje o plataforma.

## Conceptos clave

- **Notación Big O**: O(1), O(log n), O(n), O(n log n), O(n²), O(2ⁿ) — análisis de complejidad temporal y espacial
- **Estructuras de datos lineales**: Arrays, listas enlazadas (simples, dobles, circulares), pilas (stacks), colas (queues), deque
- **Estructuras de datos no lineales**: Árboles (binarios, AVL, rojo-negro, B-tree, trie), grafos (dirigidos, no dirigidos, ponderados)
- **Tablas hash**: Funciones hash, manejo de colisiones (encadenamiento, direccionamiento abierto), factor de carga
- **Algoritmos de ordenamiento**: QuickSort, MergeSort, HeapSort, InsertionSort, BubbleSort — estabilidad y complejidad comparativa
- **Algoritmos de búsqueda**: Búsqueda binaria, BFS, DFS, Dijkstra, A*, Bellman-Ford, Floyd-Warshall
- **Técnicas algorítmicas**: Recursión, divide y vencerás, programación dinámica, backtracking, greedy, ramificación y poda
- **Gestión de memoria**: Stack vs heap, asignación dinámica, garbage collection, fragmentación, memory leaks
- **Paradigmas de programación**: Imperativo, funcional, orientado a objetos, lógico, concurrente
- **Representación de datos**: Binario, hexadecimal, complemento a dos, punto flotante (IEEE 754), codificación de caracteres (ASCII, Unicode, UTF-8)
- **Compiladores vs intérpretes**: Análisis léxico, sintáctico, semántico; generación de código intermedio, optimización

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Libros canónicos | "Introduction to Algorithms" (CLRS), "The Algorithm Design Manual" (Skiena), "Structure and Interpretation of Computer Programs" (SICP) |
| Herramientas de visualización | VisuAlgo, Algorithm Visualizer, Python Tutor |
| Plataformas de práctica | LeetCode, HackerRank, CodeSignal, Exercism, Project Euler |
| Lenguajes para algoritmos | Python (rápido prototipado), C++ (máximo rendimiento), Java (robustez), Rust (seguridad de memoria) |
| Analizadores de complejidad | Big-O Calculator, Complexity Profiler |

## Hoja de ruta

1. **Principiante**: Variables, condicionales, bucles, funciones — tipos de datos básicos — arrays y strings — complejidad O(1), O(n)
2. **Intermedio**: Listas enlazadas, pilas, colas — recursión — ordenamiento O(n²) → O(n log n) — árboles binarios — tablas hash
3. **Avanzado**: Grafos, BFS/DFS — programación dinámica — árboles balanceados — algoritmos de string matching (KMP, Rabin-Karp) — análisis amortizado
4. **Experto**: Algoritmos paralelos y distribuidos — estructuras de datos persistentes — teoría de la computación (autómatas, NP-completitud) — cachés y memoria caché-aware — algoritmos cuánticos

## Relaciones con otros módulos

- [001-Languages](../001-Languages/) — Implementación concreta de estructuras y algoritmos en cada lenguaje
- [003-Databases](../003-Databases/) — Índices (B-tree, hash indexes), planes de ejecución, optimización de queries
- [004-OperatingSystems](../004-OperatingSystems/) — Gestión de memoria virtual, planificación de procesos, page replacement algorithms
- [008-Networking](../008-Networking/) — Algoritmos de enrutamiento, control de congestión, checksums
- [009-Security](../009-Security/) — Algoritmos criptográficos, funciones hash seguras, complejidad de ataque
- [033-DeepLearning](../033-DeepLearning/) — Algoritmos de optimización (SGD, Adam), backward propagation como aplicación de regla de la cadena
- [052-Standards](../052-Standards/) — Notación asintótica estándar, representación de datos conforme a IEEE

## Recursos recomendados

- **Libros**: "Introduction to Algorithms" (CLRS, MIT Press), "The Art of Computer Programming" (Knuth), "Cracking the Coding Interview" (McDowell)
- **Cursos**: MIT 6.006 Introduction to Algorithms, Stanford CS106B, Coursera Algorithms Specialization (Princeton)
- **Papers**: "Big O notation" (Bachmann–Landau), "Time bounds for selection" (Blum, Floyd, Pratt, Rivest, Tarjan)
- **Herramientas**: Valgrind (detección de memory leaks), perf (profiling), GDB (depuración baja)
