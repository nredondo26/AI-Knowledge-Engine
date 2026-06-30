# Bitbucket Pipelines — CI/CD Integrado en Bitbucket

## Descripción General

Bitbucket Pipelines es el servicio de CI/CD nativo de Bitbucket Cloud. Los pipelines se definen en `bitbucket-pipelines.yml`. Usa contenedores Docker para ejecución, con integración directa a Pull Requests y entornos de despliegue.

---

## Configuración Básica

```yaml
# bitbucket-pipelines.yml
image: node:20

pipelines:
  default:
    - step:
        name: Lint & Test
        caches:
          - node
        script:
          - npm ci
          - npm run lint
          - npm run test:ci
        artifacts:
          - dist/**
    - step:
        name: Build
        script:
          - npm run build
        artifacts:
          - dist/**
    - step:
        name: Deploy to Staging
        deployment: staging
        script:
          - pipe: atlassian/aws-s3-deploy:1.1.0
            variables:
              AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
              AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
              AWS_DEFAULT_REGION: 'us-east-1'
              S3_BUCKET: 'mi-app-staging'
              LOCAL_PATH: 'dist'
```

---

## Pipelines por Ramas

```yaml
pipelines:
  branches:
    main:
      - step:
          name: Deploy Production
          deployment: production
          trigger: manual
          script:
            - pipe: atlassian/aws-s3-deploy:1.1.0
              variables:
                AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
                AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
                AWS_DEFAULT_REGION: 'us-east-1'
                S3_BUCKET: 'mi-app-prod'
                LOCAL_PATH: 'dist'

    develop:
      - step:
          name: Deploy Dev
          deployment: test
          script:
            - ./deploy.sh dev

  pull-requests:
    '**':
      - step:
          name: PR Checks
          script:
            - npm ci
            - npm run lint
            - npm test
```

---

## Custom Pipelines (Manual Trigger)

```yaml
pipelines:
  custom:
    deploy-to-prod:
      - step:
          name: Deploy Production
          deployment: production
          trigger: manual
          script:
            - echo "Desplegando a producción..."
            - ./deploy.sh prod

    rollback:
      - step:
          name: Rollback
          script:
            - ./rollback.sh $BITBUCKET_TAG
```

---

## Services y Múltiples Contenedores

```yaml
definitions:
  services:
    postgres:
      image: postgres:15
      variables:
        POSTGRES_DB: testdb
        POSTGRES_USER: test
        POSTGRES_PASSWORD: test
    redis:
      image: redis:7-alpine

pipelines:
  default:
    - step:
        name: Integration Tests
        image: node:20
        services:
          - postgres
          - redis
        script:
          - npm ci
          - npm run test:integration
```

---

## Pipes (Reutilización)

```yaml
script:
  - pipe: atlassian/slack-notify:2.0.0
    variables:
      WEBHOOK_URL: $SLACK_WEBHOOK
      MESSAGE: 'Pipeline completado exitosamente'
```

Los pipes son componentes reutilizables como los orbs de CircleCI.

---

## Cache

```yaml
definitions:
  caches:
    custom-npm: node_modules
    maven: ~/.m2

pipelines:
  default:
    - step:
        caches:
          - custom-npm
          - node
        script:
          - npm ci
```

---

## Mejores Prácticas

1. **Definiciones**: Centralizar servicios y caches en `definitions`.
2. **Artifacts**: Pasar builds entre steps sin reconstruir.
3. **Deployment types**: Usar `test`, `staging`, `production` para tracking.
4. **Pipes**: Preferir pipes a scripts manuales.
5. **Trigger manual**: En producción usar `trigger: manual`.

---

## Referencias

- [Bitbucket Pipelines Docs](https://bitbucket.org/product/features/pipelines)
- [Atlassian Pipe Registry](https://bitbucket.org/product/features/pipelines/integrations)
