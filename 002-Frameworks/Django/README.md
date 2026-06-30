# Django

## Descripción

Django es un framework web de alto nivel escrito en Python que sigue el patrón **MTV (Model-Template-View)**. Creado en 2005 por Adrian Holovaty y Simon Willison, Django prioriza la velocidad de desarrollo, la seguridad y la escalabilidad. Su filosofía "batteries-included" proporciona un ORM, sistema de autenticación, panel admin, serialización, migraciones de base de datos y más.

Django es ideal para aplicaciones que requieren un backend robusto: CMS, plataformas SaaS, APIs REST, sitios de contenido y aplicaciones con alta demanda de seguridad.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Modelos (Models)** | Definición de la estructura de datos; cada clase es una tabla en la BD. |
| **Vistas (Views)** | Lógica que procesa peticiones y retorna respuestas (HTTP o templates). |
| **Plantillas (Templates)** | Archivos HTML con sintaxis Django para renderizar datos dinámicos. |
| **URLs (URLconf)** | Mapeo de patrones de URL a vistas. |
| **ORM (Object-Relational Mapping)** | Capa de abstracción que permite operar la BD con Python en vez de SQL. |
| **Migraciones** | Sistema de versionado de esquemas de base de datos. |
| **Admin (django.contrib.admin)** | Interfaz administrativa generada automáticamente. |
| **Middleware** | Componentes que procesan peticiones/respuestas de forma global (auth, sesión, CSRF). |
| **DRF (Django REST Framework)** | Librería oficial para construir APIs RESTful. |
| **Señales (Signals)** | Permiten que ciertos eventos disparen callbacks (ej: post_save). |
| **Context Processors** | Funciones que inyectan variables en todas las plantillas. |

---

## Ejemplos de código

### Modelo y migraciones

```python
from django.db import models

class Categoria(models.Model):
    nombre = models.CharField(max_length=100)

    def __str__(self):
        return self.nombre

class Producto(models.Model):
    nombre = models.CharField(max_length=200)
    precio = models.DecimalField(max_digits=10, decimal_places=2)
    categoria = models.ForeignKey(Categoria, on_delete=models.CASCADE, related_name='productos')
    creado = models.DateTimeField(auto_now_add=True)
    stock = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ['-creado']

    def __str__(self):
        return self.nombre
```

```bash
python manage.py makemigrations
python manage.py migrate
```

### Vista basada en función y template

```python
# views.py
from django.shortcuts import render
from .models import Producto

def lista_productos(request):
    productos = Producto.objects.select_related('categoria').all()
    return render(request, 'productos/lista.html', {'productos': productos})
```

```html
<!-- templates/productos/lista.html -->
{% extends 'base.html' %}
{% block content %}
  <h1>Productos</h1>
  <ul>
    {% for producto in productos %}
      <li>
        {{ producto.nombre }} - ${{ producto.precio }}
        ({{ producto.categoria.nombre }})
      </li>
    {% empty %}
      <li>No hay productos disponibles.</li>
    {% endfor %}
  </ul>
{% endblock %}
```

### API con Django REST Framework

```python
# serializers.py
from rest_framework import serializers
from .models import Producto, Categoria

class CategoriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = ['id', 'nombre']

class ProductoSerializer(serializers.ModelSerializer):
    categoria = CategoriaSerializer(read_only=True)
    categoria_id = serializers.PrimaryKeyRelatedField(
        queryset=Categoria.objects.all(), source='categoria', write_only=True
    )

    class Meta:
        model = Producto
        fields = ['id', 'nombre', 'precio', 'categoria', 'categoria_id']
```

```python
# views.py (DRF)
from rest_framework import generics
from .models import Producto
from .serializers import ProductoSerializer

class ProductoListCreate(generics.ListCreateAPIView):
    queryset = Producto.objects.select_related('categoria').all()
    serializer_class = ProductoSerializer

class ProductoDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Producto.objects.all()
    serializer_class = ProductoSerializer
```

```python
# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('api/productos/', views.ProductoListCreate.as_view()),
    path('api/productos/<int:pk>/', views.ProductoDetail.as_view()),
]
```

### Autenticación y señales

```python
# signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.models import User

@receiver(post_save, sender=User)
def crear_perfil_usuario(sender, instance, created, **kwargs):
    if created:
        # Crear perfil automáticamente al registrar un usuario
        Perfil.objects.create(usuario=instance)
```

### Formulario con validación

```python
# forms.py
from django import forms
from .models import Producto

class ProductoForm(forms.ModelForm):
    class Meta:
        model = Producto
        fields = ['nombre', 'precio', 'categoria', 'stock']

    def clean_precio(self):
        precio = self.cleaned_data['precio']
        if precio <= 0:
            raise forms.ValidationError('El precio debe ser positivo.')
        return precio
```

---

## Hoja de ruta

```
1. Python intermedio
   ├── Tipado, comprehensions, decoradores
   ├── Entornos virtuales (venv, uv)
   └── Programación orientada a objetos

2. Fundamentos de Django
   ├── Proyecto vs aplicación (startproject / startapp)
   ├── Modelos y migraciones (makemigrations, migrate)
   ├── Admin personalizado (ModelAdmin, actions)
   ├── Vistas basadas en función y plantillas
   └── URLconf (include, path, re_path)

3. ORM avanzado
   ├── Consultas (filter, exclude, annotate, aggregate, Q)
   ├── Select_related / Prefetch_related (optimización N+1)
   ├── Transacciones (transaction.atomic)
   └── Señales y managers personalizados

4. Formularios y procesamiento
   ├── Form y ModelForm
   ├── Validación, widgets, class-based views (CreateView, UpdateView)
   └── CSRF, mensajes flash

5. Authentication y autorización
   ├── User model, login/logout, permisos
   ├── Grupos y permissions
   └── Middleware de autenticación

6. Django REST Framework
   ├── Serializadores (ModelSerializer, validación anidada)
   ├── Viewsets y routers
   ├── Permisos y autenticación (Token, JWT)
   ├── Paginación, filtros y búsqueda
   ├── Throttling y versionado
   └── Documentación con drf-spectacular (OpenAPI)

7. Testing
   ├── TestCase, Client, APITestCase
   ├── Factory Boy para fixtures
   └── Cobertura con pytest-django

8. Optimización y producción
   ├── Caching (Redis, Memcached)
   ├── Celery + RabbitMQ / Redis para tareas asíncronas
   ├── Archivos estáticos y media (S3 / CloudFront)
   ├── Gunicorn + Nginx
   └── Docker y CI/CD

9. Ecosistema extendido
   ├── django-allauth (autenticación social)
   ├── django-cors-headers
   ├── django-debug-toolbar
   └── django-filter
```
