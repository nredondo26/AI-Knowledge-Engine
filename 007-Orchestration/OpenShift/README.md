# Red Hat OpenShift — Plataforma Kubernetes empresarial

## Descripción

OpenShift extiende Kubernetes con CI/CD integrado, seguridad avanzada, OperatorHub, redes (OVN-Kubernetes), monitorización (Prometheus + Grafana) y herramientas de desarrollo (Source-to-Image, Dev Spaces, Pipelines). Disponible como OCP (on-prem), ROSA (AWS), ARO (Azure) y OKD (comunitario).

## Arquitectura

- **Control plane**: Kubernetes + operadores OpenShift
- **Router**: HAProxy Ingress Controller (routes)
- **Internal Registry**: ImageStreams integrado
- **SDN**: OpenShift SDN u OVN-Kubernetes
- **OperatorHub**: Marketplace de operadores
- **Monitoring**: Prometheus + Grafana + Alertmanager preconfigurados

## Instalación (IPI)

```bash
cat > install-config.yaml <<EOF
apiVersion: v1
baseDomain: midominio.com
metadata:
  name: ocp-prod
platform:
  aws:
    region: us-east-1
pullSecret: '{"auths":{...}}'
sshKey: 'ssh-rsa ...'
EOF
./openshift-install create cluster
```

## Routes (vs Ingress)

```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: miapp
spec:
  host: miapp.apps.ocp-prod.midominio.com
  to:
    kind: Service
    name: miapp-svc
  port:
    targetPort: 3000
  tls:
    termination: edge
    insecureEdgeTerminationPolicy: Redirect
```

## ImageStreams y BuildConfigs

```yaml
apiVersion: image.openshift.io/v1
kind: ImageStream
metadata:
  name: miapp
---
apiVersion: build.openshift.io/v1
kind: BuildConfig
metadata:
  name: miapp
spec:
  source:
    type: Git
    git:
      uri: https://github.com/usuario/miapp.git
      ref: main
  strategy:
    type: Source
    sourceStrategy:
      from:
        kind: ImageStreamTag
        name: nodejs:20-ubi9
  output:
    to:
      kind: ImageStreamTag
      name: miapp:latest
```

## Security Context Constraints (SCC)

```yaml
apiVersion: security.openshift.io/v1
kind: SecurityContextConstraints
metadata:
  name: miapp-scc
allowPrivilegedContainer: false
runAsUser:
  type: MustRunAsRange
seLinuxContext:
  type: MustRunAs
fsGroup:
  type: MustRunAs
```

```bash
oc adm policy add-scc-to-user miapp-scc -z default -n miapp-ns
```

## OperatorHub

```bash
oc apply -f https://operatorhub.io/install/postgresql-operator.yaml
oc get operators
oc get packagemanifests -n openshift-marketplace
```

## Templates

```yaml
apiVersion: template.openshift.io/v1
kind: Template
metadata:
  name: miapp-template
objects:
  - apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: "${APP_NAME}"
    spec:
      replicas: ${{REPLICAS}}
      template:
        spec:
          containers:
            - image: "${IMAGE}:${TAG}"
              name: app
parameters:
  - name: APP_NAME
    value: miapp
  - name: REPLICAS
    value: "3"
  - name: IMAGE
    value: quay.io/usuario/miapp
  - name: TAG
    value: latest
```

## Relaciones con otros módulos

- [Kubernetes](../Kubernetes/) — OpenShift extiende K8s upstream
- [EKS](../EKS/) — ROSA (OpenShift on AWS)
- [AKS](../AKS/) — ARO (Azure Red Hat OpenShift)
- [Containers/Security](../../006-Containers/Security/) — SCC

## Recursos recomendados

- [Documentación OpenShift](https://docs.openshift.com/)
- [OKD — Community OpenShift](https://okd.io/)
