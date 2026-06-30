# Ética de la Inteligencia Artificial (031-AI/Ethics)

## Descripción del dominio

La ética de la IA es el campo multidisciplinario que estudia los principios morales, valores y normas que deben guiar el diseño, desarrollo, despliegue y gobernanza de los sistemas de inteligencia artificial. Abarca problemas como el sesgo algorítmico, la equidad, la transparencia, la privacidad, la responsabilidad, la explicabilidad y el impacto social. Con la creciente integración de la IA en decisiones críticas (préstamos, justicia penal, contratación, salud), la ética ha pasado de ser un tema académico periférico a una prioridad regulatoria y empresarial.

## Conceptos clave

### Sesgo algorítmico (Bias)

- **Sesgo de datos históricos**: El modelo replica sesgos existentes en los datos de entrenamiento (ej: sistemas de contratación que discriminan por género porque los datos históricos reflejan sesgos pasados).
- **Sesgo de muestreo**: Los datos de entrenamiento no representan adecuadamente a la población objetivo.
- **Sesgo de etiquetado**: Anotadores humanos introducen sus propios sesgos al etiquetar datos.
- **Sesgo de medición**: Las métricas y características seleccionadas no capturan el fenómeno real de manera justa.
- **Sesgo de agregación**: Un modelo único no puede representar adecuadamente a todos los subgrupos.
- **Sesgo de evaluación**: La métrica de rendimiento no refleja equidad (ej: accuracy global alta pero rendimiento pobre en minorías).

### Equidad (Fairness)

- **Paridad demográfica (Demographic Parity)**: La probabilidad de predicción positiva debe ser igual entre grupos protegidos.
- **Igualdad de oportunidades (Equal Opportunity)**: La tasa de verdaderos positivos debe ser igual entre grupos (Tasa de aciertos por grupo).
- **Igualdad de odds (Equalized Odds)**: Tanto la tasa de verdaderos positivos como la de falsos positivos deben ser iguales.
- **Equidad individual**: Individuos similares deben recibir predicciones similares.
- **Contra-factual**: La predicción no debe cambiar si se modifica solo la característica del grupo protegido.

### Transparencia y Explicabilidad (XAI)

- **Transparencia del modelo**: Capacidad de entender internamente cómo funciona el modelo.
- **Explicaciones post-hoc**: SHAP, LIME, Grad-CAM, Integrated Gradients.
- **Modelos intrínsecamente interpretables**: Árboles de decisión pequeños, regresión lineal, modelos GLM.
- **Derecho a la explicación**: Regulado por GDPR (Art. 22) — los ciudadanos tienen derecho a recibir una explicación de decisiones automatizadas.

### Privacidad

- **Datos sensibles**: Información protegida (raza, religión, orientación sexual, salud).
- **Ataques de inferencia**: Extraer información privada del modelo entrenado (membership inference, model inversion).
- **Diferential Privacy (DP)**: Técnica que añade ruido controlado para garantizar que la presencia o ausencia de un individuo no afecte significativamente el resultado del modelo.
- **Aprendizaje Federado**: Entrenamiento descentralizado donde los datos nunca abandonan el dispositivo.

### Responsabilidad (Accountability)

- **Human-in-the-loop**: Decisiones críticas requieren supervisión humana obligatoria.
- **Liability**: ¿Quién es responsable cuando un sistema de IA causa daño? (fabricante, desarrollador, deployer, usuario).
- **AI auditing**: Evaluación independiente de sistemas de IA para verificar cumplimiento de estándares éticos.

## Regulaciones y marcos normativos

| Regulación / Marco | Región | Año | Aspectos clave |
|-------------------|--------|-----|----------------|
| **GDPR** (Art. 22) | Unión Europea | 2018 | Derecho a no ser sujeto a decisiones automatizadas, derecho a explicación |
| **EU AI Act** | Unión Europea | 2024 | Clasificación por riesgo (inaceptable, alto, limitado, mínimo); transparencia, evaluación de conformidad |
| **Executive Order 14110** | EE.UU. | 2023 | Estándares de seguridad, equidad, privacidad para IA |
| **AI Bill of Rights** | EE.UU. | 2022 | Blueprint: sistemas seguros, no discriminatorios, con privacidad, notificación, explicación, alternativas humanas |
| **Beijing AI Principles** | China | 2019 | Armonía, responsabilidad, ética, privacidad, equidad |
| **UNESCO Recommendation** | Global | 2021 | Ética de la IA como marco internacional vinculante |
| **NIST AI Risk Management Framework** | EE.UU. | 2023 | Mapa, Medir, Gestionar, Gobernar riesgos de IA |

## Problemas abiertos y debates

1. **Alignment Problem**: ¿Cómo aseguramos que los sistemas de IA avanzada optimicen lo que realmente queremos (no lo que literalmente programamos)?
2. **Value Lock-in**: Riesgo de que los primeros sistemas de IA general codifiquen valores particulares que después sean difíciles de cambiar.
3. **Concentración de poder**: Empresas con acceso a datos masivos y compute concentran el poder de la IA; riesgo de monopolio.
4. **Desplazamiento laboral**: Automatización de trabajos cognitivos y creativos; necesidad de re-skilling y renta básica universal.
5. **Armas autónomas letales (LAWS)**: Sistemas que seleccionan y atacan objetivos sin intervención humana.
6. **Manipulación y desinformación**: Deepfakes, generación de contenido falso a escala industrial.

## Código: detección y mitigación de sesgo

```python
# Detección de sesgo en clasificación binaria con scikit-learn
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import confusion_matrix

# Simulación: dataset de aprobación de préstamos con sesgo de género
np.random.seed(42)
n = 2000
genero = np.random.choice([0, 1], n)  # 0=mujer, 1=hombre
ingreso = np.random.normal(50000, 15000, n) * (1 + 0.2 * genero)
deuda = np.random.normal(20000, 10000, n)
historial = np.random.beta(2 + 3 * genero, 2)  # hombres tienen mejor historial (sesgo)
aprobado = (ingreso / 30000 + historial * 2 - deuda / 20000 > np.random.normal(1, 0.5, n)).astype(int)

df = pd.DataFrame({'genero': genero, 'ingreso': ingreso, 'deuda': deuda,
                   'historial': historial, 'aprobado': aprobado})

X = df[['genero', 'ingreso', 'deuda', 'historial']]
y = df['aprobado']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)
y_pred = model.predict(X_test)

# Evaluación por grupo
test = X_test.copy()
test['real'] = y_test
test['pred'] = y_pred

for g in [0, 1]:
    subset = test[test['genero'] == g]
    cm = confusion_matrix(subset['real'], subset['pred'])
    tn, fp, fn, tp = cm.ravel()
    tpr = tp / (tp + fn)  # True Positive Rate
    fpr = fp / (fp + tn)  # False Positive Rate
    precision = tp / (tp + fp)
    print(f"Género {'Mujer' if g == 0 else 'Hombre'}: "
          f"TPR={tpr:.2f}, FPR={fpr:.2f}, Precisión={precision:.2f}, n={len(subset)}")

# Demographic Parity: P(y_pred=1 | grupo=0) ≈ P(y_pred=1 | grupo=1)
p_mujer = (test[test['genero'] == 0]['pred'] == 1).mean()
p_hombre = (test[test['genero'] == 1]['pred'] == 1).mean()
print(f"\nDemographic Parity: Mujer={p_mujer:.2f}, Hombre={p_hombre:.2f}")
print(f"Diferencia (debe ser ≈0 para equidad): {abs(p_mujer - p_hombre):.3f}")
```

```python
# Mitigación de sesgo con reweighting y umbral por grupo
from sklearn.calibration import CalibratedClassifierCV

# Estrategia 1: Remover la característica protegida (poco efectivo si hay proxies)
X_no_genero = X.drop('genero', axis=1)
model2 = RandomForestClassifier(n_estimators=100, random_state=42)
model2.fit(X_no_genero, y_train)
y_pred2 = model2.predict(X_test.drop('genero', axis=1))
acc_no_gen = (y_pred2 == y_test).mean()
print(f"\nAccuracy sin género: {acc_no_gen:.3f}")

# Estrategia 2: Calibrar y usar umbrales específicos por grupo
calibrated = CalibratedClassifierCV(
    RandomForestClassifier(n_estimators=100, random_state=42),
    method='isotonic'
)
calibrated.fit(X_train, y_train)
probs = calibrated.predict_proba(X_test)[:, 1]

for g in [0, 1]:
    idx = X_test['genero'] == g
    subset_probs = probs[idx]
    # Usar umbral óptimo por grupo para igualar TPR
    best_thresh = np.percentile(subset_probs[y_test.values[idx] == 1], 20)
    print(f"Umbral óptimo {g}: {best_thresh:.3f}")
```

```python
# Explicabilidad con SHAP
import shap

explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X_test)

# Resumen de importancia
shap.summary_plot(shap_values, X_test, feature_names=X.columns, show=False)
```

## Relaciones con otros módulos

- `../History/`: Lecciones de fracasos éticos históricos (sesgo en COMPAS, Tay de Microsoft).
- `../Safety/`: La ética informa los objetivos de seguridad; la seguridad implementa principios éticos.
- `../AGI/`: Ética de la IA avanzada — alineación, valores, gobernanza global.
- `../../032-MachineLearning/`: Técnicas de debiasing, fair ML, adversarial debiasing.
- `../../033-DeepLearning/`: Privacidad en deep learning, differential privacy, federated learning.
- `../../034-LLM/`: Sesgo en LLMs, jailbreaks, mitigación, contenido tóxico.

## Recursos recomendados

- **Libro**: "Weapons of Math Destruction" (Cathy O'Neil) — Cómo los algoritmos perpetúan desigualdad.
- **Libro**: "The Ethical Algorithm" (Kearns & Roth) — Privacidad, equidad y transparencia.
- **Libro**: "Fairness and Machine Learning: Limitations and Opportunities" (Barocas, Hardt, Narayanan).
- **Paper**: "Fairness through Awareness" (Dwork et al., 2012) — Definiciones formales de equidad.
- **Paper**: "The Mythos of Model Interpretability" (Lipton, 2016) — Crítica a la interpretabilidad.
- **Curso**: "CS 364A: Fairness in Machine Learning" (Stanford) — https://fairmlclass.github.io/.
- **Herramientas**: AI Fairness 360 (IBM), Fairlearn (Microsoft), What-If Tool (Google).
- **Regulación**: EU AI Act (2024), NIST AI RMF 1.0.
