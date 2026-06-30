# 000-Core: Fundamentos de Computación

## Descripción ampliada del dominio

Los fundamentos de computación constituyen la base teórica y práctica sobre la que se construye todo el conocimiento en ingeniería de software. Este módulo cubre desde el análisis de complejidad algorítmica (notación Big O) hasta estructuras de datos fundamentales, algoritmos clásicos, gestión de memoria y principios de arquitectura computacional. Dominar estos conceptos es esencial para escribir código eficiente, escalable y mantenible en cualquier lenguaje o plataforma. El estudio abarca tanto la teoría de la computación (autómatas, computabilidad, NP-completitud) como la aplicación práctica en el diseño de sistemas reales. La correcta elección de estructuras de datos y algoritmos determina el rendimiento, consumo de recursos y escalabilidad de cualquier aplicación, desde sistemas embebidos hasta plataformas cloud que procesan millones de peticiones por segundo.

## Tabla de conceptos clave

| Concepto | Descripción | Ejemplo de uso | Complejidad típica |
|----------|-------------|----------------|-------------------|
| Notación Big O | Medida asintótica de crecimiento de tiempo/espacio | Análisis de algoritmos | O(1), O(log n), O(n), O(n²) |
| Arrays | Colección contigua de elementos en memoria | Buffer, matriz, caché lineal | O(1) acceso, O(n) búsqueda |
| Listas enlazadas | Nodos conectados por punteros | Cola de procesos, editor de texto | O(1) inserción/borrado (conocida posición) |
| Árboles binarios | Jerarquía de nodos con máximo 2 hijos | Índices de base de datos, parseo de expresiones | O(log n) promedio |
| Tablas hash | Mapeo clave-valor con función hash | Cachés, diccionarios, conjuntos | O(1) promedio, O(n) peor caso |
| Grafos | Conjunto de nodos y aristas | Redes sociales, mapas, dependencias | O(V+E) BFS/DFS |
| Programación dinámica | Optimización por subproblemas superpuestos | Fibonacci, mochila, shortest path | O(n²) típico |
| Divide y vencerás | Dividir problema en subproblemas independientes | MergeSort, QuickSort | O(n log n) |
| Algoritmos greedy | Elección óptima local para solución global | Huffman, Dijkstra, cambio de moneda | O(n log n) típico |
| Backtracking | Búsqueda sistemática con retroceso | N-reinas, Sudoku, laberintos | O(2ⁿ) en peor caso |

## Tecnologías principales

| Categoría | Tecnologías | Propósito |
|-----------|-------------|-----------|
| Libros canónicos | CLRS, Skiena, SICP, Knuth (TAOCP) | Referencia teórica y práctica |
| Visualización | VisuAlgo, Algorithm Visualizer, Python Tutor | Aprendizaje interactivo |
| Plataformas de práctica | LeetCode, HackerRank, CodeSignal, Exercism, Project Euler | Entrenamiento algorítmico |
| Lenguajes de implementación | Python (prototipado), C++ (rendimiento), Java (robustez), Rust (seguridad) | Diferentes compensaciones |
| Herramientas de profiling | Valgrind, perf, GDB, big-O profiler | Análisis de rendimiento |
| Bibliotecas estándar | STL (C++), Java Collections, Python stdlib, Rust std | Implementaciones probadas |
| Competiciones | ICPC, Codeforces, TopCoder, Google Code Jam | Resolución de problemas avanzados |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Variables, condicionales, bucles, funciones. Tipos de datos básicos. Arrays y strings unidimensionales. Complejidad O(1), O(n). Algoritmos de búsqueda lineal. Ordenamiento por burbuja e inserción. Recursión básica (factorial, Fibonacci).
   - Proyecto: Implementar una calculadora con pila de operaciones.
   - Lectura: Capítulos 1-3 de CLRS.

2. **Intermedio (3-6 meses)**: Listas enlazadas (simples, dobles, circulares). Pilas, colas, deque. Ordenamiento O(n log n): MergeSort, QuickSort, HeapSort. Árboles binarios, BST, recorridos (inorder, preorder, postorder). Tablas hash con manejo de colisiones. Búsqueda binaria. Divide y vencerás. Backtracking básico.
   - Proyectos: Implementar un sistema de archivos simple con árbol. Motor de búsqueda con índice invertido.
   - Lectura: Capítulos 4-12 de CLRS.

3. **Avanzado (6-12 meses)**: Grafos: BFS, DFS, Dijkstra, Bellman-Ford, Floyd-Warshall, A*. Programación dinámica (mochila, LCS, edit distance, subsecuencia máxima). Árboles balanceados (AVL, Red-Black, B-Trees). Heaps y priority queues. Algoritmos de string matching (KMP, Rabin-Karp, Boyer-Moore). Análisis amortizado. Ordenamiento topológico. Minimum Spanning Tree (Kruskal, Prim).
   - Proyectos: Implementar un motor de rutas GPS. Sistema de recomendación colaborativo.
   - Lectura: Capítulos 15-26 de CLRS.

4. **Experto (12+ meses)**: Algoritmos paralelos y distribuidos (MapReduce, MPI). Estructuras de datos persistentes y funcionales. Teoría de la computación: autómatas finitos, pushdown, máquinas de Turing, NP-completitud (reducciones, SAT, 3-SAT, TSP). Cachés y algoritmos caché-aware (LRU, LFU, ARC). Algoritmos cuánticos (Shor, Grover). Geometría computacional (convex hull, closest pair). Análisis probabilístico y randomized algorithms.
   - Proyectos: Implementar un optimizador de consultas SQL. Diseñar un sistema de caché distribuida.
   - Lectura: TAOCP (Knuth), "Computational Geometry" (de Berg), Quantum Computing papers.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [001-Languages](../001-Languages/) | Implementación concreta de cada estructura y algoritmo en distintos lenguajes |
| [003-Databases](../003-Databases/) | Índices B-tree y hash, planes de ejecución, optimización de consultas |
| [004-OperatingSystems](../004-OperatingSystems/) | Gestión de memoria virtual, planificación de procesos, page replacement (LRU, Clock) |
| [008-Networking](../008-Networking/) | Algoritmos de enrutamiento (OSPF, BGP), control de congestión, checksums |
| [009-Security](../009-Security/) | Algoritmos criptográficos (RSA, AES), hash seguros (SHA-256), complejidad de ataque |
| [033-DeepLearning](../033-DeepLearning/) | Algoritmos de optimización (SGD, Adam), backpropagation como regla de la cadena |
| [040-Reasoning](../040-Reasoning/) | Razonamiento lógico, árboles de decisión, inferencia |
| [042-Documentation](../042-Documentation/) | Documentación técnica de estructuras de datos |

## Recursos recomendados

- **Libros**: "Introduction to Algorithms" (CLRS, 4ª ed.), "The Art of Computer Programming" (Knuth, vols 1-4), "Algorithm Design Manual" (Skiena, 3ª ed.), "Cracking the Coding Interview" (McDowell, 6ª ed.), "Competitive Programming" (Halim).
- **Cursos**: MIT 6.006 Introduction to Algorithms, Stanford CS106B, Princeton Coursera Algorithms Specialization (Sedgewick), MIT 6.046J Design and Analysis of Algorithms.
- **Papers**: "Big O notation" (Bachmann–Landau), "Time bounds for selection" (Blum et al.), "A note on the complexity of sorting" (Ford-Johnson).
- **Herramientas**: Valgrind (memcheck), perf (Linux profiling), GDB (debugger), callgrind (cache profiling), Compiler Explorer (godbolt.org).

## Notas adicionales

Los fundamentos de computación no son solo teoría académica; empresas como Google, Meta, Amazon, Microsoft y Apple evalúan extensivamente estos conocimientos en sus procesos de entrevista técnica. La práctica deliberada en plataformas como LeetCode (alrededor de 300 problemas resueltos cubren la mayoría de patrones) es el camino recomendado para dominar el módulo. La combinación de estudio teórico con implementación práctica y participación en competiciones (Codeforces, ICPC) acelera significativamente el aprendizaje.
