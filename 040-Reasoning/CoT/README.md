# Chain-of-Thought (CoT) — Razonamiento Paso a Paso

## Descripción del dominio

Chain-of-Thought (CoT) es una técnica de prompting que induce a los LLMs a generar una secuencia de pasos de razonamiento intermedios antes de producir la respuesta final. Introducida por Wei et al. (2022), CoT mejora significativamente la precisión en tareas que requieren razonamiento matemático, lógico, simbólico y de sentido común. El razonamiento paso a paso permite al modelo descomponer problemas complejos en subproblemas manejables, reduce errores de cálculo y hace que el proceso de razonamiento sea interpretable por humanos.

## Áreas clave

- **Few-shot CoT**: Proporciona ejemplos (2-8) en el prompt que muestran el razonamiento paso a paso. Formato: "Pregunta: ... Razonamiento: ... Respuesta: ...". Los ejemplos deben ser representativos del tipo de problema
- **Zero-shot CoT**: Sin ejemplos. Usa un trigger como "Pensemos paso a paso" (Let's think step by step) o "Razonemos" para activar el razonamiento encadenado. Simple pero efectivo, especialmente con modelos grandes
- **CoT-SC (Self-Consistency)**: Genera múltiples cadenas de razonamiento independientes y selecciona la respuesta más frecuente (majority voting). Mejora robustez frente a caminos de razonamiento incorrectos
- **Auto-CoT**: Genera automáticamente ejemplos de CoT para few-shot. Agrupa preguntas por similitud y usa el LLM para generar cadenas de razonamiento para cada cluster
- **CoT con código**: Pedir al LLM que genere código Python (u otro lenguaje) para resolver el problema y ejecutar el código. El código actúa como razonamiento estructurado verificable
- **CoT en modelos multimodales**: Extensión de CoT a imágenes (vídeos, diagramas). El modelo describe visualmente la imagen y razona textualmente paso a paso
- **Evaluación de CoT**: Métricas: exactitud final, fidelidad (los pasos realmente justifican la respuesta), coherencia del razonamiento, atomicidad (granularidad de los pasos)

## Ejemplo: Few-shot CoT (prompt)

```
Pregunta: Si 3 manzanas cuestan 5 euros, ¿cuánto cuestan 12 manzanas?
Razonamiento: Primero calculamos el precio por manzana: 5 / 3 = 1.666...
Luego multiplicamos por 12: 1.666... * 12 = 20.
Respuesta: 20 euros.

Pregunta: Un tren viaja a 120 km/h durante 2.5 horas. ¿Qué distancia recorre?
Razonamiento:
Respuesta:
```

## Ejemplo: Zero-shot CoT en Python (LLM query)

```python
from openai import OpenAI

client = OpenAI()

prompt = """Pregunta: Una tienda tiene 25 camisetas. Vende 8 el lunes y 12 el martes. 
¿Cuántas camisetas le quedan?
Razonemos paso a paso:"""

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": prompt}],
    temperature=0
)

print(response.choices[0].message.content)
# El modelo genera algo como:
# "Lunes: vende 8, quedan 25 - 8 = 17
# Martes: vende 12, quedan 17 - 12 = 5
# Respuesta: 5"
```

## Ejemplo: CoT con self-consistency

```python
from collections import Counter

prompt = """Pregunta: Juan tiene 3 veces la edad de Ana. Si Ana tiene 8 años,
¿cuántos años tiene Juan?
Razonamiento paso a paso:
Respuesta:"""

responses = []
for _ in range(5):  # Múltiples muestras
    r = client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7  # Mayor temperatura para diversidad
    )
    responses.append(r.choices[0].message.content)

# Extraer respuestas numéricas y hacer majority voting
answers = []
for resp in responses:
    # Parsear último número como respuesta
    import re
    nums = re.findall(r'\d+', resp)
    if nums:
        answers.append(int(nums[-1]))

final = Counter(answers).most_common(1)[0][0]
print(f"Respuesta por consenso: {final}")
```

## Técnicas avanzadas

| Técnica | Descripción | Cuándo usarla |
|---------|-------------|---------------|
| Few-shot CoT | Ejemplos de razonamiento en el prompt | Problemas con patrón conocido |
| Zero-shot CoT | "Pensemos paso a paso" | Tareas generales, sin ejemplos |
| CoT-SC | Múltiples cadenas + majority voting | Problemas de alta stake (mate, lógica) |
| Auto-CoT | Generación automática de ejemplos | Sin ejemplos disponibles |
| CoT + Code | Razonamiento en Python + ejecución | Problemas numéricos, simbólicos |
| Tree-of-Thoughts | Búsqueda en árbol con evaluación | Problemas que requieren exploración (planning, puzzles) |
| Program-of-Thought | Razonamiento como programa ejecutable | Problemas que requieren cómputo exacto |
| Structured CoT | Razonamiento en formato estructurado (JSON, listas) | Tareas que requieren extracción estructurada |

## Buenas prácticas

- Usar zero-shot CoT como baseline (es gratis y efectivo con modelos grandes)
- Para mejores resultados, usar few-shot CoT con 3-5 ejemplos representativos
- Añadir "Razonemos paso a paso" en español o el trigger que mejor funcione para tu modelo
- Usar CoT-SC con temperature = 0.5-0.7 y 5-10 muestras para problemas críticos
- Para problemas numéricos, preferir CoT + Code (generar y ejecutar Python)
- Validar que los pasos de razonamiento sean consistentes (no solo la respuesta final)
- Evitar cadenas demasiado largas (> 20 pasos) que pueden perder coherencia
- En modelos pequeños (< 7B parámetros), CoT puede no mejorar o incluso empeorar
- Para tareas no analíticas (creatividad, resumen, traducción), CoT puede ser innecesario
