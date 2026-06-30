# 054-Benchmarks: Benchmarks y Evaluaciones

## Descripción del dominio

Los benchmarks son conjuntos estandarizados de pruebas que permiten evaluar, comparar y clasificar el rendimiento de sistemas, modelos, algoritmos o herramientas bajo condiciones controladas y reproducibles. Este módulo cubre desde benchmarks clásicos de rendimiento de hardware y software (SPEC, TPC, Geekbench) hasta benchmarks modernos de inteligencia artificial y modelos de lenguaje (MMLU, HumanEval, SWE-Bench, GSM8K, HellaSwag, Big-Bench). También incluye benchmarks de seguridad (CVE, CVSS, penetration testing frameworks), bases de datos (YCSB, TPC-C, TPC-H), cloud computing (CloudSuite, SPEC Cloud) y redes (netperf, iperf3). Los benchmarks proporcionan métricas objetivas para la toma de decisiones informadas sobre arquitectura, tecnología y optimización.

## Conceptos clave

- **MMLU (Massive Multitask Language Understanding)**: benchmark de 57 materias que evalúa conocimiento del mundo y capacidad de razonamiento en modelos de lenguaje, desde matemáticas hasta derecho y medicina
- **HumanEval**: benchmark de generación de código propuesto por OpenAI que evalúa la capacidad de modelos para escribir funciones Python a partir de docstrings con pruebas unitarias
- **SWE-Bench**: benchmark que evalúa la capacidad de modelos para resolver issues reales de repositorios GitHub, incluyendo edición de código, debugging y comprensión de código base existente
- **GSM8K**: conjunto de problemas matemáticos de nivel escolar que evalúa razonamiento aritmético multiturno en modelos de lenguaje
- **Big-Bench (Beyond the Imitation Game)**: colaboración masiva de más de 200 tareas para evaluar capacidades emergentes en modelos de lenguaje grandes
- **HellaSwag**: benchmark de razonamiento de sentido común que evalúa la capacidad de predecir el final correcto de una descripción
- **SPEC (Standard Performance Evaluation Corporation)**: benchmarks estandarizados para rendimiento de CPU (SPEC CPU), servidores (SPEC SFS), virtualización (SPEC Virt) y energía (SPEC Power)
- **TPC (Transaction Processing Performance Council)**: benchmarks para bases de datos transaccionales (TPC-C), analíticas (TPC-H, TPC-DS) y big data (TPCx-BB)
- **YCSB (Yahoo! Cloud Serving Benchmark)**: framework para evaluar el rendimiento de bases de datos NoSQL y sistemas de almacenamiento cloud
- **CVSS (Common Vulnerability Scoring System)**: sistema estandarizado para puntuar la severidad de vulnerabilidades de seguridad (0-10)
- **Latencia, throughput y percentiles**: métricas fundamentales en benchmarks de rendimiento: latencia media, p99, p999, throughput (operaciones/segundo)
- **Fairness y sesgo en benchmarks**: evaluación de sesgos demográficos, culturales y lingüísticos en modelos de IA para garantizar equidad
- **Overfitting a benchmarks**: fenómeno donde los modelos optimizan específicamente para un benchmark, perdiendo generalización

## Tecnologías principales

| Categoría | Benchmarks / Herramientas |
|-----------|---------------------------|
| LLM / AI | MMLU, HumanEval, SWE-Bench, GSM8K, HellaSwag, BIG-Bench, MATH, ARC, LAMBADA |
| Rendimiento CPU | SPEC CPU 2017, Geekbench, Cinebench, PassMark, Prime95 |
| Bases de datos | TPC-C, TPC-H, TPC-DS, YCSB, ClickBench, H2O.ai DB Benchmark |
| Redes | iperf3, netperf, nuttcp, sockperf, TRex (Cisco) |
| Cloud | CloudSuite, SPEC Cloud IaaS, Yahoo Cloud Serving Benchmark |
| Seguridad | CVSS v3.1, CWE, OWASP Benchmark, NIST SP 800-115 |
| Frameworks de evaluación | LM Evaluation Harness (EleutherAI), DeepEval, OpenAI Evals, LangSmith |
| Observabilidad | Prometheus + Grafana, Datadog, New Relic, OpenTelemetry para recolección de métricas |

## Hoja de ruta

1. **Principiante**: comprender qué es un benchmark y por qué es importante; interpretar resultados de benchmarks comunes (Geekbench, MMLU); ejecutar pruebas de carga simples con herramientas como `ab` (Apache Bench) o `wrk`; medir latencia y throughput básicos.
2. **Intermedio**: diseñar benchmarks representativos para un sistema específico; usar frameworks de evaluación de LLM (EleutherAI LM Harness) para comparar modelos; ejecutar YCSB para evaluar bases de datos NoSQL; interpretar percentiles (p50, p99, p999) y entender su impacto en la experiencia del usuario.
3. **Avanzado**: crear benchmarks personalizados para casos de uso concretos; automatizar la ejecución de benchmarks en CI/CD (regression testing); realizar análisis estadístico de resultados (media geométrica, intervalos de confianza); evaluar fairness y sesgo en modelos de IA con benchmarks como WinoBias, StereoSet.
4. **Experto**: contribuir a conjuntos de benchmarks open source (nuevos tasks en BIG-Bench, nuevos problemas en SWE-Bench); definir metodologías de evaluación para toda una organización; publicar resultados y análisis comparativos; desarrollar benchmarks sintéticos para dominios específicos (medicina, legal, finanzas).

## Relaciones con otros módulos

- [000-Core](../000-Core/) — benchmarks de algoritmos (complejidad Big O vs. rendimiento real)
- [001-Languages](../001-Languages/) — comparativas de rendimiento entre lenguajes (Benchmarks Game, TechEmpower)
- [003-Databases](../003-Databases/) — benchmarks de bases de datos relacionales y NoSQL (TPC, YCSB)
- [005-Cloud](../005-Cloud/) — benchmarks de proveedores cloud (CloudSpectator, SPEC Cloud)
- [008-Networking](../008-Networking/) — benchmarks de red (iperf3, netperf, latency entre regiones cloud)
- [009-Security](../009-Security/) — benchmarks de seguridad (CVSS, CWE, OWASP Benchmark)
- [031-AI](../031-AI/) / [032-MachineLearning](../032-MachineLearning/) — benchmarks de modelos ML y datasets
- [034-LLM](../034-LLM/) — benchmarks específicos para modelos de lenguaje (MMLU, HumanEval, SWE-Bench)
- [048-Certifications](../048-Certifications/) — resultados de benchmarks como requisito para ciertas certificaciones
- [052-Standards](../052-Standards/) — estándares detrás de benchmarks (SPEC, TPC están estandarizados)
- [059-Metadata](../059-Metadata/) — metadatos de benchmarks (versión, configuración, fecha, resultados normalizados)

## Recursos recomendados

- **MMLU**: github.com/hendrycks/test — paper y dataset original (Measuring Massive Multitask Language Understanding)
- **HumanEval**: github.com/openai/human-eval — benchmark de generación de código de OpenAI
- **SWE-Bench**: github.com/princeton-nlp/SWE-bench — benchmark de resolución de issues de software reales
- **EleutherAI LM Evaluation Harness**: github.com/EleutherAI/lm-evaluation-harness — framework estándar para evaluar LLMs
- **TPC**: tpc.org — benchmarks transaccionales y analíticos
- **SPEC**: spec.org — benchmarks de rendimiento de CPU, GPU, servidores y energía
- **Geekbench**: geekbench.com — benchmark multiplataforma de CPU y GPU
- **YCSB**: github.com/brianfrankcooper/YCSB — framework de benchmark para sistemas cloud
- **Papers**: "Beyond the Imitation Game: Quantifying and extrapolating the capabilities of language models" (BIG-Bench)
- **Papers**: "Training Verifiers to Solve Math Word Problems" (GSM8K, OpenAI)
