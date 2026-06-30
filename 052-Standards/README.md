# 052-Standards: Estándares Técnicos

## Descripción del dominio

Los estándares técnicos son especificaciones formales que definen cómo deben funcionar, comunicarse o construirse tecnologías, sistemas y procesos. Este módulo cubre los principales organismos de estandarización (ISO, IEEE, W3C, IETF, OASIS) y los estándares más relevantes para el desarrollo de software: formatos de datos (JSON, XML, YAML, CSV), protocolos de comunicación (HTTP, gRPC, GraphQL), codificación de caracteres (Unicode, ASCII), estándares web (HTML5, CSS3, WCAG), estándares de seguridad (TLS, OAuth, SAML), estándares de código (Google Style Guides, Microsoft Design Guidelines) y estándares de calidad (ISO 25000, CMMI). Conocer y aplicar estándares garantiza interoperabilidad, portabilidad, seguridad y mantenibilidad en los sistemas.

## Conceptos clave

- **ISO (International Organization for Standardization)**: organismo que desarrolla estándares internacionales voluntarios, como ISO 8601 (fechas), ISO 3166 (países), ISO 27001 (seguridad), ISO 9001 (calidad)
- **IEEE (Institute of Electrical and Electronics Engineers)**: estándares de ingeniería eléctrica y computación, como IEEE 754 (punto flotante), IEEE 802.3 (Ethernet), IEEE 802.11 (WiFi)
- **W3C (World Wide Web Consortium)**: estándares web: HTML5, CSS3, DOM, WebAssembly, WCAG (accesibilidad), RDF, SPARQL
- **IETF (Internet Engineering Task Force)**: produce RFCs que definen protocolos de internet: HTTP/1.1, HTTP/2, HTTP/3, TLS 1.3, TCP, IP, DNS, WebSocket
- **OASIS (Organization for the Advancement of Structured Information Standards)**: estándares para intercambio de datos: XML, SAML, DocBook, OpenDocument
- **RFC (Request for Comments)**: documentos técnicos que definen protocolos, procedimientos y formatos de internet; numerados secuencialmente (RFC 2616, RFC 7540, etc.)
- **Estándares de codificación**: guías de estilo que definen convenciones de nomenclatura, formato, estructura y buenas prácticas en cada lenguaje (Google Style Guides, PEP 8, StandardJS, Airbnb Style Guide)
- **Estándares de formato de datos**: JSON (ECMA-404), XML (W3C), YAML (yaml.org), CSV (RFC 4180), Protocol Buffers, Avro, Parquet
- **Semantic Versioning (SemVer)**: estándar de versionado MAJOR.MINOR.PATCH que comunica el tipo de cambios en una librería o API
- **Estándares de accesibilidad**: WCAG 2.1/2.2 (Pautas de Accesibilidad al Contenido Web), ARIA, Section 508
- **Estándares de API**: OpenAPI 3.x (Swagger), GraphQL, gRPC, JSON:API, HAL, REST (Fielding constraints)

## Tecnologías principales

| Categoría | Estándares |
|-----------|-------------|
| Web | HTML5 (W3C), CSS3 (W3C), ECMAScript/JavaScript (TC39/ECMA), WebAssembly (W3C) |
| Redes y protocolos | HTTP/1.1, HTTP/2, HTTP/3 (IETF), TLS 1.3 (IETF), WebSocket (IETF), QUIC (IETF) |
| Seguridad | OAuth 2.0 (IETF), OpenID Connect, SAML (OASIS), JWT (IETF), PKCS (RSA Labs) |
| Datos | JSON (ECMA-404), XML 1.0 (W3C), YAML (yaml.org), CSV (RFC 4180), Protocol Buffers (Google) |
| Calidad | ISO/IEC 25000 (SQuaRE), ISO 9126, CMMI, SPICE (ISO 15504) |
| Accesibilidad | WCAG 2.2 (W3C), ARIA 1.3 (W3C), Section 508 (EEUU), EN 301 549 (EU) |

## Hoja de ruta

1. **Principiante**: conocer los organismos de estandarización y su propósito; aplicar guías de estilo de código (PEP 8, StandardJS, Google Style); usar Semantic Versioning en proyectos; escribir HTML5 y CSS3 conforme a las especificaciones W3C.
2. **Intermedio**: implementar APIs RESTful siguiendo las buenas prácticas y estándares (OpenAPI, JSON:API); configurar OAuth 2.0 y OpenID Connect para autenticación; validar documentos XML/JSON contra esquemas (XSD, JSON Schema); aplicar WCAG nivel AA en interfaces web.
3. **Avanzado**: contribuir a estándares abiertos mediante comentarios en drafts públicos o implementaciones de referencia; implementar protocolos de red conforme a RFCs relevantes; diseñar formatos de datos propietarios pero compatibles con estándares existentes; certificar sistemas según ISO 27001.
4. **Experto**: participar en grupos de trabajo de organismos de estandarización (IETF WG, W3C CG); publicar Internet-Drafts o RFCs; diseñar marcos de cumplimiento normativo para toda una organización; auditar conformidad con estándares en sistemas legacy y modernos.

## Relaciones con otros módulos

- [000-Core](../000-Core/) — IEEE 754 (punto flotante), notación Big O estándar, representación de datos
- [001-Languages](../001-Languages/) — cada lenguaje sigue convenciones y estándares de codificación específicos
- [005-Cloud](../005-Cloud/) — estándares de interoperabilidad cloud (NIST SP 500-292, ISO/IEC 17203)
- [008-Networking](../008-Networking/) — RFCs de protocolos TCP/IP, HTTP, DNS, TLS
- [009-Security](../009-Security/) — estándares criptográficos (AES, RSA, SHA-3), OAuth, SAML, PKI
- [042-Documentation](../042-Documentation/) — estándares de documentación (DocBook, AsciiDoc, DITA)
- [046-BestPractices](../046-BestPractices/) — las mejores prácticas suelen basarse en o referenciar estándares formales
- [053-Compliance](../053-Compliance/) — cumplimiento normativo basado en estándares ISO, NIST, GDPR, PCI-DSS
- [057-Taxonomy](../057-Taxonomy/) — clasificación jerárquica de estándares por organismo, dominio y versión
- [059-Metadata](../059-Metadata/) — estándares de metadatos (Dublin Core, ISO 19115, MARC)

## Recursos recomendados

- **W3C**: w3.org/TR — todas las recomendaciones y notas del W3C
- **IETF RFC Editor**: rfc-editor.org — buscador de RFCs por número, autor o palabra clave
- **ISO**: iso.org — catálogo de estándares internacionales
- **IEEE Standards**: standards.ieee.org — estándares IEEE accesibles
- **OASIS**: oasis-open.org/standards — estándares abiertos para intercambio de información
- Google Style Guides: github.com/google/styleguide — guías de estilo para múltiples lenguajes
- SemVer: semver.org — especificación oficial de Semantic Versioning
- **Libro**: "HTTP: The Definitive Guide" (Gourley & Totty) — guía completa de estándares HTTP
- **Libro**: "TCP/IP Illustrated" (Stevens) — estándares de protocolos de red en detalle
