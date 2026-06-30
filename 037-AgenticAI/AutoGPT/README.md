# AutoGPT — Agente Autónomo Basado en LLM

## Descripción del dominio

AutoGPT es uno de los primeros y más populares proyectos de agente autónomo basado en LLM (lanzado en marzo de 2023 por Significant Gravitas). Demostró cómo un LLM (GPT-4) podía recibir un objetivo de alto nivel, descomponerlo en subtareas, ejecutar herramientas (navegación web, ejecución de código, almacenamiento de archivos), evaluar resultados y ajustar su enfoque iterativamente sin intervención humana. AutoGPT introdujo el concepto de "AI agent loops": pensamiento → acción → observación → repetición, que influyó en frameworks posteriores como LangGraph, CrewAI y AgentGPT.

## Áreas clave

- **Arquitectura de agente**: Loop principal: objetivo → pensar (thought) → razonar (reasoning) → plan (plan) → criticar (criticism) → acción (tool use) → resultado → memoria → repetir
- **Memoria**: Memoria a corto plazo (contexto de la ventana del LLM) + memoria a largo plazo (almacenamiento en vector database como Pinecone o Weaviate para recuperar experiencias pasadas)
- **Herramientas (Tools)**: Navegación web (requests, Selenium), ejecución de código Python, almacenamiento de archivos, búsqueda web (Google/Bing API), procesamiento de texto, interacción con APIs externas
- **Gestión de objetivos**: Objetivo principal → descomposición en subobjetivos → priorización → ejecución secuencial o paralela. Re-evaluación periódica del progreso hacia el objetivo principal
- **Prompt Engineering**: System prompt complejo que define personalidad, capacidades, reglas de seguridad y formato de respuesta. Instrucciones para pensamiento estructurado, análisis de riesgos y auto-crítica
- **Limitaciones y desafíos**: Costo elevado (muchas llamadas API), loops infinitos, alucinaciones en herramientas, falta de persistencia robusta, seguridad (ejecución de código, navegación web)
- **Variantes**: AutoGPT Classic (Python CLI + web UI), AgentGPT (versión navegador), BabyAGI (task-driven, más simple), GodMode (AutoGPT + ChatGPT web UI), smol-developer (agente de código)

## Ejemplo: Bucle principal de AutoGPT (simplificado)

```python
class AutoGPT:
    def __init__(self, objective, llm, tools, memory):
        self.objective = objective
        self.llm = llm
        self.tools = {t.name: t for t in tools}
        self.memory = memory
        self.history = []

    def run(self, max_steps=50):
        for step in range(max_steps):
            prompt = self.build_prompt()
            response = self.llm.generate(prompt)

            thought = response.get("thoughts", {})
            action = response.get("action", {})

            print(f"[{step}] Thought: {thought.get('text')}")
            print(f"[{step}] Plan: {thought.get('plan')}")
            print(f"[{step}] Criticism: {thought.get('criticism')}")

            if action["name"] == "final_answer":
                return action["args"]["answer"]

            tool = self.tools.get(action["name"])
            if not tool:
                continue

            result = tool.execute(**action["args"])
            self.memory.add(f"{action['name']}({action['args']}) = {result}")
            self.history.append((action, result))

            # Evaluar progreso
            if self.is_objective_complete():
                return "Objetivo completado"

        return "Máximo de pasos alcanzado"

    def build_prompt(self):
        return f"""Objetivo: {self.objective}
Historial reciente: {self.history[-5:]}
Memoria relevante: {self.memory.query(self.objective)}
Herramientas disponibles: {list(self.tools.keys())}
Piensa paso a paso qué hacer a continuación.
Responde con JSON: {{
    "thoughts": {{"text": "...", "plan": "...", "criticism": "..."}},
    "action": {{"name": "tool_name", "args": {{...}}}}
}}"""
```

## Tecnologías principales

| Componente | Descripción |
|------------|-------------|
| AutoGPT Classic | Versión original (Python, CLI + web) |
| AutoGPT Platform | Servicio cloud (beta, interfaz gráfica) |
| AgentGPT | Versión navegador con UI drag-and-drop |
| BabyAGI | Task-driven agent (más simple, sin tools complejas) |
| smol-developer | AutoGPT especializado en desarrollo de software |
| LangChain / LangGraph | Frameworks modernos para construir agentes similares |
| Pinecone / Weaviate | Vector databases para memoria a largo plazo |
| Redis / SQLite | Almacenamiento de estado y configuración |

## Limitaciones y lecciones aprendidas

| Limitación | Descripción | Mitigación |
|------------|-------------|------------|
| Costo | ~$0.10-0.50 por paso con GPT-4 | Usar modelos más baratos para subtareas simples |
| Loops infinitos | El agente repite acciones sin progreso | Añadir step limit, detección de loops, diversificación |
| Alucinaciones | Inventa resultados de herramientas | Verificar outputs de tools, usar sandboxing |
| Seguridad | Ejecución de código arbitrario | Containerizar ejecución, restringir herramientas |
| Falta de persistencia | El agente olvida contexto entre sesiones | Memoria persistente con vector DB |

## Buenas prácticas

- Definir objetivos claros, específicos y medibles (no "hazme un sitio web" sino "crea una landing page con HTML/CSS/JS")
- Limitar el número máximo de pasos para controlar costos y evitar loops
- Implementar detección de progreso: si no hay avance en N pasos, cambiar estrategia
- Usar modelos más pequeños (GPT-4o-mini, Claude Haiku) para pasos de razonamiento simples
- Verificar resultados de herramientas externas antes de usarlos en el siguiente paso
- Mantener un log detallado de acciones y resultados para depuración
- Para tareas de código, usar ejecución en contenedor aislado (Docker sandbox)
- Implementar human-in-the-loop para acciones destructivas (escribir archivos, ejecutar comandos)
- Preferir frameworks modernos (LangGraph, CrewAI) sobre AutoGPT clásico para nuevos proyectos
