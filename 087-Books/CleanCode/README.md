# Clean Code — Código Limpio (Robert C. Martin)

## Resumen

*Clean Code: A Handbook of Agile Software Craftsmanship* (2008) de Robert C. Martin. Libro fundamental sobre principios, patrones y prácticas para escribir código legible, mantenible y profesional.

## Principios Fundamentales

### 1. Nombres Significativos

```java
// Malo
int d; // elapsed time in days

// Bueno
int elapsedTimeInDays;
```

Reglas: nombres que revelen intención, pronunciables, buscables; evitar desinformación.

### 2. Funciones Pequeñas (SRP)

```java
// Malo: función larga con múltiples responsabilidades
public void processOrder(Order order) {
    validateOrder(order);
    calculateTotals(order);
    saveOrder(order);
    sendConfirmation(order);
}
```

Reglas: una función = una cosa; menos de 20 líneas; sin efectos secundarios.

### 3. Comentarios — Preferir Código Auto-documentado

```java
// Malo
// Check if employee is eligible for full benefits
if ((employee.flags & HOURLY_FLAG) && (employee.age > 65))

// Bueno
if (employee.isEligibleForFullBenefits())
```

### 4. Manejo de Errores — Excepciones sobre Códigos

```java
// Malo: return codes
if (deletePage(page) == E_OK) { ... }

// Bueno: excepciones
try {
    deletePage(page);
} catch (Exception e) {
    logError(e);
}
```

### 5. Objetos vs Estructuras

- **Objeto**: esconde datos, expone comportamiento
- **Estructura**: expone datos, sin comportamiento

## Los 12 Principios de Clases

1. **SRP**: Una razón para cambiar
2. **Cohesión alta**: Métodos que usan mismas variables
3. **Open-Closed**: Abierta para extensión, cerrada para modificación
4. **LSP**: Subtipos sustituibles
5. **ISP**: Interfaces pequeñas
6. **DIP**: Depender de abstracciones
7-12: Organización, tamaño, encapsulación, bajo acoplamiento, jerarquía, polimorfismo

## Code Smells y Soluciones

| Smell | Solución |
|-------|----------|
| Comentarios redundantes | Eliminar |
| Código comentado | Eliminar |
| Código duplicado | Extraer método/clase |
| Código muerto | Eliminar |
| Demasiados parámetros | Objeto parámetro |
| Flag arguments | Dividir función |

## TDD (Test-Driven Development)

```text
Red → Green → Refactor
1. Escribir test que falla
2. Hacer que pase
3. Refactorizar
```

## Frases Célebres

> "Clean code always looks like it was written by someone who cares."

> "The ratio of time spent reading versus writing is well over 10 to 1."

> "Leave the campground cleaner than you found it."

## Aplicación por Lenguaje

### Python
```python
def calculate_total(items: list, tax_rate: float) -> float:
    subtotal = sum(item.price for item in items)
    return subtotal * (1 + tax_rate)
```

### JavaScript
```javascript
const getActiveUsers = (users) => users.filter(u => u.isActive);
```

### Java
```java
public record User(String name, String email) {}
```

## Recursos

- *Clean Code* — Robert C. Martin
- *Clean Coder* — Robert C. Martin
- *Clean Architecture* — Robert C. Martin
- *Refactoring* — Martin Fowler
- *The Pragmatic Programmer* — Hunt & Thomas
