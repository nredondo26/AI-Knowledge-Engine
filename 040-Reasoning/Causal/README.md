# Razonamiento Causal en IA

## Descripción del dominio

El razonamiento causal va más allá de la correlación y la predicción para entender las relaciones de causa y efecto entre variables. Formalizado por Judea Pearl en el *Ladder of Causation* (tres niveles: Asociación, Intervención, Contrafactuales), permite responder preguntas del tipo "¿qué pasaría si interviniéramos?" y "¿por qué ocurrió esto?". Es fundamental para el descubrimiento científico, políticas públicas, pruebas de fármacos, análisis de negocio (marketing causal), fairness en ML (eliminar sesgo), y recomendaciones causales.

## Áreas clave

- **Ladder of Causation (Pearl)**: Nivel 1 (Asociación — ver correlaciones, P(y|x)), Nivel 2 (Intervención — predecir efecto de acciones, P(y|do(x))), Nivel 3 (Contrafactuales — razonar sobre lo que podría haber sido)
- **Diagramas causales (DAGs)**: Directed Acyclic Graphs donde aristas X → Y indican que X causalmente afecta a Y. Nodos: variables observadas y no observadas. Aristas: relaciones causales directas
- **Do-calculus**: Operador do(X=x) que representa la intervención que fija X a x. Reglas de do-calculus para estimar P(y|do(x)) a partir de datos observacionales
- **Criterio back-door**: Conjunto de variables Z que bloquea caminos espurios (confounders) entre X e Y. Si Z satisface back-door, P(y|do(x)) = Σ_z P(y|x,z) P(z)
- **Criterio front-door**: Cuando hay un mediador M entre X e Y y no se pueden medir confounders directamente. P(y|do(x)) = Σ_m P(m|x) Σ_x' P(y|m,x') P(x')
- **Contrafactuales**: Razonamiento "¿qué habría pasado si...?" a nivel individual. Basado en modelos estructurales (SCM). Ej: "Si hubiera tomado el otro medicamento, ¿me habría curado?"
- **Descubrimiento causal**: Aprender el DAG causal a partir de datos. Algoritmos: PC, FCI, GES, LiNGAM (no lineal), NOTEARS (optimización continua), DirectLiNGAM. Asunciones: suficiencia causal, fidelidad, Markov property
- **Inferencia causal (ATE, CATE)**: Average Treatment Effect (ATE), Conditional Average Treatment Effect (CATE), Heterogeneous Treatment Effects. Métodos: Propensity Score Matching (PSM), Inverse Probability Weighting (IPW), Double ML (DML), Causal Forest, Instrumental Variables (IV)
- **Causalidad en ML**: Causal representation learning, invariant risk minimization (IRM), stable learning, domain generalization, fair ML (eliminar efecto de variables sensibles). Modelos causales para out-of-distribution generalization
- **Instrumental Variables (IV)**: Variable Z que afecta a X pero no a Y directamente (solo a través de X). Usado cuando hay confounders no observados. Estimación: two-stage least squares (2SLS)

## Ejemplo: Do-calculus con dowhy

```python
import dowhy
from dowhy import CausalModel
import pandas as pd

# Crear modelo causal
model = CausalModel(
    data=df,
    treatment='medicamento',
    outcome='curacion',
    graph="""
        digraph {
            edad -> medicamento;
            gravedad -> medicamento;
            gravedad -> curacion;
            medicamento -> curacion;
            edad -> curacion;
        }
    """
)

# Identificar efecto causal
identified = model.identify_effect()

# Estimar ATE
estimate = model.estimate_effect(identified,
    method_name="backdoor.propensity_score_matching")
print(f"ATE: {estimate.value}")

# Refutar con placebo y subconjunto
refutation = model.refute_estimate(identified, estimate,
    method_name="placebo_treatment_refuter")
```

## Ejemplo: Modelo estructural causal (SCM)

```python
import numpy as np

# SCM: X = f_x(U_x), Y = f_y(X, U_y), Z = f_z(Y, U_z)
# Con U_x, U_y, U_z independientes

class SCM:
    def __init__(self, seed=42):
        self.rng = np.random.default_rng(seed)

    def sample(self, n=1000, do_x=None):
        U_x = self.rng.normal(0, 1, n)
        U_y = self.rng.normal(0, 0.5, n)
        U_z = self.rng.normal(0, 0.3, n)

        if do_x is not None:
            x = np.full(n, do_x)
        else:
            x = 2 * U_x + 0.5 * U_y  # confounded

        y = 3 * x + U_y               # efecto causal
        z = 0.8 * y + U_z             # mediación

        return x, y, z

scm = SCM()
x_obs, y_obs, _ = scm.sample(10000)
x_int, y_int, _ = scm.sample(10000, do_x=1.0)

print(f"Asociacional: E[Y|X=1] ≈ {y_obs[x_obs > 0.9].mean():.2f}")
print(f"Intervencional: E[Y|do(X=1)] ≈ {y_int.mean():.2f}")
```

## Tecnologías principales

| Herramienta | Descripción |
|-------------|-------------|
| DoWhy (Microsoft) | Inferencia causal en Python: identificación, estimación, refutación |
| CausalNex | Modelos causales con DAGs y redes bayesianas |
| EconML (Microsoft) | Métodos de estimación CATE/ATE (DML, Causal Forest, IV) |
| CausalML (Uber) | Modelos causales basados en ML (uplift modeling, CATE) |
| Tetrad (CMU) | Descubrimiento causal (algoritmos PC, FCI, GES) — interfaz gráfica |
| PyWhy | Ecosistema Python para causalidad (DoWhy, EconML, dowhy-gcm) |
| causallearn | Descubrimiento causal (PC, FCI, LiNGAM, NOTEARS) |
| ShowYourWork | Razonamiento contrafactual con SCM |
| Bayesys | Inferencia de DAGs con métodos Bayesianos |

## Buenas prácticas

- Empezar siempre con un diagrama causal (DAG) dibujado manualmente basado en conocimiento del dominio
- Usar DoWhy para el pipeline completo: model → identify → estimate → refute
- Verificar supuestos: suficiencia causal, no confounding sin medir, positividad (overlap)
- Refutar estimaciones con tests de placebo, subconjunto de datos, y random common cause
- No confundir correlación con causalidad: los DAGs requieren conocimiento del dominio
- Para ATE, usar Double ML (EconML) que es robusto a model misspecification
- Para descubrimiento causal con < 50 variables, usar PC o GES; > 50 variables, NOTEARS
- En ML, considerar causalidad para mejorar generalización out-of-distribution (IRM, stable learning)
- Documentar supuestos causales explícitamente y hacer análisis de sensibilidad
