# Travis CI — CI/CD para GitHub

## Descripción General

Travis CI fue uno de los primeros servicios SaaS de CI/CD. Se configura con `.travis.yml` y se integra nativamente con GitHub. Su versión gratuita (.org) fue descontinuada en 2021; Travis CI.com continúa como producto enterprise.

---

## Build Matrix

```yaml
# .travis.yml
language: node_js
node_js:
  - 18
  - 20
  - 22

os:
  - linux
  - osx

env:
  - DB=mysql
  - DB=postgres

dist: focal
sudo: required

cache:
  npm: true
  directories:
    - node_modules

before_install:
  - npm update -g npm

install:
  - npm ci

script:
  - npm run lint
  - npm test

after_success:
  - npm run coverage
  - bash <(curl -s https://codecov.io/bash)
```

---

## Stages (Pipeline)

```yaml
language: node_js
node_js: 20

jobs:
  include:
    - stage: lint
      script: npm run lint

    - stage: test
      script: npm test

    - stage: build
      script: npm run build

    - stage: deploy
      if: branch = main AND type != pull_request
      script: ./deploy.sh
      deploy:
        provider: heroku
        api_key: $HEROKU_API_KEY
        app: mi-app-produccion
```

---

## Servicios (Docker)

```yaml
services:
  - docker
  - mysql
  - postgresql
  - redis

before_install:
  - docker build -t mi-app .
  - docker run -d -p 5432:5432 postgres:15

script:
  - docker run mi-app npm test
```

---

## Despliegue a AWS

```yaml
deploy:
  provider: elasticbeanstalk
  access_key_id: $AWS_ACCESS_KEY
  secret_access_key: $AWS_SECRET_KEY
  region: us-east-1
  app: mi-app
  env: produccion
  bucket_name: elasticbeanstalk-us-east-1
  on:
    branch: main
```

---

## Cifrado de Variables

```bash
travis encrypt DOCKER_PASSWORD=secreto --add env.matrix
```

```yaml
env:
  global:
    - secure: "cifrado_base64..."
```

---

## Notificaciones

```yaml
notifications:
  email:
    recipients:
      - equipo@example.com
    on_success: change
    on_failure: always
  slack:
    rooms:
      - workspace:token#canal
    on_success: change
    on_failure: always
```

---

## Mejores Prácticas

1. **Build matrix**: Probar múltiples versiones y entornos en paralelo.
2. **Cache**: npm, pip, gems para acelerar builds.
3. **Stages**: Separar lint → test → build → deploy.
4. **Secretos cifrados**: `travis encrypt` para variables sensibles.
5. **Jobs condicionales**: `if:` para limitar deploy solo a `main`.

---

## Referencias

- [Travis CI Docs](https://docs.travis-ci.com)
- [Travis CI API](https://developer.travis-ci.com)
