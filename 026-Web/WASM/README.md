# WebAssembly (WASM) — Código de Alto Rendimiento en el Navegador

## Descripción General

WebAssembly (WASM) es un formato binario de bajo nivel ejecutable en navegadores modernos a velocidad casi nativa. Permite compilar lenguajes como C, C++, Rust y Go para ejecutarse en el navegador. WASM no reemplaza JavaScript, sino que actúa como objetivo de compilación para tareas intensivas (procesamiento, juegos, edición).

---

## Conceptos Clave

- **Módulo WASM**: Binario compilado (`.wasm`) importable en JS.
- **Memoria lineal**: ArrayBuffer compartido entre WASM y JS.
- **Import/Export**: Funciones WASM llamables desde JS y viceversa.
- **Emscripten**: Toolchain para compilar C/C++ a WASM.
- **WASI**: System Interface para WASM fuera del navegador.

---

## Hola Mundo con Rust + wasm-pack

```rust
// src/lib.rs
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn greet(name: &str) -> String {
    format!("¡Hola, {}!", name)
}

#[wasm_bindgen]
pub fn fibonacci(n: u32) -> u64 {
    match n {
        0 => 0,
        1 => 1,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}
```

```bash
wasm-pack build --target web
```

```javascript
// main.js
import init, { greet, fibonacci } from './pkg/mi_app.js';

await init();
console.log(greet("Mundo"));       // "¡Hola, Mundo!"
console.log(fibonacci(20));        // 6765
```

---

## Con C++ y Emscripten

```cpp
// calculos.cpp
#include <emscripten/bind.h>
using namespace emscripten;

float calcularPi(int iteraciones) {
    float pi = 0.0;
    for (int i = 0; i < iteraciones; i++) {
        pi += (i % 2 == 0 ? 1.0 : -1.0) / (2 * i + 1);
    }
    return pi * 4;
}

EMSCRIPTEN_BINDINGS(mi_modulo) {
    function("calcularPi", &calcularPi);
}
```

```bash
emcc calculos.cpp -o calculos.js -s WASM=1
```

```javascript
const Module = require('./calculos.js');
Module.onRuntimeInitialized = () => {
    console.log(Module.calcularPi(10000000));
};
```

---

## Procesamiento de Imágenes con Go

```go
package main

import "syscall/js"

func processImage(this js.Value, args []js.Value) interface{} {
    pixels := make([]uint8, args[0].Get("length").Int())
    js.CopyBytesToGo(pixels, args[0])
    for i := range pixels {
        pixels[i] = 255 - pixels[i] // Negativo
    }
    js.CopyBytesToJS(args[0], pixels)
    return nil
}

func main() {
    js.Global().Set("invertImage", js.FuncOf(processImage))
    <-make(chan struct{})
}
```

```bash
GOOS=js GOARCH=wasm go build -o main.wasm
```

---

## Memoria Compartida

```javascript
// Escribir en memoria WASM desde JS
const memoria = new WebAssembly.Memory({ initial: 256, maximum: 256 });
const buffer = new Uint8Array(memoria.buffer);
buffer.set([72, 101, 108, 108, 111], 0);  // "Hello"

// Importar en módulo WASM
const importObject = { env: { memoria } };
const instance = await WebAssembly.instantiate(wasmBytes, importObject);
```

---

## WebAssembly Threads (SharedArrayBuffer)

```c
// threads.c
#include <pthread.h>
#include <emscripten.h>

void* sumar(void* arg) {
    int* data = (int*)arg;
    for (int i = 0; i < 1000000; i++) data[0]++;
    return NULL;
}

EMSCRIPTEN_KEEPALIVE
void parallelSum(int* data) {
    pthread_t t1, t2;
    pthread_create(&t1, NULL, sumar, data);
    pthread_create(&t2, NULL, sumar, data);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
}
```

Requiere `SharedArrayBuffer` habilitado vía headers `Cross-Origin-Opener-Policy` y `Cross-Origin-Embedder-Policy`.

---

## SIMD (Single Instruction Multiple Data)

WASM soporta operaciones SIMD para procesamiento vectorial:

```rust
#[target_feature(enable = "simd128")]
pub unsafe fn suma_vectorizada(a: &[f32], b: &[f32]) -> Vec<f32> {
    a.iter().zip(b).map(|(x, y)| x + y).collect()
}
```

---

## Depuración y Perfilado

```bash
# Chrome DevTools: Sources > WebAssembly
# Firefox: Debugger > WASM
# wasm2wat para depurar
wasm2wat modulo.wasm -o modulo.wat
```

---

## Casos de Uso

| Caso | Lenguaje | Librería |
|------|----------|----------|
| Editor de imágenes | C++ | ImageMagick WASM |
| Compilación en navegador | Rust | Babel WASM |
| Procesamiento de audio | C | FFmpeg WASM |
| Base de datos SQL | C | SQLite WASM |
| Juegos 3D | C++ | Unity/Unreal WASM |
| Simulación científica | Fortran | LAPACK WASM |

---

## Referencias

- [WebAssembly MDN](https://developer.mozilla.org/es/docs/WebAssembly)
- [Rust + wasm-pack](https://rustwasm.github.io/docs/wasm-pack)
- [Emscripten](https://emscripten.org)
- [Wasmtime (runtime WASI)](https://wasmtime.dev)
- [WebAssembly By Example](https://wasmbyexample.dev)
