# 023-Banking: Banca Digital

## Descripción del dominio

La banca digital transforma los servicios financieros tradicionales mediante tecnología, eliminando la necesidad de sucursales físicas para la mayoría de operaciones. Abarca sistemas de core bancario, canales digitales (web, móvil), open banking (PSD2), pagos en tiempo real (ISO 20022), originación de créditos, gestión de riesgos y cumplimiento regulatorio. La modernización de core bancario legacy es uno de los mayores desafíos técnicos del sector financiero.

## Conceptos clave

- **Core Banking System**: Sistema central que gestiona cuentas, transacciones, saldos e intereses
- **Open Banking**: Exposición de datos bancarios via APIs seguras (terceros autorizados)
- **PSD2 (Payment Services Directive 2)**: Regulación europea que obliga a abrir APIs bancarias
- **ISO 20022**: Estándar global para mensajería financiera en pagos y reporting
- **SCA (Strong Customer Authentication)**: Autenticación multifactor obligatoria en pagos digitales
- **AISP (Account Information Service Provider)**: Proveedor que accede a información de cuentas
- **PISP (Payment Initiation Service Provider)**: Proveedor que inicia pagos desde cuentas
- **Real-Time Payments (RTP)**: Sistemas de pagos inmediatos 24/7 (SPEI, SEPA Instant, FedNow)
- **KYC (Know Your Customer)**: Procesos de verificación de identidad del cliente
- **AML (Anti-Money Laundering)**: Sistemas de detección y prevención de lavado de dinero
- **Digital Onboarding**: Apertura de cuentas 100% digital con validación biométrica
- **SWIFT**: Red de mensajería interbancaria global (transiciones a ISO 20022)
- **Credit Scoring**: Evaluación automatizada de riesgo crediticio con ML
- **Treasury Management**: Gestión de liquidez, cash pooling y conciliación

## Tecnologías principales

- **Temenos**: Core banking líder, T24/Transact, cloud-native, SaaS
- **Thought Machine (Vault)**: Core bancario moderno, cloud-native, APIs first
- **Mambu**: Core bancario SaaS, componente-based, orientado a neobancos
- **Finacle (Infosys)**: Core bancario global con módulos de banca digital
- **Oracle Flexcube**: Core bancario tradicional ampliamente adoptado
- **SAP Banking**: Suite SAP para banca corporativa y minorista
- **Backbase**: Plataforma de engagement bancario, frontend omnicanal
- **Nucleus Software**: Core para banca de consumo y préstamos
- **Fiserv**: Proveedor integral de tecnología financiera (core, pagos, procesamiento)
- **FIS**: Tecnología bancaria global, core, pagos, wealth management
- **Plaid**: Conectividad con cuentas bancarias para open banking
- **Yolt/Nordigen (GoCardless)**: Agregadores AIS bajo PSD2
- **Token.io**: Plataforma de open banking payments en Europa

## Hoja de ruta

1. **Principiante**: Entender estructura del sistema bancario (cuentas, transacciones, saldos, intereses). Conceptos de core bancario, ledger, double-entry accounting. Diferencias entre banca minorista, corporativa e inversión.
2. **Intermedio**: Integrar APIs de open banking (Plaid, TrueLayer). Implementar KYC digital con validación documental. Flujo de pagos SEPA/SPEI. Conciliación automatizada. Préstamos digitales básicos.
3. **Avanzado**: Arquitectura de core bancario moderno (Mambu, Thought Machine). Diseño de ledger contable escalable. Implementación de ISO 20022. Pagos en tiempo real con orquestación. Scoring crediticio con ML.
4. **Experto**: Diseñar core bancario propio. Estrategias de migración desde sistemas legacy (mainframe). Banca como servicio (BaaS). Integración con CBDC (Central Bank Digital Currency). Sistemas de detección de fraude en tiempo real.

## Relaciones con otros módulos

- [Fintech](../024-Fintech/) — Neobancos, lending digital, open banking, banca como servicio
- [PaymentGateways](../022-PaymentGateways/) — Procesamiento de pagos, adquirencia, PSPs
- [Compliance](../053-Compliance/) — Regulaciones bancarias, PSD2, KYC, AML, GDPR
- [Security](../009-Security/) — Cifrado, autenticación fuerte, prevención de fraude
- [Databases](../003-Databases/) — Ledger contable, persistencia transaccional ACID
- [Cloud](../005-Cloud/) — Core bancario cloud-native, regulación de residencia de datos
- [Architecture](../010-Architecture/) — Microservicios, event sourcing, CQRS en sistemas financieros

## Recursos recomendados

- [Thought Machine Docs](https://docs.thoughtmachine.net)
- [Mambu Developers](https://developers.mambu.com)
- [Temenos Developer Portal](https://developer.temenos.com)
- [PSD2 Directive (EU)](https://ec.europa.eu/info/law/payment-services-psd-2-directive-eu-2015-2366)
- [ISO 20022](https://www.iso20022.org)
- "The Future of Banking" — Brett King
- "Bank 4.0" — Brett King
- [Plaid Docs](https://plaid.com/docs)
- [SWIFT ISO 20022 Migration](https://www.swift.com/our-solutions/iso-20022)
