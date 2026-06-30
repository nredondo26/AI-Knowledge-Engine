# TensorFlow / Keras (033-DeepLearning/TensorFlow)

## Descripción del dominio

TensorFlow es un framework de deep learning desarrollado por Google Brain, lanzado como open-source en 2015. Su ecosistema incluye Keras (API de alto nivel), TensorFlow Lite (móvil/edge), TensorFlow.js (navegador), TFX (pipelines de producción), TPU (hardware especializado) y TensorBoard (visualización). Aunque PyTorch domina la investigación académica, TensorFlow mantiene una presencia masiva en producción industrial, despliegue en dispositivos móviles y ecosistemas cloud (GCP, Vertex AI). Keras, integrada como `tf.keras`, ofrece una API intuitiva que sigue el principio de "progressive disclosure of complexity": fácil para principiantes, potente para expertos.

## Ecosistema TensorFlow

| Componente | Propósito | API principal |
|------------|-----------|---------------|
| **TensorFlow Core** | Computación numérica con grafo computacional | `tf.*` |
| **Keras** | API de alto nivel para construir y entrenar modelos | `tf.keras.*` |
| **TF Data** | Pipeline de entrada de datos eficiente | `tf.data.Dataset` |
| **TF Lite** | Inferencia en dispositivos móviles/embebidos | `tf.lite.*` |
| **TF.js** | Deep learning en navegador / Node.js | `tfjs` |
| **TFX** | Pipelines de producción completos | `tfx.*` |
| **TF Serving** | Servicio de modelos en producción | `tensorflow_model_server` |
| **TensorBoard** | Visualización de métricas, gráficos, embeddings | `tf.keras.callbacks.TensorBoard` |
| **TPU** | Aceleración hardware especializada | `tf.distribute.TPUStrategy` |
| **TF Datasets** | Datasets estándar preprocesados | `tensorflow_datasets` |

## Conceptos fundamentales

### Tensores y operaciones

```python
import tensorflow as tf

# Tensores fundamentales
scalar = tf.constant(42)
vector = tf.constant([1, 2, 3, 4])
matrix = tf.constant([[1, 2], [3, 4]])
tensor_3d = tf.constant([[[1, 2], [3, 4]], [[5, 6], [7, 8]]])

print(f"Escalar: {scalar}, shape={scalar.shape}")
print(f"Vector: {vector}, shape={vector.shape}")
print(f"Matriz: {matrix}, shape={matrix.shape}")
print(f"Tensor 3D: {tensor_3d}, shape={tensor_3d.shape}")

# Operaciones con tensores
a = tf.constant([[1, 2], [3, 4]], dtype=tf.float32)
b = tf.constant([[5, 6], [7, 8]], dtype=tf.float32)

print(f"Suma:\n{a + b}")
print(f"Producto matricial:\n{a @ b}")
print(f"Transpuesta:\n{tf.transpose(a)}")

# Broadcasting (como NumPy)
c = tf.constant([10, 20])
print(f"Broadcasting:\n{a + c}")

# GradientTape: diferenciación automática
x = tf.Variable(3.0)
with tf.GradientTape() as tape:
    y = x ** 3 + 2 * x ** 2 + 5
dy_dx = tape.gradient(y, x)
print(f"dy/dx en x=3: {dy_dx.numpy():.2f}")  # 3x² + 4x = 3(9) + 12 = 39
```

### tf.data: pipelines de datos eficientes

```python
# Dataset desde numpy
import numpy as np

X = np.random.randn(1000, 32).astype(np.float32)
y = np.random.randint(0, 2, 1000).astype(np.float32)

dataset = tf.data.Dataset.from_tensor_slices((X, y))
dataset = dataset.shuffle(1000).batch(32).prefetch(tf.data.AUTOTUNE)

# Transformaciones dentro del pipeline
def augment(x, y):
    x = x + tf.random.normal(tf.shape(x), stddev=0.01)
    return x, y

dataset_aug = dataset.map(augment, num_parallel_calls=tf.data.AUTOTUNE)

# Iteración eficiente
for batch_x, batch_y in dataset_aug.take(1):
    print(f"Batch X shape: {batch_x.shape}, Batch y shape: {batch_y.shape}")
```

## Construcción de modelos con Keras

### 1. Sequential API (modelos secuenciales)

```python
from tensorflow import keras
from tensorflow.keras import layers

# CNN para clasificación MNIST
model = keras.Sequential([
    layers.Input(shape=(28, 28, 1)),
    layers.Conv2D(32, kernel_size=(3, 3), activation='relu'),
    layers.MaxPooling2D(pool_size=(2, 2)),
    layers.Conv2D(64, kernel_size=(3, 3), activation='relu'),
    layers.MaxPooling2D(pool_size=(2, 2)),
    layers.Flatten(),
    layers.Dropout(0.5),
    layers.Dense(128, activation='relu'),
    layers.Dropout(0.3),
    layers.Dense(10, activation='softmax')
])

model.compile(
    optimizer=keras.optimizers.Adam(learning_rate=1e-3),
    loss=keras.losses.SparseCategoricalCrossentropy(),
    metrics=['accuracy']
)

print(model.summary())
```

### 2. Functional API (modelos complejos, multi-input/output)

```python
from tensorflow.keras import layers, Model, Input

# Modelo con dos inputs y un output
input_a = Input(shape=(32,), name='numeric_input')
input_b = Input(shape=(10,), name='categorical_input')

# Rama numérica
x = layers.Dense(64, activation='relu')(input_a)
x = layers.BatchNormalization()(x)
x = layers.Dropout(0.3)(x)

# Rama categórica
y = layers.Dense(32, activation='relu')(input_b)
y = layers.Dropout(0.2)(y)

# Concatenación
combined = layers.concatenate([x, y])
z = layers.Dense(64, activation='relu')(combined)
z = layers.Dropout(0.4)(z)
output = layers.Dense(1, activation='sigmoid', name='output')(z)

model_fn = Model(inputs=[input_a, input_b], outputs=output, name='multi_input_model')
model_fn.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
model_fn.summary()
```

### 3. Subclassing API (máximo control)

```python
class TransformerBlock(layers.Layer):
    """Bloque Transformer minimalista como capa personalizada"""
    def __init__(self, embed_dim, num_heads, ff_dim, rate=0.1):
        super().__init__()
        self.att = layers.MultiHeadAttention(num_heads=num_heads, key_dim=embed_dim)
        self.ffn = keras.Sequential([
            layers.Dense(ff_dim, activation='relu'),
            layers.Dense(embed_dim)
        ])
        self.layernorm1 = layers.LayerNormalization(epsilon=1e-6)
        self.layernorm2 = layers.LayerNormalization(epsilon=1e-6)
        self.dropout1 = layers.Dropout(rate)
        self.dropout2 = layers.Dropout(rate)

    def call(self, inputs, training=False):
        attn_output = self.att(inputs, inputs)
        attn_output = self.dropout1(attn_output, training=training)
        out1 = self.layernorm1(inputs + attn_output)
        ffn_output = self.ffn(out1)
        ffn_output = self.dropout2(ffn_output, training=training)
        return self.layernorm2(out1 + ffn_output)

class CustomClassifier(keras.Model):
    def __init__(self, vocab_size=10000, embed_dim=128, num_heads=4, ff_dim=256, num_classes=5):
        super().__init__()
        self.embedding = layers.Embedding(vocab_size, embed_dim)
        self.transformer = TransformerBlock(embed_dim, num_heads, ff_dim)
        self.global_pool = layers.GlobalAveragePooling1D()
        self.dropout = layers.Dropout(0.3)
        self.classifier = layers.Dense(num_classes, activation='softmax')

    def call(self, inputs, training=False):
        x = self.embedding(inputs)
        x = self.transformer(x, training=training)
        x = self.global_pool(x)
        x = self.dropout(x, training=training)
        return self.classifier(x)

# Uso
model_custom = CustomClassifier()
model_custom.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
```

## Entrenamiento y callbacks

```python
# Callbacks esenciales
callbacks = [
    keras.callbacks.EarlyStopping(
        monitor='val_loss', patience=10, restore_best_weights=True
    ),
    keras.callbacks.ReduceLROnPlateau(
        monitor='val_loss', factor=0.5, patience=5, min_lr=1e-7
    ),
    keras.callbacks.ModelCheckpoint(
        'best_model.keras', monitor='val_accuracy', save_best_only=True
    ),
    keras.callbacks.TensorBoard(
        log_dir='./logs', histogram_freq=1, write_graph=True
    ),
    keras.callbacks.CSVLogger('training_log.csv'),
]

# Entrenamiento con tf.data dataset
history = model.fit(
    dataset_aug,
    validation_data=(X_val, y_val),
    epochs=100,
    callbacks=callbacks,
    verbose=1
)

# Visualizar entrenamiento
import matplotlib.pyplot as plt
plt.plot(history.history['loss'], label='train')
plt.plot(history.history['val_loss'], label='val')
plt.title('Loss durante entrenamiento')
plt.xlabel('Epoch')
plt.legend()
# plt.show()
```

## Estrategias de distribución

```python
# Data Parallelism: entrenar en múltiples GPUs/TPUs
strategy = tf.distribute.MirroredStrategy()  # GPU múltiples
# strategy = tf.distribute.TPUStrategy()     # TPU

with strategy.scope():
    model_dist = keras.Sequential([
        layers.Input(shape=(28, 28, 1)),
        layers.Conv2D(32, 3, activation='relu'),
        layers.GlobalAveragePooling2D(),
        layers.Dense(10, activation='softmax')
    ])
    model_dist.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])

# El batch size se distribuye automáticamente entre los dispositivos
```

## TensorFlow Lite: despliegue en móvil/edge

```python
# Conversión a TFLite (modelo cuantizado)
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]  # Cuantización int8
tflite_model = converter.convert()

with open('model_quantized.tflite', 'wb') as f:
    f.write(tflite_model)

# Inferencia con TFLite en Python
interpreter = tf.lite.Interpreter(model_content=tflite_model)
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Ejecutar inferencia
input_data = np.random.randn(1, 28, 28, 1).astype(np.float32)
interpreter.set_tensor(input_details[0]['index'], input_data)
interpreter.invoke()
output_data = interpreter.get_tensor(output_details[0]['index'])
print(f"Predicción TFLite: {np.argmax(output_data)}")
```

## TensorBoard: visualización de métricas

```python
# Log de métricas personalizadas
class CustomMetricLogger(keras.callbacks.Callback):
    def on_epoch_end(self, epoch, logs=None):
        logs = logs or {}
        # Escribir métricas personalizadas
        writer = tf.summary.create_file_writer('logs/custom')
        with writer.as_default():
            tf.summary.scalar('custom_accuracy', logs.get('accuracy', 0), step=epoch)

# Lanzar TensorBoard desde terminal:
# tensorboard --logdir=./logs --port=6006
```

## Buenas prácticas en TensorFlow/Keras

1. **Usar `tf.data`** para pipelines de entrada en lugar de alimentar datos con numpy directamente.
2. **Prefetch con `tf.data.AUTOTUNE`** para superponer preprocesamiento y entrenamiento.
3. **Mixed precision** para entrenar más rápido en GPUs modernas: `tf.keras.mixed_precision.set_global_policy('mixed_float16')`.
4. **Functional API** para la mayoría de modelos (más flexible que Sequential, más legible que Subclassing).
5. **Checkpointing + EarlyStopping** para recuperar mejor modelo.
6. **TensorBoard** para depuración de pérdidas, métricas, histogramas de pesos.
7. **Usar `model.save('model.keras')`** (formato nativo Keras v3) en lugar de H5 o SavedModel cuando sea posible.
8. **Profile con TensorBoard** para identificar cuellos de botella: `tf.profiler.experimental.start('logdir')`.

## Relaciones con otros módulos

- `../PyTorch/`: Alternativa principal de deep learning; comparación de APIs y rendimiento.
- `../CNN/`: Implementación de CNNs con TensorFlow/Keras.
- `../Transformers/`: Modelos transformer con KerasNLP / Hugging Face + TF backend.
- `../ModelOptimization/`: Cuantización, pruning, knowledge distillation con TFLite y TF Model Optimization Toolkit.
- `../../032-MachineLearning/ScikitLearn/`: Uso de sklearn para preprocesamiento combinado con modelos TF.
- `../../034-LLM/`: LLMs con TensorFlow (Gemma, T5, BERT).

## Recursos recomendados

- **Documentación**: https://www.tensorflow.org/learn — Guías, tutoriales, API docs.
- **Libro**: "Deep Learning with Python" (François Chollet) — El libro de Keras por su creador.
- **Curso**: "TensorFlow Developer Certificate" (DeepLearning.AI) — Coursera.
- **Repositorio**: https://github.com/tensorflow/models — Modelos oficiales.
- **Paper**: "TensorFlow: A System for Large-Scale Machine Learning" (Abadi et al., 2016).
- **Herramienta**: TensorBoard.dev — Compartir experimentos online.
- **Ejemplos**: https://www.tensorflow.org/tutorials — Tutoriales oficiales.
