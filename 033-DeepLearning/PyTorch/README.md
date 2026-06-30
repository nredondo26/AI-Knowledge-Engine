# PyTorch (033-DeepLearning/PyTorch)

## Descripcion del dominio

PyTorch es un framework de deep learning desarrollado por Meta AI (Facebook Research), lanzado en 2016. Se ha convertido en el framework dominante en investigacion academica y la opcion preferida para trabajo de vanguardia en NLP, vision, generacion de contenido y aprendizaje por refuerzo. Su diseño se basa en tres principios: computacion con tensores dinamicos (define-by-run), diferenciacion automatica con `autograd`, y una API Pythonic que se siente natural para desarrolladores Python. El ecosistema incluye torchvision, torchaudio, torchtext, PyTorch Lightning, Hugging Face Transformers (con backend PyTorch), TorchScript, TorchServe y TorchDynamo.

## Ecosistema PyTorch

| Componente | Proposito | Comando |
|------------|-----------|---------|
| **PyTorch Core** | Tensores, autograd, nn.Module, optimizadores | `torch.*` |
| **torchvision** | Datasets, modelos pre-entrenados, transformaciones de imagenes | `torchvision.*` |
| **torchaudio** | Procesamiento de audio y señales | `torchaudio.*` |
| **torchtext** | Utilidades para NLP (deprecada, migrar a Hugging Face) | `torchtext.*` |
| **PyTorch Lightning** | Abstraccion de entrenamiento (reducir boilerplate) | `lightning.pytorch.*` |
| **TorchScript** | Serializacion y despliegue sin dependencia Python | `torch.jit.*` |
| **TorchServe** | Servicio de modelos en produccion | `torchserve` |
| **TorchDynamo** | Compilacion JIT (graph capture) para aceleracion | `torch.compile` |
| **torch.distributed** | Entrenamiento distribuido (DDP, FSDP, RPC) | `torch.distributed.*` |
| **TorchFX** | Transformacion de grafos de modulos | `torch.fx.*` |
| **TorchAO** | Optimizacion de arquitectura: cuantizacion, pruning | `torch.ao.*` |

## Fundamentos: tensores y autograd

```python
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import numpy as np

# Tensores: similar a NumPy pero con GPU acceleration
x = torch.tensor([[1, 2], [3, 4]], dtype=torch.float32)
y = torch.tensor([[5, 6], [7, 8]], dtype=torch.float32)

print(f"Tensor en CPU: {x.device}")
print(f"Suma: {x + y}")
print(f"Producto elemento: {x * y}")
print(f"Producto matricial: {x @ y}")

# GPU si esta disponible
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
x_gpu = x.to(device)
print(f"Tensor en: {x_gpu.device}")

# Diferenciacion automatica con autograd
x_var = torch.tensor(3.0, requires_grad=True)
y_var = x_var ** 3 + 2 * x_var ** 2 + 5
y_var.backward()
print(f"dy/dx en x=3: {x_var.grad.item()}")  # 39

# Gradiente de una funcion vectorial
x = torch.randn(3, requires_grad=True)
y = x.pow(2).sum()
y.backward()
print(f"Gradiente: {x.grad}")  # 2*x
```

## Construccion de modelos: nn.Module

### 1. MLP basico para clasificacion

```python
class MLP(nn.Module):
    """Perceptron multicapa con dropout y batch normalization"""
    def __init__(self, input_dim=784, hidden_dims=[512, 256], num_classes=10, dropout=0.3):
        super().__init__()
        layers = []
        prev_dim = input_dim
        for h_dim in hidden_dims:
            layers.extend([
                nn.Linear(prev_dim, h_dim),
                nn.BatchNorm1d(h_dim),
                nn.ReLU(inplace=True),
                nn.Dropout(dropout)
            ])
            prev_dim = h_dim
        layers.append(nn.Linear(prev_dim, num_classes))
        self.network = nn.Sequential(*layers)

    def forward(self, x):
        return self.network(x)

model = MLP(input_dim=784, num_classes=10)
print(f"Total params: {sum(p.numel() for p in model.parameters()):,}")
print(f"Trainable params: {sum(p.numel() for p in model.parameters() if p.requires_grad):,}")

x_batch = torch.randn(32, 784)
output = model(x_batch)
print(f"Output shape: {output.shape}")
```

### 2. CNN para clasificacion de imagenes

```python
class CNN(nn.Module):
    """Red convolucional para CIFAR-10 (3x32x32 a 10 clases)"""
    def __init__(self, num_classes=10):
        super().__init__()
        self.features = nn.Sequential(
            nn.Conv2d(3, 32, kernel_size=3, padding=1),
            nn.BatchNorm2d(32),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(2),

            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.BatchNorm2d(64),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(2),

            nn.Conv2d(64, 128, kernel_size=3, padding=1),
            nn.BatchNorm2d(128),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(2),
        )
        self.classifier = nn.Sequential(
            nn.Dropout(0.4),
            nn.Linear(128 * 4 * 4, 256),
            nn.ReLU(inplace=True),
            nn.Dropout(0.3),
            nn.Linear(256, num_classes)
        )

    def forward(self, x):
        x = self.features(x)
        x = x.view(x.size(0), -1)
        x = self.classifier(x)
        return x
```

### 3. Transformer desde cero

```python
class MultiHeadAttention(nn.Module):
    def __init__(self, d_model, n_heads):
        super().__init__()
        assert d_model % n_heads == 0
        self.d_k = d_model // n_heads
        self.n_heads = n_heads
        self.w_q = nn.Linear(d_model, d_model)
        self.w_k = nn.Linear(d_model, d_model)
        self.w_v = nn.Linear(d_model, d_model)
        self.w_o = nn.Linear(d_model, d_model)

    def forward(self, x, mask=None):
        B, T, D = x.shape
        Q = self.w_q(x).view(B, T, self.n_heads, self.d_k).transpose(1, 2)
        K = self.w_k(x).view(B, T, self.n_heads, self.d_k).transpose(1, 2)
        V = self.w_v(x).view(B, T, self.n_heads, self.d_k).transpose(1, 2)

        scores = Q @ K.transpose(-2, -1) / (self.d_k ** 0.5)
        if mask is not None:
            scores = scores.masked_fill(mask == 0, float("-inf"))
        attn = F.softmax(scores, dim=-1)
        out = (attn @ V).transpose(1, 2).contiguous().view(B, T, D)
        return self.w_o(out)

class TransformerEncoder(nn.Module):
    def __init__(self, d_model=512, n_heads=8, d_ff=2048, dropout=0.1):
        super().__init__()
        self.attention = MultiHeadAttention(d_model, n_heads)
        self.norm1 = nn.LayerNorm(d_model)
        self.norm2 = nn.LayerNorm(d_model)
        self.ffn = nn.Sequential(
            nn.Linear(d_model, d_ff),
            nn.ReLU(),
            nn.Dropout(dropout),
            nn.Linear(d_ff, d_model),
            nn.Dropout(dropout)
        )
        self.dropout = nn.Dropout(dropout)

    def forward(self, x, mask=None):
        x = x + self.dropout(self.attention(self.norm1(x), mask))
        x = x + self.dropout(self.ffn(self.norm2(x)))
        return x
```

## Ciclo de entrenamiento completo

```python
from torch.utils.data import DataLoader
from torchvision import datasets, transforms

transform = transforms.Compose([
    transforms.RandomCrop(32, padding=4),
    transforms.RandomHorizontalFlip(),
    transforms.ToTensor(),
    transforms.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010))
])

train_dataset = datasets.CIFAR10(root="./data", train=True, download=True, transform=transform)
test_dataset = datasets.CIFAR10(root="./data", train=False, transform=transform)

train_loader = DataLoader(train_dataset, batch_size=128, shuffle=True, num_workers=4,
                          pin_memory=True)
test_loader = DataLoader(test_dataset, batch_size=256, shuffle=False, num_workers=4,
                         pin_memory=True)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = CNN(num_classes=10).to(device)
criterion = nn.CrossEntropyLoss()
optimizer = optim.AdamW(model.parameters(), lr=1e-3, weight_decay=5e-4)
scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=100)

def train_epoch(model, loader, optimizer, criterion):
    model.train()
    total_loss = 0.0
    correct = 0
    total = 0
    for images, labels in loader:
        images, labels = images.to(device), labels.to(device)
        optimizer.zero_grad(set_to_none=True)
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
        optimizer.step()
        total_loss += loss.item() * images.size(0)
        _, preds = outputs.max(1)
        correct += preds.eq(labels).sum().item()
        total += labels.size(0)
    return total_loss / total, correct / total

def evaluate(model, loader, criterion):
    model.eval()
    total_loss = 0.0
    correct = 0
    total = 0
    with torch.no_grad():
        for images, labels in loader:
            images, labels = images.to(device), labels.to(device)
            outputs = model(images)
            loss = criterion(outputs, labels)
            total_loss += loss.item() * images.size(0)
            _, preds = outputs.max(1)
            correct += preds.eq(labels).sum().item()
            total += labels.size(0)
    return total_loss / total, correct / total

for epoch in range(50):
    train_loss, train_acc = train_epoch(model, train_loader, optimizer, criterion)
    test_loss, test_acc = evaluate(model, test_loader, criterion)
    scheduler.step()
    if (epoch + 1) % 10 == 0:
        print(f"Epoch {epoch+1:2d} | Train Loss: {train_loss:.4f} Acc: {train_acc:.4f} | "
              f"Test Loss: {test_loss:.4f} Acc: {test_acc:.4f}")
```

## Entrenamiento distribuido con DDP

```python
# Lanzar con: torchrun --nproc_per_node=4 train_ddp.py
import torch.distributed as dist
import torch.multiprocessing as mp
from torch.nn.parallel import DistributedDataParallel

def setup_ddp(rank, world_size):
    dist.init_process_group("nccl", rank=rank, world_size=world_size)
    torch.cuda.set_device(rank)

def train_ddp(rank, world_size):
    setup_ddp(rank, world_size)
    model = CNN().to(rank)
    model = DistributedDataParallel(model, device_ids=[rank])
    dataloader = DataLoader(train_dataset, batch_size=128, shuffle=True,
                            sampler=DistributedSampler(train_dataset, num_replicas=world_size,
                                                       rank=rank))
    optimizer = optim.AdamW(model.parameters(), lr=1e-3 * world_size)
    for epoch in range(10):
        dataloader.sampler.set_epoch(epoch)
        train_epoch(model, dataloader, optimizer, criterion)
    dist.destroy_process_group()

if __name__ == "__main__":
    world_size = torch.cuda.device_count()
    mp.spawn(train_ddp, args=(world_size,), nprocs=world_size)
```

## Mixed Precision Training

```python
from torch.cuda.amp import autocast, GradScaler

scaler = GradScaler()
model = CNN().to(device)
optimizer = optim.AdamW(model.parameters(), lr=1e-3)

for images, labels in train_loader:
    images, labels = images.to(device), labels.to(device)
    optimizer.zero_grad(set_to_none=True)
    with autocast():
        outputs = model(images)
        loss = criterion(outputs, labels)
    scaler.scale(loss).backward()
    scaler.step(optimizer)
    scaler.update()
```

## Compilacion con torch.compile (TorchDynamo)

```python
# Aceleracion JIT: captura el grafo y lo optimiza
model = CNN().to(device)
model_compiled = torch.compile(model, mode="reduce-overhead")
# mode: "default", "reduce-overhead", "max-autotune"

# Uso identico al original
output = model_compiled(images)
```

## Exportacion y despliegue (TorchScript / ONNX)

```python
# TorchScript: serializacion para produccion
model.eval()
example_input = torch.randn(1, 3, 32, 32).to(device)
# Tracing
traced_model = torch.jit.trace(model, example_input)
traced_model.save("model_cifar.pt")

# ONNX: interoperabilidad entre frameworks
torch.onnx.export(
    model, example_input, "model_cifar.onnx",
    input_names=["input"], output_names=["output"],
    dynamic_axes={"input": {0: "batch_size"}, "output": {0: "batch_size"}},
    opset_version=17
)
```

## PyTorch Lightning: boilerplate reducido

```python
import lightning as L

class LitCNN(L.LightningModule):
    def __init__(self, lr=1e-3):
        super().__init__()
        self.model = CNN()
        self.lr = lr
        self.save_hyperparameters()

    def training_step(self, batch, batch_idx):
        images, labels = batch
        outputs = self.model(images)
        loss = F.cross_entropy(outputs, labels)
        acc = (outputs.argmax(1) == labels).float().mean()
        self.log("train_loss", loss, prog_bar=True)
        self.log("train_acc", acc, prog_bar=True)
        return loss

    def validation_step(self, batch, batch_idx):
        images, labels = batch
        outputs = self.model(images)
        loss = F.cross_entropy(outputs, labels)
        acc = (outputs.argmax(1) == labels).float().mean()
        self.log("val_loss", loss, prog_bar=True)
        self.log("val_acc", acc, prog_bar=True)

    def configure_optimizers(self):
        opt = optim.AdamW(self.model.parameters(), lr=self.lr, weight_decay=5e-4)
        sched = optim.lr_scheduler.CosineAnnealingLR(opt, T_max=100)
        return [opt], [sched]

trainer = L.Trainer(max_epochs=50, accelerator="auto", devices="auto",
                    callbacks=[L.pytorch.callbacks.ModelCheckpoint(monitor="val_acc", mode="max")])
model_lightning = LitCNN()
trainer.fit(model_lightning, train_loader, test_loader)
```

## Buenas practicas

1. **Usar `pin_memory=True` en DataLoader** para transferencia mas rapida CPU-GPU.
2. **Preferir `optimizer.zero_grad(set_to_none=True)`** sobre `zero_grad()` (menos memoria).
3. **Gradient clipping**: `nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)` para estabilidad.
4. **Mixed precision** con `GradScaler` + `autocast` para 2-3x de aceleracion en GPUs modernas.
5. **`torch.compile()`** para aceleracion JIT sin cambios de codigo.
6. **DataLoader con `num_workers=4`** (o mas) para paralelizar carga de datos.
7. **Seed todo** para reproducibilidad: `torch.manual_seed(42)`, `np.random.seed(42)`.
8. **Usar `with torch.no_grad():`** en evaluacion para deshabilitar autograd.
9. **Checkpointing**: Guardar solo `model.state_dict()` + `optimizer.state_dict()` + epoch.

## Relaciones con otros modulos

- `../TensorFlow/`: Framework alternativo; diferencias en API, rendimiento, ecosistema.
- `../CNN/`: Redes convolucionales implementadas con PyTorch.
- `../RNN/`: Redes recurrentes y LSTMs con PyTorch.
- `../Transformers/`: Implementacion de transformers con PyTorch/Hugging Face.
- `../ModelOptimization/`: Cuantizacion, pruning, distillation con PyTorch.
- `../JAX/`: Framework alternativo de Google Research, creciente en investigacion.
- `../../032-MachineLearning/ScikitLearn/`: Preprocesamiento combinado con modelos PyTorch.
- `../../034-LLM/`: LLMs con PyTorch (LLaMA, Mistral, GPT).

## Recursos recomendados

- **Documentacion**: https://pytorch.org/docs/stable/ -- API completa y tutoriales.
- **Libro**: "Deep Learning with PyTorch" (Stevens, Antiga, Viehmann) -- Manning Publications.
- **Libro**: "Programming PyTorch for Deep Learning" (Ian Pointer) -- O'Reilly.
- **Curso**: "PyTorch for Deep Learning" (freeCodeCamp / Daniel Bourke) -- YouTube.
- **Curso**: "Practical Deep Learning for Coders" (fast.ai) -- Basado en PyTorch.
- **Paper**: "PyTorch: An Imperative Style, High-Performance Deep Learning Library" (Paszke et al., 2019).
- **Repositorio**: https://github.com/pytorch/pytorch -- Codigo fuente.
- **Repositorio**: https://github.com/pytorch/examples -- Ejemplos oficiales.
- **Repositorio**: https://github.com/huggingface/transformers -- Modelos pre-entrenados con PyTorch.
