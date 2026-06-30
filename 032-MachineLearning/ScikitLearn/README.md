# Scikit-Learn (032-MachineLearning/ScikitLearn)

## Descripción del dominio

Scikit-learn (sklearn) es la librería de referencia en Python para Machine Learning clásico. Construida sobre NumPy, SciPy y Matplotlib, ofrece una API uniforme y consistente para tareas de clasificación, regresión, clustering, reducción de dimensionalidad, selección de modelos y preprocesamiento. Su diseño sigue principios de usabilidad, eficiencia y documentación exhaustiva. Desde su lanzamiento en 2007 (como parte del proyecto Google Summer of Code), se ha convertido en el estándar de facto para ML en producción, educación e investigación aplicada.

## Arquitectura de la librería

### API unificada (Transformer + Estimator + Predictor)

Todo objeto en scikit-learn sigue el patrón:

- **Estimator**: `fit(X, y)` — entrena el modelo con datos.
- **Predictor**: `predict(X)` — genera predicciones (supervisado) o labels (no supervisado).
- **Transformer**: `transform(X)` — transforma datos (preprocesamiento, reducción de dimensionalidad).
- **Score**: `score(X, y)` — evalúa rendimiento con métrica por defecto.

### Módulos principales

| Módulo | Funcionalidad | Clases clave |
|--------|--------------|--------------|
| `sklearn.linear_model` | Modelos lineales | LinearRegression, LogisticRegression, Ridge, Lasso, ElasticNet, SGDRegressor |
| `sklearn.tree` | Árboles de decisión | DecisionTreeClassifier, DecisionTreeRegressor, export_graphviz |
| `sklearn.ensemble` | Métodos de ensemble | RandomForestClassifier, GradientBoostingClassifier, AdaBoost, VotingClassifier, StackingClassifier |
| `sklearn.svm` | Support Vector Machines | SVC, SVR, LinearSVC, NuSVC |
| `sklearn.neighbors` | Vecinos cercanos | KNeighborsClassifier, KNeighborsRegressor, NearestNeighbors |
| `sklearn.cluster` | Clustering | KMeans, DBSCAN, AgglomerativeClustering, OPTICS, SpectralClustering |
| `sklearn.decomposition` | Reducción de dimensionalidad | PCA, NMF, FastICA, TruncatedSVD |
| `sklearn.preprocessing` | Preprocesamiento | StandardScaler, MinMaxScaler, OneHotEncoder, LabelEncoder, PolynomialFeatures |
| `sklearn.feature_selection` | Selección de características | SelectKBest, RFE, SelectFromModel, VarianceThreshold |
| `sklearn.model_selection` | Validación y búsqueda | train_test_split, cross_val_score, GridSearchCV, RandomizedSearchCV |
| `sklearn.metrics` | Métricas de evaluación | accuracy_score, precision_recall_fscore_support, roc_auc_score, confusion_matrix, mean_squared_error, r2_score |
| `sklearn.pipeline` | Pipelines | Pipeline, FeatureUnion, make_pipeline |
| `sklearn.impute` | Imputación de valores | SimpleImputer, KNNImputer, IterativeImputer |
| `sklearn.compose` | Composición de transformadores | ColumnTransformer, TransformedTargetRegressor |

### Pipeline: composición de transformaciones

El Pipeline es probablemente la característica más importante de scikit-learn para producción: permite encadenar transformaciones y un estimador final en un solo objeto, asegurando que `fit` y `transform` se apliquen correctamente en entrenamiento y test.

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split, cross_val_score
import pandas as pd
import numpy as np

# Datos de ejemplo
np.random.seed(42)
n = 1000
df = pd.DataFrame({
    'edad': np.random.randint(18, 80, n),
    'ingreso': np.random.normal(50000, 20000, n),
    'educacion': np.random.choice(['basica', 'media', 'universitaria'], n),
    'ciudad': np.random.choice(['A', 'B', 'C'], n),
    'target': np.random.binomial(1, 0.3, n)
})
df.loc[::10, 'edad'] = np.nan  # 10% missing

# Preprocesamiento diferenciado por tipo de columna
numeric_features = ['edad', 'ingreso']
categorical_features = ['educacion', 'ciudad']

numeric_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler', StandardScaler())
])

categorical_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('onehot', OneHotEncoder(drop='first', sparse_output=False))
])

preprocessor = ColumnTransformer(
    transformers=[
        ('num', numeric_transformer, numeric_features),
        ('cat', categorical_transformer, categorical_features)
    ]
)

# Pipeline completo
pipeline = Pipeline(steps=[
    ('preprocessor', preprocessor),
    ('classifier', RandomForestClassifier(n_estimators=100, random_state=42))
])

X = df.drop('target', axis=1)
y = df['target']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
pipeline.fit(X_train, y_train)

# Evaluación con cross-validation (el pipeline asegura preprocesamiento correcto en cada fold)
cv_scores = cross_val_score(pipeline, X_train, y_train, cv=5, scoring='roc_auc')
print(f"CV AUC: {cv_scores.mean():.4f} ± {cv_scores.std():.4f}")

# Predicción y evaluación
y_pred = pipeline.predict(X_test)
y_proba = pipeline.predict_proba(X_test)[:, 1]

from sklearn.metrics import classification_report, roc_auc_score
print(classification_report(y_test, y_pred))
print(f"Test AUC: {roc_auc_score(y_test, y_proba):.4f}")
```

## Algoritmos fundamentales con código

### 1. Regresión Lineal y Regularización

```python
from sklearn.linear_model import LinearRegression, Ridge, Lasso, ElasticNet
from sklearn.datasets import make_regression
from sklearn.metrics import mean_squared_error, r2_score

X, y = make_regression(n_samples=200, n_features=20, noise=0.1, random_state=42)

models = {
    'LinearRegression': LinearRegression(),
    'Ridge (L2)': Ridge(alpha=1.0),
    'Lasso (L1)': Lasso(alpha=0.1),
    'ElasticNet (L1+L2)': ElasticNet(alpha=0.1, l1_ratio=0.5)
}

for name, model in models.items():
    scores = cross_val_score(model, X, y, cv=5, scoring='r2')
    model.fit(X, y)
    y_pred = model.predict(X)
    n_features_used = np.sum(model.coef_ != 0) if hasattr(model, 'coef_') else 'N/A'
    print(f"{name:25s}: R² CV={scores.mean():.4f} ± {scores.std():.4f}, "
          f"Features nonzero={n_features_used}")
```

### 2. Clasificación: Random Forest + Gradient Boosting

```python
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.datasets import make_classification

X, y = make_classification(n_samples=1000, n_features=30, n_informative=15,
                            n_redundant=5, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Random Forest — bagging de árboles profundos
rf = RandomForestClassifier(
    n_estimators=300, max_depth=15, min_samples_split=5,
    max_features='sqrt', random_state=42, n_jobs=-1
)
rf.fit(X_train, y_train)
print(f"RF Train: {rf.score(X_train, y_train):.4f}")
print(f"RF Test:  {rf.score(X_test, y_test):.4f}")

# Feature importance con Gini
importances = pd.DataFrame({
    'feature': [f'f{i}' for i in range(30)],
    'importance': rf.feature_importances_
}).sort_values('importance', ascending=False)
print("\nTop 5 features (RF):")
print(importances.head(5))

# Gradient Boosting — boosting secuencial
gb = GradientBoostingClassifier(
    n_estimators=200, learning_rate=0.05, max_depth=4,
    subsample=0.8, random_state=42
)
gb.fit(X_train, y_train)
print(f"\nGB Train: {gb.score(X_train, y_train):.4f}")
print(f"GB Test:  {gb.score(X_test, y_test):.4f}")
```

### 3. SVM con Kernel Trick

```python
from sklearn.svm import SVC
from sklearn.datasets import make_circles
import matplotlib.pyplot as plt

# Dataset no lineal (círculos concéntricos)
X, y = make_circles(n_samples=500, noise=0.1, factor=0.5, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# SVM lineal falla con datos no lineales
svm_linear = SVC(kernel='linear', C=1.0)
svm_linear.fit(X_train, y_train)
print(f"SVM Linear: {svm_linear.score(X_test, y_test):.4f}")

# SVM con kernel RBF (mapea a espacio de dimensionalidad infinita)
svm_rbf = SVC(kernel='rbf', C=1.0, gamma='scale')
svm_rbf.fit(X_train, y_train)
print(f"SVM RBF:    {svm_rbf.score(X_test, y_test):.4f}")

# Tuning: relación C (regularización) y gamma (influencia de cada punto)
from sklearn.model_selection import GridSearchCV

param_grid = {
    'C': [0.1, 1, 10, 100],
    'gamma': [0.001, 0.01, 0.1, 1, 'scale', 'auto'],
    'kernel': ['rbf']
}
grid = GridSearchCV(SVC(), param_grid, cv=5, scoring='accuracy', n_jobs=-1, verbose=0)
grid.fit(X_train, y_train)
print(f"\nBest params: {grid.best_params_}")
print(f"Best CV: {grid.best_score_:.4f}")
print(f"Test: {grid.score(X_test, y_test):.4f}")
```

### 4. Clustering: K-Means y DBSCAN

```python
from sklearn.cluster import KMeans, DBSCAN
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import silhouette_score

# Dataset sintético con clusters
from sklearn.datasets import make_blobs
X, y_true = make_blobs(n_samples=500, centers=5, cluster_std=1.0, random_state=42)
X = StandardScaler().fit_transform(X)

# Método del codo + silhouette para elegir k
inertias = []
silhouettes = []
K_range = range(2, 11)

for k in K_range:
    km = KMeans(n_clusters=k, random_state=42, n_init=10)
    labels = km.fit_predict(X)
    inertias.append(km.inertia_)
    silhouettes.append(silhouette_score(X, labels))

# K óptimo es el que maximiza silhouette
best_k = K_range[np.argmax(silhouettes)]
print(f"K óptimo (silhouette): {best_k}")
print(f"Silhouette scores: {dict(zip(K_range, [f'{s:.3f}' for s in silhouettes]))}")

# DBSCAN: clustering basado en densidad (no requiere k)
dbscan = DBSCAN(eps=0.3, min_samples=5)
labels_db = dbscan.fit_predict(X)
n_clusters = len(set(labels_db)) - (1 if -1 in labels_db else 0)
n_noise = list(labels_db).count(-1)
print(f"DBSCAN: {n_clusters} clusters, {n_noise} puntos de ruido")
```

### 5. Reducción de dimensionalidad: PCA + t-SNE

```python
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE

# PCA: transformación lineal que maximiza varianza en componentes ortogonales
pca = PCA(n_components=0.95)  # mantener 95% de varianza
X_pca = pca.fit_transform(X)
print(f"PCA: {X.shape[1]} dimensiones → {X_pca.shape[1]} componentes")
print(f"Varianza explicada por componente: {pca.explained_variance_ratio_[:3]}")

# t-SNE: visualización no lineal (preserva vecindarios locales)
tsne = TSNE(n_components=2, perplexity=30, random_state=42)
X_tsne = tsne.fit_transform(X)

# Interpretación: t-SNE es excelente para visualización (preserva estructura local)
# pero NO debe usarse para inferencia estadística o feature engineering
```

### 6. Búsqueda de hiperparámetros avanzada

```python
from sklearn.model_selection import RandomizedSearchCV
from scipy.stats import randint, uniform

# Random Search es más eficiente que Grid Search para espacios grandes
param_dist = {
    'n_estimators': randint(50, 500),
    'max_depth': [3, 5, 7, 10, 15, None],
    'min_samples_split': randint(2, 20),
    'min_samples_leaf': randint(1, 10),
    'max_features': ['sqrt', 'log2', None],
    'bootstrap': [True, False]
}

rf = RandomForestClassifier(random_state=42)
random_search = RandomizedSearchCV(
    rf, param_dist, n_iter=50, cv=5,
    scoring='roc_auc', n_jobs=-1, random_state=42
)
random_search.fit(X_train, y_train)
print(f"Best params: {random_search.best_params_}")
print(f"Best AUC: {random_search.best_score_:.4f}")
```

## Buenas prácticas en producción

1. **Siempre usar Pipelines**: Evita data leakage entre train y test.
2. **ColumnTransformer para datos mixtos**: Numéricos (scaler/imputer) y categóricos (onehot/ordinal).
3. **Persistencia con joblib**: `joblib.dump(pipeline, 'model.joblib')` y `joblib.load('model.joblib')`.
4. **Feature engineering dentro del pipeline**: PolynomialFeatures, SelectKBest, PCA como pasos intermedios.
5. **Validación con cross-validation**: Siempre usar `cross_val_score` o `cross_validate` para estimación robusta.
6. **Calibración de probabilidades**: `CalibratedClassifierCV` para obtener probabilidades bien calibradas.
7. **Manejo de clases desbalanceadas**: `class_weight='balanced'`, SMOTE (imbalanced-learn), o umbrales ajustables.

## Relaciones con otros módulos

- `../XGBoost/`: Gradient boosting optimizado (XGBoost se integra con sklearn API).
- `../FeatureEngineering/`: Técnicas de transformación que se integran en Pipelines sklearn.
- `../ModelSelection/`: GridSearchCV, RandomizedSearchCV, cross-validation.
- `../../033-DeepLearning/`: sklearn para baseline, feature extraction, y evaluación comparativa.
- `../../031-AI/Ethics/`: Fairness metrics, debiasing con sklearn.

## Recursos recomendados

- **Documentación oficial**: https://scikit-learn.org/stable/user_guide.html — La mejor documentación de ML.
- **Libro**: "Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow" (Géron).
- **Curso**: "Introduction to Machine Learning with scikit-learn" (DataCamp).
- **Cheat Sheet**: https://scikit-learn.org/stable/tutorial/machine_learning_map/ — Mapa de algoritmos.
- **Repositorio**: https://github.com/scikit-learn/scikit-learn — Código fuente y ejemplos.
