# Chef — Automatización de Configuración

## Conceptos Fundamentales

Chef es una herramienta de gestión de configuración basada en Ruby que utiliza un modelo declarativo con recetas (recipes) y cookbooks. Opera con arquitectura cliente-servidor (Chef Server + Chef Client) o standalone (Chef Solo, Chef Zero).

### Componentes

- **Chef Server**: Almacena cookbooks, políticas y datos de nodos.
- **Chef Client**: Agente que ejecuta recetas en los nodos.
- **Cookbook**: Unidad reutilizable que contiene recetas, templates, archivos y atributos.
- **Recipe**: Archivo Ruby con declaraciones de recursos.
- **Role**: Define comportamiento común para un grupo de nodos.
- **Data Bag**: Datos JSON cifrados o planos compartidos entre cookbooks.

## Cookbook y Receta

```
cookbooks/
  nginx/
    recipes/default.rb
    templates/default/nginx.conf.erb
    files/default/index.html
    attributes/default.rb
    metadata.rb
    spec/unit/recipes/default_spec.rb
```

### Receta básica

```ruby
# cookbooks/nginx/recipes/default.rb
package 'nginx' do
  action :install
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]'
end

service 'nginx' do
  action [:enable, :start]
  supports restart: true, reload: true, status: true
end
```

### Atributos

```ruby
# cookbooks/nginx/attributes/default.rb
default['nginx']['port'] = 80
default['nginx']['worker_processes'] = 'auto'
default['nginx']['server_name'] = 'localhost'

# cookbooks/nginx/attributes/production.rb
override['nginx']['worker_processes'] = 4
```

### Template ERB

```ruby
# templates/default/nginx.conf.erb
worker_processes <%= @node['nginx']['worker_processes'] %>;

events {
  worker_connections 1024;
}

http {
  server {
    listen <%= @node['nginx']['port'] %>;
    server_name <%= @node['nginx']['server_name'] %>;
  }
}
```

## Chef Solo (Standalone)

```ruby
# solo.rb
cookbook_path ['/var/chef/cookbooks']
node_name 'web-server-01'

# solo.json (run list)
{
  "run_list": ["recipe[nginx]", "recipe[app::deploy]"],
  "nginx": {
    "port": 8080,
    "server_name": "app.example.com"
  }
}
```

```bash
chef-solo -c solo.rb -j solo.json
```

## Data Bags

```ruby
# Acceder a data bag cifrada
db = data_bag_item('credentials', 'production')
template '/etc/app/database.yml' do
  variables(host: db['host'], port: db['port'], password: db['password'])
end
```

## Roles

```ruby
# roles/web_server.rb
name 'web_server'
description 'Web server with nginx and Node.js'
run_list [
  'recipe[nginx]',
  'recipe[nodejs]',
  'recipe[app::deploy]',
]
default_attributes(
  nginx: { port: 80 },
)
override_attributes(
  app: { version: '2.1.0' },
)
```

## Best Practices

1. **Idempotencia**: Ejecutar N veces sin efectos secundarios. Usar `not_if`/`only_if`.
2. **Atributos bien definidos**: `default`, `normal`, `override` con criterio.
3. **Testing**: ChefSpec (unit), Test Kitchen (integration), InSpec (compliance).
4. **Data Bags para secretos**: No hardcodear credenciales en recetas.
5. **Cookbooks pequeños**: Un cookbook = un componente.
6. **Roles antes que nodos**: Comportamiento por rol, no por nodo individual.
