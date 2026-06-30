# 027-Desktop: Desarrollo de Escritorio

## Descripción ampliada del dominio

El desarrollo de escritorio crea aplicaciones que se ejecutan nativamente en sistemas operativos de escritorio (Windows, macOS, Linux). Aunque las aplicaciones web y móviles han ganado protagonismo, las aplicaciones de escritorio siguen siendo esenciales para herramientas de productividad (Microsoft Office, Adobe Creative Suite), desarrollo (VS Code, JetBrains IDEs), diseño (Figma, Sketch), gaming, y aplicaciones enterprise que requieren acceso completo a hardware, alto rendimiento, capacidades offline y experiencia de usuario rica. La evolución del desarrollo desktop: aplicaciones nativas (C/C++ Win32/MFC, Cocoa/Objective-C, GTK/Qt en Linux, 1990s-2000s) → frameworks gestionados (.NET Windows Forms/WPF, Java Swing/JavaFX, 2000s-2010s) → frameworks multiplataforma (Electron, Qt, Flutter, 2015+) → aplicaciones web progresivas nativas (Tauri, Flutter Desktop, 2020+). Las tendencias actuales son: aplicaciones de escritorio impulsadas por WebView (Electron, Tauri), frameworks multiplataforma (Flutter, .NET MAUI, Qt), progressive web apps instalables como desktop apps, y aplicaciones nativas optimizadas con Rust y Swift.

## Tabla de conceptos clave

| Concepto | Descripción | Frameworks |
|----------|-------------|------------|
| Nativo Windows | Aplicaciones para Windows usando APIs nativas | Win32, MFC, WPF, UWP, WinUI 3, Windows Forms |
| Nativo macOS | Aplicaciones para macOS usando frameworks Apple | Cocoa (Objective-C), SwiftUI, AppKit |
| Nativo Linux | Aplicaciones para Linux usando toolkits GTK/Qt | GTK (C/Python), Qt (C++/Python), EFL |
| Multiplataforma | Código base compartido entre Windows, macOS, Linux | Qt, wxWidgets, .NET MAUI, Flutter, JavaFX, Tauri |
| Electron | Framework multiplataforma basado en Chromium + Node.js | Electron (VS Code, Slack, Discord, Figma) |
| Tauri | Framework multiplataforma ligero usando WebView nativo + Rust backend | Tauri (Rust + JS/TS, más ligero que Electron) |
| Flutter Desktop | Framework declarativo multiplataforma de Google | Flutter Desktop, lenguaje Dart |
| WebView | Componente de navegador embebido en app nativa | WKWebView (macOS), WebView2 (Windows), WebKitGTK (Linux) |
| Arquitectura MVVM | Model-View-ViewModel para UI de escritorio | WPF MVVM, .NET MAUI MVVM, Qt QML |
| Single Instance | Garantizar que solo una instancia de la app se ejecute | Named pipes, lock files, Mutex |

## Tecnologías principales

| Framework | Lenguaje | Plataformas | Rendimiento | Tamaño app | Complejidad | Casos de uso |
|-----------|----------|-------------|-------------|------------|-------------|--------------|
| Qt 6 | C++, Python (PySide6/PyQt6) | Win, Mac, Linux | Nativo | Medio | Alta | Apps profesionales, CAD, multimedia |
| Electron | JS/TS, HTML, CSS | Win, Mac, Linux | Medio | Grande (100MB+) | Media | Apps web-like: VS Code, Slack, Discord |
| Tauri 2 | Rust + JS/TS | Win, Mac, Linux | Casi nativo | Pequeño (3-10MB) | Media | Apps ligeras, seguras, modernas |
| WPF (.NET) | C# | Windows | Nativo | Medio | Alta | Apps empresariales Windows |
| WinUI 3 | C# | Windows 10+ | Nativo (moderno) | Medio | Alta | Apps modernas Windows 11 |
| Flutter Desktop | Dart | Win, Mac, Linux | Alto | Medio (20-40MB) | Media | Cross-platform UI consistente |
| SwiftUI | Swift | macOS, iOS, watchOS, tvOS | Nativo | Pequeño | Baja | Ecosistema Apple, moderno |
| .NET MAUI | C# | Win, Mac, Android, iOS | Medio-alto | Medio | Media | .NET ecosystem, cross-platform |
| JavaFX | Java, Kotlin, Scala | Win, Mac, Linux | Alto | Grande (JRE) | Alta | Enterprise, scientific |
| GTK 4 | C, Python (PyGObject), Rust | Linux, Mac, Win | Nativo | Medio | Alta | Linux apps, GNOME ecosystem |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos fundamentales: ciclo de eventos (event loop), widgets/componentes, layouts, ventanas. Crear primera app: "Hello World" con Tauri + React/Vue, o Python + tkinter, o .NET MAUI. Manejo de eventos: click, input, selección. Widgets básicos: button, label, text input, checkbox, radio, list, combo box, menubar. Layouts: stack, grid, border, absolute positioning. Diálogos: message box, file open/save, color picker, font dialog. Estructura típica de proyecto desktop.
   - Práctica: App simple "Calculadora" con Tauri/Electron/tkinter. App "To-Do List" con persistencia en archivo JSON.
   - Lectura: Tauri docs, Electron docs, Python tkinter docs, .NET MAUI tutorials.

2. **Intermedio (2-6 meses)**: Modelo de datos y persistencia: SQLite integrado, JSON/YAML config files, serialización. MVVM/MVC arquitectura: separación UI, lógica de negocio y datos. Data binding: enlace entre UI y modelo (WPF Binding, Qt signals/slots, Flutter streams). Menús: menubar, context menu, shortcuts, accelerators. Configuraciones: persistencia de preferencias, user settings. Eventos avanzados: drag and drop, clipboard, keyboard events, mouse events. Canvas y gráficos 2D básicos (custom painting, shapes, text). Multiventana: ventanas hijas, modales, pestañas. Undo/Redo: command pattern para acciones del usuario. Internacionalización (i18n): resource files, localization.
   - Proyecto: App de notas con markdown (edición, vista previa, archivos, categorías). Editor de imágenes simple (crop, resize, filters).
   - Lectura: Tauri advanced docs, Qt documentation (qt.io), "WPF 4.5 Unleashed" (Nathan).

3. **Avanzado (6-12 meses)**: Rendimiento: lazy loading, virtualized lists (Large data sets), async operations (background threads, async/await), Web Workers (Electron), memory profiling, avoiding UI thread blocking. Threading: main thread vs worker threads, thread safety, UI dispatcher, synchronization. Procesos IPC (Electron): main process ↔ renderer process, contextBridge, preload scripts. System integration: file associations, custom URI scheme (deep linking), system tray, notifications, startup at boot, auto-update (electron-updater, Tauri updater), Windows Taskbar (jump lists, progress). Hardware access: serial port, Bluetooth, USB HID, camera, microphone, printer. Advanced graphics: hardware acceleration, Canvas 2D/WebGL (Electron/Tauri), Skia (Flutter). Testing desktop apps: unit tests, integration tests (spectron for Electron, Tauri driver, Flutter integration test), UI automation. Packaging and distribution: app signing (codesign), installers (NSIS, WiX, DMG, .deb/.rpm, AppImage). CI/CD for desktop: GitHub Actions build matrix (Win + Mac + Linux), code signing, notarization (macOS), automated releases. Accessibility: screen readers (VoiceOver, NVDA, JAWS), keyboard navigation, high contrast. Security: sandboxing, CSP in webviews, IPC validation, secure storage (keychain, dpapi).
   - Proyecto: App de productividad (Kanban board, calendar, diagram editor) con file system, auto-save, undo/redo, system tray, auto-update.
   - Certificación: No hay certificaciones específicas de desktop frameworks muy establecidas, pero contribuciones open source son muy valoradas.

4. **Experto (12+ meses)**: High-performance rendering: Skia/OpenGL/DirectX integration, Vulkan (via Rust), custom shaders, GPGPU (CUDA, OpenCL). System-level integration: OS-specific APIs via FFI (Win32, Cocoa, Linux D-Bus), DLL injection, Windows services, macOS XPC services, Linux daemons. Native plugins: Rust native plugins (Tauri), C++ addons (Electron native modules, node-gyp). Performance profiling: Instruments (macOS), Visual Studio Profiler, Valgrind, perf (Linux), Chrome DevTools (Electron). Custom window chrome: frameless window, custom titlebar, rounded corners (Windows 11), vibrancy (macOS), blur behind. Multi-process architecture: Chromium's multi-process model (Electron), process sandboxing, process management for large apps. Security hardening: hardening Electron (contextIsolation, sandbox, disable remote), Tauri allowlist, code signing (authenticode, macOS hardened runtime). Accessibility compliance: WCAG 2.1 AA, Section 508, EN 301 549. Distribution at scale: Windows Store, Mac App Store, Linux packaging (Snap, Flatpak, AppImage), MSI/GPO deployment. WebView bridges: React/Next.js + Tauri/Electron (hybrid web-desktop apps). Auto-update infrastructure: Sparkle (macOS), Squirrel (Windows), Tauri updater (Rust). AI/ML on desktop: local LLMs with Ollama/llama.cpp, Whisper for speech, ONNX Runtime, TensorRT. Blockchain desktop: crypto wallets, dApp browsers.
   - Proyecto: App desktop AI-local (chat with local LLM, image generation). High-performance CAD or video editor. Desktop app with system-level integration (file manager replacement).
   - Lectura: Electron source code, Tauri source code, "Building Desktop Applications with Electron" (Ghatole), Rust + Tauri guides.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [001-Languages](../001-Languages/) | Swift (macOS), C# (Windows), C++ (Qt), JS/TS (Electron/Tauri) |
| [002-Frameworks](../002-Frameworks/) | Tauri, Electron como frameworks multiplataforma |
| [004-OperatingSystems](../004-OperatingSystems/) | Win32, Cocoa, Linux system calls, filesystem |
| [009-Security](../009-Security/) | Code signing, sandboxing, secure storage, IPC security |
| [010-Architecture](../010-Architecture/) | Arquitectura MVVM, MVC, event-driven |
| [011-DesignPatterns](../011-DesignPatterns/) | Command (undo/redo), Observer (events), Singleton |
| [026-Web](../026-Web/) | Electron/Tauri usan tecnologías web |
| [031-AI](../031-AI/) | On-device AI apps, local LLM desktop clients |

## Recursos recomendados

- **Frameworks principales**: Tauri (tauri.app), Electron (electronjs.org), Qt (qt.io), Flutter Desktop (flutter.dev/desktop), .NET MAUI (learn.microsoft.com/dotnet/maui).
- **Libros**: "Electron in Action" (Morscheuser), "Building Desktop Applications with Electron" (Ghatole), "C++ GUI Programming with Qt 4" (Blanchette, Summerfield), "WPF 4.5 Unleashed" (Nathan).
- **Cursos**: "Electron for Desktop Apps" (Udemy), "Rust & Tauri" (Udemy), "Qt 6 C++" (Udemy).
- **Herramientas**: VS Code, Qt Creator, JetBrains Rider (C#), CLion (C++), Rust Rover (Rust), Android Studio (Flutter).
- **Recursos de diseño**: Human Interface Guidelines (Apple), Windows Design Guidelines, GNOME HIG, Material Design 3.

## Notas adicionales

Tauri es la tendencia más prometedora: apps ligeras, seguras (Rust backend), multiplataforma, con frontend web (React, Vue, Svelte). Electron sigue siendo el estándar para apps que necesitan máximo ecosistema web. Qt es la opción para apps profesionales críticas (CAD, multimedia). Flutter Desktop es excelente para UI consistente cross-platform. Las apps nativas (SwiftUI, WinUI) ofrecen mejor integración con el SO pero requieren desarrollo separado. Las aplicaciones de escritorio con AI local (LLM, Whisper) son una tendencia creciente.
