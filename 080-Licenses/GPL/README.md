# GNU General Public License (GPL) — Copyleft

## Visión General

La Licencia Pública General de GNU (GPL) es una licencia copyleft que garantiza a los usuarios la libertad de usar, compartir y modificar software, pero exige que las obras derivadas se distribuyan bajo los mismos términos. Creada por Richard Stallman y la Free Software Foundation (FSF).

## Versiones

| Versión | Año | Cambios principales |
|---------|-----|---------------------|
| GPLv1 | 1989 | Primera versión, copyleft básico |
| GPLv2 | 1991 | Cláusula "Liberty or Death" (Sección 7) |
| GPLv3 | 2007 | Compatibilidad Apache, patentes, tivoization, DRM |

## Principios Fundamentales

```
Las 4 libertades del software libre (FSF):
  0: Ejecutar el programa para cualquier propósito
  1: Estudiar cómo funciona el programa y adaptarlo
  2: Redistribuir copias para ayudar al prójimo
  3: Mejorar el programa y publicar las mejoras
```

## Cómo Funciona el Copyleft

```
Código original (GPL)
  └── Modificación / Derivado (DEBE ser GPL)
       └── Si distribuyes, debes:
            ├── Incluir código fuente completo
            ├── Mantener copyright y licencia
            └── Incluir aviso de cambios

Excepción: Uso interno sin distribución → No obliga a publicar
```

## Texto Completo (GPLv3)

El texto completo de GPLv3 contiene ~5,000 palabras. Los elementos clave son:

```
Secciones principales:
  1. Definiciones
  2. Permisos básicos
  3. Protección de derechos legales (patentes)
  4. Distribución de copias literales
  5. Distribución de versiones modificadas
  6. Código fuente (obligación de proveerlo)
  7. Términos adicionales
  8. Terminación de la licencia
  9. Aceptación no requerida
  10. Interacción con otras licencias
  11. Patentes
  12. No surrender others' freedom
  13. AGPL compatibility
  14. Versiones revisadas
```

## Cómo Aplicar GPL

```bash
# 1. Incluir archivo COPYING o LICENSE en la raíz
# 2. Incluir aviso en cada archivo fuente
```

### Cabecera estándar GPLv3

```python
# Copyright (C) 2024  Nombre del Autor
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
```

### En cabecera C

```c
/* Copyright (C) 2024  Nombre del Autor
 *
 * This file is part of Proyecto X.
 *
 * Proyecto X is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Proyecto X is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Proyecto X.  If not, see <https://www.gnu.org/licenses/>.
 */
```

### SPDX Identifier

```python
# SPDX-License-Identifier: GPL-3.0-or-later
```

## GPLv2 vs GPLv3

| Aspecto | GPLv2 | GPLv3 |
|---------|-------|-------|
| Tivoization | Permitido | Prohibido |
| DRM | No mencionado | Prohibido si afecta usuarios |
| Patentes | Grant implícito confuso | Grant explícito y claro |
| Apache 2.0 | Incompatible | Compatible |
| Termination | Discrecional | Automática con reinstatement |
| AGPL | No existe | Compatible |

## GPL y Licencias Relacionadas

| Licencia | Relación con GPL |
|----------|------------------|
| **LGPL** | Versión débil: permite enlazar con código no GPL |
| **AGPL** | Copyleft también sobre uso en red (SaaS) |
| **GPL + Classpath Exception** | Permite enlazar librerías sin contaminar |
| **GPL + OpenSSL Exception** | Permite usar OpenSSL (incompatible con GPL pura) |

## Compatibilidad

```
GPLv3 ── compatible con:
  ├── Apache 2.0    (sí)
  ├── LGPLv3        (sí)
  ├── AGPLv3        (sí)
  ├── GPLv2         (solo si código es "GPLv2 or later")
  └── MIT / BSD     (sí, son permisivas)

GPLv3 ── incompatible con:
  └── GPLv2 sola    (sin "or later")
  └── MPL 1.1       (MPL 2.0 sí, con compatibilidad parcial)
```

## Proyectos Conocidos Bajo GPL

```yaml
GPLv2:
  - Linux Kernel
  - Git
  - WordPress
  - MySQL (antes, ahora dual)
  - GIMP
  - VLC media player

GPLv3:
  - Bash (desde 4.0)
  - GCC
  - Emacs
  - GnuPG
  - LibreOffice
  - Octave
  - Raspberry Pi OS (kernel, herramientas)

LGPL:
  - glibc
  - GTK
  - Qt (antes GPL, ahora LGPL)
  - FFmpeg

AGPL:
  - MongoDB (antes AGPL, ahora SSPL)
  - Nextcloud
  - Mastodon
```

## Preguntas Frecuentes

### ¿Si uso una librería GPL en mi proyecto, mi proyecto debe ser GPL?

Depende:
- **Dinámica** (shared library) → Generalmente no contamina si es LGPL
- **Estática** o modificación del código → Sí, debe ser GPL
- **Uso como herramienta externa** (CLI) → No, es agregación

### ¿Puedo vender software GPL?

Sí. GPL permite cobrar por distribuir el software, pero debes proporcionar el código fuente.

### ¿Puedo usar GPL en un producto SaaS?

Sí, pero GPL no exige publicar cambios si no distribuyes el software. AGPL cierra este loophole.

### ¿Qué significa "or any later version"?

El usuario puede elegir la versión de GPL que aplica. Sin esta cláusula, solo aplica la versión específica.

### ¿Puedo relicenciar código GPL?

No sin permiso de todos los autores del copyright (cada contribuyente).

## Cumplimiento (Compliance)

```yaml
Pasos para cumplir con GPL:
  1. Acompañar el binario con código fuente completo
  2. Incluir texto completo de GPL
  3. Incluir avisos de copyright de todos los autores
  4. Documentar cómo obtener la fuente (si se distribuye en físico)
  5. No imponer restricciones adicionales
```

### Violaciones Comunes

- Distribuir binarios sin código fuente
- No incluir texto de licencia
- Impedir la instalación de versiones modificadas (tivoization)
- CLA que anula los derechos GPL
- No identificar autores/contribuyentes

## Referencias

- [GNU GPLv3 Text (FSF)](https://www.gnu.org/licenses/gpl-3.0.html)
- [GNU GPLv2 Text](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
- [GPL FAQ (FSF)](https://www.gnu.org/licenses/gpl-faq.html)
- [Choose a License — GPL](https://choosealicense.com/licenses/gpl-3.0/)
- [SPDX — GPL-3.0-only](https://spdx.org/licenses/GPL-3.0-only.html)
- [Copyleft.org](https://copyleft.org/)
