# 012-Testing

## Descripción del dominio

El testing de software es el proceso de evaluar y verificar que un sistema cumple con los requisitos esperados y no presenta defectos. Abarca múltiples niveles (unitario, integración, sistema, aceptación) y enfoques (manual, automatizado, funcional, no funcional). Las metodologías modernas como TDD (Test-Driven Development) y BDD (Behavior-Driven Development) integran las pruebas en el flujo de desarrollo desde el inicio, mejorando la calidad, reduciendo el costo de los defectos y proporcionando una red de seguridad para la refactorización continua.

## Conceptos clave

- **Prueba unitaria**: verifica el comportamiento de la unidad más pequeña del software (función, método, clase) de forma aislada, usando mocks o stubs para las dependencias externas.
- **Prueba de integración**: valida que varios módulos o servicios funcionen correctamente al interactuar entre sí, incluyendo bases de datos, APIs y sistemas de archivos.
- **Prueba E2E (End-to-End)**: simula el flujo completo del usuario a través de toda la aplicación, desde la interfaz de usuario hasta la base de datos, pasando por todos los servicios intermedios.
- **TDD (Test-Driven Development)**: ciclo de desarrollo donde primero se escribe una prueba que falla, luego el código mínimo para que pase, y finalmente se refactoriza (Red-Green-Refactor).
- **BDD (Behavior-Driven Development)**: extensión de TDD que describe el comportamiento esperado del sistema en lenguaje natural usando el formato Given-When-Then, con herramientas como Cucumber o SpecFlow.
- **Mock**: objeto simulado que imita el comportamiento de una dependencia real, permitiendo verificar interacciones (qué métodos se llamaron, con qué argumentos).
- **Stub**: objeto que proporciona respuestas predefinidas a las llamadas durante la prueba, sin verificar interacciones.
- **Fixture**: conjunto de datos o estado predefinido necesario para ejecutar una prueba de manera consistente.
- **Cobertura (coverage)**: métrica que indica qué porcentaje del código (líneas, ramas, funciones) está siendo ejecutado por las pruebas.
- **Pirámide de testing**: modelo que recomienda muchos tests unitarios (base), menos tests de integración (medio) y pocos tests E2E (cima), maximizando la velocidad y la confianza.
- **Prueba de regresión**: conjunto de pruebas que se ejecutan tras cada cambio para asegurar que las funcionalidades existentes no se rompan.
- **Prueba de humo (smoke test)**: conjunto mínimo de pruebas rápidas que verifican que las funcionalidades críticas del sistema funcionan antes de proceder con pruebas más profundas.
- **Property-Based Testing**: enfoque donde se definen invariantes o propiedades que deben cumplirse para un rango amplio de entradas generadas automáticamente (p.ej., con Hypothesis o QuickCheck).

## Tecnologías principales

- **Unitarios**: JUnit (Java), pytest (Python), Jest (JS/TS), NUnit/xUnit (.NET), RSpec (Ruby), Go testing
- **Mocking**: Mockito (Java), unittest.mock (Python), Jest mocks (JS/TS), Moq (.NET), gomock (Go)
- **BDD**: Cucumber, SpecFlow, Behave (Python), Jasmine, Mocha
- **E2E**: Selenium, Cypress, Playwright, Puppeteer, TestCafe
- **Cobertura**: JaCoCo (Java), coverage.py, Istanbul (JS/TS), OpenCover (.NET)
- **Integración/API**: REST Assured, Postman/Newman, Supertest, Karate, WireMock
- **Property-Based**: Hypothesis (Python), fast-check (JS/TS), jqwik (Java)
- **CI integración**: Jenkins, GitHub Actions, GitLab CI, CircleCI

## Hoja de ruta

1. **Principiante**: escribir pruebas unitarias simples con asserts; entender asserts, test runners y fixtures; usar mocks y stubs básicos; ejecutar pruebas localmente y en CI; medir cobertura básica.
2. **Intermedio**: aplicar TDD sistemáticamente (Red-Green-Refactor); escribir pruebas de integración con bases de datos reales o en memoria; usar BDD para describir funcionalidades en lenguaje de negocio; organizar suites por categorías (unitarias, integración, lentas).
3. **Avanzado**: diseñar pruebas E2E con patrones Page Object y API testing; implementar property-based testing para detectar casos borde; aplicar mutation testing para evaluar la calidad de las pruebas; optimizar tiempos de ejecución con paralelización y test sharding.
4. **Experto**: integrar tests de seguridad (SAST, DAST) y rendimiento (carga, estrés) en el pipeline; diseñar estrategias de testing para microservicios (contract testing con Pact); incorporar pruebas de caos (Chaos Engineering); definir políticas de calidad y umbrales de cobertura por equipo.

## Relaciones con otros módulos

- [010-Architecture](../010-Architecture/) — la arquitectura (hexagonal, clean) determina la testabilidad: inversión de dependencias y puertos facilitan mocks y pruebas aisladas.
- [011-DesignPatterns](../011-DesignPatterns/) — patrones como Dependency Injection, Factory y Observer hacen el código más testeable.
- [013-DevOps](../013-DevOps/) — las pruebas se integran en los pipelines de CI/CD; la calidad se monitorea en dashboards de observabilidad.
- [014-CICD](../014-CICD/) — cada etapa del pipeline ejecuta distintos niveles de prueba (unitarias rápidas primero, integración después, E2E en paralelo).
- [015-Automation](../015-Automation/) — automatización de la ejecución de pruebas, generación de reportes y gestión de entornos de prueba.
- [016-RPA](../016-RPA/) — las pruebas de bots RPA requieren simulación de entradas y verificación de salidas automatizadas.
- [018-ERP](../018-ERP/) — el testing de módulos ERP implica datos maestros, configuraciones y flujos de negocio complejos.
- [019-CRM](../019-CRM/) — las integraciones con CRM requieren pruebas de conectividad, sincronización y transformación de datos.

## Recursos recomendados

- *Test-Driven Development: By Example* — Kent Beck
- *Working Effectively with Legacy Code* — Michael Feathers
- *xUnit Test Patterns* — Gerard Meszaros
- *The Art of Unit Testing* — Roy Osherove
- *Growing Object-Oriented Software, Guided by Tests* — Steve Freeman, Nat Pryce
- *Specification by Example* — Gojko Adzic
- *Property-Based Testing with PropEr, Erlang QuickCheck* — Fred Hebert
- *Continuous Delivery* — Jez Humble, David Farley
