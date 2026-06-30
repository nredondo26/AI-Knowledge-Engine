# MCP Best Practices — Mejores Prácticas del Model Context Protocol

## Descripción del dominio

El Model Context Protocol (MCP) es un protocolo abierto que permite a los LLMs interactuar con herramientas, recursos y prompts externos de manera segura y estructurada. Este módulo recopila las mejores prácticas para implementar y utilizar servidores MCP, tanto en el desarrollo de servidores como en el uso desde hosts (Claude Desktop, IDEs). Cubre diseño de herramientas, gestión de recursos, seguridad, rendimiento, testing, despliegue y errores comunes a evitar.

## Áreas clave

- **Diseño de Tools**: Nombre descriptivo en snake_case, parámetros con JSON Schema estricto (tipos, descripciones, required), descripción clara del propósito y side effects. Una herramienta debe hacer una sola cosa bien
- **Gestión de Resources**: URIs estables y semánticas, content types adecuados, resource templates para recursos dinámicos, actualización de recursos con notificaciones (resource updated)
- **Prompts**: Plantillas con argumentos tipados, mensajes de sistema y usuario claros, ejemplos (few-shot) para guiar al LLM, versionado de prompts
- **Seguridad**: Validación de inputs del LLM (sanitización, límites de tamaño), autorización por herramienta, rate limiting, evitar inyección de comandos en herramientas que ejecutan código, logging de auditoría
- **Manejo de errores**: Errores estructurados (código + mensaje), fallo graceful, timeout por operación, retry con backoff para operaciones externas, estados degradados
- **Rendimiento**: Streaming de respuestas largas, paginación de resultados grandes, caching de recursos estáticos, lazy initialization de conexiones costosas, progress reporting para operaciones largas
- **Testing**: Unit tests para lógica de herramientas, integration tests con MCP Inspector, simulación de cliente (JSON-RPC), testing de errores y edge cases, validación de esquemas JSON
- **Documentación**: README claro con ejemplos de configuración, descripción de todas las herramientas y recursos, ejemplos de prompts que funcionan bien, registro de cambios

## Ejemplo: Tool bien diseñada

```json
{
  "name": "search_documents",
  "description": "Busca documentos en la base de conocimiento por consulta semántica. Devuelve hasta `limit` resultados ordenados por relevancia.",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "Consulta de búsqueda en lenguaje natural"
      },
      "limit": {
        "type": "integer",
        "description": "Número máximo de resultados (1-20)",
        "minimum": 1,
        "maximum": 20,
        "default": 5
      },
      "filters": {
        "type": "object",
        "description": "Filtros opcionales (categoría, fecha, etc.)",
        "properties": {
          "category": { "type": "string" },
          "date_from": { "type": "string", "format": "date" }
        }
      }
    },
    "required": ["query"]
  }
}
```

## Ejemplo: Configuración MCP en claude_desktop_config.json

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_xxxx"
      }
    }
  }
}
```

## Errores comunes

| Error | Problema | Solución |
|-------|----------|----------|
| Herramientas con efectos secundarios ocultos | El LLM no sabe que una herramienta modifica datos | Describir side effects explícitamente en la descripción |
| Parámetros sin validación | El LLM envía valores inválidos o peligrosos | Usar JSON Schema con minimum, maximum, pattern, enum |
| Sin timeout en herramientas | Operaciones lentas bloquean al host | Configurar timeout razonable y reportar progreso |
| Recursos con URIs no canónicas | Duplicación de recursos o conflictos | Usar URIs semánticas estables, evitar IDs auto-generados |
| Prompts sin ejemplos | El LLM usa el prompt de forma incorrecta | Incluir 1-3 ejemplos en la plantilla |
| Ignorar notificaciones de cambio | El LLM usa datos desactualizados | Enviar `resources/updated` cuando cambien recursos |
| Dependencias no documentadas | El servidor falla en entornos diferentes | Documentar dependencias, usar npx o contenedores |

## Buenas prácticas generales

- Preferir servidores livianos (sin frameworks pesados) — el MCP Python SDK es suficiente
- Usar entornos virtuales o contenedores para aislar dependencias del servidor
- Implementar health check endpoint para monitoreo
- Versionar servidores MCP con semantic versioning
- Probar con MCP Inspector antes de publicar
- Mantener servidores stateless o con estado mínimo (preferir recargar desde resources)
- Para servidores que acceden a datos sensibles, implementar autenticación por herramienta
- Documentar ejemplos de prompts que el LLM puede usar para cada herramienta
- Usar progres reporting con `progressToken` para operaciones que tomen > 1 segundo
- Escribir tests que verifiquen la correcta interpretación de errores por el LLM
