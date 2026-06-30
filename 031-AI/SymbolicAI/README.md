# IA Simbólica (SymbolicAI)

## Descripción del dominio

La IA Simbólica, también conocida como IA clásica o GOFAI (Good Old-Fashioned AI), se basa en la manipulación de símbolos y reglas lógicas para representar conocimiento y razonar. Fue el paradigma dominante desde los años 50 hasta los 80, con aplicaciones como sistemas expertos, demostradores automáticos de teoremas y procesamiento de lenguaje natural basado en reglas. A diferencia del conexionismo, la IA simbólica ofrece transparencia total: cada decisión puede ser rastreada a reglas explícitas.

## Conceptos clave

- **Símbolo**: Representación discreta de un concepto (ej: `Animal`, `Perro`, `Mamífero`).
- **Lógica Proposicional**: Variables booleanas conectadas por operadores lógicos (∧, ∨, ¬, →).
- **Lógica de Primer Orden**: Predicados, cuantificadores (∀, ∃), funciones. Más expresiva que la lógica proposicional.
- **Sistema Experto**: Programa que emula el conocimiento de un experto humano usando reglas if-then y un motor de inferencia.
- **Motor de Inferencia**: Mecanismo que aplica reglas a una base de hechos para derivar conclusiones (encadenamiento hacia adelante o hacia atrás).
- **Ontología**: Representación formal de un dominio de conocimiento: clases, propiedades, relaciones, axiomas.
- **Razonamiento Basado en Casos (CBR)**: Resolver nuevos problemas adaptando soluciones de problemas similares previos.
- **Planificación**: Generación automática de secuencias de acciones para alcanzar un objetivo (STRIPS, PDDL).

## Ejemplo: Sistema Experto simple

```python
class SistemaExperto:
    def __init__(self):
        self.reglas = []
        self.hechos = set()

    def agregar_regla(self, condiciones, conclusion):
        self.reglas.append((set(condiciones), conclusion))

    def agregar_hecho(self, hecho):
        self.hechos.add(hecho)

    def inferir(self):
        cambios = True
        while cambios:
            cambios = False
            for condiciones, conclusion in self.reglas:
                if condiciones.issubset(self.hechos) and conclusion not in self.hechos:
                    self.hechos.add(conclusion)
                    cambios = True
        return self.hechos

motor = SistemaExperto()
motor.agregar_hecho("tiene_plumas")
motor.agregar_hecho("vuela")
motor.agregar_regla(["tiene_plumas", "vuela"], "es_ave")
motor.agregar_regla(["es_ave", "no_vuela"], "es_pinguino")
resultados = motor.inferir()
print(resultados)
```

## Ejemplo: Lógica de Primer Orden con SymPy

```python
from sympy.logic import simplify_logic, to_dnf
from sympy import symbols

# Variables proposicionales
llueve, mojado, nublado = symbols('llueve mojado nublado')

# Reglas: si llueve entonces mojado, si nublado entonces puede llover
expr = (llueve >> mojado) & (nublado >> llueve)
print(f"Expresión original: {expr}")
print(f"Forma DNF: {to_dnf(expr)}")
print(f"Simplificada: {simplify_logic(expr)}")
```

## Tecnologías principales

- **Prolog**: Lenguaje de programación lógica. SWI-Prolog, GNU Prolog.
- **CLIPS**: Sistema experto en C, usado por NASA.
- **Drools**: Sistema experto para Java (Red Hat).
- **OWL/RDF**: Ontologías para la Web Semántica. Protégé, Apache Jena.
- **PDDL**: Lenguaje de planificación. Planers: Fast Downward, FF.
- **SymPy**: Lógica simbólica en Python.
- **Z3**: Demostrador de teoremas SMT (Microsoft Research).

## Hoja de ruta

1. Fundamentos de lógica proposicional y de primer orden.
2. Implementar encadenamiento hacia adelante y hacia atrás.
3. Construir un sistema experto pequeño con CLIPS o Pyke.
4. Modelar una ontología simple con Protégé y OWL.
5. Implementar un planificador básico (STRIPS).
6. Explorar demostradores automáticos de teoremas (Z3).
7. Estudiar limitaciones: marco de la representación, calificación, ramificación.

## Relaciones con otros módulos

- `../Approaches/`: La IA simbólica como uno de los grandes enfoques.
- `../NeuroSymbolic/`: Integración de lógica simbólica con redes neuronales.
- `../../040-Reasoning/`: Extensiones modernas del razonamiento simbólico.
- `../../058-KnowledgeGraph/`: Grafos de conocimiento basados en ontologías.

## Recursos recomendados

- **Libro**: "Knowledge Representation and Reasoning" (Brachman, Levesque).
- **Libro**: "Programming in Prolog" (Clocksin, Mellish).
- **Curso**: "CS221: Artificial Intelligence: Principles and Techniques" (Stanford).
- **Documentación**: SWI-Prolog manual, CLIPS User Guide.
- **Repositorio**: awesome-prolog (GitHub).
