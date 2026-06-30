# React

## Descripción

React es una biblioteca de JavaScript declarativa, eficiente y flexible para construir interfaces de usuario. Fue desarrollada por Meta (Facebook) y lanzada en 2013. React permite construir componentes reutilizables que gestionan su propio estado y se componen para formar UIs complejas. Su modelo basado en un **Virtual DOM** optimiza las renderizaciones al minimizar las manipulaciones directas del DOM real.

React no es un framework completo (es solo la capa de vista), pero combinado con librerías como React Router, Redux/Zustand y Next.js permite construir aplicaciones web modernas, móviles (React Native) y de escritorio.

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Componentes** | Bloques reutilizables de UI; pueden ser funciones o clases. |
| **JSX** | Extensión de sintaxis que mezcla HTML con JavaScript. |
| **Estado (state)** | Datos internos del componente que, al cambiar, disparan un re-render. |
| **Props** | Parámetros de entrada de un componente, inmutables. |
| **Ciclo de vida / Hooks** | Mecanismos para ejecutar efectos secundarios (`useEffect`) o gestionar estado (`useState`). |
| **Virtual DOM** | Representación ligera del DOM real; React calcula diferencias (diffing) y aplica solo los cambios necesarios. |
| **Reconcilación** | Algoritmo que compara el Virtual DOM anterior con el nuevo para determinar qué actualizar. |
| **Hooks** | Funciones que permiten usar estado y otras características de React sin clases. |
| **Context API** | Mecanismo para compartir datos entre componentes sin prop drilling. |
| **Renderizado condicional** | Técnica para renderizar distintos elementos según el estado. |

---

## Ejemplos de código

### Componente funcional con hooks

```jsx
import { useState, useEffect } from 'react';

function Contador() {
  const [cuenta, setCuenta] = useState(0);

  useEffect(() => {
    document.title = `Has hecho clic ${cuenta} veces`;
  }, [cuenta]);

  return (
    <div>
      <p>Has hecho clic {cuenta} veces</p>
      <button onClick={() => setCuenta(cuenta + 1)}>Incrementar</button>
    </div>
  );
}

export default Contador;
```

### Renderizado de listas

```jsx
function ListaUsuarios({ usuarios }) {
  return (
    <ul>
      {usuarios.map((usuario) => (
        <li key={usuario.id}>
          {usuario.nombre} - {usuario.email}
        </li>
      ))}
    </ul>
  );
}
```

### Manejo de formularios

```jsx
import { useState } from 'react';

function Formulario() {
  const [datos, setDatos] = useState({ nombre: '', email: '' });

  const handleChange = (e) => {
    setDatos({ ...datos, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Enviado:', datos);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input name="nombre" value={datos.nombre} onChange={handleChange} />
      <input name="email" value={datos.email} onChange={handleChange} />
      <button type="submit">Enviar</button>
    </form>
  );
}
```

### Llamada a API con useEffect

```jsx
import { useState, useEffect } from 'react';

function Usuarios() {
  const [usuarios, setUsuarios] = useState([]);
  const [cargando, setCargando] = useState(true);

  useEffect(() => {
    fetch('https://jsonplaceholder.typicode.com/users')
      .then((res) => res.json())
      .then((data) => {
        setUsuarios(data);
        setCargando(false);
      });
  }, []);

  if (cargando) return <p>Cargando...</p>;

  return (
    <ul>
      {usuarios.map((u) => <li key={u.id}>{u.name}</li>)}
    </ul>
  );
}
```

### Context API para estado global

```jsx
import { createContext, useContext, useState } from 'react';

const TemaContext = createContext();

function ProveedorTema({ children }) {
  const [tema, setTema] = useState('claro');
  return (
    <TemaContext.Provider value={{ tema, setTema }}>
      {children}
    </TemaContext.Provider>
  );
}

function BotonTema() {
  const { tema, setTema } = useContext(TemaContext);
  return (
    <button onClick={() => setTema(tema === 'claro' ? 'oscuro' : 'claro')}>
      Cambiar a modo {tema === 'claro' ? 'oscuro' : 'claro'}
    </button>
  );
}
```

---

## Hoja de ruta

```
1. Fundamentos de JavaScript moderno (ES6+)
   ├── Arrow functions, destructuring, spread operator
   ├── Promesas, async/await, fetch
   └── Módulos (import/export)

2. Introducción a React
   ├── JSX y renderizado de elementos
   ├── Componentes funcionales y de clase
   ├── Props y composición
   └── Estado con useState

3. Hooks esenciales
   ├── useEffect (efectos secundarios)
   ├── useRef (referencias al DOM)
   ├── useCallback y useMemo (optimización)
   └── Custom Hooks

4. Manejo de estado y ciclo de vida
   ├── useState vs useReducer
   ├── Context API + useContext
   └── Bibliotecas de estado: Zustand, Redux Toolkit

5. Enrutamiento
   └── React Router DOM (v6+)

6. Comunicación con APIs
   ├── useEffect + fetch / axios
   ├── React Query / TanStack Query
   └── SWR

7. Estilizado
   ├── CSS Modules
   ├── Styled Components / Emotion
   └── Tailwind CSS

8. Testing
   ├── Vitest / Jest + React Testing Library
   └── Pruebas de integración y E2E (Playwright)

9. Patrones avanzados
   ├── Render Props, HOC, Compound Components
   ├── Portales y Suspense
   └── Server Components (React 18+)

10. Frameworks basados en React
    ├── Next.js (SSR, SSG, RSC)
    └── Remix / Gatsby
```
