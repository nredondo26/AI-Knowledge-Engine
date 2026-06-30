# Python

Lenguaje interpretado, multiparadigma, tipado dinámico y fuerte. Creado por Guido van Rossum (1991). Filosofía: legibilidad, baterías incluidas, explícito sobre implícito.

## Sintaxis básica

```python
# Hola mundo
print("Hola, mundo")

# Variables: tipado dinámico
nombre: str = "Ana"   # type hint (opcional en runtime)
edad = 30             # int inferido
altura = 1.75         # float
activo = True         # bool

# Estructuras de control
if edad >= 18:
    print("Mayor")
elif edad > 12:
    print("Adolescente")
else:
    print("Menor")

for i in range(5):
    print(i)

while activo:
    break

# Comprensión de listas
cuadrados = [x**2 for x in range(10) if x % 2 == 0]

# Funciones
def sumar(a: int, b: int) -> int:
    return a + b

# args/kwargs
def log(*args, **kwargs):
    print(args, kwargs)
```

## Tipado

Python es **dinámico** y **fuerte** (no coercionan implícitamente tipos incompatibles). PEP 484 introdujo type hints para verificación estática opcional con `mypy` / `pyright`.

```python
from typing import Optional, Union, List, Dict, Callable, TypeVar, Generic

# Tipado opcional
def buscar(id: int) -> Optional[str]:
    return "foo" if id > 0 else None

# Uniones y genéricos
def procesar(data: Union[str, List[int]]) -> None: ...

T = TypeVar('T')
class Caja(Generic[T]):
    def __init__(self, valor: T) -> None:
        self.valor = valor

# Protocolos (duck typing estructural)
from typing import Protocol
class Volable(Protocol):
    def volar(self) -> None: ...

class Aguila:
    def volar(self) -> None:
        print("Volando")

def lanzar(obj: Volable) -> None:
    obj.volar()
```

## POO / Funcional

```python
# POO: clases, herencia múltiple, mixins, dataclasses, propiedades
from dataclasses import dataclass

@dataclass
class Punto:
    x: float
    y: float

    def distancia(self, otro: "Punto") -> float:
        return ((self.x - otro.x)**2 + (self.y - otro.y)**2)**0.5

class Vehiculo:
    def __init__(self, marca: str):
        self._marca = marca  # convención protected

    @property
    def marca(self) -> str:
        return self._marca

    @marca.setter
    def marca(self, valor: str) -> None:
        if not valor:
            raise ValueError("Marca requerida")
        self._marca = valor

    def mover(self) -> str:
        return "Vehículo se mueve"

class Coche(Vehiculo):
    def mover(self) -> str:
        return f"{self.marca} acelera"

# Funcional: lambdas, map, filter, reduce, itertools, functools
from functools import reduce
nums = [1, 2, 3, 4]
doblados = list(map(lambda x: x * 2, nums))
pares = list(filter(lambda x: x % 2 == 0, nums))
suma = reduce(lambda a, b: a + b, nums)

# Decoradores
def timer(f):
    from functools import wraps
    @wraps(f)
    def wrapper(*args, **kwargs):
        import time
        start = time.perf_counter()
        res = f(*args, **kwargs)
        print(f"{f.__name__}: {time.perf_counter()-start:.3f}s")
        return res
    return wrapper

@timer
def fib(n: int) -> int:
    return n if n < 2 else fib(n-1) + fib(n-2)
```

## Concurrencia

```python
# threading (GIL limita CPU-bound)
import threading

def tarea(n):
    print(f"Hilo {n}")

hilos = [threading.Thread(target=tarea, args=(i,)) for i in range(4)]
for h in hilos: h.start()
for h in hilos: h.join()

# multiprocessing (CPU-bound, bypass GIL)
from multiprocessing import Process, Pool

def cpu_intensivo(x):
    return x ** x

with Pool(4) as pool:
    resultados = pool.map(cpu_intensivo, range(10))

# asyncio (I/O-bound, cooperativo)
import asyncio

async def fetch(url):
    print(f"Fetching {url}")
    await asyncio.sleep(1)  # simula I/O
    return f"Datos de {url}"

async def main():
    tasks = [fetch(f"https://api.example.com/{i}") for i in range(3)]
    return await asyncio.gather(*tasks)

resultados = asyncio.run(main())
```

## Ecosistema

- **PyPI** (~500k paquetes). `pip install paquete`
- **Entornos virtuales**: `venv`, `poetry`, `uv`
- **Gestores de paquetes**: `pip`, `poetry`, `pdm`, `uv`
- **Web**: Django (full-stack), FastAPI (async, moderno), Flask (minimalista)
- **Ciencia de datos**: NumPy, Pandas, Matplotlib, Scikit-learn, PyTorch, TensorFlow
- **Testing**: `pytest` (estándar), `unittest` (stdlib), `hypothesis`
- **Linting/Formato**: `ruff` (ultrarrápido), `black`, `flake8`, `mypy`
- **Empaquetado**: `setuptools`, `pyproject.toml` (PEP 517/518/621)

## Herramientas

```bash
# Instalación y entorno
python -m venv .venv && source .venv/bin/activate
pip install ruff pytest mypy

# Lint y formato
ruff check . && ruff format .
mypy src/

# Testing
pytest tests/ -v --cov=src --cov-report=term-missing

# Empaquetado (pyproject.toml)
# [project]
# name = "mipaquete"
# version = "0.1.0"
# requires-python = ">=3.11"
python -m build
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [Web](../../026-Web/README.md)
- [Ciencia de Datos](../../028-Data-Science/README.md)
