# Aprendizaje No Supervisado (Unsupervised)

## Descripción del dominio

El Aprendizaje No Supervisado trabaja con datos que no tienen etiquetas. El objetivo es descubrir patrones, estructuras ocultas o representaciones útiles en los datos sin supervisión externa. Las principales tareas incluyen clustering (agrupación), reducción de dimensionalidad, detección de anomalías y estimación de densidad. Es fundamental en análisis exploratorio, sistemas de recomendación, segmentación de clientes y preprocesamiento para otros algoritmos.

## Conceptos clave

- **Clustering (Agrupamiento)**: Partición de datos en grupos donde los elementos intra-grupo son similares e inter-grupo son diferentes. Algoritmos: k-means, DBSCAN, HDBSCAN, clustering jerárquico, Gaussian Mixture Models.
- **k-means**: Particiona datos en k clusters minimizando la inercia (suma de distancias al centroide). Rápido pero sensible a inicialización y outliers. Elbow method para elegir k.
- **DBSCAN**: Clustering basado en densidad. Encuentra clusters de forma arbitraria, identifica ruido. Requiere parámetros eps (radio) y min_samples.
- **Clustering Jerárquico**: Construye una jerarquía de clusters (dendrograma). Aglomerativo (bottom-up) o divisivo (top-down).
- **Reducción de Dimensionalidad**: Transformar datos de alta dimensionalidad a un espacio de menor dimensión preservando información relevante.
- **PCA (Principal Component Analysis)**: Proyección lineal que maximiza la varianza. Descomposición en componentes principales ortogonales.
- **t-SNE**: Reducción no lineal para visualización. Preserva vecindarios locales. Computacionalmente costoso.
- **UMAP**: Reducción no lineal más rápida que t-SNE, preserva mejor la estructura global.
- **Detección de Anomalías**: Identificar puntos que se desvían significativamente del patrón normal. Isolation Forest, LOF, One-Class SVM.
- **Autoencoders**: Red neuronal que aprende a comprimir y reconstruir datos. Útil para reducción de dimensionalidad no lineal.

## Ejemplo: Clustering con k-means y visualización

```python
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs
from sklearn.cluster import KMeans, DBSCAN
from sklearn.preprocessing import StandardScaler

X, y_true = make_blobs(n_samples=300, centers=4, cluster_std=0.6, random_state=0)
X = StandardScaler().fit_transform(X)

kmeans = KMeans(n_clusters=4, random_state=0, n_init='auto')
y_kmeans = kmeans.fit_predict(X)

dbscan = DBSCAN(eps=0.3, min_samples=5)
y_dbscan = dbscan.fit_predict(X)

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))
ax1.scatter(X[:, 0], X[:, 1], c=y_kmeans, cmap='viridis')
ax1.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1],
            marker='x', s=200, linewidths=3, color='red')
ax1.set_title('k-means (k=4)')

ax2.scatter(X[:, 0], X[:, 1], c=y_dbscan, cmap='viridis')
ax2.set_title('DBSCAN (eps=0.3, min_samples=5)')
plt.show()
```

## Ejemplo: PCA y visualización de alta dimensionalidad

```python
from sklearn.decomposition import PCA
from sklearn.datasets import load_digits

digits = load_digits()
X, y = digits.data, digits.target

pca = PCA(n_components=2)
X_pca = pca.fit_transform(X)

print(f"Varianza explicada: {pca.explained_variance_ratio_.sum():.3f}")

plt.figure(figsize=(10, 8))
scatter = plt.scatter(X_pca[:, 0], X_pca[:, 1], c=y, cmap='tab10', alpha=0.7)
plt.colorbar(scatter)
plt.title('PCA en dataset Digits')
plt.xlabel('Componente 1')
plt.ylabel('Componente 2')
plt.show()
```

## Tecnologías principales

- **Scikit-learn**: KMeans, DBSCAN, PCA, t-SNE, Isolation Forest, GaussianMixture.
- **UMAP**: Reducción de dimensionalidad no lineal rápida (umap-learn).
- **HDBSCAN**: Clustering basado en densidad jerárquico.
- **Yellowbrick**: Visualización de clustering y selección de k.
- **SciPy**: Clustering jerárquico (scipy.cluster.hierarchy).

## Hoja de ruta

1. k-means: implementación, elbow method, silhouette score.
2. DBSCAN: parámetros eps y min_samples, manejo de ruido.
3. Clustering jerárquico: dendrograma, interpretación.
4. PCA: componentes principales, varianza explicada, scree plot.
5. t-SNE y UMAP: parámetros de perplejidad, vecindad, visualización.
6. Detección de anomalías: Isolation Forest, LOF, comparación de métodos.
7. Gaussian Mixture Models: EM algorithm, criterios AIC/BIC.

## Relaciones con otros módulos

- `../Supervised/`: Contraste con aprendizaje supervisado.
- `../FeatureEngineering/`: PCA y reducción de dimensionalidad como preprocesamiento.
- `../../033-DeepLearning/GANs/`: Autoencoders y modelos generativos no supervisados.
- `../../031-AI/Bias/`: Sesgo en clustering y segmentación.

## Recursos recomendados

- **Libro**: "Hands-On Machine Learning" (Géron) — Capítulos sobre clustering y reducción de dimensionalidad.
- **Paper**: "Visualizing Data using t-SNE" (van der Maaten & Hinton, 2008).
- **Paper**: "UMAP: Uniform Manifold Approximation and Projection" (McInnes et al., 2018).
- **Documentación**: Scikit-learn Clustering Guide.
- **Repositorio**: hdbscan (GitHub), umap-learn (GitHub).
