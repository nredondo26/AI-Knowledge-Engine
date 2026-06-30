# NestJS

## Descripción

NestJS es un framework progresivo para Node.js, creado por Kamil Mysliwiec en 2017. Usa TypeScript por defecto y combina POO, programación funcional y reactiva. Se inspira en Angular (módulos, decoradores, inyección de dependencias) y es compatible con Express y Fastify como HTTP engines. Ideal para aplicaciones empresariales, microservicios y APIs GraphQL.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Módulos** | `@Module()` organiza la aplicación en contextos cohesivos. |
| **Controladores** | `@Controller()` maneja rutas HTTP con decoradores. |
| **Providers** | Lógica de negocio inyectable mediante DI. |
| **Pipes** | Transformación y validación (ValidationPipe). |
| **Guards** | Control de acceso basado en roles. |
| **Interceptors** | AOP para transformar resultados, logging, caching. |
| **Decoradores** | `@Get()`, `@Post()`, `@Param()`, `@Body()`, `@Injectable()`. |

---

## Ejemplos de código

### Módulo, controlador y servicio

```typescript
// app.module.ts
@Module({
  controllers: [UsuariosController],
  providers: [UsuariosService],
})
export class AppModule {}

// usuarios.controller.ts
@Controller('usuarios')
export class UsuariosController {
  constructor(private readonly service: UsuariosService) {}

  @Get()
  findAll() { return this.service.findAll(); }

  @Get(':id')
  findOne(@Param('id') id: string) { return this.service.findOne(+id); }

  @Post()
  create(@Body() data: CreateUsuarioDto) { return this.service.create(data); }
}

// usuarios.service.ts
@Injectable()
export class UsuariosService {
  private usuarios = [{ id: 1, nombre: 'Ana', email: 'ana@email.com' }];
  private nextId = 2;

  findAll() { return this.usuarios; }

  findOne(id: number) {
    const u = this.usuarios.find((u) => u.id === id);
    if (!u) throw new NotFoundException();
    return u;
  }

  create(data: CreateUsuarioDto) {
    const u = { id: this.nextId++, ...data };
    this.usuarios.push(u);
    return u;
  }
}
```

### DTO y validación

```typescript
// create-usuario.dto.ts
import { IsString, IsEmail, MinLength } from 'class-validator';

export class CreateUsuarioDto {
  @IsString() @MinLength(3)
  nombre: string;

  @IsEmail()
  email: string;
}

// main.ts
app.useGlobalPipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true }));
```

### Guard y módulo TypeORM

```typescript
// auth.guard.ts
@Injectable()
export class AuthGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const req = context.switchToHttp().getRequest();
    return req.headers.authorization === 'Bearer token-valido';
  }
}

// usuarios.module.ts
@Module({
  imports: [TypeOrmModule.forFeature([Usuario])],
  controllers: [UsuariosController],
  providers: [UsuariosService],
})
export class UsuariosModule {}
```

---

## Hoja de ruta

```
1. TypeScript avanzado (decoradores, genéricos)
2. Módulos, controladores, providers, DI
3. Pipes (ValidationPipe, personalizados)
4. Guards, interceptors, exception filters
5. BD (TypeORM/Prisma, migraciones, relaciones)
6. Autenticación (Passport + JWT, roles)
7. GraphQL (code-first, schema-first, DataLoader)
8. Microservicios (TCP, Redis, RabbitMQ, Kafka)
9. Testing (Jest, supertest, TestModule)
10. Producción (Swagger, logging, Docker, CI/CD)
```
