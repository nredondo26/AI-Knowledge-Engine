# Model Selection — Selección de Modelos en Machine Learning

## Descripción del dominio

La selección de modelos es el proceso de elegir el mejor algoritmo de ML y sus hiperparámetros óptimos para un problema y conjunto de datos dados. No existe un modelo universalmente mejor (No Free Lunch Theorem): la elección depende del tipo de datos (tabular, texto, imagen, series temporales), tamaño del dataset, recursos computacionales, interpretabilidad requerida y métrica de evaluación (exactitud, F1, AUC, MSE, latencia). Este módulo cubre técnicas de validación cruzada, búsqueda de hiperparámetros, selección de características, comparación de modelos y consideraciones prácticas para elegir entre algoritmos.

## Áreas clave

- **Validación cruzada (Cross-Validation)**: k-fold (k=5 o 10 típico), stratified k-fold (preserva proporción de clases), Leave-One-Out (LOO, costoso), Group k-fold (datos agrupados), Time Series split (ventana temporal)
- **Búsqueda de hiperparámetros**: Grid Search (exhaustivo, costoso), Random Search (más eficiente, cubre mejor el espacio), Bayesian Optimization (Gaussian Processes, Tree Parzen Estimators), Hyperband/BOHB (bandit-based), Optuna, Hyperopt
- **Métricas de evaluación**: Regresión: MSE, RMSE, MAE, R², MAPE. Clasificación: Accuracy, Precision, Recall, F1-score, ROC-AUC, PR-AUC, Log Loss, Cohen's Kappa, Matthews Correlation Coefficient
- **Bias-Variance Tradeoff**: Modelos simples (alta bias, baja varianza — underfitting) vs complejos (baja bias, alta varianza — overfitting). Regularización, validación cruzada, ensemble methods
- **Selección de características**: Filter methods (correlación, chi-cuadrado, mutual information), Wrapper methods (RFE = Recursive Feature Elimination), Embedded methods (L1 regularization, importance de árboles, SHAP)
- **Comparación de modelos**: Statistical tests (paired t-test, Wilcoxon signed-rank, McNemar para clasificación), Effect size, Learning curves, ROC curves comparison (DeLong test), Nemenyi test (múltiples modelos)
- **Curvas de aprendizaje (Learning Curves)**: Diagnóstico de underfitting/overfitting. Plotear score en train y validation vs tamaño del dataset. Si gap aumenta con más datos → overfitting
- **Curvas de validación**: Score vs valor de un hiperparámetro (ej. max_depth, C, gamma). Identificar rango óptimo y punto de overfitting
- **Meta-aprendizaje y AutoML**: Auto-sklearn, TPOT, H2O AutoML, FLAML, AutoGluon. Búsqueda automática de pipelines completos (preprocesamiento + modelo + hiperparámetros)

## Algoritmos por tipo de problema

| Tipo de problema | Algoritmos recomendados |
|-----------------|------------------------|
| Tabular, < 10K muestras | Random Forest, Gradient Boosting (XGBoost, LightGBM), SVM (RBF kernel) |
| Tabular, > 10K muestras | XGBoost, LightGBM, CatBoost, Neural Networks (MLP) |
| Texto (clasificación) | TF-IDF + Linear SVM / Naive Bayes, Transformers (BERT, RoBERTa, DistilBERT) |
| Imágenes | CNN (ResNet, EfficientNet, ConvNeXt), Vision Transformers (ViT, DeiT) |
| Series temporales | ARIMA/SARIMA (estadístico), Prophet (Facebook), LightGBM (features de tiempo), LSTM/Transformers (deep) |
| Datos secuenciales | LSTM, GRU, Transformers, TCN (Temporal Convolutional Network) |
| Clustering | K-means (grande), HDBSCAN (densidad variable), Gaussian Mixture, Spectral Clustering |
| Detección de anomalías | Isolation Forest, LOF, Autoencoder, One-Class SVM |

## Ejemplo: Grid Search con scikit-learn

```python
from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier

param_grid = {
    'n_estimators': [100, 200, 500],
    'max_depth': [None, 10, 20, 30],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4],
}

grid = GridSearchCV(
    RandomForestClassifier(random_state=42),
    param_grid,
    cv=5,               # 5-fold cross-validation
    scoring='f1_macro',  # Métrica de evaluación
    n_jobs=-1,          # Paralelizar
    verbose=1
)
grid.fit(X_train, y_train)
print(f"Mejores parámetros: {grid.best_params_}")
print(f"Mejor score CV: {grid.best_score_:.4f}")
print(f"Score en test: {grid.score(X_test, y_test):.4f}")
```

## Ejemplo: Random Search con Optuna

```python
import optuna
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.model_selection import cross_val_score

def objective(trial):
    params = {
        'n_estimators': trial.suggest_int('n_estimators', 50, 500),
        'max_depth': trial.suggest_int('max_depth', 3, 15),
        'learning_rate': trial.suggest_float('lr', 0.01, 0.3, log=True),
        'subsample': trial.suggest_float('subsample', 0.6, 1.0),
        'min_samples_split': trial.suggest_int('min_samples_split', 2, 20),
    }
    model = GradientBoostingClassifier(**params, random_state=42)
    scores = cross_val_score(model, X_train, y_train, cv=5, scoring='f1')
    return scores.mean()

study = optuna.create_study(direction='maximize')
study.optimize(objective, n_trials=100)
```

## Tecnologías principales

| Herramienta | Tipo | Características |
|-------------|------|-----------------|
| scikit-learn | Grid/Random/Cross-val | GridSearchCV, RandomizedSearchCV, cross_val_score |
| Optuna | Bayesian/Hyperband | Suggest API, pruning, visualización, distribuciones |
| Hyperopt | Bayesian (TPE) | fmin, trials, SparkTrials (distribuido) |
| Ray Tune | Escalable | AsyncHyperBand, Population Based Training, integración MLflow |
| Auto-sklearn | AutoML | Meta-learning, ensemble, búsqueda de pipelines |
| TPOT | AutoML | Genetic programming para pipelines completos |
| H2O AutoML | AutoML | Stacked ensembles, líderes por tiempo/métricas |
| MLflow | Tracking | Experiment tracking, registro de modelos, serving |
| Weights & Biases | Tracking | Sweeps (búsqueda automática), artefactos, reports |

## Buenas prácticas

- Dividir datos en train/validation/test antes de cualquier búsqueda para evitar data leakage
- Usar stratified k-fold para clasificación con clases desbalanceadas
- Preferir Random Search sobre Grid Search (mejor cobertura del espacio con mismo presupuesto)
- Escalar características para modelos basados en distancia (SVM, KNN, PCA, redes neuronales)
- Comparar modelos con validación cruzada y test estadístico (paired t-test o Wilcoxon)
- Visualizar learning curves para diagnosticar bias/varianza
- Usar métrica alineada con el problema de negocio (no solo accuracy en datos desbalanceados)
- Documentar cada experimento con MLflow o W&B: parámetros, métricas, artefactos
- Para AutoML, empezar con H2O o Auto-sklearn como baseline y luego refinar manualmente
