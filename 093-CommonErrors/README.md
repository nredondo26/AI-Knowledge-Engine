# 093-CommonErrors — Errores Comunes y Soluciones

## Descripción del dominio

Directorio que documenta errores frecuentes en desarrollo, operaciones y despliegue de software, organizados por tecnología. Cada entrada incluye el mensaje de error exacto, el stack trace cuando aplica, la causa raíz, la solución paso a paso y patrones de debugging para identificar el problema rápidamente en el futuro. Actúa como bitácora de conocimiento colectivo para evitar resolver el mismo error dos veces.

## Conceptos clave

- **Error canónico**: Error extremadamente común con solución bien documentada (ej. `port already in use`, `permission denied`)
- **Stack trace**: Traza de llamadas que muestra la secuencia exacta hasta el punto de fallo
- **Causa raíz** (root cause): Origen real del error, no solo el síntoma visible
- **Reproducción mínima**: Conjunto mínimo de pasos para reproducir el error consistentemente
- **Workaround**: Solución temporal mientras se implementa la corrección definitiva
- **Error silencioso**: Fallo que no produce mensaje de error visible pero causa comportamiento incorrecto
- **Heisenbug**: Error que desaparece al intentar depurarlo o al añadir logging
- **Mandelbug**: Error cuya causa es tan compleja que parece tener comportamiento caótico
- **Race condition**: Error dependiente del orden temporal de ejecución entre hilos/procesos
- **Memory leak**: Fuga de memoria que degrada rendimiento progresivamente hasta el crash
- **Off-by-one**: Error clásico de índice fuera por uno (muy común en loops y slicing)
- **Null pointer / undefined**: Acceso a valor nulo o no definido (líder histórico de crashes)
- **Serialization issue**: Error al convertir datos entre formatos (JSON, YAML, protobuf, pickle)
- **Environment drift**: Error que solo ocurre en producción porque difiere del entorno de desarrollo
- **Error handling antipattern**: Capturar excepción y no hacer nada (`except: pass`) o tragar el error

## Tecnologías principales

| Tecnología | Errores típicos documentados |
|---|---|
| **Python** | ImportError, ModuleNotFoundError, KeyError, TypeError, ValueError, RecursionError, MemoryError, GIL contention, circular imports |
| **JavaScript/Node** | `undefined is not a function`, `cannot read property of null`, callback hell, Promise unhandled rejection, ESM vs CJS conflicts, heap out of memory |
| **React** | `setState` en unmounted component, hooks rules violation, stale closure, key prop missing, infinite re-render loop |
| **Docker** | `port already allocated`, `no space left on device` (overlay), `exec format error` (arch mismatch), layer caching issues, `/var/run/docker.sock` permission |
| **Kubernetes** | CrashLoopBackOff, ImagePullBackOff, ErrImagePull, OOMKilled, NodeNotReady, TLSError, CNI plugin failure, RBAC forbidden |
| **Git** | `merge conflict`, `detached HEAD`, `failed to push some refs`, `LF will be replaced by CRLF`, `index.lock` |
| **PostgreSQL** | `deadlock detected`, `could not serialize access`, `out of shared memory`, `too many connections`, `relation does not exist` |
| **Linux** | `cannot allocate memory`, `too many open files`, `device or resource busy`, `connection refused`, `address already in use` |
| **Cloud (AWS)** | `AccessDenied` IAM, `ThrottlingException`, `BucketNotEmpty`, `ValidationError` CloudFormation, `InsufficientInstanceCapacity` |
| **PyTorch/TensorFlow** | CUDA out of memory, device mismatch, shape mismatch, gradient vanishing/exploding, NaN loss |
| **Spring Boot** | `BeanDefinitionStoreException`, `NoSuchBeanDefinition`, circular dependency, port conflict, datasource config error |
| **Nginx** | `permission denied` (selinux), `upstream timed out`, `413 Request Entity Too Large`, SSL handshake failure |

## Hoja de ruta

### Principiante
1. **Errores de sintaxis** — Leer y entender mensajes de error del compilador/intérprete
2. **Errores de entorno** — Node version mismatch, Python version, PATH issues, missing dependencies
3. **Errores de Git** — Conflictos de merge, detached HEAD, force push recovery
4. **Errores HTTP** — 400, 401, 403, 404, 500 — qué significan y cómo debuguearlos
5. **Errores de permisos** — `Permission denied`, `EACCES`, `sudo` vs no-sudo, chmod/chown

### Intermedio
1. **Errores de Docker/K8s** — CrashLoopBackOff, ImagePullBackOff, OOMKilled, eviction
2. **Errores de base de datos** — Deadlocks, connection pool exhaustion, slow queries, locks
3. **Errores de red** — DNS resolution, TLS/SSL handshake, timeout, connection refused, CORS
4. **Errores de memoria** — Memory leaks en Node/Python/Java, stack overflow, heap fragmentation
5. **Errores de concurrencia** — Race conditions, deadlocks, starvation, thread safety, async pitfalls
6. **Errores de serialización** — JSON circular ref, pickle version, protobuf field mismatch, YAML parsing

### Avanzado
1. **Debugging con strace/lsof/gdb** — System calls, file descriptors, signal handling, core dumps
2. **Errores de rendimiento** — TLS/SSL overhead, GC pauses, context switching, cache misses
3. **Errores de seguridad** — Injection, deserialization attacks, SSRF, path traversal, XXE
4. **Errores de distribución** — Split-brain, network partition, clock skew, consensus failure
5. **Errores de kernel** — OOM killer, kernel panic, deadlock en drivers, filesystem corruption
6. **Errores de hardware** — ECC memory errors, disk SMART failures, NIC dropped packets, thermal throttling

### Experto
1. **Análisis post-mortem** — Core dumps, heap dumps, thread dumps, crash logs
2. **Errores deterministas vs no deterministas** — Técnicas para reproducir bugs intermitentes
3. **Chaos engineering** — Principios, herramientas (Chaos Monkey, Litmus), Game Days
4. **Debugging en producción** — Telemetry, distributed tracing, canary analysis, feature flags
5. **Fuzzing** — Generación automática de entradas para descubrir errores ocultos

## Relaciones con otros módulos

- `../047-Troubleshooting/` — Metodologías generales de resolución de problemas
- `../092-FAQ/` — Preguntas frecuentes que complementan errores comunes
- `../052-Standards/` — Estándares de logging y formato de errores
- `../054-Benchmarks/` — Benchmarks que revelan errores de rendimiento
- `../045-Snippets/` — Snippets de código con manejo de errores correcto
- `../046-BestPractices/` — Buenas prácticas para evitar errores comunes
- `../097-Observability/` — Monitoreo y alertas sobre errores en producción
- `../096-Optimization/` — Optimización de código que elimina errores de rendimiento
- `../095-Performance/` — Errores de rendimiento y sus soluciones
- `../049-InterviewQuestions/` — Preguntas sobre errores en entrevistas técnicas

## Recursos recomendados

- [Stack Overflow](https://stackoverflow.com) — Soluciones comunitarias para errores específicos
- [GitHub Issues](https://github.com/issues) — Bug reports y soluciones oficiales
- [ErrorProne](https://errorprone.info) — Detección de errores comunes en Java
- [PyLint](https://pylint.pycqa.org) / [ESLint](https://eslint.org) — Linters que previenen errores
- [Sentry](https://sentry.io) — Plataforma de monitoreo de errores en vivo
- [Rollbar](https://rollbar.com) — Seguimiento de errores y deployments
- [Airbrake](https://airbrake.io) — Notificaciones de errores y performance
- [Bugsnag](https://www.bugsnag.com) — Monitoreo de estabilidad de aplicaciones
