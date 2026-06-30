# Licencia Apache 2.0 — Permisiva con Patentes

## Visión General

La Licencia Apache 2.0, publicada por la Apache Software Foundation en 2004, es una licencia de software libre permisiva que permite usar, modificar y distribuir el software con fines comerciales. Incluye una concesión explícita de derechos de patente.

## Características Principales

| Aspecto | Descripción |
|---------|-------------|
| Tipo | Permisiva (no copyleft) |
| Atribución requerida | Sí |
| Grant de patentes | Sí, explícito |
| Terminación por litigio de patentes | Sí |
| Compatible con GPLv3 | Sí |
| Aplicación a documentación | Sí |
| Protección de marcas registradas | Sí |
| Fecha de publicación | Enero 2004 |

## Texto Completo

```
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

1. Definitions.
   "License" shall mean the terms and conditions for use, reproduction,
   and distribution as defined by Sections 1 through 9 of this document.

   [ ... texto completo ~3,000 palabras ... ]

8. Limitation of Liability.
   In no event and under no legal theory, whether in tort (including
   negligence), contract, or otherwise, unless required by applicable
   law (such as deliberate and grossly negligent acts) or agreed to in
   writing, shall any Contributor be liable to You for damages ...

9. Accepting Warranty or Additional Liability.
   While redistributing the Work or Derivative Works thereof, You may
   choose to offer, and charge a fee for, acceptance of support,
   warranty, indemnity, or other liability obligations and/or rights ...

END OF TERMS AND CONDITIONS

APPENDIX: How to apply the Apache License to your work.
```

## Cómo Aplicar Apache 2.0

```bash
# 1. Incluir archivo LICENSE en la raíz del proyecto
# 2. Incluir aviso en cada archivo fuente

# Con herramienta
npx license apache-2.0
```

### Cabecera en Archivos

```
Copyright 2024 Nombre del Autor

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

### SPDX Identifier

```python
# SPDX-License-Identifier: Apache-2.0
```

## Cláusula de Patentes (Sección 3)

La concesión de patentes es la característica distintiva de Apache 2.0:

```
Each Contributor grants You a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable (except as stated in this section)
patent license to make, have made, use, offer to sell, sell, import,
and otherwise transfer the Work ...
```

**Terminación automática**: Si inicias un litigio de patentes contra alguien alegando que el Trabajo (o una contribución) infringe una patente, tu licencia sobre el Trabajo termina inmediatamente.

## NOTICE File

Apache 2.0 requiere que las obras derivadas incluyan un archivo `NOTICE` con atribuciones:

```
# NOTICE.txt
Copyright 2024 Nombre del Autor

This software includes works under the Apache License 2.0:
  - Proyecto A (Copyright 2020 Autor A)
  - Proyecto B (Copyright 2021 Autor B)

This product includes software developed by
The Apache Software Foundation (http://www.apache.org/).
```

## Comparativa Apache 2.0 vs MIT vs GPLv3

| Aspecto | Apache 2.0 | MIT | GPLv3 |
|---------|------------|-----|-------|
| Atribución | Sí (NOTICE) | Sí (copyright) | Sí |
| Grant patentes | Explícito | No | Explícito |
| Copyleft | No | No | Sí (fuerte) |
| DRM/Tivoization | No prohibe | No prohibe | Prohibe |
| Terminación por patentes | Sí (retaliativo) | No | Sí |
| Compatibilidad GPLv3 | Compatible | Compatible | Propia |
| Aviso en docs | Sí | Sí | Sí |
| Longitud | ~3,000 palabras | ~200 palabras | ~5,000 palabras |

## Proyectos Importantes Bajo Apache 2.0

```yaml
Fundación Apache:
  - Apache HTTP Server
  - Apache Hadoop
  - Apache Spark
  - Apache Kafka
  - Apache Cassandra
  - Apache Flink
  - Apache Airflow
  - Apache Maven
  - Apache Tomcat
  - Apache Jenkins (antes)

Otros proyectos:
  - Android (partes)
  - Kubernetes
  - TensorFlow
  - Swift (lenguaje)
  - React Native
  - Flutter (Dart SDK)
  - Ethereum
  - Spring Framework
  - Ruby on Rails (cambio de MIT)
  - Go (lenguaje, licencias BSD-style)
```

## NOTICE en Proyectos Derivados

Cuando distribuyes un trabajo derivado bajo Apache 2.0, debes:

1. Incluir el archivo LICENSE original
2. Incluir o adjuntar NOTICE con atribuciones
3. Mantener SPDX identifiers
4. No usar marcas registradas del proyecto original para promocionar derivados

```bash
# Ejemplo de estructura de distribución
mi-software/
├── LICENSE
├── NOTICE.txt
├── src/
│   └── mi_codigo.py
└── vendor/
    └── libreria-apache/
        ├── LICENSE
        └── NOTICE (si existe en el original)
```

## Compatibilidad

```
Apache 2.0 ── compatible con:
  ├── GPLv3             (sí, compatible con copyleft)
  ├── MIT               (sí)
  ├── BSD               (sí)
  ├── LGPLv3            (sí)
  ├── MPL 2.0           (sí)
  └── Unlicense         (sí)

Apache 2.0 ── incompatible con:
  └── GPLv2             (incompatible! GPLv2 no acepta términos adicionales)
```

Nota: La incompatibilidad con GPLv2 es unilateral — Apache 2.0 → GPLv2 no puede relicenciarse, pero GPLv2 → Apache 2.0 tampoco.

## Apache License Versiones

| Versión | Año | Cambios |
|---------|-----|---------|
| 1.0 | 1995 | Original, sin patentes |
| 1.1 | 2000 | Advertising clause modificada |
| 2.0 | 2004 | Reestructuración completa, patentes explícitas |

## Cláusula de Marcas (Section 6)

```
Nothing in this License grants any right to use the trade names,
trademarks, service marks, or product names of the Licensor ...
```

Esto significa que no puedes llamar "Apache Foo" a tu producto derivado sin permiso de la ASF.

## Cómo Distribuir Binarios

```yaml
Requisitos para distribución de binarios:
  - Incluir copia de la licencia
  - Atribuciones en NOTICE o documentación
  - Si el código fuente no se incluye, ofrecerlo por escrito

Si el software es para uso interno (no se distribuye):
  - No hay obligación de publicar modificaciones
```

## Preguntas Frecuentes

### ¿Puedo usar código Apache 2.0 en un proyecto GPLv2?

No directamente. Pero puedes usar código Apache 2.0 en un proyecto GPLv3 ya que son compatibles.

### ¿Puedo relicenciar código Apache 2.0 a MIT?

Sí, puedes relicenciar tus propias adiciones/modificaciones, pero el código original sigue bajo Apache 2.0. El proyecto combinado puede distribuirse bajo MIT siempre que el código Apache 2.0 se mantenga identificable.

### ¿La NOTICE file es realmente obligatoria?

Sí. La sección 4(d) de Apache 2.0 requiere que preserves cualquier aviso legal requerido.

### ¿Qué pasa si contribuyo a un proyecto Apache?

Debes firmar un CLAs (Contributor License Agreement) que otorga a la ASF una licencia perpetua sobre tu contribución y certifica que tienes derecho a contribuirla.

## Referencias

- [Apache License 2.0 Text](https://www.apache.org/licenses/LICENSE-2.0)
- [Apache Licenses FAQ](https://www.apache.org/foundation/license-faq.html)
- [Choose a License — Apache 2.0](https://choosealicense.com/licenses/apache-2.0/)
- [SPDX — Apache-2.0](https://spdx.org/licenses/Apache-2.0.html)
- [tl;dr Legal — Apache 2.0](https://www.tldrlegal.com/license/apache-license-2-0-apache-2-0)
- [GPL Compatible Licenses (FSF)](https://www.gnu.org/licenses/license-list.html)
