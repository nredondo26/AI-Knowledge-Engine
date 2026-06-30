# Amazon EKS — Elastic Kubernetes Service

## Descripción

Amazon EKS es Kubernetes gestionado por AWS con control plane multi-AZ, worker nodes EC2 o Fargate, y certificación CNCF.

## Arquitectura

- **Control plane**: Gestionado por AWS (etcd, API server, scheduler) en 3 AZs
- **Worker nodes**: EC2 (Managed Node Groups, Karpenter) o Fargate (serverless)
- **IRSA**: IAM Roles for Service Accounts
- **Add-ons**: CoreDNS, kube-proxy, VPC CNI, metrics-server
- **Dataplane**: VPC CNI (IP nativa de VNet por pod)

## Creación con eksctl

```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: miapp-prod
  region: us-east-1
  version: "1.29"
managedNodeGroups:
  - name: workers
    instanceType: t3.medium
    desiredCapacity: 3
    minSize: 3
    maxSize: 10
    privateNetworking: true
iam:
  withOIDC: true
```

```bash
eksctl create cluster -f cluster.yaml
eksctl get clusters
eksctl delete cluster miapp-prod
```

## IRSA — IAM Roles for Service Accounts

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: s3-reader
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/s3-reader-role
---
apiVersion: v1
kind: Pod
metadata:
  name: myapp
  serviceAccountName: s3-reader
spec:
  containers:
    - name: app
      image: alpine:latest
      command: ["aws", "s3", "ls"]
```

## Karpenter — Auto-scaling

```yaml
apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      requirements:
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ["on-demand"]
      nodeClassRef:
        name: default
---
apiVersion: karpenter.k8s.aws/v1beta1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiFamily: AL2
  role: "KarpenterNodeRole-miapp-prod"
  subnetSelectorTerms:
    - tags:
        "kubernetes.io/cluster/miapp-prod": owned
```

## Add-ons gestionados

```bash
aws eks describe-addon-versions --kubernetes-version 1.29
eksctl create addon --cluster miapp-prod --name aws-ebs-csi-driver
```

## Cluster Autoscaler vs Karpenter

| Aspecto | Cluster Autoscaler | Karpenter |
|---------|-------------------|-----------|
| Modelo | Ajusta ASG | Aprovisiona instancias directo |
| Velocidad | Minutos | Segundos |
| Consolidación | No | Sí |

## Observabilidad

```bash
aws eks create-addon --cluster-name miapp-prod \
  --addon-name amazon-cloudwatch-observability
```

## Relaciones con otros módulos

- [AKS](../AKS/) — Kubernetes en Azure
- [GKE](../GKE/) — Kubernetes en Google Cloud
- [Cloud/AWS](../../005-Cloud/AWS/) — Infraestructura base
- [Containers/Registry](../../006-Containers/Registry/) — ECR

## Recursos recomendados

- [Documentación EKS](https://docs.aws.amazon.com/eks/)
- [eksctl](https://github.com/eksctl-io/eksctl)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
