# 044-ReferenceProjects: Proyectos de Referencia

## Descripción del dominio

Los proyectos de referencia son implementaciones canónicas que ejemplifican buenas prácticas, arquitecturas probadas y patrones de diseño recomendados para tipos específicos de sistemas. Este módulo cataloga proyectos demo, arquitecturas de ejemplo y aplicaciones de referencia que sirven como punto de partida para nuevos desarrollos, materiales de aprendizaje y estándares internos de calidad. Cada proyecto de referencia documenta no solo el código, sino las decisiones arquitectónicas, compensaciones (trade-offs) y principios aplicados, proporcionando un modelo reproducible para equipos de desarrollo.

## Conceptos clave

- **Implementaciones canónicas**: Código ejemplar que sigue las mejores prácticas reconocidas para un stack o dominio específico
- **Arquitecturas de ejemplo**: Diagramas y descripciones de arquitecturas de sistemas reales (monolíticas, microservicios, event-driven, serverless)
- **Proyectos demo**: Aplicaciones funcionales limitadas que demuestran una tecnología o concepto específico
- **Repositorios de aprendizaje**: Proyectos diseñados específicamente para enseñar una tecnología (todo-app, e-commerce, blog engine)
- **Referencias de integración**: Ejemplos de cómo integrar múltiples tecnologías (API Gateway + Lambda + DynamoDB, Kafka + Flink + Cassandra)
- **Referencias multiplataforma**: Misma aplicación implementada en diferentes stacks (Node vs Go vs Python, React vs Vue vs Svelte)
- **Estándares de proyecto**: README, licencia, contribución, código de conducta, issues y PR templates
- **Documentación arquitectónica**: ADRs (Architecture Decision Records), C4 diagrams, documentos de diseño
- **Benchmarks**: Comparativas de rendimiento entre diferentes aproximaciones implementadas como proyectos de referencia
- **Migraciones**: Proyectos que muestran migración de una arquitectura/tecnología a otra (monolith a microservices, REST a GraphQL)

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Repositorios de referencia | GitHub Awesome Lists, Microsoft Patterns & Practices, AWS Reference Architectures |
| Plataformas demo | Heroku, Vercel, Netlify, Railway, Fly.io (deploy rápido de proyectos de referencia) |
| Frameworks de ejemplo | Next.js Examples, Django Demo App, Spring PetClinic, Go Clean Architecture |
| Arquitecturas cloud | AWS Well-Architected Labs, GCP Architectures, Azure Reference Architectures |
| Patrones de microservicios | eShopOnContainers (Microsoft), Sock Shop (Weaveworks), Online Boutique (Google) |
| IA/ML ejemplos | Hugging Face Examples, TensorFlow Models, PyTorch Image Models (timm), MLflow Examples |

## Hoja de ruta

1. **Principiante**: Exploración de repositorios de referencia (PetClinic, TodoMVC) — comprensión de estructura y README — replicación de proyectos demo
2. **Intermedio**: Análisis de ADRs y documentos de diseño — ejecución de proyectos de referencia localmente — contribución menor a proyectos demo
3. **Avanzado**: Creación de proyectos de referencia para el equipo/organización — documentación de decisiones arquitectónicas — implementación de benchmarks comparativos
4. **Experto**: Mantenimiento de un catálogo completo de referencias — automatización de validación — referencias multi-lenguaje y multi-nube — enseñanza mediante proyectos de referencia

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — Principios arquitectónicos que se ejemplifican en los proyectos de referencia
- [043-Templates](../043-Templates/) — Plantillas que se derivan de proyectos de referencia exitosos
- [046-BestPractices](../046-BestPractices/) — Buenas prácticas codificadas en los proyectos de referencia
- [063-Examples](../063-Examples/) — Subconjunto de proyectos de referencia enfocados en ejemplos específicos
- [011-DesignPatterns](../011-DesignPatterns/) — Patrones de diseño aplicados en las implementaciones de referencia
- [013-DevOps](../013-DevOps/) — Configuración DevOps de los proyectos de referencia (Docker, CI/CD)
- [074-Tools](../074-Tools/) — Herramientas utilizadas en los proyectos de referencia

## Recursos recomendados

- **Repositorios**: "PetClinic" (Spring), "eShopOnContainers" (.NET), "Sock Shop" (Microservices), "RealWorld" (Conduit)
- **AWS**: AWS Reference Architecture Diagrams, AWS Well-Architected Framework, AWS Samples GitHub
- **Microsoft**: Microsoft Patterns & Practices, .NET Architecture Guides (eBooks + code)
- **Google**: Google Cloud Architecture Center, Cloud Foundation Toolkit
- **Awesome Lists**: "Awesome Architecture", "Awesome Microservices", "Awesome System Design", "Awesome Production ML"
