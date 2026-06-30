# 065-Workflows: Flujos de Trabajo

## Descripción del dominio

Los flujos de trabajo (workflows) son secuencias orquestadas de tareas que transforman datos, ejecutan procesos o coordinan sistemas distribuidos. Este módulo cubre motores de workflow tanto generales como especializados para IA: Temporal (orquestación de microservicios con durabilidad), Apache Airflow (programación y monitoreo de pipelines de datos), Prefect (orquestación de flujos con Python nativo) y Luigi (construcción de pipelines de datos). Se incluyen DAGs (Directed Acyclic Graphs) como representación común de workflows, estrategias de manejo de errores y reintentos, y patrones de pipelines para ETL, procesamiento de datos e IA generativa.

## Conceptos clave

- **DAG (Directed Acyclic Graph)**: Representación de workflow como grafo acíclico dirigido — nodos = tareas, aristas = dependencias — usado en Airflow (DAG files), Prefect (flows), Temporal (workflows) y sistemas de CI/CD
- **Temporal**: Motor de orquestación duradero — workflows como código (Java, Go, Python, TypeScript) — replay seguro — actividad y workflow — history replay — task queues — retry policies automáticas
- **Apache Airflow**: Programación y monitoreo de pipelines — DAGs en Python — operadores (PythonOperator, BashOperator, DockerOperator, KubernetesPodOperator) — XCom para paso de datos entre tareas — sensores y triggers
- **Prefect**: Orquestación moderna con Python nativo — @flow y @task decorators — automatic retries, caching, timeouts — Prefect Cloud y Prefect Server — pestañas de monitoreo UI — blocks para conexiones externas
- **Luigi**: Pipeline builder de Spotify — @requires y @run — target persistente (HDFS, S3, local) — parameter binding — date parametrization para pipelines temporales
- **LangGraph**: Framework para workflows de agentes — grafos cíclicos permitidos (ReAct loops) — estados compartidos entre nodos — compilación a ejecutable — integración con LangChain
- **Patrones de workflow**: Pipeline secuencial, fan-out/fan-in (paralelización), branching condicional, retry con backoff, circuit breaker, saga pattern (compensación de transacciones)
- **Observabilidad**: SLA monitoring, logging estructurado (ELK/Loki), métricas (Prometheus, Datadog), tracing distribuido (OpenTelemetry), alertas en Airflow (PagerDuty, Slack)
- **State machines**: Representación formal de estados y transiciones — Workflows como máquinas de estado (AWS Step Functions) — event-driven workflows con Apache Kafka/Flink

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Motores de workflow | Temporal, Airflow, Prefect, Luigi, Argo Workflows, AWS Step Functions |
| Procesamiento de datos | Apache Beam, Apache Spark, Flink, dbt (data build tool), Dagster |
| Orquestación de agentes | LangGraph, LangChain, AutoGen, CrewAI, Semantic Kernel |
| Colas de mensajes | RabbitMQ, Apache Kafka, Redis Streams, AWS SQS, Google Pub/Sub |
| Programación | cron, Apache Quartz, AWS EventBridge, Google Cloud Scheduler |
| Monitorización | Airflow UI/API, Prefect UI, Temporal Web UI, MLflow, Prometheus + Grafana |
| Infraestructura | Docker Compose, Kubernetes, Helm, Terraform, Pulumi |

## Hoja de ruta

1. **Principiante**: Concepto de pipeline y DAG — Airflow: instalación local y primer DAG simple — Prefect: @flow y @task básicos — ejecución secuencial de tareas — programación con cron/schedule
2. **Intermedio**: Dependencias complejas entre tareas — paso de datos entre tareas (XCom, Prefect results) — reintentos y manejo de errores — paralelización fan-out/fan-in — integración con Docker y bases de datos — Temporal: primer workflow durable
3. **Avanzado**: Deployment de Airflow en Kubernetes (Helm chart) — Prefect Cloud con auto-scaling — Temporal: workflow con actividades largas, señales y queries — DAGs dinámicos en Airflow — monitoreo y alertas — SLAs y timeouts — integración con APIs externas
4. **Experto**: Workflows híbridos (event-driven + scheduled) — LangGraph para agentes complejos — patrones saga para transacciones distribuidas — optimización de recursos (auto-scaling workers) — migración entre motores (Airflow → Prefect → Temporal) — pipelines RAG con monitoreo continuo de calidad

## Relaciones con otros módulos

- [064-Agents](../064-Agents/) — LangGraph y flujos con agentes como extensión de workflows
- [034-LLM](../034-LLM/) — Pipelines de inferencia batch y workflows de fine-tuning
- [035-RAG](../035-RAG/) — Workflows de ingestión, chunking, embedding y actualización de documentos
- [014-CICD](../014-CICD/) — Pipelines de CI/CD como workflows de construcción y despliegue
- [013-DevOps](../013-DevOps/) — Infraestructura para ejecución de workflows a escala
- [063-Examples](../063-Examples/) — Ejemplos prácticos de workflows en diferentes motores
- [033-DeepLearning](../033-DeepLearning/) — Workflows de entrenamiento y evaluación de modelos (MLflow, Kubeflow)
- [097-Observability](../097-Observability/) — Monitoreo y trazabilidad de ejecuciones de workflow

## Recursos recomendados

- **Documentación oficial**: Temporal.io SDK Docs, Apache Airflow Docs, Prefect Docs, Luigi Docs, LangGraph Docs
- **Papers**: "Temporal: A Protocol for Durable Execution of Workflows" (Whittaker et al., 2023); "Airflow: A Workflow Management Platform" (Beauchemin, 2019)
- **Cursos**: Apache Airflow Fundamentals (Astronomer), Prefect Workshop, Temporal 101 (Temporal.io), LangGraph Academy
- **Herramientas**: Astronomer (Airflow managed), Prefect Cloud, Temporal Cloud, Argo Workflows, Dagster
