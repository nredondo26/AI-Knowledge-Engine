# 032-MachineLearning: Aprendizaje Automático

## Descripción ampliada del dominio

Machine Learning (ML) es el subcampo de la IA que proporciona a los sistemas la capacidad de aprender y mejorar automáticamente a partir de la experiencia sin ser programados explícitamente para cada tarea. Los algoritmos ML construyen modelos matemáticos basados en datos de entrenamiento para hacer predicciones o decisiones. ML se divide en aprendizaje supervisado (etiquetas disponibles), no supervisado (sin etiquetas), semi-supervisado, por refuerzo (agente + entorno), y auto-supervisado (modelos fundacionales). Este módulo cubre algoritmos clásicos (regresión, árboles, SVM, clustering, PCA), pipelines de ML (feature engineering, training, evaluation, deployment), frameworks (scikit-learn, XGBoost, LightGBM), MLOps, y aplicaciones prácticas. La evolución de ML: modelos lineales (1950s-60s) → árboles de decisión/random forest (1980s-90s) → SVM, boosting (1990s-2000s) → deep learning (2010s) → foundation models (2020s). ML está integrado en prácticamente todos los productos tecnológicos: búsqueda web, recomendaciones, detección de fraude, diagnóstico médico, conducción autónoma, procesamiento de lenguaje y visión.

## Tabla de conceptos clave

| Concepto | Descripción | Algoritmos/Técnicas |
|----------|-------------|---------------------|
| Aprendizaje Supervisado | Modelo aprende de datos etiquetados (input → output) | Regresión (lineal, polinomial, Ridge, Lasso), Random Forest, SVM, XGBoost, LightGBM, CatBoost |
| Aprendizaje No Supervisado | Modelo encuentra patrones en datos sin etiquetas | K-Means, DBSCAN, Hierarchical clustering, PCA, t-SNE, UMAP |
| Aprendizaje Semi-Supervisado | Combinación de pocos datos etiquetados y muchos no etiquetados | Self-training, Co-training, Label propagation, S3VM |
| Aprendizaje por Refuerzo | Agente aprende por interacción con entorno (recompensa) | Q-learning, DQN, PPO, A2C, SAC |
| Auto-Supervisado | Modelo aprende representaciones sin etiquetas humanas | GPT, BERT, SimCLR, MAE (Masked Autoencoder) |
| Bias-Variance Tradeoff | Balance entre sesgo (errores sistemáticos) y varianza (sensibilidad a datos) | Underfitting (high bias), Overfitting (high variance), Regularization |
| Regularización | Técnicas para reducir overfitting | L1 (Lasso), L2 (Ridge), ElasticNet, Dropout, Early stopping |
| Feature Engineering | Creación/transformación de características | Encoding, scaling, binning, interaction terms, polynomial features |
| Cross-Validation | Evaluación robusta del modelo | K-fold, Stratified K-fold, Leave-One-Out, Time Series split |
| Ensemble Learning | Combinación de múltiples modelos | Bagging (Random Forest), Boosting (XGBoost, AdaBoost), Stacking |
| MLOps | Prácticas DevOps para ML | MLflow, Kubeflow, TFX, Feast, DVC, Weights & Biases |
| Imbalance | Manejo de clases desbalanceadas | SMOTE, ADASYN, class weights, focal loss |

## Tecnologías principales

| Framework/Librería | Propósito | Lenguaje | GPU | Distribuido | Ideal para |
|--------------------|-----------|----------|-----|-------------|------------|
| Scikit-learn | ML clásico (50+ algoritmos) | Python | No | Joblib | Prototipado, ML clásico, data analysis |
| XGBoost | Gradient boosting (árboles) | Python, R, C++, Java | Sí (histogram) | Sí (distribuido) | Tabular data, kaggle, producción |
| LightGBM | Gradient boosting (hoja-sabia) | Python, R, C++ | Sí | Sí (paralelo) | Tabular data, datasets grandes |
| CatBoost | Gradient boosting (categórico) | Python, R, C++ | Sí | Sí (multi-GPU) | Datos categóricos, default settings |
| PyTorch | Deep learning framework | Python, C++ | Sí (CUDA) | Sí (DDP, FSDP) | Research, deep learning, custom models |
| TensorFlow/Keras | Deep learning framework | Python, JS, C++ | Sí (CUDA) | Sí (TPU, multi-GPU) | Producción, TF Serving, mobile |
| JAX | Autograd + XLA (aceleración) | Python | Sí | Sí (pmap, sharded) | Research, transformers, numerics |
| Spark MLlib | ML distribuido en Spark | Scala, Python, Java, R | No | Sí (Spark cluster) | Big data, ETL + ML pipelines |
| ONNX Runtime | Inferencia multiplataforma | Python, C++, C# | Sí | Sí | Model deployment cross-platform |
| MLflow | MLOps: tracking, models, registry | Python, R, Java | — | — | Experiment tracking, model registry |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: qué es ML, diferencia con IA y DL, tipos de aprendizaje. ML pipeline: datos → entrenamiento → evaluación → predicción. Aprendizaje supervisado: regresión lineal (mínimos cuadrados, métricas: MSE, MAE, R²), regresión logística (probabilidad, sigmoid, log-loss, métricas: accuracy, precision, recall, F1, ROC/AUC). Aprendizaje no supervisado: K-Means (elbow method, silhouette score), PCA (dimensionality reduction, variance explained). Bias-variance tradeoff: underfitting vs overfitting, train/validation/test split. Python + Scikit-learn: train_test_split, fit, predict, score, cross_val_score. Preprocesamiento: StandardScaler, MinMaxScaler, OneHotEncoder, LabelEncoder. Visualización: matplotlib, seaborn (pairplot, heatmap, confusion matrix). Datasets: Iris, Titanic, Boston Housing, Breast Cancer.
   - Proyecto: Clasificador de Titanic con Random Forest. Regresor de precios de casas (viviendas de California).
   - Lectura: "Hands-On ML" (Geron, 3ª ed.) capítulos 1-4, Scikit-learn docs, Kaggle learn.

2. **Intermedio (3-8 meses)**: Algoritmos avanzados: SVM (kernel trick, RBF, polynomial, regularization C), árboles de decisión (entropy vs gini, pruning, max_depth), Random Forest (n_estimators, feature importance), Gradient Boosting (XGBoost, LightGBM, CatBoost). Feature engineering: missing value imputation, encoding (ordinal, one-hot, target encoding, frequency encoding), binning, polynomial features, interaction features, feature selection (filter, wrapper, embedded). Hyperparameter tuning: GridSearchCV, RandomizedSearchCV, Bayesian Optimization (Optuna, Hyperopt). Cross-validation: K-fold, stratified, grouped, time series split. Ensemble methods: bagging (Random Forest), boosting (AdaBoost, Gradient Boosting, XGBoost), stacking (meta-model). Dimensionality reduction: PCA (decomposition, scree plot), t-SNE (visualization), LDA (discriminant analysis). Imbalanced data: SMOTE, ADASYN, class weight, focal loss, threshold tuning. Model interpretability: SHAP (SHapley Additive exPlanations), Partial Dependence Plots (PDP), Feature importance, Permutation importance. Pipelines: sklearn Pipeline, ColumnTransformer, FeatureUnion.
   - Proyecto: XGBoost on Kaggle (car insurance, credit default) with feature engineering + hyperparameter tuning. Interpretability analysis con SHAP.
   - Certificación: TensorFlow Developer Certificate (TF cert), AWS ML Specialty, Google Professional ML Engineer.
   - Lectura: "Hands-On ML" capítulos 5-10, "Feature Engineering for ML" (Zheng, Casari), "Interpretable ML" (Molnar).

3. **Avanzado (8-14 meses)**: MLOps: experiment tracking (MLflow, Weights & Biases, Neptune), model registry, model versioning, CI/CD for ML (GitHub Actions + MLflow). Model deployment: REST API (FastAPI + MLflow), batch inference (Spark), edge inference (ONNX, TensorRT). Feature store: Feast, Tecton, Hopsworks (feature serving, consistency, point-in-time correct joins). Data pipelines: TFX, Apache Beam, Airflow (orquestración ML). Data drift & model monitoring: Evidently AI, WhyLabs, Arize AI (data drift, concept drift, model performance degradation). AutoML: H2O AutoML, AutoGluon, TPOT, FLAML (automated model selection, hyperparameter tuning, feature engineering). Time series forecasting: ARIMA, Prophet, LSTM, N-BEATS, Temporal Fusion Transformer (TFT). Anomaly detection: Isolation Forest, LOF, autoencoder, Deep SVDD. Recommendation systems: collaborative filtering (matrix factorization: ALS, SVD), content-based, hybrid (wide & deep, DLRM), neural collaborative filtering. NLP with ML: TF-IDF + Logistic Regression, Word2Vec + classifier, FastText. Large-scale ML: distributed training (Spark MLlib, Dask ML, Ray). Causal ML: uplift modeling, CATE estimation, synthetic control.
   - Proyecto: MLOps pipeline (feast + mlflow + fastapi + monitoring). Time series forecasting with Prophet/LSTM. Recommendation system with matrix factorization + deep learning.
   - Certificación: AWS ML Specialty, GCP Professional ML Engineer, Azure Data Scientist Associate.
   - Lectura: "ML Engineering" (Burkov), "Designing ML Systems" (Huyen), "Feature Engineering for ML" (Zheng).

4. **Experto (12+ meses)**: ML at scale: distributed training (PyTorch DDP, FSDP, DeepSpeed, Horovod), data parallelism, model parallelism, pipeline parallelism. ML infrastructure: GPU cluster management, Kubernetes for ML (Kubeflow, Kserve, Ray), spot instance training, checkpointing. AutoML 2.0: neural architecture search (NAS), differentiable architecture search (DARTS), hypernetwork. Foundation models: pre-training at scale (data curation, tokenization, training recipes), fine-tuning (full, LoRA, QLoRA, IA3, adapters). ML for science: reinforcement learning for drug discovery, graph neural networks for molecular properties, AlphaFold, GNoME. Causal inference: do-calculus, structural causal models, IV, diff-in-diff, regression discontinuity. Privacy-preserving ML: differential privacy (DP-SGD), federated learning (FL), split learning, confidential computing (Intel SGX, AMD SEV). ML fairness: fair representation learning, adversarial debiasing, equal opportunity, disparate impact metrics. Advanced topics: online learning (bandits, regret bounds), Bayesian nonparametrics (Gaussian processes, Dirichlet processes). ML ops for LLM: data pipeline, training infrastructure, evaluation benchmarks, deployment (vLLM, TGI). ML research: revisiting old ideas (KANs, liquid networks), new architectures (state space models, Mamba), scaling laws.
   - Proyecto: Distributed training of a large model (1B+ param). Privacy-preserving ML pipeline. AutoML system for tabular data. ML infrastructure design (multi-node GPU).
   - Lectura: "Designing ML Systems" (Huyen), "Deep Learning" (Goodfellow), "Causal Inference: The Mixtape" (Cunningham), ArXiv (cs.LG).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Estadística, álgebra lineal, optimización, algoritmos |
| [001-Languages](../001-Languages/) | Python (principal), R para estadística |
| [003-Databases](../003-Databases/) | Data storage, feature stores, ML data pipelines |
| [005-Cloud](../005-Cloud/) | SageMaker, Vertex AI, Azure ML para entrenamiento y deploy |
| [007-Orchestration](../007-Orchestration/) | Kubeflow, Kserve para orchestación ML en K8s |
| [009-Security](../009-Security/) | Adversarial ML, model security, data poisoning |
| [013-DevOps](../013-DevOps/) | MLOps, CI/CD/CT para modelos ML |
| [031-AI](../031-AI/) | ML como subcampo fundamental de IA |
| [033-DeepLearning](../033-DeepLearning/) | DL como técnica principal de ML moderno |
| [034-LLM](../034-LLM/) | LLMs como aplicación de deep learning + ML |
| [038-VectorDatabases](../038-VectorDatabases/) | Embeddings generados por modelos ML |

## Recursos recomendados

- **Libros**: "Hands-On ML with Scikit-Learn, Keras & TF" (Geron, 3ª ed.), "Designing ML Systems" (Huyen), "Feature Engineering for ML" (Zheng), "Interpretable ML" (Molnar), "ML Engineering" (Burkov), "The Elements of Statistical Learning" (Hastie).
- **Cursos**: Stanford CS229 (ML theory), Coursera ML Specialization (Andrew Ng, Stanford), "ML for Production" (DeepLearning.AI), Kaggle Learn, "Fast.ai Practical Deep Learning".
- **Práctica**: Kaggle competitions, Papers with Code benchmarks, proyectos personales.
- **Herramientas**: Scikit-learn, XGBoost, LightGBM, CatBoost, Optuna, MLflow, Weights & Biases, DVC, Great Expectations.
- **Comunidad**: Kaggle, ML Ops Community, MLOps.community, Reddit r/MachineLearning, r/MLOps.

## Notas adicionales

Scikit-learn es la puerta de entrada perfecta para ML clásico. Para datos tabulares, XGBoost/LightGBM son los reyes indiscutibles (dominan Kaggle). Feature engineering sigue siendo la habilidad más importante para ML práctico. La comprensión de bias-variance, overfitting y evaluación es esencial antes de usar algoritmos complejos. MLOps es la habilidad práctica más demandada: saber implementar modelos en producción. Las competencias de Kaggle son excelente práctica. ML no es magia: entender los datos y el problema es más importante que el algoritmo.
