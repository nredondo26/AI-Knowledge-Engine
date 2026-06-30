# 011-Patrones de Diseño

## Descripción del dominio

Los patrones de diseño son soluciones reutilizables y probadas para problemas recurrentes en el desarrollo de software. No son fragmentos de código listos para copiar, sino plantillas conceptuales que describen cómo estructurar clases, objetos e interacciones para resolver problemas específicos con un equilibrio entre flexibilidad, mantenibilidad y acoplamiento. El catálogo clásico (GoF) incluye 23 patrones categorizados en creacionales, estructurales y de comportamiento. A estos se suman patrones modernos surgidos del desarrollo concurrente, reactivo, funcional y de microservicios.

## Conceptos clave

- **SOLID**: cinco principios de diseño orientado a objetos (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion) que fundamentan muchos patrones.
- **Patrones creacionales**: controlan el proceso de creación de objetos (Singleton, Factory Method, Abstract Factory, Builder, Prototype).
- **Patrones estructurales**: definen cómo ensamblar clases y objetos en estructuras mayores (Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy).
- **Patrones de comportamiento**: gestionan algorítmos y responsabilidades entre objetos (Chain of Responsibility, Command, Interpreter, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor).
- **Inversión de dependencias (DIP)**: los módulos de alto nivel no deben depender de módulos de bajo nivel; ambos deben depender de abstracciones.
- **Composición sobre herencia**: favorecer la composición de objetos frente a la herencia de clases para lograr mayor flexibilidad en tiempo de ejecución.
- **Patrón Strategy**: permite seleccionar un algoritmo en tiempo de ejecución encapsulándolo en clases intercambiables.
- **Patrón Observer**: define una dependencia uno-a-muchos donde cuando un objeto cambia su estado, todos sus dependientes son notificados.
- **Patrón Decorator**: añade responsabilidades a un objeto dinámicamente sin modificar su clase.
- **Patrón Factory Method**: define una interfaz para crear un objeto pero permite que las subclases decidan qué clase instanciar.
- **Patrones modernos**: Dependency Injection, Repository, Unit of Work, Specification, CQRS, Saga, Circuit Breaker, Strangler Fig.
- **Anti-patrones**: soluciones que parecen atractivas pero generan problemas a largo plazo (God Class, Spaghetti Code, Golden Hammer, Boat Anchor).

## Tecnologías principales

- **Lenguajes OOP**: Java, C++, C#, Python, TypeScript, Kotlin, Swift, Ruby
- **Lenguajes funcionales**: Scala, Haskell, Elixir, F# (patrones funcionales: monads, functors, pattern matching)
- **Frameworks que implementan patrones**: Spring (DI, Proxy, Template Method), Hibernate (Repository, Unit of Work), ASP.NET Core (DI, Middleware)
- **Herramientas de análisis**: SonarQube, ArchUnit, PMD, NDepend, IntelliJ Inspections
- **Literatura clásica**: *Design Patterns: Elements of Reusable Object-Oriented Software* (GoF)

## Hoja de ruta

1. **Principiante**: aprender los principios SOLID; estudiar los patrones creacionales (Singleton, Factory, Builder) y aplicarlos en ejercicios pequeños; identificar cuándo un patrón es útil y cuándo es sobreingeniería.
2. **Intermedio**: dominar los patrones estructurales (Adapter, Decorator, Facade, Proxy) y de comportamiento (Strategy, Observer, Command, State); implementar Dependency Injection manual y con contenedores (Spring, Guice, .NET DI); refactorizar código heredado aplicando patrones.
3. **Avanzado**: combinar múltiples patrones en sistemas complejos; aplicar Repository + Unit of Work + Specification en la capa de persistencia; usar Event Sourcing + CQRS con patrones de mensajería; implementar Sagas y Circuit Breaker en microservicios.
4. **Experto**: diseñar DSLs internos usando patrón Interpreter; crear frameworks que expongan puntos de extensión mediante Template Method y Strategy; evaluar trade-offs entre patrones y alternativas (simplicidad vs. flexibilidad); enseñar y mentorizar con katas de diseño.

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — los patrones de diseño son el nivel táctico dentro de las decisiones arquitectónicas; Clean Architecture usa Dependency Inversion y se apoya en patrones GoF.
- [012-Testing](../012-Testing/) — los patrones facilitan el testing: Dependency Injection permite mocks, Observer permite espiar eventos, Factory permite objetos test doubles.
- [013-DevOps](../013-DevOps/) — patrones de despliegue como Blue/Green, Canary y Circuit Breaker se aplican en infraestructura.
- [015-Automation](../015-Automation/) — patrones como Strategy y Command se usan para diseñar motores de automatización flexibles.
- [016-RPA](../016-RPA/) — los patrones de diseño aplican a la arquitectura de bots RPA (Template Method para workflows, Strategy para selectores).
- [018-ERP](../018-ERP/) — los sistemas ERP implementan patrones como Domain Model, Repository, Service Layer y Aggregate.

## Recursos recomendados

- *Design Patterns: Elements of Reusable Object-Oriented Software* — Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides (GoF)
- *Head First Design Patterns* — Freeman, Robson, Bates, Sierra
- *Clean Code* — Robert C. Martin
- *Refactoring to Patterns* — Joshua Kerievsky
- *Patterns of Enterprise Application Architecture* — Martin Fowler
- *Domain-Driven Design* — Eric Evans
- *Design Patterns in Modern C++* — Dmitri Nesteruk
- *Game Programming Patterns* — Robert Nystrom
- *SourceMaking* (design patterns tutorials) — sourcemaking.com
- *Refactoring Guru* — refactoring.guru
