# Optimización de Modelos (ModelOptimization)

## Descripción del dominio

La Optimización de Modelos comprende un conjunto de técnicas para reducir el tamaño y los requisitos computacionales de modelos de deep learning sin sacrificar significativamente su precisión. Estas técnicas son esenciales para el despliegue de modelos en entornos con recursos limitados: dispositivos móviles, navegadores web, sistemas embebidos y servidores con restricciones de latencia o memoria. Las principales áreas incluyen cuantización, pruning (poda), destilación de conocimiento y optimización de arquitectura.

## Técnicas principales

- **Cuantización (Quantization)**: Reducir la precisión numérica de los pesos y activaciones del modelo. FP32 → FP16 (mitad de memoria), FP32 → INT8 (cuarto de memoria), FP32 → INT4 (octavo). Técnicas: Post-Training Quantization (PTQ), Quantization-Aware Training (QAT).
- **Pruning (Poda)**: Eliminar parámetros redundantes del modelo. Pruning estructurado (canales enteros, capas) vs. no estructurado (pesos individuales). Magnitude pruning, movement pruning.
- **Destilación de Conocimiento (Knowledge Distillation)**: Entrenar un modelo pequeño (student) para imitar las salidas de un modelo grande (teacher). La función de pérdida combina la pérdida con etiquetas reales y la pérdida con las salidas del teacher (soft targets).
- **Factorización de Matrices**: Descomponer matrices de pesos grandes en factores de menor rango. SVD, CP-decomposition.
- **Model Soup**: Promedio de los pesos de múltiples modelos fine-tuned para mejorar generalización sin costo de inferencia adicional.
- **Compilación**: Optimización del grafo computacional para inferencia. TorchScript, TensorRT, ONNX Runtime, XLA.

## Ejemplo: Cuantización con PyTorch

```python
import torch
import torch.quantization as quant
import torchvision.models as models

model_fp32 = models.resnet18(weights=models.ResNet18_Weights.IMAGENET1K_V1)
model_fp32.eval()

# Cuantización post-entrenamiento (PTQ)
model_fp32.qconfig = quant.get_default_qconfig('fbgemm')
model_prepared = quant.prepare(model_fp32, inplace=False)
model_quantized = quant.convert(model_prepared, inplace=False)

# Comparar tamaños
param_size_fp32 = sum(p.numel() * 4 for p in model_fp32.parameters())
param_size_int8 = sum(p.numel() * 1 for p in model_quantized.parameters())
print(f"Tamaño FP32: {param_size_fp32 / 1e6:.2f} MB")
print(f"Tamaño INT8: {param_size_int8 / 1e6:.2f} MB")
print(f"Reducción: {param_size_int8 / param_size_fp32 * 100:.1f}%")
```

## Ejemplo: Pruning con PyTorch

```python
import torch.nn.utils.prune as prune
import torch.nn as nn

model = models.resnet18(weights=models.ResNet18_Weights.IMAGENET1K_V1)

# Pruning no estructurado: eliminar 30% de pesos en capas Conv2d
for name, module in model.named_modules():
    if isinstance(module, nn.Conv2d):
        prune.l1_unstructured(module, name='weight', amount=0.3)

# Hacer el pruning permanente
for name, module in model.named_modules():
    if isinstance(module, nn.Conv2d):
        prune.remove(module, 'weight')

# Pruning estructurado (canales)
for name, module in model.named_modules():
    if isinstance(module, nn.Conv2d):
        prune.ln_structured(module, name='weight', amount=0.2, n=2, dim=0)
```

## Ejemplo: Destilación de conocimiento

```python
import torch.nn.functional as F

def distillation_loss(student_logits, teacher_logits, labels, T=4.0, alpha=0.7):
    """Pérdida combinada para destilación de conocimiento."""
    # Soft targets del teacher
    soft_teacher = F.softmax(teacher_logits / T, dim=1)
    soft_student = F.log_softmax(student_logits / T, dim=1)

    # KL divergence entre salidas suavizadas
    kd_loss = F.kl_div(soft_student, soft_teacher, reduction='batchmean') * (T ** 2)

    # Pérdida estándar con etiquetas reales
    ce_loss = F.cross_entropy(student_logits, labels)

    return alpha * ce_loss + (1 - alpha) * kd_loss

# Uso durante el entrenamiento:
# for x, y in dataloader:
#     teacher_logits = teacher_model(x)
#     student_logits = student_model(x)
#     loss = distillation_loss(student_logits, teacher_logits, y)
#     loss.backward()
#     optimizer.step()
```

## Tecnologías principales

- **PyTorch**: torch.quantization, torch.prune, torch.jit, torch.onnx.
- **TensorFlow**: TF Lite (cuantización, delegación GPU), TF Model Optimization Toolkit.
- **TensorRT**: Optimización de NVIDIA para GPUs (INT8, FP16, kernel fusion).
- **ONNX Runtime**: Inferencia optimizada multiplataforma.
- **DeepSpeed**: ZeRO optimization, mixed precision training.
- **Apache TVM**: Compilación de modelos para múltiples backends (CPU, GPU, aceleradores).
- **Hugging Face Optimum**: Optimización de modelos transformers (cuantización, pruning).

## Hoja de ruta

1. Cuantización post-entrenamiento (PTQ) con PyTorch.
2. Cuantización consciente del entrenamiento (QAT).
3. Pruning no estructurado y estructurado con PyTorch.
4. Destilación de conocimiento: teacher-student para clasificación.
5. Compilación con ONNX Runtime y TensorRT.
6. TinyML: modelos para microcontroladores (TFLite Micro).
7. Optimización de LLMs: GPTQ, AWQ, GGUF.

## Relaciones con otros módulos

- `../TransferLearning/`: Modelos transferidos a menudo requieren optimización para despliegue.
- `../CNN/`: CNNs optimizadas para visión en dispositivos móviles.
- `../GANs/`: GANs comprimidas para generación en tiempo real.
- `../../034-LLM/`: Cuantización de LLMs para inferencia local (GPTQ, AWQ, GGUF).

## Recursos recomendados

- **Documentación**: PyTorch Quantization docs, TensorFlow Lite docs.
- **Paper**: "Quantization and Training of Neural Networks for Efficient Integer-Arithmetic-Only Inference" (Jacob et al., 2017).
- **Paper**: "Distilling the Knowledge in a Neural Network" (Hinton et al., 2015).
- **Curso**: "Efficient ML" (MIT) — TinyML and Efficient Deep Learning.
- **Repositorio**: pytorch/examples/quantization, awesome-model-compression (GitHub).
