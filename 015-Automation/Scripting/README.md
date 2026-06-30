# Scripting — Automatización con Scripts

## Conceptos Fundamentales

El scripting es la forma más fundamental de automatización: programas cortos que ejecutan tareas repetitivas, orquestan herramientas, procesan datos o gestionan sistemas. A diferencia de herramientas declarativas (Terraform, Ansible), los scripts son imperativos y ofrecen control granular.

### ¿Cuándo usar scripts?

- Tareas ad-hoc y rápidas
- Automatización que no justifica una herramienta completa
- Orquestación de múltiples herramientas
- Procesamiento de datos y transformación
- Hooks de git y CI/CD
- Bootstrapping de entornos

## Bash Scripting

### Template de script

```bash
#!/usr/bin/env bash
set -euo pipefail
LOG_FILE="deploy-$(date +%Y%m%d-%H%M%S).log"
log() { echo "[INFO] $*" | tee -a "$LOG_FILE"; }

ENVIRONMENT="${1:?Se requiere entorno}"
VERSION="${2:?Se requiere versión}"

log "Desplegando versión $VERSION en $ENVIRONMENT..."
pg_dump myapp > "backup-${ENVIRONMENT}.sql"
rsync -avz --delete dist/ "user@server:/opt/myapp/"
ssh "user@server" "sudo systemctl restart myapp"
curl -f http://server:8080/health && log "Despliegue completado"
```

## Python Scripting

```python
#!/usr/bin/env python3
"""Script de automatización de backups."""

import argparse
import datetime
import json
import logging
import os
import subprocess
import sys
from pathlib import Path
from typing import Optional

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
log = logging.getLogger(__name__)


class BackupManager:
    """Gestiona backups de base de datos y archivos."""

    def __init__(self, config_path: str):
        with open(config_path) as f:
            self.config = json.load(f)

    def backup_database(self, db_name: str, output_dir: Path) -> Path:
        """Realiza backup de una base de datos PostgreSQL."""
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = output_dir / f"{db_name}_{timestamp}.sql.gz"

        cmd = [
            "pg_dump",
            f"--dbname=postgresql://{self.config['db']['user']}:{self.config['db']['password']}@"
            f"{self.config['db']['host']}:{self.config['db']['port']}/{db_name}",
            "--compress=9",
            f"--file={filename}",
        ]

        log.info(f"Backup de {db_name} en {filename}")
        subprocess.run(cmd, check=True, capture_output=True, text=True)
        log.info(f"Backup completado: {filename} ({filename.stat().st_size / 1e6:.2f} MB)")
        return filename

    def cleanup_old_backups(self, output_dir: Path, days: int = 30):
        """Elimina backups más antiguos que days días."""
        cutoff = datetime.datetime.now() - datetime.timedelta(days=days)
        for f in output_dir.glob("*.sql.gz"):
            if datetime.datetime.fromtimestamp(f.stat().st_mtime) < cutoff:
                f.unlink()
                log.info(f"Eliminado backup antiguo: {f}")


def main():
    parser = argparse.ArgumentParser(description="Gestión de backups")
    parser.add_argument("--config", required=True, help="Ruta al archivo de configuración")
    parser.add_argument("--db", nargs="+", help="Bases de datos a respaldar")
    parser.add_argument("--output", default="/backups", help="Directorio de salida")
    parser.add_argument("--cleanup-days", type=int, default=30, help="Días de retención")
    args = parser.parse_args()

    manager = BackupManager(args.config)
    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    if args.db:
        for db in args.db:
            manager.backup_database(db, output_dir)

    manager.cleanup_old_backups(output_dir, args.cleanup_days)


if __name__ == "__main__":
    main()
```

## Best Practices

1. **Error handling**: `set -euo pipefail` en Bash, `sys.exit(1)` en Python.
2. **Idempotencia**: Mismo resultado ejecutado N veces.
3. **Logging**: Cada paso con timestamp, a archivo y stdout.
4. **Argumentos CLI**: `argparse` o getopts. No hardcodear rutas.
5. **Validaciones**: Fallar rápido si falta un binario o variable.
6. **Dry-run**: `--dry-run` para mostrar sin ejecutar.
7. **Modularidad**: Funciones reutilizables, cada una hace una cosa.
