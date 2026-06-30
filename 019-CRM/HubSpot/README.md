# HubSpot — Plataforma CRM Inbound

## Visión General

HubSpot fue fundada en 2006 por Brian Halligan y Dharmesh Shah, popularizando el concepto de inbound marketing. Ofrece un CRM gratuito y una plataforma integrada de marketing, ventas, servicio al cliente, CMS y operaciones (CRM Platform). Su motor principal es HubDB (base de datos relacional en la nube) y utiliza una arquitectura de microservicios.

## Arquitectura Técnica

HubSpot se compone de varios hubs que se integran nativamente. La plataforma expone APIs REST, GraphQL y un SDK para desarrollo de aplicaciones personalizadas.

```
┌──────────────────────────────────────────────────┐
│                   HubSpot CRM                     │
│  Marketing Hub · Sales Hub · Service Hub · CMS Hub│
│              Operations Hub · Commerce Hub         │
├──────────────────────────────────────────────────┤
│              APIs y Herramientas                   │
│  REST API · GraphQL API · Webhooks · OAuth 2.0   │
├──────────────────────────────────────────────────┤
│        HubDB (Base de Datos Relacional)           │
│  Tablas dinámicas · Campos custom · Relaciones    │
├──────────────────────────────────────────────────┤
│  App Marketplace · Private Apps · Workflows        │
└──────────────────────────────────────────────────┘
```

## HubDB — Base de Datos Dinámica

HubDB es una base de datos relacional diseñada para contenido dinámico y personalizado.

```json
// Creación de tabla HubDB vía API
POST /cms/v3/hubdb/tables
{
  "name": "productos",
  "label": "Catálogo de Productos",
  "dynamic": true,
  "columns": [
    {
      "name": "nombre",
      "label": "Nombre del Producto",
      "type": "TEXT",
      "required": true
    },
    {
      "name": "precio",
      "label": "Precio (EUR)",
      "type": "NUMBER",
      "decimalPoints": 2
    },
    {
      "name": "categoria",
      "label": "Categoría",
      "type": "TEXT",
      "options": [
        {"label": "Electrónica", "value": "electronica"},
        {"label": "Hogar", "value": "hogar"},
        {"label": "Moda", "value": "moda"}
      ]
    },
    {
      "name": "disponible",
      "label": "Disponible",
      "type": "BOOLEAN"
    },
    {
      "name": "ficha_tecnica",
      "label": "Ficha Técnica",
      "type": "FILE"
    }
  ]
}
```

## HubL — HubSpot Language (Template Engine)

HubL es el lenguaje de templating de HubSpot, similar a Jinja2, usado en módulos CMS y emails.

```jinja2
{% set productos = hubdb_table_rows(1234567, "limit=10&orderBy=precio") %}

<div class="product-grid">
  {% for producto in productos %}
    <div class="product-card">
      <h3>{{ producto.nombre }}</h3>
      <p class="price">{{ format_currency(producto.precio, "EUR") }}</p>
      {% if producto.disponible %}
        <span class="badge badge-success">Disponible</span>
      {% else %}
        <span class="badge badge-danger">Agotado</span>
      {% endif %}
      {% if producto.ficha_tecnica %}
        <a href="{{ producto.ficha_tecnica.url }}" target="_blank">
          Ver ficha técnica
        </a>
      {% endif %}
    </div>
  {% endfor %}
</div>

{% if productos is iterable and productos|length == 0 %}
  <p>No hay productos disponibles.</p>
{% endif %}
```

## REST API de HubSpot

```python
import requests

class HubSpotClient:
    BASE_URL = "https://api.hubapi.com"

    def __init__(self, access_token: str):
        self.headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }

    def create_contact(self, email: str, firstname: str, lastname: str, properties: dict = None) -> dict:
        payload = {
            "properties": {
                "email": email,
                "firstname": firstname,
                "lastname": lastname,
                **(properties or {})
            }
        }
        resp = requests.post(
            f"{self.BASE_URL}/crm/v3/objects/contacts",
            headers=self.headers,
            json=payload
        )
        resp.raise_for_status()
        return resp.json()

    def search_companies(self, domain: str) -> list:
        resp = requests.post(
            f"{self.BASE_URL}/crm/v3/objects/companies/search",
            headers=self.headers,
            json={
                "filterGroups": [{
                    "filters": [{
                        "propertyName": "domain",
                        "operator": "EQ",
                        "value": domain
                    }]
                }],
                "limit": 50
            }
        )
        resp.raise_for_status()
        return resp.json().get("results", [])

    def get_all_deal_stages(self) -> list:
        resp = requests.get(
            f"{self.BASE_URL}/crm/v3/pipelines/deals",
            headers=self.headers
        )
        resp.raise_for_status()
        return resp.json().get("results", [])
```

## Webhooks de HubSpot

HubSpot puede enviar webhooks a URLs externas cuando ocurren eventos específicos.

```javascript
// Ejemplo con Express.js
const express = require('express');
const crypto = require('crypto');

const app = express();
const CLIENT_SECRET = process.env.HUBSPOT_CLIENT_SECRET;

app.post('/webhooks/hubspot', express.json(), (req, res) => {
    const signature = req.headers['x-hubspot-signature'];
    const source = req.headers['x-hubspot-signature-v3'];

    // Verificar firma
    const computedSig = crypto
        .createHmac('sha256', CLIENT_SECRET)
        .update(JSON.stringify(req.body))
        .digest('hex');

    if (computedSig !== signature) {
        return res.status(401).json({ error: 'Firma inválida' });
    }

    const events = req.body;
    events.forEach(async (event) => {
        switch (event.subscriptionType) {
            case 'contact.creation':
                await handleNewContact(event.objectId);
                break;
            case 'deal.propertyChange':
                await handleDealUpdate(event.objectId, event.propertyName);
                break;
            default:
                console.log('Evento no manejado:', event.subscriptionType);
        }
    });

    res.status(200).send('OK');
});
```

## Workflows y Automatización

```json
// Ejemplo de workflow vía API (Workflows API v4)
POST /automation/v4/workflows
{
  "name": "Lead Scoring Automático",
  "type": "CONTACT_BASED",
  "actionSets": [
    {
      "actions": [
        {
          "type": "ENROLL_IN_LIST",
          "listId": 123
        },
        {
          "type": "SET_CONTACT_PROPERTY",
          "propertyName": "lead_score",
          "propertyValue": "50"
        },
        {
          "type": "DELAY",
          "delayMilliseconds": 86400000
        },
        {
          "type": "SEND_EMAIL",
          "emailId": 456
        }
      ]
    }
  ],
  "trigger": {
    "type": "CONTACT_PROPERTY_CHANGE",
    "property": "lifecyclestage",
    "value": "lead"
  }
}
```

## Custom Objects en HubSpot

```json
// Definición de objeto custom vía API
POST /crm/v3/schemas
{
  "name": "machine",
  "labels": {
    "singular": "Máquina",
    "plural": "Máquinas"
  },
  "primaryDisplayProperty": "modelo",
  "requiredProperties": ["modelo", "tipo", "año"],
  "properties": [
    {
      "name": "modelo",
      "label": "Modelo",
      "type": "string",
      "fieldType": "text"
    },
    {
      "name": "tipo",
      "label": "Tipo de Máquina",
      "type": "enumeration",
      "fieldType": "select",
      "options": [
        {"label": "CNC", "value": "cnc"},
        {"label": "Impresión 3D", "value": "impresion_3d"},
        {"label": "Corte Láser", "value": "corte_laser"}
      ]
    },
    {
      "name": "año",
      "label": "Año de Fabricación",
      "type": "number",
      "fieldType": "number"
    }
  ],
  "associatedObjects": ["contact", "deal"]
}
```

## Asociaciones entre Objetos

```python
# Asociar contacto a un negocio (deal) y a una máquina (custom object)
def associate_objects(client, from_obj, from_id, to_obj, to_id, association_type):
    url = (
        f"{client.BASE_URL}/crm/v3/objects/"
        f"{from_obj}/{from_id}/associations/{to_obj}/{to_id}"
    )
    resp = requests.put(url, headers=client.headers, json={
        "associationTypeId": association_type
    })
    resp.raise_for_status()
    return resp.json()

# Uso
associate_objects(hs_client, "contacts", 123, "machines", 456, 16)
```

## Herramientas para Desarrolladores

### CLI de HubSpot

```bash
# Instalación
npm install -g @hubspot/cli

# Iniciar proyecto
hs init

# Subir archivos al Design Manager
hs upload src/templates marketplace/custom-templates

# Descargar assets
hs download marketplace/custom-templates src/templates

# Crear un proyecto serverless
hs project create --template default

# Desplegar proyecto serverless
hs project deploy
```

## Buenas Prácticas

1. **Rate Limiting** — Respetar los límites de 100 solicitudes/10s para la mayoría de APIs.
2. **Webhooks Idempotentes** — Usar `eventId` para evitar procesamiento duplicado.
3. **Props vs. Custom** — Reutilizar propiedades estándar antes de crear propiedades custom.
4. **HubDB vs. Custom Objects** — Usar HubDB para contenido público y Custom Objects para datos privados de CRM.
5. **Backup** — Exportar regularmente los datos mediante `crm/v3/exports`.
6. **Sandbox** — Desarrollar en sandbox antes de desplegar en producción.
7. **OAuth** — Usar OAuth 2.0 con refresh tokens para integraciones server-to-server.

## Ejemplo de App Serverless con HubSpot

```javascript
// Function serverless de HubSpot
const axios = require('axios');

exports.main = async (context, sendResponse) => {
    const { contactEmail } = context.parameters;

    try {
        const response = await axios.get(
            `https://api.github.com/users/${contactEmail.split('@')[0]}/repos`,
            { headers: { 'Accept': 'application/vnd.github.v3+json' } }
        );

        const repos = response.data.map(repo => ({
            name: repo.name,
            stars: repo.stargazers_count,
            language: repo.language,
            url: repo.html_url
        }));

        sendResponse({
            status: 'success',
            data: repos
        });
    } catch (error) {
        sendResponse({
            status: 'error',
            message: error.message
        });
    }
};
```
