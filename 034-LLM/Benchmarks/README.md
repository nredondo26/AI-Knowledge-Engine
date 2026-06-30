# Benchmarks de LLMs

## Descripción del dominio

Los benchmarks de LLMs son conjuntos de pruebas estandarizadas diseñadas para medir y comparar el rendimiento de modelos de lenguaje en diversas capacidades: conocimiento factual, razonamiento matemático, generación de código, comprensión lectora, sentido común y seguridad. Proporcionan métricas objetivas para la comparación entre modelos y el seguimiento del progreso en la investigación. La elección del benchmark depende de la tarea objetivo: un modelo para código debe evaluarse en HumanEval, uno para diálogo en MT-Bench, uno para conocimiento en MMLU.

## Benchmarks principales

- **MMLU (Massive Multitask Language Understanding)**: 57 materias académicas (humanidades, STEM, ciencias sociales). Mide conocimiento factual y razonamiento. Formato multiple-choice.
- **HumanEval**: Generación de código Python a partir de docstrings. 164 problemas. Métrica: pass@k (tasa de éxito en k intentos).
- **GSM8K**: Problemas matemáticos de escuela primaria (8.5K). Requiere razonamiento multi-paso. Métrica: exact match.
- **HellaSwag**: Razonamiento de sentido común: elegir el final más plausible de una historia. 70K preguntas.
- **TruthfulQA**: Preguntas diseñadas para provocar respuestas falsas (creencias comunes incorrectas). Mide factualidad y honestidad.
- **BBH (BIG-Bench Hard)**: 23 tareas desafiantes de BIG-Bench que no fueron resueltas por modelos anteriores. Razonamiento multi-paso.
- **MT-Bench**: 80 preguntas multi-turno que evalúan utilidad general. Usa LLM-as-Judge para puntuar.
- **Chatbot Arena (LMSYS)**: Comparación por pares (ELO) basada en votos humanos.
- **MATH**: 12.500 problemas matemáticos de concurso (AMC, AIME, etc.). Alta dificultad.
- **ARC (AI2 Reasoning Challenge)**: Preguntas de ciencias de escuelas (3° a 9° grado). Dos versiones: Challenge y Easy.

## Ejemplo: Evaluar modelo en MMLU

```python
from lm_eval import evaluator
import lm_eval.models

# Usando la librería lm-eval-harness
def evaluate_mmlu(model_name="gpt2", num_fewshot=5):
    results = evaluator.simple_evaluate(
        model="hf",
        model_args=f"pretrained={model_name}",
        tasks=["mmlu"],
        num_fewshot=num_fewshot,
        batch_size=8
    )
    return results['results']

# Para modelos de API:
results = evaluator.simple_evaluate(
    model="openai-completion",
    model_args="model=gpt-4",
    tasks=["mmlu"],
    num_fewshot=5
)

mmlu_score = results['results']['mmlu']['acc']
print(f"MMLU Score: {mmlu_score:.3f}")
```

## Ejemplo: Evaluación en HumanEval

```python
!pip install evaluate human_eval  # human_eval de OpenAI

from human_eval.data import read_problems, write_jsonl
from human_eval.evaluation import evaluate_functional_correctness

# Obtener problemas
problems = read_problems()

def generate_one_completion(prompt):
    # Llamar al LLM para generar código dado el prompt
    response = openai.Completion.create(
        model="code-davinci-002",
        prompt=prompt,
        max_tokens=256,
        temperature=0.0,
        stop=["\ndef", "\nclass", "\nprint"]
    )
    return response.choices[0].text

# Generar soluciones para los primeros 10 problemas
for task_id in list(problems.keys())[:10]:
    completion = generate_one_completion(problems[task_id]["prompt"])
    print(f"{task_id}: {completion[:50]}...")

# Evaluación completa (requiere sandbox para ejecución segura)
# evaluate_functional_correctness("samples.jsonl", k=[1, 10, 100])
```

## Tecnologías principales

- **EleutherAI LM Evaluation Harness**: Framework completo para benchmarks.
- **OpenAI Evals**: Benchmarks GPT-4, HumanEval, MATH.
- **MT-Bench / Chatbot Arena**: Evaluación de conversación multi-turno.
- **AlpacaEval**: Evaluación automática con GPT-4.
- **HELM (Holistic Evaluation of Language Models)**: Benchmark integral de Stanford.
- **DeepEval**: Testing unitario y evaluación offline.
- **LangFuse / Weights & Biases**: Platformas de evaluación y monitoreo.

## Hoja de ruta

1. Entender los benchmarks principales y qué capacidad mide cada uno.
2. Ejecutar lm-eval-harness con modelos open-source en local.
3. Evaluar modelos comerciales (GPT-4, Claude, Gemini) vía API en benchmarks.
4. Analizar resultados por subcategoría para identificar fortalezas/debilidades.
5. Evaluación multi-dimensional: no solo accuracy sino también latencia y costo.
6. Evaluación de seguridad: TruthfulQA, red teaming.
7. Construir un benchmark personalizado para el dominio de aplicación.

## Relaciones con otros módulos

- `../Evaluation/`: Benchmarks como herramientas dentro del marco de evaluación.
- `../Routing/`: Usar scores de benchmarks para decidir qué modelo usar.
- `../Caching/`: Evaluar impacto del caching en benchmarks.
- `../Security/`: Benchmarks de seguridad (TruthfulQA, ToxicChat, HarmBench).

## Recursos recomendados

- **Paper**: "Measuring Massive Multitask Language Understanding" (MMLU, 2020).
- **Paper**: "Evaluating Large Language Models Trained on Code" (HumanEval, 2021).
- **Paper**: "Holistic Evaluation of Language Models" (HELM, 2022).
- **Documentación**: EleutherAI LM Eval Harness Docs.
- **Leaderboard**: Chatbot Arena Leaderboard (LMSYS), Open LLM Leaderboard (Hugging Face).
