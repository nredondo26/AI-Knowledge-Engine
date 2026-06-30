# Caching de LLMs (Caching)

## Descripción del dominio

El caching en sistemas de LLMs consiste en almacenar respuestas generadas previamente para reutilizarlas cuando se recibe una consulta idéntica o similar. Dado que las inferencias de LLMs tienen un costo computacional y económico significativo, el caching puede reducir drásticamente la latencia (cache hit: milisegundos vs. segundos), el costo (ahorro en tokens) y la carga en los servidores. Además del caching de respuestas exactas, existen técnicas avanzadas como caching semántico (respuestas para consultas similares) y caching de KV (key-value cache) para acelerar la generación dentro de una misma sesión.

## Conceptos clave

- **Cache Hit**: La consulta se encuentra en el cache; se devuelve la respuesta almacenada sin llamar al LLM.
- **Cache Miss**: La consulta no está en el cache; se debe generar respuesta con el LLM y almacenarla.
- **TTL (Time To Live)**: Tiempo que una entrada permanece en el cache antes de ser invalidada.
- **Política de Evicción**: LRU (Least Recently Used), LFU (Least Frequently Used), FIFO, TTL-based.
- **Caching Exacto**: Coincidencia exacta de string de la consulta (incluyendo prompt completo).
- **Caching Semántico**: Almacenar embeddings de consultas y recuperar respuestas de consultas semánticamente similares. Usa similitud coseno y un umbral de similitud.
- **KV Cache**: En la arquitectura Transformer, las matrices Key y Value de capas anteriores se cachean durante la generación autoregresiva para evitar recomputación. Acelera inferencia secuencial.
- **Cache Distribuido**: Redis, Memcached o sistemas de cache en disco para compartir entre múltiples instancias.

## Ejemplo: Cache exacto con TTL

```python
import hashlib
import time
from functools import lru_cache
import json

class LLMCache:
    def __init__(self, ttl_seconds=3600):
        self.cache = {}
        self.ttl = ttl_seconds

    def _make_key(self, prompt, model, params):
        content = json.dumps({"prompt": prompt, "model": model, "params": params},
                             sort_keys=True)
        return hashlib.sha256(content.encode()).hexdigest()

    def get(self, prompt, model="gpt-4", params=None):
        key = self._make_key(prompt, model, params or {})
        entry = self.cache.get(key)
        if entry and (time.time() - entry['timestamp']) < self.ttl:
            return entry['response']
        return None

    def set(self, prompt, response, model="gpt-4", params=None):
        key = self._make_key(prompt, model, params or {})
        self.cache[key] = {
            'response': response,
            'timestamp': time.time()
        }

    def clear_expired(self):
        now = time.time()
        expired = [k for k, v in self.cache.items()
                   if (now - v['timestamp']) >= self.ttl]
        for k in expired:
            del self.cache[k]

cache = LLMCache(ttl_seconds=300)
```

## Ejemplo: Cache semántico con embeddings

```python
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

class SemanticCache:
    def __init__(self, embedding_model, similarity_threshold=0.95):
        self.embedding_model = embedding_model
        self.threshold = similarity_threshold
        self.cache = []  # [(embedding, prompt, response), ...]

    def get(self, prompt):
        emb = self.embedding_model.encode(prompt)
        for cached_emb, cached_prompt, response in self.cache:
            sim = cosine_similarity([emb], [cached_emb])[0][0]
            if sim >= self.threshold:
                return response
        return None

    def set(self, prompt, response):
        emb = self.embedding_model.encode(prompt)
        self.cache.append((emb, prompt, response))

# Uso conceptual con sentence-transformers
# from sentence_transformers import SentenceTransformer
# model = SentenceTransformer('all-MiniLM-L6-v2')
# semantic_cache = SemanticCache(embedding_model=model, threshold=0.92)
```

## Ejemplo: KV Cache en inferencia Transformer

```python
import torch

def generate_with_kv_cache(model, input_ids, max_new_tokens=100):
    """Generación autoregresiva usando KV cache."""
    past_key_values = None
    generated = input_ids.clone()

    for _ in range(max_new_tokens):
        with torch.no_grad():
            outputs = model(
                generated[:, -1:],  # solo el último token
                past_key_values=past_key_values,
                use_cache=True
            )
            past_key_values = outputs.past_key_values
            next_token = outputs.logits[:, -1, :].argmax(dim=-1, keepdim=True)
            generated = torch.cat([generated, next_token], dim=1)

    return generated
```

## Tecnologías principales

- **Redis**: Cache distribuido en memoria, soporte TTL, LRU, clustering.
- **Memcached**: Cache distribuido simple y rápido.
- **SQLite / DuckDB**: Cache local persistente en disco.
- **semantic-cache**: Librería especializada en caching semántico.
- **GPTCache**: Librería de caching para LLMs con soporte semántico y exacto.
- **vLLM / TGI**: Motores de inferencia con KV cache management optimizado (PagedAttention).

## Hoja de ruta

1. Implementar cache exacto con diccionario en memoria + TTL.
2. Agregar persistencia con SQLite para cache entre reinicios.
3. Cache semántico usando embeddings y similitud coseno.
4. Integrar Redis como backend de cache distribuido.
5. Configurar KV cache optimizado en motores de inferencia (vLLM).
6. Estrategias de invalidación: TTL, LRU, basada en eventos.
7. Monitorear cache hit ratio y ajustar umbrales/TTL.

## Relaciones con otros módulos

- `../Routing/`: Combinar routing + caching para sistema óptimo de costo/latencia.
- `../Evaluation/`: Evaluar impacto del caching en calidad de respuestas (cache semántico).
- `../Security/`: Consideraciones de seguridad: no cachear datos sensibles.
- `../../035-RAG/`: Caching de retrieved chunks y respuestas generadas en RAG.

## Recursos recomendados

- **Documentación**: GPTCache Docs, Redis Docs.
- **Paper**: "GPTCache: A Semantic Cache for LLM Services".
- **Blog**: "KV Cache Optimization for LLM Inference" (Hugging Face Blog).
- **Repositorio**: gptcache (GitHub).
