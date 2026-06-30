# Scala

Lenguaje compilado (JVM/JS/Native), multiparadigma (OO + funcional), tipado estático y fuerte. Creado por Martin Odersky (2004). Runtime: JVM (HotSpot), Scala.js, Scala Native (LLVM). Filosofía: fusionar POO y funcional, inmutabilidad por defecto, tipos expresivos.

## Sintaxis básica

```scala
@main def main(): Unit = println("Hola, mundo")

val nombre = "Ana"    // inmutable
var edad = 30         // mutable
val altura = 1.75
val activo = true

val mensaje = s"Hola, $nombre, tienes ${edad} años"

val categoria = if (edad >= 18) "Mayor"
                else if (edad > 12) "Adolescente"
                else "Menor"

for i <- 0 until 5 do println(i)
for x <- List(1, 2, 3) do println(x)

val resultado = edad match
  case n if n >= 18 => "Adulto"
  case n if n > 12  => "Adolescente"
  case _            => "Menor"

def sumar(a: Int, b: Int): Int = a + b
val cuadrado = (x: Int) => x * x
```

## Tipado

Sistema de tipos expresivo: case classes, sealed traits/enums, variance, higher-kinded types, type classes, match types (Scala 3).

```scala
// Case class: inmutable, igualdad estructural
case class Persona(nombre: String, edad: Int)
val p1 = Persona("Ana", 30)
p1.copy(edad = 31)

// Enums (Scala 3)
enum Status:
  case Activo, Inactivo, Pendiente

// ADT con sealed trait / enum
enum Opcion[+T]:
  case Some(valor: T)
  case None

// Type classes
trait Show[A]:
  def show(a: A): String

given Show[Int] with
  def show(i: Int): String = i.toString

def mostrar[A](a: A)(using s: Show[A]): String = s.show(a)
mostrar(42) // "42"

// Union types (Scala 3)
type Resultado = Int | String

// Match types (Scala 3)
type Elem[X] = X match
  case String => Char
  case Array[t] => t
```

## POO / Funcional

```scala
trait Vehiculo:
  def marca: String
  def mover: String

class Coche(val marca: String) extends Vehiculo:
  override def mover: String = s"$marca acelera"

// Mixins
trait Volable { def volar: String = "Volando" }
class Hidroavion(val marca: String) extends Vehiculo, Volable

// Funcional
val nums = List(1, 2, 3, 4)
val doblados = nums.map(_ * 2)
val pares = nums.filter(_ % 2 == 0)
val suma = nums.foldLeft(0)(_ + _)

// For comprehensions
val combinaciones = for
  x <- List(1, 2)
  y <- List('a', 'b')
yield (x, y)

// Monads: Option, Either
def dividir(a: Int, b: Int): Option[Int] =
  if b == 0 then None else Some(a / b)

def buscar(id: Int): Either[String, String] =
  if id > 0 then Right("ok") else Left("error")
```

## Concurrencia

```scala
import scala.concurrent.{Future, ExecutionContext, Await}
import scala.concurrent.duration.*

given ExecutionContext = ExecutionContext.global

val future = Future {
  Thread.sleep(100)
  "Resultado"
}

future.onComplete {
  case Success(v) => println(v)
  case Failure(e) => println(s"Error: $e")
}

// Parallel collections
val resultados = (1 to 100).toList.par.map(x => x * x)

// Cats Effect / ZIO: IO monad para efectos puros
// import cats.effect.*
// val prog = IO.println("Hola") *> IO.pure(42)
```

## Ecosistema

- **sbt** / **Mill** / **Scala CLI** — build tools
- **Scala.js** — compilación a JS (frontend)
- **Scala Native** — compilación nativa
- **Web**: Play Framework, http4s, ZIO HTTP, Akka HTTP
- **Efectos**: Cats Effect, ZIO, Monix
- **DB**: doobie, Slick, Quill, Skunk
- **Testing**: MUnit, ScalaTest, ZIO Test
- **JSON**: circe, zio-json, uPickle

## Herramientas

```bash
sbt new scala/scala3.g8 && sbt compile && sbt test
scala-cli run Main.scala && scala-cli test .
scalafmt --check && scalafmt
scala-cli package --native Main.scala -o app
scala-cli package --js Main.scala -o app.js
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [JVM](../../003-Runtimes/JVM/README.md)
- [Funcional](../../023-Functional-Programming/README.md)
```