# GraphRAG — Recuperación Aumentada con Grafos de Conocimiento

## Concepto

**GraphRAG** extiende RAG tradicional incorporando un grafo de conocimiento como fuente de recuperación. En lugar de solo fragmentos de texto planos, GraphRAG modela entidades, relaciones y jerarquías del dominio, permitiendo recuperación multi-salto, razonamiento sobre conexiones indirectas y agregación estructurada de información.

Microsoft Research popularizó GraphRAG con su paper *"From Local to Global: A Graph RAG Approach to Query-Focused Summarization"*.

## Arquitectura de GraphRAG

```
Documentos
  │
  ├─► Extracción de Entidades y Relaciones (NER + LLM)
  │     ├─ Identificar personas, lugares, conceptos
  │     └─ Extraer relaciones semánticas
  │
  ├─► Construcción del Grafo
  │     ├─ Nodos → Entidades con embeddings
  │     ├─ Aristas → Relaciones con peso
  │     └─ Comunidades → Clustering (Leiden/ Louvain)
  │
  ├─► Indexación
  │     ├─ Embeddings de nodos para búsqueda vectorial
  │     └─ Resúmenes por comunidad para búsqueda global
  │
  └─► Recuperación
        ├─ Local: entidades cercanas a la consulta
        ├─ Global: resúmenes de comunidades relevantes
        └─ Multi-salto: BFS/DFS por el grafo
```

## Implementación con NetworkX + LangChain

### 1. Extracción de Entidades con LLM

```python
from openai import OpenAI
import json

client = OpenAI()

def extraer_entidades_y_relaciones(texto):
    prompt = f"""Extrae entidades y relaciones del siguiente texto.
Devuelve JSON con "entities" (nombre, tipo) y "relations" (source, target, relation).

Texto: {texto}"""
    resp = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        response_format={"type": "json_object"}
    )
    return json.loads(resp.choices[0].message.content)
```

### 2. Construcción del Grafo de Conocimiento

```python
import networkx as nx

class KnowledgeGraph:
    def __init__(self):
        self.graph = nx.Graph()

    def add_document(self, texto, doc_id):
        datos = extraer_entidades_y_relaciones(texto)

        # Añadir nodos
        for e in datos["entities"]:
            self.graph.add_node(e["name"], type=e["type"], docs={doc_id})

        # Añadir aristas
        for r in datos["relations"]:
            if self.graph.has_edge(r["source"], r["target"]):
                self.graph[r["source"]][r["target"]]["weight"] += 1
                self.graph[r["source"]][r["target"]]["relations"].add(r["relation"])
            else:
                self.graph.add_edge(
                    r["source"], r["target"],
                    weight=1,
                    relations={r["relation"]}
                )

    def get_subgraph(self, entidad, profundidad=2):
        desde = entidad
        if desde not in self.graph:
            return nx.Graph()

        # BFS limitado por profundidad
        visitados = {desde}
        frontera = {desde}
        for _ in range(profundidad):
            nueva = set()
            for n in frontera:
                nueva.update(self.graph.neighbors(n))
            visitados.update(nueva)
            frontera = nueva

        return self.graph.subgraph(visitados)
```

### 3. GraphRAG completo con LangChain

```python
from langchain_openai import ChatOpenAI
from langchain_community.graphs.networkx_graph import NetworkxEntityGraph
from langchain.chains.graph_qa.cypher import GraphCypherQAChain

# Construir grafo desde documentos
kg = NetworkxEntityGraph()

# Añadir triplas (sujeto, predicado, objeto)
kg.add_triple("RAG", "combina", "recuperación")
kg.add_triple("RAG", "combina", "generación")
kg.add_triple("chunking", "divide", "documentos")
kg.add_triple("chunking", "mejora", "precisión")
kg.add_triple("embeddings", "representan", "semántica")

# Consulta GraphRAG
llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)

chain = GraphCypherQAChain.from_llm(
    llm=llm,
    graph=kg,
    verbose=True,
    allow_dangerous_requests=True
)

respuesta = chain.invoke("¿Qué combina RAG?")
print(respuesta["result"])
```

### 4. GraphRAG Local-Global (Microsoft)

```python
# Implementación conceptual del enfoque Local → Global

class MicrosoftGraphRAG:
    def __init__(self):
        self.graph = nx.Graph()
        self.communities = {}
        self.community_summaries = {}

    def build_communities(self):
        """Cluster de Leiden para detectar comunidades"""
        import community as community_louvain
        self.communities = community_louvain.best_partition(self.graph)

    def summarize_communities(self, llm):
        """Generar resumen por comunidad"""
        for node, community_id in self.communities.items():
            miembros = [n for n, c in self.communities.items() if c == community_id]
            subgraph = self.graph.subgraph(miembros)
            resumen_prompt = f"Describe la comunidad formada por: {', '.join(miembros)}"
            resp = llm.invoke(resumen_prompt)
            self.community_summaries[community_id] = resp.content

    def query(self, pregunta, llm):
        """Búsqueda local + global combinada"""
        # Local: entidades directamente relacionadas
        # Global: resúmenes de comunidades relevantes
        prompt_global = f"""Basado en estos resúmenes de comunidades:
{self.community_summaries}

Responde: {pregunta}"""
        return llm.invoke(prompt_global)
```

## GraphRAG vs Vector RAG

| Aspecto | Vector RAG | GraphRAG |
|---------|------------|----------|
| Unidad de recuperación | Fragmentos de texto | Entidades + relaciones |
| Tipo de consulta | Preguntas factuales | Preguntas relacionales/multisalto |
| Agregación | Difícil (texto plano) | Natural (estructura de grafo) |
| Escalabilidad | Alta | Media (construcción costosa) |
| Mantenimiento | Bajo | Alto (grafos se desactualizan) |

## Cuándo usar GraphRAG

1. **Preguntas multi-salto**: "¿Qué inventó la persona que fundó X?"
2. **Análisis de comunidades**: "¿Qué temas están conectados?"
3. **Resúmenes globales**: "¿Cuáles son los temas principales del corpus?"
4. **Razonamiento relacional**: Dominios médicos, legales, financieros.

```python
# Ejemplo: Consulta multi-salto en grafo
def multi_hop_query(graph, entidad_inicial, pregunta, llm):
    subgraph = graph.get_subgraph(entidad_inicial, profundidad=3)
    context = "\n".join([
        f"{u} --[{d['relations']}]--> {v}"
        for u, v, d in subgraph.edges(data=True)
    ])
    prompt = f"Contexto en grafo:\n{context}\n\nPregunta: {pregunta}"
    return llm.invoke(prompt)
```
