# 022-PaymentGateways: Pasarelas de Pago

## Descripción ampliada del dominio

Las pasarelas de pago (payment gateways) son servicios tecnológicos que autorizan y procesan pagos electrónicos en transacciones comerciales, actuando como intermediarias entre el comerciante, el banco emisor y el banco adquirente. Este módulo cubre los principales proveedores (Stripe, Adyen, PayPal, Square, Mercado Pago), arquitectura de pagos, tokenización, cumplimiento PCI DSS, 3D Secure, prevención de fraude, pagos recurrentes, wallets digitales y pagos internacionales. El mercado global de pagos digitales superó $9T en 2024 con crecimiento anual de ~15%. La evolución de pagos: efectivo → cheques → tarjetas (décadas 1950-90s) → e-commerce payments (1990s, CyberSource, VeriSign) → pasarelas modernas (Stripe fundada 2010, Adyen 2006) → pagos embedidos/fintech-as-a-service (2020+, Stripe Connect, Adyen for Platforms) → pagos móviles y wallets (Apple Pay, Google Pay, PayPal) → BNPL (Buy Now Pay Later: Klarna, Afterpay, Affirm, 2020+) → Real-Time Payments (RTP, FedNow, Pix, UPI, 2020+). Las tendencias actuales son: open banking payments, pagos instantáneos con liquidación en tiempo real, Stablecoins y cripto pagos, IA para prevención de fraude, Embedded Finance (pagos integrados en SaaS no-financieros).

## Tabla de conceptos clave

| Concepto | Descripción | Estándares/Tecnologías |
|----------|-------------|----------------------|
| Payment Gateway | Servicio que autoriza y procesa pagos | Stripe, Adyen, PayPal, Square, Mercado Pago |
| Merchant Account | Cuenta bancaria comercial para recibir pagos | Acquiring bank, payment facilitator |
| Acquiring | Banco que procesa pagos en nombre del comerciante | Adquiriente, procesador, ISO |
| Issuing | Banco que emite la tarjeta al consumidor | Bank issuer, tarjeta (Visa, MC, Amex) |
| Tokenization | Reemplazo de datos sensibles de tarjeta por token | PCI DSS, Stripe Tokens, Apple Pay tokens |
| 3D Secure | Autenticación adicional del titular de la tarjeta | EMV 3DS (Protocol 2.0+), SCA (PSD2) |
| PCI DSS | Estándar de seguridad para datos de tarjetas | PCI Security Standards Council, SAQ, QSA |
| Recurring Payment | Pagos periódicos (subscriptiones, suscripciones) | Stripe Subscriptions, Recurly, Chargebee |
| Payment Orchestration | Plataforma que gestiona múltiples gateways e integraciones | Spreedly, Finix, Zooz, Rebilly |
| BNPL (Buy Now Pay Later) | Pago diferido en cuotas sin intereses | Klarna, Afterpay, Affirm, Mercado Pago |
| PSP (Payment Service Provider) | Proveedor que integra gateway + acquirer | Stripe, Square, Adyen |
| Instant Payments | Pagos en tiempo real 24/7 | FedNow (US), SEPA Instant (EU), Pix (BR), UPI (IN) |

## Tecnologías principales

| Gateway | Región principal | Modelo de precios | API | Pagos recurrentes | Pagos presenciales | Multimoneda | Ideal para |
|---------|-----------------|-------------------|-----|-------------------|-------------------|-------------|------------|
| Stripe | Global | 2.9% + $0.30 | REST, GraphQL | Sí (Subscriptions) | Sí (Terminal) | 135+ monedas | Startups, SaaS, e-commerce, platformas |
| Adyen | Global | Interchange+ | REST, Webhooks | Sí | Sí (POS, Android) | 150+ monedas | Enterprise, multi-channel |
| PayPal | Global | 2.99% + $0.49 | REST, PayPal Checkout | Sí | No | 25+ monedas | Marketplaces, SMB, e-commerce |
| Square | US/UK/CA | 2.6% + $0.10 | REST | Sí | Sí (Hardware POS) | USD (limited) | Retail, SMB, presencial |
| Mercado Pago | Latinoamérica | Variable | REST | Sí | Sí (POS, QR, Point) | 8 monedas (LATAM) | LATAM markets, e-commerce |
| Braintree (PayPal) | Global | 2.59% + $0.49 | REST, SDK | Sí | No | 130+ monedas | E-commerce, marketplaces |
| Worldpay/FIS | Global | Interchange+ | API Legacy/Modern | Sí | Sí | Global | Enterprise, high volume |
| Checkout.com | Global | Interchange+ | REST | Sí | No | 150+ monedas | Enterprise, digital |
| Klarna | Europe/US | Merchant fee | API | No (BNPL) | No | EUR, USD, GBP | BNPL, consumer finance |
| Razorpay | India | 2% + $0.30 | REST, Webhooks | Sí | No | INR + 100+ | India market |

## Hoja de ruta detallada

1. **Principiante (0-2 meses)**: Conceptos fundamentales de pagos online: cómo funciona una transacción con tarjeta (autorización → captura → liquidación → settlement), actores (cardholder → merchant → acquirer → card network → issuer). Payment gateway vs merchant account vs payment facilitator (Stripe, Square son facilitadores). Tokenization: cómo Stripe.js genera tokens sin que el merchant vea datos de tarjeta. PCI DSS compliance básico: SAQ A (más simple, solo URL redirect) vs SAQ D (más complejo). Sandbox testing: Stripe test mode, tarjetas de prueba (success, decline, authentication_required). Integración básica: Stripe Elements (Simple Checkout, embedido), Stripe Checkout (página hosted), redirect to payment page.
   - Práctica: Integrar Stripe Checkout en app web. Probar pagos exitosos, declinados, 3DS en sandbox. Explorar Stripe Dashboard.
   - Lectura: Stripe docs (stripe.com/docs), "Payments 101" (Stripe), PCI DSS Quick Reference Guide.

2. **Intermedio (2-6 meses)**: Stripe avanzado: Stripe.js + Elements (card element, ideal, sepa debit, sofort, bancontact), creación de PaymentIntents, confirmación cliente/server, manejo de webhooks (payment_intent.succeeded, charge.refunded). Subscripciones (Stripe Subscriptions): productos, precios, planes, intervalos, trial period, proration, cancelación, upgrade/downgrade, invoices. Clientes y Customer portal. Refunds (full/partial), disputes (chargebacks), evidence submission. 3D Secure (EMV 3DS): cómo funciona (authentication flow), cuando es obligatorio (SCA en EU, PSD2), handling 3DS con Stripe (payment_intent.uses_sepa_debit). International payments: multi-currency pricing, dynamic currency conversion, settlement currency. Tax handling: Stripe Tax (automatic tax calculation, VAT/GST). Payouts a merchants (Stripe Connect). Multi-gateway fallback: switch a gateway alternativo si falla primary. Webhook security: webhook signing secrets, idempotency keys, retry logic, replays.
   - Proyecto: Integrar Stripe Subscriptions con planes, trial, upgrade/downgrade. Stripe Connect for marketplace. PSD2 SCA compliance flow.
   - Certificación: Stripe Certified Professional Developer.

3. **Avanzado (6-12 meses)**: Adyen: plataforma de pagos enterprise. API: checkout, modifications, recurring, payout, reports. Webhooks (notification webhooks). Payment methods: cards, wallets (Apple Pay, Google Pay, PayPal, WeChat Pay, Alipay, Klarna), local methods (iDEAL, SEPA, P24, Boleto, OXXO). Authentication: 3DS2 con Adyen (device fingerprint, challenge shopper). Recurring: token-based, shopper reference, recurring processing model. Risk management: Adyen Risk (machine learning, rules, thresholds), manual review. Payment Orchestration: Spreedly, Finix, Zooz — gestionar multi-gateway, failover, routing rules. BNPL integration: Klarna (Authorization, capture, refund), Afterpay/Clearpay. Enterprise payment architecture: multi-PSP (PSP redundancy, latency-based routing, country-specific routing), payment microservicios, idempotency, transactional outbox pattern. Payment analytics: reconciliation (payment vs settlement, fees calculation), P&L por método de pago, chargeback rate, conversion funnel optimization. Fraud prevention: machine learning models (Stripe Radar, Adyen Risk, Forter, Sift), rules engine, manual review, device fingerprint, velocity checks, IP analysis.
   - Proyecto: Implementar Adyen Checkout + 3DS2 + risk rules. Payment orchestration con multiple gateways + failover. Fraud detection pipeline with ML.
   - Certificación: Adyen Certification (Adyen Technical Assessment).

4. **Experto (12+ meses)**: Real-time payments: FedNow (US), SEPA Instant (EU), Pix (Brazil), UPI (India) — arquitectura, APIs, settlement, reconciliation. Open banking payments: PSD2 compliance, AISP/PISP, payment initiation services (PIS), account information services (AIS), TPP (Third Party Provider). Digital wallets: Apple Pay (PKPaymentToken, merchant identifier, Apple Pay on the Web), Google Pay (GatewayTokenizationSpecification, Google Pay API for Web). Stablecoins y crypto payments: Circle USDC, Coinbase Commerce, BitPay — blockchain settlement, gas fees, conversion, volatility risk. Embedded Finance: Banking-as-a-Service (Stripe Treasury, Synapse, Unit, Plaid), payment facilitation sub-merchant onboarding, KYC/KYB automation. Payment security: HSM (Hardware Security Module), key management, encryption at rest/transit, PCI DSS v4.0 (SAQ A vs D vs P2PE), tokenization vault, point-to-point encryption (P2PE). Payment scalability: high availability (active-active multi-region), idempotency keys, async processing (Kafka, queues), SLA monitoring. Payment compliance: KYB/KYC, AML screening, OFAC sanctions, PSD2 SCA exemptions, GDPR for payment data. Payment data analytics: customer payment preferences, payment conversion optimization, revenue impact.
   - Proyecto: Real-time payments integration (Pix, FedNow, SEPA Instant). Open banking PIS implementation. Embedded finance platform with Stripe Treasury.
   - Certificación: PCI Professional (PCIP), Certified Payments Professional (CPP), ITSP (International Token Standard).

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | Almacenamiento de transacciones, customer data, tokens |
| [005-Cloud](../005-Cloud/) | PCI DSS en cloud, cloud infrastructure for payments |
| [008-Networking](../008-Networking/) | Latencia de pagos, CDN para checkout, WAF |
| [009-Security](../009-Security/) | PCI DSS, tokenization, fraud detection, 3DS |
| [010-Architecture](../010-Architecture/) | Payment orchestration, idempotency, transactional outbox |
| [021-Ecommerce](../021-Ecommerce/) | Payment processing en e-commerce |
| [023-Banking](../023-Banking/) | Acquiring, issuing, settlements, bank integration |
| [024-Fintech](../024-Fintech/) | Pagos como core fintech, embedded finance |
| [025-Mobile](../025-Mobile/) | Mobile payments (Apple Pay, Google Pay, in-app purchases) |

## Recursos recomendados

- **Referencias técnicas**: Stripe Docs (stripe.com/docs), Adyen Docs (docs.adyen.com), PayPal Developer (developer.paypal.com).
- **Estándares**: PCI DSS v4.0 (pcisecuritystandards.org), EMV 3DS (emvco.com), PSD2 (EBA), SEPA (European Payments Council).
- **Libros**: "Payments Systems in the U.S." (Carol Coye Benson), "The Payment Gateway Code" (Joyal), "Fintech: The New DNA of Financial Services" (Gupta, Tham).
- **Cursos**: Stripe Academy, Adyen Learning, "Payments 101" (Stripe), "Digital Payments" (Coursera).
- **Comunidad**: Stripe Community Forum, Reddit r/stripe, r/adpen, The Payments Podcast (Glenbrook), Fintech Brain Food newsletter.

## Notas adicionales

Stripe es la mejor plataforma para empezar: API excelente, documentación clara, sandbox, pricing transparente. Para escala enterprise, Adyen ofrece mejor pricing (interchange+) y cobertura global. Para Latinoamérica, Mercado Pago es indispensable. PCI DSS compliance es obligatorio: Stripe/Adyen reducen el alcance (SAQ A). 3D Secure es requerido en Europa (PSD2) para pagos sin autenticación. La tokenización es la mejor práctica para seguridad. Las tendencias: open banking, pagos instantáneos y embedded finance están redefiniendo la industria.
