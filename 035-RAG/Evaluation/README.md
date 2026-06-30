# Evaluación de RAG (Evaluation)

## Descripción del dominio

La evaluación de sistemas RAG (Retrieval Augmented Generation) es un proceso multidimensional que mide tanto la calidad de la recuperación (retrieval) como la calidad de la generación (generation), así como su interacción. A diferencia de la evaluación tradicional de LLMs que se centra en la fluidez y coherencia, la evaluación de RAG debe verificar que las respuestas generadas están fundamentadas en los documentos recuperados, que los documentos recuperados son relevantes para la consulta, y que el sistema en su conjunto produce información precisa y útil. Los frameworks principales son RAGAS (con métricas como fidelidad, relevancia de respuesta, relevancia de contexto y recall de contexto), TruLens (con trinity de evaluation: groundedness, context relevance, answer relevance) y DeepEval. La evaluación puede ser automática (usando LLMs como jueces), basada en datasets de referencia (ground truth) o mediante anotación humana.

## Conceptos clave

- **Fidelidad (Faithfulness)**: La respuesta generada está factualmente respaldada por los documentos recuperados. Mide alucinaciones: afirmaciones no soportadas por el contexto.
- **Relevancia de Respuesta (Answer Relevance)**: La respuesta generada es relevante y responde adecuadamente a la consulta del usuario. No mide corrección factual, solo pertinencia.
- **Relevancia de Contexto (Context Relevance)**: Los documentos recuperados son relevantes para la consulta. Mide la precisión del retrieval: qué porcentaje del contexto recuperado es útil.
- **Recall de Contexto (Context Recall)**: Mide si todos los documentos relevantes para responder la consulta fueron recuperados. Relacionado con el recall del retrieval.
- **Groundedness**: Métrica de TruLens que verifica que cada afirmación en la respuesta tenga una fuente en los documentos recuperados.
- **LLM-as-Judge**: Uso de un LLM (GPT-4, Claude) para evaluar las respuestas del sistema RAG. Escalable pero puede tener sesgos.
- **Evaluación por Componentes**: Evaluar retrieval (precision@k, recall@k, MRR, NDCG) y generación (BLEU, ROUGE, METEOR, BERTScore) por separado.
- **Evaluación End-to-End**: Evaluar el sistema completo: consulta → respuesta final. Mide la calidad percibida por el usuario.
- **Dataset de Evaluación**: Conjunto de pares (pregunta, respuesta esperada, documentos relevantes) usados para medir rendimiento.
- **Métricas de Retrieval**: precision@k (fracción de relevantes en top-k), recall@k (fracción de todos los relevantes recuperados), MRR (Mean Reciprocal Rank), NDCG (Normalized Discounted Cumulative Gain), MAP (Mean Average Precision).

## Frameworks de evaluación

- **RAGAS**: Framework líder. Métricas: faithfulness, answer_relevancy, context_precision, context_recall, context_entities_recall. Puntaje compuesto RAGAS Score. Integración con LangChain, LlamaIndex.
- **TruLens**: Trinity de evaluación: groundedness, context relevance, answer relevance. Feedback functions modulares. Dashboard de monitoreo.
- **DeepEval**: Framework open source. Métricas: hallucination, answer relevancy, faithfulness, contextual precision, recall, G-Eval, summarization. Pytest integrado.
- **LangSmith**: Plataforma de LangChain con tracing, evaluación y monitoreo. Datasets, feedback, comparación de versiones de prompts y modelos.
- **Arize AI**: Observabilidad para ML y LLMs. Evaluación de RAG con métricas de retrieval y generación. Detección de drift.
- **Phoenix (Arize)**: Open source LLM observability. Tracing de RAG, evaluación de retrieval y generación, detección de alucinaciones.

## Ejemplo: Evaluación con RAGAS

```python
from ragas import evaluate
from ragas.metrics import (
    faithfulness,
    answer_relevancy,
    context_precision,
    context_recall
)
from datasets import Dataset

samples = Dataset.from_dict({
    "question": ["¿Qué es RAG?", "¿Cómo funciona el embedding?"],
    "answer": ["RAG es una arquitectura...", "El embedding convierte..."],
    "contexts": [["doc1...", "doc2..."], ["doc3..."]],
    "ground_truth": ["Respuesta correcta A", "Respuesta correcta B"]
})

result = evaluate(
    samples,
    metrics=[
        faithfulness, answer_relevancy,
        context_precision, context_recall
    ]
)

print(result.to_pandas())
```

## Ejemplo: Evaluación con DeepEval

```python
from deepeval import assert_test
from deepeval.metrics import FaithfulnessMetric, AnswerRelevancyMetric
from deepeval.test_case import LLMTestCase

test_case = LLMTestCase(
    input="¿Cuál es el límite de tokens?",
    actual_output="El límite es 4096 tokens...",
    retrieval_context=["La ventana de contexto es de 4096 tokens..."]
)

faithfulness = FaithfulnessMetric()
answer_relevancy = AnswerRelevancyMetric()

assert_test(test_case, [faithfulness, answer_relevancy])
```

## Métricas de Retrieval

```python
from sklearn.metrics import ndcg_score
import numpy as np

# precision@k, recall@k, MRR
def precision_at_k(retrieved, relevant, k):
    retrieved_k = retrieved[:k]
    return len(set(retrieved_k) & set(relevant)) / k

def recall_at_k(retrieved, relevant, k):
    retrieved_k = retrieved[:k]
    return len(set(retrieved_k) & set(relevant)) / len(relevant)

def mrr(retrieved_sets_per_query, relevant_per_query):
    total = 0
    for retrieved, relevant in zip(retrieved_sets_per_query, relevant_per_query):
        for i, doc in enumerate(retrieved):
            if doc in relevant:
                total += 1.0 / (i + 1)
                break
    return total / len(retrieved_sets_per_query)
```

## Relaciones con otros módulos

- `../HybridSearch/`: Evaluación de búsqueda híbrida vs. semántica pura.
- `../Pipelines/`: Evaluación de pipelines RAG completos.
- `../AdvancedRAG/`: Evaluación de técnicas avanzadas como GraphRAG o RAPTOR.
- `../Chunking/`: Impacto de la estrategia de chunking en métricas de retrieval.
- `../Reranking/`: Evaluación de mejora con reranking.
- `../../039-PromptEngineering/Evaluation/`: Evaluación de prompts usados en RAG.
- `../../034-LLM/`: Evaluación de LLMs subyacentes al generador.

## Recursos recomendados

- **Paper**: "RAGAS: Automated Evaluation of Retrieval Augmented Generation" (Shahul et al., 2023).
- **Paper**: "TruLens: Evaluating LLM Applications" (TruEra, 2023).
- **Documentación**: RAGAS docs, TruLens docs, DeepEval docs, LangSmith docs.
- **Guía**: "Evaluating RAG Systems" (Anyscale).
- **Repositorio**: explodinggradients/ragas, truera/trulens, confident-ai/deepeval.
- **Video**: "How to Evaluate RAG Systems" (LangChain YouTube).
