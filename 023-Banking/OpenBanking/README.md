# Open Banking — Banca Abierta y APIs Financieras

## Visión General

Open Banking es un modelo que permite a terceros (TPP — Third Party Providers) acceder a datos bancarios y ejecutar pagos con el consentimiento del cliente, mediante APIs estandarizadas. Impulsado por la regulación PSD2 en Europa (Revised Payment Services Directive), y replicado en UK (Open Banking Standard), Australia (Consumer Data Right), Brasil, México y otras regiones.

## Marco Regulatorio

### PSD2 (UE) — Directiva de Servicios de Pago 2

```
PSD2 (2015/2366)
├── Artículo 64: Autenticación reforzada (SCA)
├── Artículo 66: Acceso a cuenta de pago (XS2A)
│   ├── AISP: Account Information Service Provider
│   └── PISP: Payment Initiation Service Provider
├── Artículo 67: CISO (Card Issuer Service Provider)
├── RTS (Regulatory Technical Standards)
│   ├── SCA y CSC (Common and Secure Communication)
│   ├── IST: Interface Specific Transport
│   └── Eidas: Certificados cualificados (QSealC / QWAC)
└── Fecha límite: 14 de septiembre 2019
```

### UK Open Banking Standard

```
OBIE (Open Banking Implementation Entity)
├── Read/Write API Spec v3.1.11
├── Account and Transaction API
├── Payment Initiation API
├── Confirmation of Funds API
├── Event Notification API
└── Seguridad: OAuth 2.0 + OpenID Connect + JOSE
```

## Arquitectura Técnica

```
┌──────────────────────────────────────────────────┐
│         TPP (Third Party Provider)                │
│  App / Web que consume APIs bancarias             │
├──────────────────────────────────────────────────┤
│         ASPSP (Banco / Entidad financiera)        │
│  API Gateway · Authorization Server · AI Service │
├──────────────────────────────────────────────────┤
│   SCA Server (Strong Customer Authentication)    │
│  SMS OTP · App push · Biometría · Hardware token │
├──────────────────────────────────────────────────┤
│   Core Banking (Sistema central)                  │
│  Cuentas · Transacciones · Pagos SEPA / SWIFT    │
└──────────────────────────────────────────────────┘
```

## Flujo OAuth 2.0 para Open Banking

```
Cliente (TPP)          Authorization Server (Banco)     Resource Server (Banco)
    │                          │                              │
    │ 1. Redirige al banco    │                              │
    │   (client_id, scope,    │                              │
    │    redirect_uri)        │                              │
    │────────────────────────>│                              │
    │                          │                              │
    │ 2. Autenticación SCA    │                              │
    │   (usuario + MFA)       │                              │
    │<────────────────────────>│                              │
    │                          │                              │
    │ 3. Authorization code   │                              │
    │<────────────────────────│                              │
    │                          │                              │
    │ 4. Token request        │                              │
    │   (code + client_secret)│                              │
    │────────────────────────>│                              │
    │                          │                              │
    │ 5. Access + Refresh     │                              │
    │   token                 │                              │
    │<────────────────────────│                              │
    │                          │                              │
```

## APIs del UK Open Banking Standard

### Account and Transaction API (v3.1.11)

Obtener cuentas, saldos, transacciones y beneficiarios del cliente.

```
GET /accounts                              → Lista de cuentas
GET /accounts/{AccountId}                  → Detalle de cuenta
GET /accounts/{AccountId}/balances         → Saldos actuales
GET /accounts/{AccountId}/transactions     → Transacciones con paginación
GET /accounts/{AccountId}/beneficiaries    → Beneficiarios
GET /accounts/{AccountId}/direct-debits    → Domiciliaciones
GET /accounts/{AccountId}/standing-orders  → Órdenes permanentes
GET /accounts/{AccountId}/product          → Información del producto
GET /accounts/{AccountId}/party            → Titularidad
```

```json
// Ejemplo: GET /accounts/{AccountId}/transactions
GET https://api.banco.com/open-banking/v3.1/aisp/accounts/12345/transactions
Authorization: Bearer eyJhbG...
x-fapi-financial-id: OB-12345
x-fapi-interaction-id: 550e8400-e29b-41d4-a716-446655440000
Accept: application/json

Response 200:
{
  "Data": {
    "Transaction": [
      {
        "AccountId": "12345",
        "TransactionId": "TX20250101001",
        "TransactionReference": "REF-2025-001",
        "StatementReference": ["STMT-01-2025"],
        "CreditDebitIndicator": "Debit",
        "Status": "Booked",
        "BookingDateTime": "2025-01-15T10:30:00+01:00",
        "ValueDateTime": "2025-01-15T10:30:00+01:00",
        "Amount": {
          "Amount": "1500.00",
          "Currency": "EUR"
        },
        "ChargeAmount": {
          "Amount": "0.50",
          "Currency": "EUR"
        },
        "BankTransactionCode": {
          "Code": "ReceivedCreditTransfer",
          "SubCode": "DomesticCreditTransfer"
        },
        "ProprietaryBankTransactionCode": {
          "Code": "TRANSFERENCIA",
          "Issuer": "BANCO_ES"
        },
        "MerchantDetails": {
          "MerchantName": "AI Knowledge Engine S.L.",
          "MerchantCategoryCode": "7372"
        },
        "Balance": {
          "Amount": {
            "Amount": "25000.00",
            "Currency": "EUR"
          },
          "CreditDebitIndicator": "Credit",
          "Type": "InterimBooked"
        }
      }
    ]
  },
  "Links": {
    "Self": "/open-banking/v3.1/aisp/accounts/12345/transactions",
    "Next": "/open-banking/v3.1/aisp/accounts/12345/transactions?page=2"
  },
  "Meta": {
    "TotalPages": 5,
    "FirstAvailableDateTime": "2024-01-01T00:00:00Z",
    "LastAvailableDateTime": "2025-01-31T23:59:59Z"
  }
}
```

### Payment Initiation API

Crear y gestionar pagos desde cuentas del cliente.

```json
// POST /payments
POST https://api.banco.com/open-banking/v3.1/pisp/domestic-payments
{
  "Data": {
    "ConsentId": "12345",
    "Initiation": {
      "InstructionIdentification": "INSTR-2025-001",
      "EndToEndIdentification": "E2E-2025-001",
      "InstructedAmount": {
        "Amount": "5000.00",
        "Currency": "EUR"
      },
      "DebtorAccount": {
        "SchemeName": "IBAN",
        "Identification": "ES9121000418450200051332",
        "Name": "Empresa AI Knowledge Engine S.L."
      },
      "CreditorAccount": {
        "SchemeName": "IBAN",
        "Identification": "ES7921000813610123456789",
        "Name": "Proveedor Servicios Cloud"
      },
      "RemittanceInformation": {
        "Reference": "FACT-2025-001",
        "Unstructured": "Pago factura servicios cloud enero 2025"
      }
    }
  },
  "Risk": {
    "PaymentContextCode": "EcommerceGoods",
    "MerchantCategoryCode": "7372",
    "MerchantCustomerIdentification": "CLI-98765",
    "DeliveryAddress": {
      "AddressLine": ["Calle Tecnología 42"],
      "StreetName": "Calle Tecnología",
      "BuildingNumber": "42",
      "PostCode": "28001",
      "TownName": "Madrid",
      "Country": "ES"
    }
  }
}
```

## Strong Customer Authentication (SCA)

PSD2 requiere autenticación multifactor en dos de tres categorías:

| Factor | Ejemplo |
|--------|---------|
| Conocimiento (algo que sabes) | PIN, contraseña |
| Posesión (algo que tienes) | Móvil, token físico |
| Inherencia (algo que eres) | Huella, biometría facial |

```javascript
// Ejemplo de solicitud SCA en flujo de pago
const paymentRequest = {
  "Data": {
    "ConsentId": consentId,
    "Initiation": {
      "InstructionIdentification": "INSTR-123",
      "EndToEndIdentification": "E2E-123",
      "InstructedAmount": { "Amount": "150.00", "Currency": "EUR" },
      "DebtorAccount": { "SchemeName": "IBAN", "Identification": iban },
      "CreditorAccount": { "SchemeName": "IBAN", "Identification": creditorIban },
      "RemittanceInformation": { "Unstructured": "Pago test" }
    }
  },
  "SCASupportData": {
    "AppliedAuthenticationApproach": "CA", // C: SMS, A: App
    "ReferencePaymentOrderId": null,
    "AuthenticationApproach": "CA",
    "RequestedSCAExemptionType": null // "Single", "Corporate", "TrustedBeneficiary"
  }
};

// Tipos de exemption SCA permitidos:
// - Transaction Risk Analysis (TRA): transacciones < 100 EUR o bajo riesgo
// - Trusted Beneficiary: beneficiarios de confianza
// - Recurring Transactions: mismo importe/beneficiario
// - Secure Corporate Payment: pagos corporativos seguros
```

## Certificados eIDAS

Los TPP deben usar certificados cualificados (QWAC y QSealC) emitidos por una CA cualificada:

```bash
# Obtener el certificado del banco (QWAC)
openssl s_client -connect api.banco.com:443 \
  -servername api.banco.com \
  -showcerts </dev/null 2>/dev/null | \
  openssl x509 -text -noout | \
  grep -A1 "Subject:"

# Enviar certificado en request
curl -X GET "https://api.banco.com/open-banking/v3.1/aisp/accounts" \
  -H "Authorization: Bearer $TOKEN" \
  -H "x-fapi-financial-id: OB-12345" \
  -H "x-fapi-interaction-id: $(uuidgen)" \
  --cert /path/to/tpp_qwac.pem \
  --key /path/to/tpp_private.key
```

## Implementación: Cliente AISP (Account Information)

```python
import requests
import uuid
from datetime import datetime, timedelta

class OpenBankingClient:
    def __init__(self, base_url, client_id, client_secret, cert_path, key_path):
        self.base_url = base_url
        self.client_id = client_id
        self.client_secret = client_secret
        self.cert = (cert_path, key_path)
        self.token = None
        self.token_expires = None

    def _get_token(self, authorization_code=None):
        data = {
            "grant_type": "authorization_code" if authorization_code else "client_credentials",
            "client_id": self.client_id,
            "client_secret": self.client_secret,
            "scope": "accounts payments",
            "redirect_uri": "https://tpp.com/callback"
        }
        if authorization_code:
            data["code"] = authorization_code

        resp = requests.post(
            f"{self.base_url}/token",
            data=data,
            cert=self.cert,
            headers={"x-fapi-interaction-id": str(uuid.uuid4())}
        )
        resp.raise_for_status()
        token_data = resp.json()
        self.token = token_data["access_token"]
        self.token_expires = datetime.now() + timedelta(seconds=token_data["expires_in"])
        return self.token

    def get_accounts(self):
        resp = requests.get(
            f"{self.base_url}/open-banking/v3.1/aisp/accounts",
            headers=self._headers(),
            cert=self.cert
        )
        resp.raise_for_status()
        return resp.json()["Data"]["Account"]

    def get_transactions(self, account_id, from_date=None, to_date=None):
        params = {
            "fromBookingDateTime": from_date or (datetime.now() - timedelta(days=90)).isoformat(),
            "toBookingDateTime": to_date or datetime.now().isoformat()
        }
        resp = requests.get(
            f"{self.base_url}/open-banking/v3.1/aisp/accounts/{account_id}/transactions",
            headers=self._headers(),
            params=params,
            cert=self.cert
        )
        resp.raise_for_status()
        return resp.json()["Data"]["Transaction"]

    def get_balances(self, account_id):
        resp = requests.get(
            f"{self.base_url}/open-banking/v3.1/aisp/accounts/{account_id}/balances",
            headers=self._headers(),
            cert=self.cert
        )
        resp.raise_for_status()
        return resp.json()["Data"]["Balance"]

    def _headers(self):
        if datetime.now() >= self.token_expires:
            self._get_token()
        return {
            "Authorization": f"Bearer {self.token}",
            "x-fapi-interaction-id": str(uuid.uuid4()),
            "x-fapi-financial-id": "OB-12345",
            "Accept": "application/json"
        }

# Uso
client = OpenBankingClient(
    base_url="https://api.banco.com",
    client_id="tpp_client_id",
    client_secret="tpp_secret",
    cert_path="/certs/tpp_qwac.pem",
    key_path="/certs/tpp_key.pem"
)

accounts = client.get_accounts()
for acc in accounts:
    print(f"Cuenta: {acc['AccountId']} - IBAN: {acc['Identification']}")
    balances = client.get_balances(acc['AccountId'])
    for bal in balances:
        print(f"  Saldo: {bal['Amount']['Amount']} {bal['Amount']['Currency']}")
```

## Implementación: Cliente PISP (Payment Initiation)

```python
def initiate_payment(client, debtor_iban, creditor_iban, amount, reference):
    # 1. Crear consentimiento de pago
    consent_payload = {
        "Data": {
            "Initiation": {
                "InstructionIdentification": f"INSTR-{uuid.uuid4().hex[:12].upper()}",
                "EndToEndIdentification": f"E2E-{uuid.uuid4().hex[:12].upper()}",
                "InstructedAmount": {
                    "Amount": f"{amount:.2f}",
                    "Currency": "EUR"
                },
                "DebtorAccount": {
                    "SchemeName": "IBAN",
                    "Identification": debtor_iban
                },
                "CreditorAccount": {
                    "SchemeName": "IBAN",
                    "Identification": creditor_iban
                },
                "RemittanceInformation": {
                    "Unstructured": reference
                }
            }
        },
        "Risk": {
            "PaymentContextCode": "EcommerceGoods",
            "MerchantCategoryCode": "7372"
        }
    }

    resp = requests.post(
        f"{client.base_url}/open-banking/v3.1/pisp/domestic-payment-consents",
        headers=client._headers(),
        json=consent_payload,
        cert=client.cert
    )
    resp.raise_for_status()
    consent = resp.json()
    consent_id = consent["Data"]["ConsentId"]

    # 2. Redirigir al cliente para autorización SCA
    auth_url = (
        f"{client.base_url}/authorize?"
        f"client_id={client.client_id}&"
        f"response_type=code&"
        f"scope=payments&"
        f"redirect_uri=https://tpp.com/callback&"
        f"request={consent_id}"
    )
    print(f"Redirigir cliente a: {auth_url}")

    # 3. El cliente autoriza y recibimos el authorization_code
    # authorization_code = ... (del callback)

    # 4. Crear el pago con el consentimiento autorizado
    payment_payload = {
        "Data": {
            "ConsentId": consent_id,
            "Initiation": consent_payload["Data"]["Initiation"]
        }
    }

    resp = requests.post(
        f"{client.base_url}/open-banking/v3.1/pisp/domestic-payments",
        headers=client._headers(),
        json=payment_payload,
        cert=client.cert
    )
    resp.raise_for_status()
    payment = resp.json()
    return {
        "payment_id": payment["Data"]["DomesticPaymentId"],
        "status": payment["Data"]["Status"],
        "consent_id": consent_id
    }
```

## Confirmation of Funds API

Permite verificar si un cliente dispone de fondos suficientes antes de autorizar un pago.

```json
POST /open-banking/v3.1/cofp/funds-confirmation-consents
{
  "Data": {
    "Initiation": {
      "DebtorAccount": {
        "SchemeName": "IBAN",
        "Identification": "ES9121000418450200051332"
      }
    }
  }
}

// Respuesta: ConsentId, Status: "Authorised"

POST /open-banking/v3.1/cofp/funds-confirmations
{
  "Data": {
    "ConsentId": "CONSENT-12345",
    "Reference": "FUNDS-CHECK-001",
    "InstructedAmount": {
      "Amount": "5000.00",
      "Currency": "EUR"
    }
  }
}

// Respuesta:
{
  "Data": {
    "FundsConfirmationId": "FC-001",
    "FundsAvailableResult": {
      "FundsAvailableDateTime": "2025-01-15T12:00:00+01:00",
      "FundsAvailable": true
    }
  }
}
```

## Event Notification API

Open Banking soporta notificaciones de eventos mediante callbacks o polling.

```json
POST /open-banking/v3.1/events
{
  "Data": {
    "SubscriptionId": "SUB-001",
    "CallbackUrl": "https://tpp.com/ob-events",
    "EventTypes": [
      "urn:uk:org:openbanking:events:resource-update",
      "urn:uk:org:openbanking:events:consent-authorisation-completed"
    ],
    "Version": "2.0"
  }
}
```

## Seguridad y Compliance

| Requisito | Implementación |
|-----------|---------------|
| QWAC | Certificado cualificado TLS mutuo (mTLS) |
| QSealC | Certificado de sello cualificado para firmar JWS |
| MTLS | Autenticación mutua en todas las APIs |
| JWS | Firma digital de requests y responses |
| OAuth 2.0 | Authorization Code Flow + PKCE |
| OpenID Connect | Identity layer sobre OAuth 2.0 |
| SCA | Autenticación reforzada en 2 de 3 factores |
| Consent Management | Granular: por cuenta, período, operación |
| Logging | Registro inmutable de todos los accesos (5 años) |

## Buenas Prácticas

1. **Consentimiento granular** — Solicitar solo los datos necesarios (cuentas, transacciones, períodos).
2. **Rate Limiting** — Respetar límites del banco, típicamente 50-100 TPS por TPP.
3. **Retry con backoff** — Reintentar con backoff exponencial ante errores 429 (Too Many Requests).
4. **Certificates** — Renovar QWAC/QSealC antes de su vencimiento, monitorizar OCSP.
5. **Auditoría** — Mantener logs de todas las transacciones API por requerimiento regulatorio.
6. **Testing** — Usar sandbox bancario (Berlin Group, OBIE) para pruebas de integración.
7. **Redundancia** — Tener múltiples conexiones a ASPSPs para failover.
8. **Token storage** — Almacenar refresh tokens de forma segura (HSM, vault).
