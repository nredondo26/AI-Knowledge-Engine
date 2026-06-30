# Licencia MIT — Permisiva de Código Abierto

## Visión General

La Licencia MIT es una licencia de software libre permisiva. Originaria del Massachusetts Institute of Technology, permite reuse, modificación, distribución y uso comercial con mínimas restricciones. Es la licencia open source más popular.

## Texto Completo

```
MIT License

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Permisos vs Restricciones

| Permiso | Restricción |
|---------|-------------|
| Uso comercial | Incluir copyright (obligatorio) |
| Modificación | Incluir licencia (obligatorio) |
| Distribución | |
| Sublicencia | |
| Uso privado | |
| Responsabilidad limitada | |
| Sin garantía | |

## Cómo Aplicar MIT a un Proyecto

```bash
# 1. Crear archivo LICENSE en la raíz del proyecto
# 2. Copiar el texto de MIT License
# 3. Reemplazar <year> y <copyright holders>

# Con herramienta (node.js)
npx license mit

# Con GitHub CLI
gh repo create --license mit
```

### En package.json

```json
{
  "name": "mi-paquete",
  "version": "1.0.0",
  "license": "MIT",
  "author": "Nombre del Autor",
  "repository": {
    "type": "git",
    "url": "https://github.com/usuario/mi-paquete.git"
  }
}
```

### En cabecera de archivos

```python
# Copyright (c) 2024 Nombre del Autor
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
```

## Comparación con Otras Licencias Permisivas

| Aspecto | MIT | Apache 2.0 | BSD 2-Clause | BSD 3-Clause | Unlicense |
|---------|-----|------------|--------------|--------------|-----------|
| Atribución requerida | Sí | Sí | Sí | Sí | No |
| Cláusula de no-endoso | No | No | No | Sí | No |
| Patentes (grant implícito) | No | Sí | No | No | No |
| Jurisdicción | No | No | No | No | No |
| Longitud del texto | ~200 palabras | ~3,000 palabras | ~200 palabras | ~250 palabras | ~100 palabras |
| Popularidad (GitHub) | ~55% | ~15% | ~5% | ~5% | ~2% |

## Compatibilidad con Otras Licencias

```
MIT ── compatible con:
  ├── GPLv2        (sí, MIT es GPL-compatible)
  ├── GPLv3        (sí, permisiva)
  ├── Apache 2.0   (sí)
  ├── BSD          (sí)
  └── MPL          (sí)

MIT ── no compatible con:
  └── (ninguna, es la más permisiva)
```

## Uso en Proyectos Conocidos

```yaml
Proyectos bajo MIT (selección):
  - Node.js
  - React
  - jQuery
  - Lodash
  - Bootstrap
  - Angular
  - Vue.js
  - Express.js
  - TypeScript (compilador)
  - .NET Core
  - Rails
  - Chef
  - Homebrew
```

## Preguntas Frecuentes

### ¿Puedo usar código MIT en un producto comercial?

Sí, sin restricciones. Solo debes incluir el aviso de copyright.

### ¿Tengo que incluir la licencia si solo uso el software internamente?

Técnicamente si redistribuyes (ej. dentro de una organización). Si solo lo ejecutas, no.

### ¿Qué pasa si no incluyo el copyright?

Estarías violando los términos de la licencia, perdiendo el derecho a usarlo.

### ¿Puedo cambiar la licencia de un fork MIT?

Sí, MIT permite relicenciar. Pero el código original del upstream sigue siendo MIT.

### ¿MIT protege contra demandas de patentes?

No explícitamente. Apache 2.0 incluye grant de patentes; MIT no. Sin embargo, quien distribuye código MIT infringiendo patentes sigue siendo responsable.

## SPDX Identifier

```
SPDX-License-Identifier: MIT
```

Utilizar el identificador SPDX en lugar del texto completo cuando sea posible (recomendado por Linux Foundation).

## Referencias

- [Open Source Initiative — MIT License](https://opensource.org/license/mit/)
- [SPDX License List — MIT](https://spdx.org/licenses/MIT.html)
- [Choose an Open Source License](https://choosealicense.com/licenses/mit/)
- [tl;dr Legal — MIT](https://www.tldrlegal.com/license/mit-license)
- [GitHub License API](https://docs.github.com/en/rest/licenses)
