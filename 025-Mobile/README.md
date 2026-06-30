# 025-Mobile: Desarrollo Móvil

## Descripción del dominio

El desarrollo móvil comprende la creación de aplicaciones para dispositivos móviles (smartphones, tablets) utilizando plataformas nativas (iOS, Android) o soluciones multiplataforma. Incluye desde aplicaciones nativas con acceso completo al hardware hasta PWAs (Progressive Web Apps). El ecosistema móvil abarca stores (App Store, Google Play), SDKs, notificaciones push, mapas, pagos, biometría, cámara, sensores y conectividad Bluetooth/NFC.

## Conceptos clave

- **App nativa**: Desarrollada específicamente para una plataforma (Swift/iOS, Kotlin/Android)
- **Multiplataforma**: Código compartido entre plataformas (Flutter, React Native, Xamarin)
- **Hybrid app**: App web envuelta en un contenedor nativo (Cordova, Ionic, Capacitor)
- **PWA (Progressive Web App)**: App web instalable con capacidades offline y notificaciones
- **Widget**: Componente de interfaz en la pantalla de inicio del dispositivo
- **Push notifications**: Mensajes enviados desde servidor al dispositivo en tiempo real
- **Deep linking**: Enlace que abre contenido específico dentro de una app
- **App lifecycle**: Estados de la app (active, background, suspended, terminated)
- **State management**: Manejo del estado de la UI (Redux, BLoC, Provider, MobX)
- **Offline-first**: Estrategia que prioriza funcionalidad sin conexión con sincronización
- **App Store Optimization (ASO)**: Técnicas para mejorar posicionamiento en tiendas de apps
- **CI/CD móvil**: Integración y despliegue continuo con signing, store upload
- **TestFlight / Firebase Distribution**: Canales de distribución beta para pruebas
- **ABI / APK / IPA**: Formatos de empaquetado para Android y iOS
- **Code push**: Actualización en caliente de código JavaScript/React Native sin pasar por stores

## Tecnologías principales

- **Swift / SwiftUI**: Lenguaje y framework nativo para iOS/iPadOS/macOS, moderno y seguro
- **UIKit**: Framework tradicional de UI para iOS, basado en storyboards y código
- **Kotlin**: Lenguaje oficial moderno para Android, interoperable con Java
- **Jetpack Compose**: Framework declarativo de UI para Android (moderno)
- **Flutter**: SDK multiplataforma de Google (Dart), renderizado propio, alto rendimiento
- **React Native**: Framework multiplataforma de Meta (JavaScript/TypeScript), bridge nativo
- **Xamarin / MAUI**: Framework .NET multiplataforma de Microsoft, C# compartido
- **Ionic**: Framework híbrido basado en Angular/React/Vue con Capacitor o Cordova
- **Expo**: Toolchain para React Native simplificado, builds en la nube
- **Swift Package Manager / CocoaPods / SPM**: Gestores de dependencias iOS
- **Gradle / Maven**: Sistemas de build para Android con Kotlin/Java
- **Firebase**: Suite de Google para móviles (auth, analytics, crashlytics, messaging)
- **RevenueCat**: Monetización de suscripciones cross-platform
- **Apollo GraphQL**: Cliente GraphQL para apps móviles

## Hoja de ruta

1. **Principiante**: Crear app "Hello World" en iOS (Swift/SwiftUI) y Android (Kotlin/Jetpack Compose). Entender ciclo de vida, layouts básicos, navegación entre pantallas.
2. **Intermedio**: Consumir APIs REST/GraphQL. Implementar persistencia local (Core Data, Room). Navegación avanzada, tab bars, gestos. Publicar en tiendas. Notificaciones push.
3. **Avanzado**: Arquitectura limpia con inyección de dependencias. Pruebas unitarias y de UI. Offline-first con sincronización. Animaciones complejas. Integración con hardware (cámara, GPS, NFC). CI/CD móvil.
4. **Experto**: Desarrollo multiplataforma con Flutter/React Native para producción. Optimización de rendimiento (memory leaks, rendering). Componentes nativos personalizados (bridge). App modular con feature-based architecture. Seguridad avanzada (runtime protection, SSL pinning).

## Relaciones con otros módulos

- [Web](../026-Web/) — PWAs, APIs web compartidas, diseño responsive cross-platform
- [APIs](../079-APIs/) — APIs REST/GraphQL que consumen las apps móviles
- [Ecommerce](../021-Ecommerce/) — Apps de tiendas, pagos móviles, catálogos
- [PaymentGateways](../022-PaymentGateways/) — SDKs de pago en apps, wallets
- [Banking](../023-Banking/) — Apps de banca móvil, autenticación biométrica
- [Databases](../003-Databases/) — Persistencia local y remota (Firestore, SQLite)
- [Security](../009-Security/) — Cifrado local, autenticación, protección de datos
- [DesignPatterns](../011-DesignPatterns/) — MVVM, MVP, MVI, BLoC, Redux, Clean Architecture

## Recursos recomendados

- [Apple Developer Documentation](https://developer.apple.com/documentation)
- [Android Developers](https://developer.android.com)
- [Flutter Docs](https://docs.flutter.dev)
- [React Native Docs](https://reactnative.dev/docs)
- [Jetpack Compose Docs](https://developer.android.com/jetpack/compose)
- [Xamarin Docs](https://docs.microsoft.com/xamarin)
- "iOS Programming: The Big Nerd Ranch Guide"
- "Android Programming: The Big Nerd Ranch Guide"
- [Firebase Documentation](https://firebase.google.com/docs)
