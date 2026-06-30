# 084-Labs: Laboratorios Guiados

## Descripción del dominio

Los laboratorios guiados son entornos de práctica estructurados que combinan instrucciones paso a paso, código ejecutable y validación automática. A diferencia de los ejercicios sueltos, los labs simulan escenarios reales donde el aprendiz construye, configura o despliega una solución completa en un entorno controlado. Incluyen playgrounds interactivos, hands-on tutorials y entornos sandbox.

## Conceptos clave

- **Sandbox**: Entorno aislado y desechable para experimentar sin riesgos
- **Hands-on Tutorial**: Tutorial práctico donde se escribe código real desde cero
- **Step-by-Step Lab**: Secuencia de pasos numerados con validación en cada etapa
- **Interactive Playground**: Entorno web con editor y salida en tiempo real (tipo CodeSandbox)
- **Environment as Code**: Definición del entorno de laboratorio mediante Docker, Vagrant o Terraform
- **Auto-grading**: Validación automática de resultados mediante tests o checks predefinidos
- **Scenario-based Lab**: Laboratorio basado en un caso de uso real o simulación
- **Progressive Disclosure**: Revelación gradual de pistas y soluciones según avanza el alumno
- **Lab Guide**: Documento que describe objetivos, prerrequisitos y pasos del laboratorio
- **Clean-up**: Procedimiento de limpieza para destruir recursos creados durante el lab

## Tecnologías principales

| Herramienta | Propósito |
|-------------|-----------|
| Docker | Contenedores para entornos reproducibles de laboratorio |
| Vagrant | Máquinas virtuales para labs de infraestructura |
| Katacoda / Killercoda | Plataformas de laboratorios interactivos en el navegador |
| Jupyter Notebooks | Labs interactivos para ciencia de datos y ML |
| GitHub Codespaces | Entornos de desarrollo en la nube para labs |
| GitPod | Entornos de desarrollo efímeros basados en contenedores |
| Terraform | Provisionamiento de infraestructura para labs cloud |
| Ansible | Automatización de configuración en entornos de laboratorio |
| Play with Docker | Sandbox Docker en el navegador |
| Instruqt | Plataforma de laboratorios interactivos empresariales |

## Hoja de ruta

**Nivel Principiante:**
1. Seguir un lab guiado de Docker (crear primera imagen y contenedor)
2. Completar un notebook interactivo de Python con Jupyter
3. Usar Play with Kubernetes para desplegar primera app
4. Realizar lab de Git: branching, merge, rebase

**Nivel Intermedio:**
1. Diseñar un laboratorio con Docker y docker-compose
2. Crear un entorno reproducible con Vagrant + Ansible
3. Implementar un lab de CI/CD con GitHub Actions
4. Desplegar infraestructura temporal con Terraform

**Nivel Avanzado:**
1. Diseñar una batería de labs completa para un curso técnico
2. Implementar auto-grading con tests automatizados y feedback
3. Crear entornos multi-máquina con networking simulado
4. Integrar laboratorios con plataforma LMS via LTI o API

## Relaciones con otros módulos

- `../083-Exercises/` — Ejercicios más pequeños que pueden integrarse en labs
- `../085-Challenges/` — Desafíos que extienden o combinan múltiples labs
- `../086-Projects/` — Proyectos completos que integran varios labs
- `../006-Containers/` — Docker y contenedores para entornos de lab
- `../005-Cloud/` — Labs de infraestructura cloud
- `../050-LearningPaths/` — Rutas de aprendizaje que incluyen labs

## Recursos recomendados

- [Killercoda](https://killercoda.com) — Laboratorios interactivos gratuitos
- [Play with Docker](https://labs.play-with-docker.com) — Sandbox Docker online
- [Play with Kubernetes](https://labs.play-with-k8s.com) — Sandbox K8s online
- [Google Cloud Skills Boost](https://www.cloudskillsboost.google) — Labs cloud guiados
- [AWS Workshop Studio](https://workshops.aws) — Laboratorios oficiales de AWS
- [Azure Learning Paths](https://docs.microsoft.com/learn) — Labs interactivos de Microsoft
- Libro: "The Practice of Cloud System Administration" — Thomas A. Limoncelli
