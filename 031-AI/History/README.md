# Historia de la Inteligencia Artificial (031-AI/History)

## Descripción del dominio

La historia de la Inteligencia Artificial abla desde las primeras concepciones filosóficas sobre máquinas pensantes en la antigüedad hasta los modelos fundacionales modernos. Este recorrido incluye periodos de gran optimismo (los "veranos de la IA") y crisis de financiamiento (los "inviernos de la IA"), cada uno marcado por avances teóricos, limitaciones tecnológicas y cambios de paradigma. Comprender esta historia es esencial para contextualizar los debates actuales sobre AGI, alineación y el impacto social de la IA.

## Línea del tiempo: hitos fundamentales

### Prehistoria (1940s–1955)

- **1943**: McCulloch & Pitts proponen el primer modelo matemático de neurona artificial.
- **1950**: Alan Turing publica "Computing Machinery and Intelligence" y propone el Test de Turing.
- **1951**: Marvin Minsky construye SNARC, la primera red neuronal con hardware.

### Nacimiento de la IA (1956–1969)

- **1956**: Dartmouth Conference — John McCarthy acuña el término "Artificial Intelligence". Participan Minsky, Shannon, Rochester, Newell y Simon.
- **1957**: Frank Rosenblatt inventa el Perceptrón (Mark I Perceptron).
- **1958**: McCarthy crea LISP, el lenguaje de programación dominante en IA por décadas.
- **1961**: Unimation instala el primer robot industrial (Unimate) en General Motors.
- **1964–1966**: Joseph Weizenbaum desarrolla ELIZA, el primer chatbot (simulación de psicoterapeuta).
- **1966**: Shakey el Robot combina visión, navegación y planificación (SRI).
- **1969**: Minsky & Papert publican "Perceptrons", demostrando las limitaciones de las redes de una sola capa.

### Primer Invierno de la IA (1970–1980)

- El reporte Lighthill (1973) en Reino Unido critica la IA por no cumplir promesas, causando recortes masivos de fondos.
- Reducción de financiamiento en EE.UU. (DARPA corta fondos).
- Avances en lógica y sistemas expertos sentaron las bases para el resurgimiento.

### Sistemas Expertos (1980–1987)

- **1980**: Digital Equipment Corporation despliega XCON/R1, el primer sistema experto comercial exitoso (configuración de ordenadores VAX).
- **1981**: Japón lanza el proyecto "Fifth Generation Computer" — inspira carrera global.
- **1986**: Rumelhart, Hinton & Williams popularizan backpropagation con el paper "Learning representations by back-propagating errors".
- **1987**: Comienza el auge de las redes neuronales conexionistas.

### Segundo Invierno de la IA (1987–1993)

- Colapso del mercado de hardware especializado (LISP machines).
- Los sistemas expertos muestran rigidez: frágiles, difíciles de mantener, sin capacidad de aprendizaje.
- Financiamiento se redirige a áreas más prácticas.

### Auge del Machine Learning (1993–2011)

- **1995**: Corinna Cortes y Vladimir Vapnik publican Support Vector Machines (SVM).
- **1997**: Deep Blue (IBM) derrota a Garry Kasparov en ajedrez.
- **1997**: LSTM (Hochreiter & Schmidhuber) — redes de memoria a largo plazo.
- **2004**: Primera edición de la DARPA Grand Challenge — vehículos autónomos en el desierto.
- **2006**: Geoffrey Hinton acuña "Deep Learning" y publica entrenamiento de DBNs.
- **2009**: ImageNet (Fei-Fei Li) — dataset masivo para visión. ImageNet Challenge impulsa la innovación en CNN.

### Revolución del Deep Learning (2012–presente)

- **2012**: AlexNet (Krizhevsky, Sutskever, Hinton) gana ImageNet por amplio margen usando GPU + ReLU + Dropout. Hito fundacional del deep learning moderno.
- **2014**: Goodfellow et al. publican Generative Adversarial Networks (GANs).
- **2014**: DeepMind publica DQN — aprendizaje por refuerzo profundo para jugar Atari.
- **2015**: ResNet (He et al.) introduce conexiones residuales, permitiendo redes con más de 100 capas.
- **2016**: AlphaGo (DeepMind) derrota a Lee Sedol, campeón mundial de Go.
- **2017**: Vaswani et al. publican "Attention Is All You Need" — nace el Transformer.
- **2018**: BERT (Google) establece nuevos estándares en 11 tareas de NLP.
- **2020**: GPT-3 (OpenAI) — 175 mil millones de parámetros, demostrando capacidades emergentes.
- **2021**: DALL-E y Stable Diffusion democratizan la generación de imágenes.
- **2022**: ChatGPT alcanza 100 millones de usuarios en 2 meses. Comienza la era de los LLMs comerciales.
- **2023**: GPT-4, Claude 3, Gemini, LLaMA — modelos multimodales, razonamiento mejorado.
- **2024–2026**: Modelos con contextos de millones de tokens, agentes autónomos, IA en dispositivos (on-device), regulaciones globales (EU AI Act).

## Escuelas de pensamiento históricas

| Escuela | Enfoque | Figuras clave | Auge |
|---------|---------|---------------|------|
| **Conexionismo** | Redes neuronales, aprendizaje desde datos | McCulloch, Rosenblatt, Hinton, LeCun | 1940s–1960s, resurgió 1980s y 2010s |
| **Simbolismo** | Lógica, representación simbólica, sistemas expertos | Newell, Simon, McCarthy, Minsky | 1950s–1980s |
| **Bayesianismo** | Inferencia probabilística, redes bayesianas | Pearl, Heckerman, Russell | 1980s–presente |
| **Evolutivo** | Algoritmos genéticos, programación genética | Holland, Koza, Fogel | 1960s–presente |
| **Analógico** | Razonamiento basado en casos (CBR) | Schank, Kolodner, Aamodt | 1980s–1990s |

## Lecciones aprendidas

1. **Efecto IA**: Una vez que una tecnología de IA madura y se vuelve útil, deja de llamarse "IA" (ej: reconocimiento óptico de caracteres, sistemas de recomendación).
2. **AI Winters vs Summers**: La sobrepromesa (hype) seguida de entrega insuficiente causa ciclos de auge y caída. La investigación rigurosa y las aplicaciones prácticas mitigan este riesgo.
3. **Escala importa**: El deep learning demostró que escalar datos, compute y parámetros produce mejoras cualitativas (leyes de escala, scaling laws).
4. **Interdisciplinariedad**: Los avances más importantes combinan matemáticas (optimización), estadística (inferencia), computación (hardware), neurociencia (inspiración biológica) y lingüística.

## Código: simulación de la evolución de arquitecturas

```python
import numpy as np

# Perceptrón clásico (1957) - Rosenblatt
class Perceptron:
    def __init__(self, n_inputs, lr=0.1):
        self.weights = np.zeros(n_inputs)
        self.bias = 0.0
        self.lr = lr

    def predict(self, X):
        raw = X @ self.weights + self.bias
        return np.where(raw >= 0, 1, 0)

    def fit(self, X, y, epochs=10):
        for _ in range(epochs):
            for xi, yi in zip(X, y):
                pred = self.predict(xi)
                error = yi - pred
                self.weights += self.lr * error * xi
                self.bias += self.lr * error

# Limitación: Perceptrón no resuelve XOR (demostrado Minsky & Papert, 1969)
X = np.array([[0,0],[0,1],[1,0],[1,1]])
y_and = np.array([0,0,0,1])
p = Perceptron(2)
p.fit(X, y_and, epochs=20)
print(f"AND: {p.predict(X)}")  # [0 0 0 1] ✓

# XOR falla (necesita capa oculta — backpropagation, 1986)
y_xor = np.array([0,1,1,0])
p.fit(X, y_xor, epochs=20)
print(f"XOR: {p.predict(X)}")  # Falla (soluciona con MLP)
```

```python
# MLP con backpropagation (Rumelhart, Hinton, Williams, 1986)
import numpy as np

def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def sigmoid_deriv(x):
    return x * (1 - x)

class MLP:
    def __init__(self, n_input, n_hidden, n_output):
        self.w1 = np.random.randn(n_input, n_hidden) * 0.1
        self.b1 = np.zeros(n_hidden)
        self.w2 = np.random.randn(n_hidden, n_output) * 0.1
        self.b2 = np.zeros(n_output)

    def forward(self, X):
        self.z1 = X @ self.w1 + self.b1
        self.a1 = sigmoid(self.z1)
        self.z2 = self.a1 @ self.w2 + self.b2
        self.a2 = sigmoid(self.z2)
        return self.a2

    def backward(self, X, y, lr=0.5):
        m = X.shape[0]
        dz2 = self.a2 - y.reshape(-1, 1)
        dw2 = self.a1.T @ dz2 / m
        db2 = dz2.sum(axis=0) / m
        da1 = dz2 @ self.w2.T
        dz1 = da1 * sigmoid_deriv(self.a1)
        dw1 = X.T @ dz1 / m
        db1 = dz1.sum(axis=0) / m
        self.w2 -= lr * dw2
        self.b2 -= lr * db2
        self.w1 -= lr * dw1
        self.b1 -= lr * db1

    def fit(self, X, y, epochs=2000):
        for _ in range(epochs):
            self.forward(X)
            self.backward(X, y)

# Ahora XOR se resuelve gracias a la capa oculta
X = np.array([[0,0],[0,1],[1,0],[1,1]])
y = np.array([[0],[1],[1],[0]])
mlp = MLP(2, 4, 1)
mlp.fit(X, y, 5000)
print(f"XOR con MLP: {np.round(mlp.forward(X).flatten())}")  # [0 1 1 0]
```

## Relaciones con otros módulos

- `../`: Conceptos generales de IA donde se enmarca la historia.
- `../Ethics/`: Cómo los errores históricos (sesgo en sistemas expertos) informan la ética actual.
- `../Safety/`: Lecciones históricas sobre riesgos de IA mal alineada.
- `../AGI/`: La historia del sueño de la IA general y sus desafíos recurrentes.
- `../../032-MachineLearning/`: Evolución del ML como pilar de la IA moderna.
- `../../033-DeepLearning/`: Revolución del deep learning (2012–presente).

## Recursos recomendados

- **Libro**: "Artificial Intelligence: A Modern Approach" (Russell & Norvig) — Capítulos históricos.
- **Libro**: "The Quest for Artificial Intelligence" (Nils Nilsson) — Historia completa y accesible.
- **Libro**: "AI 2041: Ten Visions for Our Future" (Kai-Fu Lee & Chen Qiufan).
- **Paper**: "Computing Machinery and Intelligence" (Turing, 1950).
- **Paper**: "Learning representations by back-propagating errors" (Rumelhart et al., 1986).
- **Paper**: "ImageNet Classification with Deep Convolutional Neural Networks" (AlexNet, 2012).
- **Paper**: "Attention Is All You Need" (Vaswani et al., 2017).
- **Documental**: "AlphaGo" (2017) — La partida contra Lee Sedol.
- **Archivo**: AI History Archives (stanford.edu/ai-history).
