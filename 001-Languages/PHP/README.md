# PHP

Lenguaje interpretado, multiparadigma, tipado dinámico progresivo. Creado por Rasmus Lerdorf (1994). Runtime: Zend Engine (PHP 8.x con JIT). Filosofía: pragmatismo, facilidad de despliegue, batteries-included para web.

## Sintaxis básica

```php
<?php

declare(strict_types=1);

echo "Hola, mundo\n";

$nombre = "Ana";
$edad = 30;
$nulo = null;

if ($edad >= 18) {
    echo "Mayor\n";
} elseif ($edad > 12) {
    echo "Adolescente\n";
} else {
    echo "Menor\n";
}

for ($i = 0; $i < 5; $i++) echo $i;
foreach ([1, 2, 3] as $x) echo $x;

// match (PHP 8.0)
$resultado = match (true) {
    $edad >= 18 => "Adulto",
    $edad > 12  => "Adolescente",
    default     => "Menor",
};

// Arrow functions (PHP 7.4)
$cuadrado = fn($x) => $x * $x;

function sumar(int $a, int $b): int {
    return $a + $b;
}

// Named arguments (PHP 8.0)
function crearUsuario(string $nombre, int $edad): array {
    return compact('nombre', 'edad');
}
crearUsuario(edad: 30, nombre: "Ana");
```

## Tipado

Evolucionó de dinámico débil a progresivo con tipos declarables. Union types (PHP 8.0), mixed, match, enums (PHP 8.1).

```php
// Union types
function procesar(int|string $data): void {
    if (is_int($data)) echo "Entero: $data";
    else echo "String: $data";
}

// Enums (PHP 8.1)
enum Status: string {
    case Activo = 'activo';
    case Inactivo = 'inactivo';
}

// Readonly properties (PHP 8.1)
class Config {
    public function __construct(
        public readonly string $dbHost
    ) {}
}

// Atributos (PHP 8.0)
#[Attribute(Attribute::TARGET_METHOD)]
class Route {
    public function __construct(
        public string $path,
        public string $method = 'GET'
    ) {}
}
```

## POO / Funcional

```php
abstract class Vehiculo {
    public function __construct(
        protected string $marca
    ) {}
    public function mover(): string {
        return "Vehículo se mueve";
    }
}

class Coche extends Vehiculo {
    public function mover(): string {
        return "{$this->marca} acelera";
    }
}

// Traits
trait Loggable {
    public function log(string $msg): void {
        echo "[$msg]\n";
    }
}

// Funcional
$nums = [1, 2, 3, 4];
$dobrados = array_map(fn($x) => $x * 2, $nums);
$pares = array_filter($nums, fn($x) => $x % 2 === 0);
$suma = array_reduce($nums, fn($a, $x) => $a + $x, 0);
```

## Ecosistema

- **Composer** — gestor de dependencias (~350k+ paquetes en Packagist)
- **Frameworks**: Laravel (full-stack), Symfony (componentes), Slim (micro)
- **Testing**: PHPUnit, Pest
- **Análisis estático**: PHPStan (nivel 9), Psalm, Rector (refactoring)
- **ORM**: Doctrine, Eloquent
- **Estándares**: PSR-4 (autoloading), PSR-7 (HTTP messages)
- **Async**: ReactPHP, Amp, Fibers (PHP 8.1)

## Herramientas

```bash
composer init && composer require laravel/framework
composer create-project laravel/laravel mi-app
vendor/bin/phpunit tests/
vendor/bin/phpstan analyse src/ --level=max
vendor/bin/rector process src/ --set php80
vendor/bin/php-cs-fixer fix src/ --rules=@PSR12
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [Web](../../026-Web/README.md)
- [Bases de Datos](../../003-Databases/README.md)
```