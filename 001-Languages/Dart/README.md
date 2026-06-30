# Dart

Lenguaje compilado (JIT/AOT), orientado a objetos, tipado estático y fuerte. Creado por Google (2011). Runtime: Dart VM (JIT desarrollo) + compilación AOT nativa. Estandarizado ECMA-408. Filosofía: productividad, rendimiento predecible, portable (web, móvil, servidor, escritorio).

## Sintaxis básica

```dart
void main() => print('Hola, mundo');

var nombre = 'Ana';          // inferido String
final edad = 30;              // runtime constant
const PI = 3.1416;            // compile-time constant
int contador = 0;
double altura = 1.75;
bool activo = true;

String? posibleNull = null;   // null safety (2.12+)

var mensaje = 'Hola, $nombre, tienes ${edad} años';

if (edad >= 18) {
  print('Mayor');
} else if (edad > 12) {
  print('Adolescente');
} else {
  print('Menor');
}

for (var i = 0; i < 5; i++) print(i);
for (var x in [1, 2, 3]) print(x);

// Switch expression (3.0)
var categoria = switch (edad) {
  >= 18 => 'Adulto',
  > 12  => 'Adolescente',
  _     => 'Menor',
};

int sumar(int a, int b) => a + b;

void crearUsuario({required String nombre, required int edad, String pais = 'MX'}) {
  print('$nombre, $edad, $pais');
}
```

## Tipado

Sound null safety (2.12+). Genéricos reificados. Pattern matching (3.0). Extension methods.

```dart
// Null safety
String? nombreNullable;
nombreNullable ??= 'default';
var longitud = nombreNullable?.length;

// Type promotion
void procesar(Object obj) {
  if (obj is String) print(obj.length);
}

// sealed class (3.0): uniones discriminadas
sealed class Resultado<T> {}
class Exito<T> extends Resultado<T> { final T data; Exito(this.data); }
class Error<T> extends Resultado<T> { final String msg; Error(this.msg); }

String procesarRes(Resultado<int> r) => switch (r) {
  Exito(data: var d) => 'Éxito: $d',
  Error(msg: var m) => 'Error: $m',
};

// Extension methods (2.7)
extension on String {
  String get reversed => split('').reversed.join();
}
```

## POO / Funcional

```dart
abstract class Vehiculo {
  final String marca;
  Vehiculo(this.marca);
  String mover();
}

class Coche extends Vehiculo {
  Coche(super.marca);
  @override String mover() => '$marca acelera';
}

// Mixins
mixin Volable { String volar() => 'Volando'; }

class Hidroavion extends Vehiculo with Volable {
  Hidroavion(super.marca);
  @override String mover() => 'Despegando';
}

// Funcional
var nums = [1, 2, 3, 4];
var doblados = nums.map((x) => x * 2).toList();
var pares = nums.where((x) => x.isEven).toList();
var suma = nums.fold(0, (a, x) => a + x);

// Records (3.0)
(String, int) persona = ('Ana', 30);
({String n, int e}) p = (n: 'Ana', e: 30);
```

## Concurrencia

```dart
import 'dart:async';
import 'dart:isolate';

Future<String> fetchData(int id) async {
  await Future.delayed(Duration(milliseconds: 100));
  return 'Datos $id';
}

var results = await Future.wait([fetchData(1), fetchData(2)]);

// Streams
Stream<int> contar(int max) async* {
  for (var i = 0; i < max; i++) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
}

await for (var v in contar(5)) print(v);

// Isolates (paralelismo real, sin shared state)
void worker(SendPort send) => send.send('Completado');
var rp = ReceivePort();
await Isolate.spawn(worker, rp.sendPort);
print(await rp.first);
```

## Ecosistema

- **pub.dev** (~50k+ paquetes), `pub add`, `pub get`
- **Flutter** — UI multiplataforma (iOS, Android, Web, Desktop)
- **Server**: shelf, Serverpod, Dart Frog
- **Estado (Flutter)**: Riverpod, BLoC, Provider
- **Testing**: test (stdlib), flutter_test, mockito
- **Serialización**: json_serializable, freezed
- **Compilación**: `dart compile exe`, `dart compile wasm` (3.0+)

## Herramientas

```bash
dart create mi_app && dart pub add http
dart analyze lib/ && dart format lib/
dart test
dart compile exe bin/main.dart -o app
flutter create mi_app && flutter run -d chrome
flutter build apk --release
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [Mobile](../../025-Mobile/README.md)
- [Web](../../026-Web/README.md)
```