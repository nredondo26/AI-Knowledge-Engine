# Chain-of-Thought — Razonamiento Encadenado

## Concepto

**Chain-of-Thought (CoT)** es una técnica de prompting que induce al modelo a generar una secuencia de pasos de razonamiento intermedios antes de producir la respuesta final. En lugar de mapear directamente `entrada → salida`, el modelo genera `entrada → razonamiento → salida`, imitando el proceso cognitivo humano de resolver problemas paso a paso.

Introducida por Wei et al. (2022) en *"Chain-of-Thought Prompting Elicits Reasoning in Large Language Models"*, demostró mejoras dramáticas en tareas de razonamiento aritmético, simbólico y de sentido común.

## Mecanismo Interno

```
Sin CoT (mapeo directo):
  P: "Si Juan tiene 5 manzanas y da 2, ¿cuántas le quedan?"
  → R: "3" (saltándose el proceso)

Con CoT (razonamiento explícito):
  P: "Si Juan tiene 5 manzanas y da 2, ¿cuántas le quedan?"
  → R: "Juan empieza con 5 manzanas.
         Da 2 manzanas.
         Restamos: 5 - 2 = 3.
         A Juan le quedan 3 manzanas."
```

El CoT funciona porque:
1. **Distribuye la carga cognitiva**: El modelo "escribe" su memoria de trabajo.
2. **Corrige errores parciales**: Puede detectar contradicciones en su propio razonamiento.
3. **Hace visible el proceso**: Permite depurar y validar el razonamiento.

## Variantes de Chain-of-Thought

```
Chain-of-Thought
  │
  ├─► Zero-Shot CoT
  │     └─ "Piensa paso a paso"
  │
  ├─► Few-Shot CoT
  │     └─ Ejemplos de razonamiento paso a paso
  │
  ├─► Self-Consistency CoT
  │     └─ Múltiples cadenas + votación
  │
  ├─► Least-to-Most CoT
  │     └─ De subproblemas simples al complejo
  │
  ├─► Tree-of-Thought (ToT)
  │     └─ Exploración en árbol con branching
  │
  └─► Contrastive CoT
        └─ Compara razonamiento correcto vs incorrecto
```

## Implementaciones

### 1. Zero-Shot CoT

La técnica más simple: añadir "Piensa paso a paso" al prompt.

```python
from openai import OpenAI

client = OpenAI()

def zero_shot_cot(pregunta):
    resp = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{
            "role": "user",
            "content": f"{pregunta}\n\nPiensa paso a paso."
        }],
        temperature=0
    )
    return resp.choices[0].message.content

# Ejemplo
problema = """
Un tren sale de Madrid a 80 km/h. Dos horas después, otro tren sale de Barcelona
a 120 km/h hacia Madrid. Si la distancia entre Madrid y Barcelona es de 600 km,
¿cuánto tiempo tardarán en encontrarse desde que salió el segundo tren?
"""
print(zero_shot_cot(problema))
```

### 2. Few-Shot CoT

Proporciona ejemplos de razonamiento paso a paso.

```python
def few_shot_cot(pregunta):
    mensajes = [
        {"role": "system", "content": "Resuelve problemas paso a paso."},
        {"role": "user", "content": "Si 3 lápices cuestan 6€, ¿cuánto cuestan 5 lápices?"},
        {"role": "assistant", "content": """Paso 1: 3 lápices cuestan 6€.
Paso 2: Cada lápiz cuesta 6/3 = 2€.
Paso 3: 5 lápices cuestan 5 × 2 = 10€.
Respuesta: 10€."""},
        {"role": "user", "content": "Un rectángulo tiene 20cm de perímetro. Si el ancho es 4cm, ¿cuál es el largo?"},
        {"role": "assistant", "content": """Paso 1: Perímetro = 2 × (largo + ancho) = 20cm.
Paso 2: 2 × (largo + 4) = 20.
Paso 3: largo + 4 = 10.
Paso 4: largo = 6cm.
Respuesta: 6cm."""},
        {"role": "user", "content": pregunta}
    ]
    resp = client.chat.completions.create(model="gpt-4o-mini", messages=mensajes)
    return resp.choices[0].message.content
```

### 3. Self-Consistency CoT

Genera múltiples cadenas de razonamiento y agrega resultados por mayoría.

```python
import re
from collections import Counter

def self_consistency_cot(pregunta, n_cadenas=5):
    todas_respuestas = []

    for i in range(n_cadenas):
        resp = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{
                "role": "user",
                "content": f"{pregunta}\n\nPiensa paso a paso y termina con 'Respuesta: X'"
            }],
            temperature=0.7 + (i * 0.05)  # variar temperatura
        )
        texto = resp.choices[0].message.content

        # Extraer respuesta final
        match = re.search(r"Respuesta:\s*(\d+(?:\.\d+)?)", texto)
        if match:
            todas_respuestas.append(match.group(1))
        todas_respuestas.append(texto.split("Respuesta:")[-1].strip() if "Respuesta:" in texto else texto)

    # Votación mayoritaria
    conteo = Counter(todas_respuestas)
    respuesta_final = conteo.most_common(1)[0][0]
    agreement = conteo.most_common(1)[0][1] / n_cadenas

    return {
        "respuesta": respuesta_final,
        "acuerdo": agreement,
        "todas": todas_respuestas
    }

resultado = self_consistency_cot("Un granjero tiene 15 patos y 12 vacas. ¿Cuántas patas hay en total?", n_cadenas=7)
print(f"Respuesta: {resultado['respuesta']} (acuerdo: {resultado['acuerdo']:.0%})")
```

## Evaluación de CoT

| Métrica | Descripción | Medición |
|---------|-------------|----------|
| Exactitud | % de respuestas correctas | `correctas / total` |
| Fidelidad | ¿El razonamiento justifica la respuesta? | Evaluación humana o LLM |
| Pasos correctos | % de pasos lógicos válidos | Anotación manual |
| Robustez | Rendimiento ante reformulaciones | Variación de prompts |

```python
def evaluar_cot(problemas, ground_truth, metodo_cot):
    aciertos = 0
    for prob, gt in zip(problemas, ground_truth):
        resp = metodo_cot(prob)
        # Extraer respuesta numérica
        match = re.search(r"Respuesta:\s*(\d+(?:\.\d+)?)", resp)
        if match and match.group(1) == str(gt):
            aciertos += 1
    return aciertos / len(problemas)
```

## Buenas Prácticas

1. **Prompts claros**: "Piensa paso a paso" funciona, pero "Explica tu razonamiento en pasos numerados" es mejor.
2. **Temperatura baja** (0-0.3) para tareas lógicas; más alta (>0.5) para CoT con self-consistency.
3. **Formato consistente**: Usa siempre "Paso 1:", "Paso 2:", etc.
4. **Verificación**: Siempre que sea posible, añade un paso de verificación.
5. **Longitud suficiente**: El modelo necesita espacio para "pensar" (más tokens de output).

```python
# Prompt optimizado para CoT
prompt_cot = """{pregunta}

IMPORTANTE: Sigue este formato exactamente:

Paso 1: [Identificar los datos del problema]
Paso 2: [Determinar la operación necesaria]
Paso 3: [Realizar el cálculo]
Paso 4: [Verificar que el resultado tiene sentido]
Respuesta: [solo el número o respuesta final]
"""
```
