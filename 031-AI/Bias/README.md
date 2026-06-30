# Sesgo en IA (Bias)

## Descripción del dominio

El sesgo en sistemas de IA se refiere a errores sistemáticos que resultan en resultados injustos o discriminatorios para ciertos grupos de personas. El sesgo puede originarse en múltiples etapas: datos de entrenamiento desbalanceados, etiquetado subjetivo, diseño de características, arquitectura del modelo, o incluso en el despliegue. Identificar, medir y mitigar el sesgo es esencial para construir sistemas de IA éticos, justos y confiables.

## Tipos de sesgo

- **Sesgo de Datos**: El dataset no representa adecuadamente la población objetivo. Ej: datasets de visión con sobre-representación de piel clara.
- **Sesgo de Muestreo**: La muestra no es aleatoria ni representativa. Ej: encuestas solo en línea excluyen poblaciones sin acceso.
- **Sesgo de Etiquetado**: Anotadores introducen sus propios prejuicios. Ej: etiquetas ofensivas asociadas desproporcionadamente a ciertos grupos.
- **Sesgo de Confirmación**: El modelo aprende a reforzar estereotipos existentes en los datos.
- **Sesgo Algorítmico**: La función de pérdida o la arquitectura favorecen ciertos grupos. Ej: sistemas de reconocimiento facial con mayor error en mujeres de piel oscura.
- **Sesgo de Medición**: Las métricas no capturan adecuadamente el fenómeno de interés.
- **Sesgo de Despliegue**: El contexto de uso del modelo difiere del contexto de entrenamiento.

## Ejemplo: Detección de sesgo en clasificación binaria

```python
import numpy as np
from sklearn.metrics import confusion_matrix

def compute_bias_metrics(y_true, y_pred, sensitive_attr):
    """Calcula métricas de sesgo para un atributo sensible binario."""
    grupos = np.unique(sensitive_attr)
    metrics = {}

    for g in grupos:
        mask = sensitive_attr == g
        tn, fp, fn, tp = confusion_matrix(y_true[mask], y_pred[mask]).ravel()
        # Tasa de verdaderos positivos (TPR) = Recall
        tpr = tp / (tp + fn) if (tp + fn) > 0 else 0
        # Tasa de falsos positivos (FPR)
        fpr = fp / (fp + tn) if (fp + tn) > 0 else 0
        # Tasa de predicción positiva
        ppr = y_pred[mask].mean()
        metrics[g] = {'TPR': tpr, 'FPR': fpr, 'PPR': ppr}

    # Disparidad en TPR (igualdad de oportunidades)
    tpr_values = [metrics[g]['TPR'] for g in grupos]
    disparidad_tpr = abs(tpr_values[0] - tpr_values[1])
    return disparidad_tpr, metrics
```

## Ejemplo: Mitigación con re-ponderación de muestras

```python
from sklearn.utils.class_weight import compute_sample_weight
from sklearn.linear_model import LogisticRegression

def train_debiased_model(X, y, sensitive_attr):
    """Entrena modelo asignando pesos inversos a grupos desbalanceados."""
    sample_weights = compute_sample_weight('balanced', sensitive_attr)
    model = LogisticRegression()
    model.fit(X, y, sample_weight=sample_weights)
    return model
```

## Tecnologías principales

- **AIF360 (IBM)**: Toolkit completo para detección y mitigación de sesgo.
- **Fairlearn (Microsoft)**: Métricas de equidad y algoritmos de mitigación.
- **What-If Tool (Google)**: Visualización interactiva de comportamiento del modelo.
- **SHAP / LIME**: Explicabilidad para diagnosticar sesgo.
- **Aequitas**: Auditoría de sesgo automatizada.

## Hoja de ruta

1. Entender la taxonomía de sesgos en IA.
2. Medir sesgo con métricas de equidad (disparidad, demografía).
3. Detectar sesgo en datasets usando herramientas como AIF360.
4. Mitigar sesgo a nivel de datos (re-ponderación, re-muestreo).
5. Mitigar sesgo a nivel de algoritmo (restricciones de equidad).
6. Mitigar sesgo a nivel de post-procesamiento (calibración).
7. Establecer procesos de auditoría continua para modelos en producción.

## Relaciones con otros módulos

- `../Fairness/`: Las métricas de equidad como marco para medir sesgo.
- `../Ethics/`: Implicaciones éticas del sesgo algorítmico.
- `../../032-MachineLearning/FeatureEngineering/`: Sesgo introducido por selección de características.
- `../../034-LLM/Security/`: Sesgo en LLMs como vector de ataque.

## Recursos recomendados

- **Libro**: "Weapons of Math Destruction" (Cathy O'Neil).
- **Libro**: "Fairness and Machine Learning" (Barocas, Hardt, Narayanan).
- **Paper**: "Fairness Definitions Explained" (Verma & Rubin, 2018).
- **Documentación**: AIF360 Examples (IBM), Fairlearn User Guide (Microsoft).
- **Repositorio**: aif360 (GitHub), fairlearn (GitHub).
