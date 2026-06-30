# Control Robótico

## Descripción del dominio

El control robótico se ocupa de diseñar algoritmos que determinan las señales de entrada (fuerzas, torques, voltajes, PWM) necesarias para que un robot ejecute movimientos deseados, mantenga una postura o siga una trayectoria con precisión. Combina teoría de control clásico (PID, compensación feedforward), control moderno (LQR, MPC, control óptimo), control no lineal (backstepping, sliding mode), control adaptativo y control basado en aprendizaje (aprendizaje por refuerzo, control iterativo). Es fundamental para la manipulación robótica, locomoción, vuelo autónomo y navegación.

## Áreas clave

- **Control PID (Proporcional-Integral-Derivativo)**: Algoritmo más usado en robótica. P (error actual), I (error acumulado, elimina steady-state), D (tasa de cambio, amortigua overshoot). Tuning manual (Ziegler-Nichols) o automático (autotuning)
- **Control feedforward**: Compensa perturbaciones conocidas (gravedad, fricción) usando modelo del sistema. Se suma al feedback PID para mejorar tracking
- **LQR (Linear Quadratic Regulator)**: Control óptimo para sistemas lineales. Minimiza función de costo cuadrática. Ganancia K = R⁻¹BᵀP (solución ecuación Riccati)
- **MPC (Model Predictive Control)**: Control óptimo con restricciones. En cada paso, resuelve optimización sobre horizonte finito. Ideal para sistemas con restricciones (límites de torque, seguridad)
- **Control de fuerza/impedancia**: Controla la interacción física con el entorno. Impedance control (relación masa-muelle-amortiguador entre posición y fuerza). Admitancia (fuerza → posición)
- **Dinámica inversa**: Calcula torques necesarios para una trayectoria (control computed-torque). Basado en modelo dinámico completo (Coriolis, gravedad, inercia, fricción)
- **Control no lineal**: Sliding Mode Control (robusto a incertidumbres), Backstepping (sistemas strict-feedback), Lyapunov-based control (estabilidad garantizada)
- **Control de locomoción**: Bipedestación (walking, running), cuadrúpedos (trot, pace, bound, gallop), Control de vuelo (actitud, altitud, posición en drones)
- **Control basado en aprendizaje**: RL (aprendizaje por refuerzo con PPO, SAC, DDPG), IL (imitation learning), ILC (Iterative Learning Control para trayectorias repetitivas)

## Ejemplo: Control PID en microcontrolador

```c
typedef struct {
    float Kp, Ki, Kd;
    float integral;
    float prev_error;
    float dt;
} pid_t;

float pid_update(pid_t *pid, float setpoint, float measurement) {
    float error = setpoint - measurement;
    float P = pid->Kp * error;
    pid->integral += error * pid->dt;
    float I = pid->Ki * pid->integral;
    float D = pid->Kd * (error - pid->prev_error) / pid->dt;
    pid->prev_error = error;
    return P + I + D;
}

// Aplicación: control de velocidad de motor DC
pid_t speed_pid = { .Kp = 1.5, .Ki = 0.5, .Kd = 0.05, .dt = 0.01 };
float pwm = pid_update(&speed_pid, 100.0, encoder_speed());
motor_set_pwm(clamp(pwm, 0, 255));
```

## Ejemplo: Control MPC lineal (simplificado)

```python
import cvxpy as cp
import numpy as np

# Modelo: x_{k+1} = A x_k + B u_k
N = 10  # horizonte
x = cp.Variable((2, N+1))
u = cp.Variable((1, N))

cost = 0
constraints = [x[:, 0] == x0]
for k in range(N):
    cost += cp.quad_form(x[:, k], Q) + cp.quad_form(u[:, k], R)
    constraints += [x[:, k+1] == A @ x[:, k] + B @ u[:, k]]
    constraints += [u_min <= u[:, k], u[:, k] <= u_max]

problem = cp.Problem(cp.Minimize(cost), constraints)
problem.solve()
```

## Tecnologías principales

| Framework/Librería | Propósito |
|--------------------|-----------|
| ROS2 Control | Framework de control para ROS2. Controllers, hardware interfaces, lifecycle |
| MoveIt2 | Planificación y control de movimiento para brazos robóticos |
| OCS2 / Crocoddyl | MPC para sistemas robóticos complejos (locomoción, manipulación) |
| Drake (MIT) | Planificación, control y simulación (Python/C++) |
| CasADi / Acados | Optimización para MPC y NMPC en tiempo real |
| Gazebo / MuJoCo / PyBullet | Simulación de física con control |
| OpenRAVE / Orocos | Planificación de movimiento y control en tiempo real |
| TensorFlow / PyTorch | Aprendizaje por refuerzo para control (SAC, PPO, DDPG) |
| gym / gymnasium | Entornos de RL para entrenamiento de políticas de control |

## Buenas prácticas

- Sintonizar PID con método heurístico (Ziegler-Nichols) o automático (relay tuning)
- Usar feedforward para tareas conocidas (trayectorias repetitivas, compensación de gravedad)
- Para robots manipuladores, usar impedance control en tareas de interacción física (ensamblaje, pulido)
- LQR es adecuado para estabilización; MPC para tracking con restricciones
- En robots con dinámica no lineal, usar control no lineal o MPC no lineal
- Verificar estabilidad con Lyapunov (control clásico) o simulaciones Monte Carlo (RL)
- Usar ROS2 Control para integrar controladores con hardware real y simulación
- En robots móviles, combinar control de baja frecuencia (navegación) con alta frecuencia (estabilización)
- Para robots de alta precisión, usar ILC (Iterative Learning Control) para rechazar errores repetitivos
