# Aprendizaje Supervisado (Supervised)

## Descripción del dominio

El Aprendizaje Supervisado es la rama del Machine Learning donde los modelos se entrenan con datos etiquetados: cada ejemplo de entrenamiento tiene un par (X, y) donde X son las características y y es la etiqueta o valor objetivo. El objetivo es aprender una función f: X → y que generalice a datos no vistos. Las dos grandes categorías son regresión (y es continua) y clasificación (y es discreta). Es el tipo de aprendizaje más utilizado en la industria.

## Conceptos clave

- **Regresión Lineal**: Modela la relación entre características y variable objetivo como una combinación lineal. Minimiza el error cuadrático medio (MSE).
- **Regresión Logística**: Clasificación binaria que modela la probabilidad de pertenencia a una clase usando la función sigmoide.
- **Árboles de Decisión**: Partición recursiva del espacio de características basada en reglas aprendidas de los datos. CART, ID3, C4.5.
- **Random Forest**: Conjunto de árboles entrenados con bagging. Reduce varianza y mejora generalización.
- **Support Vector Machines**: Encuentra el hiperplano que maximiza el margen entre clases. Kernel trick para no linealidad.
- **k-Nearest Neighbors**: Clasifica basándose en la mayoría de votos de los k vecinos más cercanos en el espacio de características.
- **Naive Bayes**: Clasificador probabilístico basado en el teorema de Bayes con supuesto de independencia condicional.
- **Gradient Boosting**: Conjunto secuencial de modelos débiles donde cada uno corrige errores del anterior (XGBoost, LightGBM, CatBoost).

## Ejemplo: Pipeline de clasificación supervisada

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, ConfusionMatrixDisplay
import matplotlib.pyplot as plt

data = load_iris()
X, y = data.data, data.target

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train_scaled, y_train)

y_pred = model.predict(X_test_scaled)
print(classification_report(y_test, y_pred, target_names=data.target_names))
ConfusionMatrixDisplay.from_estimator(model, X_test_scaled, y_test)
plt.show()
```

## Ejemplo: Regresión con búsqueda de hiperparámetros

```python
from sklearn.datasets import fetch_california_housing
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.metrics import mean_squared_error, r2_score

X, y = fetch_california_housing(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

param_grid = {
    'n_estimators': [100, 200],
    'max_depth': [3, 5, 7],
    'learning_rate': [0.01, 0.1]
}

gbr = GradientBoostingRegressor(random_state=42)
grid = GridSearchCV(gbr, param_grid, cv=5, scoring='r2', n_jobs=-1)
grid.fit(X_train, y_train)

print(f"Mejores parámetros: {grid.best_params_}")
print(f"R² en test: {r2_score(y_test, grid.predict(X_test)):.4f}")
print(f"MSE en test: {mean_squared_error(y_test, grid.predict(X_test)):.4f}")
```

## Tecnologías principales

- **Scikit-learn**: Librería principal de ML supervisado en Python.
- **XGBoost / LightGBM / CatBoost**: Gradient boosting optimizado.
- **Statsmodels**: Modelos lineales con inferencia estadística completa.
- **Imbalanced-learn**: Técnicas para datos desbalanceados (SMOTE, ADASYN).

## Hoja de ruta

1. Regresión lineal simple y múltiple con scikit-learn.
2. Regresión logística y métricas de clasificación (accuracy, precisión, recall, F1, ROC-AUC).
3. Árboles de decisión y visualización de reglas.
4. Random Forest: feature importance, out-of-bag score.
5. SVM: kernels lineal, polinomial, RBF. Regularización (C, gamma).
6. Gradient Boosting: XGBoost, early stopping, tuning.
7. Pipeline completa con validación cruzada y búsqueda de hiperparámetros.

## Relaciones con otros módulos

- `../Unsupervised/`: Contraste con aprendizaje no supervisado.
- `../FeatureEngineering/`: Ingeniería de características para mejorar modelos supervisados.
- `../ReinforcementLearning/`: Contraste entre supervisado y por refuerzo.
- `../MLflow/`: Seguimiento de experimentos con modelos supervisados.
- `../../031-AI/Approaches/`: Enfoque conexionista vs. simbólico.

## Recursos recomendados

- **Libro**: "Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow" (Géron).
- **Curso**: "Machine Learning" (Andrew Ng) en Coursera.
- **Documentación**: Scikit-learn User Guide.
- **Cheat Sheet**: Scikit-learn Algorithm Cheat Sheet.
- **Repositorio**: awesome-sklearn (GitHub).
