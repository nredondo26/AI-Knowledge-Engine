# Go

Lenguaje compilado, tipado estático y fuerte, con recolector de basura. Creado por Robert Griesemer, Rob Pike y Ken Thompson (Google, 2009). Filosofía: simplicidad, concurrencia nativa, compilación rápida, sin herencia.

## Sintaxis básica

```go
package main

import "fmt"

func main() {
	fmt.Println("Hola, mundo")
}

// Variables: tipado estático con inferencia
var nombre string = "Ana"
edad := 30            // inferencia con :=
var activo bool       // zero value: false

// Tipos básicos: string, int, int8..64, uint, float32, float64, bool, byte, rune
// Compuestos: array, slice, map, struct, func, interface, channel

// Estructuras de control
if edad >= 18 {
	fmt.Println("Mayor")
} else if edad > 12 {
	fmt.Println("Adolescente")
} else {
	fmt.Println("Menor")
}

for i := 0; i < 5; i++ {
	fmt.Println(i)
}

for _, item := range []string{"a", "b", "c"} {
	fmt.Println(item)
}

i := 0
for i < 5 { // while
	i++
}

// Switch sin break (no fallthrough por defecto)
switch edad {
case 0, 1, 2, 3:
	fmt.Println("Bebé")
case 4, 5, 6, 7, 8, 9, 10:
	fmt.Println("Niño")
default:
	fmt.Println("Adulto")
}

// defer (LIFO, típico para limpiar recursos)
defer fmt.Println("Mundo")
fmt.Println("Hola")
```

## Tipado

Go es **estático**, **fuerte** y **estructural** para interfaces (duck typing en interfaces). No tiene genéricos hasta Go 1.18 (ahora sí). Sin herencia, sin clases, sin tipos nominales.

```go
// Genéricos (Go 1.18+)
func Map[T any, R any](items []T, fn func(T) R) []R {
	result := make([]R, len(items))
	for i, item := range items {
		result[i] = fn(item)
	}
	return result
}

func Filter[T any](items []T, fn func(T) bool) []T {
	var result []T
	for _, item := range items {
		if fn(item) {
			result = append(result, item)
		}
	}
	return result
}

// Constraint personalizado
type Number interface {
	~int | ~float64
}

func Sum[T Number](nums []T) T {
	var sum T
	for _, n := range nums {
		sum += n
	}
	return sum
}

// Interfaces estructurales (duck typing)
type Volador interface {
	Volar() string
}

type Aguila struct {
	Nombre string
}

func (a Aguila) Volar() string {
	return a.Nombre + " vuela"
}

func Lanzar(v Volador) {
	fmt.Println(v.Volar())
}

// Type assertion
var i interface{} = "hola"
s := i.(string)       // panic si no es string
s, ok := i.(string)   // ok=false si falla

// Type switch
switch v := i.(type) {
case string:
	fmt.Println("string:", v)
case int:
	fmt.Println("int:", v)
default:
	fmt.Printf("desconocido: %T\n", v)
}
```

## POO / Funcional

Go no tiene clases ni herencia. Usa **structs** con **métodos** y **composición** (embedding) en lugar de herencia.

```go
// Structs con métodos (POO sin clases)
type Vehiculo struct {
	Marca string
}

func (v Vehiculo) Mover() string {
	return v.Marca + " se mueve"
}

// Composición (embedding) — "hereda" comportamiento
type Coche struct {
	Vehiculo             // embedding (no herencia)
	Modelo string
}

func NewCoche(marca, modelo string) *Coche {
	return &Coche{Vehiculo{Marca: marca}, modelo}
}

func (c Coche) Mover() string {
	return c.Marca + " " + c.Modelo + " acelera"
}

// Interfaces vacías y comportamiento
type Animal interface {
	Sonido() string
}

type Perro struct{ Nombre string }
func (p Perro) Sonido() string { return "Guau" }

type Gato struct{ Nombre string }
func (g Gato) Sonido() string { return "Miau" }

func HacerSonido(a Animal) {
	fmt.Println(a.Sonido())
}

// Funcional: funciones como valores, closures, pero NO map/filter/reduce genéricos en stdlib
nums := []int{1, 2, 3, 4}
doblar := func(x int) int { return x * 2 }
doblados := Map(nums, doblar)

// Closures
func CrearContador() func() int {
	count := 0
	return func() int {
		count++
		return count
	}
}

contador := CrearContador()
fmt.Println(contador()) // 1
fmt.Println(contador()) // 2
```

## Concurrencia

La concurrencia es **ciudadana de primera clase** con gorutinas y canales (CSP — Communicating Sequential Processes).

```go
// Gorutina: hilo ligero (heap ~2KB, ~1M posibles por proceso)
func tarea(id int) {
	fmt.Printf("Gorutina %d ejecutándose\n", id)
}

go tarea(1)
go tarea(2)
go tarea(3)

time.Sleep(time.Second) // espera cutre (usar WaitGroup)

// WaitGroup
var wg sync.WaitGroup
for i := 0; i < 5; i++ {
	wg.Add(1)
	go func(id int) {
		defer wg.Done()
		fmt.Printf("Tarea %d\n", id)
		time.Sleep(100 * time.Millisecond)
	}(i)
}
wg.Wait()

// Canales (comunicación segura entre gorutinas)
ch := make(chan string)

go func() {
	ch <- "mensaje desde gorutina"
}()

msg := <-ch
fmt.Println(msg)

// Canales con buffer
chBuf := make(chan int, 3)
chBuf <- 1
chBuf <- 2
chBuf <- 3
close(chBuf)

for v := range chBuf {
	fmt.Println(v)
}

// Select (multiplexación de canales)
ch1 := make(chan string)
ch2 := make(chan string)

go func() { ch1 <- "A" }()
go func() { ch2 <- "B" }()

select {
case msg1 := <-ch1:
	fmt.Println(msg1)
case msg2 := <-ch2:
	fmt.Println(msg2)
case <-time.After(1 * time.Second):
	fmt.Println("timeout")
}

// Fan-out / Fan-in (patrón clásico)
func worker(id int, jobs <-chan int, results chan<- int) {
	for j := range jobs {
		results <- j * 2
	}
}

jobs := make(chan int, 100)
results := make(chan int, 100)

for w := 0; w < 3; w++ {
	go worker(w, jobs, results)
}

for j := 0; j < 10; j++ {
	jobs <- j
}
close(jobs)

for r := 0; r < 10; r++ {
	<-results
}
```

## Ecosistema

- **Go Modules** (`go mod`) — sistema oficial de módulos y dependencias (sin repositorio central único, se usan repos VCS directos)
- **Web**: net/http (stdlib), Gin, Echo, Fiber, Chi, Gorilla
- **CLI**: Cobra (estándar), urfave/cli
- **Testing**: testing (stdlib), testify (assertions), go-sqlmock, httptest (stdlib)
- **Bases de datos**: database/sql (stdlib), pgx (Postgres), GORM (ORM), sqlc (type-safe SQL)
- **Linting/Formato**: `gofmt` (oficial, obligatorio), `golangci-lint` (lint agregado), `staticcheck`
- **Observabilidad**: OpenTelemetry, Prometheus client, expvar, pprof (profiling stdlib)
- **Templates**: html/template (stdlib, safe), text/template
- **Compilación cruzada nativa**: `GOOS=linux GOARCH=arm64 go build`

## Herramientas

```bash
# Inicializar módulo
go mod init github.com/usuario/proyecto

# Añadir dependencia
go get github.com/gin-gonic/gin

# Compilar
go build -o app .
go build -ldflags="-s -w" .  # binario pequeño (~5-15MB)

# Lint y test
gofmt -s -w .
golangci-lint run ./...
go test -v -race -cover ./...

# Benchmark
go test -bench=. -benchmem ./...

# Profiling
go test -cpuprofile cpu.prof -memprofile mem.prof
go tool pprof -http :8080 cpu.prof

# Compilación cruzada
GOOS=linux GOARCH=amd64 go build -o app-linux
GOOS=windows GOARCH=amd64 go build -o app.exe

# Verificar dependencias
go mod tidy
go mod verify
go vet ./...
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [Web](../../026-Web/README.md)
- [CLI](../../009-CLI/README.md)
