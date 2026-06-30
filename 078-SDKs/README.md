# 078-SDKs — SDKs y Librerías Cliente

## Descripción del dominio

Un SDK (Software Development Kit) es un conjunto de herramientas, librerías, documentación y ejemplos que permite a desarrolladores integrar servicios externos, APIs o plataformas en sus aplicaciones. Este módulo cubre SDKs oficiales por lenguaje, librerías cliente, generación automática de SDKs, versionado, mantenimiento y mejores prácticas para consumir y publicar SDKs.

## Conceptos clave

- **SDK (Software Development Kit)**: Paquete completo que incluye librerías, documentación, ejemplos, tools y configuraciones para integrar un servicio.
- **Client Library / API Client**: Librería que envuelve una API REST, GraphQL o gRPC para facilitar su consumo desde un lenguaje específico.
- **API Wrapper**: Capa de abstracción sobre una API que maneja autenticación, rate limiting, retries y serialización.
- **Code Generation**: Generación automática de SDKs a partir de especificaciones OpenAPI, GraphQL Schema o protobuf.
- **OpenAPI Generator**: Herramienta que genera clientes y servidores desde specs OpenAPI/Swagger.
- **Protocol Buffers / gRPC**: Definiciones `.proto` para generar clientes en múltiples lenguajes.
- **Semantic Versioning**: Versionado SemVer para SDKs, coordinado con las APIs que consumen.
- **Authentication Handling**: Manejo de tokens, API keys, OAuth2 en el SDK.
- **Retry & Backoff**: Lógica de reintentos con backoff exponencial ante fallos de red o rate limiting.
- **Rate Limiting**: Gestión de límites de tasa del lado del cliente.
- **Pagination**: Manejo de paginación en respuestas de APIs (cursor, offset, page).
- **SDK Lifecycle**: Mantenimiento, deprecación y sunset de versiones de SDK.

## Tecnologías principales

### Generación de SDKs
- **OpenAPI Generator**: openapi-generator.tech — Genera clientes en 50+ lenguajes desde OpenAPI specs.
- **GraphQL Code Generator**: the-guild.dev/graphql/codegen — Genera tipos y hooks desde Schema GraphQL.
- **protoc + protoc-gen-***: Generación de código desde archivos protobuf para gRPC.
- **Kiota**: Generador de clientes HTTP de Microsoft para OpenAPI.
- **Speakeasy**: Plataforma de generación y publicación de SDKs moderna.
- **Fern**: Generador de SDKs tipo-safe con publicación multi-lenguaje.

### Lenguajes y Ecosistemas
- **JavaScript/TypeScript**: axios, node-fetch, openapi-fetch, tRPC client.
- **Python**: requests, httpx, aiohttp, pydantic.
- **Go**: net/http, go-resty, genqlient.
- **Java**: Retrofit, OkHttp, Spring WebClient, Feign.
- **Rust**: reqwest, ureq.
- **.NET**: HttpClient, RestSharp, Refit.

### SDKs Populares
- **AWS SDK**: boto3 (Python), aws-sdk-js-v3, AWS SDK Go v2.
- **Google Cloud SDK**: google-cloud-* por servicio, generados desde protobuf.
- **Azure SDK**: azure-sdk-* por lenguaje, diseñados con directrices de Azure SDK.
- **Stripe SDK**: Client libraries oficiales para Python, Ruby, JS, Go, Java, .NET.
- **Twilio SDK**: Librerías oficiales para integración de comunicaciones.
- **OpenAI SDK**: Python, Node.js, Go, Java con clientes oficiales y comunitarios.
- **GitHub SDK**: Octokit en múltiples lenguajes.

## Hoja de ruta

1. **Principiante**: Consumir un SDK oficial (ej. Stripe, OpenAI, AWS) desde tu lenguaje. Entender autenticación, paginación y manejo de errores. Leer la documentación del SDK.
2. **Intermedio**: Generar un SDK cliente desde una OpenAPI spec usando OpenAPI Generator. Personalizar la configuración de generación. Manejar rate limiting y retries. Contribuir a SDKs open-source.
3. **Avanzado**: Diseñar y publicar SDKs multi-lenguaje desde cero. Mantener SDKs con CI/CD, tests automatizados y generación de documentación. Implementar code generators personalizados con mustache/handlebars. Gestionar deprecación y sunset de versiones de SDK.

## Relaciones con otros módulos

- [`../079-APIs/`](../079-APIs/) — Los SDKs son la interfaz de consumo de APIs; la especificación OpenAPI/GraphQL es la fuente para generarlos.
- [`../071-Releases/`](../071-Releases/) — Publicación de SDKs en registries (npm, PyPI) con versionado SemVer.
- [`../074-Tools/`](../074-Tools/) — Herramientas CLI y generadores de código para SDKs.
- [`../077-CLI/`](../077-CLI/) — CLIs que envuelven SDKs (AWS CLI, gcloud, gh CLI).
- [`../042-Documentation/`](../042-Documentation/) — Documentación de SDKs con ejemplos de uso, guías de inicio rápido y API reference.
- [`../001-Languages/`](../001-Languages/) — Idiomas objetivo para los SDKs generados.
- [`../013-DevOps/`](../013-DevOps/) — Pipelines de build, test y publicación de SDKs.

## Recursos recomendados

- [OpenAPI Generator](https://openapi-generator.tech/) — Generación de SDKs desde OpenAPI.
- [Azure SDK Guidelines](https://azure.github.io/azure-sdk/) — Directrices de diseño de SDKs de Azure.
- [Stripe SDK Docs](https://stripe.com/docs/libraries) — Documentación de SDKs de Stripe como referencia de diseño.
- [Google API Client Libraries](https://developers.google.com/api-client-library) — SDKs de Google Cloud.
- [Speakeasy](https://speakeasy.com/) — Plataforma moderna de generación de SDKs.
- [GraphQL Code Generator](https://the-guild.dev/graphql/codegen) — Generación de código desde GraphQL.
