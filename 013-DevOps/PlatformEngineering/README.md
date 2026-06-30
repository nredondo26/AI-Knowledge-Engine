# Platform Engineering — Ingeniería de Plataforma

## Conceptos Fundamentales

Platform Engineering es la disciplina de diseñar, construir y mantener plataformas internas (IDP — Internal Developer Platform) que abstraen la complejidad de la infraestructura. Su objetivo es acelerar la entrega de software proporcionando a los desarrolladores self-service paths seguros y gobernados.

### ¿Por qué una Plataforma Interna?

| Problema | Solución de Platform Engineering |
|----------|--------------------------------|
| Desarrolladores pierden tiempo con infraestructura | Self-service: deploy con un PR |
| Configuración inconsistente entre equipos | Golden paths y templates estandarizados |
| Seguridad reactiva | Policy as Code integrado en la plataforma |
| Onboarding lento de nuevos devs | Catálogo de servicios con scaffolding automático |
| Múltiples herramientas inconexas | Portal unificado (Backstage) |

## Backstage — Portal de Desarrollador

Backstage (Spotify/CNCF) es el portal open-source más adoptado para platform engineering.

### Configuración de Servicio

```yaml
# catalog-info.yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: my-api
  description: API de usuarios
  tags:
    - golang
    - api
    - production
  annotations:
    github.com/project-slug: org/my-api
    backstage.io/techdocs-ref: dir:.
spec:
  type: service
  lifecycle: production
  owner: team-payment
  system: payment-platform
  dependsOn:
    - component:postgres-db
    - resource:redis-cache
  providesApis:
    - user-api
```

### Scaffolding de Nuevos Servicios

```yaml
# templates/nodejs-service/template.yaml
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: nodejs-service
  title: Node.js API Service
  description: Crear un nuevo microservicio Node.js
spec:
  owner: platform-team
  type: service
  parameters:
    - title: Información del servicio
      required: [serviceName, description]
      properties:
        serviceName:
          type: string
          title: Nombre del servicio
          pattern: "^[a-z0-9-]+$"
        description:
          type: string
          title: Descripción
        owner:
          type: string
          title: Equipo owner
          enum: [team-payment, team-checkout, team-users]
  steps:
    - id: template
      name: Generar código
      action: fetch:template
      input:
        url: ./skeletons/nodejs-api
        values:
          serviceName: ${{ parameters.serviceName }}
          description: ${{ parameters.description }}

    - id: publish
      name: Crear repositorio
      action: publish:github
      input:
        repoUrl: github.com?repo=${{ parameters.serviceName }}

    - id: register
      name: Registrar en Backstage
      action: catalog:register
      input:
        repoContentsUrl: ${{ steps.publish.output.repoContentsUrl }}
```

## Internal Developer Platform (IDP)

### Golden Path - Ejemplo

```yaml
# golden-path-api.yaml
apiVersion: platform.example.com/v1
kind: Service
metadata:
  name: new-api
spec:
  language: go
  team: team-payment
  database:
    engine: postgres
    size: small
  observability:
    alerts:
      - type: latency
        threshold: p99 > 500ms
    dashboards:
      - type: api-overview
  deployment:
    strategy: rolling
    minReplicas: 3
    maxReplicas: 10
    resources:
      requests: { cpu: 500m, memory: 512Mi }
      limits: { cpu: 2000m, memory: 1Gi }
```

## Best Practices

1. **Golden paths, no golden handcuffs**: Caminos recomendados con excepciones justificadas.
2. **Platform como producto**: Roadmap, feedback, métricas de adopción.
3. **API first**: Exponer APIs (CRDs, REST), no GUIs o scripts.
4. **Adopción voluntaria**: Si no adoptan, no resuelve problemas reales.
5. **Paved road**: Camino más fácil = también el más seguro y gobernado.
6. **Equipo pequeño**: 5-8 personas para decenas de equipos de producto.
7. **Métricas de éxito**: DORA metrics (deploy frequency, lead time, MTTR, change failure rate).
