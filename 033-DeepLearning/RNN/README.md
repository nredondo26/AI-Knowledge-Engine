# Redes Neuronales Recurrentes (RNN)

## Descripción del dominio

Las Redes Neuronales Recurrentes (RNN) son una familia de redes diseñadas para procesar datos secuenciales de longitud variable. A diferencia de las redes feedforward, las RNN mantienen un estado oculto que se actualiza en cada paso temporal, permitiendo capturar dependencias temporales en secuencias como texto, audio, series financieras o datos de sensores. La conexión recurrente crea una "memoria" que persiste a través del tiempo. Sin embargo, las RNN básicas sufren del problema de desvanecimiento/explosión del gradiente (vanishing/exploding gradient), lo que limita su capacidad para aprender dependencias de largo plazo.

## Conceptos clave

- **Estado Oculto (Hidden State)**: Vector que representa la memoria de la red en cada paso temporal. Se actualiza con cada nuevo input.
- **Célula Recurrente**: Unidad que combina el input actual con el estado oculto previo para producir el nuevo estado y la salida.
- **BPTT (Backpropagation Through Time)**: Algoritmo de entrenamiento que desenrolla la red en el tiempo y retropropaga el error a través de todos los pasos.
- **Vanishing Gradient**: Los gradientes se vuelven exponencialmente pequeños al retropropagar a través de muchos pasos, impidiendo aprender dependencias largas.
- **Exploding Gradient**: Los gradientes crecen exponencialmente, causando inestabilidad numérica. Mitigado con gradient clipping.
- **Many-to-Many**: Secuencia a secuencia (traducción automática, video frame labeling).
- **Many-to-One**: Secuencia a salida única (clasificación de sentimiento, predicción de serie temporal).
- **One-to-Many**: Entrada única a secuencia (generación de texto, descripción de imágenes).
- **RNN Bidireccional**: Dos RNN procesan la secuencia en direcciones opuestas, capturando contexto pasado y futuro.

## Ejemplo: RNN para clasificación de texto

```python
import torch
import torch.nn as nn

class SimpleRNN(nn.Module):
    def __init__(self, vocab_size, embed_dim, hidden_dim, num_classes):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.rnn = nn.RNN(embed_dim, hidden_dim, batch_first=True)
        self.fc = nn.Linear(hidden_dim, num_classes)

    def forward(self, x):
        # x: (batch, seq_len)
        x = self.embedding(x)           # (batch, seq_len, embed_dim)
        out, hidden = self.rnn(x)       # hidden: (1, batch, hidden_dim)
        return self.fc(hidden.squeeze(0))

# Uso
model = SimpleRNN(vocab_size=10000, embed_dim=128, hidden_dim=256, num_classes=5)
x = torch.randint(0, 10000, (16, 50))  # batch=16, seq_len=50
print(model(x).shape)
```

## Ejemplo: Generación de texto con RNN

```python
import torch
import torch.nn.functional as F

class CharRNN(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super().__init__()
        self.hidden_size = hidden_size
        self.rnn = nn.RNN(input_size, hidden_size, batch_first=True)
        self.fc = nn.Linear(hidden_size, output_size)

    def forward(self, x, hidden=None):
        out, hidden = self.rnn(x, hidden)
        out = self.fc(out)
        return out, hidden

    def generate(self, start_idx, length, device='cpu'):
        x = torch.tensor([[start_idx]], device=device)
        x = F.one_hot(x, num_classes=self.fc.out_features).float()
        hidden = None
        outputs = [start_idx]

        for _ in range(length):
            out, hidden = self.forward(x, hidden)
            probs = F.softmax(out[0, -1], dim=0)
            next_idx = torch.multinomial(probs, 1).item()
            outputs.append(next_idx)
            x = F.one_hot(torch.tensor([[next_idx]]),
                          num_classes=self.fc.out_features).float().to(device)

        return outputs
```

## Tecnologías principales

- **PyTorch**: torch.nn.RNN, torch.nn.RNNCell.
- **TensorFlow/Keras**: tf.keras.layers.SimpleRNN, tf.keras.layers.RNN.
- **JAX/Flax**: flax.linen.RNN.
- **Problemas**: Vanishing gradient, limited sequence length, difícil paralelización.

## Hoja de ruta

1. Entender el funcionamiento de la célula RNN y el estado oculto.
2. Implementar una RNN desde cero con PyTorch.
3. Entrenar una RNN para clasificación de sentimiento (IMDb).
4. Entrenar una RNN para generación de texto (Shakespeare).
5. Explorar gradient clipping para mitigar exploding gradients.
6. Comparar RNN unidireccional vs. bidireccional.
7. Entender las limitaciones que motivaron LSTM y GRU.

## Relaciones con otros módulos

- `../LSTM/`: Evolución de RNN que resuelve vanishing gradient.
- `../RNN/`: base conceptual; LSTM está aquí.
- `../../032-MachineLearning/ReinforcementLearning/`: RL con políticas recurrentes (POMDPs).
- `../../034-LLM/`: Transformers reemplazaron RNN como arquitectura principal para NLP.

## Recursos recomendados

- **Paper**: "Learning Representations by Back-Propagating Errors" (Rumelhart et al., 1986) — Origen de RNN.
- **Paper**: "Long Short-Term Memory" (Hochreiter & Schmidhuber, 1997) — LSTM.
- **Curso**: "CS224n: NLP with Deep Learning" (Stanford).
- **Blog**: "The Unreasonable Effectiveness of Recurrent Neural Networks" (Karpathy).
- **Documentación**: PyTorch RNN docs.
