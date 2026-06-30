# ASP.NET Core

## Descripción

ASP.NET Core es un framework web multiplataforma de alto rendimiento de Microsoft, escrito en C#. Lanzado en 2016, es de código abierto y funciona en Windows, Linux y macOS. Incluye MVC, Web APIs, Razor Pages, Blazor (WebAssembly/Server), SignalR (WebSockets), Entity Framework Core (ORM) y autenticación integrada. Es la plataforma preferida para aplicaciones empresariales en .NET.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Middlewares** | Componentes que procesan peticiones/respuestas en pipeline. |
| **MVC** | Model-View-Controller con routing por atributos. |
| **Blazor** | UIs interactivas con C# en vez de JavaScript. |
| **Entity Framework Core** | ORM multiplataforma con LINQ y migraciones. |
| **Inyección de dependencias** | DI nativa en el contenedor de servicios. |
| **Minimal APIs** | APIs ligeras sin controladores, ideales para microservicios. |

---

## Ejemplos de código

### Minimal API

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

List<Tarea> tareas = [];
var nextId = 1;

app.MapGet("/api/tareas", () => tareas);

app.MapPost("/api/tareas", (TareaDto dto) =>
{
    var t = new Tarea(nextId++, dto.Texto, false);
    tareas.Add(t);
    return Results.Created($"/api/tareas/{t.Id}", t);
});

app.MapDelete("/api/tareas/{id}", (int id) =>
{
    var t = tareas.FirstOrDefault(t => t.Id == id);
    return t is null ? Results.NotFound() : Results.Ok(tareas.Remove(t));
});

app.Run();

record Tarea(int Id, string Texto, bool Completada);
record TareaDto(string Texto);
```

### Controlador con EF Core

```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductosController : ControllerBase
{
    private readonly AppDbContext _db;
    public ProductosController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<ActionResult<List<Producto>>> GetAll()
        => await _db.Productos.ToListAsync();

    [HttpPost]
    public async Task<ActionResult<Producto>> Create(Producto p)
    {
        _db.Productos.Add(p);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetAll), new { id = p.Id }, p);
    }
}

public class Producto
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public decimal Precio { get; set; }
    public int CategoriaId { get; set; }
    public Categoria Categoria { get; set; } = null!;
}

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> o) : base(o) { }
    public DbSet<Producto> Productos => Set<Producto>();
}
```

### Middleware JWT

```csharp
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(o =>
    {
        o.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidateAudience = true,
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]!))
        };
    });

[Authorize]
[ApiController]
[Route("api/admin")]
public class AdminController : ControllerBase
{
    [HttpGet]
    public IActionResult Get() => Ok(new { mensaje = "Acceso autorizado" });
}
```

### Blazor component

```razor
@page "/contador"
<h1>Contador</h1>
<p>Has hecho clic @cuenta veces</p>
<button @onclick="Incrementar">+1</button>

@code {
    private int cuenta = 0;
    private void Incrementar() => cuenta++;
}
```

---

## Hoja de ruta

```
1. C# fundamentals (sintaxis, LINQ, async/await, POO)
2. .NET CLI (dotnet new, build, run)
3. Pipeline de middlewares, routing, DI, configuración
4. Controladores MVC, Minimal APIs, Razor Pages
5. Entity Framework Core (DbContext, migraciones, LINQ)
6. Autenticación (Identity, JWT, políticas de autorización)
7. Blazor (WebAssembly, Server, componentes, forms)
8. SignalR (WebSockets en tiempo real)
9. Testing (xUnit, Moq, WebApplicationFactory)
10. Producción (dotnet publish, Docker, Serilog, CI/CD)
```
