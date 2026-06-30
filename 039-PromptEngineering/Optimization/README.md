# Optimización de Prompts (Optimization)

## Descripción del dominio

La optimización de prompts es el proceso sistemático de mejorar las instrucciones dadas a modelos de lenguaje para maximizar métricas específicas como precisión, relevancia, adherencia a formato, seguridad o eficiencia de tokens. A diferencia de la escritura manual de prompts que depende de la intuición y prueba y error, la optimización utiliza métodos estructurados: A/B testing, búsqueda por gradiente de texto, aprendizaje por refuerzo, evolución de prompts, y frameworks como DSPy que tratan los prompts como módulos compilables. La optimización puede ser manual (iteración humana basada en evaluación) o automática (algoritmos que generan y evaluan variaciones de prompts). Las dimensiones de optimización incluyen: contenido del prompt (instrucciones, ejemplos, formato), parámetros de generación (temperature, top_p, presence_penalty), estructura (orden de secciones, delimitadores), y selección de ejemplos few-shot.

## Conceptos clave

- **A/B Testing**: Comparación de dos versiones de prompt (A y B) con la misma entrada para medir diferencias en calidad de respuesta.
- **Prompt Iteration**: Ciclo de mejora continua: diseñar → probar → evaluar → refinar. Cada iteración afina el prompt basado en resultados.
- **DSPy (Declarative Self-improving Python)**: Framework que trata los prompts como módulos de programa. Optimiza prompts automáticamente usando métricas y ejemplos de entrenamiento.
- **Automatic Prompt Optimization (APO)**: Algoritmos que generan, evalúan y seleccionan variaciones de prompts. Incluye búsqueda por gradiente de texto, optimización evolutiva.
- **Gradient of Text**: Técnica que calcula "gradientes textuales" — sugerencias de mejora generadas por un LLM evaluador — y los aplica al prompt.
- **Prompt Template**: Plantilla con placeholders. Optimizar la plantilla es más eficiente que prompts individuales.
- **Hyperparameter Tuning**: Ajuste de temperatura, top_p, presence_penalty, frequency_penalty, max_tokens, stop sequences.
- **Evaluation Metrics**: Métricas para medir calidad: exact match, F1, BLEU, ROUGE, METEOR, BERTScore, LLM-as-Judge, task-specific metrics.
- **Prompt Versioning**: Control de versiones con Git o LangSmith Hub.
## Ejemplo: A/B Testing de prompts

```python
import random
from openai import OpenAI

client = OpenAI()

prompt_a = """Traduce el siguiente texto al español:
{texto}
Traducción:"""

prompt_b = """Actúa como traductor profesional especializado en español.
Traduce el siguiente texto del inglés al español con precisión y naturalidad:
"{texto}"
Proporciona solo la traducción, sin explicaciones:"""

test_cases = [
    "Hello, how are you?",
    "The quick brown fox jumps over the lazy dog.",
    "Artificial intelligence is transforming the world."
]

def evaluate_translation(prompt, text):
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt.format(texto=text)}],
        temperature=0
    )
    return response.choices[0].message.content

def score_translation(original, translation):
    prompt = f"""Original: {original}
Traducción: {translation}
Puntúa la calidad de la traducción del 1 al 5 (5 = excelente).
Considera: precisión, naturalidad y gramática.
Solo responde con el número:"""
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        temperature=0
    )
    return float(response.choices[0].message.content.strip())

# Ejecutar A/B test
scores = {"A": [], "B": []}
for case in test_cases:
    for version, prompt in [("A", prompt_a), ("B", prompt_b)]:
        translation = evaluate_translation(prompt, case)
        score = score_translation(case, translation)
        scores[version].append(score)

print(f"Prompt A: {sum(scores['A'])/len(scores['A']):.2f}")
print(f"Prompt B: {sum(scores['B'])/len(scores['B']):.2f}")
```

## DSPy: Optimización automática

```python
import dspy
from dspy.teleprompt import BootstrapFewShot

# Configurar LM
lm = dspy.OpenAI(model="gpt-4o-mini", max_tokens=1000)
dspy.settings.configure(lm=lm)

# Definir módulo DSPy (prompt como programa)
class ClasificadorSentimiento(dspy.Signature):
    """Clasifica el sentimiento de un texto como positivo, negativo o neutro."""
    texto = dspy.InputField()
    sentimiento = dspy.OutputField()

class Clasificador(dspy.Module):
    def __init__(self):
        self.clasificar = dspy.Predict(ClasificadorSentimiento)
    
    def forward(self, texto):
        return self.clasificar(texto=texto)

# Datos de entrenamiento
train_data = [
    dspy.Example(texto="Me encanta este producto", sentimiento="positivo").with_inputs("texto"),
    dspy.Example(texto="Pésimo servicio", sentimiento="negativo").with_inputs("texto"),
    dspy.Example(texto="El pedido llegó a tiempo", sentimiento="neutro").with_inputs("texto"),
]

# Definir métrica
def metric(example, prediction, trace=None):
    return example.sentimiento == prediction.sentimiento

# Optimizar prompt automáticamente
optimizer = BootstrapFewShot(metric=metric, max_bootstrapped_demos=4)
optimized = optimizer.compile(Clasificador(), trainset=train_data)

# Usar prompt optimizado
result = optimized(texto="Estoy muy satisfecho con la compra")
print(f"Sentimiento: {result.sentimiento}")

# Ver el prompt optimizado
optimized_prompt = lm.inspect_history(n=1)
print(f"Prompt optimizado:\n{optimized_prompt}")
```

## Estrategias de optimización

| Estrategia | Descripción | Cuándo usarla |
|---|---|---|
| Iteración Manual | Probar variaciones manualmente | Prototipado, tareas simples |
| A/B Testing | Comparar dos versiones sistemáticamente | Validar cambios específicos |
| Grid Search | Probar combinaciones de parámetros | Encontrar hiperparámetros óptimos |
| DSPy | Optimización automática con ejemplos | Tareas con datos etiquetados |
| APO (Gradiente de Texto) | LLM sugiere mejoras iterativamente | Refinamiento fino de prompts |
| Evolutivo | Mutaciones y selección de prompts | Espacios de búsqueda grandes |
| RL from Feedback | Aprendizaje por refuerzo con feedback humano | Alineación con preferencias |

## Relaciones con otros módulos

- `../FewShot/`: Optimización de selección y orden de ejemplos few-shot.
- `../SystemPrompts/`: Optimización de instrucciones de sistema.
- `../Safety/`: Optimización de seguridad y robustez.
- `../Evaluation/`: Evaluación de prompts optimizados.
- `../ChainOfThought/`: Optimización de prompts de razonamiento.
- `./TreeOfThought/`: Optimización de parámetros de exploración ToT.
- `../../034-LLM/`: Optimización de parámetros de generación del LLM.

## Recursos recomendados

- **Paper**: "DSPy: Compiling Declarative Language Model Calls into Self-Improving Pipelines" (Khattab et al., 2023).
- **Paper**: "Automatic Prompt Optimization with Gradient of Text" (Pryzant et al., 2023).
- **Framework**: DSPy (github.com/stanfordnlp/dspy), Promptfoo (promptfoo.dev).
- **Guía**: "Prompt Optimization Guide" (LangSmith, Anthropic).
- **Herramientas**: LangSmith Hub, Anthropic Console, PromptLayer.
- **Video**: "Systematic Prompt Optimization" (DSPy, Stanford).
