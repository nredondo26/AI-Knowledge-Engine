# Salesforce — Plataforma CRM Líder en la Nube

## Visión General

Salesforce es la plataforma CRM número uno a nivel mundial, fundada por Marc Benioff en 1999. Su modelo SaaS (Software as a Service) ofrece soluciones de ventas, servicio, marketing, analytics y desarrollo de aplicaciones personalizadas sobre la plataforma Force.com.

## Arquitectura Técnica

Salesforce opera sobre una arquitectura multitenant con una pila tecnológica propietaria. Cada organización (org) comparte la misma infraestructura pero con aislamiento total de datos y metadatos.

```
┌──────────────────────────────────────────────────┐
│             Capa de Presentación                  │
│    Lightning Experience · Salesforce Mobile · API  │
├──────────────────────────────────────────────────┤
│        Capa de Lógica (Apex · Flows)              │
│  Triggers · Classes · Batch · Scheduled Jobs      │
├──────────────────────────────────────────────────┤
│     Capa de Datos (SOQL · Objectos Custom)        │
│  Salesforce Objects · Campos · Relaciones         │
├──────────────────────────────────────────────────┤
│        Almacenamiento Multitenant (Pillar)         │
│  Particionamiento físico · Indexación optimizada  │
└──────────────────────────────────────────────────┘
```

## Modelo de Datos — Objetos y Campos

### Objeto Estándar vs. Custom

```apex
// Crear un objeto custom programáticamente (Metadata API)
MetadataService.MetadataPort service = new MetadataService.MetadataPort();
service.SessionHeader = new MetadataService.SessionHeader_element();
service.SessionHeader.sessionId = UserInfo.getSessionId();

MetadataService.CustomObject customObject = new MetadataService.CustomObject();
customObject.fullName = 'Proyecto__c';
customObject.label = 'Proyecto';
customObject.pluralLabel = 'Proyectos';
customObject.nameField = new MetadataService.CustomField();
customObject.nameField.label = 'Nombre del Proyecto';
customObject.nameField.type_x = 'Text';

List<MetadataService.CustomField> fields = new List<MetadataService.CustomField>();

MetadataService.CustomField budgetField = new MetadataService.CustomField();
budgetField.fullName = 'Presupuesto__c';
budgetField.label = 'Presupuesto';
budgetField.type_x = 'Currency';
budgetField.precision = 15;
budgetField.scale = 2;

fields.add(budgetField);
customObject.fields = fields;

service.createMetadata(new List<MetadataService.Metadata>{customObject});
```

## SOQL y SOSL — Lenguajes de Consulta

### SOQL (Salesforce Object Query Language)

```apex
// SOQL básico con relaciones
List<Account> cuentas = [
    SELECT Id, Name, Industry, Type,
           (SELECT Id, Name, Amount, CloseDate
            FROM Opportunities
            WHERE StageName != 'Closed Won'
            ORDER BY CloseDate DESC)
    FROM Account
    WHERE Industry IN ('Technology', 'Healthcare')
    AND CreatedDate = THIS_YEAR
    LIMIT 100
];

// Consulta agregada con GROUP BY
AggregateResult[] results = [
    SELECT StageName, COUNT(Id) total, SUM(Amount) totalAmount
    FROM Opportunity
    WHERE CloseDate = THIS_QUARTER
    GROUP BY StageName
];
```

### SOSL (Salesforce Object Search Language)

```apex
List<List<SObject>> searchResults = [
    FIND {Acme* OR *Corp}
    IN ALL FIELDS
    RETURNING Account(Id, Name, Phone),
             Contact(Id, Name, Email),
             Opportunity(Id, Name, Amount)
];
```

## Apex — Lenguaje Corporativo

Apex es un lenguaje fuertemente tipado similar a Java, compilado a bytecode y ejecutado en la máquina virtual de Salesforce.

```apex
public class ContratoService {
    private static final Integer MAX_AMOUNT = 1000000;

    @future(callout=true)
    public static void validarContratoAsync(Set<Id> contratoIds) {
        List<Contract> contratos = [
            SELECT Id, Status, ContractTerm, Total_Amount__c, AccountId
            FROM Contract
            WHERE Id IN :contratoIds
        ];

        for (Contract c : contratos) {
            if (c.Total_Amount__c > MAX_AMOUNT) {
                c.Status = 'Pending Approval';
            }
        }

        update contratos;

        // Llamada externa a sistema de scoring
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.microservice.com/v1/score');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(contratos));
        HttpResponse res = http.send(req);
    }
}
```

## Triggers de Salesforce

```apex
trigger ContractTrigger on Contract (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ContractTriggerHandler.validateContractStartDate(Trigger.new);
        }
        if (Trigger.isUpdate) {
            ContractTriggerHandler.preventContractEndDateChange(
                Trigger.oldMap, Trigger.newMap
            );
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            ContractTriggerHandler.updateParentAccountStatus(Trigger.new);
        }
    }
}
```

```apex
public class ContractTriggerHandler {
    public static void validateContractStartDate(List<Contract> newContracts) {
        for (Contract c : newContracts) {
            if (c.StartDate < Date.today()) {
                c.StartDate.addError('La fecha de inicio no puede ser anterior a hoy.');
            }
        }
    }

    public static void preventContractEndDateChange(
        Map<Id, Contract> oldMap, Map<Id, Contract> newMap
    ) {
        for (Contract c : newMap.values()) {
            if (c.ContractTerm != oldMap.get(c.Id).ContractTerm) {
                c.ContractTerm.addError(
                    'No se puede modificar el plazo una vez creado el contrato.'
                );
            }
        }
    }

    public static void updateParentAccountStatus(List<Contract> newContracts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contract c : newContracts) {
            if (c.Status == 'Activated') {
                accountIds.add(c.AccountId);
            }
        }

        List<Account> accountsToUpdate = [
            SELECT Id, Estado_Contrato__c FROM Account WHERE Id IN :accountIds
        ];
        for (Account a : accountsToUpdate) {
            a.Estado_Contrato__c = 'Active';
        }
        update accountsToUpdate;
    }
}
```

## Lightning Web Components (LWC)

```javascript
// lwc/projectCard/projectCard.js
import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import PROJECT_BUDGET_FIELD from '@salesforce/schema/Proyecto__c.Presupuesto__c';
import PROJECT_STATUS_FIELD from '@salesforce/schema/Proyecto__c.Status__c';

const FIELDS = [PROJECT_BUDGET_FIELD, PROJECT_STATUS_FIELD];

export default class ProjectCard extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    project;

    get budget() {
        return getFieldValue(this.project.data, PROJECT_BUDGET_FIELD);
    }

    get status() {
        return getFieldValue(this.project.data, PROJECT_STATUS_FIELD);
    }

    get budgetClass() {
        return this.budget > 100000 ? 'slds-text-color_success' : 'slds-text-color_default';
    }
}
```

```html
<!-- lwc/projectCard/projectCard.html -->
<template>
    <lightning-card title="Detalles del Proyecto" icon-name="standard:project">
        <div class="slds-p-horizontal_medium">
            <template if:true={project.data}>
                <p>Presupuesto: <span class={budgetClass}>{budget}</span></p>
                <p>Estado: {status}</p>
            </template>
            <template if:true={project.error}>
                <p>Error al cargar el proyecto.</p>
            </template>
        </div>
    </lightning-card>
</template>
```

## Integración — APIs de Salesforce

### REST API

```bash
# Autenticación OAuth 2.0
curl -X POST https://login.salesforce.com/services/oauth2/token \
  -d "grant_type=password" \
  -d "client_id=3MVG9l..." \
  -d "client_secret=..." \
  -d "username=user@example.com" \
  -d "password=secretTOKEN"

# Query SOQL via REST
curl -H "Authorization: Bearer <access_token>" \
  "https://yourinstance.salesforce.com/services/data/v60.0/query?q=SELECT+Id,+Name+FROM+Account+LIMIT+10"
```

## Flow Builder — Automatización Visual

Salesforce Flow (anteriormente Process Builder + Workflow) permite crear lógica de negocio sin código.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Flow xmlns="http://soap.sforce.com/2006/04/metadata">
    <description>Flujo de aprobación de proyectos</description>
    <processType>AutoLaunchedFlow</processType>
    <startElementReference>CheckBudget</startElementReference>
    <decisions>
        <name>CheckBudget</name>
        <defaultConnector>RejectProject</defaultConnector>
        <rules>
            <name>BudgetWithinLimit</name>
            <conditionLogic>and</conditionLogic>
            <conditions>
                <leftValueReference>Project_Budget__c</leftValueReference>
                <operator>LessThan</operator>
                <rightValue>
                    <stringValue>500000</stringValue>
                </rightValue>
            </conditions>
            <connector>
                <targetReference>ApproveProject</targetReference>
            </connector>
        </rules>
    </decisions>
</Flow>
```

## Buenas Prácticas

1. **Límites de gobernanza** — Respetar los 100 registros por DML, 10 MB de heap, 100 consultas SOQL por transacción.
2. **Bulk Trigger** — Siempre manejar colecciones, nunca registros individuales.
3. **Test Coverage** — Mantener mínimo 75% de cobertura en tests Apex.
4. **Package Development** — Usar paquetes 2GP (Second Generation Packaging) para distribución.
5. **Security** — Usar Sharing Rules, Permission Sets, y Field-Level Security.
6. **Source Control** — Adoptar Salesforce DX con `sfdx` o `sf` CLI y GitHub Actions para CI/CD.
7. **Naming Conventions** — Sufijos `__c` para custom objects/campos, `__r` para relaciones.

## Comandos Salesforce DX

```bash
# Crear proyecto DX
sf project generate -n MiProyecto --default-package-dir force-app

# Autorizar org
sf org login web -a devHub

# Crear scratch org
sf org create scratch -f config/project-scratch-def.json -a scratch1

# Desplegar metadatos
sf project deploy start -d force-app/main/default

# Ejecutar tests
sf apex run test --class-names MiTest --result-format human

# Recuperar datos
sf data export tree -q "SELECT Id, Name FROM Account" -p accounts.plan.json
```
