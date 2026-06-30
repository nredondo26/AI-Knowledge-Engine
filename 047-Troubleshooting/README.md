# 047-Troubleshooting: Solución de Problemas

## Descripción del dominio

La solución de problemas (troubleshooting) es una habilidad crítica en ingeniería de software que abarca la identificación, diagnóstico y resolución de errores, fallos y comportamientos inesperados en sistemas de software. Este módulo proporciona guías estructuradas de debugging, catálogos de errores comunes con sus soluciones, metodologías de diagnosis (como el método científico aplicado a sistemas) y estrategias para la resolución eficiente de incidentes. Cubre desde debugging local en desarrollo hasta la diagnosis de problemas en producción, pasando por el análisis de logs, tracing distribuido, profiling y post-mortems.

## Conceptos clave

- **Metodología de debugging**: Formular hipótesis, aislar variables, replicar el problema, encontrar la causa raíz, verificar la solución, pruebas de regresión
- **Técnicas de debugging**: Puntos de interrupción (breakpoints), watches, step into/over/out, conditional breakpoints, logpoints, reverse debugging
- **Debugging en producción**: Logging estructurado, métricas, tracing distribuido (OpenTelemetry), dashboards, alertas, runbooks
- **Análisis de logs**: grep/Ripgrep, jq para JSON, herramientas de agregación (ELK, Loki, Splunk), patrones de búsqueda, correlación de logs
- **Errores comunes por tecnología**: Stack traces de Python, NullPointerException en Java, undefined is not a function en JS, segfaults en C/C++, deadlocks en Go, borrow checker errors en Rust
- **Problemas de red**: Timeouts, DNS resolution failures, SSL/TLS errors, CORS, rate limiting, connection pooling, proxy issues
- **Problemas de base de datos**: Slow queries, deadlocks, connection exhaustion, index misses, replication lag, data corruption
- **Problemas de infraestructura**: Out of memory, disk full, CPU throttling, container OOMKilled, pod eviction, node failures
- **Debugging de LLM/IA**: Alucinaciones, sesgos, repeticiones, token limits, embeddings incorrectos, drift en respuestas
- **Post-mortem y retrospectivas**: Análisis de causa raíz (RCA), 5 Whys, timeline del incidente, acciones correctivas, seguimiento

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| IDEs y debuggers | VS Code Debugger, PyCharm Debugger, IntelliJ Debugger, GDB, LLDB, Chrome DevTools |
| Logging | ELK Stack (Elasticsearch, Logstash, Kibana), Loki + Grafana, Splunk, Datadog Logs |
| Tracing | OpenTelemetry, Jaeger, Zipkin, AWS X-Ray, Datadog APM, New Relic |
| Profiling | cProfile/py-spy (Python), pprof (Go), perf (Linux), Valgrind, FlameGraphs |
| Infraestructura | kubectl debug, kubectl logs, docker logs, strace, lsof, netstat, tcpdump |
| Monitoreo | Prometheus + Grafana, Datadog, New Relic, Sentry (errores), PagerDuty (alertas) |
| Debugging de APIs | Postman, Insomnia, cURL, Wireshark, mitmproxy, Charles Proxy |
| Bases de datos | EXPLAIN ANALYZE, pg_stat_statements, MySQL Workbench, mongosh profiler, Redis MONITOR |

## Hoja de ruta

1. **Principiante**: Uso de console.log/print debugging — lectura de stack traces — breakpoints básicos en IDE — uso de linter para detectar errores comunes
2. **Intermedio**: Debugging avanzado con condicionales — análisis de logs con grep/jq — profiling básico — depuración de tests — debugging de APIs con Postman/cURL
3. **Avanzado**: Debugging en producción (logs estructurados, tracing) — profiling de rendimiento (CPU, memoria, I/O) — debugging de concurrencia — análisis de memory leaks — debugging de redes con tcpdump/Wireshark
4. **Experto**: Sistemas de debugging automatizado — correlación de métricas, traces y logs — runbooks automatizados — debugging de sistemas distribuidos — análisis de incidentes y post-mortems — debugging de modelos de IA/LLM

## Relaciones con otros módulos

- [012-Testing](../012-Testing/) — Tests que previenen errores y ayudan a aislar problemas
- [093-CommonErrors](../093-CommonErrors/) — Catálogo detallado de errores comunes y sus soluciones
- [097-Observability](../097-Observability/) — Observabilidad como base para el troubleshooting efectivo
- [013-DevOps](../013-DevOps/) — Operaciones y debugging de infraestructura
- [095-Performance](../095-Performance/) — Problemas de rendimiento y su diagnóstico
- [037-AgenticAI](../037-AgenticAI/) — Debugging de agentes autónomos (bucles infinitos, decisiones incorrectas)
- [014-CICD](../014-CICD/) — Debugging de pipelines de CI/CD

## Recursos recomendados

- **Libros**: "Debugging: The 9 Indispensable Rules for Finding Even the Most Elusive Software and Hardware Problems" (Agans), "Effective Debugging" (Spinellis), "The Practice of System and Network Administration" (Limoncelli)
- **Cursos**: "Debugging Techniques" (PluralSight), "Production Debugging for .NET" (Microsoft), "Google SRE: How to Debug" (Google)
- **Herramientas**: Sentry, Datadog, Grafana + Loki, OpenTelemetry, py-spy, Valgrind, Wireshark
- **Artículos**: "Debugging in Production" (Honeycomb), "The Art of Debugging" (freeCodeCamp), "Root Cause Analysis for Software Teams"
