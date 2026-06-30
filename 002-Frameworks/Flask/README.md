# Flask

## Descripción

Flask es un micro-framework web para Python, creado por Armin Ronacher en 2010. Su diseño minimalista proporciona lo esencial (ruteo, peticiones/respuestas, plantillas Jinja2) sin imponer estructura. A diferencia de Django, no incluye ORM, autenticación o admin por defecto. Es ideal para APIs REST, microservicios y prototipos rápidos.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **WSGI** | Protocolo estándar Python. Flask usa Werkzeug. |
| **Ruteo** | `@app.route()` asocia URL a función vista. |
| **Jinja2** | Motor de plantillas con herencia, filtros y bucles. |
| **Blueprints** | Módulos que organizan rutas en componentes reutilizables. |
| **Extensiones** | Flask-SQLAlchemy, Flask-Migrate, Flask-Login. |

---

## Ejemplos de código

### App mínima

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def hola():
    return jsonify({'mensaje': 'Hola Mundo'})

@app.route('/saludo/<nombre>')
def saludo(nombre):
    return jsonify({'mensaje': f'Hola {nombre}'})
```

### API REST CRUD

```python
from flask import Flask, request, jsonify

app = Flask(__name__)
tareas, next_id = [], 1

@app.route('/api/tareas', methods=['GET'])
def listar():
    return jsonify(tareas)

@app.route('/api/tareas', methods=['POST'])
def crear():
    global next_id
    data = request.get_json()
    tarea = {'id': next_id, 'texto': data['texto'], 'completada': False}
    tareas.append(tarea)
    next_id += 1
    return jsonify(tarea), 201

@app.route('/api/tareas/<int:tid>', methods=['DELETE'])
def eliminar(tid):
    global tareas
    tareas = [t for t in tareas if t['id'] != tid]
    return '', 204
```

### Blueprint y SQLAlchemy

```python
# auth/routes.py
from flask import Blueprint
auth_bp = Blueprint('auth', __name__, url_prefix='/auth')

@auth_bp.route('/login', methods=['POST'])
def login():
    return {'mensaje': 'Login exitoso'}

# app.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from auth.routes import auth_bp

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'
db = SQLAlchemy(app)
app.register_blueprint(auth_bp)
```

---

## Hoja de ruta

```
1. Python intermedio (decoradores, POO, entornos virtuales)
2. Ruteo básico, request/response, jsonify
3. Plantillas Jinja2 (herencia, bucles, filtros)
4. SQLAlchemy + Migrate (modelos, consultas)
5. Blueprints y fábrica de apps
6. Autenticación (Flask-Login, JWT)
7. APIs REST avanzadas (Flask-RESTx, paginación)
8. Testing (pytest + test_client)
9. Producción (Gunicorn + Nginx, Docker)
```
