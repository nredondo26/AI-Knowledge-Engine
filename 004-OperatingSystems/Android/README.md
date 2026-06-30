# Android — Sistema Operativo Móvil

## Descripción del dominio

Android es un sistema operativo móvil basado en el kernel de Linux, desarrollado por Google y el consorcio Open Handset Alliance. Es el SO móvil más utilizado del mundo, presente en smartphones, tablets, smart TVs (Android TV), wearables (Wear OS), automóviles (Android Automotive) y dispositivos embebidos. Android utiliza una arquitectura en capas: kernel Linux modificado, HAL (Hardware Abstraction Layer), Android Runtime (ART), frameworks de aplicaciones (Java/Kotlin) y NDK (C/C++). La seguridad se basa en sandboxing por aplicación (UIDs Linux), permisos granulares, cifrado, SELinux en modo enforcing y Google Play Protect.

## Áreas clave

- **Arquitectura**: Linux kernel, HAL, Android Runtime (ART), framework de aplicaciones, System UI
- **Lenguajes de desarrollo**: Kotlin (preferido), Java, C/C++ (NDK), Flutter/Dart, React Native
- **Componentes de aplicación**: Activity, Service, BroadcastReceiver, ContentProvider — ciclo de vida, intents, fragments
- **Arquitectura de apps recomendada**: MVVM con Android Architecture Components (LiveData, ViewModel, Room, Navigation, WorkManager)
- **Material Design 3**: Sistema de diseño de Google con temas dinámicos (Material You), componentes, tipografía
- **Permisos**: Install-time (automáticos), runtime (solicitud en uso), dangerous/normal/signature — modelos granular por permiso
- **Almacenamiento**: SharedPreferences, Room (SQLite), DataStore, almacenamiento interno/externo, Scoped Storage (Android 10+)
- **Red**: Retrofit, OkHttp, Volley, Ktor, WebSockets, GraphQL (Apollo), Firebase Cloud Messaging
- **Compilación**: Gradle, AGP (Android Gradle Plugin), R8/ProGuard, bundle (AAB) para distribución
- **Pruebas**: JUnit, Espresso (UI), Robolectric (unitarias con Android framework), MockK, Compose UI Test

## Ejemplo: Fragment y ViewModel en Kotlin

```kotlin
// ViewModel
class MainViewModel : ViewModel() {
    private val _count = MutableLiveData(0)
    val count: LiveData<Int> = _count

    fun increment() { _count.value = (_count.value ?: 0) + 1 }
}

// Fragment
class MainFragment : Fragment() {
    private val viewModel: MainViewModel by viewModels()

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        viewModel.count.observe(viewLifecycleOwner) { count ->
            binding.textCount.text = "Contador: $count"
        }
        binding.buttonIncrement.setOnClickListener {
            viewModel.increment()
        }
    }
}
```

## Ejemplo: AndroidManifest con permisos

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:label="@string/app_name"
        android:theme="@style/Theme.MyApp"
        android:allowBackup="false">
        <activity android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

## Tecnologías principales

- **IDE**: Android Studio (basado en IntelliJ IDEA)
- **Framework de UI**: Jetpack Compose (declarativo, moderno), XML con View System (legacy)
- **Inyección de dependencias**: Hilt (Dagger), Koin, Kodein
- **Red**: Retrofit + OkHttp, Ktor Client, Apollo GraphQL
- **Base de datos local**: Room, Realm, SQLDelight
- **Navegación**: Jetpack Navigation Component, Compose Navigation, Decompose
- **Async**: Coroutines + Flow, RxJava/RxKotlin
- **Testing**: JUnit 5, MockK, Turbine (Flow), Compose UI Test
- **Distribución**: Google Play Store, AAB (Android App Bundle), Firebase App Distribution

## Buenas prácticas

- Usar Jetpack Compose para nuevas UIs; migrar gradualmente desde XML
- Aplicar MVVM con ViewModel + StateFlow/Flow (no LiveData en Compose)
- Solicitar permisos runtime solo cuando sean necesarios, con justificación
- Usar Scoped Storage (MediaStore / SAF) en lugar de acceso directo a rutas
- Implementar navegación con Jetpack Navigation o Compose Navigation
- Usar WorkManager para tareas diferidas/en segundo plano (no servicios en foreground)
