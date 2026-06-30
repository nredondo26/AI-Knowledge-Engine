# 058-KnowledgeGraph: Grafo de Conocimiento

## Descripción del dominio

El grafo de conocimiento (knowledge graph) es una representación estructurada de información que modela entidades del mundo real (conceptos, tecnologías, personas, proyectos) y las relaciones semánticas entre ellas, formando una red interconectada de conocimiento. A diferencia de una taxonomía jerárquica tradicional, un grafo de conocimiento permite relaciones arbitrarias y multidireccionales entre nodos, lo que refleja con mayor fidelidad la complejidad del conocimiento en ingeniería de software. Este módulo implementa el grafo de conocimiento del AI-Knowledge-Engine, conectando todos los módulos, conceptos y términos en una red navegable donde los usuarios pueden descubrir relaciones, explorar caminos de aprendizaje y encontrar respuestas a preguntas complejas que requieren atravesar múltiples dominios. El grafo se almacena en formatos estándar (RDF, JSON-LD, GEXF) y se visualiza mediante herramientas interactivas.

## Conceptos clave

- **Nodos (entidades)**: representan conceptos, tecnologías, personas, proyectos, lenguajes, frameworks, estándares, etc. Cada nodo tiene un identificador único, un tipo y atributos.
- **Aristas (relaciones)**: conexiones semánticas entre nodos que expresan el tipo de relación: `es_un`, `requiere`, `implementa`, `hereda_de`, `complementa_a`, `alternativa_a`, `predecesor_de`, `similar_a`, `parte_de`, `depende_de`, `reemplaza_a`.
- **Tripleta (sujeto-predicado-objeto)**: unidad fundamental del grafo RDF (Resource Description Framework); ej. "Docker `es_un` ContainerRuntime" o "Kubernetes `orquesta` Docker".
- **RDF (Resource Description Framework)**: estándar W3C para representar información sobre recursos en la web; usa tripletas sujeto-predicado-objeto con URIs como identificadores globales.
- **SPARQL**: lenguaje de consulta para grafos RDF, similar a SQL pero diseñado para datos semánticos con patrones de tripletas.
- **Propiedades y atributos**: datos asociados a nodos y aristas que enriquecen el grafo: descripción, nivel de dificultad, año de creación, autor, categoría taxonómica, tags.
- **Grafo de conocimiento vs. base de datos relacional**: un grafo almacena relaciones explícitamente como conexiones de primer orden, mientras que una BD relacional las infiere mediante joins en tiempo de consulta.
- **Reasoning (razonamiento)**: capacidad de inferir nuevas relaciones implícitas a partir de las relaciones explícitas usando reglas lógicas (ej. si "SQLite `es_un` BaseDeDatos" y "BaseDeDatos `parte_de` Backend", entonces "SQLite `pertenece_a` Backend").
- **Embeddings de grafos (Graph Embeddings)**: representación vectorial de nodos y aristas que captura la estructura del grafo para tareas de machine learning (clasificación, recomendación, predicción de enlaces).
- **PageRank y centrality**: algoritmos que miden la importancia relativa de los nodos dentro del grafo; útiles para identificar conceptos centrales o tecnologías fundamentales.

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Bases de datos de grafos | Neo4j, Amazon Neptune, ArangoDB, JanusGraph, Dgraph, TigerGraph |
| Formatos semánticos | RDF, RDFS, OWL, JSON-LD, Turtle, N-Triples, GEXF, GraphML |
| Lenguajes de consulta | SPARQL, Cypher (Neo4j), Gremlin (Apache TinkerPop), GraphQL |
| Librerías de procesamiento | NetworkX (Python), igraph, Apache Jena, RDFLib, PySpark GraphFrames |
| Visualización | Neo4j Browser, D3.js, Cytoscape.js, Gephi, Sigma.js, vis.js, Graphviz |
| Embeddings de grafos | node2vec, DeepWalk, GraphSAGE, CompGCN, DistMult, TransE |
| Ontologías y vocabularios | Schema.org, DBpedia, Wikidata, YAGO, WordNet, BFO (Basic Formal Ontology) |
| Razonamiento (reasoners) | HermiT, Pellet, RDFox, ELK, Apache Jena Reasoner |

## Hoja de ruta

1. **Principiante**: entender el concepto de grafo y sus componentes (nodos, aristas, propiedades); modelar un grafo pequeño con 10-20 conceptos de un dominio familiar; usar NetworkX en Python para crear y manipular el grafo; visualizar el grafo con Graphviz o D3.js básico.
2. **Intermedio**: diseñar un esquema de relaciones con tipos definidos (`es_un`, `requiere`, `implementa`); almacenar el grafo en Neo4j y consultarlo con Cypher; implementar un explorador web interactivo que permita navegar el grafo; poblar el grafo con datos de múltiples módulos del repositorio.
3. **Avanzado**: modelar ontologías OWL con razonamiento lógico automático; conectar el grafo con fuentes externas (Wikidata, DBpedia, Schema.org); implementar búsqueda semántica que use el grafo para expandir consultas; generar embeddings de nodos para recomendación de contenidos relacionados.
4. **Experto**: diseñar un Knowledge Graph a escala empresarial que integre documentación, código, personas y procesos; implementar pipelines automáticos de extracción de entidades y relaciones desde texto (NER + RE); contribuir a grafos de conocimiento abiertos (Wikidata); usar Graph Neural Networks (GNNs) para tareas predictivas sobre el grafo.

## Relaciones con otros módulos

- [000-Core](../000-Core/) — algoritmos de grafos (BFS, DFS, Dijkstra, PageRank) aplicados al knowledge graph
- [042-Documentation](../042-Documentation/) — la documentación genera y consume información del grafo
- [052-Standards](../052-Standards/) — estándares RDF, OWL, SPARQL, SKOS, JSON-LD para representación semántica
- [056-Glossary](../056-Glossary/) — los términos del glosario son nodos del grafo de conocimiento
- [057-Taxonomy](../057-Taxonomy/) — la taxonomía define relaciones jerárquicas (`es_un`, `parte_de`) dentro del grafo
- [059-Metadata](../059-Metadata/) — metadatos enriquecen los atributos de nodos y aristas del grafo
- [034-LLM](../034-LLM/) — RAG sobre knowledge graph (GraphRAG) para respuestas basadas en relaciones semánticas
- [038-VectorDatabases](../038-VectorDatabases/) — embeddings de nodos para búsqueda híbrida (vectorial + semántica)
- [039-PromptEngineering](../039-PromptEngineering/) — prompts que consultan el grafo para responder preguntas complejas
- [040-Reasoning](../040-Reasoning/) — razonamiento lógico sobre el grafo para inferir nuevas relaciones

## Recursos recomendados

- **Neo4j Graph Academy**: neo4j.com/graphacademy — cursos gratuitos sobre bases de datos de grafos y Cypher
- **RDF 1.1 W3C**: w3.org/TR/rdf11-concepts — especificación del modelo RDF
- **SPARQL 1.1 W3C**: w3.org/TR/sparql11-query — lenguaje de consulta para datos RDF
- **NetworkX**: networkx.org — librería Python para creación y análisis de grafos
- **Libro**: "Knowledge Graphs: Methodology, Tools and Selected Use Cases" (Fensel et al.)
- **Libro**: "Graph-Powered Machine Learning" (Negre): uso de grafos en ML
- **Google Knowledge Graph API**: developers.google.com/knowledge-graph — API de grafo de conocimiento de Google
- **Wikidata**: wikidata.org — grafo de conocimiento colaborativo masivo
- **DBpedia**: dbpedia.org — grafo de conocimiento extraído de Wikipedia
- **Paper**: "GraphRAG: Unlocking LLM Discovery on Narrative Private Data" (Microsoft Research, 2024)
