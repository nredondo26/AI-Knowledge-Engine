# Java

Lenguaje compilado (bytecode → JVM), orientado a objetos, tipado estático y nominal. Creado por James Gosling (Sun, 1995). Filosofía: "write once, run anywhere". Versiones LTS cada 2 años (21, 17, 11, 8).

## Sintaxis básica

```java
public class HolaMundo {
    public static void main(String[] args) {
        System.out.println("Hola, mundo");
    }
}

// Variables (tipado estático explícito)
String nombre = "Ana";
int edad = 30;
double altura = 1.75;
boolean activo = true;
final int CONSTANTE = 42; // constante en tiempo de compilación

// var (inferencia local, Java 10+)
var lista = new ArrayList<String>();

// Estructuras de control
if (edad >= 18) {
    System.out.println("Mayor");
} else if (edad > 12) {
    System.out.println("Adolescente");
} else {
    System.out.println("Menor");
}

for (int i = 0; i < 5; i++) {
    System.out.println(i);
}

for (String item : List.of("a", "b", "c")) {
    System.out.println(item);
}

int contador = 0;
while (contador < 5) {
    contador++;
}

// Switch expression (Java 14+)
String tipo = switch (edad) {
    case 0, 1, 2, 3 -> "Bebé";
    case 4, 5, 6, 7, 8, 9, 10, 11, 12 -> "Niño";
    case 13, 14, 15, 16, 17 -> "Adolescente";
    default -> "Adulto";
};

// Records (Java 16+) — datos inmutables
public record Punto(double x, double y) {}

// Text blocks (Java 15+)
String json = """
    {
        "nombre": "Ana",
        "edad": 30
    }
    """;
```

## Tipado

Java es **estático**, **fuerte** y **nominal** (el tipo se determina por el nombre de la clase/interface, no por su estructura). Genéricos con borrado de tipo (erasure).

```java
// Genéricos (type erasure — solo en compilación)
public class Caja<T> {
    private T valor;

    public Caja(T valor) {
        this.valor = valor;
    }

    public T getValor() { return valor; }
    public void setValor(T valor) { this.valor = valor; }
}

// Wildcards: ? extends (covarianza), ? super (contravarianza)
public void procesar(List<? extends Number> nums) {
    for (Number n : nums) System.out.println(n);
}

public void agregar(List<? super Integer> lista) {
    lista.add(42);
}

// Records (inmutables, con equals/hashCode/toString generados)
record Persona(String nombre, int edad) {}

// Pattern matching (Java 16+ preview, 21+ estable)
if (obj instanceof String s && s.length() > 5) {
    System.out.println(s.toUpperCase());
}

// Sealed classes (Java 17+)
public sealed class Forma permits Circulo, Rectangulo {}

public final class Circulo extends Forma {
    private final double radio;
    public Circulo(double radio) { this.radio = radio; }
}

public final class Rectangulo extends Forma {
    private final double ancho, alto;
    public Rectangulo(double ancho, double alto) {
        this.ancho = ancho; this.alto = alto;
    }
}
```

## POO / Funcional

```java
// POO clásico: clases, herencia simple, interfaces (múltiples), abstract
abstract class Vehiculo {
    protected String marca;

    public Vehiculo(String marca) {
        this.marca = marca;
    }

    public String getMarca() { return marca; }

    public abstract String mover();
}

class Coche extends Vehiculo {
    private final String modelo;

    public Coche(String marca, String modelo) {
        super(marca);
        this.modelo = modelo;
    }

    @Override
    public String mover() {
        return marca + " " + modelo + " acelera";
    }
}

// Interfaces funcionales (un solo método abstracto)
@FunctionalInterface
interface Mapper<T, R> {
    R apply(T t);
}

// Programación funcional con Streams y lambdas (Java 8+)
import java.util.stream.*;

var numeros = List.of(1, 2, 3, 4, 5);

var doblados = numeros.stream()
    .map(n -> n * 2)
    .collect(Collectors.toList());

var pares = numeros.stream()
    .filter(n -> n % 2 == 0)
    .toList(); // Java 16+

var suma = numeros.stream()
    .reduce(0, Integer::sum);

// Method references
numeros.forEach(System.out::println);

// Optional (evitar null)
public Optional<String> buscarPorId(int id) {
    return id > 0 ? Optional.of("Encontrado") : Optional.empty();
}

buscarPorId(1)
    .map(String::toUpperCase)
    .orElseThrow(() -> new RuntimeException("No encontrado"));
```

## Concurrencia

```java
// Threads clásicos
Thread hilo = new Thread(() -> {
    System.out.println("Hilo ejecutándose");
});
hilo.start();
hilo.join();

// ExecutorService (manejo profesional de pools)
import java.util.concurrent.*;

ExecutorService executor = Executors.newFixedThreadPool(4);
List<Future<Integer>> futuros = new ArrayList<>();

for (int i = 0; i < 10; i++) {
    int taskId = i;
    futuros.add(executor.submit(() -> {
        Thread.sleep(100);
        return taskId * taskId;
    }));
}

for (Future<Integer> f : futuros) {
    System.out.println(f.get()); // bloqueante
}
executor.shutdown();

// CompletableFuture (composición asíncrona, Java 8+)
CompletableFuture.supplyAsync(() -> {
    return fetchFromApi(1);
}, executor)
.thenApply(data -> data.toUpperCase())
.thenAccept(System.out::println)
.exceptionally(ex -> {
    System.err.println("Error: " + ex);
    return null;
});

// Structured Concurrency (Java 21+ — preview)
// try (var scope = new StructuredTaskScope.ShutdownOnFailure()) {
//     Future<Integer> t1 = scope.fork(() -> tarea1());
//     Future<String> t2 = scope.fork(() -> tarea2());
//     scope.join();
//     scope.throwIfFailed();
//     return resultado(t1.resultNow(), t2.resultNow());
// }

// Virtual Threads (Project Loom, Java 21+)
// try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
//     IntStream.range(0, 10_000).forEach(i ->
//         executor.submit(() -> tarea(i))
//     );
// }

// Sincronización
private final Lock lock = new ReentrantLock();
lock.lock();
try {
    // sección crítica
} finally {
    lock.unlock();
}

// synchronized
public synchronized void metodoSeguro() {
    // solo un hilo a la vez
}
```

## Ecosistema

- **Maven** / **Gradle** — build tools estándar (gestión de dependencias, plugins)
- **JVM** ecosistema: Kotlin, Groovy, Scala, Clojure sobre el mismo runtime
- **Web**: Spring Boot (estándar industria), Quarkus (cloud-native), Micronaut, Jakarta EE
- **ORM**: Hibernate (JPA), jOOQ (type-safe SQL), MyBatis
- **Testing**: JUnit 5 (estándar), Mockito (mocking), Testcontainers (integración)
- **Reactive**: Project Reactor (Spring WebFlux), RxJava, Vert.x
- **Herramientas**: IntelliJ IDEA (IDE referencia), VisualVM (profiling), jlink (runtime custom), jdeps (análisis módulos)
- **Modularización**: JPMS (Java Platform Module System, Java 9+)

## Herramientas

```bash
# Compilar y ejecutar
javac HolaMundo.java
java HolaMundo

# Maven
mvn clean install
mvn test
mvn spring-boot:run

# Gradle
gradle build
gradle test
gradle bootRun

# JAR ejecutable
java -jar target/app.jar

# jlink (JRE mínimo para tu app)
jlink --add-modules java.base,java.sql --output mini-jre

# Herramientas JDK
jps       # procesos JVM
jstack    # stack traces
jmap      # heap dump
jconsole  # monitoreo JMX
```

## Relaciones

- [Kotlin](../Kotlin/README.md)
- [Frameworks](../../002-Frameworks/README.md)
- [Web](../../026-Web/README.md)
