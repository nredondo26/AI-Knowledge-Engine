# Aprendizaje por Refuerzo (Reinforcement Learning)

## Descripción del dominio

El Aprendizaje por Refuerzo (RL) es un paradigma donde un agente aprende a tomar decisiones mediante interacción con un entorno. El agente recibe recompensas o penalizaciones por sus acciones y debe maximizar la recompensa acumulada a largo plazo. A diferencia del aprendizaje supervisado, no hay ejemplos etiquetados sino una señal de recompensa que guía el aprendizaje. RL ha logrado hitos impresionantes en juegos (AlphaGo, Dota 2, StarCraft II), robótica, control autónomo y sistemas de recomendación.

## Conceptos clave

- **Agente**: Entidad que toma decisiones basándose en el estado del entorno.
- **Entorno (Environment)**: Sistema con el que interactúa el agente. Define estados, acciones y transiciones.
- **Estado (State)**: Representación de la situación actual del entorno.
- **Acción (Action)**: Decisión que toma el agente, que afecta el estado futuro.
- **Recompensa (Reward)**: Señal numérica que indica qué tan buena fue una acción.
- **Política (Policy)**: Estrategia que mapea estados a acciones. π(s) → a. Puede ser determinista o estocástica.
- **Función de Valor (Value Function)**: Valor esperado de recompensa futura desde un estado bajo una política. V(s).
- **Función Q (Action-Value Function)**: Valor esperado de tomar una acción a en estado s y luego seguir la política. Q(s, a).
- **Exploración vs. Explotación**: Balance entre probar acciones nuevas (exploración) y usar acciones conocidas (explotación). ε-greedy, UCB.
- **Ecuación de Bellman**: Relación recursiva que define el valor de un estado en términos de recompensa inmediata y valor del siguiente estado.
- **MDP (Markov Decision Process)**: Formalización matemática: (S, A, P, R, γ). Estado, acciones, transiciones, recompensas, factor de descuento.
- **RL Profundo (Deep RL)**: Uso de redes neuronales como aproximadores de funciones (policy, value, Q). DQN, PPO, SAC, TD3.

## Ejemplo: Q-Learning en un entorno simple

```python
import numpy as np
import gymnasium as gym

env = gym.make('Taxi-v3')
n_estados = env.observation_space.n
n_acciones = env.action_space.n

q_table = np.zeros((n_estados, n_acciones))
alpha = 0.1
gamma = 0.9
epsilon = 0.1
n_episodios = 10000

for episodio in range(n_episodios):
    estado, _ = env.reset()
    done = False
    while not done:
        if np.random.random() < epsilon:
            accion = env.action_space.sample()
        else:
            accion = np.argmax(q_table[estado])

        sig_estado, recompensa, done, _, _ = env.step(accion)

        td_target = recompensa + gamma * np.max(q_table[sig_estado])
        td_error = td_target - q_table[estado, accion]
        q_table[estado, accion] += alpha * td_error
        estado = sig_estado

print("Entrenamiento completado")
```

## Ejemplo: Deep Q-Network (DQN) con PyTorch

```python
import torch
import torch.nn as nn
import torch.optim as optim

class DQN(nn.Module):
    def __init__(self, estado_dim, accion_dim):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(estado_dim, 128),
            nn.ReLU(),
            nn.Linear(128, 128),
            nn.ReLU(),
            nn.Linear(128, accion_dim)
        )

    def forward(self, x):
        return self.net(x)

# Entrenamiento (esquemático)
estado_dim = 4   # Ej: CartPole
accion_dim = 2
dqn = DQN(estado_dim, accion_dim)
optimizer = optim.Adam(dqn.parameters(), lr=0.001)
loss_fn = nn.MSELoss()

# Replay buffer, target network, ε-greedy
# Se omite por brevedad la implementación completa del loop
```

## Tecnologías principales

- **Gymnasium**: Entornos estándar para RL (Farama Foundation).
- **Stable-Baselines3**: Implementaciones de algoritmos RL en PyTorch.
- **Ray RLlib**: RL distribuido y escalable.
- **Dopamine**: Framework de Google para investigación en RL.
- **CleanRL**: Implementaciones educativas de RL en un solo archivo.
- **Acme**: Framework de DeepMind para RL.

## Hoja de ruta

1. Fundamentos: MDP, ecuación de Bellman, programación dinámica.
2. Q-Learning tabular: taxi, frozen lake.
3. Deep Q-Network: experiencia replay, target network.
4. Policy Gradient: REINFORCE, Actor-Critic.
5. PPO (Proximal Policy Optimization): clipping, ventajas.
6. SAC (Soft Actor-Critic): entropía máxima, off-policy.
7. Entrenamiento distribuido con RLlib.

## Relaciones con otros módulos

- `../Supervised/`: Diferencias clave con aprendizaje supervisado.
- `../../033-DeepLearning/`: Deep RL combina RL con redes profundas.
- `../../037-AgenticAI/`: Agentes autónomos que usan RL para tomar decisiones.
- `../../034-LLM/RLHF/`: RL con feedback humano para alinear LLMs.

## Recursos recomendados

- **Libro**: "Reinforcement Learning: An Introduction" (Sutton & Barto) — El libro de referencia.
- **Curso**: "CS234: Reinforcement Learning" (Stanford).
- **Curso**: "Spinning Up in Deep RL" (OpenAI).
- **Documentación**: Stable-Baselines3 Docs, Gymnasium Docs.
- **Repositorio**: awesome-rl (GitHub).
