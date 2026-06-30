# Kotlin

Lenguaje compilado (JVM/JS/Native), tipado estático y fuerte, multiparadigma. Creado por JetBrains (2011, 1.0 en 2016). Filosofía: conciso, seguro, interoperable con Java. Lenguaje oficial para Android (Google, 2017+).

## Sintaxis básica

```kotlin
fun main() {
    println("Hola, mundo")
}

// Variables: val (inmutable), var (mutable)
val nombre: String = "Ana"
var edad = 30  // tipo inferido: Int
val altura = 1.75  // Double
val activo = true

// Tipos básicos: String, Int, Long, Float, Double, Boolean, Char, Byte, Short
// Arrays, List, Set, Map, Range, Pair, Triple

// Null safety: tipos no nulos por defecto
var seguro: String = "hola"     // no puede ser null
var nullable: String? = null    // nullable con ?

// Elvis operator
val longitud = nullable?.length ?: 0

// Estructuras de control
if (edad >= 18) {
    println("Mayor")
} else if (edad > 12) {
    println("Adolescente")
} else {
    println("Menor")
}

// if como expresión
val tipo = if (edad >= 18) "Adulto" else "Menor"

for (i in 0 until 5) {
    println(i)
}

for (item in listOf("a", "b", "c")) {
    println(item)
}

var i = 0
while (i < 5) {
    i++
}

// when (switch mejorado)
val descripcion = when (edad) {
    in 0..3 -> "Bebé"
    in 4..12 -> "Niño"
    in 13..17 -> "Adolescente"
    else -> "Adulto"
}

// when con expresiones
val resultado = when {
    edad < 13 -> "Infantil"
    edad < 18 -> "Juvenil"
    else -> "Adulto"
}

// String templates
println("Hola, $nombre, tienes ${edad} años")
```

## Tipado

Kotlin es **estático**, **fuerte** y **nominal** (compatible con Java). Añade null safety, propiedades, data classes, sealed classes, y sistema de tipos más expresivo.

```kotlin
// Genéricos (invariantes por defecto, declaración-site variance)
class Caja<T>(val valor: T)

// Variance: out (covariante), in (contravariante)
interface Fuente<out T> { fun obtener(): T }
interface Consumidor<in T> { fun aceptar(item: T) }

// Productor (out) y consumidor (in) — PECS (Producer Extends, Consumer Super)
fun copiar(from: Fuente<out Number>, to: Consumidor<in Number>) {}

// Reified generics (inline + reified — tipo en runtime)
inline fun <reified T> esTipo(obj: Any): Boolean = obj is T

// Data class (equals, hashCode, toString, copy, componentN)
data class Persona(val nombre: String, val edad: Int)
val p1 = Persona("Ana", 30)
val p2 = p1.copy(nombre = "Luis")
val (nombre, edad) = p1  // destructuring

// Sealed class (jerarquía cerrada, útil para estados)
sealed class Resultado<out T> {
    data class Exito<T>(val datos: T) : Resultado<T>()
    data class Error(val mensaje: String) : Resultado<Nothing>()
}

fun manejar(resultado: Resultado<Int>) = when (resultado) {
    is Resultado.Exito -> println("Datos: ${resultado.datos}")
    is Resultado.Error -> println("Error: ${resultado.mensaje}")
}

// Typealias
typealias Callback<T> = (T) -> Unit
```

## POO / Funcional

```kotlin
// POO: clases, herencia (abierta por defecto no), interfaces, object, companion
open class Vehiculo(protected val marca: String) {
    open fun mover(): String = "$marca se mueve"
}

class Coche(marca: String, val modelo: String) : Vehiculo(marca) {
    override fun mover(): String = "$marca $modelo acelera"
}

// Object (singleton)
object Config {
    const val URL = "https://api.example.com"
    val timeout = 5000L
}

// Companion object (miembros estáticos)
class MiClase {
    companion object Factory {
        fun crear(): MiClase = MiClase()
    }
}

// Delegation (by)
interface Volador {
    fun volar(): String
}

class Aguila(val nombre: String) : Volador {
    override fun volar() = "$nombre vuela"
}

class PajaroVolador(volador: Volador) : Volador by volador

// Funcional: funciones de orden superior, lambdas, let/apply/run/also/with
val numeros = listOf(1, 2, 3, 4, 5)

val doblados = numeros.map { it * 2 }
val pares = numeros.filter { it % 2 == 0 }
val suma = numeros.reduce { acc, i -> acc + i }

// Scope functions
Persona("Ana", 30).let {
    println(it.nombre)
}

Persona("Luis", 25).apply {
    // this es Persona, modifica propiedades
}

// Secuencias (lazy evaluation)
val resultado = sequenceOf(1, 2, 3, 4, 5)
    .map { it * 2 }
    .filter { it > 5 }
    .toList()

// Tail recursive
tailrec fun factorial(n: Int, acc: Int = 1): Int =
    if (n <= 1) acc else factorial(n - 1, n * acc)
```

## Concurrencia

```kotlin
// Corutinas (Kotlin estándar, no hilos del SO)
// build.gradle.kts: implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core")
import kotlinx.coroutines.*

// Lanzar corutinas
fun main() = runBlocking {
    launch {  // fire and forget
        delay(100L)
        println("Corutina 1")
    }

    val resultado = async {  // con retorno
        delay(100L)
        42
    }

    println(resultado.await())  // 42

    // Structured concurrency: las corutinas hijas completan antes que el scope
    coroutineScope {
        launch { delay(200L); println("Hija 1") }
        launch { delay(100L); println("Hija 2") }
    }
    println("Después del scope")
}

// Dispatchers
GlobalScope.launch(Dispatchers.IO) {
    // I/O intensivo
}

GlobalScope.launch(Dispatchers.Default) {
    // CPU intensivo
}

GlobalScope.launch(Dispatchers.Main) {
    // UI (Android/Swing/JavaFX)
}

// Channels
val channel = Channel<Int>()

launch {
    for (i in 1..5) channel.send(i)
    channel.close()
}

launch {
    for (valor in channel) println(valor)
}

// Flow (cold stream reactivo)
fun flujo(): Flow<Int> = flow {
    for (i in 1..3) {
        delay(100)
        emit(i)
    }
}

fun main() = runBlocking {
    flujo()
        .map { it * 2 }
        .filter { it > 2 }
        .collect { println(it) }
}

// Mutex para exclusión mutua
val mutex = Mutex()
var contador = 0

fun main() = runBlocking {
    withContext(Dispatchers.Default) {
        coroutineScope {
            repeat(100) {
                launch {
                    mutex.withLock {
                        contador++
                    }
                }
            }
        }
    }
    println(contador) // 100
}
```

## Ecosistema

- **Build**: Gradle (oficial, con Kotlin DSL), Maven
- **Multiplataforma**: Kotlin/JVM (backend Android), Kotlin/JS (frontend), Kotlin/Native (iOS, desktop, embedded)
- **Android**: Jetpack Compose (UI declarativa), Android KTX, Room (DB), Retrofit (HTTP), Dagger/Hilt (DI)
- **Backend**: Ktor (ligero, async), Spring Boot (con Kotlin support), http4k, Micronaut
- **Testing**: kotlin.test, MockK (mocking nativo Kotlin), Kotest (testing avanzado)
- **Serialización**: kotlinx.serialization (multiplataforma), Moshi, Gson
- **Corutinas**: kotlinx.coroutines, kotlinx.flow, kotlinx.channels
- **Linting**: detekt, ktlint (formato), IntelliJ inspections

## Herramientas

```bash
# Compilar
kotlinc src/Main.kt -include-runtime -d app.jar
java -jar app.jar

# Con Gradle (Kotlin DSL)
./gradlew build
./gradlew run
./gradlew test

# Android
./gradlew assembleDebug
./gradlew assembleRelease

# Multiplataforma
./gradlew :shared:linkReleaseFrameworkIosArm64

# Lint
./gradlew detekt
ktlint src/

# kapt (annotation processing)
./gradlew kaptKotlin
```

## Relaciones

- [Java](../Java/README.md)
- [Android](../../025-Mobile/Android/README.md)
- [Frameworks](../../002-Frameworks/README.md)
