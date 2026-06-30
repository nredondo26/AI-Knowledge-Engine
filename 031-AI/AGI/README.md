# Inteligencia Artificial General (AGI) (031-AI/AGI)

## Descripción del dominio

La Inteligencia Artificial General (AGI) se refiere a sistemas de IA con capacidades cognitivas equivalentes o superiores a las humanas en un amplio espectro de tareas intelectuales. A diferencia de la IA estrecha (Narrow AI), que domina tareas específicas (traducción, reconocimiento de imágenes, juego), la AGI sería capaz de aprender, razonar, planificar, comprender el lenguaje natural, y transferir conocimiento entre dominios con flexibilidad humana. El campo de investigación en AGI abarca arquitecturas cognitivas, sistemas integrados, modelos unificados de cognición y el estudio teórico de los requisitos necesarios para la inteligencia general.

## Debate sobre definiciones y criterios

| Criterio | Descripción | Defensores |
|----------|-------------|------------|
| **Cognitive Science Approach** | La AGI debe modelar la cognición humana completa (memoria, percepción, razonamiento, emoción) | Newell, Anderson, Laird |
| **Universal Intelligence** | Medir inteligencia como capacidad de optimizar objetivos en entornos diversos; usar Cogo (Legg & Hutter) | Hutter, Schmidhuber, Legg |
| **Chef's Test (Chollet)** | AGI debe generalizar a partir de pocos ejemplos, aprender tareas nuevas y adaptarse con eficiencia de muestra | François Chollet (ARC Challenge) |
| **Capabilities-based** | AGI es un sistema que puede realizar cualquier trabajo cognitivo que un humano pueda hacer | OpenAI, DeepMind, Anthropic |
| **Economic Value** | AGI como IA que puede automatizar la mayoría del trabajo cognitivo económicamente valioso | Sutton, Cotra, various timelines |

## Arquitecturas y aproximaciones principales

### Arquitecturas Cognitivas

- **Soar (Newell, Laird, Rosenbloom)**: Arquitectura unificada con memoria de largo plazo (procedimental, semántica, episódica), memoria de trabajo, chunking como mecanismo de aprendizaje. Problemas resueltos con búsqueda en espacio de estado + aprendizaje de reglas de producción.
- **ACT-R (Anderson)**: Modelo de cognición humana con módulos separados (visual, manual, declarativo, procedimental, intencional) y un buffer central. Usa teoría racional (utilidad esperada) para seleccionar acciones.
- **Nengo (Eliasmith)**: Arquitectura basada en Neural Engineering Framework (NEF). Representación neuronal distribuida, dinámica no lineal, aprendizaje supervisado/no supervisado. SPAUN (Semantic Pointer Architecture Unified Network) — modelo de 2.5 millones de neuronas que realiza 8 tareas cognitivas.

### Sistemas Integrados

- **Gato (DeepMind, 2022)**: Agente único entrenado con comportamiento multimodal (juegos, control de robots, chat, captioning de imágenes) usando transformer con 1.2B parámetros. Entrenado con behavioral cloning y RL.
- **Socrates (Microsoft Research)**: Modelo conversacional con razonamiento de sentido común, planificación, memoria episódica y diálogo multi-turno con personalidad.
- **OpenCog (SingularityNET)**: Plataforma open-source para AGI que integra lógica probabilística (PLN), redes atencionales (ECAN), planificación (Moses), aprendizaje por refuerzo, y procesamiento de lenguaje natural.

### Unificación con Deep Learning

La hipótesis actual dominante: los transformers a gran escala, aumentados con capacidades adicionales, pueden escalar a AGI (o ya son proto-AGI). Evidence:

1. **Generalización en contexto (In-Context Learning)**: Modelos con >70B params muestran capacidad de aprender tareas nuevas sin ajuste fino.
2. **Razonamiento emergente**: Cadenas de pensamiento (Chain-of-Thought), auto-consistencia, tool use, code generation.
3. **Multimodalidad**: GPT-4V, Gemini — integración de visión, audio, texto.
4. **Agentes**: AutoGPT, BabyAGI, Agentic frameworks — planificación, ejecución, memoria, reflexión.
5. **Razonamiento avanzado**: o-series (OpenAI o1, o3) — razonamiento con cadenas de pensamiento internas (inference-time compute).

## Problemas abiertos fundamentales

### 1. Escala y eficiencia de muestra

Los humanos aprenden con pocos ejemplos; los modelos actuales requieren millones. La brecha en eficiencia de muestra es uno de los principales argumentos de que escalar transformers no es suficiente.

```python
# Contraste: aprendizaje humano vs deep learning
# Tarea: aprender XOR con N ejemplos
import numpy as np
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score

def sample_efficiency_test(n_train):
    """Cuántos ejemplos necesita un MLP para aprender XOR"""
    np.random.seed(42)
    X = np.random.randint(0, 2, (n_train, 2))
    y = X[:, 0] ^ X[:, 1]

    model = MLPClassifier(hidden_layer_sizes=(4,), max_iter=500, random_state=42)
    model.fit(X, y)

    # Evaluación exhaustiva
    X_test = np.array([[0,0],[0,1],[1,0],[1,1]])
    y_test = X_test[:, 0] ^ X_test[:, 1]
    acc = accuracy_score(y_test, model.predict(X_test))
    return acc

for n in [4, 8, 16, 32, 100, 1000]:
    acc = sample_efficiency_test(n)
    print(f"n_train={n:5d} → XOR accuracy={acc:.2f} {'✓' if acc==1.0 else '✗'}")

# Un humano aprende XOR con exactamente 4 ejemplos.
# Un MLP típicamente necesita ~20-50 ejemplos para generalizar.
```

### 2. Razonamiento causal (Causal Inference)

La AGI requiere entender causalidad, no solo correlación. Judea Pearl argumenta que los sistemas actuales operan en el nivel "asociacional" (Rung 1 de la escalera de causalidad), mientras la AGI requiere razonamiento contrafactual (Rung 3).

```python
# Diferencias entre correlación y causalidad
# Simulación: ¿el marcador del tratamiento afecta la recuperación?
# Sesgo de confusión: la edad confunde la relación.

import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression

np.random.seed(42)
n = 1000
edad = np.random.uniform(20, 80, n)
# Jóvenes reciben más tratamiento (confound)
tratamiento = np.random.binomial(1, 0.8 - 0.005 * edad)
# La recuperación depende de edad (negativo) y tratamiento (positivo)
recuperacion = 0.3 * tratamiento - 0.02 * edad + np.random.normal(0, 0.1, n)

df = pd.DataFrame({'edad': edad, 'tratamiento': tratamiento, 'recuperacion': recuperacion})

# Regresión ingenua: tratamiento → recuperación (ignorando edad)
X_naive = df[['tratamiento']]
y = df['recuperacion']
m_naive = LinearRegression().fit(X_naive, y)
print(f"Coef tratamiento (sin control): {m_naive.coef_[0]:.4f}")
# Incorrecto! No captura efecto causal.

# Regresión con control de confound
X_adj = df[['tratamiento', 'edad']]
m_adj = LinearRegression().fit(X_adj, y)
print(f"Coef tratamiento (controlando edad): {m_adj.coef_[0]:.4f}")
# Correcto: 0.3
print(f"Coef edad: {m_adj.coef_[1]:.4f}")
```

### 3. Consciencia y experiencia subjetiva (Qualia)

- ¿Es la consciencia necesaria para AGI? Algunos argumentan que la integración de información (IIT — Integrated Information Theory) es un requisito.
- **Global Workspace Theory (Baars)**: La consciencia emerge de la competencia por acceso a un espacio de trabajo global.
- **Higher-Order Theories**: Un estado es consciente si hay un meta-estado que lo representa.
- **Debate abierto**: ¿Puede haber AGI sin consciencia? La mayoría de los investigadores piensa que sí.

### 4. Timelines y predicciones

| Predicción | Fecha | Autor/Fuente | Estado |
|-----------|-------|--------------|--------|
| "IA igual a humana en 20 años" | 1965 | Herbert Simon | ✗ (falló) |
| "En 3-8 años tendremos AGI" | 1990s | Kurzweil | ✗ |
| "AGI para 2029" | 2005 | Ray Kurzweil | ? |
| "Probabilidad >50% de AGI para 2070" | 2022 | Grace et al. (encuesta) | ? |
| "AGI antes de 2030" | 2023 | Demis Hassabis (DeepMind) | ? |
| "AGI para 2027" | 2023 | Leopold Aschenbrenner | ? |

## Código: implementación de un agente con razonamiento básico

```python
# Agente con planificación y memoria (versión minimalista)
import json
from typing import List, Dict, Callable

class AGIAgent:
    """
    Arquitectura integrada mínima con:
    - Percepción (embedding + clasificación)
    - Memoria (episódica + semántica)
    - Razonamiento (Chain-of-Thought simple)
    - Ejecución (tool use)
    """

    def __init__(self):
        self.memoria_episodica: List[Dict] = []
        self.memoria_semantica: Dict[str, float] = {}
        self.tools: Dict[str, Callable] = {}

    def register_tool(self, name: str, func: Callable, desc: str):
        self.tools[name] = {'func': func, 'desc': desc}

    def perceive(self, observation: str) -> str:
        """Simplifica la percepción a extraer entidades clave"""
        # En un sistema real: NER, classification, embedding
        self.memoria_episodica.append({
            'obs': observation,
            'timestamp': len(self.memoria_episodica)
        })
        return observation

    def reason(self, task: str) -> str:
        """Chain-of-Thought: descomposición de problema"""
        # Paso 1: relevancia en memoria semántica
        context = [m['obs'] for m in self.memoria_episodica[-3:]]

        # Paso 2: planeación (simplificada)
        plan = [
            f"1. Entender: {task}",
            f"2. Buscar herramientas relevantes: {list(self.tools.keys())}",
            "3. Ejecutar plan",
            "4. Verificar resultado"
        ]
        return "\n".join(plan)

    def act(self, plan: str) -> str:
        """Ejecutar acciones según el plan"""
        # Seleccionar herramienta basada en task
        results = []
        for tool_name, tool_info in self.tools.items():
            if tool_name in plan.lower():
                result = tool_info['func']()
                results.append(f"{tool_name}: {result}")
                self.memoria_semantica[tool_name] = \
                    self.memoria_semantica.get(tool_name, 0) + 1
        return "\n".join(results) if results else "No tool matched"

# Ejemplo: agente calculador con planificación
def sumar() -> str:
    return "2 + 2 = 4"

def buscar() -> str:
    return "Información encontrada sobre AGI"

agent = AGIAgent()
agent.register_tool("sumar", sumar, "Realiza sumas aritméticas")
agent.register_tool("buscar", buscar, "Busca información en la base de conocimiento")

obs = agent.perceive("Necesito calcular 2+2 y buscar información sobre AGI")
plan = agent.reason("calcular y buscar")
print("=== PLAN ===")
print(plan)
print("\n=== EJECUCIÓN ===")
result = agent.act(plan)
print(result)
```

## Relaciones con otros módulos

- `../History/`: El sueño de AGI como motivación histórica de la IA.
- `../Ethics/`: Dilemas éticos específicos de AGI (agencia moral, derechos, transparencia).
- `../Safety/`: Riesgos existenciales de AGI desalineada; alineación como requisito.
- `../../032-MachineLearning/`: ML como capa base de aprendizaje en sistemas AGI.
- `../../033-DeepLearning/`: Redes profundas como arquitectura subyacente.
- `../../034-LLM/`: LLMs como bloques de construcción de sistemas proto-AGI.
- `../../037-AgenticAI/`: Agentes autónomos como paso intermedio hacia AGI.

## Recursos recomendados

- **Libro**: "Artificial General Intelligence" (Goertzel & Pennachin) — Visión general del campo.
- **Libro**: "Superintelligence" (Nick Bostrom) — Riesgos y caminos hacia AGI.
- **Libro**: "The Most Human Human" (Brian Christian) — Test de Turing y naturaleza de la inteligencia.
- **Paper**: "Measuring the Intelligence of an Agent" (Legg & Hutter, 2007) — Definición universal.
- **Paper**: "On the Measure of Intelligence" (Chollet, 2019) — ARC Challenge y crítica a benchmarks.
- **Paper**: "Reward is Enough" (Silver et al., 2021) — Marco unificado AGI.
- **Paper**: "Situational Awareness: The Decade Ahead" (Aschenbrenner, 2024).
- **Repositorio**: ARC-AGI (GitHub) — Medición de generalización.
- **Organización**: MIRI (Machine Intelligence Research Institute), DeepMind, OpenAI, Anthropic.
