# Redes Neuronales Convolucionales (CNN)

## Descripción del dominio

Las Redes Neuronales Convolucionales (CNN) son una clase especializada de redes neuronales diseñadas para procesar datos con estructura de cuadrícula, especialmente imágenes. Su arquitectura se basa en tres ideas clave: campos receptivos locales, pesos compartidos (convolución) y submuestreo (pooling). Las CNN han revolucionado la visión por computadora, logrando rendimiento sobrehumano en clasificación de imágenes, detección de objetos, segmentación semántica y más. Arquitecturas emblemáticas incluyen LeNet-5, AlexNet, VGG, ResNet, Inception, EfficientNet y YOLO.

## Conceptos clave

- **Convolución 2D**: Operación que aplica un filtro (kernel) sobre la imagen de entrada, produciendo un mapa de activación (feature map). Captura patrones locales como bordes, texturas.
- **Kernel/Filtro**: Matriz pequeña (3×3, 5×5) que se desliza sobre la entrada. Cada kernel detecta un patrón específico.
- **Stride**: Número de píxeles que el kernel se desplaza en cada paso. Stride > 1 reduce el tamaño espacial.
- **Padding**: Relleno de ceros alrededor de la entrada para controlar el tamaño de salida. "same" (tamaño igual), "valid" (sin padding).
- **Pooling**: Operación de submuestreo que reduce la dimensionalidad espacial. Max pooling, average pooling, global average pooling.
- **Feature Map**: Salida de una capa convolucional, representa la presencia de patrones en diferentes ubicaciones espaciales.
- **Capas Convolucionales vs. Densas**: Convolucionales preservan estructura espacial, tienen menos parámetros gracias a pesos compartidos.
- **Arquitecturas Notables**: LeNet-5 (MNIST), AlexNet (ImageNet), VGG (3×3 stacks), ResNet (skip connections), Inception (múltiples kernels), EfficientNet (compound scaling).

## Ejemplo: CNN para clasificación de imágenes

```python
import torch
import torch.nn as nn
import torch.nn.functional as F

class SimpleCNN(nn.Module):
    def __init__(self, num_classes=10):
        super().__init__()
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, padding=1)
        self.bn1 = nn.BatchNorm2d(32)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, padding=1)
        self.bn2 = nn.BatchNorm2d(64)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv3 = nn.Conv2d(64, 128, kernel_size=3, padding=1)
        self.bn3 = nn.BatchNorm2d(128)
        self.fc1 = nn.Linear(128 * 4 * 4, 256)
        self.fc2 = nn.Linear(256, num_classes)
        self.dropout = nn.Dropout(0.3)

    def forward(self, x):
        x = self.pool(F.relu(self.bn1(self.conv1(x))))
        x = self.pool(F.relu(self.bn2(self.conv2(x))))
        x = self.pool(F.relu(self.bn3(self.conv3(x))))
        x = x.view(x.size(0), -1)
        x = F.relu(self.fc1(x))
        x = self.dropout(x)
        x = self.fc2(x)
        return x

model = SimpleCNN(num_classes=10)
x = torch.randn(8, 3, 32, 32)  # batch=8, RGB=3, 32x32
print(f"Salida: {model(x).shape}")
```

## Ejemplo: Data augmentation para CNN

```python
from torchvision import transforms

transform_train = transforms.Compose([
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(15),
    transforms.ColorJitter(brightness=0.2, contrast=0.2),
    transforms.RandomResizedCrop(224, scale=(0.8, 1.0)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])

transform_test = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])
```

## Tecnologías principales

- **PyTorch**: torch.nn.Conv2d, torchvision.models (ResNet, VGG, EfficientNet, DenseNet).
- **TensorFlow/Keras**: tf.keras.layers.Conv2D, tf.keras.applications.
- **OpenCV**: Procesamiento clásico de imágenes.
- **Albumentations**: Data augmentation avanzado para visión.
- **Detectron2**: Detección de objetos y segmentación (Meta).
- **MMDetection**: Framework modular de detección de objetos.

## Hoja de ruta

1. Entender la operación de convolución 2D: kernel, stride, padding.
2. Implementar LeNet-5 desde cero con PyTorch para MNIST.
3. Profundizar con VGG: stacks de convoluciones 3×3.
4. ResNet: skip connections, Batch Normalization, atajos.
5. Transfer Learning con modelos pre-entrenados (ResNet, EfficientNet).
6. Detección de objetos: YOLO, Faster R-CNN.
7. Segmentación semántica: U-Net, FCN, DeepLab.

## Relaciones con otros módulos

- `../TransferLearning/`: Uso de CNN pre-entrenadas para nuevas tareas.
- `../ModelOptimization/`: Cuantización y pruning de CNN para despliegue.
- `../../032-MachineLearning/FeatureEngineering/`: CNN aprenden características automáticamente.
- `../../031-AI/Approaches/`: Conexionismo aplicado a percepción visual.

## Recursos recomendados

- **Curso**: "CS231n: CNNs for Visual Recognition" (Stanford) — El curso de referencia.
- **Paper**: "ImageNet Classification with Deep Convolutional Neural Networks" (AlexNet, 2012).
- **Paper**: "Deep Residual Learning for Image Recognition" (ResNet, 2015).
- **Libro**: "Deep Learning for Computer Vision" (Rajalingappaa Shanmugamani).
- **Repositorio**: pytorch/vision, awesome-computer-vision (GitHub).
