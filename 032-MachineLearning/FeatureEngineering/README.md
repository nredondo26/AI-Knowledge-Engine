# Ingeniería de Características (Feature Engineering)

## Descripción del dominio

La Ingeniería de Características (Feature Engineering) es el proceso de transformar datos crudos en características que maximizan el rendimiento de los modelos de Machine Learning. Es considerada por muchos practitioners como el factor más determinante del éxito de un modelo, por encima incluso de la elección del algoritmo. Incluye técnicas de limpieza, transformación, codificación, creación, selección y escalado de características.

## Conceptos clave

- **Característica (Feature)**: Variable de entrada usada por el modelo para hacer predicciones.
- **Codificación de Categóricas**: Transformar variables categóricas en numéricas. One-hot encoding, label encoding, ordinal encoding, target encoding, binary encoding.
- **Escalado (Scaling)**: Normalizar rangos de características. StandardScaler (Z-score), MinMaxScaler, RobustScaler, MaxAbsScaler.
- **Manejo de Valores Faltantes**: Imputación con media, mediana, moda, k-NN, regresión, o indicadores de ausencia.
- **Técnicas de Transformación**: Log transform, Box-Cox, Yeo-Johnson para manejar asimetría. Binning, polynomial features, interacciones.
- **Selección de Características**: Identificar las características más relevantes. Filter methods (correlación, ANOVA), wrapper methods (RFE), embedded methods (Lasso, feature importance).
- **Extracción de Características**: Crear nuevas características desde datos existentes o externos. PCA, autoencoders, embeddings.
- **Características Temporales**: Extraer día, mes, día de semana, hora, estacionalidad, diferencias, rolling windows.
- **Características de Texto**: TF-IDF, counts, n-gramas, embeddings (Word2Vec, BERT).
- **Target Encoding**: Codificar categóricas con la media del target. Requiere cuidado para evitar data leakage.

## Ejemplo: Pipeline completa de transformación

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestRegressor

df = pd.DataFrame({
    'edad': [25, 30, np.nan, 45, 22],
    'salario': [30000, 50000, 40000, None, 28000],
    'ciudad': ['Madrid', 'Barcelona', 'Madrid', 'Valencia', 'Barcelona'],
    'target': [1, 0, 1, 0, 1]
})

X = df.drop('target', axis=1)
y = df['target']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

numeric_features = ['edad', 'salario']
numeric_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler', StandardScaler())
])

categorical_features = ['ciudad']
categorical_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='constant', fill_value='missing')),
    ('onehot', OneHotEncoder(handle_unknown='ignore'))
])

preprocessor = ColumnTransformer(transformers=[
    ('num', numeric_transformer, numeric_features),
    ('cat', categorical_transformer, categorical_features)
])

pipeline = Pipeline(steps=[
    ('preprocessor', preprocessor),
    ('regressor', RandomForestRegressor(random_state=42))
])

pipeline.fit(X_train, y_train)
print(f"Score: {pipeline.score(X_test, y_test):.3f}")
```

## Ejemplo: Creación de características desde fechas

```python
def crear_features_temporales(df, col_fecha):
    df = df.copy()
    df[col_fecha] = pd.to_datetime(df[col_fecha])
    df['year'] = df[col_fecha].dt.year
    df['month'] = df[col_fecha].dt.month
    df['day'] = df[col_fecha].dt.day
    df['dayofweek'] = df[col_fecha].dt.dayofweek
    df['is_weekend'] = df['dayofweek'].isin([5, 6]).astype(int)
    df['quarter'] = df[col_fecha].dt.quarter
    df['dayofyear'] = df[col_fecha].dt.dayofyear
    # Seno y coseno para codificación circular de mes, día de semana
    df['month_sin'] = np.sin(2 * np.pi * df['month'] / 12)
    df['month_cos'] = np.cos(2 * np.pi * df['month'] / 12)
    return df.drop(col_fecha, axis=1)
```

## Tecnologías principales

- **Pandas**: Manipulación y transformación de datos tabulares.
- **Scikit-learn**: ColumnTransformer, Pipeline, FeatureUnion, PolynomialFeatures, SelectKBest, RFE.
- **Feature-engine**: Biblioteca especializada en feature engineering.
- **Category Encoders**: Codificaciones categóricas avanzadas (target encoding, WOE, James-Stein).
- **NumPy**: Operaciones numéricas para creación de características.

## Hoja de ruta

1. Limpieza de datos: valores faltantes, outliers, duplicados.
2. Escalado y normalización: StandardScaler, MinMaxScaler, RobustScaler.
3. Codificación de variables categóricas: one-hot, label, target encoding.
4. Creación de características: polinomiales, interacciones, binning.
5. Características temporales y agregaciones (groupby).
6. Selección de características: filter, wrapper, embedded methods.
7. Pipeline automatizada con ColumnTransformer.

## Relaciones con otros módulos

- `../Supervised/`: Modelos supervisados que se benefician del feature engineering.
- `../Unsupervised/`: PCA y reducción de dimensionalidad como feature extraction.
- `../../033-DeepLearning/`: Autoencoders y embeddings aprendidos como características.
- `../../034-LLM/`: Embeddings de texto como características de alta dimensión.

## Recursos recomendados

- **Libro**: "Feature Engineering for Machine Learning" (Zheng & Casari).
- **Curso**: "Feature Engineering" en Kaggle Learn.
- **Documentación**: Scikit-learn User Guide — Feature Engineering section.
- **Documentación**: Feature-engine Documentation.
- **Repositorio**: awesome-feature-engineering (GitHub).
