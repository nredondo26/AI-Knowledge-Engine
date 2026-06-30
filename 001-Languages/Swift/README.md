# Swift

Lenguaje compilado (LLVM), tipado estático y fuerte, multiparadigma. Creado por Chris Lattner (Apple, 2014). Filosofía: seguro, rápido, expresivo. Lenguaje oficial para ecosistema Apple (iOS, macOS, watchOS, tvOS).

## Sintaxis básica

```swift
import Foundation

print("Hola, mundo")

// Variables: let (constante), var (mutable)
let nombre: String = "Ana"
var edad = 30  // tipo inferido: Int
let altura = 1.75  // Double
var activo = true

// Tipos básicos: String, Int, UInt, Float, Double, Bool, Character
// Colecciones: Array, Set, Dictionary

// Opcionales (Optionals): similar a null safety
var opcional: String? = nil
let seguro: String = "hola"  // no puede ser nil

// Optional binding
if let valor = opcional {
    print(valor)
}

// Guard let (early return)
guard let valor = opcional else {
    return
}

// Nil-coalescing
let longitud = opcional?.count ?? 0

// Estructuras de control
if edad >= 18 {
    print("Mayor")
} else if edad > 12 {
    print("Adolescente")
} else {
    print("Menor")
}

for i in 0..<5 {
    print(i)  // 0, 1, 2, 3, 4
}

for item in ["a", "b", "c"] {
    print(item)
}

var i = 0
while i < 5 {
    i += 1
}

// Switch (exhaustivo, sin break)
let descripcion: String
switch edad {
case 0..<4: descripcion = "Bebé"
case 4..<13: descripcion = "Niño"
case 13..<18: descripcion = "Adolescente"
default: descripcion = "Adulto"
}

// Funciones con parámetros label
func saludar(a persona: String, desde lugar: String) -> String {
    return "Hola \(persona) desde \(lugar)"
}
print(saludar(a: "Ana", desde: "Madrid"))
```

## Tipado

Swift es **estático**, **fuerte** y **nominal**. Tiene un sistema de tipos muy expresivo: opcionales, genéricos, protocolos con associated types, enums con valores asociados, y value semantics.

```swift
// Genéricos
func identidad<T>(_ valor: T) -> T {
    return valor
}

// Genéricos con constraints (protocolo)
func esIgual<T: Equatable>(_ a: T, _ b: T) -> Bool {
    return a == b
}

// Protocolos con associated types
protocol Contenedor {
    associatedtype Item
    mutating func agregar(_ item: Item)
    var count: Int { get }
}

struct Caja<T>: Contenedor {
    typealias Item = T
    private var items: [T] = []
    
    mutating func agregar(_ item: T) {
        items.append(item)
    }
    
    var count: Int { items.count }
}

// Opaque types (some) — retornar un tipo conforme a protocolo sin revelar el tipo concreto
func crearCualquierEquatable() -> some Equatable {
    return 42
}

// Enums con valores asociados
enum Resultado<T> {
    case exito(T)
    case error(Error)
}

let resultado = Resultado.exito(42)
switch resultado {
case .exito(let valor):
    print("Éxito: \(valor)")
case .error(let err):
    print("Error: \(err)")
}

// Typealias
typealias CompletionHandler<T> = (Result<T, Error>) -> Void

// Property wrappers
@propertyWrapper
struct MinimoMaximo {
    private var valor: Int
    let minimo: Int
    let maximo: Int
    
    init(wrappedValue: Int, minimo: Int, maximo: Int) {
        self.valor = Swift.max(minimo, Swift.min(maximo, wrappedValue))
        self.minimo = minimo
        self.maximo = maximo
    }
    
    var wrappedValue: Int {
        get { valor }
        set { valor = Swift.max(minimo, Swift.min(maximo, newValue)) }
    }
}
```

## POO / Funcional

Swift soporta **POO** (clases, herencia) y **valor semantics** (structs, enums). La recomendación es usar structs por defecto, clases solo cuando necesites herencia o referencias compartidas.

```swift
// Struct (value type, recomendado)
struct Punto {
    var x: Double
    var y: Double
    
    func distancia(a otro: Punto) -> Double {
        return hypot(x - otro.x, y - otro.y)
    }
}

// Class (reference type)
class Vehiculo {
    let marca: String
    
    init(marca: String) {
        self.marca = marca
    }
    
    func mover() -> String {
        return "\(marca) se mueve"
    }
}

class Coche: Vehiculo {
    let modelo: String
    
    init(marca: String, modelo: String) {
        self.modelo = modelo
        super.init(marca: marca)
    }
    
    override func mover() -> String {
        return "\(marca) \(modelo) acelera"
    }
}

// Protocolos (interfaces)
protocol Volador {
    func volar() -> String
}

struct Aguila: Volador {
    let nombre: String
    
    func volar() -> String {
        return "\(nombre) vuela"
    }
}

// Protocol con default implementation (trait-like)
protocol Describible {
    var descripcion: String { get }
}

extension Describible {
    var descripcion: String {
        return "Una instancia de \(Self.self)"
    }
}

// Extensiones (añadir funcionalidad a tipos existentes)
extension Int {
    var cuadrado: Int { self * self }
    var esPar: Bool { self % 2 == 0 }
}

// Funcional: funciones como first-class, map/filter/reduce
let numeros = [1, 2, 3, 4, 5]
let doblados = numeros.map { $0 * 2 }
let pares = numeros.filter { $0 % 2 == 0 }
let suma = numeros.reduce(0, +)

// Closures
let sumar: (Int, Int) -> Int = { $0 + $1 }
print(sumar(3, 4))  // 7

// Trailing closure
numeros.sorted { $0 > $1 }

// Key paths
struct Persona { let nombre: String; let edad: Int }
let personas = [Persona(nombre: "Ana", edad: 30), Persona(nombre: "Luis", edad: 25)]
let nombres = personas.map(\.nombre)
```

## Concurrencia

```swift
// Grand Central Dispatch (GCD) — colas de dispatch
let cola = DispatchQueue.global(qos: .background)

cola.async {
    print("Tarea en background")
    DispatchQueue.main.async {
        print("Volver al hilo principal")
    }
}

// OperationQueue (más alto nivel)
let queue = OperationQueue()
queue.maxConcurrentOperationCount = 4

queue.addOperation {
    print("Operación 1")
}

// async/await (Swift 5.5+)
func fetchUser(id: Int) async throws -> String {
    let url = URL(string: "https://api.example.com/users/\(id)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return String(data: data, encoding: .utf8) ?? ""
}

func main() async {
    do {
        let resultado = try await fetchUser(id: 1)
        print(resultado)
        
        // Concurrencia estructurada
        async let usuario1 = fetchUser(id: 1)
        async let usuario2 = fetchUser(id: 2)
        
        let (r1, r2) = try await (usuario1, usuario2)
        print(r1, r2)
    } catch {
        print("Error: \(error)")
    }
}

// Task (corutina Swift)
Task {
    await main()
}

// Actors (protección de estado compartido, Swift 5.5+)
actor Contador {
    private var valor = 0
    
    func incrementar() {
        valor += 1
    }
    
    func obtener() -> Int {
        return valor
    }
}

let contador = Contador()
Task {
    await contador.incrementar()
    print(await contador.obtener())
}

// AsyncSequence (AsyncStream, AsyncAlgorithms)
for await linea in URLSession.shared.bytes(from: url).0.lines {
    print(linea)
}
```

## Ecosistema

- **Swift Package Manager (SPM)** — build system y gestor de dependencias oficial (integrado en Xcode y CLI)
- **CocoaPods** / **Carthage** — gestores legacy (SPM es el estándar actual)
- **Apple frameworks**: SwiftUI (UI declarativa), UIKit/AppKit (imperativa), Combine (reactive), Foundation, Core Data, CloudKit, Metal
- **Servidor**: Vapor (web framework server-side), Perfect, Kitura (IBM, discontinuado)
- **Multiplataforma**: Swift on Server (Vapor), SwiftWasm (web), Swift for TensorFlow (ML, discontinuado)
- **Testing**: XCTest (oficial Apple), Quick + Nimble (BDD), Swift Testing (Swift 6+)
- **Linting**: SwiftFormat, SwiftLint
- **Documentación**: DocC (Documentation Compiler, oficial Apple)
- **IDEs**: Xcode (oficial, macOS), AppCode (JetBrains, discontinuado), CodeLLDB (VS Code)

## Herramientas

```bash
# Swift Package Manager
swift build
swift run
swift test
swift package init --type library

# Crear proyecto ejecutable
swift package init --type executable

# Release build
swift build -c release

# Formato
swift format --recursive Sources/

# Lint (SwiftLint)
swiftlint --strict

# Generar documentación
swift docc Sources/

# Linux (necesita swift toolchain)
# brew install swiftlint  (macOS)
# apt install swiftlint   (Linux)
```

## Relaciones

- [iOS](../../025-Mobile/iOS/README.md)
- [macOS](../../024-Desktop/macOS/README.md)
- [Frameworks](../../002-Frameworks/README.md)
