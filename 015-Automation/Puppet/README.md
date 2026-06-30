# Puppet — Automatización de Configuración

## Conceptos Fundamentales

Puppet es una herramienta de gestión de configuración declarativa que utiliza su propio lenguaje DSL basado en Ruby. Opera con arquitectura maestro-agente (o sin maestro con Puppet Bolt) y está diseñada para gestionar infraestructura a gran escala.

### Modelo Declarativo

Puppet describe el **estado deseado** de los recursos. El agente compara el estado actual con el deseado y aplica los cambios necesarios.

### Componentes

- **Puppet Master**: Servidor central que almacena configuraciones y compila catálogos.
- **Puppet Agent**: Cliente que ejecuta configuraciones en los nodos.
- **Modules**: Paquetes reutilizables de código (classes, defined types, templates, files).
- **Hiera**: Sistema de búsqueda de datos jerárquico para separar configuración de código.
- **Facts**: Variables del sistema recogidas por el agente (OS, IP, memoria, etc.).

## Manifiestos

```puppet
# manifests/site.pp
node 'web-server-01' {
  include nginx
  include app::deploy
}

node default {
  include base
  include monitoring::agent
}
```

### Recurso Package-File-Service

```puppet
class nginx {
  package { 'nginx':
    ensure => installed,
  }

  file { '/etc/nginx/sites-available/default':
    ensure  => file,
    content => template('nginx/vhost.conf.erb'),
    notify  => Service['nginx'],
  }

  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }
}
```

## Módulos

```
modules/
  nginx/
    manifests/init.pp    # Clase principal
    manifests/vhost.pp   # Defined type
    templates/           # Templates ERB
    files/               # Archivos estáticos
    lib/                 # Facts personalizados, funciones
    spec/                # Tests (rspec-puppet)
    data/                # Datos Hiera
```

### Defined Type

```puppet
# modules/nginx/manifests/vhost.pp
define nginx::vhost (
  String $server_name,
  Integer $port = 80,
  String $document_root = '/var/www/html',
) {
  file { "/etc/nginx/sites-available/${name}":
    ensure  => file,
    content => epp('nginx/vhost.conf.epp', {
      server_name   => $server_name,
      port          => $port,
      document_root => $document_root,
    }),
    notify  => Service['nginx'],
  }

  file { "/etc/nginx/sites-enabled/${name}":
    ensure => link,
    target => "/etc/nginx/sites-available/${name}",
    notify => Service['nginx'],
  }
}
```

## Puppet Bolt — Sin Maestro

```yaml
# bolt.yaml
inventory:
  nodes:
    - target1.example.com
    - target2.example.com
  groups:
    - name: webservers
      nodes:
        - web01.example.com
        - web02.example.com
```

```bash
bolt command run 'uptime' --targets webservers
bolt script run install_agent.sh --targets web01
bolt plan run deploy::app --targets webservers --params version=2.1.0
```

## PuppetDB y Reportes

```puppet
# puppetdb.conf
[main]
server_urls = https://puppetdb.example.com:8081
```

```bash
# Consultas PuppetDB (API)
curl -X GET 'https://puppetdb:8081/pdb/query/v4/nodes'
```

## Best Practices

1. **Módulos atómicos**: Cada módulo gestiona un único componente.
2. **Separar datos de código**: Usar Hiera, no hardcodear valores en manifests.
3. **Testing con rspec-puppet**: Probar clases y defined types.
4. **Versionado de módulos**: Puppetfile para fijar versiones del Forge.
5. **Idempotencia**: Ejecutar N veces produce el mismo estado final.
6. **Entornos**: Separar dev/staging/prod con directorios en el Master.
