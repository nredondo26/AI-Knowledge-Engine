# Kotlin Multiplatform (KMP) — Código Compartido, Apps Nativas

## Descripción General

Kotlin Multiplatform (KMP) permite compartir lógica de negocio entre Android, iOS, web y escritorio usando el mismo lenguaje Kotlin. La UI se mantiene nativa en cada plataforma (Jetpack Compose en Android, SwiftUI en iOS), maximizando la reutilización sin sacrificar experiencia nativa.

---

## Arquitectura

- **commonMain**: Código compartido (modelos, lógica, red, persistencia).
- **androidMain**: Implementaciones específicas Android.
- **iosMain**: Implementaciones específicas iOS (interop con Objective-C/Swift).
- **expect/actual**: Declaraciones multiplataforma con implementaciones por plataforma.

---

## Estructura del Proyecto

```
MiApp/
├── build.gradle.kts
├── settings.gradle.kts
├── shared/
│   ├── src/
│   │   ├── commonMain/kotlin/
│   │   ├── androidMain/kotlin/
│   │   └── iosMain/kotlin/
└── androidApp/
└── iosApp/
```

**settings.gradle.kts**:
```kotlin
pluginManagement {
    repositories { google(); mavenCentral(); gradlePluginPortal() }
}
rootProject.name = "MiApp"
include(":androidApp")
include(":shared")
```

---

## Código Compartido (commonMain)

```kotlin
// shared/src/commonMain/kotlin/com/ejemplo/model/Usuario.kt
data class Usuario(
    val id: Int,
    val nombre: String,
    val email: String
)

// shared/src/commonMain/kotlin/com/ejemplo/repository/UsuarioRepository.kt
class UsuarioRepository(private val api: ApiClient) {
    suspend fun getUsuarios(): List<Usuario> = api.get("usuarios")
    suspend fun getUsuario(id: Int): Usuario = api.get("usuarios/$id")
}
```

---

## expect/actual

```kotlin
// commonMain
expect class Platform {
    val name: String
}

expect fun getDeviceId(): String

// androidMain
actual class Platform actual constructor() {
    actual val name: String = "Android ${android.os.Build.VERSION.SDK_INT}"
}

actual fun getDeviceId(): String {
    return android.provider.Settings.Secure.getString(
        appContext.contentResolver,
        android.provider.Settings.Secure.ANDROID_ID
    )
}

// iosMain
actual class Platform actual constructor() {
    actual val name: String = "iOS ${UIDevice.currentDevice.systemVersion}"
}

actual fun getDeviceId(): String {
    return UIDevice.currentDevice.identifierForVendor.UUIDString
}
```

---

## Networking con Ktor

```kotlin
// shared/src/commonMain/kotlin/com/ejemplo/network/ApiClient.kt
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

class ApiClient(private val baseUrl: String) {
    private val client = HttpClient {
        install(ContentNegotiation) {
            json(Json { ignoreUnknownKeys = true; isLenient = true })
        }
    }

    suspend inline fun <reified T> get(path: String): T {
        return client.get("$baseUrl/$path").body()
    }
}
```

---

## Serialización (kotlinx.serialization)

```kotlin
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

@Serializable
data class Pedido(
    val id: Int,
    val total: Double,
    val items: List<String>
)

fun main() {
    val json = Json.encodeToString(Pedido(1, 99.99, listOf("item1", "item2")))
    val pedido = Json.decodeFromString<Pedido>(json)
}
```

---

## Corrutinas y Flow

```kotlin
// shared
class AuthRepository(private val api: ApiClient) {
    suspend fun login(email: String, password: String): Usuario {
        return api.post("auth/login", LoginRequest(email, password))
    }
}

// ViewModel compartido
class LoginViewModel(private val repo: AuthRepository) {
    private val _state = MutableStateFlow<LoginState>(LoginState.Idle)
    val state: StateFlow<LoginState> = _state

    suspend fun login(email: String, password: String) {
        _state.value = LoginState.Loading
        try {
            val user = repo.login(email, password)
            _state.value = LoginState.Success(user)
        } catch (e: Exception) {
            _state.value = LoginState.Error(e.message)
        }
    }
}

sealed class LoginState {
    object Idle : LoginState()
    object Loading : LoginState()
    data class Success(val user: Usuario) : LoginState()
    data class Error(val message: String?) : LoginState()
}
```

---

## Integración con Android (Jetpack Compose)

```kotlin
// androidApp
@Composable
fun LoginScreen(viewModel: LoginViewModel) {
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    val state by viewModel.state.collectAsState()

    Column(modifier = Modifier.padding(16.dp)) {
        OutlinedTextField(value = email, onValueChange = { email = it }, label = { Text("Email") })
        OutlinedTextField(value = password, onValueChange = { password = it }, label = { Text("Password") },
            visualTransformation = PasswordVisualTransformation())
        Button(onClick = { scope.launch { viewModel.login(email, password) } }) {
            Text("Iniciar sesión")
        }
        when (val s = state) {
            is LoginState.Loading -> CircularProgressIndicator()
            is LoginState.Error -> Text(s.message ?: "Error", color = Color.Red)
            else -> {}
        }
    }
}
```

---

## Integración con iOS (SwiftUI)

```swift
// iosApp
import SwiftUI
import shared

struct LoginView: View {
    @StateObject var viewModel = LoginObservable()
    @State var email = ""
    @State var password = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Iniciar sesión") {
                viewModel.login(email: email, password: password)
            }
            if viewModel.isLoading { ProgressView() }
        }.padding()
    }
}

class LoginObservable: ObservableObject {
    @Published var isLoading = false
    private let repo = AuthRepository(api: ApiClient(baseUrl: "https://api.ejemplo.com"))

    func login(email: String, password: String) {
        isLoading = true
        Task {
            try? await repo.login(email: email, password: password)
            DispatchQueue.main.async { self.isLoading = false }
        }
    }
}
```

---

## Compilación

```bash
# Android
./gradlew :androidApp:assembleRelease

# iOS
./gradlew :shared:linkDebugFrameworkIosSimulatorArm64
# Luego build con Xcode

# Pruebas compartidas
./gradlew :shared:allTests
```

---

## Mejores Prácticas

1. **Máximo en commonMain**: Logica de negocio, modelos, red, validación.
2. **expect/actual mínimo**: Solo para APIs de plataforma (almacenamiento, IDs).
3. **Ktor + kotlinx.serialization**: Networking tipado multi-plataforma.
4. **Corrutinas**: Para async en todas las plataformas.
5. **SQLDelight**: Persistencia local multiplataforma.
6. **UI nativa**: No forzar Compose Multiplatform si SwiftUI es más natural.

---

## Referencias

- [Kotlin Multiplatform Docs](https://kotlinlang.org/docs/multiplatform.html)
- [Ktor Client](https://ktor.io/docs/client-create-client.html)
- [SQLDelight](https://cashapp.github.io/sqldelight)
