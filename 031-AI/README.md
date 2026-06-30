# 031-AI: Inteligencia Artificial

## Descripción ampliada del dominio

La Inteligencia Artificial (IA) es el campo de la computación dedicado a crear sistemas capaces de realizar tareas que requieren inteligencia humana: razonamiento, aprendizaje, percepción, comprensión del lenguaje natural y toma de decisiones. El campo abarca múltiples enfoques: desde la IA simbólica clásica (sistemas expertos, lógica formal) hasta el aprendizaje automático y el deep learning moderno. La historia de la IA incluye el Test de Turing (1950), la conferencia de Dartmouth (1956, nacimiento del campo), los primeros sistemas expertos (1970s, MYCIN, DENDRAL), los inviernos de la IA (1974-80, 1987-93), el auge de sistemas expertos (1980s), Deep Blue vence a Kasparov (1997), AlexNet y deep learning (2012), AlphaGo vence a Lee Sedol (2016), y la era de los modelos fundacionales (GPT-3 2020, GPT-4 2023, Claude 2023, Gemini 2024). Las tendencias actuales incluyen: modelos fundacionales (LLMs, LMMs), IA agente (Agentic AI), IA generativa (texto, imagen, video, código, música, 3D), IA en ciencia (AlphaFold, descubrimiento de fármacos), IA general (AGI como objetivo), IA ética y responsable (alignment, safety, fairness), y IA en edge (on-device AI).

## Tabla de conceptos clave

| Subcampo | Descripción | Técnicas/Enfoques |
|----------|-------------|-------------------|
| IA Simbólica | Representación del conocimiento mediante símbolos y reglas lógicas | Sistemas expertos, ontologías, razonamiento basado en casos, lógica de primer orden |
| Machine Learning | Algoritmos que mejoran con la experiencia | Supervisado, no supervisado, semi-supervisado, por refuerzo |
| Deep Learning | Redes neuronales con múltiples capas | CNN, RNN, LSTM, Transformer, GAN, VAE, Diffusion |
| NLP (Natural Language Processing) | Procesamiento de lenguaje humano | Tokenización, parsing, NER, sentiment analysis, traducción, summarization |
| Computer Vision | Extracción de información de imágenes/video | Classification, detection, segmentation, pose estimation, 3D reconstruction |
| Reinforcement Learning | Aprendizaje mediante interacción con entorno | Q-learning, DQN, PPO, SAC, TD3, MuZero, RLHF |
| Generative AI | Generación de contenido nuevo (texto, imagen, audio, video) | LLMs, diffusion models, GANs, autoregressive models |
| AI Alignment | Asegurar que objetivos y comportamientos de IA coincidan con valores humanos | RLHF, Constitutional AI, mechanistic interpretability, red teaming |
| XAI (Explainable AI) | Técnicas para hacer modelos de IA interpretables | SHAP, LIME, Grad-CAM, Integrated Gradients, attention visualization |
| AGI (Artificial General Intelligence) | IA con capacidades cognitivas generales al nivel humano | Hito a largo plazo, investigación en arquitecturas cognitivas |
| Foundation Model | Modelo masivo pre-entrenado que sirve como base para múltiples tareas | GPT-4o, Claude 3.5, Gemini, LLaMA, DALL-E, Stable Diffusion |
| Multimodal AI | IA que procesa múltiples tipos de datos (texto, imagen, audio, video) | GPT-4V/4o, Claude 3, Gemini Pro, ImageBind, Universe (Meta) |

## Tecnologías principales

| Subcampo | Frameworks/Librerías | Plataformas/APIs | Hardware |
|----------|---------------------|-------------------|----------|
| Machine Learning | Scikit-learn, XGBoost, LightGBM, CatBoost | AWS SageMaker, Azure ML, Vertex AI, Databricks | CPU, GPU (NVIDIA V100, A100, H100) |
| Deep Learning | PyTorch, TensorFlow, JAX, Keras, MXNet | Hugging Face, Weights & Biases, Neptune | GPU, TPU (Google), Habana Gaudi, AMD MI |
| NLP | Transformers (HF), spaCy, NLTK, Stanford NLP | OpenAI API, Anthropic API, Cohere, Google AI | GPU, TPU, NPU |
| Computer Vision | OpenCV, Detectron2, MMDetection, YOLO, DETR | AWS Rekognition, Google Vision, Azure AI Vision | GPU, VPU, Jetson |
| RL | Stable-Baselines3, RLlib, Dopamine, Acme | OpenAI Gym, MuJoCo, Isaac Gym | GPU, CPU clusters |
| Generative AI | diffusers, TTS, AITemplate | OpenAI, Anthropic, Stability AI, Midjourney | GPU (H100, A100), TPU |
| AI Safety | transformers_lens, SAE, Lyfe, Evals | OpenAI Evals, Anthropic red teaming | GPU (research) |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: qué es IA, tipos (débil vs fuerte), historia, Turing Test. Diferencias entre IA, ML, DL. Agentes inteligentes: tipos (reflex, model-based, goal-based, utility-based, learning). Búsqueda: BFS, DFS, A*, heuristic search. Representación del conocimiento: lógica proposicional, lógica de predicados, inferencia. Probabilidad y estadística básica: distribuciones, Bayes theorem, expected value. Python: NumPy, Pandas, Matplotlib, Scikit-learn básico. Ética de IA: sesgo, equidad, transparencia.
   - Práctica: Implementar A* search para puzzle. Clasificador simple con Scikit-learn (iris dataset). Chatbot básico con reglas.
   - Lectura: "Artificial Intelligence: A Modern Approach" (Russell, Norvig, 4ª ed.) — capítulos 1-5.

2. **Intermedio (3-8 meses)**: Machine Learning clásico: regresión lineal/logística, SVM, árboles de decisión, random forest, k-means, PCA. Validación: train/test split, cross-validation, hyperparameter tuning (GridSearch, RandomizedSearch). Feature engineering: encoding, scaling, feature selection, dimensionality reduction. Redes neuronales básicas: perceptron, MLP, backpropagation, activation functions (ReLU, sigmoid, tanh, softmax). NLP básico: tokenization, TF-IDF, Bag of Words, Word2Vec (CBOW, Skip-gram), sentiment analysis. Computer vision básico: convolution operation, image filters (Gaussian, Sobel, Canny edge detection). Ética de IA: bias in datasets, fairness metrics, transparency, explainability (XAI). Aprendizaje por refuerzo básico: MDP, Bellman equations, value iteration, policy iteration, Q-learning.
   - Proyecto: Clasificador de imágenes (MNIST, CIFAR-10) con CNN. NLP pipeline (NER, sentiment). Recomendation system (collaborative filtering).
   - Lectura: AIMA capítulos 6-20, "Hands-On ML" (Geron, 3ª ed.).

3. **Avanzado (8-14 meses)**: Deep Learning avanzado: CNN architectures (ResNet, DenseNet, EfficientNet), RNN/LSTM/GRU (sequence modeling), Transformers (attention, positional encoding, multi-head), GANs (DCGAN, StyleGAN, conditional), VAEs, diffusion models. Reinforcement Learning avanzado: Deep Q-Network (DQN, Double DQN, Dueling DQN), Policy Gradients (REINFORCE, A2C, PPO), SAC, TD3, MuZero. NLP avanzado: BERT (pre-training, fine-tuning), GPT (causal LM, prompting), T5 (text-to-text), sequence-to-sequence, machine translation, text summarization, NMT. Computer vision avanzado: YOLO (object detection), Mask R-CNN (instance segmentation), U-Net (segmentation), Depth estimation (MiDaS), 3D reconstruction (NeRF, 3D Gaussian Splatting), visual transformers (ViT, DETR, SAM). Multi-modal: CLIP (image-text), DALL-E (text-to-image), Whisper (speech-to-text). Data pipelines: dataset curation, preprocessing, augmentation (Albumentations, imgaug), labeling tools (LabelStudio, CVAT). Model evaluation: metrics (accuracy, precision, recall, F1, IoU, mAP, BLEU, ROUGE, perplexity), confusion matrix, ROC/AUC. MLflow tracking, experiment management.
   - Proyecto: Fine-tune BERT for NLP task. Object detection with YOLOv8. Text-to-image with Stable Diffusion fine-tuning. RL agent for Atari/robotics.
   - Lectura: "Deep Learning" (Goodfellow, Bengio, Courville), "NLP with Transformers" (Tunstall), "RL: An Introduction" (Sutton, Barto).

4. **Experto (12+ meses)**: Foundation Models: GPT-4 architecture (speculation), multi-modal training (image, video, audio), scaling laws (Chinchilla, Kaplan), compute-optimal training, data scaling. Alignment research: RLHF (reward modeling, PPO), Constitutional AI, DPO (Direct Preference Optimization), KTO, mechanistic interpretability (sparse autoencoders, activation patching, circuit analysis). AI Safety: existential risk, alignment faking, power-seeking, deception, red teaming, evaluation (MLE-bench, METR). AGI approaches: cognitive architectures (ACT-R, SOAR, Nengo), system 2 thinking, chain-of-thought reasoning. Multi-agent AI: agent communication, tool use, planning, reflection. Causal AI: causal inference, do-calculus, structural causal models. AI for Science: AlphaFold (protein folding), GNoME (materials discovery), AI-driven drug discovery. Efficient AI: model compression (distillation, pruning, quantization), Mixture of Experts (MoE), Flash Attention, speculative decoding. AI ethics research: fairness definitions (demographic parity, equal opportunity), differential privacy, federated learning, AI governance. Frontier research: world models, active inference, self-improving AI, neuromorphic computing, liquid neural networks.
   - Proyecto: Safety evaluation suite for LLMs. Causal inference for ML model debugging. Training a foundation model from scratch (small scale).
   - Lectura: Papers: "Attention is All You Need", "Scaling Laws", "Constitutional AI", "RLHF", "GPF and GPT-4 papers". Books: "AI: A Modern Approach" (todo), "Reconciling AI Safety" (Russell), "The Alignment Problem" (Christian).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Algoritmos de búsqueda, optimización, probabilidad, estructuras de datos |
| [001-Languages](../001-Languages/) | Python como lenguaje principal, lenguajes funcionales para IA simbólica (Prolog) |
| [003-Databases](../003-Databases/) | Feature stores (Feast, Tecton), ML data pipelines |
| [032-MachineLearning](../032-MachineLearning/) | Machine Learning como subcampo principal de IA |
| [033-DeepLearning](../033-DeepLearning/) | Deep Learning como subcampo del ML |
| [034-LLM](../034-LLM/) | Large Language Models, aplicación principal de IA actual |
| [035-RAG](../035-RAG/) | Retrieval Augmented Generation, arquitectura LLM + retrieval |
| [036-MCP](../036-MCP/) | Model Context Protocol, integración LLM con tools |
| [037-AgenticAI](../037-AgenticAI/) | Agentes autónomos basados en LLM |
| [038-VectorDatabases](../038-VectorDatabases/) | Memoria semántica para sistemas IA |
| [039-PromptEngineering](../039-PromptEngineering/) | Técnicas de prompting para LLMs |
| [040-Reasoning](../040-Reasoning/) | Razonamiento, pensamiento crítico en IA |

## Recursos recomendados

- **Libros**: "Artificial Intelligence: A Modern Approach" (Russell, Norvig, 4ª ed.) — biblia de IA. "Deep Learning" (Goodfellow, Bengio, Courville). "Reinforcement Learning: An Introduction" (Sutton, Barto). "NLP with Transformers" (Tunstall). "The Alignment Problem" (Christian).
- **Cursos**: Stanford CS221 (AI), MIT 6.036 (ML), Stanford CS231n (CNN for Vision), CS224n (NLP), CS330 (Deep Multi-Task and Meta Learning), Hugging Face Course, Fast.ai.
- **Papers**: "Attention is All You Need", "GPT-3", "BERT", "Stable Diffusion", "Chinchilla scaling laws", "RLHF", "Constitutional AI", "GANs".
- **Conferencias**: NeurIPS, ICML, ICLR, AAAI, IJCAI, ACL, CVPR, ICCV, CoRL.
- **Plataformas**: Kaggle (competiciones), Papers with Code, Hugging Face, GitHub, ArXiv.

## Notas adicionales

AIMA (Russell, Norvig) es el libro de texto definitivo. La combinación de teoría + práctica (Kaggle, proyectos personales) es el camino de aprendizaje. El enfoque actual dominante es deep learning + transformers. La investigación en AI Safety es el área más importante y desafiante para el futuro de la IA. Para empezar hoy: aprender Python, PyTorch, Hugging Face Transformers, y entender los conceptos de transformers. La IA está experimentando una revolución con los modelos fundacionales — la capacidad de razonamiento y agentic AI son las fronteras actuales.
