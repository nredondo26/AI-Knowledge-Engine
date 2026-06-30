# SaltStack — Automatización de Configuración

## Conceptos Fundamentales

SaltStack (Salt) es una herramienta de automatización de infraestructura basada en Python que utiliza comunicación pub/sub con ZeroMQ. Está diseñada para gestionar miles de nodos con latencia de segundos.

### Arquitectura

- **Salt Master**: Servidor central que envía comandos y almacena configuraciones.
- **Salt Minion**: Agente que se ejecuta en nodos gestionados y ejecuta comandos.
- **Salt SSH**: Modo agentless que usa SSH en vez de minion.
- **States**: Configuración declarativa del estado deseado (equivalente a YAML).
- **Pillar**: Datos estructurados seguros específicos por minion.
- **Grains**: Información estática del minion (OS, CPU, IP, kernel).
- **Reactor**: Sistema de eventos para respuesta automática.

## States (SLS)

```yaml
# /srv/salt/nginx/init.sls
nginx:
  pkg.installed:
    - name: nginx

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/files/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: nginx

nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
```

### Top File

```yaml
# /srv/salt/top.sls
base:
  'web*':
    - nginx
    - nodejs
    - app.deploy
  'db*':
    - postgres
    - monitoring.node_exporter
  '*':
    - base
    - security.ssh
```

## Pillar

```yaml
# /srv/pillar/top.sls
base:
  'web*':
    - nginx
  'db*':
    - postgres

# /srv/pillar/nginx.sls
nginx:
  port: 8080
  server_name: app.example.com
  ssl:
    enabled: true
    cert: /etc/ssl/certs/server.crt
    key: /etc/ssl/private/server.key
```

```yaml
# state con pillar
nginx_config:
  file.managed:
    - name: /etc/nginx/sites-available/default
    - source: salt://nginx/templates/default.conf.j2
    - template: jinja
    - defaults:
        port: {{ pillar['nginx']['port'] }}
        server_name: {{ pillar['nginx']['server_name'] }}
```

## Grains

```bash
salt web01 grains.ls
salt web01 grains.item os_family cpu_model ipv4
```

```yaml
# grains personalizados (/etc/salt/grains)
role: webserver
datacenter: us-east-1
environment: production
```

## Salt SSH (Agentless)

```bash
# /etc/salt/roster
web01:
  host: 10.0.1.10
  user: admin
  sudo: True
  port: 22

db01:
  host: 10.0.2.10
  user: admin
```

```bash
salt-ssh '*' test.ping
salt-ssh -i 'web*' state.apply nginx
```

## Ejecución Remota

```bash
# Comandos ad-hoc
salt '*' cmd.run 'uptime'
salt 'web*' pkg.install htop

# States
salt 'db*' state.apply postgres
salt 'web*' state.highstate test=True
salt '*' state.sls nginx,nodejs

# Orquestación
salt-run state.orchestrate orch.deploy
```

## Best Practices

1. **Top file bien definido**: Organizar por patrones de minion o grains.
2. **Separar datos de lógica**: Pillar para datos, States para lógica.
3. **Jinja con moderación**: No poner lógica compleja en templates.
4. **Entornos Git**: Usar `gitfs` para servir states desde repositorios.
5. **Testing**: `state.show_sls` y `test=True` para dry-run.
6. **Grains estáticos**: Se actualizan al reiniciar. Pillar para datos dinámicos.
7. **Seguridad**: `pillar_encryption` con GPG para secrets.
