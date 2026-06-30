# 061-Embeddings: Embeddings y Vectores

## Descripción del dominio

Los embeddings son representaciones numéricas densas de datos discretos (palabras, oraciones, imágenes, grafos) en espacios vectoriales continuos de baja dimensionalidad. Son el núcleo de la mayoría de sistemas modernos de NLP, búsqueda semántica, sistemas de recomendación y RAG. Este módulo cubre desde word embeddings clásicos (Word2Vec, GloVe, FastText) hasta sentence embeddings modernos (Sentence-BERT, Instructor, text-embedding-ada-002/3), pasando por modelos de embedding multimodales (CLIP, ImageBind), técnicas de visualización (t-SNE, UMAP, PCA) y estrategias de fine-tuning para dominios específicos.

## Conceptos clave

- **Word embeddings**: Representaciones densas de palabras — Word2Vec (CBOW, Skip-gram), GloVe (factorización de matriz de co-ocurrencia), FastText (subword information)
- **Sentence embeddings**: Representación de oraciones completas como vectores — Sentence-BERT (SBERT), Universal Sentence Encoder, Instructor, text-embedding-ada-002/003, text-embedding-3-small/large
- **Modelos de embedding populares**: OpenAI text-embedding-ada-002/text-embedding-3, Cohere Embed, Google Gecko, BAAI BGE, intfloat/e5, sentence-transformers/all-MiniLM-L6-v2
- **Dimensionalidad**: Trade-off entre precisión y eficiencia — 128d (compacto), 384d (balanced), 768d (SBERT base), 1024d+, 1536d (ada-002), 3072d (ada-003-large)
- **Normalización**: L2 normalization para similitud coseno — dot-product vs cosine similarity vs euclidean distance
- **Embeddings contextuales**: BERT, RoBERTa, DeBERTa — embeddings dinámicos dependientes del contexto circundante (vs. estáticos)
- **Embeddings multimodales**: CLIP (texto + imagen), ImageBind (texto + imagen + audio + profundidad + térmico + IMU), GATO (multi-tarea)
- **Visualización de embeddings**: t-SNE (t-distributed Stochastic Neighbor Embedding), UMAP (Uniform Manifold Approximation and Projection), PCA, TSNE-CUDA
- **Fine-tuning de embeddings**: Contrastive learning, triplet loss, cosent loss, domain adaptation — ajuste del modelo para mejorar retrieval en corpus específicos
- **HuggingFace Hub**: Repositorio de modelos pre-entrenados — MTEB Leaderboard (Massive Text Embedding Benchmark)

## Tecnologías principales

| Categoría | Tecnologías |
|-----------|-------------|
| Frameworks de embeddings | sentence-transformers, HuggingFace Transformers, OpenAI Embeddings API, Cohere Embed API, Google Gemini Embedding |
| Word embeddings clásicos | Gensim (Word2Vec, FastText), GloVe official implementation, polyglot |
| Visualización | t-SNE (scikit-learn), UMAP (umap-learn), PCA (sklearn), TensorFlow Embedding Projector |
| Evaluación | MTEB (Massive Text Embedding Benchmark), BEIR, STS-B, SentEval |
| Reducción de dimensionalidad | PCA, Truncated SVD, Autoencoders, UMAP, t-SNE |
| Almacenamiento de vectores | FAISS (Facebook), pgvector (PostgreSQL), Pinecone, Milvus, Qdrant, Weaviate |
| Embeddings en imágenes | CLIP (OpenAI), SigLIP (Google), DINOv2 (Meta), BLIP-2 |
| Embeddings en audio | Wav2Vec 2.0, Whisper embeddings, CLAP |

## Hoja de ruta

1. **Principiante**: Concepto de espacio vectorial — similitud coseno y distancia euclídea — Word2Vec con Gensim — visualización simple con PCA — uso de sentence-transformers para obtener embeddings de texto plano
2. **Intermedio**: Fine-tuning de Sentence-BERT con datos propios — contrastive learning — embeddings contextuales vs estáticos — reducción de dimensionalidad con UMAP — MTEB benchmark — caching de embeddings
3. **Avanzado**: Embeddings multimodales (CLIP, ImageBind) — aproximaciones de embedding para eficiencia (distillation, quantization) — embedding de grafos (Node2Vec, GraphSAGE) — embeddings jerárquicos — estrategias de chunking y overlapping para documentos largos
4. **Experto**: Entrenamiento de modelos de embedding desde cero — arquitecturas basadas en Matryoshka Representation Learning (MRL) — embeddings condicionales por tarea (Instructor) — embeddings con feedback de usuario (RLHF for embeddings) — adversarial training para robustez — sistemas híbridos que combinan múltiples modelos de embedding

## Relaciones con otros módulos

- [035-RAG](../035-RAG/) — Embeddings como representación de documentos y queries para recuperación
- [038-VectorDatabases](../038-VectorDatabases/) — Almacenamiento y búsqueda eficiente de vectores generados por modelos de embedding
- [060-Indexes](../060-Indexes/) — Índices vectoriales (HNSW, IVF) que operan sobre embeddings
- [062-Search](../062-Search/) — Búsqueda semántica usando embeddings como representación
- [033-DeepLearning](../033-DeepLearning/) — Redes neuronales subyacentes a modelos de embedding (transformers)
- [039-PromptEngineering](../039-PromptEngineering/) — Estrategias de prompt para mejorar calidad de embeddings
- [063-Examples](../063-Examples/) — Ejemplos prácticos de generación y uso de embeddings
- [031-AI](../031-AI/) — Fundamentos de IA que sustentan los modelos de representación

## Recursos recomendados

- **Papers**: "Efficient Estimation of Word Representations in Vector Space" (Mikolov et al., 2013); "Sentence-BERT: Sentence Embeddings using Siamese BERT-Networks" (Reimers & Gurevych, 2019); "Learning Transferable Visual Models From Natural Language Supervision" (CLIP, Radford et al., 2021); "One Embedder, Any Task: Instruction-Finetuned Text Embeddings" (Su et al., 2022); "Matryoshka Representation Learning" (Kuznetsova et al., 2023)
- **Cursos**: Stanford CS224N (NLP with Deep Learning) — Word Embeddings and BERT; Cohere Embedding Course; HuggingFace NLP Course
- **Librerías**: sentence-transformers, FAISS, Gensim, UMAP-learn, scikit-learn
- **Leaderboards**: MTEB Leaderboard (HuggingFace), BEIR Benchmark
- **Herramientas**: TensorFlow Embedding Projector, Weights & Biases para tracking de embeddings
