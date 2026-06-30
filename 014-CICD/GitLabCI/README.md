# GitLab CI/CD

## Conceptos Fundamentales

GitLab CI/CD es el sistema de CI/CD nativo de GitLab, definido en `.gitlab-ci.yml`.

### Componentes

- **Runner**: Agente que ejecuta jobs.
- **Job**: Unidad mínima de trabajo.
- **Stage**: Grupo de jobs en paralelo; pipeline avanza secuencialmente.
- **Pipeline**: Stages + jobs disparados por un evento.

## Sintaxis

```yaml
default:
  image: node:20-alpine
  retry:
    max: 2
    when: [runner_system_failure, stuck_or_timeout_failure]

variables:
  REGISTRY: $CI_REGISTRY
  IMAGE_TAG: $CI_COMMIT_SHORT_SHA

stages:
  - lint
  - test
  - build
  - deploy

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths: [node_modules/]

lint:
  stage: lint
  script: npm ci && npm run lint
  only: [merge_requests, main]

unit-tests:
  stage: test
  script: npm ci && npm run test:ci
  artifacts:
    reports:
      junit: junit.xml

build:
  stage: build
  image: docker:24
  services: [docker:24-dind]
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $REGISTRY/$CI_PROJECT_PATH:$IMAGE_TAG .
    - docker push $REGISTRY/$CI_PROJECT_PATH:$IMAGE_TAG

deploy-staging:
  stage: deploy
  script: kubectl set image deployment/myapp myapp=$REGISTRY/$CI_PROJECT_PATH:$IMAGE_TAG -n staging
  environment:
    name: staging
    url: https://staging.example.com

deploy-production:
  stage: deploy
  script: kubectl set image deployment/myapp myapp=$REGISTRY/$CI_PROJECT_PATH:$IMAGE_TAG -n prod
  environment:
    name: production
    url: https://app.example.com
  when: manual
  needs: [deploy-staging]
  only: [main]
```

## DAG con `needs`

```yaml
stages: [build, test, package, deploy]
build-a:  { stage: build, script: make build-a }
build-b:  { stage: build, script: make build-b }
test-a:   { stage: test,  needs: [build-a], script: make test-a }
test-b:   { stage: test,  needs: [build-b], script: make test-b }
package:  { stage: package, needs: [test-a, test-b], script: make package }
deploy:   { stage: deploy,  needs: [package], script: make deploy }
```

## Matrix Parallelism

```yaml
test:
  parallel:
    matrix:
      - OS: [ubuntu, windows, macos]
        DB: [postgres, mysql]
        VERSION: [18, 20]
  script: ./test.sh $OS $DB $VERSION
```

## Child Pipelines

```yaml
generate-config:
  stage: build
  script: ./generate-pipeline.py > child.yml
  artifacts:
    paths: [child.yml]

child-pipeline:
  stage: test
  trigger:
    include:
      - artifact: child.yml
        job: generate-config
    strategy: depend
```

## Reglas (Rules)

```yaml
deploy:
  script: ./deploy.sh
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      when: never
    - if: '$CI_COMMIT_BRANCH == "main"'
      when: manual
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
      when: always
```

## Runners

```bash
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest register \
    --url "https://gitlab.com/" --token "glrt-..." \
    --executor "docker" --tag-list "docker,linux"
```

```toml
[[runners]]
  executor = "kubernetes"
  [runners.kubernetes]
    namespace = "gitlab-runners"
    image = "alpine:latest"
    privileged = true
```

## Variables y Secretos

```yaml
deploy:
  script: echo $DEPLOY_KEY | base64 -d | ssh-add -
  secrets:
    DATABASE_PASSWORD:
      vault: devops/db/prod/password@vault
```

## Templates de Seguridad

```yaml
include:
  - template: Jobs/SAST.gitlab-ci.yml
  - template: Jobs/Secret-Detection.gitlab-ci.yml
```

## Review Apps

```yaml
review:
  stage: deploy
  script: helm upgrade --install review-$CI_MERGE_REQUEST_IID ./chart
  environment:
    name: review/$CI_MERGE_REQUEST_IID
    url: https://review-$CI_MERGE_REQUEST_IID.example.com
    on_stop: stop-review
  only: [merge_requests]

stop-review:
  stage: deploy
  script: helm uninstall review-$CI_MERGE_REQUEST_IID
  environment:
    name: review/$CI_MERGE_REQUEST_IID
    action: stop
  when: manual
```

## Best Practices

1. **`default:`**: Configurar imagen, tags, retry y timeout.
2. **Cache**: `node_modules/`, `.m2/`.
3. **Máximo 4-5 stages**: Child pipelines si hay más.
4. **`needs` para DAG**: Más rápido que stages.
5. **Timeout por job**: `timeout: 30m`.
6. **Tags para enrutar a runners**.
7. **No hardcodear secrets**.
8. **Include remoto**: Reutilizar templates.
