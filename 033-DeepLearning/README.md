# Deep Learning (033-DeepLearning)

## Descripción del dominio

Deep Learning es un subcampo del Machine Learning basado en redes neuronales artificiales con múltiples capas ocultas (profundas). Estas arquitecturas son capaces de aprender representaciones jerárquicas de los datos, desde características simples en capas tempranas hasta conceptos abstractos en capas profundas. El Deep Learning ha revolucionado áreas como visión por computadora (CNNs), procesamiento del lenguaje natural (Transformers), generación de contenido (GANs, Diffusion Models) y aprendizaje por refuerzo. Los frameworks principales son TensorFlow (con Keras) y PyTorch, siendo este último el más popular en investigación. Las arquitecturas clave incluyen CNN (procesamiento espacial), RNN/LSTM (secuencias temporales), Transformers (atención) y modelos generativos.

## Conceptos clave

- **Red Neuronal Artificial**: Capas de neuronas con pesos, bias y funciones de activación. Forward propagation y backpropagation.
- **Funciones de Activación**: ReLU, sigmoide, tanh, softmax, GELU, Swish. No linealidad esencial para aprender patrones complejos.
- **CNN** (Convolutional Neural Network): Capas convolucionales para extraer características espaciales. Conv2D, pooling (max, average), stride, padding. Arquitecturas: ResNet, VGG, Inception, EfficientNet, YOLO.
- **RNN** (Recurrent Neural Network): Conexiones recurrentes para procesar secuencias. Sufren de vanishing gradient. LSTM y GRU son variantes con compuertas para controlar flujo de información.
- **LSTM** (Long Short-Term Memory): Celdas de memoria con forget gate, input gate, output gate. Ideales para series temporales, audio, texto.
- **Transformers**: Arquitectura basada exclusivamente en atención (self-attention). Sin recurrencia, permite paralelización. Base de BERT, GPT, todos los LLMs modernos.
- **GANs** (Generative Adversarial Networks): Dos redes (generador y discriminador) compiten. El generador crea datos sintéticos; el discriminador distingue real de falso.
- **Transfer Learning**: Usar un modelo pre-entrenado como punto de partida para una tarea nueva. Fine-tuning, feature extraction.
- **Atención (Attention)**: Mecanismo que pondera la importancia de diferentes partes de la entrada. Self-attention, cross-attention, multi-head attention.
- **Regularización**: Dropout, Batch Normalization, Layer Normalization, weight decay, data augmentation.
- **Optimización**: SGD, Adam, AdamW, RMSprop, learning rate scheduling (cosine, warmup, ReduceLROnPlateau).
- **Diffusion Models**: Modelos generativos que aprenden a revertir un proceso de difusión (ruido → dato). Base de DALL-E, Stable Diffusion, Midjourney.

## Tecnologías principales

- **PyTorch**: Framework dominante en investigación. Tensores dinámicos, autograd, torch.nn, torchvision, torchaudio, Hugging Face integration.
- **TensorFlow/Keras**: Framework de Google, ampliamente usado en industria. TFX para pipelines, TFLite para móviles, TensorFlow.js.
- **JAX**: Librería de Google Research para cómputo numérico acelerado, autograd, XLA. Usado por DeepMind.
- **Hugging Face Transformers**: Biblioteca estándar para modelos transformer pre-entrenados (BERT, GPT, LLaMA).
- **ONNX**: Formato interoperable para intercambio de modelos entre frameworks.
- **CUDA/cuDNN**: Aceleración GPU para deep learning. NVIDIA.
- **MLflow / Weights & Biases**: Seguimiento de experimentos y versionado de modelos.
- **Lightning AI / PyTorch Lightning**: Abstracción sobre PyTorch para simplificar entrenamiento.
- **Horovod / DeepSpeed**: Entrenamiento distribuido y paralelización.

## Hoja de ruta

**Principiante:**
1. Perceptrón simple, función de activación, pérdida (MSE, cross-entropy), backpropagation.
2. Redes densas (MLP) con Keras o PyTorch: capas, optimizadores, entrenamiento.
3. CNNs básicas: convolución, pooling, arquitectura LeNet-5, clasificación de imágenes.
4. Regularización: Dropout, Batch Normalization, data augmentation (ImageDataGenerator).
5. Proyecto: clasificador de dígitos MNIST, clasificación CIFAR-10.

**Intermedio:**
1. RNN/LSTM/GRU: procesamiento de secuencias, series temporales, generación de texto.
2. Transfer Learning: modelos pre-entrenados (ResNet, VGG, EfficientNet), fine-tuning.
3. Atención: mecanismo de atención básico, seq2seq con atención.
4. GANs básicas: DCGAN, entrenamiento estable, pérdidas (BCE, Wasserstein).
5. Optimización avanzada: AdamW, cosine annealing, warmup, gradient clipping.

**Avanzado:**
1. Transformers: self-attention, multi-head attention, positional encoding. Implementar desde cero.
2. Modelos generativos: Diffusion Models (DDPM, DDIM), VAE, flow-based models.
3. Entrenamiento distribuido: DDP (Distributed Data Parallel), FSDP (Fully Sharded Data Parallel).
4. Custom architectures: Swin Transformer, ConvNeXt, ViT (Vision Transformer).
5. Investigación: lectura de papers (NeurIPS, ICML, ICLR), reproducción de experimentos, contribuciones a frameworks.

## Relaciones con otros módulos

- `../032-MachineLearning/`: Conceptos base de ML aplicados a redes profundas.
- `../034-LLM/`: Transformers como arquitectura fundamental de los LLMs.
- `../035-RAG/`: Embeddings y modelos de recuperación basados en deep learning.
- `../037-AgenticAI/`: Modelos de deep learning como cerebro de agentes autónomos.
- `../038-VectorDatabases/`: Embeddings generados por redes neuronales.
- `../039-PromptEngineering/`: Prompts optimizados para modelos transformer.
- `../031-AI/`: Deep Learning como motor principal de la IA moderna.
- `../082-Datasets/`: Datasets etiquetados para entrenamiento de modelos profundos.

## Recursos recomendados

- **Libro**: "Deep Learning" (Goodfellow, Bengio, Courville) — El libro de referencia académico.
- **Libro**: "Deep Learning with Python" (François Chollet) — Práctico con Keras.
- **Curso**: "CS231n: Convolutional Neural Networks for Visual Recognition" (Stanford).
- **Curso**: "CS224n: Natural Language Processing with Deep Learning" (Stanford).
- **Paper**: "Attention Is All You Need" (Vaswani et al., 2017) — El transformer original.
- **Paper**: "Deep Residual Learning for Image Recognition" (He et al., 2015) — ResNet.
- **Repositorio**: pytorch/examples, tensorflow/models, awesome-deep-learning (GitHub).
