# 070-Changelogs — Historial de Cambios

## Descripción del dominio

Los changelogs son registros cronológicos de todos los cambios significativos realizados en un proyecto de software. Un buen changelog permite a desarrolladores, usuarios y equipos de producto entender qué ha cambiado entre versiones, quién realizó cada cambio y por qué. Este módulo cubre los formatos estándar de changelogs, la convención de commits convencionales, el versionado semántico y las mejores prácticas para gestionar releases.

## Conceptos clave

- **Changelog**: Documento que lista cambios notables por versión, generalmente ordenado de más reciente a más antiguo.
- **Conventional Commits**: Especificación para mensajes de commit estructurados (`feat:`, `fix:`, `BREAKING CHANGE:`) que permite generar changelogs automáticamente.
- **Semantic Versioning (SemVer)**: Sistema de versionado `MAJOR.MINOR.PATCH` donde MAJOR indica cambios incompatibles, MINOR añade funcionalidad retrocompatible y PATCH corrige bugs retrocompatibles.
- **Keep a Changelog**: Estándar popular que define cómo estructurar un archivo `CHANGELOG.md` con secciones como Added, Changed, Deprecated, Removed, Fixed, Security.
- **Release Notes**: Notas de lanzamiento dirigidas a usuarios finales, más narrativas que un changelog técnico.
- **Automated Changelog Generation**: Herramientas que parsean commits convencionales para generar changelogs automáticos (standard-version, semantic-release, changesets).
- **Unreleased Section**: Sección en el changelog para cambios aún no publicados en una release.
- **CHANGELOG vs RELEASES vs GitHub Releases**: Diferencias entre el archivo de changelog, las notas de release y las releases de GitHub.

## Tecnologías principales

- **standard-version**: Utilidad CLI que automatiza versionado y generación de changelog basada en Conventional Commits.
- **semantic-release**: Herramienta completamente automatizada que determina la siguiente versión, genera changelog y publica.
- **Changesets**: Sistema de gestión de versiones para monorepos (usado por proyectos como Next.js).
- **commitlint**: Linter para mensajes de commit que asegura el cumplimiento de Conventional Commits.
- **convco**: Herramienta CLI para trabajar con Conventional Commits y generar changelogs.
- **git-cliff**: Generador de changelogs altamente configurable escrito en Rust.
- **Release Please**: Acción de GitHub que automatiza releases basada en Conventional Commits.

## Hoja de ruta

1. **Principiante**: Entender SemVer (MAJOR.MINOR.PATCH). Aprender Conventional Commits (`feat`, `fix`, `BREAKING CHANGE`). Leer "Keep a Changelog". Crear un CHANGELOG.md manual.
2. **Intermedio**: Configurar commitlint + husky. Usar standard-version para generar changelogs automáticos. Integrar changelog generation en CI/CD.
3. **Avanzado**: Implementar semantic-release con plugins personalizados. Gestionar changelogs en monorepos con Changesets. Generar changelogs multi-idioma. Personalizar templates de changelog con git-cliff.

## Relaciones con otros módulos

- [`../071-Releases/`](../071-Releases/) — Los changelogs alimentan las release notes y están estrechamente ligados a la gestión de releases.
- [`../013-DevOps/`](../013-DevOps/) — La generación automatizada de changelogs es parte del pipeline DevOps.
- [`../014-CICD/`](../014-CICD/) — Integración de changelog generation en pipelines de CI/CD.
- [`../077-CLI/`](../077-CLI/) — Herramientas CLI como `convco` y `git-cliff` para gestión de changelogs.
- [`../046-BestPractices/`](../046-BestPractices/) — Buenas prácticas de versionado y documentación de cambios.
- [`../042-Documentation/`](../042-Documentation/) — Los changelogs como parte fundamental de la documentación técnica.

## Recursos recomendados

- [Keep a Changelog](https://keepachangelog.com/) — Estándar oficial para estructurar changelogs.
- [Conventional Commits](https://www.conventionalcommits.org/) — Especificación oficial de commits convencionales.
- [SemVer.org](https://semver.org/) — Especificación de versionado semántico.
- [semantic-release](https://semantic-release.gitbook.io/) — Herramienta de automatización de releases.
- [Changesets](https://github.com/changesets/changesets) — Sistema de versiones para monorepos.
- [git-cliff](https://git-cliff.org/) — Generador de changelogs configurable en Rust.
