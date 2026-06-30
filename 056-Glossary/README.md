# 056-Glossary: Glosario de Términos

## Descripción del dominio

El glosario de términos es un recurso lexicográfico que recopila, define y contextualiza el vocabulario técnico utilizado en el dominio de la ingeniería de software, la computación y tecnologías de la información. Este módulo contiene definiciones precisas, ordenadas alfabéticamente y organizadas por dominio (algoritmos, arquitectura, lenguajes, cloud, seguridad, IA/ML, redes, bases de datos, DevOps, etc.). Cada entrada incluye el término, su definición clara y concisa, el dominio al que pertenece, sinónimos comunes, términos relacionados y una referencia cruzada a otros módulos del knowledge engine cuando es relevante. Un glosario bien mantenido es fundamental para la comunicación efectiva entre equipos multidisciplinarios, la incorporación de nuevos miembros, la creación de documentación técnica coherente y la estandarización terminológica en toda la organización.

## Conceptos clave

- **Definición técnica**: explicación precisa, concisa y libre de ambigüedades del significado de un término en su contexto tecnológico específico
- **Dominio**: clasificación del término dentro de un área del conocimiento (arquitectura, seguridad, cloud, inteligencia artificial, etc.)
- **Sinónimos y variantes**: términos alternativos que se usan para el mismo concepto (ej. "deployment" = "despliegue"; "container" = "contenedor")
- **Términos relacionados**: vínculos semánticos con otros términos del glosario (hiperónimos, hipónimos, términos complementarios)
- **Antónimos**: términos con significado opuesto o contrastante (ej. "síncrono" vs. "asíncrono", "monolítico" vs. "microservicios")
- **Referencias cruzadas**: enlaces a módulos específicos del knowledge engine donde el término se explica en profundidad
- **Siglas y acrónimos**: expansión y definición de siglas (API, JSON, REST, CI/CD, CRUD, SOLID, ACID, BASE, CAP, K8s)
- **Términos obsoletos o legacy**: términos que han caído en desuso o han sido reemplazados por terminología más moderna, con referencias al término actual
- **Neologismos tecnológicos**: términos nuevos o recién acuñados (prompt engineering, agentic AI, retrieval-augmented generation, fine-tuning)
- **Glosario multilingüe**: términos en inglés (lengua franca técnica) con su traducción recomendada al español y viceversa

## Tecnologías principales

| Categoría | Herramientas |
|-----------|-------------|
| Bases de conocimiento | Notion, Confluence, Nuclino, Slite, GitBook |
| Generación de glosarios | Glossarist, Termbox, TBX, TermWeb, Lexonomy |
| Formatos estándar | TBX (TermBase eXchange) - ISO 30042, CSV, JSON, YAML, Markdown |
| Extracción de términos | TermExtractor, Natural Language Toolkit (NLTK), spaCy |
| Validación ortográfica | LanguageTool, Grammarly, Hunspell, proselint |
| Publicación | MkDocs + Glossarium plugin, Hugo, Docusaurus, VuePress |
| Estandarización | ISO 704 (principios de terminología), ISO 860 (armonización de conceptos), ISO 1087 (vocabulario de terminología) |

## Hoja de ruta

1. **Principiante**: recopilar términos técnicos del día a día del equipo; crear un glosario simple en un documento compartido o wiki; definir cada término con una oración clara; categorizar por dominio general.
2. **Intermedio**: establecer una plantilla consistente para las entradas (término, definición, dominio, sinónimos, referencias); integrar el glosario en la documentación técnica usando referencias cruzadas; organizar sesiones de revisión con el equipo para validar definiciones; implementar un proceso de propuesta y aprobación de nuevos términos.
3. **Avanzado**: automatizar la extracción de términos técnicos desde el código fuente y la documentación existente; publicar el glosario como parte del sitio de documentación técnica con búsqueda y filtrado por dominio; enlazar el glosario con el grafo de conocimiento del repositorio; soportar múltiples idiomas (inglés/español).
4. **Experto**: adoptar estándares de terminología (TBX, ISO 704) para intercambio con otras organizaciones; contribuir a glosarios open source o comunitarios; utilizar NLP para mantener el glosario actualizado automáticamente; integrar el glosario en herramientas de desarrollo (IDE plugins, snippets de definiciones, lints terminológicos).

## Relaciones con otros módulos

- [000-Core](../000-Core/) — términos fundamentales de algoritmos, estructuras de datos y complejidad
- [001-Languages](../001-Languages/) — terminología específica de cada lenguaje de programación
- [010-Architecture](../010-Architecture/) — vocabulario de estilos arquitectónicos, patrones y principios
- [031-AI](../031-AI/) / [032-MachineLearning](../032-MachineLearning/) — términos de inteligencia artificial y machine learning
- [034-LLM](../034-LLM/) — glosario de modelos de lenguaje, transformers, tokens, fine-tuning, RAG
- [042-Documentation](../042-Documentation/) — el glosario es un componente fundamental de la documentación técnica
- [046-BestPractices](../046-BestPractices/) — terminología asociada a buenas prácticas y estándares
- [052-Standards](../052-Standards/) — definiciones normalizadas de términos según estándares ISO, IEEE, W3C
- [057-Taxonomy](../057-Taxonomy/) — el glosario se alimenta de la taxonomía del conocimiento para organizar términos por dominio
- [058-KnowledgeGraph](../058-KnowledgeGraph/) — el glosario alimenta los nodos del grafo de conocimiento con definiciones
- [059-Metadata](../059-Metadata/) — metadatos para entradas del glosario (fecha, autor, dominio, estado, versión)

## Recursos recomendados

- **Libro**: "The Elements of Style" (Strunk & White) — principios de escritura clara aplicables a definiciones técnicas
- **ISO 704**: "Terminology work — Principles and methods" — estándar para la elaboración de terminología
- **ISO 1087-1**: "Terminology work — Vocabulary" — vocabulario de terminología
- **IEC/ISO 60050**: "International Electrotechnical Vocabulary" — referencia terminológica multidisciplinaria
- **NIST SP 800-12**: "An Introduction to Computer Security: The NIST Handbook" — glosario de seguridad
- **Google's Technical Writing Courses**: developers.google.com/tech-writing — guías de escritura técnica
- **OWASP**: owasp.org — glosario de términos de seguridad web
- **W3C Glossary**: w3.org/TR/2005/WD-glossary-20050407/ — glosario de términos web
