# 068-Research: Investigación

## Descripción del dominio

Este módulo cataloga y resume el panorama de investigación actual en Inteligencia Artificial, con énfasis en las áreas cubiertas por el Knowledge Engine: procesamiento de lenguaje natural, modelos fundacionales, RAG, agentes autónomos, sistemas de búsqueda y aprendizaje profundo. Incluye papers importantes clasificados por área y año, líneas de investigación activas (alignment, razonamiento, eficiencia computacional, multimodalidad), grupos de investigación académicos e industriales (FAIR, Google DeepMind, OpenAI, Anthropic, Mistral, Stanford CRFM), y tendencias emergentes identificadas en conferencias top (NeurIPS, ICML, ICLR, ACL, EMNLP, CVPR).

## Conceptos clave

- **Papers fundacionales**: Transformer (Vaswani et al., 2017), BERT (Devlin et al., 2018), GPT (Radford et al., 2018), GPT-3 (Brown et al., 2020), InstructGPT/ChatGPT (Ouyang et al., 2022), RLHF
- **Líneas activas de investigación**: Mechanistic interpretability, sparse autoencoders, activation steering, dataset contamination, jailbreaking y seguridad, scaling laws, emergent abilities, chain-of-thought reasoning, test-time compute, mixture of experts (MoE), quantization, distillation
- **Conferencias top**: NeurIPS (Conference on Neural Information Processing Systems), ICML (International Conference on Machine Learning), ICLR (International Conference on Learning Representations), ACL/EMNLP/NAACL (NLP), CVPR/ICCV/ECCV (visión), ICRA (robótica)
- **Grupos de investigación**: FAIR (Meta AI), Google DeepMind, OpenAI, Anthropic, Mistral AI, Stanford CRFM (Center for Research on Foundation Models), MIT CSAIL, Berkeley AI Research (BAIR), Mila (Montreal), Max Planck Institute, DeepMind
- **Tendencias emergentes**: Agentic AI, test-time compute scaling, small language models (SLM), on-device AI, Mamba (SSM), liquid neural networks, world models, embodied AI, AI for science (AlphaFold, GNoME)
- **Benchmarks y datasets**: MMLU, HumanEval, GSM8K, MATH, BIG-bench, HELM, Chatbot Arena (LMSYS), SWE-bench, MTEB, BEIR, C-Eval
- **Reproducibilidad**: Implementaciones open-source de papers (HuggingFace, Papers with Code), revisión por pares, artefactos de código, formatos de evaluación estandarizados

## Tecnologías principales

| Categoría | Tecnologías/Recursos |
|-----------|----------------------|
| Repositorios de papers | arXiv (cs.CL, cs.LG, cs.AI), Papers with Code, Semantic Scholar, Google Scholar, OpenReview |
| Implementaciones | HuggingFace Transformers, vLLM, TensorFlow, PyTorch, JAX, MosaicML, llama.cpp |
| Seguimiento de investigación | Twitter/X (ML researchers), LinkedIn, RSS feeds (arXiv), ML Newsletters (The Batch, Import AI, T3CH) |
| Conferencias | NeurIPS, ICML, ICLR, ACL, EMNLP, CVPR, ICRA, AAAI, IJCAI, COLM |
| Pre-prints | arXiv (cs.CL, cs.LG, cs.AI, cs.CV, cs.RO), OpenReview (ICLR/NeurIPS/COLM peer review) |
| Evaluación | LMSYS Chatbot Arena, HELM (Stanford), Open LLM Leaderboard (HuggingFace), AlpacaEval |

## Hoja de ruta

1. **Principiante**: Familiarizarse con arXiv y Google Scholar — leer resúmenes de papers fundacionales (Transformer, BERT, GPT-2) — entender la estructura de un paper académico (Abstract → Introduction → Method → Experiments → Conclusion) — seguir 3-5 investigadores en Twitter — registrarse en Semantic Scholar
2. **Intermedio**: Leer sesiones completas de papers top (NeurIPS, ICML) — entender experimentos y ablations — identificar líneas de investigación activas — evaluar claims vs evidencia en papers — implementar un paper simple en PyTorch (p.ej., Transformer from scratch) — contribuir con discusiones en OpenReview
3. **Avanzado**: Seguir call for papers de conferencias — escribir reviews de papers (meta-review level) — entender tendencias a través de análisis de batches de papers (ICLR trends, NeurIPS trends) — identificar huecos de investigación — colaborar con grupos de investigación open-source — contribuir a benchmarks
4. **Experto**: Proponer nuevas líneas de investigación — publicar en conferencias top — establecer colaboraciones con labs académicos — entender el ciclo completo: idea → experimento → paper → revisión → código → impacto — mentoring de investigadores junior — participar en program committees

## Relaciones con otros módulos

- [031-AI](../031-AI/) — Fundamentos de IA que conectan con líneas de investigación actuales
- [033-DeepLearning](../033-DeepLearning/) — Papers de deep learning y arquitecturas neuronales
- [034-LLM](../034-LLM/) — Papers sobre arquitectura, entrenamiento y alineación de LLMs
- [035-RAG](../035-RAG/) — Papers de retrieval augmented generation (Lewis et al. 2020, Khandelwal et al. 2020)
- [037-AgenticAI](../037-AgenticAI/) — Papers sobre agentes autónomos (ReAct, Reflexion, Toolformer)
- [088-Papers](../088-Papers/) — Colección extensa de papers con resúmenes detallados
- [067-UseCases](../067-UseCases/) — Aplicaciones prácticas derivadas de investigación académica
- [069-Roadmaps](../069-Roadmaps/) — Tendencias de futuro basadas en líneas de investigación activas
- [054-Benchmarks](../054-Benchmarks/) — Benchmarks que miden el progreso de la investigación

## Recursos recomendados

- **Plataformas**: arXiv (cs.CL, cs.LG, cs.AI, cs.CV), Papers with Code, Semantic Scholar, Google Scholar, OpenReview, Elicit.ai (research assistant), Connected Papers (visualización de citaciones)
- **Newsletters**: The Batch (Andrew Ng), Import AI (Jack Clark), T3CH (T3CH), Last Week in AI (AI Index), DeepLearning.ai The Batch
- **Podcasts**: Lex Fridman Podcast (entrevistas con investigadores), ML Street Talk, The TWIML AI Podcast, Practical AI
- **Conferencias top próximas**: NeurIPS, ICML, ICLR, COLM, ACL, EMNLP — fechas de deadline, CFP y review process
- **Papers fundacionales**: "Attention Is All You Need" (2017), "BERT: Pre-training of Deep Bidirectional Transformers" (2018), "Training language models to follow instructions" (InstructGPT, 2022), "Constitutional AI" (Anthropic, 2022), "The Claude Model" (Anthropic, 2024)
