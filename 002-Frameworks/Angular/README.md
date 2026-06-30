# Angular

## Descripción

Angular es un framework de desarrollo web mantenido por Google, escrito en TypeScript. A diferencia de React y Vue, Angular es un framework **completo y opinado** que incluye enrutamiento, manejo de formularios, inyección de dependencias, cliente HTTP, pipes, y más sin necesidad de librerías externas.

Angular utiliza una arquitectura basada en **módulos** (NgModule) o, desde v17+, **componentes standalone**. El framework se apoya en TypeScript, RxJS (programación reactiva con Observables), y un potente sistema de compilación con Ivy (compilador Angular).

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Componentes** | Bloques fundamentales de UI, decorados con `@Component`. |
| **Módulos (NgModule)** | Agrupan componentes, directivas, pipes y servicios relacionados. |
| **Servicios** | Clases con lógica de negocio, inyectables mediante DI. |
| **Inyección de dependencias** | Patrón por el cual Angular provee instancias de servicios a componentes. |
| **Data Binding** | `{{ interpolation }}`, `[property]`, `(event)`, `[(ngModel)]`. |
| **Directivas** | `*ngIf`, `*ngFor`, `ngClass`, `ngStyle`; manipulan el DOM. |
| **Pipes** | Transforman datos en el template (date, currency, async). |
| **RxJS / Observables** | Programación reactiva para manejo de eventos asíncronos y HTTP. |
| **Router** | Sistema de navegación con guards, resolvers, lazy loading. |
| **Reactive Forms** | Formularios complejos con validación reactiva basada en modelo. |
| **Standalone components** | Nueva forma de crear componentes sin NgModule (Angular 14+). |
| **Signals** | Sistema reactivo nuevo (Angular 16+) para estado granular. |

---

## Ejemplos de código

### Componente standalone

```typescript
import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-contador',
  standalone: true,
  imports: [CommonModule],
  template: `
    <p>Has hecho clic {{ cuenta() }} veces</p>
    <button (click)="incrementar()">+1</button>

    <hr />
    <h3>Lista de tareas</h3>
    <ul>
      <li *ngFor="let tarea of tareas()">{{ tarea }}</li>
    </ul>
  `,
})
export class ContadorComponent {
  cuenta = signal(0);
  tareas = signal(['Aprender Angular', 'Crear una app', 'Publicar']);

  incrementar() {
    this.cuenta.update((c) => c + 1);
  }
}
```

### Servicio con HttpClient

```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Usuario {
  id: number;
  name: string;
  email: string;
}

@Injectable({ providedIn: 'root' })
export class UsuariosService {
  private apiUrl = 'https://jsonplaceholder.typicode.com/users';

  constructor(private http: HttpClient) {}

  obtenerUsuarios(): Observable<Usuario[]> {
    return this.http.get<Usuario[]>(this.apiUrl);
  }

  obtenerUsuario(id: number): Observable<Usuario> {
    return this.http.get<Usuario>(`${this.apiUrl}/${id}`);
  }
}
```

### Reactive Forms

```typescript
import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-formulario',
  standalone: true,
  imports: [ReactiveFormsModule],
  template: `
    <form [formGroup]="formulario" (ngSubmit)="enviar()">
      <input formControlName="nombre" placeholder="Nombre" />
      <span *ngIf="formulario.get('nombre')?.invalid && formulario.get('nombre')?.touched">
        El nombre es requerido
      </span>

      <input formControlName="email" type="email" placeholder="Email" />
      <button type="submit" [disabled]="formulario.invalid">Enviar</button>
    </form>
  `,
})
export class FormularioComponent {
  formulario: FormGroup;

  constructor(private fb: FormBuilder) {
    this.formulario = this.fb.group({
      nombre: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
    });
  }

  enviar() {
    if (this.formulario.valid) {
      console.log(this.formulario.value);
    }
  }
}
```

### Router con guards

```typescript
import { Routes } from '@angular/router';
import { authGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', redirectTo: '/home', pathMatch: 'full' },
  { path: 'home', loadComponent: () => import('./home/home.component').then(m => m.HomeComponent) },
  {
    path: 'dashboard',
    canActivate: [authGuard],
    loadComponent: () => import('./dashboard/dashboard.component').then(m => m.DashboardComponent),
  },
  { path: '**', redirectTo: '/home' },
];
```

### Interceptor HTTP

```typescript
import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { AuthService } from './auth.service';

export const tokenInterceptor: HttpInterceptorFn = (req, next) => {
  const auth = inject(AuthService);
  const token = auth.getToken();

  if (token) {
    const clone = req.clone({
      setHeaders: { Authorization: `Bearer ${token}` },
    });
    return next(clone);
  }

  return next(req);
};
```

---

## Hoja de ruta

```
1. TypeScript sólido
   ├── Tipos, interfaces, genéricos
   ├── Decoradores y clases
   └── Módulos

2. Fundamentos de Angular
   ├── Arquitectura: componentes, servicios, módulos
   ├── Data binding e interpolación
   ├── Directivas estructurales (*ngIf, *ngFor)
   └── Pipes incorporados

3. Inyección de dependencias y servicios
   ├── @Injectable y providedIn
   ├── Patrón servicio + componente
   └── Jerarquía de inyectores

4. Programación reactiva con RxJS
   ├── Observables, Subjects, BehaviorSubject
   ├── Operadores (map, filter, switchMap, debounceTime)
   └── Async pipe en templates

5. HTTP Client y comunicación con APIs
   ├── HttpClient, Interceptors
   ├── Manejo de errores con catchError
   └── Caching con ShareReplay

6. Formularios
   ├── Template-driven forms
   ├── Reactive Forms con validación
   └── FormArray, FormGroup anidados

7. Routing avanzado
   ├── Guards (CanActivate, CanDeactivate, Resolve)
   ├── Lazy loading de módulos/componentes
   └── Navegación programática

8. Rendimiento y optimización
   ├── OnPush Change Detection
   ├── Signals (Angular 16+)
   ├── Deferrable views (@defer)
   └── Code splitting

9. Testing
   ├── Jasmine + Karma / Jest
   ├── TestBed y ComponentFixture
   └── Pruebas de servicios con HttpClientTesting

10. Producción y ecosistema
    ├── Angular CLI (ng generate, ng build, ng serve)
    ├── SSR con Angular Universal
    ├── Estado con NgRx / Signal Store
    └── Monorepos con Nx
```
