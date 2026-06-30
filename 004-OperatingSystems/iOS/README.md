# iOS — Sistema Operativo Móvil de Apple

## Descripción del dominio

iOS es el sistema operativo móvil de Apple para iPhone, iPod Touch y iPad (con iPadOS como rama independiente desde 2019). Está basado en el kernel XNU (híbrido Mach + FreeBSD), con una arquitectura en capas: Core OS (kernel, seguridad, drivers), Core Services (Foundation, Core Data, Core Location, Networking), Media (Core Graphics, Core Animation, AVFoundation, Metal) y Cocoa Touch (UIKit, SwiftUI, AppKit). iOS es conocido por su seguridad (sandboxing, app review, Secure Enclave, Face ID/Touch ID), su ecosistema cerrado y su experiencia de usuario pulida.

## Áreas clave

- **Lenguajes de desarrollo**: Swift (preferido), Objective-C (legacy), C/C++ (para rendimiento)
- **Frameworks de UI**: SwiftUI (declarativo, moderno, 2019+), UIKit (imperativo, legacy), AppKit (macOS), Catalyst (iPad → macOS)
- **Arquitectura de apps recomendada**: MVVM, SwiftUI + Combine, TCA (The Composable Architecture), VIPER
- **Ciclo de vida de la app**: AppDelegate → SceneDelegate (iOS 13+), estados (active, inactive, background, suspended)
- **Persistencia**: Core Data, SwiftData (iOS 17+), UserDefaults, Keychain, FileManager, CloudKit, SQLite con GRDB
- **Red**: URLSession, Alamofire, Apollo GraphQL, WebSockets, Combine para async networking
- **Seguridad**: App Sandbox, Keychain Services, Secure Enclave, Face ID / Touch ID (LocalAuthentication), App Transport Security (ATS), Data Protection
- **Distribución**: App Store (App Review), TestFlight (beta), Enterprise Distribution, Ad Hoc
- **Notificaciones push**: APNs (Apple Push Notification service), UNUserNotificationCenter, rich notifications, actionable notifications

## Ejemplo: SwiftUI App básica

```swift
import SwiftUI

struct ContentView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Contador: \(count)")
                .font(.title)
            Button("Incrementar") {
                count += 1
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
```

## Ejemplo: Llamada HTTP con URLSession y async/await

```swift
struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

func fetchUser(id: Int) async throws -> User {
    let url = URL(string: "https://api.example.com/users/\(id)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}
```

## Tecnologías principales

| Framework | Propósito |
|-----------|-----------|
| SwiftUI | UI declarativa, state management (@State, @Binding, @ObservableObject) |
| UIKit | UI imperativa legacy (UIViewController, UIView, Auto Layout) |
| Combine | Programación reactiva con Publishers/Subscribers |
| Core Data | ORM persistencia de objetos (NSManagedObject, NSPersistentContainer) |
| SwiftData | Persistencia moderna declarativa (iOS 17+, @Model, @Query) |
| CloudKit | Sincronización en la nube con iCloud (CKContainer, CKRecord) |
| Core ML | Machine Learning on-device (modelos .mlpackage) |
| Metal | API de gráficos 3D de bajo nivel |
| ARKit | Realidad aumentada |
| MapKit | Mapas y localización |

## Buenas prácticas

- Usar SwiftUI para nuevas apps; UIKit para apps que requieran control fino legacy
- Aplicar MVVM con @Observable (iOS 17+) o @ObservableObject con Combine
- Manejar errores de red con do/catch y mostrar feedback al usuario
- Usar Keychain para almacenar tokens y datos sensibles (no UserDefaults)
- Implementar Dark Mode con colores semánticos (asset catalogs)
- Seguir las Human Interface Guidelines de Apple para diseño y navegación
- Usar Instruments para perfilado de rendimiento y memoria
