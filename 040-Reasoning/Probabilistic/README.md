# Razonamiento Probabilístico en IA

## Descripción del dominio

El razonamiento probabilístico permite a los sistemas de IA tomar decisiones y hacer inferencias en condiciones de incertidumbre. Utiliza la teoría de probabilidades para representar el conocimiento incierto, actualizar creencias con nueva evidencia y calcular la probabilidad de eventos o hipótesis. Es fundamental en campos como diagnóstico médico, predicción del tiempo, procesamiento del lenguaje natural, visión por computadora, robótica (SLAM), filtrado de información y sistemas de recomendación.

## Áreas clave

- **Teorema de Bayes**: P(A|B) = P(B|A) P(A) / P(B). Base del aprendizaje automático probabilístico. Probabilidad a priori, likelihood, evidencia, probabilidad a posteriori
- **Redes Bayesianas (Bayesian Networks)**: DAG (Directed Acyclic Graph) donde nodos = variables aleatorias, aristas = dependencias condicionales. Tablas de probabilidad condicional (CPT). Inferencia exacta (variable elimination, junction tree) y aproximada (MCMC, importance sampling, loopy belief propagation)
- **Inferencia por muestreo (MCMC)**: Markov Chain Monte Carlo. Metropolis-Hastings, Gibbs sampling, Hamiltonian Monte Carlo (HMC), NUTS. Aproximación de distribuciones complejas mediante muestras
- **Modelos gráficos probabilísticos (PGMs)**: Redes Bayesianas (dirigidas) vs Markov Random Fields (MRF, no dirigidas). Modelos discriminativos (CRF = Conditional Random Fields) vs generativos (Naive Bayes, HMM)
- **Cadenas de Markov Ocultas (HMM)**: Secuencias de estados ocultos con observaciones. Problemas: evaluación (forward), decodificación (Viterbi), aprendizaje (Baum-Welch). Aplicaciones: reconocimiento de voz, POS tagging, bioinformática
- **Procesos de Decisión de Markov (MDP)**: Marco para toma de decisiones secuenciales con incertidumbre. Estados, acciones, transiciones (probabilísticas), recompensas. POMDP (MDP parcialmente observable)
- **Estimación máxima a posteriori (MAP)**: Encuentra la hipótesis más probable dado los datos. Relacionado con Maximum Likelihood (MLE) cuando no hay prior
- **Inferencia variacional (VI)**: Aproxima distribuciones posteriores complejas con familias paramétricas simples optimizando ELBO (Evidence Lower Bound). Escalable a grandes datos. Pyro, Stan, TensorFlow Probability
- **Filtrado y predicción**: Filtro de Kalman (sistemas lineales Gaussianos), Filtro de Partículas (Particle Filter, no lineal/no Gaussiano). Localización y tracking en robótica y visión

## Ejemplo: Red Bayesiana con pgmpy

```python
from pgmpy.models import BayesianNetwork
from pgmpy.factors.discrete import TabularCPD
from pgmpy.inference import VariableElimination

# Red: Clima -> Aspersor, Clima -> Lluvia, Aspersor -> HierbaMojada, Lluvia -> HierbaMojada
model = BayesianNetwork([('C', 'A'), ('C', 'L'), ('A', 'H'), ('L', 'H')])

cpd_c = TabularCPD('C', 2, [[0.5], [0.5]])           # P(C=luvia)=0.5, P(C=seco)=0.5
cpd_a = TabularCPD('A', 2, [[0.9, 0.2], [0.1, 0.8]], evidence=['C'], evidence_card=[2])
cpd_l = TabularCPD('L', 2, [[0.2, 0.8], [0.8, 0.2]], evidence=['C'], evidence_card=[2])
cpd_h = TabularCPD('H', 2, [[1, 0.1, 0.1, 0.01], [0, 0.9, 0.9, 0.99]],
                    evidence=['A', 'L'], evidence_card=[2, 2])

model.add_cpds(cpd_c, cpd_a, cpd_l, cpd_h)
model.check_model()

# Inferencia
infer = VariableElimination(model)
posterior = infer.query(['C'], evidence={'H': 1})  # P(Clima | HierbaMojada=si)
print(posterior)
```

## Ejemplo: Filtro de Kalman simple

```python
import numpy as np

class KalmanFilter:
    def __init__(self, A, H, Q, R):
        self.A = A  # Matriz de transición de estado
        self.H = H  # Matriz de observación
        self.Q = Q  # Covarianza del ruido del proceso
        self.R = R  # Covarianza del ruido de medición
        self.x = np.zeros((A.shape[0], 1))  # Estado estimado
        self.P = np.eye(A.shape[0])         # Covarianza del error

    def predict(self):
        self.x = self.A @ self.x
        self.P = self.A @ self.P @ self.A.T + self.Q

    def update(self, z):
        y = z - self.H @ self.x
        S = self.H @ self.P @ self.H.T + self.R
        K = self.P @ self.H.T @ np.linalg.inv(S)
        self.x = self.x + K @ y
        self.P = (np.eye(len(self.x)) - K @ self.H) @ self.P
        return self.x
```

## Tecnologías principales

| Herramienta | Propósito |
|-------------|-----------|
| pgmpy | Redes Bayesianas, inferencia exacta y aproximada en Python |
| PyMC | MCMC y modelado probabilístico (HMC, NUTS, Metropolis) |
| Stan | Inferencia Bayesiana con HMC (interfaces: Python, R, Julia) |
| Pyro (Uber) | Inferencia variacional y programación probabilística (PyTorch) |
| TensorFlow Probability | Distribuciones, bijectors, MCMC, VI (TensorFlow) |
| NumPyro | Pyro sobre JAX, alta performance con XLA |
| bnlearn | Redes Bayesianas (aprendizaje de estructura y parámetros) |
| hmmlearn | Modelos ocultos de Markov (HMM) |
| FilterPy | Filtros de Kalman y de partículas |
| OpenBUGS / JAGS | Modelado Bayesiano clásico |

## Buenas prácticas

- Usar redes Bayesianas cuando hay relaciones causales claras entre variables
- Para inferencia en modelos complejos, preferir MCMC (PyMC, Stan) sobre métodos exactos
- Para grandes datasets, usar inferencia variacional (Pyro) que escala mejor
- Validar modelos con posterior predictive checks (simular datos del posterior y comparar con observados)
- Usar WAIC o LOO-CV para comparación de modelos Bayesianos
- Inicializar MCMC con múltiples cadenas y verificar convergencia (R-hat < 1.01)
- Para tracking en tiempo real, usar Filtro de Kalman (lineal) o Filtro de Partículas (no lineal)
- Documentar prior distributions y justificar su elección
- Combinar razonamiento probabilístico con lógico (Markov Logic Networks) para problemas híbridos
