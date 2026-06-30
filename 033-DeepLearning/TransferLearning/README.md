# Transfer Learning

## Descripción del dominio

Transfer Learning (Aprendizaje por Transferencia) es una técnica de Machine Learning donde un modelo desarrollado para una tarea se reutiliza como punto de partida para una tarea diferente pero relacionada. En lugar de entrenar un modelo desde cero (lo que requiere muchos datos y tiempo), se toma un modelo pre-entrenado en un dataset masivo (como ImageNet para visión o Common Crawl para lenguaje) y se adapta a la tarea objetivo con pocos datos. Transfer Learning es fundamental en deep learning moderno: permite aplicar modelos estado-del-arte con recursos limitados y es la base del éxito de modelos fundacionales.

## Estrategias principales

- **Feature Extraction (Extractor de Características)**: Congelar las capas del modelo pre-entrenado y usar sus salidas como características de entrada para un clasificador nuevo entrenado desde cero.
- **Fine-tuning (Ajuste Fino)**: Descongelar algunas o todas las capas del modelo pre-entrenado y continuar el entrenamiento con datos de la tarea objetivo con una tasa de aprendizaje baja.
- **Progressive Fine-tuning**: Descongelar capas progresivamente durante el entrenamiento, empezando por las últimas.
- **Domain Adaptation**: Adaptar un modelo entrenado en un dominio fuente a un dominio objetivo diferente pero relacionado.

## Conceptos clave

- **Pre-entrenamiento (Pre-training)**: Entrenamiento inicial masivo en un dataset grande y genérico (ImageNet, Wikipedia, CommonCrawl).
- **Modelo Base/Fundacional**: Modelo pre-entrenado que sirve como punto de partida para múltiples tareas downstream.
- **Congelación (Freeze)**: No actualizar los pesos de ciertas capas durante el fine-tuning. Se logra con `requires_grad = False`.
- **Tasa de Aprendizaje Diferenciada**: Usar learning rate más bajo para capas pre-entrenadas y más alto para las nuevas capas.
- **Catástrofe del Olvido (Catastrophic Forgetting)**: El modelo olvida conocimiento pre-entrenado si se entrena con learning rate alto en la nueva tarea.

## Ejemplo: Transfer Learning con ResNet para clasificación

```python
import torch
import torch.nn as nn
import torchvision.models as models

# Cargar ResNet18 pre-entrenado en ImageNet
resnet = models.resnet18(weights=models.ResNet18_Weights.IMAGENET1K_V1)

# Congelar todas las capas
for param in resnet.parameters():
    param.requires_grad = False

# Reemplazar la última capa (fc) para la nueva tarea
num_features = resnet.fc.in_features
num_classes = 10  # ejemplo: CIFAR-10
resnet.fc = nn.Sequential(
    nn.Linear(num_features, 256),
    nn.ReLU(),
    nn.Dropout(0.3),
    nn.Linear(256, num_classes)
)

# Solo las capas nuevas tienen requires_grad=True
for param in resnet.fc.parameters():
    param.requires_grad = True

# Entrenamiento
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(resnet.fc.parameters(), lr=0.001)

# Fine-tuning progresivo: descongelar últimas capas después
def unfreeze_layers(model, layers_to_unfreeze):
    for name, param in model.named_parameters():
        if any(layer in name for layer in layers_to_unfreeze):
            param.requires_grad = True
```

## Ejemplo: Transfer Learning con Hugging Face Transformers

```python
from transformers import AutoTokenizer, AutoModelForSequenceClassification
from transformers import Trainer, TrainingArguments
import torch

model_name = "bert-base-uncased"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSequenceClassification.from_pretrained(
    model_name,
    num_labels=3,
    ignore_mismatched_sizes=True
)

# Congelar capas de embedding
for param in model.bert.embeddings.parameters():
    param.requires_grad = False

# Fine-tuning solo con capas superiores descongeladas
training_args = TrainingArguments(
    output_dir="./results",
    learning_rate=2e-5,
    per_device_train_batch_size=16,
    num_train_epochs=3,
    weight_decay=0.01,
)

# Ejemplo de inferencia con el modelo
texts = ["Me encanta este producto", "Es terrible", "Es regular"]
inputs = tokenizer(texts, padding=True, truncation=True, return_tensors="pt")
with torch.no_grad():
    outputs = model(**inputs)
    predictions = torch.softmax(outputs.logits, dim=1)
    print(predictions)
```

## Tecnologías principales

- **PyTorch**: torchvision.models (ResNet, VGG, EfficientNet, DenseNet), torch.hub.
- **TensorFlow/Keras**: tf.keras.applications (models pre-entrenados de ImageNet).
- **Hugging Face Transformers**: Modelos pre-entrenados para NLP (BERT, GPT-2, RoBERTa, T5).
- **Hugging Face Timm**: Colección de modelos de visión pre-entrenados (Ross Wightman).
- **OpenAI CLIP**: Modelo multi-modal visión-texto para zero-shot transfer.

## Hoja de ruta

1. Cargar modelo pre-entrenado de torchvision.models.
2. Feature extraction: congelar todo, entrenar solo el clasificador.
3. Fine-tuning: descongelar últimas capas, learning rate bajo.
4. Transfer learning con Hugging Face Transformers para clasificación de texto.
5. Fine-tuning progresivo y discriminación de learning rates.
6. Domain adaptation: ajustar modelo de un dominio a otro similar.
7. Evaluar cuándo usar transfer learning vs. entrenar desde cero.

## Relaciones con otros módulos

- `../CNN/`: Modelos CNN pre-entrenados son la aplicación más común de transfer learning.
- `../../034-LLM/`: Fine-tuning de LLMs como forma de transfer learning.
- `../../032-MachineLearning/MLflow/`: Seguimiento de experimentos de fine-tuning.
- `../ModelOptimization/`: Optimización de modelos transferidos para despliegue.

## Recursos recomendados

- **Curso**: "CS231n: CNNs for Visual Recognition" (Stanford) — Módulo de Transfer Learning.
- **Paper**: "How transferable are features in deep neural networks?" (Yosinski et al., 2014).
- **Documentación**: PyTorch Transfer Learning Tutorial.
- **Documentación**: Hugging Face Fine-tuning Guide.
- **Repositorio**: pytorch-image-models (timm).
