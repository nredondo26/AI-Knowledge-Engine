# Design Patterns — Patrones de Diseño (GoF)

## ¿Qué son los Patrones de Diseño?

Soluciones reutilizables para problemas comunes en desarrollo de software. El catálogo clásico (GoF, 1994) incluye 23 patrones creados por Erich Gamma, Richard Helm, Ralph Johnson y John Vlissides.

## Clasificación

### Creacionales (5)

| Patrón | Propósito |
|--------|-----------|
| **Singleton** | Única instancia de una clase |
| **Factory Method** | Creación delegada a subclases |
| **Abstract Factory** | Familias de objetos relacionados |
| **Builder** | Construcción por pasos |
| **Prototype** | Clonación de prototipos |

### Estructurales (7)

| Patrón | Propósito |
|--------|-----------|
| **Adapter** | Compatibiliza interfaces incompatibles |
| **Bridge** | Desacopla abstracción de implementación |
| **Composite** | Jerarquías parte-todo en árbol |
| **Decorator** | Añade responsabilidades dinámicamente |
| **Facade** | Interfaz unificada para subsistema |
| **Flyweight** | Compartición de objetos masivos |
| **Proxy** | Control de acceso a un objeto |

### De Comportamiento (11)

| Patrón | Propósito |
|--------|-----------|
| **Chain of Responsibility** | Cadena de manejadores |
| **Command** | Petición como objeto |
| **Interpreter** | Gramática de un lenguaje |
| **Iterator** | Acceso secuencial a colecciones |
| **Mediator** | Centraliza comunicación |
| **Memento** | Captura y restaura estado |
| **Observer** | Dependencia uno-a-muchos |
| **State** | Comportamiento según estado |
| **Strategy** | Algoritmos intercambiables |
| **Template Method** | Esqueleto de algoritmo |
| **Visitor** | Operación sobre elementos de estructura |

## Ejemplos Clave

### Singleton

```python
class DatabaseConnection:
    _instance = None
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
```

### Factory Method

```python
class LoggerFactory:
    def create_logger(self, type: str):
        if type == "console": return ConsoleLogger()
        if type == "file": return FileLogger()
```

### Observer

```python
class Observable:
    def __init__(self):
        self._observers = []
    def attach(self, observer):
        self._observers.append(observer)
    def notify(self, data):
        for obs in self._observers:
            obs.update(data)
```

### Strategy

```python
class ShoppingCart:
    def __init__(self, strategy):
        self._strategy = strategy
    def checkout(self, total):
        self._strategy.pay(total)
```

### Decorator

```python
from functools import wraps
import time

def measure_time(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        print(f"{func.__name__}: {time.time()-start:.2f}s")
        return result
    return wrapper
```

## Principios SOLID

1. **S**ingle Responsibility: Una clase, una razón de cambio
2. **O**pen/Closed: Abierto a extensión, cerrado a modificación
3. **L**iskov Substitution: Subtipos sustituibles
4. **I**nterface Segregation: Interfaces específicas
5. **D**ependency Inversion: Depender de abstracciones

## Anti-patrones Comunes

| Anti-patrón | Problema | Solución |
|-------------|----------|----------|
| God Class | Clase que hace demasiado | SRP + extraer |
| Spaghetti Code | Código sin estructura | Aplicar patrones |
| Golden Hammer | Usar siempre mismo patrón | Evaluar contexto |
| Copy-Paste | Duplicación | Extraer métodos |

## Cuándo Usar Cada Patrón

| Problema | Patrón |
|----------|--------|
| Un único punto de acceso | Singleton |
| Añadir funcionalidad dinámicamente | Decorator |
| Simplificar subsistema | Facade |
| Desacoplar emisor/receptor | Observer |
| Algoritmos intercambiables | Strategy |
| Compatibilizar interfaces | Adapter |
| Historial de operaciones | Command + Memento |

## Recursos

- *Design Patterns* — GoF (libro original)
- *Head First Design Patterns* — Freeman & Robson
- [Refactoring Guru](https://refactoring.guru/es/design-patterns)
- [SourceMaking](https://sourcemaking.com/design_patterns)
