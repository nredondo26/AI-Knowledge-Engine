# Few-Shot Prompting

## Descripción del dominio

Few-Shot Prompting es una técnica de ingeniería de prompts que consiste en incluir ejemplos de entrada y salida esperada dentro del prompt para guiar el comportamiento del modelo de lenguaje sin necesidad de fine-tuning. A diferencia del Zero-Shot (sin ejemplos), el Few-Shot proporciona al LLM demostraciones concretas del formato, tono, estructura y razonamiento esperados. Los ejemplos actúan como contexto en la ventana del modelo, permitiéndole inferir el patrón y aplicarlo a nuevas entradas. La efectividad del Few-Shot depende críticamente de la calidad, relevancia y orden de los ejemplos seleccionados. Las variantes incluyen Few-Shot estático (ejemplos fijos), Few-Shot dinámico (ejemplos seleccionados por similitud semántica con la consulta), Few-Shot con etiquetas (ejemplos con razonamiento explícito) y Few-Shot multi-turno (ejemplos de conversaciones completas).

## Conceptos clave

- **Shot**: Cada par (entrada, salida) incluido como ejemplo. "3-shot" significa 3 ejemplos.
- **Zero-Shot**: Sin ejemplos. El modelo debe inferir la tarea solo con la instrucción.
- **One-Shot**: Un solo ejemplo. Útil para tareas simples o cuando el contexto es limitado.
- **Few-Shot**: Múltiples ejemplos (típicamente 2-5). Balance entre guiar al modelo y consumir tokens de contexto.
- **Many-Shot**: Muchos ejemplos (10+). Puede saturar el contexto pero da patrones muy claros.
- **Ejemplo Dinámico (Dynamic Few-Shot)**: Los ejemplos se seleccionan en tiempo real según la consulta del usuario usando búsqueda semántica en un banco de ejemplos.
- **Orden de Ejemplos**: La disposición de los ejemplos afecta el rendimiento. Generalmente: ejemplos diversos primero, luego similares a la consulta.
- **Label Space**: El conjunto de posibles etiquetas o salidas. Los ejemplos deben cubrir todo el label space para evitar sesgos.
- **Formato Consistente**: Todos los ejemplos deben seguir exactamente el mismo formato (estructura, delimitadores, estilo) para que el modelo generalice correctamente.
- **Ejemplos con Razonamiento (Chain-of-Thought Few-Shot)**: Ejemplos que incluyen pasos intermedios de razonamiento, no solo la entrada y salida final.

## Ejemplo: Clasificación de sentimiento

```python
from openai import OpenAI

client = OpenAI()

prompt = """
Clasifica el sentimiento del siguiente texto como POSITIVO, NEGATIVO o NEUTRO.

Ejemplos:
Texto: Me encanta este producto, funciona perfectamente.
Sentimiento: POSITIVO

Texto: Pésimo servicio al cliente, nunca volveré.
Sentimiento: NEGATIVO

Texto: El pedido llegó en la fecha estimada.
Sentimiento: NEUTRO

Texto: La calidad es aceptable para el precio que pagué.
Sentimiento:

Texto: Estoy muy decepcionado con la atención recibida.
Sentimiento:
"""

response = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[{"role": "user", "content": prompt}],
    temperature=0
)
print(response.choices[0].message.content)
```

## Ejemplo: Few-Shot dinámico

```python
from openai import OpenAI
import numpy as np

class DynamicFewShot:
    def __init__(self, example_db, embedding_model):
        self.examples = example_db  # Lista de {"input": str, "output": str, "embedding": list}
        self.embedding_model = embedding_model

    def select_examples(self, query, n=3):
        """Selecciona los n ejemplos más similares a la query."""
        query_emb = self.embedding_model.encode(query)
        similarities = [
            np.dot(query_emb, ex["embedding"])
            for ex in self.examples
        ]
        indices = np.argsort(similarities)[-n:][::-1]
        return [self.examples[i] for i in indices]

    def build_prompt(self, query, system_instruction, n=3):
        examples = self.select_examples(query, n)
        prompt = system_instruction + "\n\n"
        for ex in examples:
            prompt += f"Input: {ex['input']}\nOutput: {ex['output']}\n\n"
        prompt += f"Input: {query}\nOutput:"
        return prompt

few_shot = DynamicFewShot(example_db, embedding_model)
prompt = few_shot.build_prompt(
    query="Traduce 'Hello world' al español",
    system_instruction="Traduce del inglés al español."
)
```

## Estrategias de selección de ejemplos

- **Aleatoria**: Seleccionar ejemplos al azar del banco. Simple pero no óptima.
- **Por Similitud (k-NN)**: Seleccionar ejemplos más similares semánticamente a la consulta. Mejor rendimiento general.
- **Diversidad Máxima**: Seleccionar ejemplos que cubran diferentes clases, estilos o dificultades. Evita sesgo hacia una clase.
- **Por Dificultad**: Seleccionar ejemplos con dificultad similar a la consulta esperada.
- **Balanceado**: Asegurar representación equitativa de todas las clases o categorías.
- **Relevancia Inversa**: Para tareas de generación, seleccionar ejemplos que NO sean demasiado similares para evitar copia literal.

## Consideraciones prácticas

- **Número de ejemplos**: 2-5 ejemplos suele ser óptimo. Más ejemplos consumen tokens y pueden introducir ruido. Para tareas complejas, 5-10 puede ser mejor.
- **Calidad sobre cantidad**: Un ejemplo perfectamente diseñado vale más que cinco mediocres.
- **Orden**: Colocar ejemplos diversos primero. Si hay un ejemplo particularmente relevante, colocarlo al final (recencia).
- **Formato**: Usar delimitadores consistentes (---, ###, Input:/Output:). El formato debe ser idéntico entre ejemplos.
- **Casos extremos (edge cases)**: Incluir ejemplos de casos difíciles o ambiguos mejora la robustez.
- **Evitar fugas**: No incluir la respuesta esperada de la consulta actual como ejemplo.

## Relaciones con otros módulos

- `../SystemPrompts/`: Combinación de system prompt + few-shot para definir comportamiento completo.
- `../ChainOfThought/`: Few-shot con razonamiento paso a paso para tareas complejas.
- `../TreeOfThought/`: Few-shot para exploración de múltiples caminos de razonamiento.
- `../Optimization/`: Optimización de la selección y orden de ejemplos few-shot.
- `../Evaluation/`: Evaluación del impacto de diferentes configuraciones few-shot.
- `../../037-AgenticAI/`: Few-shot para guiar comportamiento de agentes.

## Recursos recomendados

- **Paper**: "Language Models are Few-Shot Learners" (Brown et al., 2020) — GPT-3, el paper fundacional.
- **Paper**: "Rethinking the Role of Demonstrations: What Makes In-Context Learning Work?" (Min et al., 2022).
- **Paper**: "Few-Shot Parameter-Efficient Fine-Tuning is Better and Cheaper than In-Context Learning" (Liu et al., 2022).
- **Guía**: "Prompt Engineering Guide: Few-Shot" (promptingguide.ai).
- **Blog**: "Dynamic Few-Shot Prompting" (Anthropic).
- **Herramientas**: LangChain FewShotPromptTemplate, LlamaIndex few-shot.
