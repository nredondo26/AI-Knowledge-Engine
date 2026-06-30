# 023-Banking: Banca

## Descripción ampliada del dominio

El sector bancario comprende las instituciones financieras que gestionan depósitos, préstamos, inversiones y servicios financieros para individuos y empresas. La banca moderna está experimentando una transformación digital impulsada por regulaciones, expectativas de clientes y competencia fintech. Este módulo cubre banca minorista (retail banking), banca corporativa, banca de inversión, sistemas bancarios centrales (core banking), pagos, canales digitales, cumplimiento regulatorio (Basilea III, IFRS 9), y tendencias como open banking (PSD2), banca como servicio (BaaS), banca embebida (embedded finance), y banca en tiempo real. La evolución bancaria: banca tradicional (oficinas físicas) → banca electrónica (1990s, cajeros automáticos, banca telefónica) → banca por Internet (2000s) → banca móvil (2010s) → banca digital nativa (2015+, Neobanks: Nubank, Revolut, Monzo, Chime) → Open Banking (PSD2, 2018+) → Embedded Banking (2020+, fintech as a service). Los sistemas core banking dominantes son Thought Machine (Vault), Mambu, Temenos, Finacle (Infosys), y Oracle FLEXCUBE. La tendencia actual es core banking en cloud, banca componible (microservicios) y AI para fraude, riesgo y personalización.

## Tabla de conceptos clave

| Concepto | Descripción | Tecnologías/Estándares |
|----------|-------------|----------------------|
| Core Banking | Sistema central que gestiona cuentas, transacciones, clientes | Thought Machine Vault, Mambu, Temenos, Finacle |
| Cuenta bancaria | Depósito a la vista (corriente, ahorro, plazo) | IBAN, CLABE, routing/account number |
| Payment Rails | Infraestructura de pagos (ACH, wire, SEPA, SWIFT) | ACH (Nacha), SWIFT, SEPA (EU), FedWire, RTP |
| NEOBank | Banco digital sin sucursales físicas | Nubank, Revolut, Monzo, Chime, N26, Starling |
| Open Banking | APIs para compartir datos bancarios con terceros con consentimiento | PSD2 (EU), OBIE (UK), CDR (Australia) |
| BaaS (Banking as a Service) | APIs de productos bancarios para empresas no financieras | Synapse, Unit, Stripe Treasury, Railsbank |
| Lending | Préstamos (personal, hipotecario, empresarial) | Credit scoring, underwriting, origination |
| KYC/AML | Know Your Customer / Anti Money Laundering | Identity verification, PEP screening, sanctions |
| Risk Management | Gestión de riesgo de crédito, mercado, operacional, liquidez | Basilea III, IV; RWA, LCR, NSFR, ICAAP |
| Digital Onboarding | Apertura de cuenta remota digital | eKYC, video identification, biometric liveness |
| Payment Initiation | Inicio de pago desde app bancaria | SEPA Credit Transfer, SEPA Instant, FedNow, PIX |
| Digital Wallet | Billetera digital vinculada a cuenta bancaria | Apple Pay, Google Pay, Samsung Pay, bank-specific |

## Tecnologías principales

| Sistema | Tipo | Arquitectura | Cloud | Región | Clientes |
|---------|------|-------------|-------|--------|----------|
| Thought Machine Vault | Core Banking | Cloud-native, microservicios | Cloud-only (GCP/AWS) | Global | Lloyds, SEB, Standard Chartered |
| Mambu | Core Banking | Cloud-native, SaaS | Cloud-only (AWS) | Global | N26, Santander (Openbank), ABN Amro |
| Temenos | Core Banking | Cloud-híbrida | Cloud + On-prem | Global | Más de 1500 bancos |
| Finacle (Infosys) | Core Banking | Cloud-híbrida | Cloud + On-prem | Global | 60+ países, top 50 bancos |
| Oracle FLEXCUBE | Core Banking | Cloud-híbrida | Cloud + On-prem | Global | Enterprise banking |
| SAP Banking | Core Banking | Cloud-híbrida | Cloud + On-prem | Global | Corporate banking, treasury |
| Q2 / nCino | Digital Banking | Cloud-native | Cloud-only | US | Regional banks, community banks |
| Fiserv / FIS | Core + Digital | Cloud-híbrida | Cloud + On-prem | US | Grandes procesadores legacy |
| Stashfin / Zeta | Neobanking Platform | Cloud-native | Cloud | India/Global | Neobanks, alt. credit |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos bancarios fundamentales: tipos de bancos (retail, corporate, investment, central bank), productos (cuentas de ahorro/corriente, tarjetas de crédito/débito, préstamos, hipotecas, inversiones). Sistema financiero: cómo funciona una transacción bancaria (clearing y settlement), intermediación financiera, creación de dinero. Cuentas: IBAN (International Bank Account Number), BIC/SWIFT, routing number, CLABE (México). Pagos: SEPA Credit Transfer (SCT), SEPA Instant, ACH (Nacha), FedWire, SWIFT MT/MX messages. Regulación: qué es KYC (identidad, verificación), AML, FATCA, CRS. Banca digital: qué es un neobank vs banco tradicional, core banking, canales (mobile app, online banking, ATM). Métricas bancarias: NIM (Net Interest Margin), ROE, ROA, cost-income ratio, NPL ratio.
   - Práctica: Abrir cuenta en un neobank (Nubank, Revolut, Chase). Explorar APIs de open banking (PSD2 sandbox). Leer balance sheet de un banco.
   - Lectura: "The Economics of Money, Banking, and Financial Markets" (Mishkin), "Bank 4.0" (King).

2. **Intermedio (3-8 meses)**: Core banking: arquitectura (ledger, general ledger, accounts, transactions, products, interest calculation), procesamiento batch (end-of-day, interest posting, fees). Payments: payment scheme (SEPA, ACH, SWIFT), payment types (credit transfer, direct debit, instant payment), payment flow (origination → clearing → settlement). Digital onboarding: eKYC (automated identity verification, document verification, biometric liveness check, PEP/Sanctions screening). Digital banking channels: mobile app (features: balance, transactions, transfers, payments, cards), online banking (admin: beneficiaries, settings, statements). APIs bancarias: PSD2 (AISP: account information, PISP: payment initiation), Open Banking UK standards, CDR Australia. Fraud detection: card fraud (counterfeit, CNP), account takeover, social engineering, phishing. Core banking integration: APIs vs batch files, ISO 20022 (financial messaging standard), MT/MX messages.
   - Proyecto: Integrar sandbox de PSD2 API (open banking). Simular flujo de pago SEPA. Diseñar proceso de onboarding digital con eKYC.
   - Certificación: PSD2/Open Banking Awareness, ACAMS (AML certification introductory), AWS Financial Services.

3. **Avanzado (8-14 meses)**: BaaS (Banking as a Service): Stripe Treasury (banking products), Synapse (deposit accounts, card issuing), Unit (banking platform), Railsbank (global banking). Core banking implementation: Thought Machine Vault (contracts, product lifecycle, accounts, postings, schedules, ledger), Mambu (design patterns for banking products, custom fields, deposits, lending, transactions). Lending: credit scoring (FICO, application score, behavioral score), loan origination (LOS), underwriting (affordability, credit risk), loan management (repayment schedule, amortization, delinquency, collections). Payments modernización: ISO 20022 adoption, real-time payments (FedNow, SEPA Instant, UPI, PIX), instant payments clearing. Risk management: Basilea III (capital adequacy, LCR, NSFR), stress testing, model risk management, IFRS 9 (expected credit loss, impairment). Financial crime: AML transaction monitoring (rule-based typologies, ML models), sanctions screening (OFAC, EU, UN lists), suspicious activity report (SAR) filing. Banking architecture: microservicios para banking (account management, transaction processing, payments, lending, fraud), event-driven (Kafka, domain events), CQRS, saga patterns. RegTech: regulatory reporting automation (COREP, FINREP, regulatory filings), compliance as code.
   - Proyecto: Implementar BaaS product (stripe treasury or synopsis sandbox). Core banking microservice for account management + transaction processing. AML transaction monitoring rules engine.
   - Certificación: CFA (Chartered Financial Analyst) Level I, FRM (Financial Risk Manager), AWS Financial Services Specialty.

4. **Experto (14+ meses)**: Banking transformation: migration from legacy core to cloud-native (mainframe → microservicios), strategy (Strangler Fig, strangler app, strangler data). Digital banking platform architecture: composable banking (MACH-inspired: microservicios, API-first, cloud-native), event-driven core, real-time ledger. Embedded finance: banking products integrados en plataformas no financieras (shopify balance, uber money, apple savings). Neobank building: diseño completo de neobank (core + payments + cards + lending + onboarding + fraud + compliance + regulatory/reporting). AI/ML in banking: credit scoring avanzado (ML-based, alternative data), fraud prevention (real-time ML scoring, graph neural networks), personalized banking (product recommendation, dynamic pricing, next best action), NLP para chatbots y compliance, generative AI para reportes y documentación. Quantum computing threats to banking: post-quantum cryptography for payments, quantum-safe key exchange. Digital currencies: CBDC (Central Bank Digital Currency: digital euro, digital dollar, e-CNY), stablecoins (USDC, USDT), deposit tokens. Sustainability banking: ESG scoring, green finance, carbon accounting.
   - Proyecto: Diseñar arquitectura de neobank (core + payments + lending + fraud + compliance). ML credit scoring model con alternative data. CBDC integration architecture.
   - Certificación: CFA Level II/III, PRM, FRM completa, Thought Machine Vault certification, Mambu Certified Architect.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | Core banking databases, ledger systems, IFRS 9 data |
| [005-Cloud](../005-Cloud/) | Cloud banking (core en cloud), BaaS infrastructure |
| [008-Networking](../008-Networking/) | SWIFT network, payment rails, low-latency trading |
| [009-Security](../009-Security/) | KYC/AML, fraud, PCI DSS, data protection (GDPR) |
| [010-Architecture](../010-Architecture/) | Core banking architecture, microservicios, event-driven |
| [022-PaymentGateways](../022-PaymentGateways/) | Adquirencia, tarjetas, payment processing |
| [024-Fintech](../024-Fintech/) | Fintech como catalizador de innovación bancaria |
| [031-AI](../031-AI/) | AI en fraud, credit scoring, personalized banking |

## Recursos recomendados

- **Estándares y regulaciones**: Basilea III/IV (bis.org), ISO 20022 (iso20022.org), PSD2 (eba.europa.eu), PCI DSS, SWIFT standards.
- **Plataformas core**: Thought Machine Vault (thoughtmachine.net), Mambu (mambu.com), Temenos (temenos.com), Finacle (edgeverve.com).
- **BaaS/Embedded**: Stripe Treasury (stripe.com/treasury), Synapse (synapsefi.com), Unit (unit.co), Railsbank (railsbank.com).
- **Libros**: "Bank 4.0" (King), "The Future of Finance" (McMillan), "Digital Bank" (Skinner), "The Paytech Book" (The Lenz).
- **Cursos**: Coursera "Financial Markets" (Yale), "Banking and Financial Institutions" (U of Illinois), AWS Financial Services.
- **Comunidad**: Fintech Nexus, The Financial Brand, Finextra, Reddit r/fintech, r/banking.

## Notas adicionales

La banca es una industria altamente regulada con barreras de entrada significativas (licencias bancarias, capital regulatorio). Los neobanks han demostrado que es posible construir banca moderna sobre core banking cloud-native (Thought Machine, Mambu). La tendencia de embedded banking (BaaS) permite a empresas no bancarias ofrecer productos financieros. Open Banking (PSD2) ha democratizado el acceso a datos bancarios. ISO 20022 es el estándar de mensajería financiera que unifica pagos globales. La inteligencia artificial está transformando la gestión de riesgo, prevención de fraude y experiencia del cliente.
