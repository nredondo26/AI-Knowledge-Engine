# Laravel

## Descripción

Laravel es el framework PHP más popular y completo, creado por Taylor Otwell en 2011. Su filosofía es "la elegancia y expresividad del código": proporciona una sintaxis limpia, herramientas modernas y un ecosistema rico (Eloquent ORM, Blade templating, Artisan CLI, Laravel Sail, Jetstream, etc.).

Laravel brinda todo lo necesario para construir aplicaciones web modernas: autenticación, colas, notificaciones, tareas programadas, broadcasting en tiempo real, y un sistema de paquetes vía Composer. Es la opción predilecta para startups, SaaS, e-commerce y aplicaciones corporativas en PHP.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Eloquent ORM** | ActiveRecord implementation para interactuar con la BD usando objetos PHP. |
| **Blade** | Motor de plantillas con herencia, secciones y directivas (@if, @foreach). |
| **Artisan** | CLI para generar código, migraciones, seeders, y tareas personalizadas. |
| **Migraciones** | Control de versiones del esquema de base de datos. |
| **Seeders / Factories** | Población de BD con datos de prueba. |
| **Routing** | Definición de rutas en `routes/web.php` y `routes/api.php`. |
| **Middleware** | Filtros que procesan peticiones HTTP (auth, CORS, rate limiting). |
| **Service Container** | Contenedor IoC para inyección de dependencias. |
| **Service Providers** | Punto de entrada para registrar servicios en el contenedor. |
| **Events / Listeners** | Patrón observer para desacoplar lógica de negocio. |
| **Queues / Jobs** | Procesamiento asíncrono con Redis, SQS, o base de datos. |
| **Laravel Sanctum** | Autenticación ligera para SPA y APIs. |
| **Laravel Filament** | Panel admin moderno y rápido (tercero pero muy usado). |

---

## Ejemplos de código

### Rutas, controlador y modelo

```php
// routes/api.php
use App\Http\Controllers\ProductoController;
use App\Models\Producto;

Route::apiResource('productos', ProductoController::class);

Route::get('productos/{producto}/precio', function (Producto $producto) {
    return response()->json([
        'nombre' => $producto->nombre,
        'precio' => $producto->precio,
    ]);
});
```

```php
// app/Models/Producto.php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Producto extends Model
{
    use HasFactory;

    protected $fillable = ['nombre', 'precio', 'categoria_id', 'stock'];

    protected $casts = [
        'precio' => 'decimal:2',
        'stock' => 'integer',
    ];

    public function categoria(): BelongsTo
    {
        return $this->belongsTo(Categoria::class);
    }

    public function scopeEnStock($query, $minimo = 1)
    {
        return $query->where('stock', '>=', $minimo);
    }
}
```

### Controlador con validación

```php
namespace App\Http\Controllers;

use App\Models\Producto;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ProductoController extends Controller
{
    public function index(): JsonResponse
    {
        $productos = Producto::with('categoria')
            ->enStock()
            ->latest()
            ->paginate(15);

        return response()->json($productos);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'nombre' => 'required|string|max:200|unique:productos',
            'precio' => 'required|numeric|min:0.01',
            'categoria_id' => 'required|exists:categorias,id',
            'stock' => 'integer|min:0',
        ]);

        $producto = Producto::create($validated);

        return response()->json($producto->load('categoria'), 201);
    }

    public function show(Producto $producto): JsonResponse
    {
        return response()->json($producto->load('categoria'));
    }

    public function update(Request $request, Producto $producto): JsonResponse
    {
        $validated = $request->validate([
            'nombre' => "string|max:200|unique:productos,nombre,{$producto->id}",
            'precio' => 'numeric|min:0.01',
            'categoria_id' => 'exists:categorias,id',
            'stock' => 'integer|min:0',
        ]);

        $producto->update($validated);

        return response()->json($producto->load('categoria'));
    }

    public function destroy(Producto $producto): JsonResponse
    {
        $producto->delete();
        return response()->json(null, 204);
    }
}
```

### Migraciones y seeder

```php
// database/migrations/xxxx_create_productos_table.php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('productos', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 200)->unique();
            $table->decimal('precio', 10, 2);
            $table->foreignId('categoria_id')->constrained();
            $table->integer('stock')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('productos');
    }
};
```

```php
// database/seeders/ProductoSeeder.php
namespace Database\Seeders;

use App\Models\Producto;
use Illuminate\Database\Seeder;

class ProductoSeeder extends Seeder
{
    public function run(): void
    {
        Producto::factory(50)->create();
    }
}
```

### Tarea programada (Job + Queue)

```php
namespace App\Jobs;

use App\Models\Producto;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;

class ActualizarPrecios implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue;

    public function handle(): void
    {
        Producto::chunk(100, function ($productos) {
            foreach ($productos as $producto) {
                // Lógica de actualización
            }
        });
    }
}
```

```php
// app/Console/Kernel.php
protected function schedule(Schedule $schedule): void
{
    $schedule->job(new ActualizarPrecios)->dailyAt('02:00');
}
```

### Blade template con componentes

```blade
{{-- resources/views/productos/index.blade.php --}}
<x-app-layout>
    <x-slot:header>
        <h2 class="text-xl font-semibold">Productos</h2>
    </x-slot>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        @foreach ($productos as $producto)
            <x-producto-card :producto="$producto" />
        @endforeach
    </div>

    {{ $productos->links() }}
</x-app-layout>
```

---

## Hoja de ruta

```
1. PHP moderno
   ├── Tipos declarados, named arguments, match expression
   ├── Composer y autoloading (PSR-4)
   └── Programación orientada a objetos

2. Fundamentos de Laravel
   ├── Instalación con Laravel Herd / Sail / Valet
   ├── Estructura de directorios
   ├── Artisan CLI (make, migrate, tinker)
   └── Configuración (.env, config/)

3. Routing, Middleware y Controladores
   ├── Rutas web y API
   ├── Route model binding
   ├── Middleware personalizado
   └── Request / Response

4. Eloquent ORM
   ├── Modelos, relaciones (belongsTo, hasMany, morphMany)
   ├── Scopes locales y globales
   ├── Accessors, mutators, casts
   ├── Eager loading (with, load)
   └── Consultas avanzadas (whereHas, withCount)

5. Migraciones, Seeders y Factories
   ├── Migraciones (up/down, esquemas)
   ├── Seeders y Factory para datos de prueba
   └── Tinker para depuración

6. Blade y componentes
   ├── Layouts, sections, includes
   ├── Componentes anónimos y con clase
   ├── Directivas (@auth, @pusher, @stack)
   └── Alpine.js + Livewire para interactividad

7. Autenticación y autorización
   ├── Laravel Breeze / Jetstream (starter kits)
   ├── Policies y Gates
   ├── Laravel Sanctum (API tokens, SPA)
   └── Laravel Passport (OAuth2)

8. Colas, tareas y notificaciones
   ├── Jobs y Queues (Redis, SQS, BD)
   ├── Notificaciones (mail, Slack, SMS)
   ├── Tareas programadas (schedule)
   └── Broadcasting con WebSockets (Laravel Reverb / Pusher)

9. Testing
   ├── PHPUnit / Pest
   ├── HTTP tests (get, post, assertJson)
   ├── Base de datos en memoria (SQLite)
   └── Mocking y fakes (Queue::fake, Mail::fake)

10. Producción y ecosistema
    ├── Optimización (config:cache, route:cache)
    ├── Laravel Octane (alto rendimiento)
    ├── Filament Admin / Nova
    ├── Docker con Laravel Sail
    └── Despliegue (Forge, Vapor, Envoyer)
```
