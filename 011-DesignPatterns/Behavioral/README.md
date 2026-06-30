# Patrones de Diseño: Comportamentales

## Visión General

Los patrones comportamentales se centran en algoritmos y la asignación de responsabilidades entre objetos. Describen patrones de comunicación, delegación y flujo de control.

## Patrones Cubiertos

| Patrón | Propósito |
|--------|-----------|
| **Chain of Responsibility** | Pasa la petición por una cadena de handlers |
| **Command** | Encapsula una petición como objeto |
| **Iterator** | Accede secuencialmente a los elementos de una colección |
| **Mediator** | Reduce el acoplamiento entre objetos que se comunican |
| **Memento** | Captura y restaura el estado interno de un objeto |
| **Observer** | Notifica cambios a múltiples suscriptores |
| **State** | Cambia el comportamiento según el estado interno |
| **Strategy** | Selecciona un algoritmo en tiempo de ejecución |
| **Template Method** | Define el esqueleto de un algoritmo |
| **Visitor** | Separa un algoritmo de la estructura de objetos |

---

## 1. Chain of Responsibility

```java
abstract class LogHandler {
    protected LogHandler next;
    protected LogLevel level;

    public LogHandler setNext(LogHandler next) {
        this.next = next;
        return next;
    }

    public void handle(LogLevel level, String message) {
        if (this.level.ordinal() <= level.ordinal()) {
            write(message);
        }
        if (next != null) next.handle(level, message);
    }

    protected abstract void write(String message);
}

enum LogLevel { DEBUG, INFO, WARN, ERROR }

class ConsoleHandler extends LogHandler {
    ConsoleHandler() { this.level = LogLevel.DEBUG; }
    protected void write(String msg) { System.out.println("[CONSOLE] " + msg); }
}

class FileHandler extends LogHandler {
    FileHandler() { this.level = LogLevel.WARN; }
    protected void write(String msg) { System.out.println("[FILE] " + msg); }
}

class EmailHandler extends LogHandler {
    EmailHandler() { this.level = LogLevel.ERROR; }
    protected void write(String msg) { System.out.println("[EMAIL] " + msg); }
}

// Uso
var chain = new ConsoleHandler();
chain.setNext(new FileHandler()).setNext(new EmailHandler());
chain.handle(LogLevel.WARN, "Memoria baja");
```

---

## 2. Command

```java
interface Command {
    void execute();
    void undo();
}

class Light {
    void on()  { System.out.println("Luz encendida"); }
    void off() { System.out.println("Luz apagada"); }
}

class LightOnCommand implements Command {
    private Light light;
    LightOnCommand(Light light) { this.light = light; }
    public void execute() { light.on(); }
    public void undo()    { light.off(); }
}

class RemoteControl {
    private Command command;
    private Command lastCommand;

    void setCommand(Command cmd) { this.command = cmd; }
    void pressButton() {
        command.execute();
        lastCommand = command;
    }
    void pressUndo() {
        if (lastCommand != null) lastCommand.undo();
    }
}

// Uso
var light = new Light();
RemoteControl remote = new RemoteControl();
remote.setCommand(new LightOnCommand(light));
remote.pressButton();
remote.pressUndo();
```

---

## 3. Iterator

```java
interface Iterator<T> {
    boolean hasNext();
    T next();
}

class TreeNode<T> {
    T value;
    TreeNode<T> left, right;

    TreeNode(T value) { this.value = value; }
}

class InOrderIterator<T> implements Iterator<T> {
    private Stack<TreeNode<T>> stack = new Stack<>();

    InOrderIterator(TreeNode<T> root) {
        pushLeft(root);
    }

    private void pushLeft(TreeNode<T> node) {
        while (node != null) {
            stack.push(node);
            node = node.left;
        }
    }

    public boolean hasNext() { return !stack.isEmpty(); }

    public T next() {
        var node = stack.pop();
        pushLeft(node.right);
        return node.value;
    }
}

// Uso
var root = new TreeNode<>(10);
root.left = new TreeNode<>(5);
root.right = new TreeNode<>(20);
var iter = new InOrderIterator<>(root);
while (iter.hasNext()) System.out.println(iter.next());  // 5, 10, 20
```

---

## 4. Mediator

```java
interface Mediator {
    void notify(Component sender, String event);
}

class DialogMediator implements Mediator {
    private Button saveButton;
    private TextField nameField;

    public void notify(Component sender, String event) {
        if (sender == nameField && event.equals("text_changed")) {
            saveButton.setEnabled(!nameField.getText().isEmpty());
        }
    }
}

abstract class Component {
    protected Mediator mediator;
    Component(Mediator mediator) { this.mediator = mediator; }
}

class Button extends Component {
    private boolean enabled;
    Button(Mediator m) { super(m); }
    void click() { mediator.notify(this, "click"); }
    void setEnabled(boolean e) { this.enabled = e; }
}

class TextField extends Component {
    private String text = "";
    TextField(Mediator m) { super(m); }
    void setText(String t) { text = t; mediator.notify(this, "text_changed"); }
    String getText() { return text; }
}
```

---

## 5. Memento

```java
class EditorMemento {
    private final String content;

    EditorMemento(String content) { this.content = content; }
    String getContent() { return content; }
}

class Editor {
    private String content = "";

    void write(String text) { content += text; }
    String getContent() { return content; }

    EditorMemento save() {
        return new EditorMemento(content);
    }

    void restore(EditorMemento memento) {
        content = memento.getContent();
    }
}

class History {
    private Stack<EditorMemento> mementos = new Stack<>();

    void push(EditorMemento m) { mementos.push(m); }
    EditorMemento pop() { return mementos.pop(); }
}

// Uso
var editor = new Editor();
var history = new History();

editor.write("Hola ");
history.push(editor.save());
editor.write("mundo");
System.out.println(editor.getContent());  // "Hola mundo"

editor.restore(history.pop());
System.out.println(editor.getContent());  // "Hola "
```

---

## 6. Observer

```java
interface Observer {
    void update(String event, Object data);
}

class EventBus {
    private Map<String, List<Observer>> listeners = new HashMap<>();

    void subscribe(String eventType, Observer observer) {
        listeners.computeIfAbsent(eventType, k -> new ArrayList<>()).add(observer);
    }

    void unsubscribe(String eventType, Observer observer) {
        var list = listeners.get(eventType);
        if (list != null) list.remove(observer);
    }

    void emit(String eventType, Object data) {
        var list = listeners.get(eventType);
        if (list != null) list.forEach(o -> o.update(eventType, data));
    }
}

// Uso
EventBus bus = new EventBus();
bus.subscribe("user:created", (event, data) -> System.out.println("Email: " + data));
bus.subscribe("user:created", (event, data) -> System.out.println("Audit: " + data));
bus.emit("user:created", "user@example.com");
```

---

## 7. State

```java
interface State {
    void play();
    void pause();
    void stop();
}

class PlayingState implements State {
    private MediaPlayer player;
    PlayingState(MediaPlayer p) { this.player = p; }
    public void play() { System.out.println("Ya reproduciendo"); }
    public void pause() { System.out.println("Pausado"); player.setState(new PausedState(player)); }
    public void stop() { System.out.println("Detenido"); player.setState(new StoppedState(player)); }
}

class StoppedState implements State {
    private MediaPlayer player;
    StoppedState(MediaPlayer p) { this.player = p; }
    public void play() { System.out.println("Reproduciendo"); player.setState(new PlayingState(player)); }
    public void pause() { System.out.println("Sin efecto (detenido)"); }
    public void stop() { System.out.println("Ya detenido"); }
}

class MediaPlayer {
    private State state;
    MediaPlayer() { this.state = new StoppedState(this); }
    void setState(State s) { this.state = s; }
    void play()  { state.play(); }
    void pause() { state.pause(); }
    void stop()  { state.stop(); }
}
```

---

## 8. Strategy

```java
interface SortStrategy {
    <T extends Comparable<T>> void sort(List<T> items);
}

class QuickSort implements SortStrategy {
    public <T extends Comparable<T>> void sort(List<T> items) {
        System.out.println("Ordenando con QuickSort");
        // Implementación...
    }
}

class MergeSort implements SortStrategy {
    public <T extends Comparable<T>> void sort(List<T> items) {
        System.out.println("Ordenando con MergeSort");
        // Implementación...
    }
}

class SortedList {
    private List<String> items = new ArrayList<>();
    private SortStrategy strategy;

    SortedList(SortStrategy strategy) { this.strategy = strategy; }

    void setStrategy(SortStrategy s) { this.strategy = s; }
    void add(String item) { items.add(item); }

    void sort() { strategy.sort(items); }
}

// Uso
var list = new SortedList(new QuickSort());
list.add("banana");
list.add("apple");
list.sort();  // QuickSort

list.setStrategy(new MergeSort());
list.sort();  // MergeSort
```

---

## 9. Template Method

```java
abstract class DataMiner {
    // Template method
    public final void mine(String path) {
        openFile(path);
        extractData();
        parseData();
        analyzeData();
        sendReport();
        closeFile();
    }

    protected abstract void openFile(String path);
    protected void extractData() { System.out.println("Extrayendo datos genéricos"); }
    protected abstract void parseData();
    protected void analyzeData() { System.out.println("Análisis genérico"); }

    // Hook (opcional)
    protected void sendReport() { System.out.println("Reporte enviado por email"); }

    protected abstract void closeFile();
}

class PDFDataMiner extends DataMiner {
    protected void openFile(String path) { System.out.println("Abriendo PDF: " + path); }
    protected void parseData() { System.out.println("Parseando PDF"); }
    protected void closeFile() { System.out.println("Cerrando PDF"); }
}
```

---

## 10. Visitor

```java
interface Visitor {
    void visit(Paragraph p);
    void visit(Table t);
    void visit(Image i);
}

interface Element { void accept(Visitor v); }

class Paragraph implements Element {
    String text;
    Paragraph(String t) { text = t; }
    public void accept(Visitor v) { v.visit(this); }
}

class Table implements Element {
    int rows, cols;
    Table(int r, int c) { rows = r; cols = c; }
    public void accept(Visitor v) { v.visit(this); }
}

class HTMLExportVisitor implements Visitor {
    public void visit(Paragraph p) { System.out.println("<p>" + p.text + "</p>"); }
    public void visit(Table t) { System.out.println("<table rows=" + t.rows + " cols=" + t.cols + "/>"); }
    public void visit(Image i) { System.out.println("<img src='" + i.src + "'/>"); }
}

class Image implements Element {
    String src;
    Image(String s) { src = s; }
    public void accept(Visitor v) { v.visit(this); }
}

// Uso
List<Element> doc = Arrays.asList(new Paragraph("Hola"), new Table(2, 3));
Visitor exporter = new HTMLExportVisitor();
doc.forEach(e -> e.accept(exporter));
```

## Referencias

- *Design Patterns: Elements of Reusable Object-Oriented Software* — GoF
- [Refactoring Guru — Behavioral Patterns](https://refactoring.guru/design-patterns/behavioral)
- [SourceMaking — Behavioral](https://sourcemaking.com/design_patterns/behavioral)
