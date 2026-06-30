# IntelliJ IDEA — IDE para Desarrollo JVM

## ¿Qué es IntelliJ IDEA?

IDE desarrollado por JetBrains para Java, Kotlin, Groovy y otros lenguajes de la JVM. Ediciones: Community (gratuita, open-source) y Ultimate (comercial).

## Ediciones

| Característica | Community | Ultimate |
|----------------|-----------|----------|
| Java, Kotlin, Groovy | ✅ | ✅ |
| Maven, Gradle | ✅ | ✅ |
| Git, SVN | ✅ | ✅ |
| Spring, Jakarta EE | ❌ | ✅ |
| Docker, Kubernetes | ❌ | ✅ |
| Bases de datos | ❌ | ✅ |
| JS/TS/Frontend | ❌ | ✅ |

## Atajos Esenciales

| Atajo | Acción |
|-------|--------|
| `Ctrl + N` | Buscar clase |
| `Ctrl + Shift + N` | Buscar archivo |
| `Ctrl + B` | Ir a declaración |
| `Ctrl + Alt + B` | Ir a implementación |
| `Ctrl + D` | Duplicar línea |
| `Ctrl + Y` | Eliminar línea |
| `Ctrl + Alt + L` | Formatear código |
| `Ctrl + Alt + O` | Optimizar imports |
| `Alt + Enter` | Intenciones rápidas |
| `Shift + F6` | Renombrar |
| `Ctrl + F8` | Toggle breakpoint |
| `Alt + F8` | Evaluar expresión |

## Live Templates

```java
psvm → public static void main(String[] args) { }
sout → System.out.println();
fori → for (int i = 0; i < ; i++) { }
```

## Plugins Recomendados

- **Lombok**: Reducir boilerplate
- **SonarLint**: Análisis de código en tiempo real
- **Rainbow Brackets**: Colorear pares de paréntesis
- **GitToolBox**: Información adicional de Git
- **Key Promoter X**: Muestra atajos al usar el ratón

## Herramientas Integradas

- **Terminal**: `Alt + F12`
- **Database**: Conexión y consultas SQL (Ultimate)
- **HTTP Client**: Cliente REST (archivos `.http`)
- **VCS**: Git, SVN, Mercurial
- **Test Runner**: JUnit, TestNG, Spock
- **Docker**: Gestión de contenedores (Ultimate)

## Inspecciones de Código

- **Errores**: Subrayado rojo
- **Advertencias**: Subrayado amarillo
- **Sugerencias**: Subrayado gris
- Ejecutar: `Code → Inspect Code`

## Depuración Avanzada

- **Breakpoints condicionales**: Click derecho → Condition
- **Watchpoints**: Breakpoint en acceso/modificación de campo
- **Evaluate Expression**: `Alt + F8`
- **Drop Frame**: Retrocede a llamada anterior

## Buenas Prácticas

1. Mantener índice actualizado (File → Invalidate Caches)
2. Usar Local History como respaldo
3. Personalizar Live Templates para patrones frecuentes
4. Usar Run Configurations para diferentes perfiles
5. Configurar File Watchers para formateo automático

## Recursos

- [Documentación oficial](https://www.jetbrains.com/help/idea/)
- [IntelliJ IDEA Guide](https://www.jetbrains.com/idea/guide/)
