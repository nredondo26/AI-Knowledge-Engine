# Amazon ECS — Elastic Container Service

## Descripción

Amazon ECS es el orquestador de contenedores gestionado de AWS. Soporta **EC2** (control sobre instancias) y **Fargate** (serverless). No requiere gestionar control plane de Kubernetes.

## Arquitectura

- **Clúster**: Grupo lógico de recursos (EC2 o Fargate)
- **Task definition**: Plantilla JSON/YAML con contenedores, recursos, puertos
- **Task**: Instancia de una task definition
- **Service**: Mantiene tasks deseables + ELB + auto-scaling

## Task definition (Fargate)

```json
{
  "family": "miapp-api",
  "taskRoleArn": "arn:aws:iam::123456789012:role/ecsTaskRole",
  "executionRoleArn": "arn:aws:iam::123456789012:role/ecsExecutionRole",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024",
  "containerDefinitions": [
    {
      "name": "api",
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/miapp:latest",
      "essential": true,
      "portMappings": [{"containerPort": 3000}],
      "environment": [{"name": "NODE_ENV", "value": "production"}],
      "secrets": [{"name": "DB_PASSWORD", "valueFrom": "arn:aws:ssm:us-east-1:123456789012:parameter/db/password"}],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/miapp",
          "awslogs-region": "us-east-1"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"],
        "interval": 30, "timeout": 5, "retries": 3
      }
    }
  ]
}
```

## Servicio con Terraform

```hcl
resource "aws_ecs_cluster" "main" {
  name = "miapp-cluster"
  setting { name = "containerInsights", value = "enabled" }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "miapp-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  container_definitions    = jsonencode([{
    name  = "api"
    image = "${aws_ecr_repository.miapp.repository_url}:latest"
    essential = true
    portMappings = [{ containerPort = 3000 }]
  }])
}

resource "aws_ecs_service" "api" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 3
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs.id]
  }
}
```

## Auto-scaling

```hcl
resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = 20
  min_capacity       = 2
  resource_id        = "service/miapp-cluster/api-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70
  }
}
```

## Comandos AWS CLI

```bash
aws ecs list-clusters
aws ecs list-services --cluster miapp-cluster
aws ecs update-service --cluster miapp-cluster --service api \
  --force-new-deployment --desired-count 5
aws ecs run-task --cluster miapp-cluster \
  --task-definition miapp-api --count 1 --launch-type FARGATE
```

## ECS Anywhere (híbrido)

```bash
aws ssm activate --registration-code <code> --activation-code <code>
aws ecs register-container-instance --cluster miapp-cluster
```

## Relaciones con otros módulos

- [EKS](../EKS/) — Kubernetes gestionado en AWS
- [Cloud/AWS](../../005-Cloud/AWS/) — Infraestructura base (VPC, IAM, ALB)
- [Containers/Registry](../../006-Containers/Registry/) — Amazon ECR

## Recursos recomendados

- [Documentación ECS](https://docs.aws.amazon.com/ecs/)
- [ECS Workshop](https://ecsworkshop.com/)
- [Fargate](https://aws.amazon.com/fargate/)
