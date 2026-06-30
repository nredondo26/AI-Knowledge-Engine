# 096-Optimization — Optimización de Recursos

## Descripción del dominio

Directorio enfocado en la optimización integral de recursos en sistemas de software: código, memoria, almacenamiento, red, costos cloud y eficiencia energética. Abarca técnicas de refactorización para eficiencia, reducción de footprint de memoria, optimización de almacenamiento, reducción de costos en infraestructura cloud, estrategias de compresión, deduplicación y patrones de diseño para eficiencia. El objetivo es maximizar el rendimiento por unidad de recurso consumido.

## Conceptos clave

- **Space-time tradeoff**: Compromiso entre memoria usada y tiempo de ejecución
- **Big O analysis**: Complejidad algorítmica para elegir la implementación más eficiente
- **Memory footprint**: Cantidad total de memoria que consume un proceso/aplicación
- **Object pooling**: Reutilización de objetos para evitar allocación frecuente
- **Copy-on-write** (COW): Diferir la copia hasta que sea necesario escribir
- **Lazy initialization**: Crear recursos solo cuando se necesitan por primera vez
- **Compresión**: Reducir tamaño de datos (gzip, brotli, zstd, snappy, lz4)
- **Deduplicación**: Eliminar datos duplicados almacenando una sola copia
- **Minificación**: Eliminar caracteres innecesarios de código (JS, CSS, HTML)
- **Tree shaking**: Eliminar código muerto no importado en bundles
- **Dead code elimination** (DCE): Remover código inalcanzable en compilación
- **Deforestation**: Eliminar estructuras de datos intermedias en pipelines funcionales
- **Inlining**: Reemplazar llamadas a función con el cuerpo de la función
- **Tail call optimization** (TCO): Optimizar recursión para evitar stack overflow
- **AOT compilation**: Compilar a código nativo antes de ejecución (vs JIT)
- **Carbon intensity**: Eficiencia energética del software (green coding)
- **Cloud cost optimization**: Reduction de gastos en infraestructura cloud (Rightsizing, Spot instances, Reserved instances)
- **SLA-driven optimization**: Ajustar recursos según los SLAs, no por exceso

## Tecnologías principales

| Área de optimización | Herramientas y técnicas |
|---|---|
| **Código / algoritmos** | Profiling-driven refactoring, hot path optimization, loop unrolling, strength reduction, memoization |
| **Memoria** | jemalloc/tcmalloc, arena allocators, slab allocators, garbage collector tuning, object pooling, stack allocation, struct of arrays (SoA) vs array of structs (AoS) |
| **Almacenamiento** | Compresión (zstd, brotli), columnar storage (Parquet, ORC), tiered storage (hot/warm/cold), S3 Intelligent-Tiering, EBS gp3 vs io2 |
| **Red** | HTTP/2 multiplexing, gRPC streaming, protocol buffers, message packing, TCP/IP tuning, QUIC, connection reuse |
| **Cloud (AWS)** | EC2 Rightsizing, Savings Plans, Spot Instances, S3 Lifecycle, RDS Reserved Instances, Lambda provisioned concurrency, Fargate Spot |
| **Cloud (Azure)** | Azure Reservations, Spot VMs, Autoscale, Blob Storage tiers, Cosmos DB autoscale |
| **Cloud (GCP)** | Committed Use Discounts, Preemptible VMs, Cloud Storage Nearline/Coldline, BigQuery flat-rate vs on-demand |
| **Frontend** | Code splitting, bundle analysis, dynamic imports, image optimization (WebP, AVIF), font subsetting, critical CSS |
| **Compilación** | LTO (Link Time Optimization), PGO (Profile Guided Optimization), BOLT (Binary Optimization), -O3, -Os |
| **Bases de datos** | Query optimization, indexing strategy, materialized views, partitioning, clustering, vacuum/analyze |
| **Energía** | Green coding, power profiling (RAPL), idle polling reduction, efficient algorithms, ARM vs x86 efficiency |
| **Kubernetes** | VPA (Vertical Pod Autoscaler), cluster autoscaler, node pools optimization, right-sizing requests/limits |

## Hoja de ruta

### Principiante
1. **Complejidad algorítmica** — Elegir estructura de datos correcta (hash vs list, set vs array)
2. **Minificación y compresión** — Minificar JS/CSS, habilitar gzip/brotli en servidor web
3. **Imágenes** — Optimizar imágenes (WebP, AVIF, lazy loading, responsive images)
4. **Caching básico** — Cachear respuestas HTTP, static assets, DNS cache
5. **Reducir peticiones HTTP** — Bundle CSS/JS, sprites, inline small assets
6. **Database queries** — SELECT solo columnas necesarias, usar LIMIT, evitar N+1 queries

### Intermedio
1. **Memory profiling** — Identificar memory leaks con heap dumps, object allocation hotspots
2. **Code splitting** — Dividir bundles JS por rutas/páginas con lazy loading
3. **Connection pool tuning** — Ajustar pool size según concurrencia y latencia de DB
4. **Cloud rightsizing** — Analizar métricas de CPU/RAM y elegir instancia óptima
5. **Compresión de datos** — Elegir algoritmo según ratio vs velocidad (zstd vs gzip vs lz4)
6. **Tree shaking** — Configurar Webpack/vite/esbuild para eliminar código muerto
7. **AOT vs JIT** — Compilar a nativo con GraalVM o NativeAOT para reducir cold start

### Avanzado
1. **Profile Guided Optimization (PGO)** — Compilar con perfiles de ejecución real
2. **Custom memory allocators** — jemalloc/tcmalloc tuning para el workload específico
3. **Arena allocation** — Asignación de memoria en lotes para reducir fragmentación
4. **Zero-copy deserialization** — Flatbuffers, Cap'n Proto vs JSON/protobuf
5. **SIMD vectorization** — Usar instrucciones SIMD (AVX2, AVX-512, NEON) para cómputo paralelo
6. **Data-oriented design** — Organizar datos en memoria para maximizar cache hits
7. **Lock-free data structures** — Eliminar contención con CAS, RCU, hazard pointers
8. **Cloud cost optimization avanzada** — Spot instances, reserved capacity, multi-cloud arbitrage

### Experto
1. **Custom JIT compilation** — Construir JIT especializado para el dominio del problema
2. **Offline reinforcement learning for resource management** — Auto-tuning de recursos con RL
3. **Hardware-software co-design** — Optimizar para arquitectura específica (cache hierarchy, TLB, prefetcher)
4. **Energy-proportional computing** — Minimizar energía en idle y bajo carga
5. **Algorithmic approximation** — Procesamiento aproximado para ganar órdenes de magnitud en velocidad
6. **In-memory computing** — Bases de datos in-memory (SAP HANA, Redis) para eliminar I/O
7. **Computación heterogénea** — Distribuir carga entre CPU, GPU, FPGA, TPU según eficiencia
8. **Carbon-aware scheduling** — Ejecutar workloads intensivos cuando la red eléctrica es más verde

## Relaciones con otros módulos

- `../095-Performance/` — Rendimiento y escalabilidad (objetivo de la optimización)
- `../031-AI/` — Optimización de modelos, pruning, quantization, distillation
- `../005-Cloud/` — Optimización de costos cloud y rightsizing
- `../003-Databases/` — Optimización de queries, índices y almacenamiento
- `../001-Languages/` — Optimizaciones específicas por lenguaje (Rust zero-cost, Go escape analysis)
- `../010-Architecture/` — Patrones arquitectónicos para eficiencia
- `../006-Containers/` — Container image optimization, multi-stage builds, distroless
- `../026-Web/` — Optimización frontend, bundle size, Core Web Vitals
- `../054-Benchmarks/` — Benchmarks para medir el impacto de las optimizaciones
- `../034-LLM/` — Optimización de inferencia, kv-cache, speculative decoding

## Recursos recomendados

- [The Art of Computer Programming (Knuth)](https://en.wikipedia.org/wiki/The_Art_of_Computer_Programming) — Algoritmos fundamentales
- [What Every Programmer Should Know About Memory](https://people.freebsd.org/~lstewart/articles/cpumemory.pdf) — Arquitectura de memoria
- [Low-Level Academy](https://lowlevel.academy) — Optimización a bajo nivel
- [Compiler Explorer (Godbolt)](https://godbolt.org) — Ver output de assembler de optimizaciones
- [Google's TCMalloc](https://google.github.io/tcmalloc/) — Memory allocator optimizado
- [Facebook's Zstd](https://facebook.github.io/zstd/) — Compresor de alta velocidad
- [Cloudflare Blog](https://blog.cloudflare.com) — Optimizaciones de red y rendimiento
- [AWS Well-Architected Framework — Cost Optimization](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/) — Optimización de costos cloud
- [Green Software Foundation](https://greensoftware.foundation) — Principios de software sostenible
