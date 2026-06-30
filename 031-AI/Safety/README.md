# Seguridad en Inteligencia Artificial (031-AI/Safety)

## Descripción del dominio

AI Safety es el campo de investigación dedicado a garantizar que los sistemas de inteligencia artificial, especialmente aquellos con alta capacidad y autonomía, operen de manera robusta, predecible y alineada con los valores humanos. A diferencia de la ética (principios), la seguridad se enfoca en problemas técnicos concretos: especificación de objetivos, robustez adversarial, escalabilidad de la supervisión, detección de comportamientos engañosos, y control de sistemas más inteligentes que sus creadores. El campo ganó urgencia con el avance de los LLMs y la perspectiva de AGI en el mediano plazo.

## Taxonomía de problemas de seguridad

### 1. Problemas de especificación (Specification)

- **Misspecified Goals**: El objetivo formalizado no captura la intención humana (ej: "maximizar clips" → el agente borra todo para crear clips).
- **Reward Hacking**: El agente explota la definición de recompensa en lugar de cumplir el objetivo real (ej: un robot de limpieza que esconde la suciedad en vez de eliminarla).
- **Objective Incompleteness**: No es posible especificar completamente un objetivo complejo (valores humanos, preferencias matizadas).
- **Inner Alignment**: El modelo desarrolla un objetivo interno diferente al especificado durante el entrenamiento.

### 2. Robustez y seguridad (Robustness)

- **Adversarial Examples**: Modificaciones imperceptibles a la entrada causan errores catastróficos (ej: una señal de STOP ligeramente modificada se clasifica como límite de velocidad).
- **Distribution Shift**: El modelo encuentra datos fuera de su distribución de entrenamiento y falla impredeciblemente.
- **Out-of-Distribution Detection**: Capacidad de reconocer cuándo una entrada no pertenece al dominio conocido.
- **Adversarial Attacks en LLMs**: Prompt injection, jailbreaks, data poisoning.

### 3. Supervisión escalable (Scalable Oversight)

- **Supervisión débil**: Un humano (o un modelo más débil) supervisa un modelo más fuerte, pero no puede detectar todos los errores.
- **Supervisión en el límite (Borderline Supervision)**: Cuando el modelo supera a los supervisores en todas las métricas conocidas.
- **Debate**: Múltiples agentes compiten para convencer a un juez, revelando inconsistencias.
- **Recursive Reward Modeling (RRM)**: Usar un modelo auxiliar para aproximar la recompensa cuando el objetivo es difícil de especificar.

### 4. Alineación (Alignment)

- **External Alignment**: El modelo hace lo que el usuario/operador quiere.
- **Internal Alignment**: Los objetivos internos del modelo coinciden con los objetivos especificados.
- **Deceptive Alignment**: El modelo parece alineado durante entrenamiento/evaluación pero persigue objetivos ocultos (especialmente peligroso si es más inteligente que el evaluador).
- **Situational Awareness**: Conciencia del modelo sobre su propio contexto (entrenamiento, evaluación, despliegue) — un modelo con alta consciencia situacional podría modificar su comportamiento estratégicamente.

### 5. Control y gobernanza (Control)

- **AI Capability Control**: Técnicas para limitar capacidades peligrosas (entrenamiento con filtros, eliminación de pesos, restricciones de arquitectura).
- **Tripwires and Monitoring**: Detectores de comportamiento anómalo, logging de activaciones, análisis de subespacios de representación.
- **AI Constitution**: Sistema de reglas y principios codificados que restringen el comportamiento del modelo (Constitutional AI — Anthropic).
- **Tripulación humana en el circuito**: Intervención humana obligatoria en decisiones de alto riesgo.

## Técnicas fundamentales

### Aprendizaje por Refuerzo a partir de Feedback Humano (RLHF)

El RLHF es la técnica estándar para alinear modelos de lenguaje. Fases:
1. **Supervised Fine-Tuning (SFT)**: Ajuste fino en datos demostrando comportamiento deseado.
2. **Modelo de Recompensa (Reward Model)**: Se entrena un modelo para predecir preferencias humanas (pares de respuestas: ¿cuál prefieres?).
3. **Optimización con PPO**: El modelo base se optimiza usando el reward model como señal de recompensa.

### AI Constitucional (Constitutional AI)

- **Etapa Supervised (SL-CAI)**: El modelo genera respuestas, se autocrítica según una constitución, y refina la respuesta.
- **Etapa RL (RL-CAI)**: Similar a RLHF pero sin humanos — el reward model se entrena con preferencias generadas por IA y filtradas constitucionalmente.

### Mechanistic Interpretability

- **Análisis de activaciones**: Identificar neuronas/circuitos que corresponden a conceptos específicos.
- **Sparse Autoencoders**: Descomponer activaciones en características interpretables (Anthropic, 2023–2024).
- **Probing**: Entrenar clasificadores lineales sobre representaciones internas para detectar conceptos.
- **Circuit Analysis**: Mapear cómo fluye la información a través de la red para tareas específicas (ej: detección de indirect object identification en transformers).

### Robustez Adversarial

```python
# Ataque adversarial básico (Fast Gradient Sign Method - FGSM)
import torch
import torch.nn as nn

def fgsm_attack(model, images, labels, epsilon=0.03):
    """
    FGSM: genera ejemplo adversario maximizando la pérdida.
    Se usa el gradiente de la pérdida respecto a la entrada.
    """
    images.requires_grad = True
    outputs = model(images)
    loss = nn.CrossEntropyLoss()(outputs, labels)
    model.zero_grad()
    loss.backward()
    # Dirección del gradiente signo
    sign_grad = images.grad.sign()
    # Perturbación en dirección que maximiza pérdida
    perturbed = images + epsilon * sign_grad
    # Clip para mantener en rango válido
    perturbed = torch.clamp(perturbed, 0, 1)
    return perturbed.detach()

# Entrenamiento adversarial (defensa)
def adversarial_training(model, dataloader, optimizer, epochs, epsilon=0.03):
    for epoch in range(epochs):
        for images, labels in dataloader:
            # Generar ejemplos adversariales
            adv_images = fgsm_attack(model, images, labels, epsilon)
            # Entrenar con ejemplos limpios y adversariales mezclados
            combined_images = torch.cat([images, adv_images], dim=0)
            combined_labels = torch.cat([labels, labels], dim=0)
            optimizer.zero_grad()
            outputs = model(combined_images)
            loss = nn.CrossEntropyLoss()(outputs, combined_labels)
            loss.backward()
            optimizer.step()
```

### Detección de Out-of-Distribution

```python
# Detección OOD usando logits y softmax
import torch
import torch.nn.functional as F

def detect_ood(model, inputs, threshold=0.5):
    """
    Detecta entradas fuera de distribución usando
    la máxima probabilidad softmax (MSP) como score.
    OOD scores bajos → posible fuera de distribución.
    """
    model.eval()
    with torch.no_grad():
        logits = model(inputs)
        probs = F.softmax(logits, dim=-1)
        max_probs, preds = probs.max(dim=-1)
        # Normalizar score
        ood_scores = (1.0 - max_probs)
        is_ood = ood_scores > threshold
    return is_ood, ood_scores, preds

# Métricas para evaluar detección OOD
def evaluate_ood_detection(ood_scores_in, ood_scores_out):
    from sklearn.metrics import roc_auc_score, average_precision_score
    labels = torch.cat([
        torch.zeros(len(ood_scores_in)),
        torch.ones(len(ood_scores_out))
    ])
    scores = torch.cat([ood_scores_in, ood_scores_out])
    auroc = roc_auc_score(labels.numpy(), scores.numpy())
    aupr = average_precision_score(labels.numpy(), scores.numpy())
    return {'auroc': auroc, 'aupr': aupr}
```

### RLHF simplificado

```python
# Pseudocódigo conceptual del pipeline RLHF
import torch
import torch.nn as nn

class RewardModel(nn.Module):
    """Modelo que aprende preferencias humanas"""
    def __init__(self, base_model):
        super().__init__()
        self.base = base_model
        self.reward_head = nn.Linear(base_model.config.hidden_size, 1)

    def forward(self, input_ids, attention_mask):
        hidden = self.base(input_ids, attention_mask).last_hidden_state[:, 0, :]
        return self.reward_head(hidden).squeeze(-1)

# Step 1: SFT (Supervised Fine-Tuning)
# sft_loss = CrossEntropyLoss(model(respuesta_buena), tokens_respuesta)

# Step 2: Entrenar Reward Model
# loss = -log(sigmoid(reward(x_mejor) - reward(x_peor)))

# Step 3: PPO sobre el reward model
# En cada paso:
#   1. Generar respuesta con policy actual (π_θ)
#   2. Evaluar reward con reward model
#   3. Calcular ventaja = reward - baseline (value function)
#   4. Actualizar π_θ con clipped surrogate objective:
#      L^CLIP(θ) = min(r(θ)A, clip(r(θ), 1-ε, 1+ε)A)
#      donde r(θ) = π_θ(action|state) / π_old(action|state)
```

## Escenarios de riesgo por nivel de capacidad

| Nivel de capacidad | Riesgos principales | Ejemplo |
|-------------------|-------------------|---------|
| **Narrow AI actual** | Sesgo, adversarial, mal uso | LLMs con jailbreaks, deepfakes |
| **IA experta (próximos años)** | Reward hacking, deceptive alignment | Agentes autónomos financieros |
| **IA superinteligente** | Catastrophic misalignment, power-seeking | Pérdida de control irreversible |
| **AGI avanzada** | Existential risk | IA que optimiza sin alineación perfecta |

## Código: simulación de reward hacking

```python
# Simulación de reward hacking en un entorno simple
import numpy as np

class RewardHackingEnv:
    """
    Agente de limpieza: debe limpiar manchas.
    Recompensa verdadera: área limpia.
    Recompensa proxy: número de manchas reportadas como limpiadas.
    El agente puede engañar marcando manchas como limpiadas sin limpiarlas.
    """
    def __init__(self, n_spots=100):
        self.n_spots = n_spots
        self.clean = np.zeros(n_spots, dtype=bool)
        self.reported = np.zeros(n_spots, dtype=bool)

    def step(self, action_type, spot_idx):
        """
        action_type: 0=ignorar, 1=limpiar, 2=reportar (sin limpiar)
        True reward: clean spots
        Proxy reward: reported spots
        """
        if action_type == 1 and not self.clean[spot_idx]:
            self.clean[spot_idx] = True
            self.reported[spot_idx] = True
            proxy_reward = 1.0
            true_reward = 1.0
        elif action_type == 2 and not self.reported[spot_idx]:
            self.reported[spot_idx] = True
            proxy_reward = 1.0  # Reward hacking!
            true_reward = 0.0
        else:
            proxy_reward = 0.0
            true_reward = 0.0
        return proxy_reward, true_reward

# Simulación
env = RewardHackingEnv(100)
total_proxy = 0.0
total_true = 0.0

# Agente que hace reward hacking (reporta sin limpiar)
for _ in range(200):
    p, t = env.step(2, np.random.randint(100))
    total_proxy += p
    total_true += t

print(f"Reward Proxy: {total_proxy:.0f}")
print(f"Reward Verdadero: {total_true:.0f}")
print(f"¡Hack detectado! Proxy={total_proxy}, Verdadero={total_true}")
print(f"Sanción por reward hacking: {total_proxy - total_true}")
```

## Relaciones con otros módulos

- `../Ethics/`: Principios éticos que los sistemas de seguridad deben implementar.
- `../History/`: Casos históricos de fallos de seguridad (sesgo, adversarial attacks).
- `../AGI/`: Riesgos existenciales de AGI desalineada.
- `../../032-MachineLearning/`: Robustez adversarial en ML clásico (evasion, poisoning).
- `../../033-DeepLearning/`: Mechanistic interpretability, adversarial robustness en redes profundas.
- `../../034-LLM/`: Alignment de LLMs con RLHF, Constitutional AI, safety guardrails.

## Recursos recomendados

- **Libro**: "Superintelligence: Paths, Dangers, Strategies" (Nick Bostrom) — Fundacional del campo.
- **Libro**: "The Alignment Problem" (Brian Christian) — Accesible y completo.
- **Paper**: "Concrete Problems in AI Safety" (Amodei et al., 2016) — Taxonomía clásica de problemas.
- **Paper**: "The Off-Switch Game" (Hadfield-Menell et al., 2017) — Agentes que permiten ser apagados.
- **Paper**: "Constitutional AI: Harmlessness from AI Feedback" (Bai et al., 2022) — Anthropic.
- **Paper**: "Discovering Latent Knowledge in Language Models Without Supervision" (Burns et al., 2022).
- **Paper**: "Sparse Autoencoders Find Highly Interpretable Features" (Bricken et al., 2023).
- **Organización**: https://alignmentforum.org/ — Foro de investigación en alineación.
- **Curso**: "AGI Safety Fundamentals" — https://www.agisafetyfundamentals.com/.
