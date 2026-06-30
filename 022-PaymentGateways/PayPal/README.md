# PayPal — Plataforma de Pagos Digital Global

## Visión General

PayPal fue fundada en 1998 (Confinity/X.com) y adquirida por eBay en 2002. Es una de las plataformas de pago digital más antiguas y extendidas, operando en más de 200 mercados y 25 monedas. PayPal ofrece procesamiento de pagos (PayPal Checkout, Pay Later), pagos Business (PayPal Business), billetera digital (Venmo, PayPal Wallet), y soluciones para desarrolladores (REST API, JavaScript SDK, Braintree).

## Arquitectura Técnica

```
┌──────────────────────────────────────────────────┐
│              Cliente (Browser / App)              │
│  PayPal Buttons (SDK JS) · Smart Buttons        │
├──────────────────────────────────────────────────┤
│              PayPal API Gateway                   │
│  /v2/checkout/orders · /v2/payments              │
├──────────────────────────────────────────────────┤
│           PayPal Core (Procesamiento)             │
│  Auth · Settlement · Risk · Compliance           │
├──────────────────────────────────────────────────┤
│          Redes de Pago (Adquirentes)              │
│  PayPal Wallet · Tarjetas · Venmo · PUI          │
└──────────────────────────────────────────────────┘
```

## Modelo de Pagos — Orders v2 API

PayPal migró de Payments API (v1) a Orders API (v2). El flujo moderno se basa en `Orders` → `Authorize` → `Capture`.

```python
import paypalrestsdk
import json

# Configuración (REST API credentials)
paypalrestsdk.configure({
    "mode": "sandbox",  # sandbox | live
    "client_id": "AeCz...",
    "client_secret": "EJAO..."
})

# Crear orden
order = paypalrestsdk.Order({
    "intent": "CAPTURE",
    "purchase_units": [{
        "reference_id": "PU_001",
        "description": "Consultoría Cloud Migration",
        "amount": {
            "currency_code": "EUR",
            "value": "5000.00",
            "breakdown": {
                "item_total": {
                    "currency_code": "EUR",
                    "value": "4500.00"
                },
                "tax_total": {
                    "currency_code": "EUR",
                    "value": "500.00"
                }
            }
        },
        "items": [{
            "name": "Consultoría Cloud",
            "description": "Migración a AWS - 40 horas",
            "unit_amount": {
                "currency_code": "EUR",
                "value": "112.50"
            },
            "quantity": "40",
            "category": "DIGITAL_GOODS"
        }],
        "payee": {
            "email_address": "vendedor@empresa.com"
        }
    }],
    "payment_source": {
        "paypal": {
            "experience_context": {
                "payment_method_preference": "IMMEDIATE_PAYMENT_REQUIRED",
                "brand_name": "AI Knowledge Engine",
                "locale": "es-ES",
                "landing_page": "LOGIN",
                "user_action": "PAY_NOW"
            }
        }
    },
    "application_context": {
        "brand_name": "AI Knowledge Engine",
        "locale": "es-ES",
        "shipping_preference": "NO_SHIPPING",
        "user_action": "PAY_NOW"
    }
})

if order.create():
    print(f"Orden creada: {order.id} - Status: {order.status}")
    # Redirigir al usuario a aprueba.approval_url
    for link in order.links:
        if link.rel == "approve":
            print(f"URL de aprobación: {link.href}")
else:
    print(f"Error: {order.error}")
```

## PayPal JavaScript SDK — Smart Buttons

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <script src="https://www.paypal.com/sdk/js?client-id=YOUR_CLIENT_ID&currency=EUR&intent=capture">
  </script>
</head>
<body>
  <div id="paypal-button-container"></div>
  <script>
    paypal.Buttons({
      // Opciones de estilo
      style: {
        layout: 'vertical',
        color: 'gold',
        shape: 'rect',
        label: 'pay',
        tagline: false,
        height: 45
      },

      // Crear orden (llamada al servidor)
      createOrder() {
        return fetch('/api/paypal/orders', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            amount: 5000.00,
            currency: 'EUR',
            description: 'Consultoría Cloud Migration'
          })
        })
        .then(res => res.json())
        .then(data => data.id);  // Devolver el orderID de PayPal
      },

      // Capturar pago (aprobado por el usuario)
      onApprove(data) {
        return fetch('/api/paypal/capture', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ orderID: data.orderID })
        })
        .then(res => res.json())
        .then(details => {
          alert('Pago completado: ' + details.purchase_units[0].payments.captures[0].id);
          window.location.href = '/success';
        })
        .catch(err => {
          console.error('Error capturando pago:', err);
          alert('Error al procesar el pago. Contacte al soporte.');
        });
      },

      // Cancelación
      onCancel(data) {
        console.log('Pago cancelado:', data);
        window.location.href = '/checkout?canceled=true';
      },

      // Errores
      onError(err) {
        console.error('Error en PayPal Buttons:', err);
      }
    }).render('#paypal-button-container');
  </script>
</body>
</html>
```

## Backend — Captura de Pago (Express.js)

```javascript
const express = require('express');
const fetch = require('node-fetch');
const app = express();

const PAYPAL_CLIENT_ID = process.env.PAYPAL_CLIENT_ID;
const PAYPAL_SECRET = process.env.PAYPAL_SECRET;
const PAYPAL_API = process.env.PAYPAL_MODE === 'live'
  ? 'https://api-m.paypal.com'
  : 'https://api-m.sandbox.paypal.com';

// Obtener token de acceso
async function getAccessToken() {
  const auth = Buffer.from(`${PAYPAL_CLIENT_ID}:${PAYPAL_SECRET}`).toString('base64');
  const response = await fetch(`${PAYPAL_API}/v1/oauth2/token`, {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${auth}`,
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'grant_type=client_credentials'
  });
  const data = await response.json();
  return data.access_token;
}

// Crear orden
app.post('/api/paypal/orders', async (req, res) => {
  const { amount, currency, description } = req.body;
  const token = await getAccessToken();

  const response = await fetch(`${PAYPAL_API}/v2/checkout/orders`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
      'PayPal-Request-Id': `ORDER_${Date.now()}`  // Idempotencia
    },
    body: JSON.stringify({
      intent: 'CAPTURE',
      purchase_units: [{
        description,
        amount: {
          currency_code: currency || 'EUR',
          value: amount.toString()
        }
      }]
    })
  });

  const order = await response.json();
  res.json({ id: order.id });
});

// Capturar pago
app.post('/api/paypal/capture', async (req, res) => {
  const { orderID } = req.body;
  const token = await getAccessToken();

  const response = await fetch(
    `${PAYPAL_API}/v2/checkout/orders/${orderID}/capture`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      }
    }
  );

  const captureData = await response.json();

  if (captureData.status === 'COMPLETED') {
    // Actualizar pedido en base de datos
    const capture = captureData.purchase_units[0].payments.captures[0];
    await db.query(
      'UPDATE orders SET payment_id = ?, status = ? WHERE paypal_order_id = ?',
      [capture.id, 'paid', orderID]
    );

    res.json(captureData);
  } else {
    res.status(400).json({ error: 'Pago no completado', details: captureData });
  }
});

// Verificar webhook
app.post('/webhooks/paypal', async (req, res) => {
  // Verificación de firma (recomendado)
  const verification = await fetch(
    `${PAYPAL_API}/v1/notifications/verify-webhook-signature`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${await getAccessToken()}`
      },
      body: JSON.stringify({
        auth_algo: req.headers['paypal-auth-algo'],
        cert_url: req.headers['paypal-cert-url'],
        transmission_id: req.headers['paypal-transmission-id'],
        transmission_sig: req.headers['paypal-transmission-sig'],
        transmission_time: req.headers['paypal-transmission-time'],
        webhook_id: process.env.PAYPAL_WEBHOOK_ID,
        webhook_event: req.body
      })
    }
  );

  const { verification_status } = await verification.json();
  if (verification_status !== 'SUCCESS') {
    return res.status(401).send('Firma inválida');
  }

  const event = req.body;
  switch (event.event_type) {
    case 'CHECKOUT.ORDER.APPROVED':
      console.log('Orden aprobada:', event.resource.id);
      break;
    case 'PAYMENT.CAPTURE.COMPLETED':
      console.log('Captura completada:', event.resource.id);
      break;
    case 'PAYMENT.CAPTURE.REFUNDED':
      console.log('Reembolso:', event.resource.id);
      handleRefund(event.resource);
      break;
  }

  res.status(200).send('OK');
});
```

## PayPal Payouts — Pagos Masivos

```python
import paypalrestsdk
from paypalrestsdk import Payout

# Configurar SDK
paypalrestsdk.configure({
    "mode": "sandbox",
    "client_id": "YOUR_CLIENT_ID",
    "client_secret": "YOUR_CLIENT_SECRET"
})

# Crear payout batch
payout = Payout({
    "sender_batch_header": {
        "sender_batch_id": "BATCH_" + str(int(time.time())),
        "email_subject": "Has recibido un pago de AI Knowledge Engine",
        "email_message": "Gracias por tu colaboración. Adjunto el pago."
    },
    "items": [
        {
            "recipient_type": "EMAIL",
            "amount": {
                "value": "1500.00",
                "currency": "EUR"
            },
            "note": "Pago consultoría enero 2025",
            "sender_item_id": "ITEM_001",
            "receiver": "freelancer1@email.com"
        },
        {
            "recipient_type": "EMAIL",
            "amount": {
                "value": "2500.00",
                "currency": "EUR"
            },
            "note": "Pago desarrollo módulo SAP",
            "sender_item_id": "ITEM_002",
            "receiver": "freelancer2@email.com"
        }
    ]
})

if payout.create(sync_mode=True):
    print(f"Payout creado: {payout.batch_header.payout_batch_id}")
    print(f"Estado: {payout.batch_header.batch_status}")
else:
    print(f"Error: {payout.error}")
```

## PayPal Subscriptions — Suscripciones

```javascript
// Crear plan de suscripción
const createPlan = async () => {
  const token = await getAccessToken();

  const plan = await fetch(`${PAYPAL_API}/v1/billing/plans`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({
      product_id: 'PROD-XXX',
      name: 'Plan Profesional Mensual',
      description: 'Suscripción mensual al plan profesional',
      status: 'ACTIVE',
      billing_cycles: [{
        frequency: { interval_unit: 'MONTH', interval_count: 1 },
        tenure_type: 'REGULAR',
        sequence: 1,
        total_cycles: 12,
        pricing_scheme: {
          fixed_price: { value: '29.99', currency_code: 'EUR' }
        }
      }],
      payment_preferences: {
        auto_bill_outstanding: true,
        setup_fee: { value: '0', currency_code: 'EUR' },
        setup_fee_failure_action: 'CONTINUE',
        payment_failure_threshold: 3
      }
    })
  });

  return await plan.json();
};

// Crear suscripción
const createSubscription = async (planId, customerEmail) => {
  const token = await getAccessToken();

  const subscription = await fetch(`${PAYPAL_API}/v1/billing/subscriptions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({
      plan_id: planId,
      subscriber: {
        name: { given_name: 'Cliente', surname: 'Empresa' },
        email_address: customerEmail
      },
      application_context: {
        brand_name: 'AI Knowledge Engine',
        locale: 'es-ES',
        shipping_preference: 'NO_SHIPPING',
        user_action: 'SUBSCRIBE_NOW',
        payment_method: {
          payer_selected: 'PAYPAL',
          payee_preferred: 'IMMEDIATE_PAYMENT_REQUIRED'
        }
      }
    })
  });

  return await subscription.json();
};
```

## Reembolsos y Disputas

```python
import paypalrestsdk

# Reembolso completo de una captura
capture = paypalrestsdk.Capture.find("CAPTURE_ID")
refund = capture.refund({
    "amount": {
        "value": "5000.00",
        "currency_code": "EUR"
    },
    "note_to_payer": "Reembolso solicitado por el cliente"
})

if refund.success():
    print(f"Reembolso ID: {refund.id}, Estado: {refund.status}")
else:
    print(f"Error: {refund.error}")

# Reembolso parcial
partial_refund = capture.refund({
    "amount": {
        "value": "1000.00",
        "currency_code": "EUR"
    }
})

# Listar disputas
disputes = paypalrestsdk.Dispute.all({
    "start_date": "2025-01-01T00:00:00Z",
    "end_date": "2025-01-31T23:59:59Z"
})

for dispute in disputes.disputes:
    print(f"Disputa {dispute.dispute_id}: {dispute.reason} - {dispute.status}")
```

## Buenas Prácticas

1. **Idempotencia** — Usar `PayPal-Request-Id` (también llamado `Idempotency-Key`) para prevenir duplicados.
2. **Webhooks** — Verificar firma con `POST /v1/notifications/verify-webhook-signature` y renovar certificados.
3. **SCA (Strong Customer Authentication)** — PayPal maneja automáticamente PSD2/SCA para la UE.
4. **Testing** — Usar cuentas sandbox en `https://developer.paypal.com/dashboard/`.
5. **Token de acceso** — Cachear el access token (caduca en ~9 horas) para evitar renovaciones constantes.
6. **Logging** — Registrar todos los eventos de API: order creadas, captures, refunds, webhooks.
7. **Seguridad** — Nunca compartir `client_secret`. Usar variables de entorno para credenciales.
8. **Rate Limits** — Respetar el límite por defecto de 50 solicitudes por segundo.
9. **Monitoring** — Rastrear decline codes (`INSTRUMENT_DECLINED`, `PAYER_ACTION_REQUIRED`).

## Comparativa con Stripe

| Característica | PayPal | Stripe |
|---------------|--------|--------|
| API Style | REST v2 / SDK | REST / SDK / GraphQL |
| Webhook Verification | Firma HMAC + verify endpoint | Firma HMAC con `whsec_` |
| Recurring | Billing Plans/Subscriptions | Products/Prices/Subscriptions |
| Marketplaces | Payouts API | Connect (multi-destination) |
| Payouts | Sí (batch) | Sí (Connect Payouts) |
| Disputes | API de disputas completa | API de disputas completa |
| Fraud Protection | Seller Protection | Radar (ML-based) |
| SCA | Automático | Requires_action + 3D Secure |
| Multi-moneda | 25+ monedas | 135+ monedas |

## CLI de PayPal

```bash
# PayPal CLI (Node.js)
npm install -g @paypal/cli

# Iniciar sesión
paypal login

# Simular webhooks
paypal webhook simulate --event CHECKOUT.ORDER.APPROVED
paypal webhook simulate --event PAYMENT.CAPTURE.COMPLETED

# Crear orden de prueba
paypal orders create --intent CAPTURE --amount 29.99 --currency EUR

# Ver logs
paypal logs tail
```
