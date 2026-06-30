# Enrutamiento de LLMs (Routing)

## Descripción del dominio

El enrutamiento (routing) en el contexto de LLMs se refiere a la capa de inteligencia que decide qué modelo o qué estrategia usar para cada consulta entrante. En lugar de enviar todas las consultas al mismo LLM (costoso para tareas simples), un router inteligente clasifica las consultas por dificultad, dominio o tipo, y las dirige al modelo más adecuado: uno pequeño y rápido para preguntas simples, uno grande y potente para tareas complejas, o incluso sistemas especializados como motores de búsqueda o bases de conocimiento. Esto optimiza costo, latencia y calidad.

## Conceptos clave

- **Router**: Componente que analiza la consulta entrante y decide qué modelo o servicio utilizar.
- **Enrutamiento Basado en Reglas**: Usa heurísticas como longitud de la consulta, presencia de palabras clave, regex.
- **Enrutamiento por Clasificador**: Modelo de ML (a menudo pequeño) que clasifica las consultas en categorías.
- **Enrutamiento por Embeddings**: Compara la consulta con embeddings de consultas previas para encontrar el mejor modelo.
- **Enrutamiento por Estimación de Dificultad**: Usa un modelo proxy o métricas (perplejidad, logprobs) para estimar si un modelo pequeño es suficiente.
- **Modelo Guardián (Guard Model)**: Modelo pequeño que decide si una consulta debe ser escalada a un modelo más grande.
- **Enrutamiento Predictivo**: Entrena un predictor de rendimiento que estima qué modelo dará la mejor respuesta para cada entrada.
- **Costo vs. Calidad**: Trade-off fundamental. El router debe balancear precisión y costo económico/computacional.

## Ejemplo: Router basado en clasificador

```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import re

class LLMRouter:
    def __init__(self):
        self.classifier = LogisticRegression()
        self.vectorizer = TfidfVectorizer(max_features=1000)
        self.trained = False

    def train(self, queries, labels):
        # labels: 'simple' | 'complejo' | 'matematicas' | 'codigo'
        X = self.vectorizer.fit_transform(queries)
        self.classifier.fit(X, labels)
        self.trained = True

    def route(self, query):
        if not self.trained:
            return self._rule_based(query)
        X = self.vectorizer.transform([query])
        category = self.classifier.predict(X)[0]
        return self._model_for_category(category)

    def _rule_based(self, query):
        if len(query.split()) < 5:
            return "modelo_rapido"  # modelo pequeño
        if re.search(r'\b(suma|resta|ecuación|derivada|integral)\b', query, re.I):
            return "modelo_matematicas"
        if re.search(r'\b(código|python|función|bug|error)\b', query, re.I):
            return "modelo_codigo"
        return "modelo_general"

    def _model_for_category(self, category):
        routing = {
            'simple': 'modelo_rapido',
            'complejo': 'modelo_potente',
            'matematicas': 'modelo_matematicas',
            'codigo': 'modelo_codigo'
        }
        return routing.get(category, 'modelo_general')

router = LLMRouter()
router.train(
    ["¿Qué hora es?", "¿Cómo estás?", "Dime un chiste"],
    ["simple", "simple", "simple"]
)
print(router.route("Explica el teorema de Bayes"))
```

## Ejemplo: Routing por estimación de incertidumbre

```python
def uncertainty_routing(query, small_model, large_model, threshold=0.8):
    """Usa logprobs del modelo pequeño para decidir si escalar."""
    import numpy as np

    response = small_model(query, return_logprobs=True)
    confidence = np.exp(response['logprobs'].mean())

    if confidence < threshold:
        print(f"Escalando a modelo grande (confianza: {confidence:.3f})")
        return large_model(query)
    return response['text']

# Uso conceptual:
# result = uncertainty_routing("¿Qué es la teoría de la relatividad?",
#                              small_model=llama_7b,
#                              large_model=gpt_4,
#                              threshold=0.7)
```

## Tecnologías principales

- **OpenRouter**: API unificada para múltiples modelos con routing.
- **LangChain RouterChain**: Enrutamiento basado en condiciones y embeddings.
- **LlamaIndex Router**: Routers para queries en sistemas RAG.
- **Semantic Router**: Librería especializada en routing semántico usando embeddings.
- **MLflow**: Routing de modelos en producción por etapa (staging, production).

## Hoja de ruta

1. Router basado en reglas: keywords, longitud, regex.
2. Clasificador de intención para routing: entrenar modelo pequeño.
3. Routing por embeddings: similitud coseno con consultas históricas.
4. Routing por incertidumbre: logprobs, perplejidad para escalar.
5. Routing multi-modelo con balanceo de costo vs. calidad.
6. Integración con sistemas RAG: router decide recuperación vs. generación.
7. Monitoreo y adaptación del router con feedback de usuarios.

## Relaciones con otros módulos

- `../Caching/`: Combinación de caching + routing para optimizar costo y latencia.
- `../Evaluation/`: Evaluación del router: precisión de decisión, costo ahorrado.
- `../../037-AgenticAI/`: Agentes que deciden qué herramienta o modelo usar.
- `../../039-PromptEngineering/`: Prompts de sistema para configurar el comportamiento del router.

## Recursos recomendados

- **Documentación**: OpenRouter API Docs, Semantic Router Docs.
- **Paper**: "RouterBench: A Benchmark for Multi-LLM Routing Systems".
- **Blog**: "Building a Smart LLM Router" (Anyscale).
- **Repositorio**: semantic-router (GitHub).
