# 082-Datasets: Conjuntos de Datos

## Descripción del dominio

Los datasets o conjuntos de datos son la materia prima de la inteligencia artificial y el machine learning. La calidad, diversidad y volumen de los datos determinan directamente el rendimiento de los modelos. Este módulo cataloga datasets públicos por dominio, plataformas de referencia (Hugging Face, Kaggle), estrategias de data governance, versionado de datos y prácticas de curado.

## Conceptos clave

- **Data Curation**: Proceso de limpieza, normalización y enriquecimiento de datos crudos
- **Data Versioning**: Control de versiones de datasets usando herramientas como DVC o Hugging Face Datasets
- **Train/Validation/Test Split**: División del dataset en subconjuntos para entrenamiento, validación y evaluación
- **Data Drift**: Cambio en la distribución estadística de los datos a lo largo del tiempo
- **Data Governance**: Políticas y procesos para gestionar disponibilidad, integridad y seguridad de datos
- **Etiquetado / Anotación**: Asignación manual o automática de etiquetas a datos no estructurados
- **Synthetic Data**: Datos generados artificialmente que imitan propiedades estadísticas de datos reales
- **Bias in Data**: Sesgos presentes en los datos que pueden generar modelos discriminatorios
- **Data Augmentation**: Técnicas para expandir datasets mediante transformaciones controladas
- **Federated Datasets**: Conjuntos distribuidos que no pueden centralizarse por privacidad
- **Data Lineage**: Trazabilidad del origen, transformaciones y uso de cada dato

## Tecnologías principales

| Herramienta | Propósito |
|-------------|-----------|
| Hugging Face Datasets | Biblioteca principal de datasets para ML |
| Kaggle | Plataforma de competiciones y datasets públicos |
| DVC (Data Version Control) | Versionado de datasets y pipelines |
| Label Studio | Herramienta open-source de anotación |
| FiftyOne | Visualización y análisis de datasets de visión |
| TensorFlow Datasets | Colección de datasets listos para TF |
| Apache Parquet | Formato columnar eficiente para grandes datos |
| Great Expectations | Validación y testing de calidad de datos |
| Soda Core | Monitoreo de calidad de datos en producción |
| Data Version Control (DVC) | Git para datos — versionado de datasets |

## Hoja de ruta

**Nivel Principiante:**
1. Explorar datasets populares en Kaggle y Hugging Face
2. Cargar un dataset con Hugging Face Datasets library
3. Realizar un EDA (Análisis Exploratorio de Datos) básico
4. Dividir dataset en train/validation/test correctamente

**Nivel Intermedio:**
1. Implementar pipeline de data curation con pandas y DVC
2. Configurar anotación de datos con Label Studio
3. Detectar y mitigar sesgos en datasets usando Fairlearn
4. Usar data augmentation para imágenes (albumentations) o texto (NLPAug)

**Nivel Avanzado:**
1. Diseñar estrategia de data governance con Great Expectations
2. Implementar data versioning con DVC + S3/Google Cloud Storage
3. Crear datasets sintéticos con SDV (Synthetic Data Vault)
4. Establecer monitoreo de data drift en producción con Evidently AI

## Relaciones con otros módulos

- `../032-MachineLearning/` — Uso de datasets en entrenamiento de modelos
- `../033-DeepLearning/` — Datasets para CNN, RNN y transformers
- `../034-LLM/` — Datasets para fine-tuning y pre-entrenamiento de LLMs
- `../038-VectorDatabases/` — Ingesta de datasets en bases vectoriales
- `../053-Compliance/` — Cumplimiento GDPR y privacidad en datasets
- `../056-Glossary/` — Definiciones de términos relacionados con datos

## Recursos recomendados

- [Hugging Face Datasets](https://huggingface.co/docs/datasets/) — Documentación oficial
- [Kaggle Datasets](https://www.kaggle.com/datasets) — Portal de datasets comunitarios
- [Papers with Code Datasets](https://paperswithcode.com/datasets) — Datasets vinculados a papers
- [Google Dataset Search](https://datasetsearch.research.google.com) — Buscador académico de datasets
- [Awesome Public Datasets](https://github.com/awesomedata/awesome-public-datasets) — Lista curada en GitHub
- [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/index.php) — Repositorio histórico de datasets
- Libro: "Data Governance: The Definitive Guide" — Evren Eryurek et al.
