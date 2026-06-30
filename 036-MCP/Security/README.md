# Seguridad en MCP (Security)

## Descripción del dominio

La seguridad en el Model Context Protocol (MCP) abarca las prácticas, mecanismos y configuraciones necesarias para garantizar que la comunicación entre hosts, clientes y servidores MCP sea segura, controlada y auditable. Dado que MCP permite a los LLMs ejecutar herramientas que pueden acceder a archivos, bases de datos y APIs externas, la seguridad es crítica para prevenir accesos no autorizados, fugas de información, ejecución de comandos maliciosos y otros riesgos. Las principales áreas de seguridad incluyen: autenticación y autorización (API keys, OAuth, tokens), control de acceso a herramientas y recursos (permisos granulares), sanitización de entradas (prevención de path traversal, injection), rate limiting y cuotas, aislamiento de procesos y sandboxing, cifrado de la comunicación (TLS/HTTPS para SSE), y auditoría/logging de todas las operaciones. MCP también incluye conceptos como Roots (directorios que el host comparte con el servidor) para limitar el alcance del acceso a archivos.

## Conceptos clave

- **Autenticación**: Verificación de la identidad del cliente/servidor. En SSE: API keys, JWT, OAuth 2.0, certificados TLS mutuos (mTLS). En stdio: confianza implícita por ser local.
- **Autorización**: Control de qué operaciones puede realizar un cliente autenticado. Permisos por tool, recurso o prompt. Implementable como middleware en el servidor.
- **Roots**: Directorios o rutas que el host comparte explícitamente con el servidor MCP. El servidor solo debe acceder a paths dentro de los roots declarados.
- **Path Traversal**: Ataque donde un usuario malicioso usa `../` para acceder a archivos fuera del directorio permitido. Prevención: sanitización de rutas, uso de `os.path.realpath`.
- **Prompt Injection**: Inyección de instrucciones maliciosas a través de argumentos de prompts o tools. Prevención: validación de entradas, sanitización, separación de instrucciones del sistema y datos del usuario.
- **Tool Authorization**: Control granular de qué LLM o usuario puede invocar qué herramientas. Puede basarse en roles, scopes OAuth, o listas de control de acceso (ACL).
- **Resource Access Control**: Restricción de qué recursos puede leer un cliente. Los recursos sensibles (contraseñas, claves) deben protegerse con autenticación adicional.
- **Rate Limiting**: Limitación del número de llamadas a herramientas o lecturas de recursos por unidad de tiempo. Previene abuso y DOS.
- **Audit Logging**: Registro detallado de todas las operaciones: qué tool se llamó, con qué argumentos, por quién, cuándo, resultado, duración.
- **Sandboxing**: Aislamiento del proceso del servidor MCP mediante contenedores (Docker), virtualenvs, o sistemas de archivos temporales.
- **TLS/HTTPS**: Cifrado de la comunicación en transporte SSE. Obligatorio en producción para prevenir escuchas y ataques man-in-the-middle.
- **Input Validation**: Validación estricta de todos los argumentos de herramientas y prompts contra JSON Schema, con sanitización de cadenas y límites de tamaño.

## Ejemplo: Middleware de autorización

```python
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool
import os

app = Server("servidor-seguro")

# Autorización simple por API key
ALLOWED_TOOLS = {
    "usuario_admin": {"listar_archivos", "leer_archivo", "ejecutar_query"},
    "usuario_lector": {"listar_archivos", "leer_archivo"}
}

def authorize(client_id: str, tool_name: str) -> bool:
    """Verifica si el cliente tiene permiso para usar la tool."""
    return tool_name in ALLOWED_TOOLS.get(client_id, set())

@app.call_tool()
async def call_tool(name: str, arguments: dict) -> list:
    # Obtener identidad del cliente (ej. del header de autenticación)
    client_id = get_current_client_id()

    if not authorize(client_id, name):
        return [TextContent(
            type="text",
            text=f"Error: No autorizado para usar '{name}'",
            isError=True
        )]

    # Validar argumentos contra JSON Schema
    if name == "leer_archivo":
        path = arguments.get("path", "")
        # Sanitizar path: evitar path traversal
        real_path = os.path.realpath(path)
        allowed_root = os.path.realpath("/datos/permitidos")
        if not real_path.startswith(allowed_root):
            return [TextContent(
                type="text",
                text="Error: Acceso denegado a esta ruta",
                isError=True
            )]

    # Ejecutar la herramienta
    return await execute_tool(name, arguments)
```

## Prácticas de seguridad

- **Principio de Mínimo Privilegio**: El servidor MCP debe tener solo los permisos necesarios. No ejecutar como root. Usar Roots para limitar acceso a archivos.
- **Validación de Paths**: Siempre normalizar rutas con `os.path.realpath()` y verificar que estén dentro de los roots permitidos. Rechazar `../` y enlaces simbólicos maliciosos.
- **Sanitización de Input**: Validar tipos, longitudes, rangos y patrones. Escapar caracteres especiales en queries SQL, comandos shell, etc.
- **No Confiar en el Input del LLM**: Los argumentos de tools pueden contener intentos de injection. Validar todo como si viniera de un usuario malicioso.
- **Rate Limiting**: Implementar límites por cliente, por tool, por tiempo. Usar token bucket o sliding window. Responder con error 429.
- **Logging Seguro**: No registrar secretos, API keys o datos personales. Enmascarar campos sensibles. Logs estructurados para auditoría.
- **TLS/HTTPS**: Para servidores SSE remotos, usar TLS 1.3. Certificados válidos. Considerar mTLS para autenticación mutua.
- **Timeout**: Establecer timeouts para todas las operaciones de herramientas. Prevenir ejecución indefinida.
- **Sandboxing**: Ejecutar servidores MCP en contenedores Docker sin privilegios. Usar sistemas de archivos temporales y redes aisladas.

## Amenazas comunes

| Amenaza | Descripción | Mitigación |
|---|---|---|
| Path Traversal | Acceso a archivos fuera del directorio permitido | Validación de rutas, Roots |
| Prompt Injection | Instrucciones maliciosas en argumentos | Separación sistema/usuario, validación |
| Command Injection | Ejecución de comandos a través de argumentos | No usar shell, validación estricta |
| Data Exfiltration | Fuga de datos sensibles a través de tools | Control de acceso, logging, rate limiting |
| Denial of Service | Sobrecarga del servidor con muchas llamadas | Rate limiting, timeouts, cuotas |
| Autenticación Débil | Acceso no autorizado a herramientas | API keys, OAuth, mTLS |
| Logging Inseguro | Exposición de secretos en logs | Enmascaramiento, logs estructurados |

## Relaciones con otros módulos

- `../Tools/`: Autorización y validación específica para herramientas.
- `../Resources/`: Control de acceso a recursos sensibles.
- `../Prompts/`: Prevención de prompt injection en argumentos de prompts.
- `../Transport/`: Seguridad de la capa de transporte (TLS, autenticación).
- `../Examples/`: Ejemplos de servidores con configuraciones de seguridad.
- `../../039-PromptEngineering/Safety/`: Guardrails y seguridad en prompts.
- `../../034-LLM/`: Seguridad en function calling y tool use.

## Recursos recomendados

- **Documentación oficial**: modelcontextprotocol.io/docs/concepts/security.
- **Guía**: "MCP Security Best Practices" (modelcontextprotocol.io).
- **OWASP**: OWASP Top 10 for LLM Applications (injection, sensitive disclosure).
- **Paper**: "Universal and Transferable Adversarial Attacks on Aligned Language Models" (Zou et al., 2023).
- **Herramientas**: Lakera Guard (detección de injection), NVIDIA NeMo Guardrails.
- **Repositorio**: protect.ai/prompt-inject-detection.
