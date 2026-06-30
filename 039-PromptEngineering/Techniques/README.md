# Techniques — Técnicas Avanzadas de Prompt Engineering

## Concepto

**Prompt Engineering** es la disciplina de diseñar y optimizar instrucciones para modelos de lenguaje (LLMs) con el fin de obtener respuestas precisas, relevantes y controlables. No se trata solo de "escribir prompts", sino de aplicar principios sistemáticos de comunicación, psicología cognitiva y arquitectura de modelos para guiar eficazmente el comportamiento del LLM.

Las técnicas de prompting transforman un LLM genérico en un experto especializado, un razonador lógico, un traductor preciso o cualquier otro rol deseado.

## Taxonomía de Técnicas

```
Prompt Engineering
  │
  ├─► Técnicas de Instrucción
  │     ├─ Zero-Shot
  │     ├─ Few-Shot
  │     ├─ System Prompting
  │     └─ Role Prompting
  │
  ├─► Técnicas de Razonamiento
  │     ├─ Chain-of-Thought (CoT)
  │     ├─ Tree-of-Thought (ToT)
  │     ├─ Self-Consistency
  │     └─ Least-to-Most
  │
  ├─► Técnicas de Estructura
  │     ├─ Structured Output (JSON/XML/YAML)
  │     ├─ Template Prompting
  │     └─ Delimitadores
  │
  ├─► Técnicas de Refinamiento
  │     ├─ Iterative Prompting
  │     ├─ Chain-of-Density
  │     ├─ Self-Refine
  │     └─ Prompt Chaining
  │
  └─► Técnicas Avanzadas
        ├─ ReAct (Reasoning + Acting)
        ├─ Reflexion
        ├─ Active Prompting
        └─ Metaprompting
```

## Técnicas Fundamentales

### 1. Zero-Shot Prompting

El LLM realiza una tarea sin ejemplos previos. La clave está en la claridad y especificidad.

```python
from openai import OpenAI

client = OpenAI()

# Zero-shot básico
resp = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[{
        "role": "user",
        "content": "Clasifica el sentimiento de este texto como positivo, negativo o neutral:\n\n'El producto superó mis expectativas. La entrega fue rápida y el soporte excelente.'"
    }]
)
print(resp.choices[0].message.content)  # "Positivo"

# Zero-shot con instrucciones estructuradas
resp = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[{
        "role": "system",
        "content": "Eres un clasificador de texto. Responde ÚNICAMENTE con el nombre de la categoría en español."
    }, {
        "role": "user",
        "content": "Texto: 'El servicio al cliente fue terrible. Esperé 2 horas.'\nCategorías: [positivo, negativo, neutral]\nCategoría:"
    }]
)
```

### 2. Few-Shot Prompting

Proporciona ejemplos (shots) para que el modelo aprenda el patrón.

```python
def few_shot_clasificar(texto):
    mensajes = [
        {"role": "system", "content": "Clasifica el texto en la categoría correcta."},
        {"role": "user", "content": "Texto: 'Me encanta este producto'\nCategoría: Positivo"},
        {"role": "assistant", "content": "Positivo"},
        {"role": "user", "content": "Texto: 'No funciona como esperaba'\nCategoría: Negativo"},
        {"role": "assistant", "content": "Negativo"},
        {"role": "user", "content": "Texto: 'El color es azul'\nCategoría: Neutral"},
        {"role": "assistant", "content": "Neutral"},
        {"role": "user", "content": f"Texto: '{texto}'\nCategoría:"}
    ]
    resp = client.chat.completions.create(model="gpt-4o-mini", messages=mensajes)
    return resp.choices[0].message.content

print(few_shot_clasificar("La calidad es aceptable pero mejorable"))  # Neutral
```

### 3. Role Prompting (Persona Pattern)

Asigna un personaje o rol específico al modelo.

```python
def role_prompt(tarea, rol, contexto):
    prompt = f"""
Actúa como {rol}. Tienes las siguientes características:
- Experiencia: 20 años en el campo
- Estilo: Explicaciones claras con analogías
- Audiencia: Estudiantes universitarios

Tu tarea: {tarea}

Contexto: {contexto}
"""
    return client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}]
    ).choices[0].message.content

# Ejemplo
print(role_prompt(
    "Explica el concepto de embeddings vectoriales",
    "profesor de IA de universidad top-10",
    "Los estudiantes ya conocen álgebra lineal básica"
))
```

### 4. Structured Output Prompting

Fuerza al modelo a devolver estructuras de datos específicas.

```python
import json
from pydantic import BaseModel

class AnalisisTexto(BaseModel):
    sentimiento: str  # positivo, negativo, neutral
    tono: str  # formal, informal, sarcástico
    palabras_clave: list[str]
    score: float  # -1 a 1

def analizar_estructurado(texto):
    resp = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{
            "role": "system",
            "content": "Devuelve un objeto JSON con el análisis del texto."
        }, {
            "role": "user",
            "content": f"""Analiza este texto y devuelve JSON:
{{
  "sentimiento": "positivo|negativo|neutral",
  "tono": "formal|informal|sarcástico",
  "palabras_clave": ["...", "..."],
  "score": 0.75
}}

Texto: "{texto}"
"""
        }],
        response_format={"type": "json_object"}
    )
    datos = json.loads(resp.choices[0].message.content)
    return AnalisisTexto(**datos)

resultado = analizar_estructurado("Increíble, justo lo que necesitaba. Gracias.")
print(f"Sentimiento: {resultado.sentimiento} | Score: {resultado.score}")
```

## Comparativa de Técnicas

| Técnica | Cuándo usarla | Ventaja | Desventaja |
|---------|--------------|---------|------------|
| Zero-Shot | Tareas simples | Mínimo esfuerzo | Baja precisión en tareas complejas |
| Few-Shot | Tareas con patrón claro | Alta precisión | Costo por tokens de ejemplos |
| CoT | Razonamiento matemático/lógico | Mejora precisión 10-30% | Respuestas más largas |
| Self-Consistency | Preguntas ambiguas | Robusteza estadística | Costo N veces |
| ReAct | Tareas multi-paso | Combina razón + acción | Complejo de implementar |

## Buenas Prácticas Generales

1. **Sé específico**: "Escribe un poema de 4 versos sobre IA" > "Escribe un poema"
2. **Usa delimitadores**: `###`, ```, `---` para separar instrucciones de entrada
3. **Un paso a la vez**: No mezcles múltiples instrucciones en un prompt
4. **Proporciona formato de salida**: "Responde en JSON con campos: X, Y, Z"
5. **Itera**: Prueba variaciones y mide resultados

```python
# Ejemplo de prompt optimizado
prompt_optimo = """
Contexto: {contexto}

Instrucciones:
1. Lee el contexto cuidadosamente
2. Responde SOLO si encuentras evidencia en el contexto
3. Si no hay suficiente información, di "No hay suficiente información"

Pregunta: {pregunta}

Formato de respuesta:
- Respuesta directa (máximo 2 oraciones)
- Cita textual del contexto (entre comillas)
"""
```
