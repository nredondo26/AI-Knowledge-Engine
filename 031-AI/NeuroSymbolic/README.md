# IA Neurosimbólica (NeuroSymbolic)

## Descripción del dominio

La IA Neurosimbólica busca integrar las fortalezas de las redes neuronales (aprendizaje de patrones a partir de datos, tolerancia al ruido, rendimiento en percepción) con las de la IA simbólica (razonamiento explícito, generalización composicional, interpretabilidad, uso de conocimiento previo). Esta integración promete sistemas que aprenden de datos pero también razonan de manera transparente, combinando lo mejor de ambos paradigmas.

## Conceptos clave

- **Razonamiento Neuronal**: Redes entrenadas para realizar inferencias lógicas o simbólicas directamente desde datos.
- **Diferenciación Simbólica**: Incorporar operaciones simbólicas (ej: ejecución de reglas) dentro de grafos computacionales diferenciables.
- **Programación Diferenciable**: Lenguajes de programación donde las operaciones simbólicas se integran en pipelines diferenciables (DSP, DeepProbLog).
- **Inyección de Conocimiento**: Incorporar conocimiento previo (ontologías, reglas) como restricciones o regularizadores en redes neuronales.
- **Aprendizaje Relacional**: Redes que aprenden relaciones entre entidades, similar a lógica de primer orden (Graph Neural Networks, Relational Networks).
- **Conceptos y Composicionalidad**: Aprender conceptos discretos y combinarlos composicionalmente, como hace el razonamiento humano.
- **Percepción + Razonamiento**: Pipeline donde una red neuronal procesa entradas sensoriales (imágenes, texto) y un módulo simbólico razona sobre las representaciones extraídas.

## Ejemplo: Inyección de conocimiento como restricción

```python
import torch
import torch.nn as nn
import torch.optim as optim

class RedConRestriccion(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super().__init__()
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.fc2 = nn.Linear(hidden_size, output_size)

    def forward(self, x):
        h = torch.relu(self.fc1(x))
        return torch.softmax(self.fc2(h), dim=1)

def loss_func(y_pred, y_true, alpha=0.1):
    ce = nn.CrossEntropyLoss()(y_pred, y_true)
    # Restricción simbólica: penalizar predicciones inconsistentes
    # Por ejemplo: si clase A y B no pueden coexistir
    prob_a = y_pred[:, 0]
    prob_b = y_pred[:, 1]
    restriccion = torch.mean(torch.relu(prob_a + prob_b - 0.9))
    return ce + alpha * restriccion
```

## Ejemplo: DeepProbLog básico

```python
# Pseudocódigo conceptual de DeepProbLog
# DeepProbLog integra programas lógicos probabilísticos con redes neuronales
from deepproblog.examples.MNIST.data import MNIST
from deepproblog.engine import InferenceEngine

# Definir hechos probabilísticos desde redes neuronales
# nn(mnist_net, [X], Y, [0..9])  -- red neuronal clasifica dígitos
# Reglas lógicas sobre los dígitos para tareas como suma

# Programa lógico:
# adicion(X, Y, Z) :- nn(digit, [X], A), nn(digit, [Y], B), Z is A + B
# Consulta: adicion([img1, img2], 7) -- probable?
```

## Tecnologías principales

- **DeepProbLog**: Integración de Prolog probabilístico con PyTorch.
- **Pyro / NumPyro**: Programación probabilística con integración simbólica.
- **Scallop**: Framework neuro-simbólico con razonamiento diferenciable.
- **NeuroLog**: Razonamiento lógico en PyTorch.
- **Graph Neural Networks**: Para aprendizaje relacional (PyTorch Geometric, DGL).

## Hoja de ruta

1. Fundamentos de IA simbólica (lógica, reglas, ontologías).
2. Fundamentos de redes neuronales (PyTorch).
3. Estudiar DeepProbLog: programas lógicos con predicciones neuronales.
4. Inyección de conocimiento: restricciones lógicas como pérdida auxiliar.
5. Graph Neural Networks para razonamiento relacional.
6. Programación diferenciable con Scallop o NeuroLog.
7. Aplicaciones: VQA (visual question answering), razonamiento sobre imágenes.

## Relaciones con otros módulos

- `../Approaches/`: Integración de enfoques conexionista y simbólico.
- `../SymbolicAI/`: Base de la IA simbólica que se integra con redes neuronales.
- `../../033-DeepLearning/`: Redes neuronales como componente perceptual.
- `../../058-KnowledgeGraph/`: Grafos de conocimiento como interfaz simbólica.
- `../../040-Reasoning/`: Razonamiento avanzado con componentes neuronales.

## Recursos recomendados

- **Paper**: "DeepProbLog: Neural Probabilistic Logic Programming" (Manhaeve et al., 2018).
- **Paper**: "Neuro-Symbolic AI: An Emerging New Generation of AI" (Garcez et al., 2020).
- **Paper**: "The Neuro-Symbolic Concept Learner" (Mao et al., 2019).
- **Curso**: "Neuro-Symbolic AI" (TU Darmstadt / YouTube).
- **Repositorio**: awesome-neurosymbolic (GitHub).
