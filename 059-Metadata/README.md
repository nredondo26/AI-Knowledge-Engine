# 059-Metadata: Metadatos

## Descripción del dominio

Los metadatos son "datos sobre datos": información estructurada que describe, explica, localiza o facilita la gestión de un recurso digital. En el contexto del AI-Knowledge-Engine, los metadatos permiten etiquetar, clasificar, buscar y relacionar todo el contenido del repositorio de manera consistente y automatizable. Este módulo cubre los esquemas de metadatos más relevantes (Dublin Core, Schema.org, MARC, MODS, PREMIS), metadatos incrustados en archivos (frontmatter YAML/TOML en Markdown), metadatos técnicos (EXIF para imágenes, ID3 para audio, etc.), metadatos de contenido (tags, categorías, descripciones, autor, fecha, versión) y sistemas de etiquetado (folksonomías, vocabularios controlados, taxonomías). Una estrategia sólida de metadatos es fundamental para la gobernanza de la información, la interoperabilidad entre sistemas y la escalabilidad del conocimiento.

## Conceptos clave

- **Dublin Core**: conjunto de 15 elementos básicos de metadatos (DC): Title, Creator, Subject, Description, Publisher, Contributor, Date, Type, Format, Identifier, Source, Language, Relation, Coverage, Rights. Estándar ISO 15836.
- **Schema.org**: vocabulario colaborativo de datos estructurados utilizado por Google, Bing, Yahoo y Yandex para markup semántico en la web; define tipos como `TechArticle`, `Course`, `SoftwareApplication`, `Person`, `Organization`.
- **Frontmatter**: bloque de metadatos al inicio de archivos Markdown, delimitado por `---`, usualmente en YAML, TOML o JSON. Ejemplo: `--- title: "Introducción a Kubernetes" tags: [kubernetes, containers, devops] ---`.
- **MARC (Machine-Readable Cataloging)**: estándar bibliotecario para representación de metadatos de recursos bibliográficos; ampliamente usado en bibliotecas universitarias y nacionales.
- **PREMIS (Preservation Metadata Implementation Strategies)**: estándar para metadatos de preservación digital: origen, autenticidad, integridad, cadena de custodia.
- **MODS (Metadata Object Description Schema)**: esquema XML para metadatos bibliográficos, más rico que Dublin Core pero más simple que MARC.
- **Vocabulario controlado**: lista predefinida de términos autorizados para valores de metadatos (ej. lista cerrada de tags, categorías o tipos de contenido).
- **Tagging vs. Classification**: tagging (etiquetado libre, folksonómico) permite cualquier etiqueta; classification (clasificación controlada) restringe a términos de un vocabulario autorizado.
- **Metadatos descriptivos vs. estructurales vs. administrativos**: descriptivos describen el contenido (título, resumen); estructurales describen la organización interna (capítulos, secciones); administrativos describen la gestión del recurso (licencia, fecha de creación, versiones).
- **Linked Data y metadatos enlazados**: uso de URIs como identificadores globales para que los metadatos sean enlazables y consultables a través de la web (JSON-LD, RDFa, Microdata).
- **Open Graph Protocol (OGP)**: estándar de metadatos para integrar contenido web en redes sociales (Facebook, Twitter, LinkedIn); usa etiquetas `<meta property="og:title">` en HTML.

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Esquemas de metadatos | Dublin Core (ISO 15836), Schema.org, MARC21, MODS, PREMIS, METS, LOM (Learning Object Metadata) |
| Formatos de serialización | YAML, TOML, JSON, XML, RDF/XML, JSON-LD, Turtle, N-Triples |
| Frontmatter en MD | YAML frontmatter (Jekyll, Hugo, MkDocs), TOML frontmatter (Zola) |
| Extracción y gestión | ExifTool, Apache Tika, MediaInfo, Mutagen (Python) |
| Validación | JSON Schema, XML Schema (XSD), ShEx, SHACL (validación de grafos RDF) |
| Motores de búsqueda | Elasticsearch (mapeo de metadatos), Algolia, Meilisearch, Typesense |
| CMS y SSG | Hugo, Jekyll, MkDocs, Docusaurus, Strapi, WordPress (campos personalizados) |
| Headless CMS | Contentful, Sanity, Strapi, Directus (gestión de metadatos como contenido) |

## Hoja de ruta

1. **Principiante**: comprender los 15 elementos de Dublin Core y su propósito; agregar frontmatter YAML básico a documentos Markdown (título, descripción, fecha, tags); usar etiquetas libres para clasificar contenido inicialmente; explorar Schema.org y Open Graph en páginas web.
2. **Intermedio**: definir un vocabulario controlado de tags y categorías para el repositorio; implementar metadatos estructurales (relaciones entre documentos: padre/hijo, siguiente/anterior); validar metadatos con esquemas JSON Schema o YAML; extraer metadatos automáticamente de archivos con ExifTool o Apache Tika.
3. **Avanzado**: diseñar un esquema de metadatos completo usando Dublin Core + extensiones por dominio; integrar metadatos en el sistema de búsqueda (Elasticsearch) con mapeos optimizados; implementar markup Schema.org en la documentación publicada; automatizar la generación y actualización de metadatos en pipelines CI/CD.
4. **Experto**: contribuir a vocabularios de metadatos abiertos (Schema.org, Dublin Core); implementar linked data con JSON-LD y URIs para todos los recursos del repositorio; diseñar estrategias de interoperabilidad de metadatos entre sistemas heterogéneos; auditar la calidad y consistencia de los metadatos periódicamente (completitud, precisión, actualización).

## Relaciones con otros módulos

- [042-Documentation](../042-Documentation/) — la documentación se beneficia de metadatos para búsqueda, navegación y versionado
- [043-Templates](../043-Templates/) — plantillas de frontmatter y metadatos reutilizables para nuevos documentos
- [050-LearningPaths](../050-LearningPaths/) — metadatos para clasificar rutas de aprendizaje por rol, nivel y tecnología
- [052-Standards](../052-Standards/) — estándares de metadatos (Dublin Core ISO 15836, MARC, Schema.org)
- [053-Compliance](../053-Compliance/) — metadatos de compliance (fechas de auditoría, evidencias, clasificación de datos)
- [055-Checklists](../055-Checklists/) — metadatos para versionar checklists (autor, fecha última revisión, aprobación)
- [056-Glossary](../056-Glossary/) — metadatos para términos del glosario (dominio, sinónimos, referencias cruzadas)
- [057-Taxonomy](../057-Taxonomy/) — la taxonomía usa metadatos para describir categorías y sus relaciones
- [058-KnowledgeGraph](../058-KnowledgeGraph/) — los metadatos enriquecen atributos de nodos y aristas del grafo de conocimiento

## Recursos recomendados

- **Dublin Core Metadata Initiative**: dublincore.org — esquemas, guías y documentación de Dublin Core
- **Schema.org**: schema.org — vocabulario de datos estructurados para la web
- **Open Graph Protocol**: ogp.me — estándar de metadatos para integración en redes sociales
- **YAML Frontmatter**: jekyllrb.com/docs/front-matter/ — sintaxis y ejemplos de frontmatter en Jekyll
- **JSON-LD W3C**: w3.org/TR/json-ld11 — formato de linked data basado en JSON
- **ExifTool**: exiftool.org — herramienta de línea de comandos para leer, escribir y editar metadatos
- **Apache Tika**: tika.apache.org — toolkit de extracción de metadatos y contenido de documentos
- **PREMIS**: loc.gov/standards/premis/ — metadatos de preservación digital
- **ISO 15836**: estándar Dublin Core (Information and documentation — The Dublin Core metadata element set)
- **Google Structured Data Testing Tool**: search.google.com/test/rich-results — validador de Schema.org
