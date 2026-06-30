# Odoo — Suite ERP Modular de Código Abierto

## Visión General

Odoo (antes OpenERP / TinyERP) es un conjunto de aplicaciones de negocio open source fundado por Fabien Pinckaers en Bélgica. Cubre ERP, CRM, e-commerce, contabilidad, inventario, RRHH y más con una filosofía de desarrollo modular. La edición Community es gratuita (LGPL) y la Enterprise añade funcionalidades avanzadas con suscripción.

## Arquitectura Técnica

Odoo sigue una arquitectura multinivel con un servidor Python (Odoo Server), una base de datos PostgreSQL y un frontend web basado en OWL (Odoo Web Library).

```
┌─────────────────────────────────────────┐
│       Navegador Web / Cliente Móvil       │
│    OWL Framework (JavaScript moderno)     │
├─────────────────────────────────────────┤
│           Odoo Server (Python)            │
│  ORM · Report Engine · Workflow · API    │
├─────────────────────────────────────────┤
│          PostgreSQL (Base de Datos)       │
│   Modelo relacional · Traducciones · ACL  │
└─────────────────────────────────────────┘
```

## Estructura de un Módulo Odoo

Cada módulo Odoo es un paquete Python con una estructura bien definida.

```
mi_modulo/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   └── mi_modelo.py
├── views/
│   ├── mi_modelo_views.xml
│   └── menu_views.xml
├── security/
│   ├── ir.model.access.csv
│   └── mi_modulo_security.xml
├── data/
│   └── datos_demo.xml
├── demo/
│   └── demo_data.xml
├── controllers/
│   └── main.py
├── static/
│   └── description/
│       └── icon.png
└── i18n/
    └── es.po
```

## Manifesto del Módulo

```python
# __manifest__.py
{
    'name': 'Gestión Avanzada de Inventarios',
    'version': '18.0.1.0.0',
    'category': 'Inventory',
    'summary': 'Extiende la gestión de inventarios con trazabilidad por lotes',
    'description': """
Módulo para trazabilidad avanzada con códigos de barras y lotes.
    """,
    'author': 'AI Knowledge Engine',
    'depends': ['stock', 'product', 'barcodes'],
    'data': [
        'security/ir.model.access.csv',
        'views/stock_move_views.xml',
        'views/menu_views.xml',
    ],
    'demo': ['demo/demo_data.xml'],
    'installable': True,
    'application': False,
    'auto_install': False,
    'license': 'LGPL-3',
}
```

## Modelo de Datos — ORM de Odoo

Odoo proporciona un ORM completo con herencia múltiple, campos calculados, constraints y flujos de trabajo.

```python
# models/mi_modelo.py
from odoo import models, fields, api
from odoo.exceptions import ValidationError
import re

class LoteInventario(models.Model):
    _name = 'mi.lote.inventario'
    _description = 'Lote de Inventario'
    _rec_name = 'codigo_lote'
    _order = 'fecha_creacion DESC'

    codigo_lote = fields.Char(
        string='Código de Lote',
        required=True,
        index=True,
        copy=False
    )
    producto_id = fields.Many2one(
        'product.product',
        string='Producto',
        required=True,
        domain=[('type', '=', 'product')]
    )
    cantidad = fields.Float(
        string='Cantidad Disponible',
        digits='Product Unit of Measure',
        default=0.0
    )
    fecha_caducidad = fields.Date(string='Fecha de Caducidad')
    ubicacion_id = fields.Many2one(
        'stock.location',
        string='Ubicación',
        domain=[('usage', '=', 'internal')]
    )
    activo = fields.Boolean(string='Activo', default=True)
    estado = fields.Selection([
        ('disponible', 'Disponible'),
        ('reservado', 'Reservado'),
        ('caducado', 'Caducado'),
    ], string='Estado', default='disponible', compute='_compute_estado')

    @api.depends('fecha_caducidad', 'cantidad')
    def _compute_estado(self):
        for record in self:
            if record.fecha_caducidad and record.fecha_caducidad < fields.Date.today():
                record.estado = 'caducado'
            elif record.cantidad <= 0:
                record.estado = 'reservado'
            else:
                record.estado = 'disponible'

    @api.constrains('codigo_lote')
    def _check_codigo_lote(self):
        for record in self:
            if not re.match(r'^LOTE-\d{4}-\d{6}$', record.codigo_lote):
                raise ValidationError('Formato de lote inválido: LOTE-YYYY-NNNNNN')
```

## Vistas XML — Interfaz de Usuario

```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <record id="view_mi_lote_inventario_form" model="ir.ui.view">
        <field name="name">mi.lote.inventario.form</field>
        <field name="model">mi.lote.inventario</field>
        <field name="arch" type="xml">
            <form string="Lote de Inventario">
                <sheet>
                    <group>
                        <group>
                            <field name="codigo_lote"/>
                            <field name="producto_id"/>
                            <field name="cantidad"/>
                        </group>
                        <group>
                            <field name="fecha_caducidad"/>
                            <field name="ubicacion_id"/>
                            <field name="estado" widget="badge"/>
                        </group>
                    </group>
                </sheet>
            </form>
        </field>
    </record>

    <record id="view_mi_lote_inventario_tree" model="ir.ui.view">
        <field name="name">mi.lote.inventario.tree</field>
        <field name="model">mi.lote.inventario</field>
        <field name="arch" type="xml">
            <tree>
                <field name="codigo_lote"/>
                <field name="producto_id"/>
                <field name="cantidad" sum="Total"/>
                <field name="fecha_caducidad"/>
                <field name="estado" widget="badge"/>
            </tree>
        </field>
    </record>
</odoo>
```

## Seguridad — Permisos y Reglas

```csv
# security/ir.model.access.csv
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_mi_lote_inventario_user,mi.lote.inventario.user,model_mi_lote_inventario,base.group_user,1,1,1,0
access_mi_lote_inventario_manager,mi.lote.inventario.manager,model_mi_lote_inventario,stock.group_stock_manager,1,1,1,1
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <record id="rule_mi_lote_inventario_company" model="ir.rule">
        <field name="name">Lote: multi-compañía</field>
        <field name="model_id" ref="model_mi_lote_inventario"/>
        <field name="domain_force">[('company_id', 'in', company_ids)]</field>
    </record>
</odoo>
```

## API Externa — XML-RPC y JSON-RPC

```python
import xmlrpc.client

url = 'https://mi-instancia.odoo.com'
db = 'mi_base'
username = 'admin'
password = 'secret'

common = xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/common')
uid = common.authenticate(db, username, password, {})

models = xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/object')
lotes = models.execute_kw(db, uid, password,
    'mi.lote.inventario', 'search_read',
    [[['estado', '=', 'disponible']]],
    {'fields': ['codigo_lote', 'producto_id', 'cantidad'], 'limit': 50})
```

## Migración y Actualización

Odoo proporciona scripts de migración entre versiones.

```python
# migrations/18.0.1.0.0/pre-migrate.py
def migrate(cr, version):
    if not version:
        return
    cr.execute("""
        UPDATE mi_lote_inventario
        SET ubicacion_id = (
            SELECT id FROM stock_location
            WHERE usage = 'internal' LIMIT 1
        )
        WHERE ubicacion_id IS NULL
    """)
```

## Buenas Prácticas

1. **Herencia** — Preferir herencia por prototipo (`_inherit`) antes que modificar módulos existentes.
2. **Rendimiento** — Usar `sudo()` con cuidado, evitar N+1 queries con `read_group()` y `search()` con prefetch.
3. **Tests** — Escribir tests YAML o Python con `TransactionCase`.
4. **i18n** — Mantener archivos PO actualizados para traducciones.
5. **Git** — Seguir convenciones de commits: `[FIX]`, `[ADD]`, `[IMP]`, `[REF]`.
6. **Seguridad** — Nunca exponer métodos sin verificación de permisos.

## Despliegue con Docker

```yaml
# docker-compose.yml
version: '3.8'
services:
  odoo:
    image: odoo:18.0
    depends_on:
      - db
    ports:
      - "8069:8069"
    volumes:
      - odoo-data:/var/lib/odoo
      - ./custom-addons:/mnt/extra-addons
    environment:
      - HOST=db
      - USER=odoo
      - PASSWORD=odoo
  db:
    image: postgres:16
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=odoo
      - POSTGRES_PASSWORD=odoo
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  odoo-data:
  postgres-data:
```

## Odoo Sh — Plataforma Cloud

Odoo.sh es la plataforma PaaS oficial de Odoo. Ofrece CI/CD automatizado, staging automático, backups, y escalado horizontal. Compatible con GitHub, GitLab y Bitbucket.
