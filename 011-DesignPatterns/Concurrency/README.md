# Patrones de Concurrencia

## Descripción del dominio

Los patrones de concurrencia resuelven problemas recurrentes en la programación concurrente y paralela, donde múltiples flujos de ejecución (hilos, procesos, corrutinas, actores) deben coordinarse para acceder a recursos compartidos, comunicarse entre sí y completar tareas de manera eficiente y correcta. Estos patrones abordan la sincronización, exclusión mutua, comunicación entre hilos, pooling de recursos y gestión de tareas asíncronas. La elección del patrón depende del modelo de concurrencia del lenguaje (hilos, async/await, actores, CSP, STM) y de los requisitos de rendimiento y escalabilidad.

## Áreas clave

- **Exclusión mutua**: Mutex, semáforo, monitor, spinlock, read-write lock, RCU (Read-Copy-Update)
- **Sincronización**: Barrera (barrier), CountDownLatch, CyclicBarrier, Phaser, Condition Variable
- **Comunicación entre hilos**: Channel (Go/CSP), Pipe, Queue (blocking queue), Actor (Akka/Erlang)
- **Patrones de tareas**: Thread Pool, Work Stealing, Fork-Join, Future/Promise, Actor Pool
- **Paralelismo de datos**: MapReduce, Divide and Conquer, Pipeline, Producer-Consumer, Parallel Loop
- **Gestión de estado compartido**: Thread-local storage, Immutable objects, Copy-on-Write, Software Transactional Memory (STM)
- **Patrones de coordinación**: Barrier, Latch, Exchanger, Phaser, Semaphore barrier

## Patrones principales

| Patrón | Descripción | Ejemplo de uso |
|--------|-------------|----------------|
| **Producer-Consumer** | Productores generan datos, consumidores los procesan; buffer compartido | Logging async, procesamiento de colas |
| **Thread Pool** | Grupo de hilos reutilizables que ejecutan tareas de una cola | Servidores web, ejecutores de tareas |
| **Fork-Join** | Divide tarea en subtareas, las ejecuta en paralelo, combina resultados | Procesamiento paralelo de arrays |
| **Active Object** | Desacopla ejecución de llamada mediante cola de peticiones y scheduler | Sistemas en tiempo real, GUI |
| **Reactor** | Demultiplexa eventos de E/S y los distribuye a handlers | Netty, libevent, epoll |
| **Proactor** | Similar a Reactor pero E/S asíncrona con completion handlers | Boost.Asio, Windows IOCP |
| **Barrier** | Punto de sincronización donde N hilos esperan hasta que todos lleguen | Computación paralela iterativa |
| **Read-Write Lock** | Múltiples lectores simultáneos o un escritor exclusivo | Cachés, bases de datos en memoria |
| **Double-Checked Locking** | Verificación perezosa con locking mínimo | Singleton perezoso thread-safe |

## Ejemplo: Producer-Consumer con Channels (Go)

```go
func producer(ch chan<- int, done chan<- bool) {
    for i := 0; i < 10; i++ {
        ch <- i
        time.Sleep(100 * time.Millisecond)
    }
    close(ch)
    done <- true
}

func consumer(id int, ch <-chan int) {
    for v := range ch {
        fmt.Printf("Consumidor %d: %d\n", id, v)
    }
}

func main() {
    ch := make(chan int, 5)
    done := make(chan bool)
    go producer(ch, done)
    go consumer(1, ch)
    go consumer(2, ch)
    <-done
}
```

## Ejemplo: Thread Pool con ExecutorService (Java)

```java
ExecutorService pool = Executors.newFixedThreadPool(4);
List<Future<Integer>> futures = new ArrayList<>();
for (int i = 0; i < 20; i++) {
    final int taskId = i;
    futures.add(pool.submit(() -> {
        Thread.sleep(100);
        return taskId * taskId;
    }));
}
for (Future<Integer> f : futures) {
    System.out.println(f.get());
}
pool.shutdown();
```

## Tecnologías principales

| Lenguaje/Plataforma | Modelo de concurrencia |
|---------------------|----------------------|
| Java | Threads, ExecutorService, ForkJoinPool, CompletableFuture, Locks, STM (Multiverse) |
| Go | Goroutines, Channels (CSP), sync.Mutex, sync.WaitGroup, select |
| Python | threading, multiprocessing, asyncio (async/await), concurrent.futures |
| C++ | std::thread, std::async, std::future, std::mutex, TBB, OpenMP |
| Rust | std::thread, tokio (async), Rayon (paralelismo), std::sync::Arc, crossbeam |
| C# / .NET | Task, Task Parallel Library (TPL), async/await, Channel<T>, PLINQ |
| Erlang/Elixir | Actores (processes), message passing, OTP, GenServer |
| Akka (JVM) | Actor Model, Cluster, Streams |
| CUDA | Paralelismo GPU, kernel<<<grid, block>>> |

## Buenas prácticas

- Evitar locks innecesarios; preferir comunicación mediante canales/colas
- Usar thread pools en lugar de crear hilos directamente
- Preferir inmutabilidad para evitar condiciones de carrera
- Documentar los contratos de sincronización (qué locks protegen qué datos)
- Usar herramientas de detección: ThreadSanitizer, Helgrind, lockdep
- Mantener granularidad de locks fina (fine-grained) pero sin caer en deadlock
- Para alto rendimiento, considerar lock-free structures (atomic operations, RCU)
