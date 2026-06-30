# HashiCorp Nomad — Orquestador flexible

## Descripción

Nomad es un orquestador de workloads de HashiCorp que gestiona contenedores, aplicaciones nativas, VMs y batch jobs. Es monolítico (un solo binario), más simple que Kubernetes, y se integra con Consul (service discovery) y Vault (secretos).

## Arquitectura

- **Servers**: Gestionan estado, scheduling y liderazgo (Raft consensus)
- **Clients**: Ejecutan tareas y reportan recursos
- **Jobs**: Definición declarativa en HCL
- **Allocations**: Asignación de job a un cliente
- **Task Groups**: Tareas que comparten red/almacenamiento

## Instalación

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install nomad
sudo nomad agent -dev -bind=0.0.0.0 -log-level=INFO
```

## Job básico en HCL

```hcl
job "web" {
  datacenters = ["dc1"]
  type = "service"
  group "web" {
    count = 3
    network { port "http" { to = 80 } }
    service {
      name = "nginx-web"
      port = "http"
      check { type = "http" path = "/" interval = "10s" timeout = "2s" }
    }
    task "nginx" {
      driver = "docker"
      config { image = "nginx:alpine" ports = ["http"] }
      resources { cpu = 500 memory = 256 }
    }
  }
}
```

```bash
nomad job run web.nomad
```

## Comandos de gestión

```bash
nomad job list
nomad job status web
nomad alloc logs <alloc-id> nginx
nomad alloc exec <alloc-id> nginx sh
nomad job stop web
```

## Drivers soportados

| Driver | Descripción |
|--------|-------------|
| docker | Contenedores Docker |
| podman | Contenedores Podman |
| exec | Binarios directos |
| java | Aplicaciones Java |
| qemu | Máquinas virtuales |
| containerd-driver | Integración containerd |

## Integración con Consul y Vault

```hcl
service {
  name = "api"
  port = "http"
  check { type = "http" path = "/health" interval = "10s" }
}

task "app" {
  driver = "docker"
  config { image = "miapp:latest" }
  template {
    data        = <<EOH
DATABASE_URL = "postgres://{{with secret "secret/data/db"}}{{.Data.data.username}}:{{.Data.data.password}}@db:5432/miapp{{end}}"
EOH
    destination = "local/env.txt"
    env         = true
  }
}
```

## Job batch

```hcl
job "procesar-datos" {
  datacenters = ["dc1"]
  type = "batch"
  group "process" {
    task "procesar" {
      driver = "exec"
      config { command = "/usr/local/bin/procesar.sh" }
      resources { cpu = 2000 memory = 1024 }
    }
  }
}
```

## Relaciones con otros módulos

- [Kubernetes](../Kubernetes/) — Alternativa más compleja
- [DockerSwarm](../DockerSwarm/) — Simplicidad similar
- [AWS/HashiCorp](../../005-Cloud/HashiCorp/) — Ecosistema Consul + Vault + Terraform
- [Containers/Docker](../../006-Containers/Docker/) — Driver de contenedores

## Recursos recomendados

- [Documentación oficial](https://developer.hashicorp.com/nomad/docs)
- [Nomad — Learn](https://learn.hashicorp.com/nomad)
- [GitHub — Nomad](https://github.com/hashicorp/nomad)
