# CircleCI — CI/CD en la Nube

## Descripción General

CircleCI es una plataforma de integración continua y entrega continua (CI/CD) basada en la nube. Los pipelines se definen en un archivo YAML (`.circleci/config.yml`). Soporta ejecución paralela, caching inteligente, y orquestación con workflows.

---

## Arquitectura

- **Jobs**: Unidad de trabajo (build, test, deploy).
- **Steps**: Comandos o acciones dentro de un job.
- **Workflows**: Orquestan jobs en paralelo o secuencial.
- **Executor**: `docker`, `machine` (VM), `macos`.
- **Orbs**: Paquetes reutilizables de configuración YAML.

---

## Configuración Básica

```yaml
# .circleci/config.yml
version: 2.1

orbs:
  node: circleci/node@5.1.0

executors:
  node-executor:
    docker:
      - image: cimg/node:20.11

jobs:
  lint-and-test:
    executor: node-executor
    steps:
      - checkout
      - node/install-packages:
          pkg-manager: npm
      - run: npm run lint
      - run: npm run test:ci

  build:
    executor: node-executor
    steps:
      - checkout
      - node/install-packages:
          pkg-manager: npm
      - run: npm run build
      - persist_to_workspace:
          root: .
          paths:
            - dist

workflows:
  version: 2
  ci-pipeline:
    jobs:
      - lint-and-test
      - build:
          requires:
            - lint-and-test
```

---

## Workflows con DAG

```yaml
workflows:
  full-pipeline:
    jobs:
      - lint
      - test:
          requires: [lint]
      - build:
          requires: [lint]
      - integration-tests:
          requires: [test]
      - deploy-staging:
          requires: [build, integration-tests]
          filters:
            branches:
              only: main
      - deploy-production:
          type: approval
          requires: [deploy-staging]
          filters:
            branches:
              only: main
```

---

## Matrix Testing

```yaml
test-matrix:
  docker:
    - image: cimg/node:18.20
    - image: cimg/node:20.11
    - image: cimg/node:22.0
  parallelism: 4
  steps:
    - checkout
    - run: npm ci
    - run: npm test -- --shard=$(($CIRCLE_NODE_INDEX + 1))/$CIRCLE_NODE_TOTAL
```

---

## Caching y Dependencias

```yaml
jobs:
  install-deps:
    docker:
      - image: cimg/node:20.11
    steps:
      - checkout
      - restore_cache:
          keys:
            - v1-deps-{{ checksum "package-lock.json" }}
            - v1-deps-
      - run: npm ci
      - save_cache:
          key: v1-deps-{{ checksum "package-lock.json" }}
          paths:
            - node_modules
```

---

## Orbs (Reutilización)

```yaml
version: 2.1

orbs:
  aws-cli: circleci/aws-cli@3.1
  slack: circleci/slack@4.10

jobs:
  deploy:
    docker:
      - image: cimg/python:3.11
    steps:
      - aws-cli/setup
      - run: aws s3 sync dist/ s3://mi-bucket/
      - slack/notify:
          event: success
          custom: 'Deploy completado :rocket:'
```

---

## Persistencia de Workspace

```yaml
jobs:
  build:
    steps:
      - run: npm run build
      - persist_to_workspace:
          root: dist
          paths:
            - .

  deploy:
    steps:
      - attach_workspace:
          at: /tmp/workspace
      - run: ls /tmp/workspace
```

---

## Variables de Entorno y Contextos

```yaml
jobs:
  deploy-production:
    docker:
      - image: cimg/base:current
    steps:
      - run: ./deploy.sh
        environment:
          ENV: production

workflows:
  release:
    jobs:
      - deploy-production:
          context: production-context
```

Los contextos agrupan variables de entorno seguras compartidas entre proyectos.

---

## SSH Debug

```yaml
jobs:
  debug:
    machine: true
    steps:
      - checkout
      - run: ssh -p 64535 -o StrictHostKeyChecking=no remote@localhost
```

CircleCI permite habilitar SSH re-run para depuración interactiva.

---

## Mejores Prácticas

1. **Usar orbs oficiales** en lugar de scripts manuales.
2. **Caching agresivo**: `restore_cache` + `save_cache` para dependencias.
3. **Parallelism**: Dividir tests entre múltiples contenedores.
4. **Workspaces**: Pasar artefactos entre jobs sin store externo.
5. **Contextos**: Para secretos compartidos entre proyectos.
6. **Workflows**: Modelar DAG real, no pipelines lineales.

---

## Referencias

- [CircleCI Docs](https://circleci.com/docs)
- [CircleCI Orb Registry](https://circleci.com/developer/orbs)
- [CircleCI CLI](https://circleci.com/docs/local-cli)
