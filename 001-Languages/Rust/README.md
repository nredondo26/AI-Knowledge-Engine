# Rust

Lenguaje compilado, tipado estático y fuerte, sin recolector de basura. Creado por Graydon Hoare (Mozilla, 2010). Filosofía: seguridad de memoria sin GC, concurrencia sin data races, cero costo de abstracciones.

## Sintaxis básica

```rust
fn main() {
    println!("Hola, mundo");
}

// Variables: inmutables por defecto (let), mutables con mut
let nombre = "Ana";       // inmutable, &str inferido
let mut edad: u32 = 30;   // mutable explícito
const ALTURA: f64 = 1.75; // constante compile-time
let activo = true;

// Tipos escalares: i8..i128, u8..u128, f32, f64, bool, char (4 bytes, Unicode)
// Compuestos: tuple, array, slice, struct, enum, String, &str

// Estructuras de control
if edad >= 18 {
    println!("Mayor");
} else if edad > 12 {
    println!("Adolescente");
} else {
    println!("Menor");
}

// if como expresión
let estado = if edad >= 18 { "adulto" } else { "menor" };

for i in 0..5 {
    println!("{}", i);
}

for item in ["a", "b", "c"].iter() {
    println!("{}", item);
}

let mut contador = 0;
while contador < 5 {
    contador += 1;
}

// loop infinito con break
loop {
    contador += 1;
    if contador >= 10 {
        break;
    }
}

// Pattern matching
let numero = 3;
match numero {
    0 => println!("cero"),
    1..=3 => println!("pequeño"),
    _ => println!("grande"),
}

// if let (cuando solo importa un caso)
if let Some(valor) = opcional {
    println!("{}", valor);
}
```

## Tipado / Ownership

El sistema de tipos central de Rust es **ownership** + **borrowing** + **lifetimes**. Sin estos conceptos no se entiende Rust.

```rust
// Ownership: cada valor tiene un único dueño
fn main() {
    let s1 = String::from("hola");
    let s2 = s1; // s1 se mueve a s2 (no copia)
    // println!("{}", s1); // ERROR: s1 ya no es válido
    println!("{}", s2);
}

// Borrowing: referencias (&T inmutable, &mut T mutable)
fn calcular_longitud(s: &String) -> usize {
    s.len()
} // s sale de scope, pero no se dropea (solo prestado)

fn modificar(s: &mut String) {
    s.push_str(" mundo");
}

// Reglas: una referencia mutable O múltiples inmutables, nunca ambas
let mut texto = String::from("hola");
let r1 = &texto;    // ok
let r2 = &texto;    // ok
// let r3 = &mut texto; // ERROR: ya hay prestamos inmutables
println!("{} {}", r1, r2);

// Lifetimes (anotaciones 'a)
fn mayor<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}

// Structs con lifetimes
struct Prestamo<'a> {
    referencia: &'a str,
}

impl<'a> Prestamo<'a> {
    fn longitud(&self) -> usize {
        self.referencia.len()
    }
}

// Tipos algebraicos (enums + pattern matching)
enum Option<T> {
    Some(T),
    None,
}

enum Result<T, E> {
    Ok(T),
    Err(E),
}

fn dividir(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("División por cero"))
    } else {
        Ok(a / b)
    }
}
```

## POO / Funcional

Rust no tiene clases ni herencia. Usa **structs + impl** + **traits** (composición sobre herencia, duck typing en compilación).

```rust
// Structs con métodos (impl)
struct Vehiculo {
    marca: String,
}

impl Vehiculo {
    fn new(marca: &str) -> Self {
        Self { marca: marca.to_string() }
    }

    fn mover(&self) -> String {
        format!("{} se mueve", self.marca)
    }
}

// Traits (interfaces en tiempo de compilación)
trait Volador {
    fn volar(&self) -> String;
}

struct Aguila {
    nombre: String,
}

impl Volador for Aguila {
    fn volar(&self) -> String {
        format!("{} vuela", self.nombre)
    }
}

// Genéricos con trait bounds
fn lanzar<T: Volador>(objeto: T) {
    println!("{}", objeto.volar());
}

// Composición sobre herencia
struct Coche {
    vehiculo: Vehiculo,
    modelo: String,
}

impl Coche {
    fn mover(&self) -> String {
        format!("{} {} acelera", self.vehiculo.marca, self.modelo)
    }
}

// Funcional: closures, iterators, map/filter/fold
fn funcional() {
    let nums = vec![1, 2, 3, 4, 5];

    let doblados: Vec<i32> = nums.iter()
        .map(|x| x * 2)
        .collect();

    let pares: Vec<&i32> = nums.iter()
        .filter(|x| *x % 2 == 0)
        .collect();

    let suma: i32 = nums.iter()
        .fold(0, |acc, x| acc + x);

    // Closures con captura
    let factor = 3;
    let multiplicar = |x: i32| x * factor;
    println!("{}", multiplicar(5)); // 15
}
```

## Concurrencia

Rust previene **data races** en compilación mediante `Send` y `Sync` (traits marcadores).

```rust
// Hilos (std::thread)
use std::thread;
use std::sync::{Arc, Mutex};

fn main() {
    let mut handles = vec![];

    for i in 0..5 {
        handles.push(thread::spawn(move || {
            println!("Hilo {}", i);
            i * i
        }));
    }

    for h in handles {
        println!("Resultado: {}", h.join().unwrap());
    }
}

// Canales (std::sync::mpsc — múltiple productor, single consumer)
use std::sync::mpsc;

let (tx, rx) = mpsc::channel();

thread::spawn(move || {
    tx.send("mensaje desde hilo").unwrap();
});

println!("{}", rx.recv().unwrap());

// Arc<Mutex<T>> para estado compartido
let contador = Arc::new(Mutex::new(0));
let mut handles = vec![];

for _ in 0..10 {
    let c = Arc::clone(&contador);
    handles.push(thread::spawn(move || {
        let mut num = c.lock().unwrap();
        *num += 1;
    }));
}

for h in handles {
    h.join().unwrap();
}

println!("Contador: {}", *contador.lock().unwrap());

// async/await (Tokio como runtime estándar)
// [dependencies]
// tokio = { version = "1", features = ["full"] }

// #[tokio::main]
// async fn main() {
//     let tarea1 = tokio::spawn(async {
//         tokio::time::sleep(Duration::from_millis(100)).await;
//         42
//     });
//
//     let tarea2 = tokio::spawn(async {
//         tokio::time::sleep(Duration::from_millis(50)).await;
//         24
//     });
//
//     let (r1, r2) = tokio::join!(tarea1, tarea2);
//     println!("{} {}", r1.unwrap(), r2.unwrap());
// }

// Rayon (paralelismo de datos)
// use rayon::prelude::*;
// fn main() {
//     let nums = vec![1, 2, 3, 4, 5, 6, 7, 8];
//     let sum: i32 = nums.par_iter().sum();
//     println!("Suma paralela: {}", sum);
// }
```

## Ecosistema

- **Cargo** — build system, gestor de paquetes, test runner, documentador (todo en uno)
- **crates.io** — repositorio central de paquetes (~170k+ crates)
- **Async runtimes**: Tokio (estándar), async-std, smol
- **Web**: Axum (Tokio ecosystem), Actix Web (actor-based), Rocket, Warp, Tide
- **CLI**: clap (parser args), structopt (ahora en clap), colored, indicatif
- **Serialización**: serde (estándar, derive), bincode, json (serde_json)
- **Bases de datos**: sqlx (async, compile-time checked), diesel (ORM), sea-orm
- **Testing**: std `#[test]`, proptest (property-based), criterion (benchmarks)
- **Linting/Formato**: `rustfmt` (oficial), `clippy` (lint oficial), `cargo-deny` (licencias)
- **Documentación**: rustdoc (documentación en código con ejemplos compilables)
- **Embedded**: `no_std`, Embassy (async embedded), esp-rs

## Herramientas

```bash
# Instalación
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Proyecto nuevo
cargo new mi_proyecto
cd mi_proyecto

# Compilar y ejecutar
cargo build
cargo build --release
cargo run
cargo check  # solo verificar, sin compilar binario

# Tests
cargo test
cargo test -- --nocapture  # ver stdout

# Benchmarks
cargo bench

# Lint
cargo clippy -- -D warnings
cargo fmt

# Documentación
cargo doc --open

# Publicar crate
cargo publish

# Analizar binario
cargo bloat --crates
cargo size --release -- -A
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [CLI](../../009-CLI/README.md)
- [Sistemas](../../008-Sistemas/README.md)
