# GitHub Actions

## Conceptos Fundamentales

GitHub Actions es la plataforma de CI/CD nativa de GitHub. Los workflows se definen en YAML dentro de `.github/workflows/`.

### Componentes

- **Workflow**: Proceso automatizado configurable con jobs.
- **Job**: Conjunto de steps en el mismo runner.
- **Step**: Tarea individual (comando shell o acción reutilizable).
- **Action**: Extensión reutilizable (JavaScript, Docker o composite).
- **Runner**: Servidor que ejecuta los workflows (GitHub-hosted o self-hosted).
- **Event**: Disparador (push, pull_request, schedule, workflow_dispatch).

## Sintaxis de Workflow

```yaml
name: CI Pipeline
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: "20"
  REGISTRY: ghcr.io

jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: "npm"
      - run: npm ci
      - run: npm run lint
      - run: npm run test:ci

  build:
    needs: test
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: ${{ env.REGISTRY }}/${{ github.repository }}:${{ github.sha }}
```

## Matrix Builds

```yaml
test-matrix:
  strategy:
    matrix:
      os: [ubuntu-latest, windows-latest, macos-latest]
      node: [18, 20, 22]
    fail-fast: false
  runs-on: ${{ matrix.os }}
  steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node }}
    - run: npm ci
    - run: npm test
```

## Reusable Workflows

```yaml
# .github/workflows/deploy.yml (reusable)
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
    secrets:
      CLOUD_API_KEY:
        required: true
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - run: ./deploy.sh ${{ inputs.environment }}
        env:
          API_KEY: ${{ secrets.CLOUD_API_KEY }}

# .github/workflows/release.yml (caller)
jobs:
  deploy-staging:
    uses: ./.github/workflows/deploy.yml
    with:
      environment: staging
    secrets:
      CLOUD_API_KEY: ${{ secrets.STAGING_API_KEY }}
```

## Environments y Protecciones

```yaml
deploy-production:
  runs-on: ubuntu-latest
  environment:
    name: production
    url: https://app.example.com
  concurrency:
    group: production-deploy
    cancel-in-progress: false
```

Características: required reviewers, wait timer, deployment branches, environment secrets.

## Self-Hosted Runners

```yaml
jobs:
  build-on-prem:
    runs-on: [self-hosted, linux, x64, gpu]
    steps:
      - run: docker build -t myapp .
```

```bash
./config.sh --url https://github.com/org/repo --token AAAAAAAA --labels gpu
sudo ./svc.sh install && sudo ./svc.sh start
```

## Caching

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

## Eventos y Filtros

```yaml
on:
  push:
    branches-ignore: [gh-pages]
    paths:
      - "src/**"
      - "!src/**/*.test.ts"
    tags: ["v*.*.*"]
  pull_request:
    types: [opened, synchronize, ready_for_review]
  workflow_dispatch:
    inputs:
      dry-run:
        type: boolean
        default: false
```

## OIDC para AWS

```yaml
- uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
    aws-region: us-east-1
```

Elimina necesidad de AWS keys como secrets.

## Best Practices

1. **Mínimo privilegio**: `permissions:` limita alcance del GITHUB_TOKEN.
2. **Usar GITHUB_TOKEN en lugar de PAT**: Scope limitado al workflow.
3. **Pin Actions a SHA**: Evitar tags mutables como `@v4`.
4. **Secretos**: `${{ secrets.MY_SECRET }}`, nunca en env.
5. **Evitar `pull_request_target`**: Riesgo de inyección en PRs de forks.
6. **Validación de inputs**: `required` y `type` en actions compuestas.
