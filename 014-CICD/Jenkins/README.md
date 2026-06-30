# Jenkins — Automatización CI/CD

## Conceptos Fundamentales

Jenkins es el servidor de automatización open-source más veterano del ecosistema DevOps. Basado en Java, soporta pipelines declarativos y scripted mediante un DSL basado en Groovy con más de 1,800 plugins.

### Arquitectura

- **Master (Controller)**: Orquesta pipelines, sirve UI, almacena config.
- **Agent (Node)**: Ejecuta jobs (máquina, VM, contenedor Docker, pod K8s).
- **Executor**: Slot de ejecución dentro de un agent.

## Jenkinsfile — Pipeline as Code

### Declarative Pipeline

```groovy
pipeline {
    agent any
    parameters {
        string(name: 'BRANCH', defaultValue: 'main')
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'])
        booleanParam(name: 'DRY_RUN', defaultValue: false)
    }
    environment {
        DOCKER_REGISTRY = 'registry.example.com'
    }
    stages {
        stage('Checkout') { steps { checkout scm } }

        stage('Lint & Test') {
            parallel {
                stage('Lint') { steps { sh 'npm run lint' } }
                stage('Unit Tests') {
                    steps { sh 'npm run test:ci' }
                    post { always { junit 'reports/**/junit.xml' } }
                }
            }
        }

        stage('Build') {
            steps {
                sh "docker build -t ${DOCKER_REGISTRY}/myapp:${BUILD_NUMBER} ."
            }
        }

        stage('Deploy') {
            when { expression { params.ENVIRONMENT != 'prod' } }
            steps {
                sh "kubectl set image deployment/myapp myapp=${DOCKER_REGISTRY}/myapp:${BUILD_NUMBER}"
            }
        }
    }
    post {
        always { cleanWs() }
        success { emailext(to: 'team@example.com',
            subject: "Build exitoso: ${env.BUILD_NUMBER}") }
        failure { slackSend(channel: '#devops-alerts', color: 'danger',
            message: "Pipeline falló #${env.BUILD_NUMBER}") }
    }
}
```

### Scripted Pipeline

```groovy
node('linux-java') {
    stage('Checkout') { checkout scm }
    stage('Build') {
        docker.image('maven:3.9').inside('-v /tmp/.m2:/root/.m2') {
            sh 'mvn clean package'
        }
    }
    stage('Archive') { archiveArtifacts artifacts: 'target/*.jar' }
}
```

## Shared Libraries

Código reutilizable entre pipelines:

```groovy
// vars/kubernetesDeploy.groovy
def call(String namespace, String deployment, String image) {
    sh """
        kubectl set image deployment/${deployment} ${deployment}=${image} -n ${namespace} --record
        kubectl rollout status deployment/${deployment} -n ${namespace}
    """
}

// Jenkinsfile
@Library('my-shared-lib@main') _
pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps { kubernetesDeploy(namespace: 'prod', deployment: 'myapp', image: 'app:1.0') }
        }
    }
}
```

## Agentes

### Docker Agent

```groovy
pipeline {
    agent { docker { image 'node:20-alpine'; args '-v /var/run/docker.sock:/var/run/docker.sock' } }
    stages {
        stage('Test') { steps { sh 'npm ci && npm test' } }
    }
}
```

### Kubernetes Agent

```groovy
pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: node
      image: node:20
      command: ['cat']
      tty: true
    - name: docker
      image: docker:24
      command: ['cat']
      tty: true
'''
            defaultContainer 'node'
        }
    }
    stages {
        stage('Build') {
            steps { container('docker') { sh 'docker build -t myapp .' } }
        }
    }
}
```

## Configuration as Code (JCasC)

```yaml
jenkins:
  systemMessage: "Jenkins con JCasC"
  numExecutors: 0
  securityRealm:
    ldap:
      configurations:
        - server: ldap.example.com
          managerPasswordSecret: "${LDAP_PASSWORD}"
  authorizationStrategy:
    globalMatrix:
      permissions:
        - "Overall/Administer:admin"
        - "Overall/Read:authenticated"
  credentials:
    - usernamePassword:
        id: docker-hub
        username: "${DOCKER_USER}"
        password: "${DOCKER_PASS}"

unclassified:
  location:
    url: "https://jenkins.example.com"
```

## Best Practices

1. **Pipeline as Code**: Nunca configurar jobs desde la UI.
2. **Shared Libraries**: Centralizar lógica común versionada.
3. **JCasC + Backup**: Config reproducible desde código.
4. **Evitar `node` statement global**: Usar `agent` declarativo.
5. **Manejar secretos con Credentials Binding**:
   ```groovy
   withCredentials([string(credentialsId: 'api-key', variable: 'API_KEY')]) {
       sh './deploy.sh --api-key $API_KEY'
   }
   ```
6. **Pipeline durability**: `durabilityHint 'PERFORMANCE_OPTIMIZED'` para stages no críticos.
7. **Limitar artefactos grandes**: Usar S3/Artifactory en lugar de Jenkins.
8. **Monitorización**: Metrics Plugin + Prometheus + Grafana.
9. **Blue Ocean UI**: Mejorar UX de pipelines.
10. **Declarative > Scripted**: Preferir declarative (mejor sintaxis, validación, paralelismo).

## Métricas Clave

| Métrica | Umbral |
|---------|--------|
| Queue length | > 5 |
| Executor usage | > 80% |
| Build duration | > 2x baseline |
| Build success rate | < 90% |
| Disk usage /var/lib/jenkins | > 85% |
