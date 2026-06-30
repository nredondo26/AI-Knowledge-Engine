# 079-APIs — APIs y Endpoints

## Descripción del dominio

Las APIs (Application Programming Interfaces) son el mecanismo fundamental de comunicación entre sistemas distribuidos. Este módulo abarca los principales estilos de API —REST, GraphQL, gRPC, WebSocket— así como el diseño, versionado, documentación, seguridad y mejores prácticas para construir APIs robustas y escalables.

## Conceptos clave

- **REST (Representational State Transfer)**: Estilo arquitectónico basado en recursos identificados por URLs, operaciones HTTP (GET, POST, PUT, PATCH, DELETE) y representaciones (JSON, XML).
- **GraphQL**: Lenguaje de consulta que permite al cliente solicitar exactamente los datos que necesita, reduciendo over-fetching y under-fetching.
- **gRPC**: Framework RPC de alto rendimiento que usa Protocol Buffers y HTTP/2, ideal para comunicación entre microservicios.
- **WebSocket**: Protocolo de comunicación bidireccional en tiempo real sobre TCP, usado para chats, notificaciones, streaming.
- **Endpoint**: URL específica donde una API expone un recurso o funcionalidad.
- **OpenAPI (Swagger)**: Especificación estándar para describir APIs REST (endpoints, parámetros, respuestas, autenticación).
- **API Versioning**: Estrategias para versionar APIs (URL path: `/v1/`, header, query parameter).
- **Pagination**: Técnicas para dividir respuestas grandes (offset/limit, cursor-based, keyset pagination).
- **Rate Limiting**: Control de frecuencia de requests para proteger el servidor y asegurar fairness.
- **Authentication & Authorization**: Mecanismos de seguridad (API Keys, JWT, OAuth2, OpenID Connect).
- **Idempotency**: Propiedad de operaciones que pueden ejecutarse múltiples veces sin efectos secundarios.
- **HATEOAS**: Hypermedia as the Engine of Application State — REST nivel 3 de madurez de Richardson.
- **API Gateway**: Punto de entrada único que gestiona autenticación, rate limiting, routing y transformación.
- **Webhook**: Callback HTTP que notifica eventos a sistemas externos.
- **Server-Sent Events (SSE)**: Stream unidireccional de eventos desde servidor a cliente sobre HTTP.

## Tecnologías principales

### Frameworks y Herramientas de API
- **Express / Fastify (Node.js)**: Frameworks REST para JavaScript/TypeScript.
- **FastAPI / Django REST (Python)**: Frameworks modernos para APIs REST en Python.
- **Spring Boot (Java)**: Framework enterprise con soporte REST y gRPC.
- **Go net/http / Gin / Fiber**: Frameworks REST para Go.
- **Apollo / Yoga (GraphQL)**: Servidores GraphQL para Node.js.
- **gRPC / protobuf**: Framework RPC con code generation multi-lenguaje.
- **WebSocket (ws, Socket.IO)**: Librerías para comunicación bidireccional.

### Documentación y Testing
- **Swagger UI / OpenAPI**: Visualización interactiva de especificaciones OpenAPI.
- **Postman / Insomnia**: Clientes GUI para probar APIs.
- **Redoc**: Generador de documentación OpenAPI con diseño limpio.
- **Stoplight**: Plataforma de diseño y documentación de APIs.
- **Bruno**: Cliente API offline con almacenamiento local de colecciones.
- **Hoppscotch**: Cliente API web open-source.

### API Gateways y Management
- **Kong**: API Gateway open-source.
- **Traefik**: Proxy inverso y API Gateway con auto-descubrimiento.
- **AWS API Gateway**: Servicio gestionado de API Gateway en AWS.
- **Apigee (Google)**: Plataforma enterprise de gestión de APIs.
- **NGINX**: Proxy inverso que funciona como API Gateway.

## Hoja de ruta

1. **Principiante**: Entender HTTP methods, status codes y estructura REST. Crear una API REST simple con tu framework favorito. Usar Postman o Bruno para probar endpoints. Leer especificaciones OpenAPI básicas.
2. **Intermedio**: Diseñar APIs con versionado y paginación. Documentar APIs con OpenAPI/Swagger. Implementar autenticación JWT/OAuth2. Probar con tests automatizados. Usar API Gateway.
3. **Avanzado**: Implementar GraphQL y gRPC. Diseñar APIs event-driven con WebHooks. Optimizar rendimiento con caching y rate limiting. Aplicar API-first design con contratos OpenAPI. Implementar API versioning con sunset policies. Monitorizar APIs con métricas y alertas.

## Relaciones con otros módulos

- [`../078-SDKs/`](../078-SDKs/) — Los SDKs son clientes generados a partir de especificaciones de API (OpenAPI, GraphQL Schema, protobuf).
- [`../010-Architecture/`](../010-Architecture/) — Diseño arquitectónico de APIs (microservicios, API Gateway, event-driven).
- [`../008-Networking/`](../008-Networking/) — Protocolos HTTP/2, gRPC, WebSocket sobre TCP/IP.
- [`../009-Security/`](../009-Security/) — Autenticación, autorización, OWASP API Security Top 10.
- [`../012-Testing/`](../012-Testing/) — Testing de APIs (unit, integration, contract, e2e).
- [`../047-Troubleshooting/`](../047-Troubleshooting/) — Debugging de APIs con curl, Postman, logs.
- [`../013-DevOps/`](../013-DevOps/) — Despliegue, escalado y monitorización de APIs.

## Recursos recomendados

- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html) — Especificación oficial de OpenAPI.
- [REST API Tutorial](https://restfulapi.net/) — Guía completa de diseño REST.
- [GraphQL Official Docs](https://graphql.org/learn/) — Documentación oficial de GraphQL.
- [gRPC Documentation](https://grpc.io/docs/) — Documentación oficial de gRPC.
- [OWASP API Security Top 10](https://owasp.org/www-project-api-security/) — Vulnerabilidades de seguridad en APIs.
- [WebSocket RFC 6455](https://datatracker.ietf.org/doc/html/rfc6455) — Especificación oficial de WebSocket.
- [Microsoft API Guidelines](https://github.com/microsoft/api-guidelines) — Guías de diseño de APIs de Microsoft.
- [JSON:API](https://jsonapi.org/) — Especificación para APIs JSON.
