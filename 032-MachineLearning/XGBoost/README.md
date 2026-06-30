# XGBoost (032-MachineLearning/XGBoost)

## Descripción del dominio

XGBoost (eXtreme Gradient Boosting) es una implementación optimizada y escalable de gradient boosted decision trees (GBDT). Desarrollado por Tianqi Chen en 2014, se ha convertido en el algoritmo dominante en competencias de Kaggle y aplicaciones tabulares en producción debido a su rendimiento, velocidad y manejo nativo de missing values, regularización y paralelización. XGBoost implementa el algoritmo de gradient boosting con una serie de innovaciones técnicas que mejoran significativamente sobre implementaciones ingenuas.

## Fundamentos teóricos

### Gradient Boosting

El gradient boosting construye un ensemble de árboles de decisión secuencialmente, donde cada nuevo árbol se ajusta a los residuos (errores) del conjunto actual:

1. Inicializar: `F_0(x) = argmin_γ Σ L(y_i, γ)`
2. Para m = 1 hasta M:
   - Calcular residuos: `r_im = -[∂L(y_i, F(x_i))/∂F(x_i)]_F=F_{m-1}`
   - Ajustar árbol de regresión a los residuos: `h_m(x)`
   - Actualizar: `F_m(x) = F_{m-1}(x) + η · h_m(x)` donde η es el learning rate

### Innovaciones de XGBoost

1. **Regularización**: Penalización L1 (Lasso) y L2 (Ridge) en los pesos de las hojas.
2. **Sparsity-aware algorithm**: Manejo nativo de valores faltantes con dirección de split aprendida.
3. **Weighted Quantile Sketch**: Algoritmo aproximado para encontrar splits óptimos en datos distribuidos.
4. **Cache-aware access**: Optimización de memoria para acceso a datos y gradientes.
5. **Out-of-core computing**: Procesamiento de datos que no caben en RAM.
6. **Block structure**: Datos ordenados por feature para paralelización de splits.
7. **Column Block**: Compresión de columnas para acelerar la búsqueda de splits.

## Parámetros críticos

### Parámetros generales

| Parámetro | Descripción | Rango típico |
|-----------|-------------|-------------|
| `n_estimators` | Número de árboles (boosting rounds) | 100–10000 (con early_stopping) |
| `learning_rate` (eta) | Factor de contracción (step size) | 0.001–0.3 |
| `max_depth` | Profundidad máxima del árbol | 3–10 |
| `min_child_weight` | Suma mínima de pesos en hoja | 1–10 (mayor → menos overfitting) |
| `subsample` | Fracción de muestras por árbol | 0.5–1.0 |
| `colsample_bytree` | Fracción de features por árbol | 0.3–1.0 |
| `gamma` | Reducción mínima de pérdida para hacer split | 0–5 |
| `lambda` (reg_lambda) | Regularización L2 en pesos de hojas | 0–10 |
| `alpha` (reg_alpha) | Regularización L1 en pesos de hojas | 0–10 |
| `scale_pos_weight` | Balance de clases para desbalanceo | sum(neg)/sum(pos) |

### Parámetros de entrenamiento

- `eval_metric`: Métrica de validación (rmse, logloss, auc, mae, etc.)
- `early_stopping_rounds`: Detener entrenamiento si no mejora en N rondas
- `max_delta_step`: Limita el peso máximo en cada paso (útil para clases desbalanceadas)

## Código: implementación completa

### 1. Clasificación binaria con early stopping

```python
import xgboost as xgb
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import classification_report, roc_auc_score, roc_curve
from sklearn.datasets import make_classification

# Dataset sintético
X, y = make_classification(
    n_samples=5000, n_features=20, n_informative=10,
    n_redundant=5, weights=[0.7, 0.3], random_state=42
)
feature_names = [f'feature_{i}' for i in range(X.shape[1])]

X_train, X_val, X_test, y_train, y_val, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Converter a DMatrix (estructura optimizada de XGBoost)
dtrain = xgb.DMatrix(X_train, label=y_train, feature_names=feature_names)
dval = xgb.DMatrix(X_val, label=y_val, feature_names=feature_names)
dtest = xgb.DMatrix(X_test, label=y_test, feature_names=feature_names)

# Parámetros optimizados
params = {
    'objective': 'binary:logistic',
    'eval_metric': 'auc',
    'max_depth': 6,
    'learning_rate': 0.05,
    'subsample': 0.8,
    'colsample_bytree': 0.8,
    'min_child_weight': 3,
    'gamma': 0.1,
    'reg_lambda': 2.0,
    'reg_alpha': 0.5,
    'scale_pos_weight': (y_train == 0).sum() / (y_train == 1).sum(),
    'seed': 42,
    'verbosity': 0
}

# Entrenamiento con early stopping
model = xgb.train(
    params=params,
    dtrain=dtrain,
    num_boost_round=2000,
    evals=[(dtrain, 'train'), (dval, 'val')],
    early_stopping_rounds=50,
    verbose_eval=100
)

print(f"\nMejor iteración: {model.best_iteration}")
print(f"Mejor AUC val: {model.best_score:.4f}")

# Predicción
y_pred_proba = model.predict(dtest)
y_pred = (y_pred_proba >= 0.5).astype(int)

print("\nMétricas de test:")
print(classification_report(y_test, y_pred))
print(f"AUC-ROC: {roc_auc_score(y_test, y_pred_proba):.4f}")
```

### 2. Regresión con XGBoost

```python
from sklearn.datasets import fetch_california_housing
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import xgboost as xgb

# Dataset de precios de vivienda en California
housing = fetch_california_housing()
X, y = housing.data, housing.target

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# API sklearn-compatible de XGBoost
model_reg = xgb.XGBRegressor(
    n_estimators=500, learning_rate=0.05, max_depth=6,
    subsample=0.8, colsample_bytree=0.8,
    reg_lambda=1.0, reg_alpha=0.1,
    random_state=42, n_jobs=-1
)

# Cross-validation
cv_scores = cross_val_score(model_reg, X_train, y_train, cv=5, scoring='r2')
print(f"R² CV: {cv_scores.mean():.4f} ± {cv_scores.std():.4f}")

model_reg.fit(
    X_train, y_train,
    eval_set=[(X_train, y_train), (X_test, y_test)],
    verbose=False
)

y_pred = model_reg.predict(X_test)
print(f"\nTest RMSE: {mean_squared_error(y_test, y_pred)**0.5:.4f}")
print(f"Test MAE:  {mean_absolute_error(y_test, y_pred):.4f}")
print(f"Test R²:   {r2_score(y_test, y_pred):.4f}")
```

### 3. Optimización de hiperparámetros con Optuna

```python
import optuna
from sklearn.model_selection import cross_val_score
import xgboost as xgb

def objective(trial):
    params = {
        'n_estimators': trial.suggest_int('n_estimators', 100, 1000, step=50),
        'max_depth': trial.suggest_int('max_depth', 3, 12),
        'learning_rate': trial.suggest_float('learning_rate', 0.01, 0.3, log=True),
        'subsample': trial.suggest_float('subsample', 0.5, 1.0),
        'colsample_bytree': trial.suggest_float('colsample_bytree', 0.3, 1.0),
        'min_child_weight': trial.suggest_int('min_child_weight', 1, 10),
        'gamma': trial.suggest_float('gamma', 0, 5),
        'reg_lambda': trial.suggest_float('reg_lambda', 0, 10),
        'reg_alpha': trial.suggest_float('reg_alpha', 0, 10),
        'random_state': 42
    }

    model = xgb.XGBClassifier(**params, use_label_encoder=False, eval_metric='logloss')
    score = cross_val_score(model, X_train, y_train, cv=3, scoring='roc_auc').mean()
    return score

study = optuna.create_study(direction='maximize', study_name='xgb_opt')
study.optimize(objective, n_trials=30, show_progress_bar=True)

print(f"Mejores parámetros: {study.best_params}")
print(f"Mejor AUC CV: {study.best_value:.4f}")

# Entrenar modelo óptimo
best_model = xgb.XGBClassifier(**study.best_params, random_state=42)
best_model.fit(X_train, y_train)
print(f"Test AUC: {roc_auc_score(y_test, best_model.predict_proba(X_test)[:, 1]):.4f}")
```

### 4. Visualización e interpretación

```python
import matplotlib.pyplot as plt
import xgboost as xgb
from sklearn.datasets import load_breast_cancer

data = load_breast_cancer()
X, y = data.data, data.target
feature_names = data.feature_names

model = xgb.XGBClassifier(n_estimators=100, max_depth=4, random_state=42)
model.fit(X, y)

# Feature importance (weight = número de veces que se usa un feature para split)
xgb.plot_importance(model, importance_type='weight', max_num_features=10)
plt.title('Feature Importance (Weight)')
plt.tight_layout()
# plt.show()

# Feature importance por ganancia (gain = mejora promedio en pérdida)
xgb.plot_importance(model, importance_type='gain', max_num_features=10)
plt.title('Feature Importance (Gain)')
plt.tight_layout()
# plt.show()

# SHAP values para explicabilidad
import shap
explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X)

# Gráfico de resumen
shap.summary_plot(shap_values, X, feature_names=feature_names, plot_type='bar')

# Dependence plot para feature individual
shap.dependence_plot('worst radius', shap_values, X, feature_names=feature_names)
```

### 5. XGBoost nativo con custome objective

```python
# Custom objective: Huber loss (robusta a outliers)
import xgboost as xgb
import numpy as np

def huber_approx_obj(preds, dtrain):
    """Aproximación diferenciable de Huber loss"""
    d = preds - dtrain.get_label()
    h = 1.0  # threshold
    scale = 1.0 + (d / h) ** 2
    scale_sqrt = np.sqrt(scale)
    grad = d / scale_sqrt
    hess = 1.0 / (scale * scale_sqrt)
    return grad, hess

# Evaluación custom
def custom_mae(preds, dtrain):
    labels = dtrain.get_label()
    return 'mae', np.mean(np.abs(preds - labels))

# Entrenamiento con custom objective
dtrain = xgb.DMatrix(X_train, label=y_train)
dtest = xgb.DMatrix(X_test, label=y_test)

params = {
    'objective': huber_approx_obj,
    'max_depth': 5,
    'learning_rate': 0.05,
    'verbosity': 0
}

model_custom = xgb.train(
    params, dtrain, num_boost_round=200,
    evals=[(dtrain, 'train'), (dtest, 'test')],
    feval=custom_mae,
    verbose_eval=50
)
```

### 6. XGBoost para series temporales

```python
# Uso de features temporales con XGBoost para forecasting
def create_lag_features(series, lags=[1, 2, 3, 7, 14, 30], window_stats=[7, 14, 30]):
    df = pd.DataFrame({'y': series})
    for lag in lags:
        df[f'lag_{lag}'] = df['y'].shift(lag)
    for w in window_stats:
        df[f'rolling_mean_{w}'] = df['y'].rolling(w).mean()
        df[f'rolling_std_{w}'] = df['y'].rolling(w).std()
    df = df.dropna()
    return df

# Simulación de serie temporal
np.random.seed(42)
t = np.arange(1000)
series = 10 + 0.01 * t + 5 * np.sin(2 * np.pi * t / 365) + np.random.normal(0, 1, 1000)

df = create_lag_features(series)
target = 'y'
features = [c for c in df.columns if c != target]

# Entrenamiento para forecasting
split = int(len(df) * 0.8)
train_df, test_df = df.iloc[:split], df.iloc[split:]

model_ts = xgb.XGBRegressor(n_estimators=200, max_depth=5, learning_rate=0.1, random_state=42)
model_ts.fit(train_df[features], train_df[target])
y_pred_ts = model_ts.predict(test_df[features])

rmse_ts = mean_squared_error(test_df[target], y_pred_ts) ** 0.5
print(f"Forecast RMSE: {rmse_ts:.4f}")
```

## Ventajas frente a otros boosting

| Característica | XGBoost | LightGBM | CatBoost |
|---------------|---------|----------|----------|
| Crecimiento de árbol | Level-wise (por nivel) | Leaf-wise (por hoja) | Symmetric |
| Manejo de categoricals | One-hot / Label encoding | Gradient-based one-side sampling | Target encoding nativo |
| Velocidad en datos grandes | Buena | Excelente (GOSS) | Buena |
| GPU acceleration | Sí (desde 2016) | Sí | Sí |
| Tratamiento de missing | Aprende dirección de split | Asigna a lado con menor pérdida | Tratamiento especial |
| Overfitting | Excelente (regularización) | Bueno (necesita tuning) | Excelente |
| Popularidad en Kaggle | Muy alta | Alta | Creciente |

## XGBoost con GPU

```python
params_gpu = params.copy()
params_gpu.update({
    'tree_method': 'gpu_hist',     # Algoritmo GPU
    'predictor': 'gpu_predictor',  # Predicción en GPU
    'gpu_id': 0
})

# Entrenamiento acelerado por GPU (10-50x más rápido)
model_gpu = xgb.train(params_gpu, dtrain, num_boost_round=500)
```

## Relaciones con otros módulos

- `../ScikitLearn/`: API sklearn-compatible de XGBoost, uso en Pipelines.
- `../ModelSelection/`: Optimización de hiperparámetros con Optuna / GridSearch.
- `../FeatureEngineering/`: Feature engineering para modelos tree-based.
- `../../033-DeepLearning/`: XGBoost como baseline para datos tabulares frente a redes profundas.
- `../../031-AI/Safety/`: Robustez de modelos boosting ante datos adversariales.

## Recursos recomendados

- **Documentación**: https://xgboost.readthedocs.io/ — Guía completa y tutoriales.
- **Paper**: "XGBoost: A Scalable Tree Boosting System" (Chen & Guestrin, 2016) — KDD 2016.
- **Libro**: "The Elements of Statistical Learning" (Hastie et al.) — Fundamento teórico del boosting.
- **Tutorial**: "XGBoost Official Tutorial" — https://xgboost.readthedocs.io/en/stable/tutorials/.
- **Repositorio**: https://github.com/dmlc/xgboost — Código fuente en C++ con Python API.
- **Kaggle**: "XGBoost for Tabular Data" — Notebooks de referencia.
