# 051-Diagrams: Diagramas Técnicos

## Descripción del dominio

Los diagramas técnicos son representaciones visuales que permiten comunicar la estructura, el comportamiento y las relaciones de un sistema de software de manera clara y sin ambigüedades. Este módulo cubre las principales herramientas y notaciones para crear diagramas: Mermaid (diagramas como código), PlantUML, DrawIO, Structurizr y el modelo C4 para arquitectura de software. También incluye diagramas de infraestructura, flujo de datos, secuencia, estado, componentes y despliegue. El uso sistemático de diagramas mejora la documentación, facilita las revisiones de diseño, alinea a los equipos multidisciplinarios y sirve como fuente única de verdad para la arquitectura del sistema.

## Conceptos clave

- **Modelo C4**: Contexto, Contenedores, Componentes, Código — cuatro niveles de abstracción para visualizar la arquitectura de software, propuesto por Simon Brown
- **Diagrama de contexto (C1)**: visión general del sistema, sus usuarios y sus relaciones con sistemas externos
- **Diagrama de contenedores (C2)**: descomposición en aplicaciones, bases de datos, APIs, colas de mensajes y cómo se comunican
- **Diagrama de componentes (C3)**: detalle interno de cada contenedor, mostrando módulos, servicios y sus interfaces
- **Diagrama de código (C4)**: nivel más detallado, equivalente a diagramas de clases UML o entidades del modelo de datos
- **Mermaid**: lenguaje de diagramas basado en markdown que se renderiza en GitHub, GitLab y herramientas de documentación
- **PlantUML**: herramienta open source que genera diagramas UML a partir de texto descriptivo
- **DrawIO / diagrams.net**: editor gráfico colaborativo para diagramas técnicos, integrable con VS Code y Google Drive
- **Structurizr**: herramienta diseñada específicamente para el modelo C4, con capacidad de renderizado y validación
- **Diagramas de secuencia**: interacción temporal entre objetos o servicios, mostrando el orden de los mensajes
- **Diagramas de flujo (flowcharts)**: representación de algoritmos, procesos de negocio o pipelines con decisiones y bifurcaciones
- **Diagramas de infraestructura**: topología de red, despliegue en cloud (AWS, Azure, GCP), firewalls, balanceadores, zonas de disponibilidad
- **ADR (Architecture Decision Records)**: registros de decisiones arquitectónicas que a menudo incluyen diagramas para justificar y visualizar las opciones
- **Diagramas entidad-relación (ERD)**: representación de la estructura de bases de datos, tablas, columnas, claves y relaciones

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Diagram-as-code | Mermaid, PlantUML, Structurizr DSL, Diagrams (Python), D2 (Terrastruct), Graphviz |
| Editores gráficos | DrawIO / diagrams.net, LucidChart, Excalidraw, Figma, miro |
| Integración CI/CD | PlantUML-server, Kroki, mermaid-cli, github-action-markdown-link-check con diagramas |
| Plugins IDE | Mermaid Preview (VS Code), PlantUML (VS Code, IntelliJ), Draw.io Integration (VS Code) |
| Formatos de salida | SVG, PNG, PDF, HTML incrustado, embed en markdown |
| Validación | Structurizr lint, PlantUML check, ADR-tools, c4-validator |

## Hoja de ruta

1. **Principiante**: aprender notación básica de Mermaid (flowcharts, sequence diagrams); crear diagramas simples en GitHub Markdown; usar DrawIO para diagramas de infraestructura básicos; entender los niveles del modelo C4 (C1 y C2).
2. **Intermedio**: dominar PlantUML para diagramas UML completos (clases, componentes, estados); adoptar Structurizr DSL para documentar arquitectura; integrar diagramas en CI/CD para que se rendericen automáticamente; crear diagramas C3 de componentes con relaciones detalladas.
3. **Avanzado**: modelar infraestructura cloud completa con Diagrams (Python) o D2; documentar decisiones arquitectónicas con ADR + diagramas; gestionar repositorios de diagramas versionados; automatizar la generación de diagramas desde el código fuente (spring-restdocs, asciidoctor).
4. **Experto**: diseñar sistemas complejos con C4 y validación automática de consistencia; contribuir a herramientas open source (Mermaid, PlantUML, Structurizr); enseñar modelado visual a equipos y organizaciones; crear pipelines de documentación viva (living documentation) que integren diagramas, código y pruebas.

## Relaciones con otros módulos

- [000-Core](../000-Core/) — algoritmos y estructuras de datos representados mediante diagramas de flujo
- [010-Architecture](../010-Architecture/) — el modelo C4 es la herramienta principal para documentar decisiones arquitectónicas
- [011-DesignPatterns](../011-DesignPatterns/) — diagramas UML de clases y secuencia para ilustrar patrones de diseño
- [013-DevOps](../013-DevOps/) — diagramas de infraestructura, pipelines CI/CD y topologías de despliegue
- [015-Automation](../015-Automation/) — automatización de generación y validación de diagramas en pipelines
- [042-Documentation](../042-Documentation/) — los diagramas son componentes esenciales de la documentación técnica
- [052-Standards](../052-Standards/) — estándares UML, notación BPMN 2.0, modelos de arquitectura de referencia
- [058-KnowledgeGraph](../058-KnowledgeGraph/) — visualización de grafos de conocimiento y relaciones entre conceptos
- [059-Metadata](../059-Metadata/) — metadatos para versionar, etiquetar y buscar diagramas en repositorios

## Recursos recomendados

- **C4 Model**: c4model.com — guía oficial del modelo C4 por Simon Brown
- **Mermaid**: mermaid.js.org — documentación oficial y editor interactivo
- **PlantUML**: plantuml.com — guía de referencia de todos los tipos de diagramas UML
- **Structurizr**: structurizr.com — herramienta dedicada para el modelo C4 con DSL propio
- **Libro**: "Software Architecture for Developers" (Simon Brown) — enfoque práctico del modelado C4
- **Libro**: "UML Distilled" (Martin Fowler) — referencia concisa de UML aplicado
- **DrawIO / diagrams.net**: app.diagrams.net — editor gratuito con integración a Google Drive, VS Code y Confluence
- **D2 Lang**: d2lang.com — nuevo lenguaje de diagramas declarativo enfocado en simplicidad
- **Kroki**: kroki.io — servicio unificado que renderiza múltiples formatos de diagramas (Mermaid, PlantUML, Graphviz, etc.)
