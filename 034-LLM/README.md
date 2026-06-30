# 034-LLM: Large Language Models

## Descripción ampliada del dominio

Los Large Language Models (LLMs) son modelos de lenguaje basados en la arquitectura Transformer, entrenados con enormes cantidades de texto (cientos de miles de millones de tokens) y cientos de miles de millones de parámetros. Estos modelos muestran capacidades emergentes de razonamiento, comprensión contextual, generación de texto coherente y ejecución de instrucciones complejas. Ejemplos representativos incluyen GPT-4o (OpenAI), Claude (Anthropic), Gemini (Google), LLaMA (Meta), Mistral (Mistral AI), DeepSeek y Qwen (Alibaba). La evolución de los LLM: modelos de lenguaje estadísticos (n-gram, 1990s) → word embeddings + RNN/LSTM (2013, Word2Vec, ELMo) → Transformer (2017, Vaswani) → BERT (2018, encoder-only) → GPT-2 (2019, decoder-only, 1.5B) → GPT-3 (2020, 175B, in-context learning) → ChatGPT (2022, RLHF) → GPT-4 (2023, multi-modal) → Claude 3 (2024) → GPT-4o, Gemini 2.0 (2024-25). Las tendencias actuales incluyen: modelos con razonamiento (Chain-of-Thought, system 2), eficiencia (modelos pequeños pero capaces: Phi-3, Gemma, Llama 3), agentic capabilities, multi-modalidad nativa, contextos largos (1M+ tokens), y open-weight models competitivos.

## Tabla de conceptos clave

| Concepto | Descripción | Técnicas/Implementaciones |
|----------|-------------|--------------------------|
| Transformer | Arquitectura basada en atención, encoder-decoder o decoder-only | GPT (decoder), BERT (encoder), T5 (encoder-decoder) |
| Pre-training | Entrenamiento masivo en texto no etiquetado | Autoregressive (next token prediction), MLM (masked) |
| Fine-tuning | Ajuste del modelo pre-entrenado para tarea específica | Supervised fine-tuning (SFT), instruction tuning |
| RLHF | Reinforcement Learning from Human Feedback | Reward model + PPO optimization |
| DPO | Direct Preference Optimization | Optimización directa sin reward model |
| Quantization | Reducción de precisión de pesos (FP32→ FP16→ INT8→ INT4) | GPTQ, AWQ, GGUF/GGML, bitsandbytes |
| Context Window | Número máximo de tokens procesables | 4K (GPT-3) → 32K (GPT-4) → 1M+ (Gemini, Claude, Llama 3) |
| In-Context Learning | Aprendizaje a partir de ejemplos en el prompt | Few-shot, zero-shot, many-shot |
| Emergent Abilities | Capacidades que surgen solo en modelos grandes | Reasoning, mathematical ability, code generation |
| KV Cache | Cache de keys/values para inferencia autoregresiva eficiente | PagedAttention (vLLM), continuous batching |
| System Prompt | Instrucción de sistema que define comportamiento del modelo | Role, tone, constraints, output format |
| Logprobs | Probabilidades logarítmicas de cada token generado | Útil para ranking, scoring, perplexity |
| MoE (Mixture of Experts) | Arquitectura con sub-modelos especializados activados por token | Mixtral 8x7B, GPT-4, DeepSeek-V2, Qwen2-MoE |

## Tecnologías principales

| Categoría | Herramientas/Plataformas | Propósito |
|-----------|-------------------------|-----------|
| APIs Propietarias | OpenAI API, Anthropic API, Google AI, Mistral API, Cohere | Acceso a modelos de frontera vía API |
| Modelos Open Weights | LLaMA 3.1/3.2, Mistral/Mixtral, DeepSeek, Qwen 2.5, Gemma 2, Dbrx | Ejecución local y fine-tuning |
| Frameworks de Inferencia | vLLM, TensorRT-LLM, llama.cpp, Ollama, TGI (HF) | Inferencia optimizada, despliegue |
| Frameworks de Fine-tuning | Axolotl, Unsloth, TRL (HF), lit-gpt, torchtune | SFT, LoRA, QLoRA, DPO, RLHF |
| Frameworks de Aplicaciones | LangChain, LlamaIndex, Haystack, DSPy, Semantic Kernel | RAG, agents, chains, tools |
| Evaluación | LMSys Chatbot Arena, Open LLM Leaderboard, HELM, MMLU | Benchmarks, human evaluation |
| Seguridad y Alineamiento | NeMo Guardrails, Guardrails AI, LLM Guard | Content filtering, jailbreak prevention |
| Observabilidad | LangFuse, Weights & Biases, MLflow, Arize AI | Monitoreo, tracing, evaluación |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos fundamentales: qué es un LLM, arquitectura Transformer, encoder vs decoder vs encoder-decoder, pre-training vs fine-tuning. Prompt Engineering básico: zero-shot, few-shot, system prompt, temperature, top_p, max_tokens, stop sequences. Uso de APIs: OpenAI API (chat completions), Anthropic API, Google Gemini API desde Python. Playground: OpenAI Playground, Anthropic Console, Google AI Studio. Tokenization: BPE, SentencePiece, token counting (tiktoken). Parámetros de generación: temperature (creatividad), top_p (nucleus sampling), frequency/penalty, presence penalty. Proyecto: chatbot simple con Streamlit/Gradio + OpenAI/Claude API.
   - Práctica: Experimentar con diferentes system prompts, temperatures. Construir un asistente simple con API.
   - Lectura: "LLM University" (Cohere), OpenAI API docs, Anthropic API docs.

2. **Intermedio (2-6 meses)**: Fine-tuning: SFT (Supervised Fine-Tuning), instruction tuning datasets (Alpaca, Dolly, OpenAssistant). LoRA (Low-Rank Adaptation): parámetros de adaptación, rank, alpha, target modules. QLoRA: 4-bit quantization + LoRA. Training setup: axolotl (config YAML), Unsloth (2x faster, less memory). Datasets: Hugging Face Datasets, formatting (chat template, completion only), ChatML format. Evaluation: perplexity, benchmarks (MMLU, HumanEval, GSM8K, HellaSwag, ARC), LMSys Chatbot Arena (Elo rating). RAG básico: chunking (RecursiveCharacterTextSplitter), embeddings (text-embedding-3-small, BGE, E5), retrieval (Chroma, FAISS), generation (prompt template with context). Deployment: Ollama (local), TGI (Hugging Face), vLLM (production). Safety: system prompt guardrails, content filtering, basic jailbreak prevention. LangChain: chains, prompts, memory, retrievers, tools.
   - Proyecto: Fine-tuning LLaMA 3.1 8B with LoRA/QLoRA for a task (code generation, instruction following). RAG pipeline for Q&A on custom documents.
   - Certificación: No hay certificaciones estándar de LLM. Cursos DeepLearning.AI (LangChain, RAG, fine-tuning).
   - Lectura: Hugging Face NLP Course (chapters on LLMs), "LLM Practitioner" (The Full Stack), LangChain docs.

3. **Avanzado (6-12 meses)**: Advanced fine-tuning: full fine-tuning (vs LoRA), DPO (Direct Preference Optimization), RLHF (reward model + PPO), multi-turn chat fine-tuning, RL from AI feedback (RLAIF). Training at scale: FSDP (Fully Sharded Data Parallel), DeepSpeed ZeRO (stages 1-3, offload), gradient checkpointing, mixed precision (bfloat16), FP8 training. Long context: RoPE scaling (linear, NTK-aware, YaRN), sliding window attention, Ring Attention, context parallelism. Advanced inference: PagedAttention (vLLM), continuous batching, streaming (Server-Sent Events), speculative decoding (assisted generation, Medusa), in-flight batching. Quantization avanzada: AWQ (Activation-aware Weight Quantization), GPTQ, GGUF/llama.cpp, bitsandbytes (4-bit NF4). Security: prompt injection prevention, jailbreak techniques (tokens attack, role-play, many-shot), guardrails (NVIDIA NeMo Guardrails, Guardrails AI), red teaming, output filtering. Evaluation: customized benchmarks, human evaluation protocols, LLM-as-a-judge (MT-Bench, AlpacaEval, Chatbot Arena). Customizing: RLHF + DPO datasets curation, reward model training, rejection sampling.
   - Proyecto: Fine-tune with DPO for alignment. Deploy LLM with vLLM (continuous batching, PagedAttention). Implement speculative decoding for 2x generation speed.
   - Lectura: "RLHF: Reinforcement Learning from Human Feedback" blog posts, vLLM docs, Hugging Face alignment handbook.

4. **Experto (12+ meses)**: Pre-training LLMs: data curation (quality filtering, deduplication, contamination removal, synthetic data), tokenization design (BPE vs Unigram, vocabulary size). Training recipes: scaling laws (Chinchilla, Kaplan), learning rate schedule (warmup + cosine decay), batch size scaling, weight initialization, stability tricks (loss spikes handling, gradient clipping). Multi-modal LLMs: vision-language (LLaVA, GPT-4V, Qwen-VL), audio (Whisper + LLM), video understanding. MoE models: MoE layer, top-k routing, load balancing loss, expert capacity (Switch Transformer, Mixtral). Efficient architectures: Mamba (state space models), RWKV, Hyena, grouped-query attention, multi-query attention. Context extension: YaRN (NTK-aware), positional interpolation, Ring Attention, Ring Flash Attention, Hierarchical Context (GraphRAG). Mechanistic interpretability: sparse autoencoders (SAE), activation patching, circuit analysis, logit lens, tuned lens, probing. Safety research: capability evaluations (METR, MLE-bench), alignment faking, deception detection, power-seeking behavior, scheming. Privacy and federated learning for LLMs. Emerging: test-time compute scaling (chain-of-thought, consensus), LLM as a judge, multi-agent multi-step reasoning, world models.
   - Proyecto: Pre-training a small LLM (1B params) from scratch. Implementation of Flash Attention, Mamba, or MoE layer. Safety evaluation framework. Multi-modal vision-language model fine-tuning.
   - Lectura: Research papers (NeurIPS, ICML, ICLR), EleutherAI blog, StableLM, MosaicML blog, Anthropic research, ArXiv sanity.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [031-AI](../031-AI/) | LLM como aplicación central de IA |
| [032-MachineLearning](../032-MachineLearning/) | ML clásico para pre/post-procesamiento, regresión, clasificación |
| [033-DeepLearning](../033-DeepLearning/) | Arquitectura Transformer, training techniques, attention |
| [035-RAG](../035-RAG/) | LLMs como generadores en sistemas RAG |
| [036-MCP](../036-MCP/) | LLMs como clientes MCP para integración con herramientas |
| [037-AgenticAI](../037-AgenticAI/) | LLMs como cerebro de agentes autónomos |
| [038-VectorDatabases](../038-VectorDatabases/) | Embeddings de LLMs para búsqueda semántica |
| [039-PromptEngineering](../039-PromptEngineering/) | Técnicas de prompting para LLMs |
| [040-Reasoning](../040-Reasoning/) | Razonamiento en LLMs (CoT, ToT, system 2) |
| [041-CodeGeneration](../041-CodeGeneration/) | LLMs para generación de código |
| [042-Documentation](../042-Documentation/) | LLMs para documentación automática |

## Recursos recomendados

- **Papers**: "Attention is All You Need" (Vaswani), "GPT-3" (Brown), "Training Language Models to Follow Instructions with Human Feedback" (Ouyang), "Constitutional AI" (Bai), "LLaMA" (Touvron), "Scaling Laws" (Kaplan/Chinchilla), "RAG" (Lewis).
- **Cursos**: Hugging Face NLP Course, DeepLearning.AI "LangChain for LLM Apps", "Building Systems with ChatGPT", "Finetuning LLMs", Stanford CS224n (LLM section).
- **Documentación**: OpenAI API docs, Anthropic API docs, Hugging Face Transformers, LangChain, LlamaIndex, vLLM.
- **Plataformas**: Hugging Face Hub (models + datasets), LMSys Chatbot Arena, Open LLM Leaderboard, HELM.
- **Comunidad**: EleutherAI, LAION, Hugging Face Discord, Reddit r/LocalLLaMA, AI Alignment Forum, LessWrong.

## Notas adicionales

OpenAI GPT-4 y Anthropic Claude son los modelos de frontera. LLaMA 3.1 es el mejor modelo open-weight. vLLM es el motor de inferencia más popular. Ollama es la forma más fácil de ejecutar LLMs localmente. La evaluación es crucial (LMSys leaderboard). Fine-tuning con LoRA es accesible con pocos recursos (una GPU 24GB). La seguridad es crítica: prompt injection, jailbreaking y contenido peligroso son riesgos reales. El campo avanza semanalmente: mantenerse actualizado es un desafío.
