# 022-PaymentGateways: Pasarelas de Pago

## Descripción del dominio

Las pasarelas de pago son la infraestructura tecnológica que autoriza y procesa transacciones financieras entre compradores, vendedores y entidades bancarias. Actúan como intermediarias cifrando datos sensibles, validando fondos y facilitando la liquidación. El dominio abarca pagos con tarjeta (crédito/débito), billeteras digitales, transferencias bancarias, criptomonedas y métodos alternativos. La seguridad es crítica bajo estándares PCI DSS y regulaciones como PSD2.

## Conceptos clave

- **Payment Gateway**: Servicio que autoriza pagos entre comercio y banco adquirente
- **Payment Processor**: Sistema que maneja la comunicación con redes de tarjetas (Visa, MC)
- **Merchant Account**: Cuenta bancaria comercial que recibe fondos de transacciones
- **Acquirer**: Banco que procesa pagos en nombre del comercio
- **Issuer**: Banco que emite la tarjeta al consumidor
- **PCI DSS**: Payment Card Industry Data Security Standard — estándar obligatorio de seguridad
- **3D Secure (3DS)**: Protocolo de autenticación adicional del tarjetahabiente (PSD2 SCA)
- **Tokenization**: Reemplazo de datos sensibles de tarjeta por tokens seguros
- **Chargeback**: Disputa del consumidor que fuerza la devolución del pago
- **Recurring billing**: Pagos periódicos automatizados (suscripciones)
- **Escrow**: Depósito en garantía liberado al cumplir condiciones
- **Settlement**: Liquidación de fondos desde el adquiriente al comercio
- **Stripe Connect**: Plataforma para marketplaces con pagos split
- **PSP (Payment Service Provider)**: Proveedor que unifica múltiples métodos de pago
- **Webhooks**: Notificaciones en tiempo real sobre eventos de pago

## Tecnologías principales

- **Stripe**: Líder en experiencia developer, APIs excelentes, Stripe Connect, Stripe Billing
- **PayPal**: Billetera digital global, PayPal Checkout, Payflow, Braintree
- **Adyen**: Plataforma de pagos enterprise, unifica adquirencia, métodos locales
- **Mercado Pago**: Líder en Latinoamérica, pagos QR, link de pago, checkout Pro
- **Square**: Soluciones POS + online, procesamiento integrado con hardware
- **Braintree**: Solución PayPal para pagos en apps y web, soporte para Venmo
- **Checkout.com**: PSP global con procesamiento propio y orquestación inteligente
- **Plaid**: Conectividad con cuentas bancarias para ACH y verificación
- **Razorpay**: Líder en India, pagos UPI, net banking, tarjetas
- **Pagar.me**: Procesadora brasileña con recusrencia y split de pagos
- **Yapily**: Plataforma de open banking para pagos desde cuenta bancaria
- **TrueLayer**: Proveedor PSD2 con APIs de pago y datos bancarios

## Hoja de ruta

1. **Principiante**: Integrar Stripe/PayPal en web o app. Entender flujo checkout: intención de pago → confirmación → webhook. Procesar pagos únicos y recurrentes.
2. **Intermedio**: Implementar 3D Secure, manejo de fallos y reembolsos. Tokenización de tarjetas. Conciliación de transacciones. Integrar múltiples métodos de pago. Cumplimiento PCI DSS básico (SAQ A).
3. **Avanzado**: Arquitectura de pagos multi-PSP con failover. Split payments para marketplaces (Stripe Connect). Optimización de autorización (sticky routing, smart retries). Detección de fraude con machine learning.
4. **Experto**: Diseñar orquestador de pagos propio. Implementar PSD2/SCA completo. Estrategias de "payment method ranking" basadas en éxito de autorización. Integración con redes cripto y DeFi. Cumplimiento PCI DSS Level 1.

## Relaciones con otros módulos

- [Ecommerce](../021-Ecommerce/) — Checkout, carrito, suscripciones y marketplaces
- [Banking](../023-Banking/) — Adquirencia, liquidación, cuentas merchant
- [Fintech](../024-Fintech/) — Pagos móviles, cripto, open banking, neobancos
- [Security](../009-Security/) — PCI DSS, cifrado, tokenización, prevención de fraude
- [APIs](../079-APIs/) — APIs REST idempotentes, webhooks, SDKs de pago
- [Compliance](../053-Compliance/) — Regulaciones financieras, KYC, AML
- [Databases](../003-Databases/) — Almacenamiento de transacciones y reconciliación

## Recursos recomendados

- [Stripe Docs](https://stripe.com/docs)
- [PayPal Developer](https://developer.paypal.com)
- [Adyen Docs](https://docs.adyen.com)
- [Mercado Pago Developers](https://www.mercadopago.com/developers)
- [PCI Security Standards Council](https://www.pcisecuritystandards.org)
- "Payment Systems in the Digital Age" — Cambridge University Press
- "Building Payment Gateways" — Stripe Press
- [Braintree Developer Docs](https://developer.paypal.com/braintree)
