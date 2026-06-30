# 033-DeepLearning: Aprendizaje Profundo

## Descripción ampliada del dominio

Deep Learning (DL) es un subcampo del Machine Learning basado en redes neuronales artificiales con múltiples capas (deep = profundo). Estas redes aprenden representaciones jerárquicas de los datos, transformando entradas crudas (píxeles, audio, texto) en conceptos cada vez más abstractos. El DL ha impulsado avances revolucionarios en visión por computadora, procesamiento de lenguaje natural, reconocimiento de voz, generación de contenido, robótica, diagnóstico médico, descubrimiento de fármacos y conducción autónoma. La arquitectura Transformer (2017, Vaswani) es actualmente la más influyente. La evolución del DL: perceptrón (1958, Rosenblatt) → backpropagation (1986, Rumelhart) → CNN/LSTM (1990s, LeCun, Hochreiter) → AlexNet (2012, Krizhevsky, revolución DL) → GANs (2014, Goodfellow) → ResNet (2015, He) → Transformer (2017, Vaswani) → BERT/GPT (2018) → diffusion models (2020) → GPT-4/Foundation Models (2023). La investigación actual incluye: modelos multimodales, eficiencia en training/inferencia, scaling laws, interpretability, y AI segura.

## Tabla de conceptos clave

| Concepto | Descripción | Arquitecturas |
|----------|-------------|---------------|
| Red Neuronal | Capas de neuronas interconectadas con pesos y bias | MLP (perceptrón multicapa), Dense (fully connected) |
| CNN (Convolutional NN) | Capas convolucionales para datos espaciales (imágenes, video) | LeNet, AlexNet, VGG, ResNet, Inception, EfficientNet, ConvNeXt |
| RNN/LSTM/GRU | Redes recurrentes para datos secuenciales | Vanilla RNN, LSTM, GRU, BiLSTM, seq2seq |
| Transformer | Arquitectura basada en atención para secuencias | Encoder (BERT), Decoder (GPT), Encoder-Decoder (T5), Vision Transformer |
| Normalization | Técnicas para estabilizar entrenamiento | BatchNorm, LayerNorm, InstanceNorm, GroupNorm, RMSNorm |
| Activation | Función no lineal en neuronas | ReLU, GELU, SiLU/Swish, Sigmoid, Tanh, Softmax |
| Optimization | Algoritmos para minimizar función de pérdida | SGD, SGD+Momentum, Adam, AdamW, AdamW, Lion |
| Regularization | Técnicas para evitar overfitting | Dropout, DropPath, Weight Decay, Label Smoothing, Stochastic Depth |
| Attention | Mecanismo que pesa importancia de elementos de entrada | Self-attention, Multi-head attention, Cross-attention, Flash Attention |
| Embedding | Representación vectorial densa de datos discretos | Word embeddings, positional embeddings, learned embeddings |
| Loss Function | Función a minimizar durante entrenamiento | Cross-entropy, MSE, MAE, Contrastive loss, Triplet loss |

## Tecnologías principales

| Framework | Autograd | Training | Deployment | Ecosystem | Computación distribuida |
|-----------|----------|----------|------------|-----------|----------------------|
| PyTorch | Sí (eager, torch.compile) | DDP, FSDP, DeepSpeed, Horovod | TorchServe, ONNX, TorchScript, ExecuTorch | Hugging Face, Lightning, fast.ai | DDP (multi-GPU), FSDP (sharding), TP |
| TensorFlow/Keras | Sí (GradientTape, eager) | tf.distribute, Horovod, TPU | TF Serving, TF Lite, TF.js | Vertex AI, KerasCV, TensorBoard | Mirrored, multi-worker, TPU strategy |
| JAX | Sí (grad, vmap, pmap, jit) | Flax, Haiku, Optax, PyTree | PJRT, XLA compilation | Transformers (HF), DeepMind | pmap (multi-device), sharded |
| ONNX Runtime | — | — | ONNX (cross-framework) | ONNX ops, ONNX-MLIR | ORT (multi-device) |
| Lightning | PyTorch wrapper | Lightning Trainer, Fabric | Lightning Serve, Lit-Llama | Lightning Hub, Bolts | Lightning DDP/FSDP/DeepSpeed |
| Hugging Face | PyTorch/TF/JAX | Trainer, Accelerate, TRL | Text Generation Inference, TGI | 200K+ models, datasets, spaces | Accelerate (multi-GPU, TPU) |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: neurona artificial (w * x + b), forward pass, backward pass (backpropagation, chain rule). MLP (perceptrón multicapa): layers, units, activation functions (ReLU, sigmoid, tanh, softmax). Training loop: forward, loss, backward (gradients), optimizer step (SGD, Adam). Dataset y DataLoader. PyTorch: Tensor, autograd, nn.Module, nn.Linear, torch.optim, F.mse_loss, F.cross_entropy. Training: batch size, epochs, learning rate, train/validation split. Overfitting/underfitting: dropout, weight decay, early stopping. TensorBoard: logging scalars, histograms, graphs. GPU training: .to(device), CUDA.
   - Proyecto: MLP para MNIST classification. Simple regression con PyTorch.
   - Lectura: "Deep Learning with PyTorch" (Stevens), "d2l.ai" (Dive into Deep Learning), PyTorch tutorials.

2. **Intermedio (3-8 meses)**: CNNs: convolutional layer (kernel size, stride, padding, dilation), pooling (max, avg, global avg), channels. CNN architectures: LeNet, AlexNet, VGG (importance of depth), ResNet (skip connections, bottleneck blocks), Batch Normalization, Global Average Pooling. Training tricks: learning rate scheduling (StepLR, CosineAnnealing, OneCycle), gradient clipping, weight initialization (He, Xavier), augmentation (RandomCrop, HorizontalFlip, ColorJitter, CutMix, MixUp). Transfer learning: pre-trained models (ImageNet), fine-tuning, feature extraction, progressive unfreezing. RNNs: sequence modeling, vanishing/exploding gradients, LSTM (forget, input, output gates), GRU. Training RNNs: truncated BPTT, packed sequences. Embeddings: word embeddings, embedding layer. Seq2seq: encoder-decoder, teacher forcing. Attention: Bahdanau (additive), Luong (multiplicative). PyTorch Lightning: Trainer, Module, DataModule, Callbacks. Multi-GPU: DataParallel, DistributedDataParallel.
   - Proyecto: Image classifier with ResNet transfer learning (cats vs dogs, CIFAR-100). Text classifier with LSTM/GRU. Neural machine translation (seq2seq + attention).
   - Certificación: PyTorch Certified (no oficial, cursos DeepLearning.AI).
   - Lectura: "Dive into Deep Learning" (Zhang, Lipton, Li, Smola) — mejor recurso interactivo, "Deep Learning with PyTorch" (Stevens).

3. **Avanzado (8-14 meses)**: Transformers: attention mechanism (scaled dot-product, self-attention, multi-head, cross-attention), positional encoding (sinusoidal, learned, RoPE). BERT: Masked Language Model (MLM), Next Sentence Prediction (NSP), pre-training + fine-tuning. GPT: causal language model, autoregressive decoding, temperature/top-k/top-p sampling, beam search, KV caching. Vision Transformers (ViT): patch embedding, CLS token, position embeddings. ViT variants: DEiT, Swin Transformer, MaxViT. Multi-modal: CLIP (contrastive vision-language), DALL-E (text-to-image via VQ-VAE + autoregressive), Stable Diffusion (latent diffusion + cross-attention). GANs: generator + discriminator, adversarial training, DCGAN, conditional GAN (pix2pix, cGAN), StyleGAN, CycleGAN. Diffusion models: forward diffusion (noise schedule), reverse diffusion (UNet + noise prediction), DDPM, DDIM, CFG (classifier-free guidance). VAEs: encoder → latent → decoder, KL divergence, reparameterization trick, VQ-VAE. Normalizing flows: invertible transformations, exact likelihood. Training large models: mixed precision (AMP), gradient accumulation, gradient checkpoint, batch size scaling. Advanced optimization: AdamW, cosine schedule, warmup, linear decay.
   - Proyecto: ViT from scratch for image classification. Fine-tune BERT for text classification/SQuAD. Train a diffusion model for image generation (simple dataset). Fine-tune Stable Diffusion (LoRA).
   - Lectura: "Deep Learning" (Goodfellow, Bengio, Courville), "The Annotated Transformer" (Harvard NLP), papers: "Attention is All You Need".

4. **Experto (12+ meses)**: Large-scale training: FSDP (Fully Sharded Data Parallel), DeepSpeed (ZeRO stages 1,2,3, offload), Megatron-LM (model parallelism), Tensor Parallelism, Pipeline Parallelism (GPipe, PipeDream). Efficient attention: Flash Attention (tiling, recomputation), Flash Attention 2/3, multi-query attention, grouped-query attention, sliding window attention, sparse attention. Model optimization: quantization (GPTQ, AWQ, GGUF), pruning (magnitude, SparseGPT, Wanda), distillation (logit matching, feature matching), speculative decoding (assisted generation). MoE (Mixture of Experts): sparse MoE, top-k routing, expert balancing, load balancing loss (Switch Transformer, Mixtral). Scaling laws: Chinchilla scaling (compute-optimal), Kaplan scaling, scaling of MoE, Data scaling. Interpretability: mechanistic interpretability, sparse autoencoders (SAE), activation patching, circuit analysis (IOI, docstring), logit lens, tuned lens, probing. xAI/interpretability: attention visualization (BertViz, TransformerLens), Grad-CAM (CNNs), integrated gradients, SHAP. Expert training techniques: FP8 training, distributed checkpointing, curriculum learning, sequence parallelism, memory-efficient optimizers (Adafactor, 8-bit Adam). Advanced architectures: Mamba (state space models), RWKV (RNN-like Transformer), Hyena, liquid neural networks, Kolmogorov-Arnold Networks (KANs). Research frontiers: reasoning in transformers (chain-of-thought, code pre-training), multi-modal training, world models, agentic capabilities, safety alignment.
   - Proyecto: Training a small LLM (1B param) from scratch. Implementing Flash Attention in Triton. Mechanistic interpretability of a small transformer. Efficient fine-tuning (LoRA, QLoRA) of 7B+ model.
   - Lectura: ArXiv (NLP, CV, ML), Karpathy's "Let's build GPT from scratch", Megatron-LM, DeepSpeed docs, Hugging Face blog.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Álgebra lineal, cálculo, optimización, probabilidad |
| [001-Languages](../001-Languages/) | Python (principal), CUDA C++ para kernels, Triton |
| [031-AI](../031-AI/) | DL como técnica principal de IA moderna |
| [032-MachineLearning](../032-MachineLearning/) | DL como subcampo de ML, conceptos de ML aplicados |
| [034-LLM](../034-LLM/) | LLMs basados en arquitectura Transformer |
| [035-RAG](../035-RAG/) | Embeddings y generadores basados en DL |
| [038-VectorDatabases](../038-VectorDatabases/) | Embeddings generados por modelos DL |
| [030-Robotics](../030-Robotics/) | Deep RL, visión para robótica |
| [039-PromptEngineering](../039-PromptEngineering/) | Prompting depende de arquitectura del modelo |

## Recursos recomendados

- **Libros**: "Deep Learning" (Goodfellow, Bengio, Courville — gratis online), "Dive into Deep Learning" (Zhang, Lipton, Li, Smola — interactivo), "Deep Learning with PyTorch" (Stevens, Antiga, Viehmann), "Understanding Deep Learning" (Prince).
- **Cursos**: Stanford CS231n (CNN for Visual Recognition), Stanford CS224n (NLP with Deep Learning), Stanford CS330 (Multi-Task/Meta Learning), Fast.ai "Practical Deep Learning for Coders", Hugging Face "Deep Reinforcement Learning", MIT 6.S191.
- **Papers**: "AlexNet" (Krizhevsky), "ResNet" (He), "GAN" (Goodfellow), "Attention is All You Need" (Vaswani), "BERT" (Devlin), "GPT-3" (Brown), "Stable Diffusion" (Rombach), "FlashAttention" (Dao).
- **Herramientas**: PyTorch, JAX, Hugging Face Transformers, lightning.ai, Weights & Biases, Comet, Neptune, gradio (demo apps).
- **Práctica**: Papers with Code (benchmarks + code), Hugging Face Hub (models + datasets), Kaggle competitions.

## Notas adicionales

PyTorch es el framework dominante en investigación y la opción recomendada para aprender. Hugging Face Transformers es la biblioteca más importante para trabajar con modelos pre-entrenados. El Transformer es la arquitectura más importante de la década, fundamental para LLMs, visión y más allá. Los conceptos de atención, normalización, y optimización son comunes a todas las arquitecturas. La escalabilidad de entrenamiento (FSDP, DeepSpeed, FlashAttention) es la habilidad más demandada en DL avanzado. La interpretabilidad mecanicista es el campo más activo para entender qué aprenden las redes. Mantenerse al día es esencial: DL avanza rápidamente — seguir ArXiv Sanity, Hugging Face y Twitter/X de investigadores clave.
