# CrewAI — Framework Multi-Agente

## Concepto

**CrewAI** es un framework orquestador de agentes autónomos de IA donde múltiples agentes especializados colaboran como un equipo (crew) para completar tareas complejas. Cada agente tiene un rol, objetivos y herramientas específicas, y puede delegar, preguntar y colaborar con otros agentes.

CrewAI abstrae la complejidad de coordinar agentes (qué agente hace qué, cuándo, y cómo se comunican) permitiendo definir flujos de trabajo multi-agente con código declarativo.

## Arquitectura de CrewAI

```
Crew (Equipo)
  │
  ├─► Agent 1 (Investigador)
  │     ├─ Rol: Recolectar información
  │     ├─ Goal: Encontrar datos relevantes
  │     ├─ Tools: [WebSearch, Scraper, DB]
  │     └─ Backstory: "Experto en investigación..."
  │
  ├─► Agent 2 (Analista)
  │     ├─ Rol: Analizar y sintetizar
  │     ├─ Goal: Extraer conclusiones
  │     ├─ Tools: [Calculator, Summarizer]
  │     └─ Backstory: "Analista con 10 años..."
  │
  ├─► Agent 3 (Escritor)
  │     ├─ Rol: Redactar informe final
  │     ├─ Goal: Producir documento pulido
  │     ├─ Tools: [Formatter, Translator]
  │     └─ Backstory: "Escritor técnico..."
  │
  ├─► Tasks (Tareas)
  │     ├─ Task 1: Investigar tema → Agent 1
  │     ├─ Task 2: Analizar datos → Agent 2
  │     └─ Task 3: Escribir reporte → Agent 3
  │
  └─► Process (Proceso)
        ├─ sequential: una tarea tras otra
        └─ hierarchical: manager asigna y revisa
```

## Implementación

### 1. Definición de Agentes

```python
from crewai import Agent
from crewai_tools import SerperDevTool, ScrapeWebsiteTool

# Herramientas
busqueda = SerperDevTool()
scraper = ScrapeWebsiteTool()

# Agente Investigador
investigador = Agent(
    role="Investigador Senior de IA",
    goal="Descubrir las últimas tendencias y avances en {tema}",
    backstory="Investigador con 15 años de experiencia en IA. "
              "Especialista en encontrar información relevante y actualizada.",
    tools=[busqueda, scraper],
    verbose=True,
    allow_delegation=False,
    max_iter=10,
    memory=True
)

# Agente Analista
analista = Agent(
    role="Analista de Datos Técnicos",
    goal="Sintetizar información técnica compleja en conclusiones claras y accionables",
    backstory="Analista con PhD en Ciencias de la Computación. "
              "Experto en identificar patrones y tendencias en datos técnicos.",
    tools=[],  # usa razonamiento del LLM
    verbose=True,
    allow_delegation=True
)

# Agente Redactor
redactor = Agent(
    role="Redactor Técnico Senior",
    goal="Producir informes técnicos claros, precisos y bien estructurados",
    backstory="Redactor técnico con experiencia en documentación de IA y ML. "
              "Ganador de premios de comunicación científica.",
    verbose=True,
    allow_delegation=False
)
```

### 2. Definición de Tareas

```python
from crewai import Task

# Tarea 1: Investigar
tarea_investigacion = Task(
    description=(
        "Realiza una investigación exhaustiva sobre {tema}. "
        "Busca al menos 5 fuentes confiables y extrae los puntos clave. "
        "Enfócate en avances recientes (último año) y aplicaciones prácticas."
    ),
    expected_output=(
        "Lista de 5-10 fuentes con resumen de cada una, "
        "incluyendo hallazgos principales, fechas y relevancia."
    ),
    agent=investigador,
    output_file="investigacion.md"
)

# Tarea 2: Analizar
tarea_analisis = Task(
    description=(
        "Analiza los resultados de la investigación. "
        "Identifica patrones, contradicciones y tendencias. "
        "Proporciona una síntesis estructurada con conclusiones clave."
    ),
    expected_output=(
        "Informe de análisis con: resumen ejecutivo, "
        "tendencias identificadas (top 3), contradicciones, "
        "y recomendaciones basadas en datos."
    ),
    agent=analista,
    context=[tarea_investigacion],  # depende de la investigación
    output_file="analisis.md"
)

# Tarea 3: Redactar
tarea_redaccion = Task(
    description=(
        "Con base en el análisis, redacta un informe técnico completo sobre {tema}. "
        "El informe debe incluir: introducción, metodología, hallazgos, "
        "discusión, conclusiones y referencias. Usa lenguaje claro y preciso."
    ),
    expected_output=(
        "Informe técnico en formato markdown de 1500-2000 palabras, "
        "con estructura profesional y referencias formateadas."
    ),
    agent=redactor,
    context=[tarea_analisis],
    output_file="informe_final.md"
)
```

### 3. Creación del Crew y Ejecución

```python
from crewai import Crew, Process

crew = Crew(
    agents=[investigador, analista, redactor],
    tasks=[tarea_investigacion, tarea_analisis, tarea_redaccion],
    process=Process.sequential,  # o hierarchical
    verbose=True,
    memory=True,
    cache=True,
    max_rpm=10,  # llamadas por minuto
    share_crew=True  # compartir contexto entre agentes
)

# Ejecutar
resultado = crew.kickoff(inputs={"tema": "GraphRAG: Avances y Aplicaciones"})
print("## Resultado Final ##")
print(resultado)
```

### 4. Agentes con Memoria y Colaboración

```python
# Agente con memoria de largo plazo
agente_memoria = Agent(
    role="Experto en RAG",
    goal="Mantener conocimiento actualizado sobre RAG",
    backstory="Experto que aprende de cada interacción",
    memory=True,
    memory_config={
        "provider": "mem0",  # o "rag", "vector_store"
        "config": {"user_id": "equipo-rag"}
    },
    verbose=True
)

# Delegación entre agentes
class DelegatorAgent(Agent):
    def should_delegate(self, task):
        # Lógica para decidir si delegar
        return task.complexity > 0.7
```

## Buenas Prácticas

1. **Roles específicos**: Agentes con roles acotados rinden mejor.
2. **Backstory detallado**: Mejora la personalidad y consistencia.
3. **Herramientas mínimas**: Solo las necesarias para el rol.
4. **Tareas atómicas**: Cada tarea debe ser una unidad de trabajo clara.
5. **Caché**: Habilitar `cache=True` para evitar llamadas redundantes.

```python
# Configuración de cache personalizada
crew = Crew(
    ...,
    cache=dict(
        provider="redis",
        config={"host": "localhost", "port": 6379}
    )
)
```
