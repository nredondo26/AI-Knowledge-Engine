# C++

Lenguaje compilado, multiparadigma, tipado estático y débil. Creado por Bjarne Stroustrup (1985). Estandarizado ISO (C++98/11/14/17/20/23). Compiladores: GCC, Clang, MSVC. Filosofía: zero-cost abstractions, RAII, representación directa del hardware.

## Sintaxis básica

```cpp
#include <iostream>
#include <vector>
#include <memory>

auto main() -> int {
    std::cout << "Hola, mundo" << std::endl;
    return 0;
}

int edad = 30;
constexpr double PI = 3.1416;
auto nombre = "Ana"s;

if (edad >= 18) {
    std::cout << "Mayor\n";
} else if (edad > 12) {
    std::cout << "Adolescente\n";
} else {
    std::cout << "Menor\n";
}

for (int i = 0; i < 5; ++i) std::cout << i;
for (auto&& x : {1, 2, 3}) std::cout << x;

auto sumar = [](int a, int b) { return a + b; };
```

## Tipado

Estático y débil (conversiones implícitas). Inferencia con `auto`/`decltype`. Templates con SFINAE/Concepts (C++20).

```cpp
#include <concepts>

template <std::integral T>
auto doblar(T v) { return v * 2; }

// Concepts (C++20)
template <typename T> requires std::is_arithmetic_v<T>
auto cuadrado(T x) { return x * x; }

// std::optional (C++17)
std::optional<int> dividir(int a, int b) {
    if (b == 0) return std::nullopt;
    return a / b;
}

// explicit casts
int a = static_cast<int>(3.14);
```

## POO / RAII

```cpp
class Vehiculo {
protected:
    std::string marca_;
public:
    explicit Vehiculo(std::string m) : marca_(std::move(m)) {}
    virtual ~Vehiculo() = default;
    virtual auto mover() const -> std::string { return "Vehículo se mueve"; }
    Vehiculo(const Vehiculo&) = delete;
};

class Coche final : public Vehiculo {
    using Vehiculo::Vehiculo;
    auto mover() const -> std::string override { return marca_ + " acelera"; }
};

// Smart pointers (RAII)
auto crear() -> std::unique_ptr<Vehiculo> {
    return std::make_unique<Coche>("Toyota");
}

// STL funcional
#include <algorithm>
#include <ranges>
#include <numeric>
std::vector<int> nums = {1, 2, 3, 4, 5};
auto pares = nums | std::views::filter([](int x) { return x % 2 == 0; });
auto suma = std::accumulate(nums.begin(), nums.end(), 0);
```

## Concurrencia

```cpp
#include <thread>
#include <future>
#include <atomic>

std::jthread hilo([](int id) { /*...*/ }, 1);

auto tarea = [](int x) -> int {
    std::this_thread::sleep_for(std::chrono::seconds(1));
    return x * x;
};

std::future<int> res = std::async(std::launch::async, tarea, 42);
int valor = res.get();

std::atomic<int> contador = 0;
std::mutex mtx;
std::lock_guard lock(mtx);
```

## Ecosistema

- **Compiladores**: GCC, Clang, MSVC, ICC
- **Build**: CMake (estándar), Meson, Bazel, Ninja
- **Paquetes**: vcpkg, Conan, Hunter
- **Librerías**: STL, Boost, fmt, spdlog, nlohmann/json, Catch2
- **Análisis**: Clang-Tidy, Clang Static Analyzer, Cppcheck, ASan/UBSan/TSan

## Herramientas

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build -j$(nproc)
clang-tidy src/*.cpp -- -std=c++20
clang-format -i src/*.cpp --style=llvm
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [Sistemas Operativos](../../004-OperatingSystems/README.md)
- [Rendimiento](../../022-Performance/README.md)
```