# 027-Desktop: Aplicaciones de Escritorio

## Descripción del dominio

El desarrollo de aplicaciones de escritorio abarca la creación de software que se ejecuta nativamente en sistemas operativos de escritorio (Windows, macOS, Linux). Incluye tecnologías nativas (WPF, WinForms, Qt, GTK, Cocoa) y frameworks multiplataforma (Electron, Tauri, .NET MAUI, Flutter Desktop, JavaFX). Las tendencias actuales combinan capacidades nativas con tecnologías web (Electron, Tauri), ofreciendo experiencias ricas con acceso completo al sistema de archivos, hardware y APIs del SO.

## Conceptos clave

- **Native app**: Aplicación compilada para un sistema operativo específico (Win32, Cocoa, X11)
- **Cross-platform desktop**: Framework que permite ejecutar la misma app en múltiples SO
- **Electron**: Framework que ejecuta apps web como escritorio usando Chromium + Node.js
- **Tauri**: Framework alternativo a Electron, usa el webview del sistema, más ligero (+Rust)
- **Webview**: Componente nativo del SO para renderizar contenido web (WKWebView, WebView2)
- **Win32 API**: API nativa de Windows para aplicaciones de escritorio
- **WPF (Windows Presentation Foundation)**: Framework .NET para UI de escritorio Windows con XAML
- **WinForms**: Framework .NET tradicional para aplicaciones Windows
- **Qt**: Framework C++ multiplataforma, usado en KDE, Docker Desktop, VLC
- **GTK**: Toolkit C multiplataforma, usado en GNOME, GIMP
- **Menubar/Tray**: Icono y menú en la barra de estado del sistema
- **System Tray**: Icono en el área de notificación del SO
- **Auto-updater**: Mecanismo de actualización automática de la aplicación
- **IPC (Inter-Process Communication)**: Comunicación entre procesos (main process ↔ renderer en Electron)
- **Native modules**: Módulos compilados en C++ accesibles desde frameworks JS
- **Window management**: Manejo de ventanas, posiciones, tamaños, estados (maximizado, minimizado)
- **Drag & drop**: Arrastrar y soltar archivos desde el sistema hacia la aplicación
- **File system access**: Acceso nativo a archivos y directorios locales

## Tecnologías principales

- **Electron**: Chromium + Node.js, apps como VS Code, Slack, Discord, WhatsApp Desktop, Figma
- **Tauri**: Webview del SO + backend Rust, más pequeño y seguro, creciendo rápidamente
- **WPF (.NET)**: Framework Windows con XAML, data binding, MVVM, usado en aplicaciones enterprise
- **WinForms (.NET)**: Legacy pero aún usado en apps empresariales de Windows
- **Qt (C++ / PySide / QML)**: Framework multiplataforma C++ con bindings para Python, JS, Rust
- **GTK (C / Python / Rust)**: Toolkit del ecosistema GNOME, GIMP, Inkscape
- **Flutter Desktop**: Versión desktop de Flutter (Windows, macOS, Linux) — emergente
- **.NET MAUI**: Evolución de Xamarin.Forms para desktop (Windows, macOS)
- **JavaFX**: Framework Java para UI de escritorio, reemplazo de Swing
- **Swing (Java)**: Legacy toolkit Java para aplicaciones desktop
- **Cocoa (macOS)**: Framework nativo de Apple para apps macOS con Swift/Objective-C
- **Sciter**: Motor HTML/CSS ligero para apps desktop nativas
- **Neutralino.js**: Alternativa minimalista sin Chromium, usa webview nativo
- **NW.js**: Similar a Electron, permite Node.js directo en el frontend

## Hoja de ruta

1. **Principiante**: Crear app de escritorio simple con Electron. Entender procesos main/renderer, IPC, menús y ventanas. Empaquetar y distribuir. Alternativa: app básica con Tauri.
2. **Intermedio**: Aplicación desktop con acceso a sistema de archivos, notificaciones, tray icon. Integraciones con APIs del SO (shell, diálogos). Auto-updater. SQLite local.
3. **Avanzado**: Arquitectura robusta con separación de procesos. Módulos nativos compilados para rendimiento crítico. Comunicación IPC segura y eficiente. Testing (unit, integration, E2E). Distribución multi-plataforma con firmado (code signing).
4. **Experto**: Comparativa y selección óptima de framework según caso de uso. Optimización de memoria y rendimiento. Integración profunda con el SO (DLLs, .dylib, .so). Acceso a hardware (USB, impresoras, Bluetooth). Aplicaciones de tiempo real con GPU acceleration.

## Relaciones con otros módulos

- [Web](../026-Web/) — Electron/Tauri renderizan UI web, conocimientos de HTML/CSS/JS compartidos
- [Mobile](../025-Mobile/) — Diseño UI/UX multiplataforma, patrones de estado
- [Frameworks](../002-Frameworks/) — Frameworks desktop y librerías UI
- [Languages](../001-Languages/) — Rust (Tauri), C++ (Qt), C# (WPF/MAUI), Python (GTK/PyQt)
- [Security](../009-Security/) — Sandboxing, code signing, permisos del SO
- [OperatingSystems](../004-OperatingSystems/) — APIs específicas de Windows, macOS, Linux
- [IDEs](../075-IDEs/) — Las apps desktop más famosas (VS Code, JetBrains) son Electron/Java

## Recursos recomendados

- [Electron Documentation](https://www.electronjs.org/docs)
- [Tauri Documentation](https://tauri.app/start)
- [Qt Documentation](https://doc.qt.io)
- [WPF Documentation (Microsoft)](https://learn.microsoft.com/dotnet/desktop/wpf)
- [.NET MAUI Docs](https://learn.microsoft.com/dotnet/maui)
- [Flutter Desktop](https://docs.flutter.dev/platform-integration/desktop)
- "Electron in Action" — Steve Kinney
- "Qt 6 C++ GUI Programming Cookbook" — Packt
- [GTK Documentation](https://docs.gtk.org)
