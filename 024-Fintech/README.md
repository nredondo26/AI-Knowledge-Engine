# 024-Fintech: Tecnología Financiera

## Descripción ampliada del dominio

Fintech (Financial Technology) se refiere a la innovación tecnológica en servicios financieros, desde startups disruptivas hasta grandes instituciones que adoptan tecnología para mejorar productos financieros. Este módulo cubre pagos digitales, préstamos (lending), wealthtech (inversión), insurtech (seguros), regtech (cumplimiento regulatorio), criptoactivos y blockchain, finanzas embebidas (embedded finance), open banking, y las tecnologías subyacentes (AI/ML, APIs, cloud, blockchain). La inversión global en fintech alcanzó ~$150B en 2024. Las fintechs unicornio más valiosas incluyen Stripe ($65B), Revolut ($40B+), Nubank ($40B+), Ripple, Digital Currency Group, y Chime. La evolución fintech: Fintech 1.0 (2000-2010, pagos online: PayPal, primera ola) → Fintech 2.0 (2010-2015, neobanks: Nubank, Revolut, Monzo; lending: Lending Club, SoFi) → Fintech 3.0 (2015-2020, embedded finance, open banking, insurtech, wealthtech) → Fintech 4.0 (2020+, DeFi, Web3 fintech, AI-native finance, embedded everything). Los subsectores fintech más activos son pagos (mayor inversión), lending, wealthtech, insurtech, regtech, y open banking platforms.

## Tabla de conceptos clave

| Subsector | Descripción | Empresas representativas |
|-----------|-------------|--------------------------|
| Pagos digitales | Procesamiento de pagos online, móviles, P2P, transfronterizos | Stripe, Adyen, PayPal, Square, Mercado Pago, Revolut |
| Lending (Préstamos) | Plataformas de préstamos P2P, consumer lending, BNPL, mortgage | Lending Club, SoFi, Klarna, Affirm, Upstart, Kueski |
| Wealthtech | Gestión de inversiones automatizada (robo-advisors), trading, wealth mgmt | Betterment, Wealthfront, Robinhood, eToro, Trade Republic |
| Insurtech | Seguros digitales: distribución, suscripción, claims | Lemonade, Root Insurance, Oscar Health, Hippo |
| Regtech | Automatización de cumplimiento regulatorio, KYC, AML, reporting | ComplyAdvantage, Chainalysis, Onfido, Jumio, Trulioo |
| Open Banking | APIs para compartir datos financieros con terceros con consentimiento | Plaid, Yodlee, Tink, TrueLayer, Salt Edge |
| BaaS/Embedded Finance | Servicios financieros integrados en plataformas no financieras | Stripe Treasury, Unit, Synapse, Railsbank, Solarisbank |
| Cripto/Blockchain | Activos digitales, DeFi, stablecoins, pagos cripto | Coinbase, Circle, Ripple, Chainlink, Fireblocks |
| Neobank | Banco digital sin sucursales físicas | Nubank, Revolut, Chime, Monzo, N26, Starling |
| Digital Identity | Verificación de identidad digital, KYC, biometría | Onfido, Jumio, Veriff, ID.me, iProov |

## Tecnologías principales

| Categoría | Tecnologías/Core | APIs/SDK | Regulación | Cloud |
|-----------|------------------|----------|------------|-------|
| Pagos | Stripe, Adyen, PayPal, Spreedly | REST, SDKs, Webhooks | PCI DSS, PSD2, SCA | Stripe Cloud, Adyen |
| Lending | Credit scoring (FICO, Vantage), underwriting ML, LOS | Loan origination APIs | Truth in Lending (TILA), ECOA | AWS (compliance) |
| Wealthtech | Trading APIs (Alpaca, Interactive Brokers), robo-advisor (Wealthfront) | Plaid, Finicity (AIS) | SEC, FINRA, MiFID II | AWS, GCP |
| Insurtech | Insurance core systems (Guidewire, Duck Creek) | Quote/bind APIs | State insurance regulators | Cloud-native |
| Regtech | KYC (Onfido, Jumio), AML (ComplyAdvantage), sanctions | Identity verification APIs | AML 5th Directive, FATF | Cloud (GCP, AWS) |
| Open Banking | PSD2 AISP/PISP, OBIE standards | Plaid, Tink, TrueLayer APIs | PSD2 (EU), OBIE (UK), CDR (AU) | Cloud |
| BaaS | Unit, Synapse, Stripe Treasury | Banking APIs, ledger APIs | Banking license (partner bank) | Cloud-native |
| Crypto | Ethereum, Solana, Stellar, Fireblocks, Chainalysis | RPC, REST, gRPC | MiCA (EU), SEC guidance | Cloud + self-hosted |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fintech: qué es fintech, subsectores, diferencias con banca tradicional. Modelos de negocio: B2C (neobanks, trading), B2B (BaaS, payments infrastructure), B2B2C (embedded finance). Regulación: PSD2 (Payment Services Directive 2), KYC/AML, GDPR, PCI DSS. APIs financieras: qué es open banking, AISP (Account Information Service Provider), PISP (Payment Initiation Service Provider). Pagos vs lending vs wealthtech. Casos de estudio: cómo funciona Stripe (pagos), Nubank (neobank), Coinbase (crypto). Juego de arena (sandbox) regulatorio: pruebas de productos fintech en entornos controlados. Fintech ecosystems: UK, US, Brazil, India, China, Mexico.
   - Práctica: Crear cuenta sandbox en Stripe, Plaid (Link). Explorar API de acceso a cuentas (Plaid Link/Stripe). Leer whitepaper de stablecoin (USDC).
   - Lectura: "The Fintech Book" (Chishti, Barberis), "Bank 4.0" (King), Finextra blog.

2. **Intermedio (3-8 meses)**: Payments: flujo completo de transacción (merchant → gateway → acquirer → network → issuer), tokenización, 3DS, dispute/chargeback, multicurrency, cross-border fees optimization. Lending: credit scoring fundamentals (FICO, behavior score, bureau data, alternative data), loan origination, underwriting (decision engine, rules, ML models), amortization schedules, interest calculation (simple, compound, flat, APR), delinquency and collections. Open Banking integrations: Plaid (Link token, public token, access token, transactions, auth, identity, assets), Tink (account info, payment initiation, transaction data enrichment). Wealthtech: portfolio theory basics (Markowitz, CAPM), robo-advisor algorithms (Modern Portfolio Theory, tax-loss harvesting), fractional trading. BaaS platforms: Unit (deposit accounts, cards, payments, lending), Synapse (account issuance, card issuing, ACH/wire payments, KYC/KYB). Embedded finance: Stripe Treasury (yield-bearing accounts, debit cards), Shopify Balance, Uber Money. Crypto basics: blockchain (distributed ledger, consensus: PoW, PoS, DPoS), Bitcoin vs Ethereum, stablecoins (USDC, USDT), DeFi (lending, swaps, yield farming), smart contracts. Regulatory sandbox: how to test fintech products under regulatory supervision (FCA sandbox, CFT sandbox).
   - Proyecto: Integrar Plaid Link + Transaction Data API. Construir simple credit scoring ML model. Integrar Unit/Stripe Treasury for embedded banking.
   - Certificación: Fintech Certification (Coursera/Wharton), Plaid Certified Developer, Stripe Certified Developer.

3. **Avanzado (8-14 meses)**: Lending analytics: loan portfolio performance (NPL, delinquency vintage curves, recovery rates), IFRS 9/CECL impairment modeling (probability of default, loss given default, exposure at default), securitization basics. AI/ML en fintech: credit scoring avanzado (XGBoost, LightGBM, neural networks, alternative data: telco, utility, psychometric), fraud detection (graph neural networks, real-time scoring, anomaly detection, rules + ML), NLP for financial documents (loan agreements, regulatory filings), GenAI for personalized financial advice, robo-advisor algorithms with RL. Blockchain/DeFi: DeFi protocols (Uniswap, Aave, Compound, MakerDAO), yield optimization, liquidity pools, AMM (Automated Market Maker), lending protocols, stablecoins mechanisms (collateralized: DAI, algorithmic: UST collapsed). Digital identity: decentralized identity (DID, Verifiable Credentials), self-sovereign identity (SSI), zkKYC (zero-knowledge KYC). Real-time payments infrastructure: FedNow, UPI, Pix — API integration, settlement, reconciliation, fraud prevention. Compliance automation: AML transaction monitoring (rule-based typologies + ML models), sanctions screening (OFAC, EU, UN), RegTech reporting (COREP, FINREP, suspicious activity reports). Fintech scalability: payment processing at scale (horizontal scaling, Kafka event streaming, idempotency keys), banking core microservicios, multi-region active-active.
   - Proyecto: Lending ML model with alternative data + explainability (SHAP). DeFi lending pool simulation. Real-time payments integration (Pix/FedNow sandbox).
   - Certificación: FRM (Financial Risk Manager), CFA Level I, AWS Financial Services Specialty, Certified Cryptocurrency Expert.

4. **Experto (12+ meses)**: Fintech architecture at enterprise scale: payment orchestration (multi-PSP), banking core (Thought Machine, Mambu), lending platform (LOS + decision engine + ML), ledger (double-entry accounting as code). AI-native fintech: LLMs for financial services (regulatory compliance, document processing, customer service, financial advice), multi-agent AI for financial operations (agent-based treasury management, automated hedging, portfolio rebalancing). GenAI for RegTech: AI-based AML/CFT (pattern detection, narrative generation for SARs), regulatory filing generation, automated compliance monitoring. Embedded finance ecosystem: fintech-as-a-service platform (banking + payments + lending + cards + KYC/KYB in single API). DeFi and TradFi convergence: institutional DeFi (regulated DeFi), tokenized real-world assets (RWA: treasuries, real estate, private credit), stablecoin payments integration. Quantum computing in finance: quantum risk modeling (portfolio optimization, Monte Carlo simulation), quantum-safe cryptography for payments. Financial inclusion fintech: Brazil's Pix (instant payments free for individuals), India's UPI, mobile money (M-Pesa Africa), micro-lending in emerging markets. Fintech M&A and regulation: MiCA (EU crypto regulation), stablecoin regulation, digital asset custody.
   - Proyecto: AI-powered embedded finance platform. DeFi lending protocol with KYC/AML compliance. Enterprise fintech architecture (core + lending + payments + fraud).
   - Certificación: CFA Level II/III, CFT (Certified Fintech), MIT Fintech Certificate, Thought Machine Vault certification.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [003-Databases](../003-Databases/) | Ledger, transaction data, analytics databases |
| [005-Cloud](../005-Cloud/) | Cloud infrastructure for fintech (compliance, multi-region) |
| [008-Networking](../008-Networking/) | Low-latency payments, SWIFT, payment rails |
| [009-Security](../009-Security/) | KYC/AML, PCI DSS, fraud detection, crypto security |
| [010-Architecture](../010-Architecture/) | Fintech architecture (microservicios, event-driven, CQRS) |
| [022-PaymentGateways](../022-PaymentGateways/) | Pagos como core del ecosistema fintech |
| [023-Banking](../023-Banking/) | Core banking, lending, deposits, embedded banking |
| [031-AI](../031-AI/) | AI/ML para credit scoring, fraud, personalization |
| [032-MachineLearning](../032-MachineLearning/) | ML models para lending, fraud, risk |

## Recursos recomendados

- **Libros**: "The Fintech Book" (Chishti, Barberis), "Bank 4.0" (King), "The Future of Finance" (McMillan), "The PAYTECH Book" (Lenz), "DeFi and the Future of Finance" (Harvey, Ramachandran, Santoro).
- **Cursos**: Coursera "Fintech" (Wharton, Yale), MIT "Fintech" (online), "Blockchain and Money" (MIT), "DeFi" (Duke).
- **Plataformas**: Stripe (pagos), Plaid (open banking), Unit (BaaS), Thought Machine (core), Coinbase/Anchorage (crypto).
- **Regulación**: PSD2 (EU), OBIE (UK), Open Banking BR (Brazil), CDR (Australia), MiCA (crypto EU), FATF guidelines.
- **Comunidad**: Fintech Nexus, LendIt Fintech, Money20/20, Web Summit fintech track, Reddit r/fintech, Fintech Business Weekly.

## Notas adicionales

Fintech es uno de los sectores más dinámicos de la tecnología. La regulación es clave: conocer el marco regulatorio local es esencial. La tendencia es "embedded everything": fintech como servicio integrado en plataformas no financieras. AI y automatización están transformando el crédito, inversiones y cumplimiento. Open Banking y pagos instantáneos (Pix, UPI, FedNow) están redefiniendo los pagos globales. DeFi y crypto son áreas de alto riesgo y alta recompensa. La inclusión financiera sigue siendo un motor importante en mercados emergentes.
