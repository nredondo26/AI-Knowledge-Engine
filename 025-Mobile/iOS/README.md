# iOS — Desarrollo Nativo para Dispositivos Apple

## Descripción General

iOS es el sistema operativo móvil de Apple. El desarrollo nativo usa **Swift** (moderno) u **Objective-C** (heredado). El entorno oficial es **Xcode** (IDE, simuladores, instrumentos, SDK).

---

## Arquitectura del Sistema iOS

1. **Core OS**: Kernel XNU (Mach + FreeBSD), memoria, archivos, seguridad, drivers.
2. **Core Services**: CFNetwork, CoreLocation, CoreData, Foundation, CloudKit.
3. **Media**: CoreGraphics, CoreAnimation, AVFoundation, Metal (3D bajo nivel).
4. **Cocoa Touch**: UIKit, SwiftUI, MapKit, ARKit, UserNotifications.

---

## Swift — Lenguaje Principal

```swift
struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    private var createdAt: Date

    var formattedDate: String {
        let f = DateFormatter(); f.dateStyle = .medium; return f.string(from: createdAt)
    }
}
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .secondsSince1970
let user = try! decoder.decode(User.self, from: jsonData)
```

---

## UIKit — Framework Clásico

```swift
class ViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { items.count }
    func tableView(_: UITableView, cellForRowAt i: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "cell", for: i)
        c.textLabel?.text = items[i.row]; return c
    }
}
```

---

## SwiftUI — UI Declarativa

```swift
struct ContentView: View {
    @State private var items = ["Manzana", "Banana"]

    var body: some View {
        NavigationStack {
            List(items, id: \.self) { item in
                HStack { Text(item); Spacer(); Image(systemName: "chevron.right") }
            }
            .navigationTitle("Lista")
        }
    }
}
```

---

## Ciclo de Vida

| Estado | Descripción |
|--------|-------------|
| **Not Running** | App no cargada en memoria |
| **Inactive** | Foreground sin eventos |
| **Active** | Foreground recibiendo eventos |
| **Background** | Segundo plano (~30s de ejecución) |
| **Suspended** | En memoria sin ejecutar |

```swift
@main struct MyApp: App {
    @Environment(\.scenePhase) private var phase
    var body: some Scene {
        WindowGroup { ContentView() }
            .onChange(of: phase) { _, new in
                switch new { case .active: break; case .inactive: break; case .background: break; @unknown default: break }
            }
    }
}
```

---

## Concurrencia (GCD y async/await)

```swift
// GCD
DispatchQueue.global(qos: .background).async {
    let data = try! Data(contentsOf: url)
    DispatchQueue.main.async { self.imageView.image = UIImage(data: data) }
}

// Modern async/await
func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let http = response as? HTTPURLResponse, 200...299 ~= http.statusCode else {
        throw URLError(.badServerResponse)
    }
    return try JSONDecoder().decode(T.self, from: data)
}
```

---

## Core Data

```swift
class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Core Data: \(error)") }
        }
    }
}
```

---

## Testing

```swift
final class UserServiceTests: XCTestCase {
    func testFetchUsers() async throws {
        let users = try await sut.fetchUsers()
        XCTAssertFalse(users.isEmpty)
    }
}
```

---

## Distribución

- **Development**: Certificado desarrollador, hasta 100 dispositivos registrados.
- **TestFlight**: Beta hasta 10,000 usuarios.
- **App Store**: Revisión por Apple (App Review).
- **Enterprise**: Distribución interna sin App Store.

---

## Referencias

- [Apple Developer Documentation](https://developer.apple.com/documentation)
- [Swift.org](https://swift.org)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)
