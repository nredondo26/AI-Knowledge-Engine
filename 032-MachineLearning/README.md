# Machine Learning (032-MachineLearning)

## Descripción del dominio

Machine Learning (ML) es el subcampo de la inteligencia artificial que se centra en algoritmos que permiten a las computadoras aprender patrones a partir de datos sin ser explícitamente programadas. El ML clásico abarca técnicas fundamentales como regresión lineal y logística, árboles de decisión, Random Forest, Support Vector Machines (SVM), k-Nearest Neighbors, y clustering con k-means. Scikit-learn es la librería de referencia en Python para ML clásico. El feature engineering (selección, extracción, transformación de características) es critical para el rendimiento de los modelos. Las pipelines de ML incluyen preprocesamiento, entrenamiento, validación, tuning de hiperparámetros y despliegue.

## Conceptos clave

- **Aprendizaje Supervisado**: Modelos entrenados con datos etiquetados (X → y). Incluye regresión (predecir valor continuo) y clasificación (predecir categoría).
- **Aprendizaje No Supervisado**: Modelos que encuentran patrones en datos no etiquetados. Clustering (k-means, DBSCAN, HDBSCAN), reducción de dimensionalidad (PCA, t-SNE, UMAP), detección de anomalías.
- **Regresión Lineal**: Modelo que predice una variable continua como combinación lineal de características. Mínimos cuadrados ordinarios.
- **Regresión Logística**: Modelo de clasificación binaria que usa la función sigmoide para estimar probabilidades.
- **Árboles de Decisión**: Modelos basados en reglas jerárquicas. CART, ID3, C4.5. Propensos a overfitting; se usan Random Forest y Gradient Boosting para mitigarlo.
- **Random Forest**: Ensemble de árboles de decisión entrenados con bagging. Reduce varianza y mejora generalización.
- **SVM** (Support Vector Machine): Encuentra el hiperplano óptimo que separa clases maximizando el margen. Kernel trick para datos no lineales.
- **Gradient Boosting**: Ensemble secuencial donde cada árbol corrige errores del anterior. XGBoost, LightGBM, CatBoost.
- **Feature Engineering**: Creación, transformación, selección y escalado de características. Técnicas: one-hot encoding, label encoding, binning, polynomial features, interacciones.
- **Métricas**: Accuracy, precision, recall, F1-score, ROC-AUC, MSE, MAE, R², silhouette score.
- **Validación**: Train/validation/test split, k-fold cross-validation, stratified k-fold.
- **Hiperparámetros**: Parámetros de configuración del modelo (learning rate, max_depth, n_estimators). Grid Search, Random Search, Bayesian Optimization.
- **Underfitting vs Overfitting**: Modelo demasiado simple (alta bias) vs modelo demasiado complejo (alta varianza). Regularización L1 (Lasso), L2 (Ridge).

## Tecnologías principales

- **Scikit-learn**: Librería principal de ML clásico en Python. Compatible con NumPy, SciPy, Pandas.
- **XGBoost / LightGBM / CatBoost**: Implementaciones optimizadas de gradient boosting.
- **Pandas**: Manipulación y análisis de datos tabulares.
- **NumPy**: Cómputo numérico eficiente, arreglos multidimensionales.
- **Matplotlib / Seaborn / Plotly**: Visualización de datos.
- **Statsmodels**: Inferencia estadística, modelos lineales, pruebas de hipótesis.
- **Imbalanced-learn**: Técnicas para clases desbalanceadas (SMOTE, ADASYN).
- **Scikit-optimize / Optuna**: Optimización Bayesiana de hiperparámetros.
- **Pandas Profiling / Sweetviz**: Análisis exploratorio automatizado.
- **SHAP / ELI5 / LIME**: Explicabilidad de modelos.

## Hoja de ruta

**Principiante:**
1. Fundamentos de estadística: media, varianza, correlación, distribución normal, probabilidad.
2. Python científico: NumPy, Pandas, Matplotlib básico.
3. Regresión lineal con scikit-learn: entrenamiento, evaluación, interpretación de coeficientes.
4. Clasificación con k-NN y regresión logística: accuracy, matriz de confusión, precisión, recall.
5. Conceptos de train/test split, overfitting, underfitting.

**Intermedio:**
1. Árboles de decisión y Random Forest: interpretación, feature importance.
2. SVM: kernel lineal, polinomial, RBF; efecto de regularización (C, gamma).
3. Feature engineering: encoding, escalado (StandardScaler, MinMaxScaler), selección de características.
4. Cross-validation y GridSearchCV para optimización de hiperparámetros.
5. Clustering: k-means, DBSCAN, métricas de evaluación (inercia, silhouette score).

**Avanzado:**
1. Gradient Boosting: XGBoost, LightGBM, CatBoost, early stopping.
2. Ensemble avanzado: stacking, blending, voting classifiers.
3. Sesgo y varianza: bias-variance tradeoff, regularización L1/L2, ElasticNet.
4. ML en producción: pipelines (sklearn.pipeline), serialización (joblib, pickle), versionado de modelos.
5. Feature engineering avanzado: polinomial features, interacciones, target encoding, embeddings.

## Relaciones con otros módulos

- `../031-AI/`: Fundamento de la inteligencia artificial y su historia.
- `../033-DeepLearning/`: Deep Learning como extensión del ML clásico con redes profundas.
- `../034-LLM/`: LLMs como modelos de lenguaje basados en ML a gran escala.
- `../035-RAG/`: Recuperación y reranking usando modelos de ML clásico.
- `../038-VectorDatabases/`: Feature embeddings generados por modelos de ML.
- `../039-PromptEngineering/`: Prompts optimizados con técnicas basadas en ML.
- `../096-Optimization/`: Optimización de hiperparámetros y funciones de pérdida.
- `../058-KnowledgeGraph/`: Extracción de relaciones y entidades con ML.

## Recursos recomendados

- **Libro**: "Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow" (Aurélien Géron).
- **Libro**: "The Elements of Statistical Learning" (Hastie, Tibshirani, Friedman).
- **Curso**: "Machine Learning" (Andrew Ng) en Coursera — Clásico fundamental.
- **Documentación**: Scikit-learn User Guide (scikit-learn.org/stable/user_guide.html).
- **Cheat Sheet**: "Scikit-learn Algorithm Cheat Sheet" — Selección rápida de algoritmos.
- **Repositorio**: scikit-learn examples, Kaggle ML competitions.
- **Video**: "StatQuest" (Josh Starmer) en YouTube — Explicaciones intuitivas de ML.
