# 095-Performance — Rendimiento y Escalabilidad

## Descripción del dominio

Directorio dedicado a la optimización del rendimiento y la escalabilidad de sistemas de software. Abarca desde profiling y análisis de cuellos de botella hasta estrategias de caching, CDN, balanceo de carga, escalado horizontal/vertical, optimización de consultas, tuning de JVM/Node/Python y load testing. Cada entrada proporciona técnicas prácticas respaldadas por métricas y benchmarks.

## Conceptos clave

- **Latencia**: Tiempo que tarda una solicitud en completarse (ms, μs)
- **Throughput**: Cantidad de solicitudes procesadas por unidad de tiempo (RPS, TPS, QPS)
- **P99/P95/P50**: Percentiles de latencia — el 99% de las solicitudes se completan en X ms
- **Escalado vertical** (scale up): Aumentar recursos de una máquina (CPU, RAM, disco)
- **Escalado horizontal** (scale out): Añadir más instancias/máquinas al sistema
- **Elasticidad**: Capacidad de escalar automáticamente según la demanda
- **Cuello de botella**: Recurso que limita el rendimiento global del sistema
- **Caching**: Almacenamiento temporal de datos costosos para acelerar accesos repetidos
- **CDN** (Content Delivery Network): Red distribuida de servidores para entregar contenido estático
- **Load balancing**: Distribución de tráfico entre múltiples servidores
- **Connection pooling**: Reutilización de conexiones (DB, HTTP, gRPC) para evitar overhead
- **Throttling**: Limitación de tasa para proteger recursos
- **Backpressure**: Mecanismo para que el consumidor regule la velocidad del productor
- **Amortized cost**: Coste promedio de una operación considerando operaciones costosas ocasionales
- **Cache hit ratio**: Porcentaje de accesos a caché que encuentran datos (ideal > 90%)
- **Cold start**: Tiempo de inicialización de una función serverless o contenedor
- **Tail latency**: Latencia de los percentiles altos (P99, P99.9) que afectan la experiencia percibida

## Tecnologías principales

| Área | Herramientas y tecnologías |
|---|---|
| **Profiling CPU** | perf, flamegraphs, pprof (Go), py-spy (Python), async-profiler (JVM), Xcode Instruments (macOS), VTune (Intel) |
| **Profiling memoria** | Valgrind, heaptrack, malloc-trace, memray (Python), Chrome DevTools Heap, Java JMC |
| **Profiling I/O** | iostat, iotop, strace, blktrace, fio, ioping, fatrace |
| **Profiling red** | tcpdump, Wireshark, iperf3, netdata, eBPF, tc (traffic control) |
| **APM** | Datadog, New Relic, Dynatrace, AppDynamics, Elastic APM, OpenTelemetry, Grafana Tempo |
| **Caching** | Redis, Memcached, Varnish, Nginx caching, CDN (CloudFront, Cloudflare, Akamai), local cache (Caffeine, Guava) |
| **Load testing** | k6, Locust, Artillery, Vegeta, wrk, Hey, Siege, JMeter, Gatling |
| **Bases de datos** | pg_stat_statements, MySQL slow query log, EXPLAIN ANALYZE, indexing, read replicas, sharding |
| **Cloud scaling** | AWS Auto Scaling, Azure VMSS, GCP MIG, K8s HPA/VPA, serverless (Lambda, Cloud Functions) |
| **Message queues** | Kafka, RabbitMQ, Amazon SQS/SNS, Google Pub/Sub, NATS, Pulsar |
| **Web servers** | Nginx tuning, Caddy, Envoy, HAProxy, Traefik, Apache httpd |
| **Frontend** | Lighthouse, Web Vitals, bundle analysis (webpack-bundle-analyzer), lazy loading, code splitting |
| **Lenguajes** | JVM GC tuning, V8 optimization, Python GIL workarounds, Go goroutines, Rust zero-cost abstractions |
| **Sistemas operativos** | Kernel tuning (sysctl), cgroups, CPU governors, I/O schedulers, NUMA, huge pages |

## Hoja de ruta

### Principiante
1. **Métricas básicas** — Entender latencia, throughput, percentiles, error rate
2. **Caching 101** — Cuándo cachear, TTL, invalidación, cache hit ratio
3. **Load testing básico** — wrk/hey para medir RPS de un endpoint
4. **Slow query detection** — EXPLAIN ANALYZE en PostgreSQL, slow query log
5. **Frontend performance** — Lighthouse, Core Web Vitals, lazy loading de imágenes
6. **CDN** — Configurar Cloudflare/CloudFront para assets estáticos

### Intermedio
1. **Profiling con flamegraphs** — perf + FlameGraph para identificar hotspots
2. **Caching en múltiples capas** — Browser → CDN → Redis/ElastiCache → DB query cache
3. **Connection pooling** — Configurar PgBouncer, HikariCP, HTTP keep-alive
4. **Load balancing** — HAProxy/Nginx round-robin, least connections, sticky sessions
5. **Auto-scaling** — Configurar Horizontal Pod Autoscaler (K8s), AWS Auto Scaling
6. **Database indexing** — B-tree, hash, GIN, GiST, composite indexes, partial indexes
7. **APM setup** — Instrumentar con OpenTelemetry + Datadog/Grafana

### Avanzado
1. **JVM GC tuning** — G1GC, ZGC, Shenandoah, GC logs analysis, heap dump analysis
2. **Kernel bypass** — DPDK, XDP, io_uring, AF_XDP para latencia ultra-baja
3. **eBPF profiling** — BCC/bpftrace para tracing en producción sin overhead
4. **NUMA-aware computing** — Bindear procesos/memoria a nodos NUMA específicos
5. **Goroutine/async profiling** — Go scheduler tracing, Python asyncio event loop lag
6. **HTTP/2, HTTP/3, gRPC** — Multiplexing, server push, stream multiplexing, protobuf
7. **Shared memory** — IPC optimizado con mmap, shm_open, memfd_create

### Experto
1. **Sistemas distribuidos** — Raft/Paxos overhead, consistency vs latency tradeoffs
2. **Zero-copy networking** — sendfile, splice, kTLS, TLS record offloading
3. **CPU cache optimization** — Cache line alignment, prefetching, false sharing
4. **Compile-time optimization** — LTO, PGO, BOLT, link-time optimization
5. **Custom allocators** — jemalloc, tcmalloc, mimalloc tuning, arena allocation
6. **Hardware acceleration** — GPU computing, FPGA, ASIC, SmartNIC offload
7. **Global-scale systems** — Anycast routing, multi-region active-active, CRDTs
8. **Chaos performance testing** — Litmus/Gremlin para probar rendimiento bajo fallos

## Relaciones con otros módulos

- `../096-Optimization/` — Optimización de recursos complementaria (código, memoria, costos)
- `../097-Observability/` — Monitoreo, métricas y alertas para rendimiento
- `../003-Databases/` — Optimización de consultas y configuración de DB
- `../005-Cloud/` — Auto-scaling, CDN, balanceo de carga en cloud
- `../006-Containers/` — Resource limits, CPU/memory requests y limits en K8s
- `../010-Architecture/` — Patrones de arquitectura para escalabilidad
- `../026-Web/` — Optimización frontend, Web Vitals, bundle size
- `../034-LLM/` — Optimización de inferencia, kv-caching, quantization
- `../054-Benchmarks/` — Benchmarks comparativos de rendimiento
- `../053-Compliance/` — SLAs de rendimiento y requisitos regulatorios

## Recursos recomendados

- [High Scalability](http://highscalability.com) — Casos de estudio de sistemas escalables
- [Systems Performance (Gregg)](https://www.brendangregg.com/systems-performance-2nd-edition-book.html) — Libro de referencia
- [Brendan Gregg's Website](https://www.brendangregg.com) — Linux performance tools, flamegraphs
- [Google SRE Book](https://sre.google/books/) — Site Reliability Engineering
- [k6 Documentation](https://k6.io/docs/) — Load testing moderno
- [WebPageTest](https://www.webpagetest.org) — Análisis de rendimiento web
- [Lighthouse](https://developer.chrome.com/docs/lighthouse) — Auditoría de rendimiento web
- [USE Method](https://www.brendangregg.com/usemethod.html) — Metodología de análisis de rendimiento
- [Linux Performance Tuning](https://tldp.org/HOWTO/SCSI-2.4-HOWTO/perform.html) — Tuning de kernel
