# Ruby on Rails

## Descripción

Ruby on Rails es un framework web full-stack creado por David Heinemeier Hansson en 2004, construido sobre Ruby. Sigue los principios de **Convención sobre Configuración** (CoC) y **DRY**, permitiendo desarrollar rápidamente con menos código. Incluye ORM (Active Record), plantillas (ERB), enrutador RESTful, migraciones, scaffolding, Action Cable (WebSockets), Active Job (tareas en segundo plano) y Action Mailer.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **MVC** | Separación en modelo, vista y controlador. |
| **Active Record** | ORM que mapea tablas a clases Ruby con validaciones y asociaciones. |
| **Migraciones** | Versionado del esquema de BD en Ruby. |
| **RESTful Routing** | `resources :articulos` genera 7 rutas CRUD. |
| **Scaffolding** | Generación automática de modelo, vista, controlador y migraciones. |
| **Gems** | Librerías empaquetadas (Devise, RSpec, Pundit). |

---

## Ejemplos de código

### Scaffolding

```bash
rails generate scaffold Articulo titulo:string cuerpo:text publicado:boolean
rails db:migrate
```

### Modelo

```ruby
# app/models/articulo.rb
class Articulo < ApplicationRecord
  belongs_to :usuario
  has_many :comentarios, dependent: :destroy

  validates :titulo, presence: true, length: { minimum: 5 }
  validates :cuerpo, presence: true

  scope :publicados, -> { where(publicado: true) }
  scope :recientes,  -> { order(created_at: :desc) }

  def resumen
    cuerpo.truncate(100)
  end
end
```

### Controlador

```ruby
# app/controllers/articulos_controller.rb
class ArticulosController < ApplicationController
  before_action :set_articulo, only: [:show, :edit, :update, :destroy]

  def index
    @articulos = Articulo.publicados.recientes
  end

  def create
    @articulo = Articulo.new(articulo_params)
    if @articulo.save
      redirect_to @articulo, notice: 'Creado con éxito.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_articulo
    @articulo = Articulo.find(params[:id])
  end

  def articulo_params
    params.require(:articulo).permit(:titulo, :cuerpo, :publicado)
  end
end
```

### Vistas ERB

```erb
<!-- index.html.erb -->
<h1>Artículos</h1>
<% @articulos.each do |articulo| %>
  <article>
    <h2><%= link_to articulo.titulo, articulo %></h2>
    <p><%= articulo.resumen %></p>
    <small><%= articulo.created_at.strftime('%d/%m/%Y') %></small>
  </article>
<% end %>
<%= link_to 'Nuevo', new_articulo_path %>
```

### Rutas

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :articulos do
    resources :comentarios, only: [:create, :destroy]
  end
  root 'articulos#index'
end
```

---

## Hoja de ruta

```
1. Ruby (sintaxis, POO, bloques, módulos)
2. MVC, routing RESTful, generadores, migraciones
3. Active Record (asociaciones, validaciones, scopes, consultas)
4. Vistas (ERB, partials, layouts, helpers)
5. Controladores (filtros, strong params, sesiones, flash)
6. Autenticación (Devise) y autorización (Pundit)
7. APIs (modo API, serializers, versionado)
8. Tareas en segundo plano (Sidekiq, Action Mailer)
9. Testing (RSpec, Factory Bot, Capybara)
10. Producción (Puma + Nginx, Docker, CI/CD)
```
