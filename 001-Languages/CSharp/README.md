# C#

Lenguaje compilado (JIT/AOT), multiparadigma, tipado estático y fuerte. Creado por Anders Hejlsberg (2000) para .NET. Runtime: .NET CLR (CoreCLR). Estandarizado ECMA-334. Filosofía: productividad, seguridad de tipos, multiplataforma.

## Sintaxis básica

```csharp
Console.WriteLine("Hola, mundo");

var nombre = "Ana";
int edad = 30;
double altura = 1.75;
bool activo = true;
int? contador = null;  // nullable

var mensaje = $"Hola, {nombre}, tienes {edad} años";

if (edad >= 18) {
    Console.WriteLine("Mayor");
} else if (edad > 12) {
    Console.WriteLine("Adolescente");
} else {
    Console.WriteLine("Menor");
}

for (int i = 0; i < 5; i++) Console.WriteLine(i);
foreach (var x in new[] {1, 2, 3}) Console.WriteLine(x);

// Pattern matching (C#7+)
var categoria = edad switch {
    >= 18 => "Adulto",
    > 12  => "Adolescente",
    _     => "Menor"
};

int Sumar(int a, int b) => a + b;
```

## Tipado

Estático y fuerte. Value types (struct) vs reference types (class). Nullable reference types (C#8+). Generics, records (C#9), pattern matching exhaustivo.

```csharp
#nullable enable
string? posibleNull = null;

// Records: igualdad estructural (C#9)
public record Persona(string Nombre, int Edad);
var p1 = new Persona("Ana", 30);
var p2 = new Persona("Ana", 30);
Console.WriteLine(p1 == p2); // true

// Pattern matching exhaustivo
var descripcion = vehiculo switch {
    Coche c => $"Coche {c.Marca}",
    Bicicleta b => $"Bici {b.Color}",
    _ => "Otro"
};

// Generics
var lista = new List<int> { 42 };
int valor = lista[0];
```

## POO / Funcional

```csharp
public abstract class Vehiculo {
    public string Marca { get; }
    protected Vehiculo(string m) => Marca = m;
    public virtual string Mover() => "Vehículo se mueve";
}

public sealed class Coche : Vehiculo {
    public Coche(string m) : base(m) {}
    public override string Mover() => $"{Marca} acelera";
}

// LINQ (Language Integrated Query)
var nums = new[] {1, 2, 3, 4};
var pares = nums.Where(x => x % 2 == 0).ToList();
var doblados = nums.Select(x => x * 2).ToList();
var suma = nums.Aggregate(0, (a, b) => a + b);

// Extension methods
public static class StringExtensions {
    public static string Invertir(this string s) =>
        new string(s.Reverse().ToArray());
}

"hola".Invertir(); // "aloh"
```

## Concurrencia

```csharp
async Task<string> FetchDataAsync(int id) {
    await Task.Delay(100);
    return $"Datos {id}";
}

var results = await Task.WhenAll(
    Enumerable.Range(1, 3).Select(FetchDataAsync)
);

// Parallel LINQ
var paresParalelo = Enumerable.Range(1, 100).AsParallel()
    .Where(x => x % 2 == 0).ToList();

// async enumerables (C#8)
async IAsyncEnumerable<int> Generar() {
    for (int i = 0; i < 10; i++) {
        await Task.Delay(10);
        yield return i;
    }
}

// Span<T>: acceso seguro sin allocations
Span<byte> buffer = stackalloc byte[256];
```

## Ecosistema

- **.NET SDK** — compilador Roslyn, MSBuild
- **NuGet** — gestor de paquetes (~300k+)
- **Web**: ASP.NET Core (MVC, Minimal APIs, Blazor, SignalR)
- **ORM**: Entity Framework Core, Dapper
- **Testing**: xUnit, NUnit, MSTest
- **AOT**: Native AOT (C#11)
- **Serialización**: System.Text.Json

## Herramientas

```bash
dotnet new console -n MiApp
dotnet restore && dotnet build -c Release
dotnet test -v
dotnet publish -c Release -r linux-x64 -p:PublishAot=true
dotnet format
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [Web](../../026-Web/README.md)
- [.NET Runtime](../../003-Runtimes/dotNET/README.md)
```