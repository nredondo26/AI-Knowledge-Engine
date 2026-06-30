# Redes de Memoria Largo-Corto Plazo (LSTM)

## Descripción del dominio

Las redes LSTM (Long Short-Term Memory) son un tipo especial de Red Neuronal Recurrente diseñada para superar el problema del desvanecimiento del gradiente (vanishing gradient) que afecta a las RNN tradicionales. Introducidas por Hochreiter y Schmidhuber en 1997, las LSTM incorporan un mecanismo de compuertas (gates) que controlan el flujo de información: qué información recordar, qué olvidar y qué emitir como salida. Esto les permite capturar dependencias de largo plazo en secuencias, haciéndolas ideales para series temporales, reconocimiento de voz, traducción automática y generación de música. Las GRU (Gated Recurrent Units) son una variante simplificada con menos parámetros.

## Conceptos clave

- **Célula de Memoria (Cell State)**: Línea de transmisión horizontal que atraviesa toda la secuencia. La memoria a largo plazo de la red.
- **Estado Oculto (Hidden State)**: Salida de la LSTM en cada paso, usada para predicción y como entrada al siguiente paso.
- **Forget Gate**: Compuerta que decide qué información descartar del estado de célula. σ(W_f * [h_{t-1}, x_t] + b_f).
- **Input Gate**: Compuerta que decide qué nueva información almacenar en el estado de célula. σ(W_i * [h_{t-1}, x_t] + b_i).
- **Candidate Cell**: Nuevos valores candidatos para el estado de célula. tanh(W_c * [h_{t-1}, x_t] + b_c).
- **Output Gate**: Compuerta que decide qué partes del estado de célula emitir como salida. σ(W_o * [h_{t-1}, x_t] + b_o).
- **GRU (Gated Recurrent Unit)**: Variante con solo 2 compuertas (reset y update), sin estado de célula separado. Menos parámetros, rendimiento similar.

## Ejemplo: LSTM para predicción de series temporales

```python
import torch
import torch.nn as nn
import numpy as np

class LSTMPredictor(nn.Module):
    def __init__(self, input_dim, hidden_dim, num_layers, output_dim):
        super().__init__()
        self.lstm = nn.LSTM(input_dim, hidden_dim,
                            num_layers=num_layers, batch_first=True)
        self.fc = nn.Linear(hidden_dim, output_dim)

    def forward(self, x):
        # x: (batch, seq_len, input_dim)
        out, (hidden, cell) = self.lstm(x)
        # out: (batch, seq_len, hidden_dim)
        out = self.fc(out[:, -1, :])  # última salida temporal
        return out

# Datos sintéticos: sin(x) + ruido
seq_length = 50
x = np.sin(np.linspace(0, 100, 1000)) + np.random.normal(0, 0.1, 1000)

def create_sequences(data, seq_len):
    xs, ys = [], []
    for i in range(len(data) - seq_len):
        xs.append(data[i:i+seq_len])
        ys.append(data[i+seq_len])
    return torch.FloatTensor(xs).unsqueeze(-1), torch.FloatTensor(ys).unsqueeze(-1)

X, y = create_sequences(x, seq_length)
model = LSTMPredictor(input_dim=1, hidden_dim=64, num_layers=2, output_dim=1)
output = model(X[:4])
print(f"Input shape: {X[:4].shape}, Output shape: {output.shape}")
```

## Ejemplo: LSTM bidireccional para clasificación

```python
class BiLSTMClassifier(nn.Module):
    def __init__(self, vocab_size, embed_dim, hidden_dim, num_classes, num_layers=2):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.lstm = nn.LSTM(embed_dim, hidden_dim, num_layers,
                            batch_first=True, bidirectional=True)
        self.fc = nn.Linear(hidden_dim * 2, num_classes)
        self.dropout = nn.Dropout(0.3)

    def forward(self, x):
        x = self.embedding(x)
        out, (hidden, cell) = self.lstm(x)
        # Concatenar último hidden forward y backward
        hidden_fwd = hidden[-2, :, :]  # última capa, forward
        hidden_bwd = hidden[-1, :, :]  # última capa, backward
        concat = torch.cat((hidden_fwd, hidden_bwd), dim=1)
        return self.fc(self.dropout(concat))

model = BiLSTMClassifier(vocab_size=10000, embed_dim=128,
                         hidden_dim=128, num_classes=5)
x = torch.randint(0, 10000, (16, 50))
print(model(x).shape)
```

## Tecnologías principales

- **PyTorch**: torch.nn.LSTM, torch.nn.LSTMCell, torch.nn.GRU, torch.nn.GRUCell.
- **TensorFlow/Keras**: tf.keras.layers.LSTM, tf.keras.layers.GRU, tf.keras.layers.Bidirectional.
- **JAX/Flax**: flax.linen.LSTMCell, flax.linen.GRUCell.
- **Ventajas**: Captura dependencias largas, funciona en múltiples dominios secuenciales.
- **Limitaciones**: Más parámetros que RNN simple, más lento de entrenar, aun limitado para secuencias extremadamente largas.

## Hoja de ruta

1. Entender la arquitectura LSTM: cell state, forget gate, input gate, output gate.
2. Implementar LSTM desde cero con PyTorch (usando LSTMCell).
3. Entrenar LSTM para predicción de series temporales financieras o climáticas.
4. LSTM bidireccional para clasificación de texto.
5. Codificador-decodificador LSTM para traducción automática.
6. GRU como alternativa más ligera.
7. Atención + LSTM para mejorar dependencias muy largas.

## Relaciones con otros módulos

- `../RNN/`: LSTM como mejora sobre RNN básica.
- `../CNN/`: CNN + LSTM para video y secuencias de imágenes.
- `../../032-MachineLearning/ReinforcementLearning/`: Memoria recurrente en RL parcialmente observable.
- `../../034-LLM/`: LSTM superado por Transformers para NLP, pero aún relevante en series temporales.

## Recursos recomendados

- **Paper**: "Long Short-Term Memory" (Hochreiter & Schmidhuber, 1997) — El paper original.
- **Blog**: "Understanding LSTM Networks" (Christopher Olah) — Excelente explicación visual.
- **Curso**: "CS224n: NLP with Deep Learning" (Stanford) — Módulo de RNN y LSTM.
- **Documentación**: PyTorch LSTM docs, TensorFlow LSTM docs.
