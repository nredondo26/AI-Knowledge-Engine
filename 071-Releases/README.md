# 071-Releases — Gestión de Releases

## Descripción del dominio

La gestión de releases es el proceso de planificar, empaquetar, probar y distribuir versiones de software a los usuarios finales. Abarca desde la creación de GitHub Releases y etiquetado Git hasta la publicación de artefactos binarios, paquetes y contenedores. Una gestión sólida de releases garantiza trazabilidad, repetibilidad y despliegues confiables.

## Conceptos clave

- **GitHub Releases**: Funcionalidad de GitHub que permite etiquetar commits, generar notas de release y distribuir artefactos binarios descargables.
- **Git Tag**: Etiqueta (`git tag v1.2.3`) que marca un punto específico en la historia del repositorio asociado a una versión.
- **Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH` con reglas para cambios incompatibles, nuevas funcionalidades y parches.
- **Release Notes**: Documento narrativo que describe qué incluye una release, dirigido a desarrolladores y usuarios.
- **Artifact Management**: Almacenamiento y distribución de artefactos de build (JARs, DLLs, imágenes Docker, paquetes npm).
- **Distribution Channels**: Canales de distribución (npm, PyPI, Maven Central, Docker Hub, GitHub Releases, APT, Homebrew).
- **Pre-release / Release Candidate (RC)**: Versiones previas a la release estable para pruebas.
- **GitHub Actions Release Workflows**: Automatización de builds, pruebas y publicación usando Actions.
- **Release Train**: Modelo de releases regulares en intervalos fijos (ej. releases mensuales).
- **Canary / Rolling Releases**: Estrategias de despliegue gradual para minimizar riesgos.

## Tecnologías principales

- **GitHub Releases**: Plataforma principal para publicación de releases y artefactos.
- **semantic-release**: Automatización completa de versionado, changelog y publicación.
- **Release Please**: Acción de GitHub para automatizar PRs de release.
- **goreleaser**: Herramienta para releases de Go (build multi-plataforma, publicación).
- **changesets**: Gestión de versiones para monorepos JavaScript/TypeScript.
- **nexus / artifactory**: Repositorios de artefactos empresariales (sonatype Nexus, JFrog Artifactory).
- **Docker Hub / GHCR**: Registries de contenedores para distribuir imágenes Docker.
- **Homebrew**: Distribución de herramientas CLI para macOS/Linux.
- **npm / PyPI / Maven Central / RubyGems**: Registries de paquetes por ecosistema.

## Hoja de ruta

1. **Principiante**: Crear una GitHub Release manual. Entender SemVer. Escribir release notes básicas. Usar `git tag` y `git push --tags`.
2. **Intermedio**: Automatizar releases con GitHub Actions. Usar semantic-release o Release Please. Subir artefactos a múltiples registries.
3. **Avanzado**: Gestionar releases en monorepos. Implementar release trains y canary deployments. Firmar artefactos con GPG. Integrar con SBOM (Software Bill of Materials). Gestionar versiones en entornos enterprise con Artifactory/Nexus.

## Relaciones con otros módulos

- [`../070-Changelogs/`](../070-Changelogs/) — Los changelogs alimentan las release notes y se generan durante el proceso de release.
- [`../014-CICD/`](../014-CICD/) — Los pipelines de CI/CD ejecutan los workflows de release automatizados.
- [`../013-DevOps/`](../013-DevOps/) — La gestión de releases es una disciplina central de DevOps.
- [`../005-Cloud/`](../005-Cloud/) — Distribución de artefactos en la nube (S3, GCS, registries).
- [`../006-Containers/`](../006-Containers/) — Publicación de imágenes Docker y contenedores como artefactos de release.
- [`../078-SDKs/`](../078-SDKs/) — Releases de SDKs y librerías cliente con versionado SemVer.
- [`../046-BestPractices/`](../046-BestPractices/) — Buenas prácticas para releases confiables y trazables.

## Recursos recomendados

- [GitHub Releases Docs](https://docs.github.com/en/repositories/releasing-projects-on-github) — Documentación oficial de releases en GitHub.
- [SemVer.org](https://semver.org/) — Especificación de versionado semántico.
- [semantic-release](https://semantic-release.gitbook.io/) — Automatización de releases.
- [goreleaser](https://goreleaser.com/) — Releases multi-plataforma para Go.
- [changesets](https://github.com/changesets/changesets) — Versionado para monorepos.
- [Keeping a Changelog](https://keepachangelog.com/) — Estándar para changelogs en releases.
