# Large Language Models (034-LLM)

## Descripción del dominio

Los Large Language Models (LLMs) son modelos de lenguaje basados en la arquitectura Transformer, entrenados con enormes cantidades de texto (cientos de miles de millones de tokens) y cientos de miles de millones de parámetros. Estos modelos muestran capacidades emergentes de razonamiento, comprensión contextual, generación de texto coherente y ejecución de instrucciones complejas. Ejemplos representativos incluyen GPT-4o (OpenAI), Claude (Anthropic), Gemini (Google), LLaMA (Meta), Mistral (Mistral AI) y DeepSeek. El fine-tuning permite especializar modelos para tareas concretas, RLHF (Reinforcement Learning from Human Feedback) alinea los modelos con preferencias humanas, y la cuantización reduce su tamaño para despliegue eficiente. Los LLMs son la base de asistentes virtuales, chatbots, herramientas de código, sistemas RAG y agentes autónomos.

## Conceptos clave

- **Transformer**: Arquitectura basada en atención. Encoder (BERT) para comprensión, decoder (GPT) para generación, encoder-decoder (T5) para traducción.
- **Pre-training**: Entrenamiento inicial masivo en texto no etiquetado con objetivos como predicción de siguiente token (autoregresivo) o masked language modeling (BERT).
- **Fine-tuning**: Ajuste del modelo pre-entrenado en datos etiquetados para una tarea específica (clasificación, extracción, generación).
- **RLHF** (Reinforcement Learning from Human Feedback): Entrenamiento con retroalimentación humana. Modelo de recompensa + PPO para alinear el LLM con preferencias humanas.
- **DPO** (Direct Preference Optimization): Alternativa a RLHF que optimiza directamente preferencias sin modelo de recompensa separado.
- **Cuantización**: Reducción de precisión de pesos (FP32 → FP16 → INT8 → INT4). Técnicas: GPTQ, AWQ, GGUF/GGML. Reduce memoria y acelera inferencia.
- **Context Window**: Número máximo de tokens que el modelo puede procesar. Desde 4K (GPT-3) hasta 2M tokens (Gemini 1.5 Pro, Claude 3).
- **Emergent Abilities**: Capacidades que aparecen solo en modelos de gran escala (razonamiento multi-step, in-context learning, instrucciones complejas).
- **In-Context Learning**: El modelo aprende de ejemplos incluidos en el prompt sin actualizar pesos (few-shot, zero-shot).
- **Prompt Engineering**: Técnicas para formular instrucciones que maximicen la calidad de las respuestas del LLM.
- **System Prompt**: Instrucción de sistema que define el rol, tono, restricciones y comportamiento del asistente.
- **Logprob / Temperature / Top-p**: Parámetros de generación que controlan la creatividad y determinismo de las respuestas.
- **LoRA** (Low-Rank Adaptation): Técnica de fine-tuning eficiente que entrena matrices de bajo rango en lugar de todos los parámetros.

## Tecnologías principales

- **APIs**: OpenAI API (GPT-4o, GPT-4o-mini), Anthropic API (Claude 3.5 Sonnet, Opus), Google AI (Gemini 1.5 Pro/Flash), Mistral API, Cohere.
- **Modelos Open Weights**: LLaMA 3.1/3.2 (Meta), Mistral/Mixtral, DeepSeek V2/R1, Qwen 2.5, Gemma 2 (Google).
- **Hugging Face Transformers**: Biblioteca para cargar, fine-tune y usar modelos LLM.
- **vLLM**: Motor de inferencia optimizado con PagedAttention, throughput alto, soporte para múltiples GPUs.
- **Ollama / llama.cpp**: Ejecución local de LLMs, cuantizados con GGUF, en CPU/GPU.
- **axolotl / Unsloth**: Frameworks para fine-tuning eficiente de LLMs (QLoRA, LoRA, full fine-tune).
- **TRL (Transformer Reinforcement Learning)**: Librería de Hugging Face para RLHF y DPO.
- **LangChain / LlamaIndex**: Frameworks para construir aplicaciones con LLMs (RAG, agents, chains).
- **OpenAI Evals / LangFuse / Weights & Biases**: Evaluación y monitoreo de LLMs.

## Hoja de ruta

**Principiante:**
1. Arquitectura Transformer: entender self-attention, multi-head attention, positional encoding.
2. Prompt Engineering básico: system prompt, zero-shot, few-shot, claridad en instrucciones.
3. Uso de APIs de LLMs: OpenAI, Anthropic, Gemini desde Python.
4. Parámetros de generación: temperature, top_p, max_tokens, stop sequences.
5. Proyecto: chatbot simple usando API de OpenAI y Streamlit.

**Intermedio:**
1. Fine-tuning con LoRA/QLoRA: preparación de dataset, entrenamiento con axolotl o Unsloth.
2. Cuantización: GPTQ y AWQ para inferencia eficiente, GGUF para local.
3. Evaluación de LLMs: benchmarks (MMLU, HumanEval, GSM8K), métricas (perplejidad, BLEU, ROUGE).
4. RAG básico: chunking, embeddings, retrieval, generación aumentada.
5. Safety: jailbreaking, content filtering, guardrails (NVIDIA NeMo Guardrails).

**Avanzado:**
1. RLHF y DPO: implementación completa, modelos de recompensa, alineamiento.
2. Despliegue a escala: vLLM, TensorRT-LLM, inferencia distribuida.
3. Custom pre-training: tokenización (BPE, SentencePiece), dataset curation, training a gran escala.
4. Mechanistic Interpretability: SAE (Sparse Autoencoders), activation patching, circuit analysis.
5. Investigación frontiers: attention mechanisms alternativos (Mamba, State Space Models), multi-modal LLMs, agentic capabilities.

## Relaciones con otros módulos

- `../033-DeepLearning/`: Arquitectura Transformer y fundamentos de deep learning.
- `../035-RAG/`: LLMs como generadores en sistemas RAG.
- `../036-MCP/`: LLMs como clientes/puntos de integración con MCP.
- `../037-AgenticAI/`: LLMs como cerebro de agentes autónomos.
- `../038-VectorDatabases/`: Embeddings generados por LLMs para búsqueda semántica.
- `../039-PromptEngineering/`: Técnicas de prompting para LLMs.
- `../035-RAG/`: Chunking, embedding y recuperación aumentada con LLMs.
- `../040-Reasoning/`: Cadenas de razonamiento (Chain-of-Thought, Tree-of-Thought) en LLMs.

## Recursos recomendados

- **Paper**: "Attention Is All You Need" (Vaswani et al., 2017).
- **Paper**: "Training Language Models to Follow Instructions with Human Feedback" (Ouyang et al., 2022).
- **Paper**: "LLaMA: Open and Efficient Foundation Language Models" (Touvron et al., 2023).
- **Curso**: "CS224n: Natural Language Processing with Deep Learning" (Stanford).
- **Curso**: "LLM University" (Cohere).
- **Documentación**: Hugging Face Transformers Docs, OpenAI API Reference.
- **Repositorio**: awesome-llms (GitHub), lm-sys/FastChat, ggerganov/llama.cpp.
