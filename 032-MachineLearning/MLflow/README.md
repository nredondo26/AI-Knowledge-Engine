# MLflow

## Descripción del dominio

MLflow es una plataforma开源 de código abierto para gestionar el ciclo de vida completo de proyectos de Machine Learning. Desarrollada por Databricks, MLflow proporciona componentes para experiment tracking (seguimiento de experimentos), empaquetado de código reproducible, registro y versionado de modelos, y despliegue. Es independiente del framework y del lenguaje, funcionando con cualquier biblioteca de ML (scikit-learn, PyTorch, TensorFlow, XGBoost) y en cualquier infraestructura (local, cloud, Kubernetes).

## Componentes principales

- **MLflow Tracking**: API para registrar parámetros, métricas, artefactos y metadatos durante la ejecución de experimentos. Interfaz web para comparar ejecuciones.
- **MLflow Projects**: Formato estándar para empaquetar código de ML de manera reproducible (conda.yaml, Docker, entry points).
- **MLflow Models**: Formato estándar para empaquetar modelos entrenados con metadatos (firmas de entrada/salida, dependencias, conda environment). Soporte para múltiples flavors (python_function, sklearn, pytorch, onnx).
- **MLflow Model Registry**: Almacén centralizado de modelos con versionado, estados (Staging, Production, Archived) y transiciones. Integración con CI/CD.
- **MLflow Deployments**: APIs para servir modelos como endpoints REST, incluyendo contenedores Docker, SageMaker, Azure ML, y Kubernetes.

## Ejemplo: Seguimiento de experimentos

```python
import mlflow
import mlflow.sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, f1_score

mlflow.set_experiment("iris_experiment")

with mlflow.start_run(run_name="random_forest_baseline"):
    X, y = load_iris(return_X_y=True)
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    params = {"n_estimators": 100, "max_depth": 5, "random_state": 42}
    mlflow.log_params(params)

    model = RandomForestClassifier(**params)
    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)
    acc = accuracy_score(y_test, y_pred)
    f1 = f1_score(y_test, y_pred, average='weighted')

    mlflow.log_metrics({"accuracy": acc, "f1_weighted": f1})
    mlflow.sklearn.log_model(model, "model")

    print(f"accuracy={acc:.3f}, f1={f1:.3f}")
```

## Ejemplo: Registro y carga de modelos

```python
import mlflow

# Registrar modelo desde una ejecución
with mlflow.start_run() as run:
    model = RandomForestClassifier(n_estimators=100)
    model.fit(X_train, y_train)
    mlflow.sklearn.log_model(model, "model")

    run_id = run.info.run_id
    model_uri = f"runs:/{run_id}/model"
    mlflow.register_model(model_uri, "IrisRandomForest")

# Cargar modelo desde el registro en producción
import mlflow.pyfunc

model_prod = mlflow.pyfunc.load_model(
    model_uri="models:/IrisRandomForest/Production"
)
predicciones = model_prod.predict(X_test)
```

## Ejemplo: Servir modelo como API

```python
# Desde terminal:
# mlflow models serve -m models:/IrisRandomForest/Production --port 5001
# Luego desde Python:
import requests
import json

data = {"inputs": [[5.1, 3.5, 1.4, 0.2], [6.7, 3.1, 4.7, 1.5]]}
response = requests.post("http://localhost:5001/invocations",
                         json=data,
                         headers={"Content-Type": "application/json"})
print(response.json())
```

## Tecnologías principales

- **MLflow Tracking**: UI web, API Python/R/Java, autologging.
- **MLflow Models**: Flavors: sklearn, pytorch, tensorflow, keras, xgboost, lightgbm, onnx, pmml, spark.
- **MLflow Registry**: Almacén backend (MySQL, PostgreSQL, SQLite, Databricks).
- **MLflow Deployments**: Docker, SageMaker, Azure ML, Kubernetes, local.
- **Integraciones**: Apache Spark, Databricks, Airflow, Kubeflow, SageMaker.

## Hoja de ruta

1. Instalar MLflow e iniciar el servidor de tracking (`mlflow ui`).
2. Registrar parámetros, métricas y artefactos con `mlflow.log_*`.
3. Comparar ejecuciones en la UI web.
4. Empaquetar modelos con `mlflow.models` y registrar en el Model Registry.
5. Servir modelos como API REST localmente.
6. Integrar MLflow en pipelines de CI/CD.
7. Escalar con tracking distribuido y despliegue en cloud.

## Relaciones con otros módulos

- `../Supervised/`: Seguimiento de experimentos de modelos supervisados.
- `../Unsupervised/`: Registro de pipelines de clustering y reducción.
- `../../033-DeepLearning/ModelOptimization/`: Seguimiento de optimización de modelos.
- `../../033-DeepLearning/`: Registro de modelos PyTorch y TensorFlow.

## Recursos recomendados

- **Documentación**: MLflow Documentation (mlflow.org/docs).
- **Repositorio**: mlflow/mlflow (GitHub).
- **Curso**: "MLflow: el ciclo de vida del Machine Learning" (Databricks).
- **Cheat Sheet**: MLflow Quickstart.
