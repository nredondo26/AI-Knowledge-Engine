# Ansible

## Conceptos Fundamentales

Ansible es un motor de automatización agentless de Red Hat. Usa SSH/WinRM y YAML para playbooks. Modelo declarativo con estado deseado.

### Componentes

- **Inventory**: Lista de nodos (estático o dinámico cloud).
- **Playbook**: Archivo YAML con plays (roles + tareas).
- **Module**: Código Python/PowerShell (package, copy, service).
- **Role**: Empaquetado reusable (tareas, handlers, templates).
- **Handler**: Tarea solo si es notificada.
- **Collection**: Distribución de roles, módulos, plugins.

## Inventory

```yaml
all:
  children:
    webservers:
      hosts:
        web01:
          ansible_host: 10.0.1.10
          ansible_user: admin
    dbservers:
      hosts:
        db01:
          ansible_host: 10.0.2.10
      vars:
        postgres_version: "16"
```

### Dinámico (AWS)

```yaml
plugin: aws_ec2
regions: [us-east-1]
filters:
  tag:Environment: production
keyed_groups:
  - key: tags.Role
```

## Playbook

```yaml
---
- name: Configurar servidor web
  hosts: webservers
  become: yes
  vars:
    app_port: 8080
  tasks:
    - name: Instalar nginx
      apt:
        name: nginx
        state: present
      notify: restart nginx

    - name: Configurar vhost
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/sites-available/default

    - name: Iniciar servicio
      service:
        name: nginx
        state: started
        enabled: yes

  handlers:
    - name: restart nginx
      service:
        name: nginx
        state: restarted
```

## Roles

```
roles/
  nginx/
    defaults/main.yml
    tasks/main.yml
    handlers/main.yml
    templates/nginx.conf.j2
    files/index.html
    meta/main.yml
```

```yaml
- name: Web servers
  hosts: webservers
  roles:
    - role: common
    - role: nginx
      vars:
        app_name: myapp
        ssl_enabled: true
```

## Módulos Esenciales

```yaml
tasks:
  - name: Copiar archivo
    copy:
      src: files/config.yml
      dest: /etc/app/config.yml
      mode: '0640'
      backup: yes

  - name: Template Jinja2
    template:
      src: app.env.j2
      dest: /etc/app/app.env

  - name: Servicio systemd
    systemd:
      name: myapp
      state: restarted
      daemon_reload: yes

  - name: Docker container
    docker_container:
      name: redis
      image: redis:7
      state: started
      ports: ["6379:6379"]

  - name: EC2 instance
    ec2_instance:
      name: "web-{{ item }}"
      instance_type: t3.medium
      image_id: ami-0abcdef
    loop: "{{ instances }}"
```

## Ansible Vault

```bash
ansible-vault create secrets.yml
ansible-playbook playbook.yml --ask-vault-pass
```

```yaml
db_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  623632653439663833393663386534376130...
```

## Tags y Estrategias

```yaml
tasks:
  - name: Instalar paquetes
    apt:
      name: "{{ packages }}"
    tags: [packages]

  - name: Configurar firewall
    ufw:
      rule: allow
      port: 80
    tags: [security]
```

```bash
ansible-playbook playbook.yml --tags deploy
ansible-playbook playbook.yml --check --diff
```

## Best Practices

1. **Usar roles**: No playbooks monolíticos.
2. **Idempotencia**: Ejecutar N veces sin efectos secundarios.
3. **Estructura de proyecto**:
   ```
   ansible-project/
     inventory/ roles/ playbooks/ group_vars/ host_vars/ ansible.cfg
   ```
4. **ansible.cfg**:
   ```ini
   [defaults]
   inventory = inventory/production/hosts.yml
   roles_path = roles
   host_key_checking = False
   ```
5. **`--check --diff` siempre antes de aplicar**.
6. **Secrets fuera del repo**: Vault.
7. **Limit**: `ansible-playbook play.yml --limit web01`.
8. **Variables con defaults**: `defaults/main.yml`.
9. **Colecciones**:
   ```yaml
   collections:
     - name: community.docker
       version: ">=3.4.0"
   ```
