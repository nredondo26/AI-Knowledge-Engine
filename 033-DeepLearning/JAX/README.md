# JAX

## Descripción del dominio

JAX es una biblioteca de Google Research para cómputo numérico de alto rendimiento con aceleración GPU/TPU. Combina la flexibilidad de NumPy con la capacidad de diferenciación automática (autograd), compilación JIT (XLA), vectorización automática (vmap) y paralelización (pmap). JAX no es un framework de deep learning como tal, sino un motor de transformaciones de funciones que sirve de base para bibliotecas de alto nivel como Flax, Haiku, Equinox y Optimistix. Es usado por DeepMind para investigación a gran escala y por modelos populares como AlphaFold.

## Conceptos clave

- **jax.numpy**: API compatible con NumPy que funciona sobre XLA. Soporta GPU/TPU de forma transparente.
- **Autograd (grad)**: Diferenciación automática de funciones Python arbitrarias. Soporta gradientes de primer orden, Hessianos, Jacobianos.
- **JIT (just-in-time)**: Compilación de funciones Python a kernels XLA optimizados con `@jit`. Acelera drásticamente bucles y operaciones.
- **vmap (vectorizing map)**: Transforma funciones que procesan un solo elemento en funciones vectorizadas sobre lotes.
- **pmap (parallel map)**: Ejecuta funciones en paralelo a través de múltiples dispositivos (GPUs/TPUs). SPMD (Single Program Multiple Data).
- **Pseudo-aleatoriedad**: JAX maneja la aleatoriedad explícitamente con claves (PRNGKey) para garantizar reproducibilidad en cómputo paralelo.
- **Inmutabilidad**: Los arrays en JAX son inmutables. No hay operaciones in-place. Cada operación crea un nuevo array.
- **Composable Transformations**: Las transformaciones (grad, jit, vmap, pmap) son composables y se aplican a funciones puras.

## Ejemplo: Diferenciación automática

```python
import jax
import jax.numpy as jnp

def f(x):
    return jnp.sin(x) ** 2 + jnp.cos(x) ** 2

grad_f = jax.grad(f)
x = jnp.array(1.0)
print(f"f(x) = {f(x):.4f}")
print(f"f'(x) = {grad_f(x):.4f}")

# Hessiano
hessian_f = jax.hessian(f)
print(f"f''(x) = {hessian_f(x):.4f}")

# Gradiente de una función con múltiples parámetros
def loss(w, b, x, y):
    pred = jnp.dot(x, w) + b
    return jnp.mean((pred - y) ** 2)

w = jnp.array([1.0, 2.0])
b = jnp.array(0.5)
X = jnp.array([[1.0, 2.0], [3.0, 4.0]])
Y = jnp.array([1.0, 2.0])

grad_loss = jax.grad(loss, argnums=(0, 1))
dw, db = grad_loss(w, b, X, Y)
print(f"dw = {dw}, db = {db}")
```

## Ejemplo: JIT y vectorización

```python
import jax
import jax.numpy as jnp
import time

@jax.jit
def funcion_ralentizada(x):
    for _ in range(1000):
        x = jnp.sin(x) + jnp.cos(x)
    return x

@jax.jit
def funcion_vectorizada(x):
    x = jnp.sin(x) + jnp.cos(x)
    return x

# vmap: aplicar función a cada fila de un batch
funcion_batch = jax.vmap(funcion_vectorizada)

x = jnp.ones(1000)
# Primera llamada JIT compila (lento)
resultado = funcion_ralentizada(x)
# Segunda llamada es rápida
resultado = funcion_ralentizada(x)

batch = jnp.ones((100, 1000))
resultados = funcion_batch(batch)
print(f"Shape del batch: {resultados.shape}")
```

## Tecnologías principales

- **JAX**: Base de transformaciones: grad, jit, vmap, pmap, lax (operaciones de bajo nivel).
- **Flax**: Framework de redes neuronales de Google Research (similar a PyTorch nn.Module).
- **Haiku**: Framework de DeepMind para redes neuronales con JAX.
- **Equinox**: Biblioteca para parámetros como estructuras PyTree.
- **Optax**: Biblioteca de optimizadores (Adam, SGD, AdamW).
- **Orbax**: Checkpointing y almacenamiento.
- **Diffrax**: Resolución de EDOs (ecuaciones diferenciales ordinarias).

## Hoja de ruta

1. Conceptos básicos: jax.numpy, inmutabilidad, PRNG keys.
2. Autograd: grad, value_and_grad, jacfwd, jacrev, hessian.
3. JIT: compilación, trazado, reglas de uso, efectos secundarios.
4. vmap: vectorización automática, combinación con grad.
5. pmap: paralelización multi-dispositivo, SPMD.
6. Construcción de redes neuronales con Flax o Haiku.
7. Entrenamiento distribuido a gran escala con pmap y FSDP.

## Relaciones con otros módulos

- `../../032-MachineLearning/MLflow/`: Seguimiento de experimentos con JAX.
- `../../033-DeepLearning/`: JAX como alternativa a PyTorch/TensorFlow para deep learning.
- `../../033-DeepLearning/ModelOptimization/`: Optimización de modelos en JAX.
- `../../034-LLM/`: Implementación de transformers con JAX (llamada en Flax).

## Recursos recomendados

- **Documentación**: JAX Documentation (jax.readthedocs.io).
- **Curso**: "JAX 101" (jax.readthedocs.io/en/latest/jax-101).
- **Paper**: "JAX: Composable Transformations of Python+NumPy Programs" (2018).
- **Repositorio**: google/jax (GitHub), google/flax (GitHub).
- **Taller**: "JAX, Flax & Transformers" (YouTube).
