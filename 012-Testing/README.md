# 012-Testing: Pruebas de Software

## Descripción ampliada del dominio

Las pruebas de software verifican que el sistema cumple con los requisitos especificados, detectan defectos temprano, y proporcionan confianza en la calidad del producto. Este módulo cubre la teoría y práctica de testing: pirámide de pruebas (unitarias, integración, E2E), tipos (funcionales, no funcionales, regresión, humo, aceptación, exploratorio), técnicas (caja negra, caja blanca, caja gris), automatización, TDD/BDD, mocking, cobertura, y herramientas del ecosistema moderno. La evolución del testing: de pruebas manuales (1980s-90s) a automatización (2000s), TDD (2003, Kent Beck), BDD (2006, Dan North), pruebas continuas en CI/CD (2010s), y testing impulsado por IA (2020s, generación automática de tests). La "pirámide de pruebas" (Mike Cohn, 2009) establece que debe haber muchas pruebas unitarias rápidas, menos pruebas de integración, y pocas pruebas E2E lentas. El testing no es solo un rol: es una responsabilidad de todo desarrollador. Las pruebas automatizadas son inversión, no gasto: pagan dividendos en calidad, velocidad de desarrollo y confianza para refactorizar.

## Tabla de conceptos clave

| Concepto | Descripción | Frameworks/Herramientas |
|----------|-------------|------------------------|
| Prueba unitaria | Verifica una unidad aislada del código (función, método, clase) | Jest, pytest, JUnit, NUnit, Mocha, RSpec |
| Prueba de integración | Verifica interacción entre unidades/módulos/sistemas | Spring Test, Testcontainers, Supertest, pytest-django |
| Prueba E2E | Verifica flujo completo del sistema desde UI | Cypress, Playwright, Selenium, Puppeteer, TestCafe |
| Prueba de API | Verifica endpoints HTTP, contratos REST/GraphQL | Postman, REST Assured, Supertest, Newman |
| Prueba de regresión | Verifica que cambios no rompen funcionalidad existente | Automatización de toda la suite de pruebas |
| Prueba de aceptación | Verifica que el sistema cumple criterios de negocio | Cucumber, SpecFlow, FitNesse, Behat |
| Prueba de carga/rendimiento | Verifica comportamiento bajo estrés y carga | k6, JMeter, Locust, Gatling, Artillery |
| Prueba de seguridad | Verifica vulnerabilidades de seguridad | OWASP ZAP, Burp Suite, SonarQube (SAST) |
| Prueba de humo (Smoke) | Verificación rápida de funcionalidades críticas | Test suite mínimo, post-deploy |
| Prueba exploratoria | Testing manual sin script, descubrimiento de bugs | Manual + herramientas de grabación |
| TDD (Test-Driven Development) | Escribir test antes del código: Red → Green → Refactor | Todos los frameworks de testing |
| BDD (Behavior-Driven Development) | Pruebas en lenguaje natural (Given/When/Then) | Cucumber, SpecFlow, behave, jbehave |

## Tecnologías principales

| Lenguaje | Frameworks de testing | Mocking/Stubbing | Coverage | Assertions |
|----------|----------------------|-------------------|----------|------------|
| Python | pytest, unittest, nose2 | unittest.mock, pytest-mock, moto | coverage.py, pytest-cov | pytest assert, hamcrest |
| JavaScript/TypeScript | Jest, Vitest, Mocha, Jasmine | Jest mock, sinon.js, nock | c8, Istanbul, Jest --coverage | Jest expect, chai |
| Java/Kotlin | JUnit 5, TestNG | Mockito, EasyMock, WireMock, MockServer | JaCoCo, jacoco-maven-plugin | AssertJ, Hamcrest |
| Go | testing (stdlib), testify, ginkgo | testify/mock, minimock, sqlmock | go test -cover, goveralls | testify/assert |
| Rust | cargo test, rstest | mockall, mockito, fake, proptest | tarpaulin, llvm-cov | assert, assert_eq |
| Ruby | RSpec, Minitest | rspec-mocks, webmock, vcr | simplecov | rspec-expectations |
| C# | xUnit, NUnit, MSTest | Moq, NSubstitute, FakeItEasy | Coverlet, dotCover | FluentAssertions |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos: qué es un test, valor de los tests, tipos de tests según la pirámide. Pruebas unitarias: estructura (Arrange, Act, Assert — AAA), naming (test_method_expectedBehavior), asserts básicos (assertEquals, assertTrue). Correr tests desde CLI y desde IDE. Aislar unidades: stubs y mocks básicos (reemplazar dependencias externas). Coverage: entender línea, rama, función — usar herramienta de coverage (pytest-cov, Jest --coverage). Red-Green-Refactor en TDD. Tests parametrizados. Excepciones y edge cases (null, valores límite, strings vacíos). Test doubles: Stub (retorna datos fijos), Mock (verifica interacciones), Fake (implementación ligera funcional), Dummy (parámetro pasado pero no usado), Spy (registra interacciones).
   - Práctica: Escribir tests unitarios para módulo de negocio (cálculos, validaciones). Configurar coverage. Hacer TDD para una función simple.
   - Lectura: "Test-Driven Development by Example" (Beck), pytest docs / JUnit docs.

2. **Intermedio (2-6 meses)**: Pruebas de integración: base de datos (Testcontainers, Django test DB), APIs HTTP (Supertest, REST Assured, WebTest), sistema de archivos (tempfile, mock filesystem). Mocks avanzados: Mockito (verify, times, any(), eq(), argument captors), pytest-mock (mocker fixture, patch context manager). Fakes y test containers: contenedores Docker para dependencias (PostgreSQL, Redis, Kafka, Elasticsearch) con Testcontainers, LocalStack para AWS. Pruebas de API: Postman collections, Newman (CLI), schemas OpenAPI contract testing, status codes, headers, body schema validation. Parametrized tests: múltiples inputs y outputs, fuzzing básico. Test fixtures: setUp/tearDown, conftest.py (pytest), @Before/@After (JUnit). Hierarchical tests: describe/groups en Jest/Mocha, Nested contexts en RSpec. BDD: Given/When/Then con Cucumber/behave, step definitions. Prueba de snapshot/testing de UI components.
   - Proyecto: Suite completa de tests unitarios + integración para API REST. Dockerizar tests con Testcontainers. BDD para un flujo de negocio.
   - Lectura: "xUnit Test Patterns" (Meszaros), "Growing Object-Oriented Software Guided by Tests" (Freeman, Pryce).

3. **Avanzado (6-12 meses)**: Pruebas E2E: Playwright/Cypress (web), Detox (React Native mobile), Appium (mobile). Page Object Model (POM) para organización. Fixtures y contextos en E2E. Screenshot diff testing (percy, Applitools). Test retry, flakiness detection, parallel execution. Contract testing: Pact (consumer-driven contract tests), Spring Cloud Contract, JSON Schema validation, gRPC contract testing. Performance testing: k6 (scripting en JS, thresholds, metrics), JMeter (test plans, assertions, listeners), Locust (Python, distributed), Gatling (Scala). Chaos testing: Chaos Monkey, Chaos Mesh, Litmus, Gremlin — inyectar fallos para probar resiliencia. Mutation testing: PIT (Java), MutPy (Python), Stryker (JS) — mutar código para validar que tests detectan errores. Property-based testing: Hypothesis (Python), fast-check (JS), QuickTheories (Java), proptest (Rust). Fuzzing: AFL++, libFuzzer, OSS-Fuzz. Prueba de seguridad en CI/CD: SAST (Semgrep, CodeQL, SonarQube), SCA (Snyk, Dependabot), secret scanning.
   - Proyecto: E2E tests con Playwright + visual regression. Performance tests con k6 para API. Contract tests con Pact en pipelines CI.
   - Lectura: "Continuous Delivery" (Humble, Farley) capítulo testing, Playwright docs, k6 docs.

4. **Experto (12+ meses)**: Estrategias de testing en microservicios: test pyramids adaptadas (contract tests, consumer-driven contracts, component tests, integration tests with Testcontainers). Testing en arquitecturas event-driven: testing de streams (Kafka test containers, schema registry), idempotency tests, outbox pattern testing. AI for testing: generación automática de tests (Copilot, Diffblue, EvoSuite, TestSpark), AI-powered test maintenance, self-healing tests (Mabl, Testim, Functionize). Observability-driven testing: OpenTelemetry + tests, trace-based testing. Quality gates en CI/CD: coverage thresholds, mutation score gates, flaky test detection and quarantine, test impact analysis (solo correr tests afectados por cambios). Meta-testing: testing de los propios tests (mutation score, coverage del test suite), test smells. Chaos engineering como testing de producción. Performance regression testing: benchmark comparison (JMH, pyperf), flame graph analysis. Security regression testing: fuzzing regression, security baseline. Formal verification: TLA+, Coq, Isabelle para sistemas críticos.
   - Proyecto: Mutation testing pipeline. AI test generation integration. Custom test framework/runner para dominio específico.
   - Lectura: "Software Testing and Analysis" (Mauro, Pezzè), papers on AI testing, mutation testing.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Testing de algoritmos y estructuras de datos |
| [001-Languages](../001-Languages/) | Testing específico de cada lenguaje y sus frameworks |
| [002-Frameworks](../002-Frameworks/) | Testing de componentes, hooks, servicios en frameworks |
| [003-Databases](../003-Databases/) | Test data management, test DB isolation, migraciones de test |
| [009-Security](../009-Security/) | SAST/DAST, penetration testing, security scanning |
| [010-Architecture](../010-Architecture/) | Arquitectura de tests, test pyramid, contract testing |
| [011-DesignPatterns](../011-DesignPatterns/) | Test patterns (Page Object, Test Builder, Object Mother) |
| [013-DevOps](../013-DevOps/) | Pruebas automatizadas en CI/CD, quality gates |
| [014-CICD](../014-CICD/) | Ejecución de tests en pipeline, parallel test execution |
| [031-AI](../031-AI/) | AI-generated tests, self-healing tests, AI for QA |

## Recursos recomendados

- **Libros**: "Test-Driven Development by Example" (Beck), "xUnit Test Patterns" (Meszaros), "Growing Object-Oriented Software Guided by Tests" (Freeman, Pryce), "Continuous Delivery" (Humble, Farley) capítulos 5-9, "Software Testing and Analysis" (Pezzè, Young).
- **Cursos**: Coursera "Software Testing and Automation" (UMD), "Testing with Python" (TestDriven.io), "Modern React Testing" (TestingJavaScript.com).
- **Herramientas**: playwright.dev, cypress.io, vitest.dev, docs.pytest.org, k6.io, pact.io, testcontainers.com, stryker-mutator.io, hypothesis.works.
- **Blogs**: Martin Fowler (martinfowler.com/testing), TestDriven.io, The Practical Test Pyramid (Ham Vocke).
- **Práctica**: Kata de TDD (String Calculator, Bowling Game, FizzBuzz, Roman Numerals), Testing en proyectos open source, contribuir a snapshots.

## Notas adicionales

Las pruebas automatizadas son una inversión: un buen test suite permite refactorizar con confianza y entrega rápida. La cobertura de línea no es el objetivo (80% es aceptable, 100% no es realista), sino la confianza en que los tests detectan regresiones. Mutation testing es mejor métrica que code coverage. TDD no es testing; es una técnica de diseño que produce tests como subproducto. En microservicios, los contract tests consumer-driven son más importantes que los E2E. El testing en producción (canary analysis, feature flags) complementa el testing pre-producción.
