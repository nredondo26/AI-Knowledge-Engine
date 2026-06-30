# Coverage — Cobertura de Código

## Conceptos Fundamentales

La cobertura de código mide qué porcentaje del código fuente es ejecutado durante las pruebas. Es una métrica cuantitativa que ayuda a identificar código no probado, pero no mide la calidad de los tests ni la corrección del sistema.

### Tipos de Cobertura

| Tipo | Mide | Herramientas |
|------|------|-------------|
| **Línea** | Líneas de código ejecutadas | Coverage.py, Istanbul |
| **Rama (Branch)** | Toma de decisiones (if/else) | pytest-cov, JaCoCo |
| **Funció** | Funciones invocadas | gcov, kcov |
| **Ruta (Path)** | Combinaciones de ramas | Herramientas avanzadas |
| **Mutació** | Resistencia a cambios (mutantes) | mutmut, Stryker |

## Coverage.py + pytest

```bash
# Instalación
pip install pytest-cov

# Ejecutar con cobertura
pytest --cov=src tests/

# Reporte detallado con líneas no cubiertas
pytest --cov=src --cov-report=term-missing tests/

# Umbral mínimo de cobertura (falla si es menor)
pytest --cov=src --cov-fail-under=80 tests/

# Reporte HTML navegable
pytest --cov=src --cov-report=html tests/
```

### Configuración (.coveragerc)

```ini
[run]
source = src
omit =
    */migrations/*
    */tests/*
    *__init__.py
    *conftest.py
    manage.py

[report]
exclude_lines =
    pragma: no cover
    def __repr__
    raise NotImplementedError
    if __name__ == "__main__":
    if TYPE_CHECKING:

[html]
directory = reports/coverage_html
```

### Ejemplo de Salida

```
Name                  Stmts   Miss  Cover   Missing
---------------------------------------------------
src/pricing.py           45      5    89%   23-27, 89
src/users.py             78     12    85%   34-40, 101-105
src/orders.py            102     8    92%   15, 67, 200-204
src/payments.py          55      0   100%
---------------------------------------------------
TOTAL                   280     25    91%
```

## Cobertura por Ramas (Branch)

```bash
pytest --cov=src --cov-branch --cov-report=term-missing
```

```
Name                  Stmts   Miss Branch BrPart  Cover   Missing
---------------------------------------------------------------
src/pricing.py           45      5     12      3    87%   23-27
```

## Cobertura en JavaScript/TypeScript

```bash
# Vitest con c8
vitest --coverage

# config
{
  "test": {
    "coverage": {
      "provider": "v8",
      "reporter": ["text", "html", "lcov"],
      "thresholds": {
        "branches": 80,
        "functions": 85,
        "lines": 85,
        "statements": 85
      }
    }
  }
}
```

## Cobertura en CI

```yaml
# .github/workflows/test.yaml
name: Test with Coverage
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install -e ".[dev]"
      - run: pytest --cov=src --cov-report=xml --cov-fail-under=80
      - uses: codecov/codecov-action@v4
        with:
          file: ./coverage.xml
          fail_ci_if_error: true
```

## Badges de Cobertura

```markdown
[![codecov](https://codecov.io/gh/user/repo/branch/main/graph/badge.svg)](https://codecov.io/gh/user/repo)
```

## Best Practices

1. **Cobertura ≠ Calidad**: 100% no garantiza tests correctos.
2. **Umbral realista**: 80% es buen objetivo. Líneas no cubiertas deben justificarse (logging, error handlers).
3. **Branch > Line coverage**: Cobertura de ramas es más significativa.
4. **Excluir código trivial**: `__repr__`, `__str__`, `if __name__`, migrations.
5. **Tendencia, no absoluto**: Monitorear cambios de cobertura en el tiempo.
6. **Integrar en CI**: Fallar build si cobertura baja del umbral.
