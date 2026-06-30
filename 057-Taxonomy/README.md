# 057-Taxonomy: Taxonomía del Conocimiento

## Descripción del dominio

La taxonomía del conocimiento es la disciplina que clasifica y organiza jerárquicamente los conceptos, tecnologías y dominios del ecosistema de ingeniería de software. Una taxonomía bien definida establece relaciones de herencia (es-un), composición (parte-de) y dependencia (requiere-a) entre los elementos del conocimiento, creando un marco consistente para la navegación, búsqueda y aprendizaje. Este módulo define la taxonomía completa del repositorio AI-Knowledge-Engine, categorizando cada módulo, sub-área y concepto en una estructura de árbol navegable. La taxonomía sirve como columna vertebral para el grafo de conocimiento, el glosario y la documentación interconectada, permitiendo a los usuarios explorar el contenido desde lo general a lo específico y descubrir relaciones que de otra manera pasarían desapercibidas.

## Conceptos clave

- **Taxonomía formal**: clasificación jerárquica donde cada elemento tiene un padre y puede tener múltiples hijos, formando una estructura de árbol
- **Ontología**: representación formal y explícita de una conceptualización compartida; incluye clases, relaciones, atributos y restricciones; va más allá de la taxonomía al permitir relaciones arbitrarias entre conceptos
- **Folksonomía**: clasificación colaborativa mediante etiquetas (tags) libres, sin jerarquía predefinida; usada en plataformas como Stack Overflow, Dev.to, Medium
- **Tesauro**: vocabulario controlado que incluye términos, sinónimos, términos relacionados (RT), términos más generales (BT), términos más específicos (NT) y términos preferidos (USE/UF)
- **SKOS (Simple Knowledge Organization System)**: estándar W3C para representar tesauros, taxonomías y sistemas de clasificación en RDF/OWL
- **Facetas**: dimensiones ortogonales de clasificación que permiten filtrar conceptos por múltiples criterios simultáneamente (ej. por dominio, nivel de dificultad, tecnología asociada, tipo de contenido)
- **Categorización automática**: uso de NLP y machine learning para asignar automáticamente conceptos a categorías taxonómicas basándose en su contenido textual
- **Jerarquía de navegación**: estructura breadcrumb que muestra la ruta desde la raíz hasta el concepto actual (Fundamentos > Algoritmos > Ordenamiento > QuickSort)
- **Taxonomía plana vs. jerárquica**: taxonomía plana usa una sola lista plana de categorías; la jerárquica permite profundidad (subcategorías, sub-subcategorías)
- **Polyhierarchy**: capacidad de que un concepto pertenezca a múltiples ramas de la taxonomía simultáneamente (ej. "Autenticación" puede estar en Seguridad y en Desarrollo Web)

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Esquemas de representación | SKOS (W3C), OWL (W3C), RDF (W3C), JSON-LD, Schema.org |
| Bases de datos de grafos | Neo4j, Amazon Neptune, ArangoDB, JanusGraph, Apache TinkerPop |
| Herramientas de modelado | Protégé (Stanford), TopBraid Composer, PoolParty, Synaptica |
| Vocabularios controlados | Dublin Core, MARC, LOC Subject Headings, MeSH, ACM Computing Classification System |
| Indexación y búsqueda | Elasticsearch, Apache Solr, Algolia, Typesense, Meilisearch |
| NLP para extracción de conceptos | spaCy, Stanford NLP, NLTK, BERTopic, TextRazor |
| Frameworks de ontologías | RDFLib, Apache Jena, OWL API, GraphDB (ontop) |
| Visualización | WebVOWL, OntoGraph, Graphviz, D3.js (jerarquías radiales, tree maps) |

## Hoja de ruta

1. **Principiante**: entender la diferencia entre taxonomía, ontología y folksonomía; examinar clasificaciones existentes (ACM CCS, MeSH, DMOZ); crear una taxonomía simple para un proyecto pequeño (máximo 3 niveles de profundidad); documentar las categorías y su propósito.
2. **Intermedio**: diseñar una taxonomía formal con relaciones BT/NT/RT (siguiendo estándares de tesauro); implementar la taxonomía en SKOS/RDF; integrar la taxonomía en un motor de búsqueda para mejorar la relevancia de resultados; usar facetas para filtrar contenido por múltiples dimensiones.
3. **Avanzado**: modelar ontologías OWL con relaciones complejas (transitivas, simétricas, funcionales); almacenar la ontología en una base de datos de grafos (Neo4j, Amazon Neptune); automatizar la clasificación de contenido nuevo usando NLP y modelos de lenguaje; validar la consistencia de la ontología con razonadores (Pellet, HermiT).
4. **Experto**: diseñar sistemas de conocimiento híbridos (taxonomía + folksonomía + ontología); contribuir a ontologías y vocabularios estandarizados (Schema.org, Wikidata, DBpedia); publicar datasets de taxonomías como linked data; integrar la taxonomía en sistemas de recomendación y descubrimiento de conocimiento.

## Relaciones con otros módulos

- [000-Core](../000-Core/) — la taxonomía clasifica los fundamentos de computación en sub-áreas (algoritmos, datos, memoria)
- [042-Documentation](../042-Documentation/) — la documentación se organiza según la estructura taxonómica
- [052-Standards](../052-Standards/) — estándares de representación de taxonomías (SKOS, OWL, RDF, Schema.org)
- [053-Compliance](../053-Compliance/) — taxonomía de requisitos normativos por regulación y dominio
- [056-Glossary](../056-Glossary/) — el glosario proporciona las definiciones de los conceptos que la taxonomía organiza
- [058-KnowledgeGraph](../058-KnowledgeGraph/) — la taxonomía es la estructura jerárquica que alimenta el grafo de conocimiento
- [059-Metadata](../059-Metadata/) — metadatos asociados a categorías taxonómicas (etiquetas, descripciones, fechas)

## Recursos recomendados

- **SKOS W3C**: w3.org/TR/skos-reference — guía de referencia de SKOS (Simple Knowledge Organization System)
- **OWL W3C**: w3.org/TR/owl2-primer — introducción a OWL 2, el lenguaje de ontologías web
- **Protégé**: protege.stanford.edu — editor de ontologías open source de la Universidad de Stanford
- **ACM Computing Classification System (CCS)**: acm.org/publications/class-2012 — taxonomía estándar de la computación
- **Schema.org**: schema.org — vocabulario colaborativo de datos estructurados en la web
- **Dublin Core**: dublincore.org — estándar de metadatos para recursos digitales
- **Libro**: "Ontology Engineering" (Elisa Kendall, Deborah McGuinness) — metodología de diseño ontológico
- **Libro**: "The Discipline of Organizing" (Robert J. Glushko) — principios de organización de información
