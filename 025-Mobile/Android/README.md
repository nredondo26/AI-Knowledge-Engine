# Android — Desarrollo Nativo para el Ecosistema Google

## Descripción General

Android es un SO basado en el kernel Linux. El desarrollo nativo usa **Kotlin** (oficial) o **Java** con **Android Studio**. **Jetpack** es el conjunto de bibliotecas oficiales que aceleran el desarrollo.

---

## Arquitectura del Sistema

1. **Linux Kernel**: Procesos, memoria, drivers, red, seguridad.
2. **HAL**: Interfaz entre hardware y framework Java/Kotlin.
3. **ART**: Ejecuta DEX con compilación AOT + JIT híbrido.
4. **Native C/C++ Libraries**: OpenGL ES, Vulkan, WebKit, MediaCodec.
5. **Java API Framework**: ActivityManager, ContentProviders, etc.
6. **System Apps**: Lanzador, Contactos, Navegador.

---

## Kotlin

```kotlin
data class Usuario(val id: Long, val nombre: String, val email: String) {
    init {
        require(nombre.isNotBlank()) { "Nombre requerido" }
        require(email.contains("@")) { "Email inválido" }
    }
}
fun Usuario.toDisplayString(): String = "$nombre <$email>"
```

---

## Activities y Ciclo de Vida

```kotlin
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) { super.onCreate(savedInstanceState); setContentView(R.layout.activity_main) }
    override fun onStart() {}
    override fun onResume() {}
    override fun onPause() {}
    override fun onStop() {}
    override fun onDestroy() {}
    override fun onSaveInstanceState(outState: Bundle) { outState.putString("key", "valor") }
}
```

Fragment lifecycle: `onAttach` → `onCreate` → `onCreateView` → `onViewCreated` → `onStart` → `onResume` → `onPause` → `onStop` → `onDestroyView` → `onDestroy` → `onDetach`.

---

## Jetpack Compose

```kotlin
@Composable
fun ListaUsuarios(usuarios: List<Usuario>, onItemClick: (Usuario) -> Unit) {
    LazyColumn {
        items(usuarios) { u ->
            Card(modifier = Modifier.fillMaxWidth().padding(8.dp), elevation = CardDefaults.cardElevation(2.dp)) {
                Row(Modifier.padding(16.dp)) { Column { Text(u.nombre, fontWeight = FontWeight.Bold); Text(u.email, color = Color.Gray) } }
            }
        }
    }
}
```

---

## MVVM + Clean Architecture

```
┌──────────────────────────────────┐
│  UI Layer (Composable / Activity) │
├──────────────────────────────────┤
│  ViewModel (StateFlow)           │
├──────────────────────────────────┤
│  Domain Layer (casos de uso)     │
├──────────────────────────────────┤
│  Data Layer (Room, Retrofit)     │
└──────────────────────────────────┘
```

```kotlin
class UsuarioViewModel(private val repo: UsuarioRepository) : ViewModel() {
    private val _uiState = MutableStateFlow<UiState<List<Usuario>>>(UiState.Loading)
    val uiState: StateFlow<UiState<List<Usuario>>> = _uiState.asStateFlow()
    init { cargarUsuarios() }
    fun cargarUsuarios() = viewModelScope.launch {
        _uiState.value = UiState.Loading
        try { _uiState.value = UiState.Success(repo.obtenerUsuarios()) }
        catch (e: Exception) { _uiState.value = UiState.Error(e.message ?: "Error") }
    }
}
sealed class UiState<out T> { object Loading : UiState<Nothing>(); data class Success<T>(val data: T) : UiState<T>(); data class Error(val message: String) : UiState<Nothing>() }
```

---

## Room — Persistencia

```kotlin
@Entity(tableName = "usuarios")
data class UsuarioEntity(@PrimaryKey val id: Long, val nombre: String, val email: String)

@Dao
interface UsuarioDao {
    @Query("SELECT * FROM usuarios") fun obtenerTodos(): Flow<List<UsuarioEntity>>
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insertar(u: UsuarioEntity)
}
```

---

## Retrofit + OkHttp

```kotlin
interface ApiService { @GET("users") suspend fun getUsers(): List<UsuarioResponse> }

val retrofit = Retrofit.Builder().baseUrl("https://api.ejemplo.com/")
    .client(OkHttpClient.Builder().connectTimeout(30, TimeUnit.SECONDS).build())
    .addConverterFactory(MoshiConverterFactory.create(Moshi.Builder().addLast(KotlinJsonAdapterFactory()).build()))
    .build()
```

---

## Hilt — DI

```kotlin
@HiltAndroidApp class App : Application()
@AndroidEntryPoint class MainActivity : AppCompatActivity() { @Inject lateinit var factory: ViewModelProvider.Factory }
```

---

## Testing

```kotlin
@Test fun `cargar usuarios exitosamente`() = runTest {
    coEvery { repository.obtenerUsuarios() } returns listOf(mockUsuario())
    val state = viewModel.uiState.first { it is UiState.Success }
    assertTrue(state is UiState.Success)
}
```

---

## Build Variants

```groovy
android {
    buildTypes {
        debug { applicationIdSuffix ".debug"; isMinifyEnabled = false }
        release { isMinifyEnabled = true; proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro") }
    }
}
```

---

## Publicación

Formato **App Bundle (.aab)** obligatorio. Play Console con tracks: internal, alpha, beta, production. Play Integrity API para verificar autenticidad.

---

## Referencias

- [Android Developers](https://developer.android.com/docs)
- [Kotlin Docs](https://kotlinlang.org/docs/home.html)
