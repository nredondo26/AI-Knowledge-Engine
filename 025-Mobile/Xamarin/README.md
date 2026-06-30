# Xamarin — Aplicaciones Móviles con .NET

## Descripción General

Xamarin es el framework de Microsoft para crear apps móviles nativas con C# y .NET. Sucesor: **.NET MAUI** (Multi-platform App UI), que unifica Android, iOS, macOS, Windows y Tizen en una sola plataforma.

---

## Arquitectura de Xamarin

- **Xamarin.Android**: Compila C# a IL, ejecutado en Mono con binding a Java/Kotlin.
- **Xamarin.iOS**: Compila C# a IL con AOT (Ahead-of-Time) para iOS nativo.
- **Xamarin.Forms**: Capa de UI compartida que renderiza controles nativos en cada plataforma.

---

## Hola Mundo con .NET MAUI

```xml
<!-- MainPage.xaml -->
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="MiApp.MainPage">
    <VerticalStackLayout Spacing="25" Padding="30">
        <Label Text="¡Hola, MAUI!" FontSize="32" HorizontalOptions="Center" />
        <Button Text="Presióname" Clicked="OnButtonClicked" />
        <Label x:Name="MensajeLabel" FontSize="18" HorizontalOptions="Center" />
    </VerticalStackLayout>
</ContentPage>
```

```csharp
// MainPage.xaml.cs
using Microsoft.Maui.Controls;

namespace MiApp;

public partial class MainPage : ContentPage
{
    private int _contador = 0;

    public MainPage()
    {
        InitializeComponent();
    }

    private void OnButtonClicked(object sender, EventArgs e)
    {
        _contador++;
        MensajeLabel.Text = $"Presionado {_contador} veces";
    }
}
```

---

## MVVM con Xamarin.Forms

```csharp
// Model
public class Usuario
{
    public string Nombre { get; set; }
    public string Email { get; set; }
}

// ViewModel
public class UsuarioViewModel : INotifyPropertyChanged
{
    private string _nombre;
    public string Nombre
    {
        get => _nombre;
        set { _nombre = value; OnPropertyChanged(); }
    }

    public ICommand GuardarCommand { get; }

    public UsuarioViewModel()
    {
        GuardarCommand = new Command(async () => await Guardar());
    }

    private async Task Guardar()
    {
        await Application.Current.MainPage.DisplayAlert("OK", $"Guardado: {Nombre}", "Aceptar");
    }

    public event PropertyChangedEventHandler PropertyChanged;
    protected void OnPropertyChanged([CallerMemberName] string name = null)
        => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
}
```

---

## Navegación (Shell)

```xml
<Shell xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
       xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
       x:Class="MiApp.AppShell">
    <TabBar>
        <ShellContent Title="Inicio" ContentTemplate="{DataRouter local:HomePage}" Route="home" />
        <ShellContent Title="Perfil" ContentTemplate="{DataRouter local:ProfilePage}" Route="profile" />
    </TabBar>
</Shell>
```

```csharp
await Shell.Current.GoToAsync("profile");
await Shell.Current.GoToAsync("detail?id=42");
```

---

## Consumo de API REST

```csharp
public class ApiService
{
    private readonly HttpClient _http = new()
    {
        BaseAddress = new Uri("https://api.ejemplo.com/")
    };

    public async Task<List<Usuario>> GetUsuariosAsync()
    {
        var response = await _http.GetAsync("usuarios");
        response.EnsureSuccessStatusCode();
        var json = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<List<Usuario>>(json);
    }

    public async Task<Usuario> CreateUsuarioAsync(Usuario usuario)
    {
        var json = JsonSerializer.Serialize(usuario);
        var content = new StringContent(json, Encoding.UTF8, "application/json");
        var response = await _http.PostAsync("usuarios", content);
        response.EnsureSuccessStatusCode();
        var result = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<Usuario>(result);
    }
}
```

---

## Persistencia Local (SQLite)

```csharp
[Table("usuarios")]
public class UsuarioDb
{
    [PrimaryKey, AutoIncrement]
    public int Id { get; set; }
    public string Nombre { get; set; }
    public string Email { get; set; }
}

public class DatabaseService
{
    private SQLiteAsyncConnection _db;

    public async Task InitAsync()
    {
        if (_db is not null) return;
        var path = Path.Combine(FileSystem.AppDataDirectory, "miapp.db3");
        _db = new SQLiteAsyncConnection(path);
        await _db.CreateTableAsync<UsuarioDb>();
    }

    public async Task<List<UsuarioDb>> GetAllAsync()
    {
        await InitAsync();
        return await _db.Table<UsuarioDb>().ToListAsync();
    }

    public async Task<int> SaveAsync(UsuarioDb usuario)
    {
        await InitAsync();
        return await _db.InsertAsync(usuario);
    }
}
```

---

## Platform-Specific Code

```csharp
// Interfaces compartidas
public interface IDeviceInfo
{
    string GetDeviceName();
}

// Android
[assembly: Dependency(typeof(MiApp.Droid.DeviceInfo))]
namespace MiApp.Droid;
public class DeviceInfo : IDeviceInfo
{
    public string GetDeviceName() => Android.OS.Build.Model;
}

// iOS
[assembly: Dependency(typeof(MiApp.iOS.DeviceInfo))]
namespace MiApp.iOS;
public class DeviceInfo : IDeviceInfo
{
    public string GetDeviceName() => UIDevice.CurrentDevice.Name;
}

// Uso compartido: var name = DependencyService.Get<IDeviceInfo>().GetDeviceName();
```

---

## Compilación y Publicación

```bash
# Android
dotnet publish -f net8.0-android -c Release

# iOS
dotnet publish -f net8.0-ios -c Release

# MAUI multi-target
dotnet build -f net8.0-android
dotnet build -f net8.0-ios
```

---

## Pruebas Unitarias

```csharp
[TestClass]
public class UsuarioViewModelTests
{
    [TestMethod]
    public void Nombre_SeActualizaCorrectamente()
    {
        var vm = new UsuarioViewModel();
        vm.Nombre = "Ana";
        Assert.AreEqual("Ana", vm.Nombre);
    }
}
```

---

## Mejores Prácticas

1. **MVVM**: Separación clara entre UI y lógica de negocio.
2. **Inyección de dependencias**: Usar contenedor DI de MAUI.
3. **Código compartido**: Máximo código en proyecto compartido, mínimo platform-specific.
4. **SQLite**: Para persistencia local offline-first.
5. **HttpClient**: Singleton para evitar socket exhaustion.

---

## Referencias

- [Microsoft MAUI Docs](https://learn.microsoft.com/dotnet/maui)
- [Xamarin.Forms Docs](https://learn.microsoft.com/xamarin/xamarin-forms)
- [Xamarin Community Toolkit](https://github.com/xamarin/XamarinCommunityToolkit)
