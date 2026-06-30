# Patrones de Diseño: Estructurales

## Visión General

Los patrones estructurales explican cómo ensamblar objetos y clases en estructuras más grandes, manteniendo la flexibilidad y eficiencia. Se centran en la composición y la herencia para definir relaciones entre entidades.

## Patrones Cubiertos

| Patrón | Propósito | Tipo |
|--------|-----------|------|
| **Adapter** | Compatibiliza interfaces incompatibles | Clase/Objeto |
| **Bridge** | Desacopla abstracción de implementación | Objeto |
| **Composite** | Trata objetos individuales y compuestos uniformemente | Objeto |
| **Decorator** | Añade responsabilidades dinámicamente | Objeto |
| **Facade** | Interfaz simplificada para un subsistema | Objeto |
| **Flyweight** | Comparte objetos granulares para ahorrar memoria | Objeto |
| **Proxy** | Controla el acceso a otro objeto | Objeto |

---

## 1. Adapter (Wrapper)

Convierte la interfaz de una clase en otra que el cliente espera.

```java
// Interfaz esperada por el cliente
interface PaymentProcessor {
    void pay(String amount);
}

// API externa incompatible
class StripeAPI {
    public void charge(double amount, String currency) {
        System.out.printf("Cargando %.2f %s via Stripe%n", amount, currency);
    }
}

// Adapter
class StripeAdapter implements PaymentProcessor {
    private StripeAPI api = new StripeAPI();

    public void pay(String amount) {
        double value = Double.parseDouble(amount.replace("$", ""));
        api.charge(value, "USD");
    }
}

// Uso
PaymentProcessor processor = new StripeAdapter();
processor.pay("$49.99");
```

**Cuándo usar:** Integrar un componente legacy o de terceros con interfaz incompatible.

---

## 2. Bridge

Separa la abstracción de su implementación para que ambas puedan variar independientemente.

```java
// Implementación
interface Device {
    void turnOn();
    void turnOff();
    void setVolume(int percent);
}

class TV implements Device {
    public void turnOn()   { System.out.println("TV encendida"); }
    public void turnOff()  { System.out.println("TV apagada"); }
    public void setVolume(int percent) { System.out.println("TV volumen: " + percent); }
}

class Radio implements Device {
    public void turnOn()   { System.out.println("Radio encendida"); }
    public void turnOff()  { System.out.println("Radio apagada"); }
    public void setVolume(int percent) { System.out.println("Radio volumen: " + percent); }
}

// Abstracción
abstract class RemoteControl {
    protected Device device;
    RemoteControl(Device device) { this.device = device; }
    abstract void togglePower();
    abstract void volumeUp();
}

class BasicRemote extends RemoteControl {
    private boolean isOn = false;

    BasicRemote(Device device) { super(device); }

    void togglePower() {
        if (isOn) { device.turnOff(); isOn = false; }
        else { device.turnOn(); isOn = true; }
    }

    void volumeUp() { device.setVolume(10); }
}

// Uso
RemoteControl remote = new BasicRemote(new TV());
remote.togglePower();
remote.volumeUp();

RemoteControl radioRemote = new BasicRemote(new Radio());
radioRemote.togglePower();
```

**Cuándo usar:** Evitar herencia múltiple; abstracción e implementación deben ser extensibles independientemente.

---

## 3. Composite

Compone objetos en estructuras de árbol para representar jerarquías parte-todo.

```java
abstract class FileSystemNode {
    protected String name;
    FileSystemNode(String name) { this.name = name; }
    public abstract int getSize();
    public abstract void display(int indent);
}

class File extends FileSystemNode {
    private int size;

    File(String name, int size) {
        super(name);
        this.size = size;
    }

    public int getSize() { return size; }

    public void display(int indent) {
        System.out.println("  ".repeat(indent) + "📄 " + name + " (" + size + " KB)");
    }
}

class Directory extends FileSystemNode {
    private List<FileSystemNode> children = new ArrayList<>();

    Directory(String name) { super(name); }

    public void add(FileSystemNode node) { children.add(node); }
    public void remove(FileSystemNode node) { children.remove(node); }

    public int getSize() {
        return children.stream().mapToInt(FileSystemNode::getSize).sum();
    }

    public void display(int indent) {
        System.out.println("  ".repeat(indent) + "📁 " + name + "/");
        for (var child : children) child.display(indent + 1);
    }
}

// Uso
var root = new Directory("proyecto");
var src = new Directory("src");
src.add(new File("main.java", 10));
src.add(new File("utils.java", 5));
root.add(src);
root.add(new File("README.md", 2));
root.display(0);
System.out.println("Total: " + root.getSize() + " KB");
```

**Cuándo usar:** Estructuras jerárquicas recursivas (sistemas de archivos, menús, UI).

---

## 4. Decorator

Añade comportamiento a objetos existentes dinámicamente sin alterar su estructura.

```java
interface Coffee {
    double getCost();
    String getDescription();
}

class SimpleCoffee implements Coffee {
    public double getCost() { return 2.0; }
    public String getDescription() { return "Café simple"; }
}

abstract class CoffeeDecorator implements Coffee {
    protected Coffee coffee;
    CoffeeDecorator(Coffee coffee) { this.coffee = coffee; }
    public double getCost() { return coffee.getCost(); }
    public String getDescription() { return coffee.getDescription(); }
}

class MilkDecorator extends CoffeeDecorator {
    MilkDecorator(Coffee coffee) { super(coffee); }
    public double getCost() { return super.getCost() + 0.5; }
    public String getDescription() { return super.getDescription() + ", Leche"; }
}

class WhipDecorator extends CoffeeDecorator {
    WhipDecorator(Coffee coffee) { super(coffee); }
    public double getCost() { return super.getCost() + 0.7; }
    public String getDescription() { return super.getDescription() + ", Crema"; }
}

// Uso
Coffee coffee = new SimpleCoffee();
coffee = new MilkDecorator(coffee);
coffee = new WhipDecorator(coffee);
System.out.println(coffee.getDescription() + " = $" + coffee.getCost());
// Café simple, Leche, Crema = $3.2
```

**Cuándo usar:** Añadir responsabilidades a objetos de forma transparente; evitar subclases por cada combinación.

---

## 5. Facade

Proporciona una interfaz unificada y simplificada para un conjunto de interfaces de un subsistema.

```java
// Subsistemas complejos
class CPU {
    void freeze() { System.out.println("CPU: freeze"); }
    void jump(long position) { System.out.println("CPU: jump to " + position); }
    void execute() { System.out.println("CPU: execute"); }
}

class Memory {
    void load(long position, byte[] data) {
        System.out.println("Memory: load " + data.length + " bytes at " + position);
    }
}

class HardDrive {
    byte[] read(long lba, int size) {
        System.out.println("HDD: read " + size + " bytes from LBA " + lba);
        return new byte[size];
    }
}

// Facade
class ComputerFacade {
    private CPU cpu = new CPU();
    private Memory memory = new Memory();
    private HardDrive hdd = new HardDrive();
    private static final long BOOT_ADDRESS = 0x0000;

    public void start() {
        cpu.freeze();
        memory.load(BOOT_ADDRESS, hdd.read(0, 1024));
        cpu.jump(BOOT_ADDRESS);
        cpu.execute();
    }
}

// Uso
new ComputerFacade().start();
```

**Cuándo usar:** Simplificar el uso de subsistemas complejos; desacoplar cliente de múltiples componentes.

---

## 6. Flyweight

Comparte partes comunes entre múltiples objetos para reducir el uso de memoria.

```java
class TreeType {  // Flyweight (intrínseco)
    private String name;
    private String color;
    private String texture;

    TreeType(String name, String color, String texture) {
        this.name = name;
        this.color = color;
        this.texture = texture;
    }

    void draw(int x, int y) {
        System.out.printf("Dibujando %s en (%d,%d)%n", name, x, y);
    }
}

class TreeFactory {
    private static Map<String, TreeType> types = new HashMap<>();

    static TreeType getTreeType(String name, String color, String texture) {
        String key = name + "|" + color + "|" + texture;
        return types.computeIfAbsent(key, k -> new TreeType(name, color, texture));
    }
}

class Tree {  // Contexto (extrínseco)
    private int x, y;
    private TreeType type;

    Tree(int x, int y, TreeType type) {
        this.x = x;
        this.y = y;
        this.type = type;
    }

    void draw() { type.draw(x, y); }
}

// Uso
var forest = new ArrayList<Tree>();
forest.add(new Tree(10, 20, TreeFactory.getTreeType("Roble", "Verde", "Rugosa")));
forest.add(new Tree(30, 40, TreeFactory.getTreeType("Roble", "Verde", "Rugosa"))); // Reutiliza
```

**Cuándo usar:** Muchos objetos similares que consumen mucha memoria; el estado intrínseco puede compartirse.

---

## 7. Proxy

Proporciona un sustituto o marcador de posición para controlar el acceso a otro objeto.

```java
interface Image {
    void display();
}

class RealImage implements Image {
    private String filename;

    RealImage(String filename) {
        this.filename = filename;
        loadFromDisk();
    }

    private void loadFromDisk() {
        System.out.println("Cargando " + filename + " desde disco...");
    }

    public void display() {
        System.out.println("Mostrando " + filename);
    }
}

class ProxyImage implements Image {
    private RealImage realImage;
    private String filename;

    ProxyImage(String filename) { this.filename = filename; }

    public void display() {
        if (realImage == null) realImage = new RealImage(filename);
        realImage.display();
    }
}

// Uso (lazy loading)
Image image = new ProxyImage("foto.jpg");
image.display();  // Carga + muestra
image.display();  // Solo muestra (ya cargada)
```

**Variantes:**
- **Virtual proxy** — Lazy loading (ejemplo arriba)
- **Protection proxy** — Control de acceso
- **Remote proxy** — Stub para objetos remotos (RMI/gRPC)
- **Logging proxy** — Auditoría de llamadas

## Comparativa

| Patrón | Propósito | Relación |
|--------|-----------|----------|
| Adapter | Compatibilizar interfaces | Transforma |
| Bridge | Abstracción/implementación independientes | Desacopla |
| Composite | Tratar objetos y compuestos uniformemente | Jerarquiza |
| Decorator | Añadir comportamiento dinámicamente | Envuelve |
| Facade | Simplificar subsistema | Oculta |
| Flyweight | Compartir objetos granulares | Optimiza |
| Proxy | Controlar acceso | Sustituye |

## Referencias

- *Design Patterns: Elements of Reusable Object-Oriented Software* — GoF
- [Refactoring Guru — Structural Patterns](https://refactoring.guru/design-patterns/structural)
- [SourceMaking — Structural](https://sourcemaking.com/design_patterns/structural)
