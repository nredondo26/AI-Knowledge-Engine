# Patrones de Diseño: Creacionales

## Visión General

Los patrones creacionales abstraen el proceso de instanciación de objetos. Ayudan a que un sistema sea independiente de cómo se crean, componen y representan sus objetos.

## Patrones Cubiertos

| Patrón | Propósito | Tipo |
|--------|-----------|------|
| **Singleton** | Una única instancia global | Objeto |
| **Factory Method** | Creación mediante subclases | Clase |
| **Abstract Factory** | Familias de objetos relacionados | Objeto |
| **Builder** | Objetos complejos paso a paso | Objeto |
| **Prototype** | Clonación de objetos | Objeto |

---

## 1. Singleton

Garantiza que una clase tenga solo una instancia y proporciona un punto de acceso global.

```java
public class Logger {
    private static volatile Logger instance;
    private LogLevel level = LogLevel.INFO;

    private Logger() {}

    public static Logger getInstance() {
        if (instance == null) {
            synchronized (Logger.class) {
                if (instance == null) {
                    instance = new Logger();
                }
            }
        }
        return instance;
    }

    public void log(String message, LogLevel level) {
        if (level.ordinal() >= this.level.ordinal()) {
            System.out.printf("[%s] %s%n", level, message);
        }
    }
}

// Uso
Logger.getInstance().log("App iniciada", LogLevel.INFO);
```

**Cuándo usar:** Configuración global, pools de conexiones, logging, cachés.

**Anti-patrón:** Uso excesivo — dificulta testing (no se puede mockear el constructor).

---

## 2. Factory Method (Virtual Constructor)

Define una interfaz para crear un objeto, pero permite que las subclases decidan qué clase instanciar.

```java
abstract class DocumentParser {
    public abstract Document parse(String content);
}

class PDFParser extends DocumentParser {
    public Document parse(String content) {
        return new PDFDocument(content);
    }
}

class HTMLParser extends DocumentParser {
    public Document parse(String content) {
        return new HTMLDocument(content);
    }
}

// Factory Method
enum DocumentType { PDF, HTML, XML }

class ParserFactory {
    public static DocumentParser createParser(DocumentType type) {
        return switch (type) {
            case PDF -> new PDFParser();
            case HTML -> new HTMLParser();
            case XML -> new XMLParser();
        };
    }
}

// Uso
var parser = ParserFactory.createParser(DocumentType.PDF);
var doc = parser.parse(content);
```

**Cuándo usar:** La clase no puede anticipar la clase de objetos que debe crear; las subclases especifican sus propios objetos.

---

## 3. Abstract Factory

Proporciona una interfaz para crear familias de objetos relacionados sin especificar sus clases concretas.

```java
interface UIFactory {
    Button createButton();
    Checkbox createCheckbox();
    TextField createTextField();
}

class WindowsFactory implements UIFactory {
    public Button createButton()    { return new WindowsButton(); }
    public Checkbox createCheckbox() { return new WindowsCheckbox(); }
    public TextField createTextField() { return new WindowsTextField(); }
}

class MacFactory implements UIFactory {
    public Button createButton()    { return new MacButton(); }
    public Checkbox createCheckbox() { return new MacCheckbox(); }
    public TextField createTextField() { return new MacTextField(); }
}

class Application {
    private final UIFactory factory;

    Application(UIFactory factory) {
        this.factory = factory;
    }

    void render() {
        var btn = factory.createButton();
        var chk = factory.createCheckbox();
        btn.render();
        chk.render();
    }
}

// Uso
var app = new Application(new WindowsFactory());
app.render();
```

**Cuándo usar:** El sistema debe configurarse con una de múltiples familias de productos.

---

## 4. Builder

Separa la construcción de un objeto complejo de su representación, permitiendo diferentes representaciones.

```java
class HttpRequest {
    private String method;
    private String url;
    private Map<String, String> headers;
    private String body;

    private HttpRequest() {}

    public static class Builder {
        private final HttpRequest request = new HttpRequest();

        public Builder method(String method) {
            request.method = method;
            return this;
        }

        public Builder url(String url) {
            request.url = url;
            return this;
        }

        public Builder header(String key, String value) {
            if (request.headers == null)
                request.headers = new HashMap<>();
            request.headers.put(key, value);
            return this;
        }

        public Builder body(String body) {
            request.body = body;
            return this;
        }

        public HttpRequest build() {
            if (request.url == null)
                throw new IllegalStateException("URL es obligatoria");
            return request;
        }
    }
}

// Uso
HttpRequest req = new HttpRequest.Builder()
    .method("POST")
    .url("https://api.example.com/data")
    .header("Content-Type", "application/json")
    .header("Authorization", "Bearer token123")
    .body("{\"name\": \"test\"}")
    .build();
```

**Cuándo usar:** Objetos con muchos parámetros opcionales o configuraciones complejas paso a paso.

---

## 5. Prototype

Permite crear nuevos objetos clonando una instancia existente (prototipo).

```java
abstract class Shape implements Cloneable {
    protected int x, y;
    protected String color;

    public abstract void draw();

    public Shape clone() {
        try {
            return (Shape) super.clone();
        } catch (CloneNotSupportedException e) {
            throw new RuntimeException(e);
        }
    }
}

class Rectangle extends Shape {
    private int width, height;

    Rectangle(int x, int y, int w, int h, String color) {
        this.x = x;
        this.y = y;
        this.width = w;
        this.height = h;
        this.color = color;
    }

    public void draw() {
        System.out.printf("Rectángulo %s en (%d,%d) %dx%d%n", color, x, y, width, height);
    }
}

class ShapeRegistry {
    private static Map<String, Shape> prototypes = new HashMap<>();

    static {
        prototypes.put("big_red", new Rectangle(0, 0, 100, 50, "red"));
        prototypes.put("small_blue", new Rectangle(0, 0, 30, 20, "blue"));
    }

    public static Shape createShape(String key) {
        return prototypes.get(key).clone();
    }
}

// Uso
Shape s1 = ShapeRegistry.createShape("big_red");
s1.draw();
Shape s2 = ShapeRegistry.createShape("big_red");
s2.x = 50; // Modificación sin afectar prototipo
```

**Cuándo usar:** Costo de creación alto (DB, red, I/O) o el objeto tiene muchas configuraciones posibles.

---

## Comparativa

| Patrón | Complejidad | Flexibilidad | Acoplamiento |
|--------|-------------|--------------|--------------|
| Singleton | Baja | Mínima | Alto (acceso global) |
| Factory Method | Media | Media | Bajo |
| Abstract Factory | Alta | Alta | Muy bajo |
| Builder | Media | Alta | Bajo |
| Prototype | Baja | Alta | Bajo |

## Referencias

- *Design Patterns: Elements of Reusable Object-Oriented Software* — Gamma, Helm, Johnson, Vlissides (GoF)
- [Refactoring Guru — Creational Patterns](https://refactoring.guru/design-patterns/creational)
- [SourceMaking — Creational](https://sourcemaking.com/design_patterns/creational)
