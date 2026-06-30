#!/bin/bash
# AI Knowledge Engine - Expansion Tool
# Crea subdirectorios por tecnología dentro de cada módulo
# Uso: ./expand.sh <module>   - Expande un módulo específico
#       ./expand.sh all       - Expande todos los módulos

ENGINE_DIR="$(cd "$(dirname "$0")" && pwd)"
ACTION="${1:-status}"

case $ACTION in
    status)
        echo "Módulos disponibles para expandir:"
        echo "  languages     - 001-Languages"
        echo "  frameworks    - 002-Frameworks"
        echo "  databases     - 003-Databases"
        echo "  os            - 004-OperatingSystems"
        echo "  cloud         - 005-Cloud"
        echo "  containers    - 006-Containers"
        echo "  orchestration - 007-Orchestration"
        echo "  security      - 009-Security"
        echo "  architecture  - 010-Architecture"
        echo "  patterns      - 011-DesignPatterns"
        echo "  testing       - 012-Testing"
        echo "  cicd          - 014-CICD"
        echo "  mobile        - 025-Mobile"
        echo "  llm           - 034-LLM"
        echo "  rag           - 035-RAG"
        echo "  mcp           - 036-MCP"
        echo "  agents        - 037-AgenticAI"
        echo "  vectordbs     - 038-VectorDatabases"
        echo "  prompteng     - 039-PromptEngineering"
        echo "  observability - 097-Observability"
        echo ""
        echo "Uso: ./expand.sh <modulo>"
        echo "     ./expand.sh all"
        ;;
    languages)
        mkdir -p "$ENGINE_DIR/001-Languages"/{Python,JavaScript,TypeScript,Java,Kotlin,Go,Rust,CPlusPlus,CSharp,PHP,Ruby,Swift,Scala,Dart,R,Shell,Bash,PowerShell}
        for d in "$ENGINE_DIR/001-Languages"/*/; do
            name=$(basename "$d")
            [ -f "$d/README.md" ] && continue
            cat > "$d/README.md" << EOF
# $name

## Descripción
Lenguaje de programación $name.

## Conceptos clave
- Sintaxis básica
- Tipos de datos
- Estructuras de control
- POO / Funcional
- Concurrencia
- Ecosistema y paquetes

## Hoja de ruta
- Principiante: Sintaxis básica, tipos, estructuras
- Intermedio: POO, manejo de errores, librerías estándar
- Avanzado: Patrones, concurrencia, performance
- Experto: Meta-programación, compiladores, internals

## Relaciones
- [Frameworks](../../002-Frameworks/README.md)
- [Web](../../026-Web/README.md)
- [Mobile](../../025-Mobile/README.md)
EOF
        done
        echo "✅ 001-Languages expandido"
        ;;
    databases)
        mkdir -p "$ENGINE_DIR/003-Databases"/{PostgreSQL,MySQL,MariaDB,SQLite,SQLServer,Oracle,MongoDB,Redis,Elasticsearch,Cassandra,DynamoDB,Firestore,Neo4j,InfluxDB,ClickHouse}
        echo "✅ 003-Databases expandido"
        ;;
    cloud)
        mkdir -p "$ENGINE_DIR/005-Cloud"/{AWS,Azure,GCP,Heroku,Vercel,Netlify,Cloudflare,DigitalOcean,Linode}
        for d in AWS Azure GCP; do
            dir="$ENGINE_DIR/005-Cloud/$d"
            [ -f "$dir/README.md" ] && continue
            cat > "$dir/README.md" << EOF
# $d

## Servicios principales
- Compute
- Storage
- Database
- Networking
- Security
- AI/ML
- Serverless

## Conceptos clave
- Regiones y zonas
- IAM
- VPC
- Escalabilidad
- Cost optimization

## Certificaciones
- Foundational
- Associate
- Professional
- Specialty
EOF
        done
        echo "✅ 005-Cloud expandido"
        ;;
    security)
        mkdir -p "$ENGINE_DIR/009-Security"/{OWASP,Authentication,Authorization,Cryptography,NetworkSecurity,CloudSecurity,ZeroTrust,SIEM,IncidentResponse,AppSec,DevSecOps}
        echo "✅ 009-Security expandido"
        ;;
    architecture)
        mkdir -p "$ENGINE_DIR/010-Architecture"/{Microservices,Monolith,CleanArchitecture,Hexagonal,CQRS,EventSourcing,Serverless,Solid,DDD,SOA}
        echo "✅ 010-Architecture expandido"
        ;;
    llm)
        mkdir -p "$ENGINE_DIR/034-LLM"/{GPT,Claude,Gemini,LLaMA,Mistral,Phi,FineTuning,RLHF,Quantization,PromptInjection,Security,Routing,Caching,Evaluation,Benchmarks}
        for d in GPT Claude Gemini LLaMA Mistral; do
            dir="$ENGINE_DIR/034-LLM/$d"
            [ -f "$dir/README.md" ] && continue
            cat > "$dir/README.md" << EOF
# $d

## Descripción
Modelo de lenguaje $d.

## Capacidades clave
- Generación de texto
- Razonamiento
- Code generation
- Contexto y ventana

## Versiones
- Listado de versiones y mejoras

## Buenas prácticas
- Prompting
- Rate limits
- Costos
- Safety

## Relaciones
- [PromptEngineering](../../039-PromptEngineering/README.md)
- [RAG](../../035-RAG/README.md)
- [AgenticAI](../../037-AgenticAI/README.md)
EOF
        done
        echo "✅ 034-LLM expandido"
        ;;
    mcp)
        mkdir -p "$ENGINE_DIR/036-MCP"/{Servers,Clients,Tools,Resources,Prompts,Transport,Security,BestPractices,Examples}
        echo "✅ 036-MCP expandido"
        ;;
    agents)
        mkdir -p "$ENGINE_DIR/037-AgenticAI"/{LangChain,CrewAI,AutoGPT,OpenAIAssistants,ClaudeAgents,MultiAgent,Planning,Memory,ToolUse,Evaluation}
        echo "✅ 037-AgenticAI expandido"
        ;;
    vectordbs)
        mkdir -p "$ENGINE_DIR/038-VectorDatabases"/{Pinecone,Weaviate,Chroma,Qdrant,Milvus,MongoDBAtlas,Pgvector,Elasticsearch}
        echo "✅ 038-VectorDatabases expandido"
        ;;
    prompteng)
        mkdir -p "$ENGINE_DIR/039-PromptEngineering"/{Techniques,FewShot,ChainOfThought,TreeOfThought,SystemPrompts,Safety,Optimization,Evaluation}
        echo "✅ 039-PromptEngineering expandido"
        ;;
    observability)
        mkdir -p "$ENGINE_DIR/097-Observability"/{Prometheus,Grafana,Datadog,OpenTelemetry,ELK,Loki,Tempo,Jaeger,Sentry,NewRelic}
        echo "✅ 097-Observability expandido"
        ;;
    frameworks)
        mkdir -p "$ENGINE_DIR/002-Frameworks"/{React,Vue,Angular,Svelte,NextJS,Nuxt,Django,Flask,FastAPI,Spring,Laravel,Express,NestJS,RubyOnRails,ASPNet}
        echo "✅ 002-Frameworks expandido"
        ;;
    testing)
        mkdir -p "$ENGINE_DIR/012-Testing"/{UnitTesting,IntegrationTesting,E2E,PerformanceTesting,SecurityTesting,TDD,BDD,Mocking,Fixtures,Coverage}
        echo "✅ 012-Testing expandido"
        ;;
    cicd)
        mkdir -p "$ENGINE_DIR/014-CICD"/{GitHubActions,Jenkins,GitLabCI,ArgoCD,CircleCI,TravisCI,BitbucketPipelines,ActionsRunner}
        echo "✅ 014-CICD expandido"
        ;;
    mobile)
        mkdir -p "$ENGINE_DIR/025-Mobile"/{iOS,Android,Flutter,ReactNative,Xamarin,Ionic,KotlinMultiplatform}
        echo "✅ 025-Mobile expandido"
        ;;
    rag)
        mkdir -p "$ENGINE_DIR/035-RAG"/{Chunking,Embedding,Retrieval,Reranking,HybridSearch,GraphRAG,Evaluation,Pipelines,AdvancedRAG}
        echo "✅ 035-RAG expandido"
        ;;
    os)
        mkdir -p "$ENGINE_DIR/004-OperatingSystems"/{Linux,Windows,macOS,Unix,BSD,Android,iOS,Kernel,Drivers,FileSystems}
        echo "✅ 004-OperatingSystems expandido"
        ;;
    containers)
        mkdir -p "$ENGINE_DIR/006-Containers"/{Docker,Podman,containerd,BuildKit,Registry,Compose,Networking,Storage,Security}
        echo "✅ 006-Containers expandido"
        ;;
    orchestration)
        mkdir -p "$ENGINE_DIR/007-Orchestration"/{Kubernetes,Nomad,DockerSwarm,ECS,EKS,AKS,GKE,OpenShift,ServiceMesh}
        echo "✅ 007-Orchestration expandido"
        ;;
    patterns)
        mkdir -p "$ENGINE_DIR/011-DesignPatterns"/{Creational,Structural,Behavioral,Concurrency,Architectural,Integration,CloudPatterns}
        echo "✅ 011-DesignPatterns expandido"
        ;;
    devops)
        mkdir -p "$ENGINE_DIR/013-DevOps"/{GitOps,SRE,IaC,Monitoring,IncidentManagement,ChaosEngineering,PlatformEngineering}
        echo "✅ 013-DevOps expandido"
        ;;
    automation)
        mkdir -p "$ENGINE_DIR/015-Automation"/{Ansible,Puppet,Chef,SaltStack,Terraform,Pulumi,CloudFormation,Scripting}
        echo "✅ 015-Automation expandido"
        ;;
    ml)
        mkdir -p "$ENGINE_DIR/032-MachineLearning"/{Supervised,Unsupervised,ReinforcementLearning,FeatureEngineering,ModelSelection,ScikitLearn,XGBoost,MLflow}
        echo "✅ 032-MachineLearning expandido"
        ;;
    deeplearning)
        mkdir -p "$ENGINE_DIR/033-DeepLearning"/{TensorFlow,PyTorch,JAX,CNN,RNN,LSTM,GANs,Transformers,TransferLearning,ModelOptimization}
        echo "✅ 033-DeepLearning expandido"
        ;;
    ai)
        mkdir -p "$ENGINE_DIR/031-AI"/{History,Approaches,SymbolicAI,NeuroSymbolic,Ethics,Bias,Fairness,AGI,Safety}
        echo "✅ 031-AI expandido"
        ;;
    web)
        mkdir -p "$ENGINE_DIR/026-Web"/{HTML,CSS,JavaScript,TypeScript,WASM,PWA,WebSockets,WebRTC,A11y,SEO,Performance}
        echo "✅ 026-Web expandido"
        ;;
    apis)
        mkdir -p "$ENGINE_DIR/079-APIs"/{REST,GraphQL,gRPC,WebSocket,OpenAPI,Versioning,Security,RateLimiting,Documentation}
        echo "✅ 079-APIs expandido"
        ;;
    certs)
        mkdir -p "$ENGINE_DIR/048-Certifications"/{AWS,Azure,GCP,Kubernetes,Terraform,SAP,Security,Cisco,PMG,Scrum}
        echo "✅ 048-Certifications expandido"
        ;;
    iot)
        mkdir -p "$ENGINE_DIR/029-IoT"/{MQTT,CoAP,LoRaWAN,Zigbee,Bluetooth,EdgeComputing,Sensors,Platforms,Protocols}
        echo "✅ 029-IoT expandido"
        ;;
    embedded)
        mkdir -p "$ENGINE_DIR/028-Embedded"/{Arduino,RaspberryPi,ESP32,STM32,RTOS,ARM,Firmware,BareMetal}
        echo "✅ 028-Embedded expandido"
        ;;
    all)
        expand_dir() {
            local d="$1"
            if [ -d "$ENGINE_DIR/$d" ]; then
                mkdir -p "$ENGINE_DIR/$d"/{Conceptos,Guia,Recursos,Ejemplos}
                echo "  $d → estructura base"
            fi
        }
        echo "Expandiendo todos los módulos..."
        for dir in 0*/; do
            name=$(basename "$dir")
            expand_dir "$name"
        done
        ;;
    *)
        echo "Módulo '$ACTION' no reconocido"
        echo "Usa: ./expand.sh status para ver opciones"
        ;;
esac
