# Ejemplos MCP (Examples)

## Descripción del dominio

Esta carpeta contiene ejemplos completos de servidores MCP (Model Context Protocol) que ilustran conceptos, patrones de diseño y casos de uso del protocolo. Los ejemplos abarcan desde servidores básicos con una sola herramienta hasta servidores complejos que exponen herramientas, recursos y prompts simultáneamente. Cada ejemplo está diseñado para ser funcional, bien documentado y servir como punto de partida para desarrollar servidores MCP personalizados. Los ejemplos cubren los tres elementos principales del protocolo — Tools, Resources y Prompts — así como configuraciones de transporte (stdio y SSE), manejo de errores, logging, seguridad básica y patrones de integración con frameworks como FastMCP y SDKs oficiales de Python y TypeScript.

## Categorías de ejemplos

- **Hola Mundo MCP**: Servidor mínimo con una herramienta de saludo. Ilustra la estructura básica: inicialización, listado de herramientas y llamada.
- **Servidor de Archivos**: Implementación simplificada del servidor filesystem de referencia. Herramientas: leer, escribir, listar, buscar archivos. Recursos: acceso a archivos via URI.
- **Servidor de Base de Datos**: Conexión a SQLite/PostgreSQL. Herramientas para ejecutar queries, listar tablas. Recursos para esquemas y resultados de queries.
- **Servidor de APIs**: Proxy a APIs REST externas (GitHub, clima, noticias). Herramientas parametrizadas con autenticación vía headers.
- **Servidor de Prompts**: Ejemplos de prompts reutilizables: analizador de código, resumidor de documentos, traductor técnico.
- **Servidor Híbrido (Tools + Resources + Prompts)**: Servidor completo que expone los tres tipos de capacidades simultáneamente.
- **Servidor con Seguridad**: Ejemplo con autenticación vía API key, autorización por roles, sanitización de paths, rate limiting y logging.
- **Servidor con Streaming**: Herramientas que devuelven resultados parciales mediante notificaciones de progreso.
- **Servidor con FastMCP**: Uso del framework FastMCP para construir servidores con sintaxis simplificada.

## Ejemplo: Servidor mínimo con FastMCP

```python
# Instalar: pip install fastmcp
from fastmcp import FastMCP

app = FastMCP("Ejemplo MCP")

@app.tool()
def saludar(nombre: str) -> str:
    """Saluda a una persona por su nombre."""
    return f"¡Hola, {nombre}! Bienvenido a MCP."

@app.tool()
def sumar(a: float, b: float) -> float:
    """Suma dos números."""
    return a + b

@app.resource("docs://{tema}")
def documentacion(tema: str) -> str:
    """Obtiene documentación sobre un tema."""
    docs = {
        "mcp": "Model Context Protocol...",
        "tools": "Las tools son funciones...",
        "resources": "Los resources son datos..."
    }
    return docs.get(tema, "Tema no encontrado")

@app.prompt()
def analizar_codigo(lenguaje: str, codigo: str) -> str:
    """Analiza código fuente y sugiere mejoras."""
    return f"Analiza el siguiente código {lenguaje}:\n{codigo}"

if __name__ == "__main__":
    app.run(transport="stdio")
```

## Estructura de los ejemplos

Cada ejemplo incluye:
- **README propio** (opcional): Descripción del ejemplo, requisitos, instrucciones de uso.
- **Código fuente**: Implementación completa en Python o TypeScript con comentarios explicativos.
- **Configuración**: Archivos de ejemplo para `claude_desktop_config.json` o similar.
- **Tests**: Pruebas unitarias usando MCP Inspector o pytest con client MCP simulado.
- **Documentación**: Explicación de conceptos ilustrados, decisiones de diseño y variaciones posibles.

## Relaciones con otros módulos

- `../Tools/`: Ejemplos de servidores con diferentes tipos de herramientas.
- `../Resources/`: Ejemplos de recursos estáticos y dinámicos.
- `../Prompts/`: Ejemplos de prompts reutilizables.
- `../Transport/`: Ejemplos con transporte stdio y SSE.
- `../Security/`: Ejemplos con medidas de seguridad implementadas.
- `../../035-RAG/`: Ejemplos de servidores MCP para retrieval en RAG.
- `../../037-AgenticAI/`: Ejemplos de integración MCP con agentes.

## Recursos recomendados

- **Documentación oficial**: modelcontextprotocol.io/quickstart/server.
- **Repositorio oficial de servidores**: github.com/modelcontextprotocol/servers.
- **Awesome MCP Servers**: github.com/punkpeye/awesome-mcp-servers.
- **FastMCP**: github.com/anthropics/fastmcp.
- **SDK**: Python SDK (anthropic/mcp), TypeScript SDK (modelcontextprotocol/typescript-sdk).
- **Inspector**: MCP Inspector para probar ejemplos interactivamente.
