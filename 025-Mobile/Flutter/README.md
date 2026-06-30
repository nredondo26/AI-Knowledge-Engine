# Flutter — Framework Multiplataforma de Google

## Descripción General

Flutter es un framework de código abierto de Google para construir aplicaciones compiladas nativamente desde un solo código base: **móvil** (Android, iOS), **web**, **escritorio** (Windows, macOS, Linux) y **embebidos**. Usa **Dart** y su propio motor de renderizado (Skia → Impeller), arquitectura basada en widgets y hot reload.

---

## Arquitectura

1. **Framework (Dart)**: Widgets, renderizado, animación, gestos, accesibilidad.
2. **Engine (C/C++)**: Skia/Impeller, Dart VM, platform channels.
3. **Embedder**: Código específico por plataforma (Android: Kotlin, iOS: Swift).

---

## Widgets

```dart
void main() => runApp(const MaterialApp(
  title: 'Mi App', theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
  home: HomeScreen(),
));
```

| Tipo | Ejemplos | Mutabilidad |
|------|----------|-------------|
| **StatelessWidget** | `Text`, `Icon`, `Container` | Inmutable |
| **StatefulWidget** | `TextField`, `Checkbox` | Estado mutable vía `State` |

---

## StatefulWidget

```dart
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});
  @override State<CounterScreen> createState() => _CounterScreenState();
}
class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  void _increment() => setState(() => _counter++);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Contador')),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Has presionado:'), Text('$_counter', style: Theme.of(context).textTheme.headlineLarge),
    ])),
    floatingActionButton: FloatingActionButton(onPressed: _increment, child: const Icon(Icons.add)),
  );
}
```

---

## Gestión de Estado

### Provider

```dart
class ContadorModel extends ChangeNotifier { int _v = 0; int get valor => _v; void inc() { _v++; notifyListeners(); } }
// Consumir: final c = context.watch<ContadorModel>(); final c = context.read<ContadorModel>();
```

### Bloc

```dart
sealed class CounterEvent {} final class Increment extends CounterEvent {}
class CounterBloc extends Bloc<CounterEvent, int> { CounterBloc() : super(0) { on<Increment>((e, emit) => emit(state + 1)); } }
// UI: BlocBuilder<CounterBloc, int>(builder: (_, count) => Text('$count'));
```

---

## Navegación (GoRouter)

```dart
final router = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
  GoRoute(path: '/detail/:id', builder: (_, s) => DetailScreen(id: s.pathParameters['id']!)),
]);
// context.go('/detail/42'); context.pop();
```

---

## Networking

```dart
class ApiClient {
  static const _base = 'https://api.ejemplo.com';
  Future<List<Usuario>> fetchUsuarios() async {
    final r = await http.get(Uri.parse('$_base/usuarios'));
    if (r.statusCode != 200) throw Exception('Error ${r.statusCode}');
    return (json.decode(r.body) as List).map((j) => Usuario.fromJson(j)).toList();
  }
}
```

Opción avanzada: **Dio** (interceptores, timeouts, cancelación).

---

## Persistencia

### Drift (SQLite)

```dart
@DriftDatabase(tables: [Usuarios]) class AppDatabase extends _$AppDatabase { AppDatabase() : super(_openConnection()); }
```

### SharedPreferences

```dart
final prefs = await SharedPreferences.getInstance(); await prefs.setString('token', 'abc');
```

---

## Platform Channels

```dart
static const platform = MethodChannel('com.ejemplo/bateria');
final result = await platform.invokeMethod<int>('getBatteryLevel');
```

---

## Testing

```dart
test('Contador se incrementa', () { final bloc = CounterBloc(); bloc.add(Increment()); expect(bloc.state, 1); });
testWidgets('Muestra título', (tester) async { await tester.pumpWidget(const MaterialApp(home: HomeScreen())); expect(find.text('Mi App'), findsOneWidget); });
```

---

## Compilación

```bash
flutter build apk --release        # Android
flutter build ios --release         # iOS
flutter build web                   # Web
flutter build linux                 # Linux
```

---

## Optimización

Usar `const` widgets, evitar `setState` en widgets profundos, lazy loading con `CachedNetworkImageProvider`, profiling con DevTools.

---

## Referencias

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
