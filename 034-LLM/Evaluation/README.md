# Evaluación de LLMs (Evaluation)

## Descripción del dominio

La evaluación de Large Language Models (LLMs) es el proceso de medir sistemáticamente la calidad, seguridad y utilidad de las respuestas generadas. Dada la naturaleza abierta y generativa de los LLMs, la evaluación va más allá de métricas simples de clasificación. Abarca la corrección factual, la alineación con instrucciones, la seguridad, la ausencia de sesgo, la capacidad de razonamiento y la calidad percibida por humanos. La evaluación es crítica para el desarrollo, fine-tuning, comparación de modelos y monitoreo en producción.

## Categorías de evaluación

- **Evaluación Automática con Métricas**: BLEU (traducción), ROUGE (resumen), METEOR, BERTScore, Perplejidad, Exact Match (EM).
- **Evaluación con LLM-as-Judge**: Usar un LLM (GPT-4, Claude) para evaluar respuestas de otro LLM. Correlaciona bien con evaluaciones humanas.
- **Benchmarks Estandarizados**: MMLU (conocimiento), HumanEval (código), GSM8K (matemáticas), HellaSwag (sentido común), TruthfulQA (factualidad).
- **Evaluación Humana**: Anotadores humanos evalúan calidad, utilidad, seguridad. Costoso pero gold standard.
- **Evaluación de Seguridad (Red Teaming)**: Pruebas adversariales para detectar jailbreaks, sesgos, contenido dañino.
- **Evaluación de Alineación**: ¿El modelo sigue las instrucciones? ¿Respeta el system prompt? ¿Mantiene el rol asignado?

## Ejemplo: Evaluación con BERTScore

```python
from bert_score import score
from datasets import load_dataset

# Cargar dataset de referencia
references = ["El gato está en la alfombra", "Hace sol hoy"]
candidates = ["El gato está sobre la alfombra", "Hoy está soleado"]

P, R, F1 = score(candidates, references, lang="es", verbose=True)
print(f"Precisión: {P.mean():.4f}")
print(f"Recall: {R.mean():.4f}")
print(f"F1: {F1.mean():.4f}")
```

## Ejemplo: LLM-as-Judge

```python
import openai  # o cualquier API de LLM

def evaluate_with_llm(prompt, response, criteria):
    evaluator_prompt = f"""
    Evalúa la siguiente respuesta según estos criterios:
    {criteria}

    Prompt: {prompt}
    Respuesta: {response}

    Proporciona una puntuación del 1 al 5 para estos aspectos:
    - Corrección factual
    - Utilidad
    - Seguridad
    - Claridad

    Responde SOLO con un JSON:
    {{"correccion": int, "utilidad": int, "seguridad": int, "claridad": int}}
    """

    eval_response = openai.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": evaluator_prompt}],
        response_format={"type": "json_object"}
    )
    return eval_response.choices[0].message.content

# Uso
result = evaluate_with_llm(
    prompt="Explica la fotosíntesis",
    response="La fotosíntesis es el proceso...",
    criteria="Precisión científica, nivel educativo apropiado"
)
print(result)
```

## Ejemplo: Evaluación de respuesta correcta vs. generada

```python
from nltk.translate.bleu_score import sentence_bleu, SmoothingFunction
from rouge_score import rouge_scorer
import numpy as np

def evaluate_summary(reference, candidate):
    """Evalúa un resumen generado vs. referencia."""
    # BLEU
    smoothie = SmoothingFunction().method1
    bleu = sentence_bleu([reference.split()], candidate.split(),
                         smoothing_function=smoothie)

    # ROUGE
    scorer = rouge_scorer.RougeScorer(['rouge1', 'rouge2', 'rougeL'], use_stemmer=True)
    scores = scorer.score(reference, candidate)

    return {
        'bleu': bleu,
        'rouge1_f1': scores['rouge1'].fmeasure,
        'rouge2_f1': scores['rouge2'].fmeasure,
        'rougeL_f1': scores['rougeL'].fmeasure
    }

ref = "El modelo de lenguaje mostró excelente rendimiento en las pruebas"
cand = "El modelo de lenguaje tuvo un gran desempeño en las evaluaciones"
print(evaluate_summary(ref, cand))
```

## Tecnologías principales

- **EleutherAI LM Eval Harness**: Framework estándar para benchmarks de LLMs.
- **OpenAI Evals**: Framework de OpenAI para evaluar LLMs.
- **LangFuse / Weights & Biases**: Monitoreo y evaluación en producción.
- **BERTScore**: Evaluación de generación de texto basada en embeddings BERT.
- **Rouge / BLEU**: Métricas clásicas para resumen y traducción.
- **Anthropic Eval**: Framework de Anthropic para evaluaciones de seguridad.
- **DeepEval**: Framework de testing unitario para LLMs.

## Hoja de ruta

1. Perplejidad y loss como métricas básicas de calidad del modelo.
2. BLEU, ROUGE, METEOR para tareas de generación.
3. BERTScore para evaluación semántica sin referencia exacta.
4. LLM-as-Judge: prompt de evaluación, calibración con humanos.
5. Benchmarks estandarizados: MMLU, HumanEval, GSM8K.
6. Evaluación de seguridad: red teaming, jailbreak detection.
7. Monitoreo continuo en producción: drift, calidad, feedback loop.

## Relaciones con otros módulos

- `../Benchmarks/`: Benchmarks específicos como herramientas de evaluación.
- `../Security/`: Evaluación de seguridad y robustness.
- `../Routing/`: Evaluación del rendimiento del router.
- `../Caching/`: Evaluación del impacto del caching en calidad.
- `../../032-MachineLearning/MLflow/`: Seguimiento de métricas de evaluación.

## Recursos recomendados

- **Paper**: "Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena" (Zheng et al., 2023).
- **Paper**: "Holistic Evaluation of Language Models" (Liang et al., 2022).
- **Documentación**: EleutherAI LM Eval Harness, OpenAI Evals.
- **Repositorio**: EleutherAI/lm-evaluation-harness (GitHub), openai/evals (GitHub).
