# 025-Mobile: Desarrollo Móvil

## Descripción ampliada del dominio

El desarrollo móvil comprende la creación de aplicaciones para dispositivos móviles (smartphones, tablets) utilizando plataformas nativas (iOS con Swift, Android con Kotlin) o soluciones multiplataforma (Flutter, React Native, .NET MAUI). El ecosistema móvil global incluye más de 6.500 millones de usuarios de smartphones, con Android (~70% market share) y iOS (~30%) como únicos sistemas operativos relevantes. La App Store de Apple genera más de $100B anuales para desarrolladores; Google Play genera ~$50B. La evolución del desarrollo móvil: apps nativas (2008, SDK nativos, Objective-C/Java) → multiplataforma (2015+, React Native, Xamarin) → Flutter (2018, declarativo, Google) → Kotlin Multiplatform (2020+, código compartido UI nativa). Las tendencias actuales incluyen: apps impulsadas por IA generativa, AR/VR (Apple Vision Pro, ARKit), apps modulares con feature-based architecture, Compose Multiplatform (UI declarativa para iOS y Android), y superapps (WeChat, Rappi, Grab) que integran múltiples servicios en una sola app. El ciclo de vida de una app incluye desarrollo, testing, distribución en stores (App Store, Google Play), monitoreo y actualizaciones.

## Tabla de conceptos clave

| Concepto | Descripción | Tecnologías |
|----------|-------------|-------------|
| App Nativa | Desarrollada específicamente para una plataforma (iOS o Android) | Swift/SwiftUI (iOS), Kotlin/Jetpack Compose (Android) |
| App Multiplataforma | Código base compartido entre plataformas | Flutter (Dart), React Native (JS/TS), .NET MAUI (C#) |
| App Híbrida | App web en contenedor nativo (webview) | Ionic, Capacitor, Cordova |
| PWA (Progressive Web App) | Web app instalable con capacidades nativas | HTML, CSS, JS, Service Workers |
| Widget | Componente de UI en la pantalla de inicio | iOS WidgetKit, Android App Widgets |
| State Management | Gestión del estado de UI y datos | Redux, BLoC, Provider, Riverpod, MobX, GetX |
| Arquitectura Móvil | Patrones de diseño para apps móviles | MVVM, MVP, MVI, Clean Architecture, Modular |
| Offline-first | Estrategia que prioriza funcionalidad sin conexión | SQLite, Room, Realm, Firebase Firestore offline |
| Push Notifications | Mensajes enviados desde servidor a dispositivo | Firebase Cloud Messaging, Apple Push Notification |
| Deep Linking | Enlace que abre contenido específico dentro de una app | Universal Links (iOS), App Links (Android) |
| App Store Optimization (ASO) | Optimización para posicionamiento en tiendas | Keywords, screenshots, ratings, reviews, localization |
| CI/CD Móvil | Integración y despliegue continuos para apps móviles | GitHub Actions, Bitrise, Codemagic, Fastlane |

## Tecnologías principales

| Tecnología | Tipo | Lenguaje | UI Framework | Rendimiento | Ecosistema | Ideal para |
|------------|------|----------|-------------|-------------|------------|------------|
| Swift + SwiftUI | Nativo iOS | Swift | SwiftUI + UIKit (compat) | Excelente | Nativo (Apple) | Apps iOS exclusivas, Apple ecosystem |
| Kotlin + Jetpack Compose | Nativo Android | Kotlin | Jetpack Compose | Excelente | Google, extenso | Apps Android, modern development |
| Flutter | Multiplataforma | Dart | Flutter Widgets (Skia/Impeller) | Muy alto | Google, creciente | Cross-platform, MVP rápido, UI consistente |
| React Native | Multiplataforma | JS/TS | RN Components + Hermes/JSC | Alto | Meta, extenso | Cross-platform, JS developers, Expo |
| Kotlin Multiplatform (KMP) | Multiplataforma | Kotlin | Compose Multiplatform | Alto | Kotlin (JetBrains) | Code sharing, UI nativa, lógica compartida |
| .NET MAUI | Multiplataforma | C# | MAUI Controls | Medio-alto | Microsoft | .NET ecosystem, enterprise |
| Ionic + Capacitor | Híbrido | JS/TS | Web (Angular/React/Vue) + Native plugins | Medio | Open source | Apps simples, Web devs, POCs |
| Xamarin (legacy) | Multiplataforma | C# | Xamarin.Forms (legacy) | Medio | Microsoft | Legacy .NET mobile apps |
| Unity (game) | Multiplataforma (games) | C# | Unity Engine | Excelente (games) | Unity Technologies | Juegos, 3D, AR/VR |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: plataformas (iOS, Android), SDK, emuladores/simuladores. Configurar entorno de desarrollo: Xcode (iOS), Android Studio (Android). Crear app "Hello World". Layouts básicos: SwiftUI (VStack, HStack, ZStack, Text, Image, Button), Jetpack Compose (Column, Row, Box, Text, Image, Button, Modifier). Navegación básica: NavigationStack (iOS), NavHost/Navigation (Android). Gestión de estado básica: @State (SwiftUI), remember/mutableStateOf (Compose). Compilación y ejecución en emulador y dispositivo físico. Estructura de proyecto estándar. Manejo de eventos: onTapGesture, Button onClick. Listas simples: List/ForEach (SwiftUI), LazyColumn (Compose).
   - Proyecto: App simple "Contador" o "Lista de tareas" básica. Desde UI hasta ejecución en emulador y dispositivo. 
   - Lectura: Apple SwiftUI Tutorials, Android Compose Basics, Flutter Get Started.

2. **Intermedio (3-8 meses)**: State Management avanzado: Observer pattern, ViewModel (Android), @Observable (iOS), providers. Networking: URLSession (iOS), Retrofit/Ktor (Android), http package (Flutter), fetch (RN). JSON parsing: Codable (iOS), Gson/Moshi/Kotlinx Serialization, json_serializable (Flutter). Persistencia local: SwiftData/CoreData (iOS), Room (Android), SQLite (Flutter), AsyncStorage (RN). Navegación avanzada: tabs, bottom navigation, nested navigation, passing data. Formularios: text input, validación, date pickers, pickers, switches. Cámara y galería: UIImagePickerController, CameraX, image_picker (Flutter/RN). Notificaciones push: Firebase Cloud Messaging, Apple Push Notification service. Publicación en stores: developer account, certificates, app icons, screenshots, App Store Connect, Google Play Console. APIs REST: consumo de API externa, manejo de errores, loading states.
   - Proyecto: App de clima con API REST, persistencia offline, localización GPS, UI con estados (loading, error, empty, success). Publicar en TestFlight.
   - Lectura: "iOS Programming: The Big Nerd Ranch Guide", "Android Programming: The Big Nerd Ranch Guide", Flutter docs.

3. **Avanzado (6-12 meses)**: Arquitecturas móviles: MVVM (MVVM + Repository + UseCases), Clean Architecture (capas: data, domain, presentation), Modular architecture (feature modules). Inyección de dependencias: Dagger Hilt/Koin (Android), Swinject/Factory (iOS), getIt/injectable (Flutter). Testing: unit tests (XCTest, JUnit, flutter_test), widget tests, integration tests (XCTest UI, Espresso, Compose Test, Flutter driver). Pruebas en dispositivos reales, snapshot testing. CI/CD móvil: Bitrise, Codemagic, Fastlane (match, gym, scan, deliver, pilot), GitHub Actions. Code signing management: Fastlane match, manual provisioning. Offline-first: repositorios con estrategias de cache (network-first, cache-first, stale-while-revalidate), sincronización en background, conflict resolution. Animaciones: SwiftUI animations, Compose animation, Lottie, Rive. Biometrics: Face ID / Touch ID (iOS), Biometric (Android), local_auth (Flutter). Performance profiling: Instruments (iOS), Android Profiler, Flutter DevTools, memory leaks, UI jank. Feature flags: LaunchDarkly, Firebase Remote Config, Unleash. Deep linking: Universal Links + App Links. Push notifications avanzado: rich push, notification payload, handling taps, notification categories.
   - Proyecto: App modular offline-first con Clean Architecture + DI + testing + CI/CD. Integration biometría, deep linking y push.
   - Certificación: Apple Certified iOS Developer (no oficial pero valorado), Google Associate Android Developer, Flutter Certified.

4. **Experto (12+ meses)**: App multiplataforma con Flutter/Compose Multiplatform para iOS + Android código compartido. Performance extremo: profiling avanzado, memory optimization, image caching, lazy loading, queued rendering, custom paint (Canvas). Seguridad: SSL pinning, runtime protection (obfuscation, anti-tamper), secure storage (Keychain, EncryptedSharedPreferences), jailbreak/root detection, code obfuscation (ProGuard, R8). App modular con feature SPM (Swift Package Manager) / Gradle modules / Flutter packages. Reactive architecture: Combine (iOS), Kotlin Flow (Android), RxDart. Advanced networking: GraphQL (Apollo), WebSockets (Streaming data), gRPC, REST with interceptors (logging, auth, caching). AR/VR: ARKit (iOS), ARCore (Android), AR Foundation, RealityKit, Apple Vision Pro (visionOS). AI/ML on-device: CoreML (iOS), ML Kit / TensorFlow Lite (Android/Flutter). SuperApp architecture: micro-apps dentro de app (like WeChat mini programs), dynamic feature delivery (Android App Bundle dynamic features). App security anti-piracy: license verification, integrity checks, obfuscation. Main thread optimization: structured concurrency (Swift async/await), Kotlin coroutines, isolates (Flutter). Accessibility (a11y): VoiceOver, TalkBack, dynamic type, sufficient color contrast. Widgets (iOS WidgetKit, Android Homescreen widgets) y watchOS/watch face complications.
   - Proyecto: SuperApp con micro-apps. AI on-device app (ML Kit / CoreML). Multi-platform Flutter app with native performance.
   - Certificación: Apple Certified iOS Developer, Google Associate Android Developer (AAD), Flutter Certified Application Developer (proyectos portafolio).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [001-Languages](../001-Languages/) | Swift (iOS), Kotlin (Android), Dart (Flutter), JS/TS (RN) |
| [002-Frameworks](../002-Frameworks/) | React Native, Flutter como frameworks multiplataforma |
| [003-Databases](../003-Databases/) | Persistencia local (SQLite, Room, SwiftData, Realm) y remota (Firestore) |
| [005-Cloud](../005-Cloud/) | Cloud functions, push notifications, hosting assets |
| [009-Security](../009-Security/) | App security, SSL pinning, secure storage, jailbreak detection |
| [010-Architecture](../010-Architecture/) | Clean Architecture, MVVM, MVP, MVI for mobile |
| [011-DesignPatterns](../011-DesignPatterns/) | Repository, Factory, Observer, Adapter en mobile |
| [012-Testing](../012-Testing/) | Unit, widget, integration tests for mobile |
| [021-Ecommerce](../021-Ecommerce/) | Mobile shopping apps, payment SDK, push for e-commerce |
| [026-Web](../026-Web/) | PWAs, web views, cross-platform web/mobile |
| [031-AI](../031-AI/) | On-device ML (CoreML, TFLite), AI-powered mobile features |

## Recursos recomendados

- **Documentación oficial**: Apple Developer (developer.apple.com), Android Developers (developer.android.com), Flutter (flutter.dev), React Native (reactnative.dev).
- **Libros**: "iOS Programming: The Big Nerd Ranch Guide" (7ª ed.), "Android Programming: The Big Nerd Ranch Guide" (4ª ed.), "Flutter Complete Reference" (Carlo), "React Native in Action" (Dabit).
- **Cursos**: Stanford CS193p (SwiftUI), Google Android Basics with Compose, Udemy "The Complete Flutter Development Bootcamp", "React Native: The Practical Guide".
- **Herramientas**: Xcode, Android Studio, VS Code, Flutter DevTools, Postman, Charles Proxy (debugging), Figma/Zeplin (design), Firebase Console.
- **Testing**: XCTest, Espresso, Maestro (mobile E2E), Detox (React Native), Patrol (Flutter).
- **ASO**: App Radar, Sensor Tower, App Annie, TheTool.
- **Comunidad**: iOS Dev Weekly, Android Weekly, Flutter Weekly, React Native Newsletter, Swift by Sundell.

## Notas adicionales

React Native (con Expo) es la opción más rápida para desarrollo cross-platform. Flutter ofrece mejor rendimiento y UI más consistente. Kotlin Multiplatform + Compose Multiplatform es la tendencia emergente para apps que necesitan máximo rendimiento nativo con código compartido. Las apps nativas siguen siendo necesarias para experiencias altamente optimizadas con acceso completo a hardware. Las PWAs son una alternativa creciente para apps simples sin necesidad de stores. La publicación en App Store es más restrictiva que Google Play. La accesibilidad (a11y) es cada vez más importante como requisito legal en muchos países.
