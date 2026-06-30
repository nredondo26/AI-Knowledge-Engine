# Spring Framework

## Descripción

Spring es el framework de aplicaciones empresariales más popular del ecosistema Java. Nació en 2002 como alternativa más ligera a Java EE (hoy Jakarta EE). Spring Boot (su extensión más usada) elimina la configuración boilerplate mediante auto-configuración, servidor embebido (Tomcat, Jetty) y dependencias starter.

Spring proporciona un modelo de programación integral: inyección de dependencias (IoC), programación orientada a aspectos (AOP), acceso a datos (Spring Data), seguridad (Spring Security), microservicios (Spring Cloud), y más. Es la elección estándar para sistemas bancarios, fintech, e-commerce y grandes corporaciones.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Inversión de Control (IoC)** | El contenedor Spring gestiona el ciclo de vida de los objetos. |
| **Inyección de Dependencias (DI)** | Spring inyecta automáticamente las dependencias requeridas. |
| **Spring Boot** | Extensión que auto-configura la aplicación basándose en dependencias del classpath. |
| **Auto-configuración** | Spring Boot configura beans por defecto según los starters detectados. |
| **Starter POMs** | Dependencias pre-configuradas (`spring-boot-starter-web`, `-data-jpa`, etc.). |
| **Beans** | Objetos gestionados por el contenedor Spring (singleton por defecto). |
| **ApplicationContext** | Interfaz principal del contenedor IoC. |
| **AOP (Aspect-Oriented Programming)** | Permite separar concerns transversales (logging, transacciones). |
| **Spring Data JPA** | Capa de acceso a datos que implementa repositorios automáticamente. |
| **Spring Security** | Framework de autenticación y autorización completo. |
| **Spring Cloud** | Suite para construir microservicios (descubrimiento, config, gateway). |

---

## Ejemplos de código

### Controlador REST con Spring Boot

```java
@RestController
@RequestMapping("/api/productos")
@RequiredArgsConstructor
public class ProductoController {

    private final ProductoService service;

    @GetMapping
    public ResponseEntity<List<ProductoDTO>> listar() {
        return ResponseEntity.ok(service.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductoDTO> obtener(@PathVariable Long id) {
        return ResponseEntity.ok(service.obtenerPorId(id));
    }

    @PostMapping
    public ResponseEntity<ProductoDTO> crear(@Valid @RequestBody ProductoDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.crear(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductoDTO> actualizar(@PathVariable Long id, @Valid @RequestBody ProductoDTO dto) {
        return ResponseEntity.ok(service.actualizar(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}
```

### Entidad JPA y repositorio

```java
@Entity
@Table(name = "productos")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Producto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String nombre;

    @Column(nullable = false)
    private BigDecimal precio;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id")
    private Categoria categoria;

    @Column(nullable = false)
    private Integer stock = 0;
}
```

```java
@Repository
public interface ProductoRepository extends JpaRepository<Producto, Long> {

    List<Producto> findByCategoriaId(Long categoriaId);

    @Query("SELECT p FROM Producto p WHERE p.precio BETWEEN :min AND :max")
    List<Producto> buscarPorRangoPrecio(@Param("min") BigDecimal min, @Param("max") BigDecimal max);

    boolean existsByNombre(String nombre);
}
```

### Servicio con transacciones

```java
@Service
@Transactional
@RequiredArgsConstructor
public class ProductoService {

    private final ProductoRepository repository;

    @Transactional(readOnly = true)
    public List<ProductoDTO> listarTodos() {
        return repository.findAll().stream()
            .map(ProductoDTO::fromEntity)
            .toList();
    }

    @Transactional(readOnly = true)
    public ProductoDTO obtenerPorId(Long id) {
        return repository.findById(id)
            .map(ProductoDTO::fromEntity)
            .orElseThrow(() -> new ResourceNotFoundException("Producto no encontrado: " + id));
    }

    public ProductoDTO crear(ProductoDTO dto) {
        if (repository.existsByNombre(dto.nombre())) {
            throw new IllegalArgumentException("El producto ya existe");
        }
        var producto = dto.toEntity();
        return ProductoDTO.fromEntity(repository.save(producto));
    }

    public ProductoDTO actualizar(Long id, ProductoDTO dto) {
        var producto = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Producto no encontrado"));
        producto.setNombre(dto.nombre());
        producto.setPrecio(dto.precio());
        producto.setStock(dto.stock());
        return ProductoDTO.fromEntity(repository.save(producto));
    }

    public void eliminar(Long id) {
        if (!repository.existsById(id)) {
            throw new ResourceNotFoundException("Producto no encontrado");
        }
        repository.deleteById(id);
    }
}
```

### DTO y validación

```java
public record ProductoDTO(
    Long id,
    @NotBlank(message = "El nombre es obligatorio")
    @Size(max = 200)
    String nombre,
    @NotNull @DecimalMin("0.01") BigDecimal precio,
    Long categoriaId,
    @Min(0) Integer stock
) {
    public static ProductoDTO fromEntity(Producto p) {
        return new ProductoDTO(
            p.getId(), p.getNombre(), p.getPrecio(),
            p.getCategoria().getId(), p.getStock()
        );
    }

    public Producto toEntity() {
        var p = new Producto();
        p.setNombre(this.nombre);
        p.setPrecio(this.precio);
        p.setStock(this.stock != null ? this.stock : 0);
        return p;
    }
}
```

### Configuración de seguridad (Spring Security + JWT)

```java
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthFilter jwtFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .csrf(csrf -> csrf.disable())
            .sessionManagement(sm -> sm.sessionCreationPolicy(STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**", "/swagger-ui/**", "/v3/api-docs/**").permitAll()
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
            .build();
    }
}
```

---

## Hoja de ruta

```
1. Java moderno (8+)
   ├── Streams, Optional, Lambdas
   ├── Records, Pattern Matching
   └── Maven / Gradle básico

2. Fundamentos Spring Core
   ├── Inversión de Control e Inyección de Dependencias
   ├── ApplicationContext y configuración (XML, Java Config)
   └── Scopes (singleton, prototype, request, session)

3. Spring Boot
   ├── Starters y auto-configuración
   ├── application.yml / application.properties
   ├── Spring Boot DevTools
   ├── perfiles (dev, prod, test)
   └── Actuator (health, metrics, info)

4. Desarrollo Web con Spring MVC
   ├── @RestController, @RequestMapping
   ├── Manejo de excepciones (@ControllerAdvice)
   ├── Validación con Jakarta Validation
   └── Content negotiation (JSON, XML)

5. Acceso a datos
   ├── Spring Data JPA (JpaRepository, Query Methods, @Query)
   ├── Transacciones (@Transactional)
   ├── Migraciones con Flyway / Liquibase
   └── Conexiones con HikariCP

6. Seguridad con Spring Security
   ├── AuthenticationManager, UserDetailsService
   ├── JWT (jjwt, auth0)
   ├── OAuth2 / OpenID Connect
   ├── Method security (@PreAuthorize)
   └── CORS, CSRF

7. Pruebas
   ├── SpringBootTest, @WebMvcTest, @DataJpaTest
   ├── Mockito, AssertJ
   ├── Testcontainers para BD reales
   └── RestAssured / WebTestClient para E2E

8. Microservicios (Spring Cloud)
   ├── Service discovery (Eureka / Consul)
   ├── API Gateway (Spring Cloud Gateway)
   ├── Config Server (centralizado)
   ├── Resilience4j (circuit breaker, retry)
   └── Tracing con Micrometer + Zipkin

9. Producción
   ├── Docker y Kubernetes
   ├── Monitorización con Prometheus + Grafana
   ├── Logging (Logback, SLF4J, ELK)
   └── CI/CD (GitHub Actions, Jenkins)
```
