# Equidad en IA (Fairness)

## Descripción del dominio

La equidad en Inteligencia Artificial se refiere a la ausencia de discriminación injusta en las decisiones tomadas por sistemas automatizados. Diferentes definiciones matemáticas de equidad capturan distintos aspectos de lo que significa ser "justo", y muchas veces estas definiciones son mutuamente incompatibles. El objetivo no es encontrar una definición universal, sino elegir la apropiada para cada contexto, considerando el impacto social, legal y ético del sistema.

## Definiciones de equidad

- **Igualdad de Oportunidades**: TPR (tasa de verdaderos positivos) igual entre grupos. El modelo debe predecir correctamente con la misma tasa para todos los grupos.
- **Paridad Demográfica**: La tasa de predicción positiva es igual entre grupos. Independientemente de la etiqueta real, el modelo asigna resultados positivos con la misma frecuencia.
- **Impacto Desigual (Disparate Impact)**: La razón entre la tasa de predicción positiva del grupo desfavorecido y el grupo favorecido debe superar 0.8 (regla 4/5).
- **Equidad por Igualdad de Probabilidades**: TPR y FPR iguales entre grupos. El modelo comete los mismos errores para todos los grupos.
- **Equidad Contractual**: Individuos similares deben recibir predicciones similares (contra-factual).
- **Equidad Individual**: Individuos que son iguales en todas las características relevantes deben ser tratados igual.

## Ejemplo: Cálculo de métricas de equidad

```python
import numpy as np
import pandas as pd
from sklearn.metrics import confusion_matrix

def fairness_metrics(y_true, y_pred, sensitive_attr):
    groups = np.unique(sensitive_attr)
    results = []

    for g in groups:
        mask = sensitive_attr == g
        yt, yp = y_true[mask], y_pred[mask]
        tn, fp, fn, tp = confusion_matrix(yt, yp).ravel()

        tpr = tp / (tp + fn) if (tp + fn) > 0 else 0
        fpr = fp / (fp + tn) if (fp + tn) > 0 else 0
        ppr = yp.mean()
        accuracy = (tp + tn) / (tp + tn + fp + fn)

        results.append({'grupo': g, 'TPR': tpr, 'FPR': fpr,
                        'PPR': ppr, 'accuracy': accuracy,
                        'n': mask.sum()})

    df = pd.DataFrame(results)

    # Métricas de disparidad
    tpr_ratio = df['TPR'].min() / df['TPR'].max()
    ppr_ratio = df['PPR'].min() / df['PPR'].max()
    print(f"TPR ratio (igualdad oportunidades): {tpr_ratio:.3f}")
    print(f"PPR ratio (impacto dispar): {ppr_ratio:.3f}")

    return df
```

## Ejemplo: Post-procesamiento para equidad

```python
from sklearn.linear_model import LogisticRegression

def equalized_odds_postprocessing(y_true, y_pred, sensitive_attr):
    """Ajusta umbrales de decisión por grupo para igualar TPR y FPR."""
    groups = np.unique(sensitive_attr)
    thresholds = {}

    for g in groups:
        mask = sensitive_attr == g
        yt, yp = y_true[mask], y_pred[mask]
        # Buscar umbral que iguale TPR y FPR a los del grupo mayoritario
        # (implementación simplificada: usa la media por grupo)
        mejor_tpr = yt[yp >= 0.5].mean() if (yp >= 0.5).sum() > 0 else 0
        thresholds[g] = 0.5  # punto de partida

    return thresholds

# Uso con calibración por grupo
def predict_fair(model, X, sensitive_attr, thresholds):
    scores = model.predict_proba(X)[:, 1]
    y_pred = np.zeros_like(scores)
    for g, umbral in thresholds.items():
        mask = sensitive_attr == g
        y_pred[mask] = (scores[mask] >= umbral).astype(int)
    return y_pred
```

## Tecnologías principales

- **AIF360**: Implementaciones de mitigación pre-procesamiento, in-procesamiento y post-procesamiento.
- **Fairlearn**: Reducir la desigualdad con algoritmos como Exponentiated Gradient, Threshold Optimizer.
- **Aequitas**: Reportes automatizados de equidad para auditoría.
- **What-If Tool**: Exploración visual de trade-offs entre exactitud y equidad.
- **FairML**: Diagnóstico de contribuciones de características al sesgo.

## Hoja de ruta

1. Entender las diferentes definiciones de equidad y sus trade-offs.
2. Calcular métricas de equidad (paridad demográfica, igualdad de oportunidades).
3. Usar AIF360 para auditar un modelo existente.
4. Aplicar mitigación pre-procesamiento (re-ponderación, re-muestreo).
5. Aplicar mitigación in-procesamiento (restricciones en el optimizador).
6. Aplicar mitigación post-procesamiento (ajuste de umbrales).
7. Evaluar trade-offs entre exactitud y equidad para el contexto dado.

## Relaciones con otros módulos

- `../Bias/`: Identificación de sesgo como paso previo a la mitigación de equidad.
- `../Ethics/`: Marco ético para decisiones sobre equidad.
- `../../034-LLM/Security/`: Equidad en respuestas de LLMs.
- `../../032-MachineLearning/Supervised/`: Modelos supervisados donde se aplican métricas de equidad.

## Recursos recomendados

- **Paper**: "Fairness Definitions Explained" (Verma & Rubin, 2018).
- **Paper**: "Income Disparity in ML: A Survey of Fairness Definitions" (Narayanan, 2018).
- **Documentación**: AIF360 User Guide, Fairlearn User Guide.
- **Curso**: "Fairness in Machine Learning" (Barocas, Hardt) — YouTube.
- **Repositorio**: aif360 (IBM), fairlearn (Microsoft).
