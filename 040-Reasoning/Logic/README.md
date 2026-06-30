# Razonamiento Lógico en IA

## Descripción del dominio

El razonamiento lógico en inteligencia artificial trata de formalizar el conocimiento y derivar conclusiones mediante reglas de inferencia válidas. Abarca desde la lógica proposicional (Boolean algebra) hasta la lógica de primer orden (predicados, cuantificadores), pasando por lógicas no clásicas (modal, temporal, descriptiva, difusa, no monotónica). El razonamiento lógico es la base de los sistemas expertos, la representación del conocimiento (Knowledge Representation), la planificación automática, la verificación formal y la semántica de lenguajes de programación.

## Áreas clave

- **Lógica proposicional**: Proposiciones atómicas, conectores lógicos (∧, ∨, ¬, →, ↔), tablas de verdad, tautologías, contradicciones, equivalencias lógicas, formas normales (CNF, DNF), satisfacibilidad (SAT)
- **Lógica de primer orden (FOL)**: Constantes, variables, predicados, funciones, cuantificadores (∀, ∃), términos, fórmulas bien formadas, unificación, forma normal de Skolem, cláusulas de Horn
- **Resolución y refutación**: Regla de resolución (Robinson, 1965), refutación por resolución, estrategias de resolución (lineal, unitaria, entrada), paramodulación, resolución con igualdad
- **Deductivos y probadores automáticos**: Tableaux semánticos, resolución, cálculo de secuentes, conexión method, SAT solvers (DPLL, CDCL), SMT solvers (Z3, CVC5), theorem provers (Vampire, E Prover)
- **Lógica descriptiva (Description Logic)**: Base de ontologías y OWL (Web Ontology Language). Conceptos, roles, individuos. Razonadores: Pellet, HermiT, ELK. Lógica de subsumción y clasificación
- **Lógica no monotónica**: Negación por fallo (negation as failure), circunscripción (McCarthy), default logic (Reiter), lógica autoepistémica. Manejo de incertidumbre e información incompleta
- **Lógica temporal**: LTL (Linear Temporal Logic), CTL (Computation Tree Logic). Operadores: G (globally), F (finally), X (next), U (until). Verificación de modelos (model checking, SPIN, NuSMV)
- **Lógica modal**: Modalidades: □ (necesidad), ◇ (posibilidad). Lógicas modales normales (K, T, S4, S5). Aplicaciones: epistemología (saber), deóntica (obligación), temporal, espacial
- **Lógica difusa (Fuzzy Logic)**: Grados de verdad [0,1]. Conectores difusos (T-norma, S-norma), implicación difusa, sistema de inferencia Mamdani, Sugeno. Control difuso en sistemas embebidos
- **PROLOG**: Lenguaje de programación lógica. Hechos, reglas, consultas, unificación, backtracking, corte (!), negación por fallo. CHR (Constraint Handling Rules), CLP (Constraint Logic Programming)

## Ejemplo: Resolución en lógica proposicional

```prolog
% PROLOG: parentesco
hecho(padre(juan, maria)).
hecho(padre(juan, pedro)).
hecho(padre(maria, ana)).

% Regla: X es abuelo de Y si X es padre de Z y Z es padre de Y
abuelo(X, Y) :- padre(X, Z), padre(Z, Y).

% Consulta
?- abuelo(juan, ana).   % true
?- abuelo(juan, Quien). % Quien = ana
```

## Ejemplo: SAT solver con Z3 (SMT)

```python
from z3 import *

# Problema: ¿existe asignación que satisfaga (a ∨ b) ∧ (¬a ∨ ¬b)?
a, b = Bools('a b')
s = Solver()
s.add(Or(a, b))
s.add(Or(Not(a), Not(b)))

if s.check() == sat:
    m = s.model()
    print(f"a = {m[a]}, b = {m[b]}")  # a = True, b = False o viceversa
```

## Tecnologías principales

| Herramienta | Descripción |
|-------------|-------------|
| Z3 (Microsoft) | SMT solver, lógica de primer orden, aritmética, arrays, strings |
| CVC5 | SMT solver, sucesor de CVC4, soporte para lógicas múltiples |
| Vampire | Theorem prover de primer orden, ganador de CASC |
| E Prover | Theorem prover de alto rendimiento |
| SPASS | Prover de primer orden con igualdad |
| Prover9 / Mace4 | Prover + contramodel finder |
| SPIN / NuSMV | Model checkers (verificación de sistemas concurrentes) |
| SWI-Prolog | Intérprete PROLOG moderno con librerías (CHR, CLP, web) |
| Pellet / HermiT | Razonadores OWL/DL para ontologías |
| Trino / Drools | Motores de reglas de producción (Rete algorithm) |

## Buenas prácticas

- Usar lógica proposicional para problemas de decisión (SAT) con herramientas como Z3 o MiniSat
- Para representación de conocimiento estructurado, preferir OWL + razonador (Pellet/HermiT)
- PROLOG es ideal para problemas con reglas lógicas, búsqueda y backtracking
- SMT solvers (Z3) para verificación de programas, scheduling y problemas con restricciones
- Lógica temporal (LTL) para especificación y verificación de sistemas reactivos
- Lógica difusa para control en sistemas con variables continuas y reglas lingüísticas
- Documentar axiomas y reglas lógicas formalmente para mantener consistencia
- Evaluar complejidad: SAT es NP-completo, FOL es semidecidible, DL está en EXPTIME

## Referencias

- *Artificial Intelligence: A Modern Approach* (Russell & Norvig) — capítulos de lógica
- *Knowledge Representation and Reasoning* (Brachman, Levesque) — texto completo
- *Handbook of Practical Logic and Automated Reasoning* (Harrison)
- Z3 Guide: https://rise4fun.com/z3/tutorial
- SWI-Prolog Documentation: https://www.swi-prolog.org
- OWL 2 Web Ontology Language: https://www.w3.org/TR/owl2-overview/
