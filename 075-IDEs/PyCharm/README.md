# PyCharm — IDE para Desarrollo Python

## ¿Qué es PyCharm?

IDE para Python creado por JetBrains. Ofrece edición inteligente, depuración visual, integración con VCS y soporte para desarrollo web, científico y de datos. Ediciones: Professional y Community.

## Ediciones

| Característica | Community | Professional |
|----------------|-----------|-------------|
| Editor Python inteligente | ✅ | ✅ |
| Depurador visual | ✅ | ✅ |
| VCS integrado | ✅ | ✅ |
| Django, Flask | ❌ | ✅ |
| SQL y bases de datos | ❌ | ✅ |
| Jupyter Notebooks | ❌ | ✅ |
| Profiler | ❌ | ✅ |
| Docker | ❌ | ✅ |

## Atajos Esenciales

| Atajo | Acción |
|-------|--------|
| `Ctrl + N` | Buscar archivo |
| `Ctrl + B` | Ir a declaración |
| `Ctrl + Alt + L` | Formatear (PEP 8) |
| `Ctrl + D` | Duplicar línea |
| `Ctrl + Y` | Eliminar línea |
| `Ctrl + /` | Comentar/Descomentar |
| `Shift + F6` | Renombrar |
| `Ctrl + Alt + M` | Extraer método |
| `Shift + F9` | Depurar |
| `Ctrl + Shift + F10` | Ejecutar |

## Configuración del Intérprete

```text
File → Settings → Project → Python Interpreter
```

Opciones: Virtualenv (recomendado), Conda, Pipenv, Poetry, WSL, Docker.

## Soporte para Frameworks

- **Django**: Detección automática, manage.py tasks, runserver
- **Flask**: `FLASK_APP=app.py FLASK_ENV=development`
- **FastAPI**: Uvicorn como servidor ASGI
- **SQLAlchemy**: Navegación modelo → tabla, autocompletado

## Ciencia de Datos

- **Jupyter Notebook**: Edición y ejecución interactiva (Professional)
- **Scientific Mode**: Variables, plots y consola separados
- **DataFrame Viewer**: Visualización de pandas
- **Matplotlib/Seaborn**: Gráficos interactivos

## Testing Integrado

Soporte nativo para unittest, pytest y nose. Ejecución con cobertura: `Run → Run with Coverage`.

## Plugins Recomendados

- **Pylint**: Análisis estático
- **BlackConnect**: Formateo con Black
- **Ruff**: Linter rápido
- **GitToolBox**: Información Git
- **Key Promoter X**: Aprender atajos

## Buenas Prácticas

1. Usar entornos virtuales por proyecto (`.venv` en `.gitignore`)
2. Configurar Black como File Watcher
3. Activar linting en tiempo real
4. Usar Run Configurations para diferentes perfiles
5. Aprovechar Local History como respaldo

## Recursos

- [Documentación oficial](https://www.jetbrains.com/help/pycharm/)
- [PyCharm Guide](https://www.jetbrains.com/pycharm/guide/)
