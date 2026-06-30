# Transformers — Arquitectura de Deep Learning

## Descripción del dominio

La arquitectura Transformer, introducida en el paper *"Attention Is All You Need"* (Vaswani et al., 2017), revolucionó el Deep Learning al reemplazar las redes recurrentes (RNN/LSTM) con un mecanismo de atención que permite procesar secuencias completas en paralelo. Los Transformers son la base de todos los LLMs modernos (GPT, LLaMA, Claude, Gemini, Mistral), modelos de embeddings (BERT, RoBERTa, sentence-transformers), modelos multimodales (CLIP, LLaVA, GPT-4V) y arquitecturas de visión (ViT, Swin, DETR). Su éxito radica en la escalabilidad: más datos y más parámetros producen mejor rendimiento de forma consistente (scaling laws).

## Áreas clave

- **Arquitectura encoder-decoder**: Original para traducción. Encoder (bidireccional, BERT) genera representaciones contextuales. Decoder (autoregresivo, GPT) genera tokens secuencia a secuencia
- **Self-Attention**: Cada token atiende a todos los tokens de la secuencia. Matrices Q (query), K (key), V (value). Score = softmax(QKᵀ / √d) V. Atención multi-cabeza (multi-head): múltiples cabezas capturan diferentes relaciones
- **Positional Encoding**: Sin recurrencia ni convolución, los Transformers necesitan codificación posicional. Sinusoidal (original), RoPE (Rotary Position Embedding, usado en LLaMA), ALiBi (attention with linear biases), relative position bias
- **Arquitecturas principales**: Encoder-only (BERT, RoBERTa, DeBERTa — clasificación, NER, QA extractivo), Decoder-only (GPT, LLaMA, Mistral — generación, chat), Encoder-Decoder (T5, BART, mT5 — traducción, resumen, QA abstractivo)
- **Layer Normalization y Residual Connections**: Pre-Norm (antes de atención/FFN) vs Post-Norm (después). Pre-Norm es más estable en entrenamiento profundo. Skip connections permiten gradientes fluyan directamente
- **Feed-Forward Network (FFN)**: MLP de 2 capas con activación ReLU/GELU/SwiGLU. Expande y contrae dimensionalidad. SwiGLU (LLaMA) y GeGLU mejoran rendimiento sobre ReLU
- **KV-Cache**: Almacena keys y values de tokens previos durante generación autoregresiva. Evita recomputar atención. Crítico para eficiencia en inferencia de LLMs
- **Scaling Laws**: Rendimiento mejora con más parámetros, más datos y más cómputo (Kaplan et al., Chinchilla). Optimal: ~20 tokens por parámetro (Chinchilla scaling)
- **Eficiencia**: Flash Attention (IO-aware, operación fundida), PagedAttention (vLLM, gestión de KV-cache), quantization (GPTQ, AWQ, bitsandbytes), speculative decoding, pruning, distillation
- **Fine-tuning**: Full fine-tuning, LoRA (Low-Rank Adaptation, QLoRA), Adapters, Prefix Tuning, Prompt Tuning, (IA)³. LoRA es el método más popular: entrena matrices de rango bajo y las añade a pesos congelados

## Ejemplo: Transformer decoder simple (PyTorch)

```python
import torch
import torch.nn as nn

class DecoderLayer(nn.Module):
    def __init__(self, d_model, n_heads, d_ff):
        super().__init__()
        self.self_attn = nn.MultiheadAttention(d_model, n_heads, batch_first=True)
        self.norm1 = nn.LayerNorm(d_model)
        self.ffn = nn.Sequential(
            nn.Linear(d_model, d_ff),
            nn.GELU(),
            nn.Linear(d_ff, d_model))
        self.norm2 = nn.LayerNorm(d_model)

    def forward(self, x, mask=None):
        x = x + self.self_attn(self.norm1(x), self.norm1(x), self.norm1(x),
                               attn_mask=mask, need_weights=False)[0]
        x = x + self.ffn(self.norm2(x))
        return x

class MiniTransformer(nn.Module):
    def __init__(self, vocab_size, d_model=512, n_layers=6, n_heads=8):
        super().__init__()
        self.embed = nn.Embedding(vocab_size, d_model)
        self.layers = nn.ModuleList([
            DecoderLayer(d_model, n_heads, d_model * 4) for _ in range(n_layers)
        ])
        self.norm = nn.LayerNorm(d_model)
        self.head = nn.Linear(d_model, vocab_size)

    def forward(self, x, mask=None):
        x = self.embed(x)
        for layer in self.layers:
            x = layer(x, mask)
        return self.head(self.norm(x))
```

## Tecnologías principales

| Framework/Librería | Propósito |
|--------------------|-----------|
| Hugging Face Transformers | Biblioteca estándar para modelos pre-entrenados (30K+ modelos) |
| PyTorch | Framework principal para entrenar y fine-tune Transformers |
| TensorFlow / Keras | Framework alternativo |
| JAX + Flax/ Haiku | Framework de Google Research para scaling |
| vLLM | Inferencia optimizada de LLMs con PagedAttention |
| llama.cpp | Inferencia de LLMs en CPU/GPU con cuantización (GGUF) |
| xFormers (Meta) | Componentes eficientes para Transformers |
| Flash Attention | Atención fundida IO-aware (Tri Dao) |
| DeepSpeed (Microsoft) | Optimización de entrenamiento (ZeRO, sharding, offloading) |
| FSDP (PyTorch) | Fully Sharded Data Parallel para entrenar modelos grandes |
| LitGPT / axolotl | Fine-tuning de LLMs open-source |

## Buenas prácticas

- Usar Hugging Face Transformers para acceder a modelos pre-entrenados y tokenizers
- Para fine-tuning de LLMs, usar LoRA/QLoRA (4-bit quantized LoRA) — mucho más barato que full fine-tune
- Implementar Flash Attention para acelerar entrenamiento e inferencia (2-5x más rápido)
- Usar KV-cache para generación autoregresiva eficiente
- Aplicar cuantización (GPTQ, AWQ, bitsandbytes) para reducir tamaño de modelo 2-4x
- Para inferencia de LLMs en producción, usar vLLM o TGI (Text Generation Inference)
- Preferir arquitecturas decoder-only (GPT-style) para generación de texto y chat
- Seguir scaling laws para decidir tamaño del modelo vs cantidad de datos
- Monitorizar perplexity y loss en validación durante pre-training
- Usar mixed precision training (bfloat16, fp16) para ahorrar memoria GPU
