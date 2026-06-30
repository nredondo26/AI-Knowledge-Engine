# Service Mesh — Malla de servicios para microservicios

## Descripción

Un Service Mesh gestiona la comunicación entre microservicios proporcionando observabilidad, seguridad (mTLS), control de tráfico (canary, circuit breaking) y resiliencia (retries, timeouts) sin modificar el código. Se implementa con sidecar proxies (Envoy) o eBPF (Cilium).

## Arquitectura

- **Data plane**: Proxies sidecar que interceptan el tráfico
- **Control plane**: Configura los proxies (istiod, Linkerd-controller, Consul)
- **mTLS**: Cifrado mutuo automático entre servicios
- **Telemetría**: Métricas (Prometheus), trazas (Jaeger), logs
- **Traffic management**: Enrutamiento por peso, cabeceras, mirroring

## Istio — Instalación

```bash
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
```

### Recursos Istio

```yaml
# VirtualService — Canary
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: api
spec:
  hosts: [api]
  http:
    - match:
        - headers: { version: { exact: v2 } }
      route:
        - destination: { host: api, subset: v2 }
    - route:
        - destination: { host: api, subset: v1 }
          weight: 90
        - destination: { host: api, subset: v2 }
          weight: 10
---
# PeerAuthentication — mTLS estricto
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls: { mode: STRICT }
---
# DestinationRule — Circuit breaking
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: db
spec:
  host: db
  trafficPolicy:
    connectionPool:
      tcp: { maxConnections: 50 }
      http: { http1MaxPendingRequests: 10 }
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 30s
      baseEjectionTime: 30s
```

## Linkerd

```bash
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install | sh
linkerd check --pre && linkerd install | kubectl apply -f -
kubectl get ns default -o yaml | linkerd inject - | kubectl apply -f -
linkerd viz install | kubectl apply -f - && linkerd viz dashboard
```

## Consul Service Mesh

```hcl
kind = "service-intentions"
name = "api"
sources = [{ name = "frontend", action = "allow" }]

kind = "service-resolver"
name = "api"
default_subset = "v1"
subsets = {
  v1 = { filter = "Service.Meta.version == v1" }
  v2 = { filter = "Service.Meta.version == v2" }
}
```

## Cilium Service Mesh (eBPF)

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: api-policy
spec:
  endpointSelector:
    matchLabels:
      app: api
  ingress:
    - fromEndpoints:
        - matchLabels:
            app: frontend
      toPorts:
        - ports:
            - port: "3000"
              protocol: TCP
```

## Observabilidad

```bash
# Kiali (Istio)
istioctl dashboard kiali
```

## Relaciones con otros módulos

- [Kubernetes](../Kubernetes/) — Service Mesh se despliega sobre K8s
- [Networking](../../008-Networking/) — Proxies, enrutamiento
- [Security](../../009-Security/) — Zero-trust con mTLS
- [Containers/Security](../../006-Containers/Security/) — Identidad de workloads

## Recursos recomendados

- [Istio documentation](https://istio.io/latest/docs/)
- [Linkerd documentation](https://linkerd.io/2.14/overview/)
- [Cilium Service Mesh](https://docs.cilium.io/en/stable/network/servicemesh/)
