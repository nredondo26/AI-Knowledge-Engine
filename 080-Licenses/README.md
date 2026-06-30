# 080-Licenses: Licencias de Software

## Descripción del dominio

Las licencias de software son contratos legales que definen cómo se puede usar, modificar, distribuir y compartir un programa o componente. En el desarrollo moderno, elegir la licencia correcta es crucial para proyectos open-source, comerciales y colaborativos. Este módulo cubre las licencias más utilizadas, su compatibilidad, implicaciones legales y criterios de selección.

## Conceptos clave

- **Copyright**: Derecho de autor que protege el código fuente como obra intelectual
- **Copyleft**: Mecanismo legal que obliga a que las obras derivadas mantengan la misma licencia
- **Permissive**: Licencias que permiten usar el código en proyectos propietarios sin restricciones (MIT, Apache, BSD)
- **Strong Copyleft**: Requiere que cualquier obra derivada se distribuya bajo la misma licencia (GPL)
- **Weak Copyleft**: Permite enlazar el código en proyectos propietarios sin contagiar al resto (LGPL, MPL)
- **Compatibilidad**: Capacidad de combinar código con diferentes licencias en un mismo proyecto
- **Dual Licensing**: Distribución del mismo software bajo dos licencias distintas (ej: comercial + open-source)
- **CLA** (Contributor License Agreement): Acuerdo que firman los contribuyentes para ceder derechos
- **SPDX**: Formato estandarizado para identificar licencias en archivos de código
- **License Compliance**: Verificación de que todas las dependencias cumplen con la licencia del proyecto
- **Tainted Work**: Obra derivada que hereda restricciones de la licencia original

## Tecnologías principales

| Herramienta | Propósito |
|-------------|-----------|
| SPDX | Identificación estandarizada de licencias |
| FOSSA | Escaneo automatizado de licencias en dependencias |
| Black Duck | Auditoría legal de componentes open-source |
| Snyk | Seguridad y cumplimiento de licencias |
| LicenseFinder | Herramienta CLI para auditar licencias |
| GitHub License API | Detección automática de licencias en repositorios |
| REUSE | Framework de la FSFE para declarar licencias |
| OSADL | Checker de compatibilidad GPL |

## Hoja de ruta

**Nivel Principiante:**
1. Comprender la diferencia entre copyright, copyleft y dominio público
2. Leer y entender la licencia MIT completa
3. Identificar la licencia de proyectos populares en GitHub
4. Distinguir entre licencias permisivas y restrictivas

**Nivel Intermedio:**
1. Analizar compatibilidad entre GPL v2 y GPL v3
2. Entender las implicaciones de Apache 2.0 con patentes
3. Configurar LICENSE y LICENSE-DEPENDENCIES en proyectos
4. Usar SPDX identifiers en cabeceras de archivos

**Nivel Avanzado:**
1. Evaluar estrategias de dual licensing para proyectos comerciales
2. Implementar CLA automation con CLA Assistant
3. Realizar auditorías de licencias en proyectos con 100+ dependencias
4. Asesorar sobre cumplimiento legal en mergers y adquisiciones

## Relaciones con otros módulos

- `../079-APIs/` — Licencias de APIs y términos de servicio
- `../052-Standards/` — Estándares SPDX y REUSE
- `../053-Compliance/` — Compliance legal y auditorías
- `../093-CommonErrors/` — Errores comunes al elegir licencias
- `../046-BestPractices/` — Buenas prácticas en licenciamiento
- `../074-Tools/` — Herramientas de análisis de licencias

## Recursos recomendados

- [ChooseALicense.com](https://choosealicense.com) — Guía interactiva para elegir licencia
- [GNU Licenses](https://www.gnu.org/licenses/) — Documentación oficial de la FSF
- [SPDX License List](https://spdx.org/licenses/) — Lista completa de identificadores SPDX
- [TLDRLegal](https://tldrlegal.com) — Resúmenes simplificados de licencias
- [FSFE REUSE](https://reuse.software) — Framework para licenciar proyectos
- [Open Source Initiative](https://opensource.org/licenses) — Catálogo de licencias aprobadas
- Libro: "Understanding Open Source and Free Software Licensing" — Andrew M. St. Laurent
