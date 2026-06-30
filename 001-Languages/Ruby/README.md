# Ruby

Lenguaje interpretado, orientado a objetos puro, tipado dinámico y fuerte. Creado por Yukihiro "Matz" Matsumoto (1995). Runtime: YARV (CRuby), JRuby, TruffleRuby. Filosofía: optimizado para felicidad del desarrollador, convención sobre configuración, principio de menor sorpresa.

## Sintaxis básica

```ruby
puts "Hola, mundo"

nombre = "Ana"
edad = 30
altura = 1.75
activo = true

# Símbolos (inmutables)
estado = :activo

mensaje = "Hola, #{nombre}, tienes #{edad} años"

if edad >= 18
  puts "Mayor"
elsif edad > 12
  puts "Adolescente"
else
  puts "Menor"
end

(0...5).each { |i| puts i }
[1, 2, 3].each { |x| puts x }

case edad
when 0..12 then puts "Niño"
when 13..17 then puts "Adolescente"
else puts "Adulto"
end

def sumar(a, b) = a + b
def crear_usuario(nombre:, edad:, pais: "MX")
  { nombre: nombre, edad: edad, pais: pais }
end
```

## Tipado

Dinámico y fuerte. Duck typing: responde a métodos, no a clases. Todo es objeto. Nil es objeto.

```ruby
# Duck typing
def hacer_sonido(animal)
  animal.sonido
end

class Perro; def sonido; "Guau"; end; end
class Gato; def sonido; "Miau"; end; end

# Safe navigation (2.3+)
usuario&.direccion&.calle

# Pattern matching (3.0+)
case {nombre: "Ana", edad: 30}
in {nombre:, edad:}
  puts "#{nombre} tiene #{edad} años"
end

# respond_to?
"texto".respond_to?(:length) # true
```

## POO / Metaprogramación

```ruby
class Vehiculo
  attr_reader :marca
  
  def initialize(marca)
    @marca = marca
  end

  def mover = "Vehículo se mueve"
end

class Coche < Vehiculo
  def mover = "#{@marca} acelera"
end

# Mixins
module Volable
  def volar = "#{nombre} vuela"
end

class Pato
  include Volable
  attr_reader :nombre
  def initialize(nombre) = @nombre = nombre
end

# Monkey patching
class String
  def invertir = reverse
end

# Metaprogramación
[:nombre, :edad].each do |campo|
  define_method(campo) { instance_variable_get("@#{campo}") }
end

# Funcional
nums = [1, 2, 3, 4]
dobrados = nums.map { |x| x * 2 }
pares = nums.select(&:even?)
suma = nums.reduce(0) { |a, x| a + x }

# Proc/Lambda
cuadrado = ->(x) { x * x }
```

## Concurrencia

```ruby
# Threads (I/O-bound, GIL liberado durante I/O)
threads = 5.times.map do |i|
  Thread.new do
    sleep(0.1)
    puts "Hilo #{i}"
  end
end
threads.each(&:join)

# Ractor (3.0+): paralelismo real sin GIL
ractor = Ractor.new { Ractor.yield "desde ractor" }
puts ractor.take

# Fibers (cooperativos)
fiber = Fiber.new do
  Fiber.yield "primero"; "segundo"
end
puts fiber.resume
puts fiber.resume
```

## Ecosistema

- **RubyGems** (~200k+ gems), **Bundler** (Gemfile.lock)
- **Web**: Ruby on Rails, Sinatra, Hanami
- **Testing**: RSpec, Minitest, Capybara, FactoryBot
- **ORM**: ActiveRecord, Sequel
- **Jobs**: Sidekiq (Redis), GoodJob (PG), DelayedJob
- **Linting**: RuboCop, Reek, Sorbet (type checker)
- **Consola**: IRB, Pry

## Herramientas

```bash
gem install rails && rails new mi-app --api
bundle add sinatra && bundle install
bundle exec rspec spec/
bundle exec rubocop -A
srb init && srb tc
bundle exec rake db:migrate
```

## Relaciones

- [Frameworks](../../002-Frameworks/README.md)
- [Web](../../026-Web/README.md)
- [Bases de Datos](../../003-Databases/README.md)
```