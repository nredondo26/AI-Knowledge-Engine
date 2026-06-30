# Enfoques de IA (Approaches)

## Descripción del dominio

Los enfoques de Inteligencia Artificial representan las diferentes filosofías y metodologías para construir sistemas inteligentes. Históricamente han coexistido tres grandes corrientes: el conexionismo (redes neuronales), el simbolismo (lógica y representación) y el conductismo (agentes que actúan en entornos). Cada enfoque tiene fortalezas y limitaciones distintas, y la IA moderna tiende a integrar múltiples enfoques en sistemas híbridos.

## Enfoques principales

- **Conexionismo (Redes Neuronales)**: Modelos inspirados en el cerebro biológico. Aprenden representaciones a partir de datos mediante ajuste de pesos sinápticos. Incluye deep learning, transformers, CNNs. Es el enfoque dominante actualmente por su rendimiento en percepción y lenguaje.

- **Simbolismo (IA Simbólica)**: Representación explícita del conocimiento mediante símbolos y reglas lógicas. Sistemas expertos, razonamiento basado en casos, ontologías. Fuerte en razonamiento explícito, débil en percepción.

- **Conductismo (Agentes)**: Sistemas que aprenden mediante interacción con el entorno. Aprendizaje por refuerzo, planificación, búsqueda. Énfasis en acciones y recompensas más que en representaciones internas.

- **Bayesianismo**: Modelos probabilísticos que manejan incertidumbre de forma explícita. Redes bayesianas, procesos gaussianos, inferencia variacional.

- **Analogismo**: Aprendizaje basado en similitud con ejemplos previos. k-NN, SVM con kernels, case-based reasoning.

- **Evolucionario**: Algoritmos inspirados en evolución biológica. Algoritmos genéticos, programación genética, estrategias evolutivas.

## Ejemplo: Perceptrón (Conexionismo)

```python
import numpy as np

class Perceptron:
    def __init__(self, lr=0.01, epochs=50):
        self.lr = lr
        self.epochs = epochs
        self.weights = None
        self.bias = None

    def fit(self, X, y):
        n_samples, n_features = X.shape
        self.weights = np.zeros(n_features)
        self.bias = 0

        for _ in range(self.epochs):
            for idx, x_i in enumerate(X):
                linear = np.dot(x_i, self.weights) + self.bias
                y_pred = np.where(linear >= 0, 1, 0)
                update = self.lr * (y[idx] - y_pred)
                self.weights += update * x_i
                self.bias += update

    def predict(self, X):
        linear = np.dot(X, self.weights) + self.bias
        return np.where(linear >= 0, 1, 0)
```

## Ejemplo: Algoritmo Genético (Evolucionario)

```python
import random

def genetic_algorithm(fitness, n_generations=100, pop_size=50, mut_rate=0.01):
    n_genes = 10
    population = [[random.randint(0, 1) for _ in range(n_genes)]
                  for _ in range(pop_size)]

    for gen in range(n_generations):
        scores = [(fitness(ind), ind) for ind in population]
        scores.sort(reverse=True, key=lambda x: x[0])
        population = [ind for _, ind in scores[:pop_size // 2]]

        offspring = []
        while len(offspring) < pop_size:
            p1, p2 = random.sample(population, 2)
            split = random.randint(1, n_genes - 1)
            child = p1[:split] + p2[split:]
            child = [g if random.random() > mut_rate else 1 - g for g in child]
            offspring.append(child)
        population = offspring

    return max(population, key=fitness)

def example_fitness(individual):
    return sum(individual)
```

## Tecnologías principales

- **Conexionismo**: PyTorch, TensorFlow, JAX, Keras.
- **Simbolismo**: Prolog, CLIPS, Drools, OWL/RDF, GraphDB.
- **Bayesiano**: PyMC, Stan, pgmpy, Edward2.
- **Evolucionario**: DEAP, PyGAD, NEAT-Python.
- **Agentes**: Gymnasium, Ray RLlib, Stable-Baselines3.

## Hoja de ruta

1. Entender la taxonomía de enfoques de IA y sus fundamentos filosóficos.
2. Implementar un perceptrón desde cero (conexionismo).
3. Implementar un sistema experto simple con reglas if-then (simbolismo).
4. Implementar un algoritmo genético básico (evolucionario).
5. Explorar redes bayesianas con pgmpy (bayesianismo).
6. Comprender las fortalezas y debilidades de cada enfoque.
7. Estudiar sistemas híbridos que combinan múltiples enfoques.

## Relaciones con otros módulos

- `SymbolicAI/`: Profundización en el enfoque simbólico.
- `NeuroSymbolic/`: Integración de redes neuronales con razonamiento simbólico.
- `../../032-MachineLearning/ReinforcementLearning/`: Enfoque conductista.
- `../../033-DeepLearning/`: Enfoque conexionista moderno.

## Recursos recomendados

- **Libro**: "Artificial Intelligence: A Modern Approach" (Russell, Norvig) — Cobertura completa de todos los enfoques.
- **Paper**: "Deep Learning" (LeCun, Bengio, Hinton, 2015) — Manifiesto conexionista.
- **Paper**: "Computing Machinery and Intelligence" (Turing, 1950).
- **Repositorio**: awesome-artificial-intelligence (GitHub).
