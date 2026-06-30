# Magento (Adobe Commerce) — Plataforma E-commerce Open Source

## Visión General

Magento (ahora Adobe Commerce) es una plataforma de comercio electrónico open source escrita en PHP. Fundada por Varien en 2007, fue adquirida por Adobe en 2018. Ofrece dos ediciones: Magento Open Source (gratuita) y Adobe Commerce (con suscripción, con B2B, Page Builder, Live Search y más). Utiliza una arquitectura modular EAV y un potente framework de extensiones.

## Arquitectura Técnica

```
┌──────────────────────────────────────────────────┐
│              Frontend (Luma / Hyvä / PWA)         │
│  Knockout.js · RequireJS · Tailwind (Hyvä)       │
├──────────────────────────────────────────────────┤
│         Magento Core (PHP 8.x / Symfony)          │
│  Service Contracts · Plugins (Interceptors)      │
├──────────────────────────────────────────────────┤
│           Capa de Negocio (Modelos)               │
│  Repositorios · Factories · Colecciones           │
├──────────────────────────────────────────────────┤
│         Capa de Persistencia (MySQL / EAV)        │
│  Tablas planas · EAV (Entity-Attribute-Value)    │
└──────────────────────────────────────────────────┘
```

## Estructura de un Módulo Magento

```
app/code/Vendor/Modulo/
├── etc/
│   ├── module.xml
│   ├── di.xml
│   ├── config.xml
│   ├── events.xml
│   └── webapi.xml
├── Setup/
│   ├── InstallSchema.php
│   ├── UpgradeSchema.php
│   ├── InstallData.php
│   └── Recurring.php
├── Model/
│   ├── Producto.php
│   ├── ResourceModel/
│   │   └── Producto.php
│   └── ProductoRepository.php
├── Api/
│   ├── ProductoRepositoryInterface.php
│   └── Data/
│       └── ProductoInterface.php
├── Block/
│   ├── Producto.php
│   └── Adminhtml/
├── Controller/
│   ├── Index/
│   │   ├── Index.php
│   │   └── View.php
│   └── Adminhtml/
├── view/
│   ├── frontend/
│   │   ├── layouts/
│   │   ├── templates/
│   │   └── web/
│   └── adminhtml/
├── i18n/
├── Plugin/
├── Observer/
└── registration.php
```

## Módulo y DI (Dependency Injection)

```xml
<?xml version="1.0"?>
<!-- app/code/Vendor/GestionProyectos/etc/module.xml -->
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="Vendor_GestionProyectos" setup_version="1.0.0">
        <sequence>
            <module name="Magento_Catalog"/>
            <module name="Magento_Sales"/>
        </sequence>
    </module>
</config>
```

```php
<?php
// app/code/Vendor/GestionProyectos/registration.php
use Magento\Framework\Component\ComponentRegistrar;

ComponentRegistrar::register(
    ComponentRegistrar::MODULE,
    'Vendor_GestionProyectos',
    __DIR__
);
```

```xml
<?xml version="1.0"?>
<!-- app/code/Vendor/GestionProyectos/etc/di.xml -->
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">

    <!-- Preference para interfaz de repositorio -->
    <preference for="Vendor\GestionProyectos\Api\ProyectoRepositoryInterface"
                type="Vendor\GestionProyectos\Model\ProyectoRepository" />

    <!-- Plugin (Interceptor) -->
    <type name="Magento\Catalog\Model\ProductRepository">
        <plugin name="proyectos_add_project_info"
                type="Vendor\GestionProyectos\Plugin\ProductPlugin"
                sortOrder="10" />
    </type>

    <!-- Virtual Type para logger específico -->
    <virtualType name="Vendor\GestionProyectos\Logger\Handler"
                 type="Magento\Framework\Logger\Handler\Base">
        <arguments>
            <argument name="fileName" xsi:type="string">/var/log/proyectos.log</argument>
        </arguments>
    </virtualType>
</config>
```

## Modelo EAV (Entity-Attribute-Value)

```php
<?php
// Setup/InstallSchema.php
namespace Vendor\GestionProyectos\Setup;

use Magento\Framework\Setup\InstallSchemaInterface;
use Magento\Framework\Setup\ModuleContextInterface;
use Magento\Framework\Setup\SchemaSetupInterface;
use Magento\Framework\DB\Ddl\Table;

class InstallSchema implements InstallSchemaInterface
{
    public function install(SchemaSetupInterface $setup, ModuleContextInterface $context)
    {
        $setup->startSetup();

        // Tabla del modelo
        $table = $setup->getConnection()
            ->newTable($setup->getTable('vendor_proyecto'))
            ->addColumn(
                'entity_id',
                Table::TYPE_INTEGER,
                null,
                ['identity' => true, 'unsigned' => true, 'nullable' => false, 'primary' => true],
                'ID del Proyecto'
            )
            ->addColumn('codigo', Table::TYPE_TEXT, 50, ['nullable' => false], 'Código único')
            ->addColumn('nombre', Table::TYPE_TEXT, 255, ['nullable' => false], 'Nombre')
            ->addColumn('presupuesto', Table::TYPE_DECIMAL, '15,2', ['nullable' => false, 'default' => 0.00])
            ->addColumn('estado', Table::TYPE_TEXT, 20, ['nullable' => false, 'default' => 'planificado'])
            ->addColumn('customer_id', Table::TYPE_INTEGER, null, ['unsigned' => true])
            ->addColumn('created_at', Table::TYPE_TIMESTAMP, null, ['default' => Table::TIMESTAMP_INIT])
            ->addColumn('updated_at', Table::TYPE_TIMESTAMP, null, ['default' => Table::TIMESTAMP_INIT_UPDATE])
            ->addIndex($setup->getIdxName('vendor_proyecto', ['codigo']), ['codigo'])
            ->addForeignKey(
                $setup->getFkName('vendor_proyecto', 'customer_id', 'customer_entity', 'entity_id'),
                'customer_id',
                $setup->getTable('customer_entity'),
                'entity_id',
                Table::ACTION_SET_NULL
            )
            ->setComment('Tabla de Proyectos');

        $setup->getConnection()->createTable($table);

        // Tabla EAV para atributos dinámicos
        $eavTable = $setup->getConnection()
            ->newTable($setup->getTable('vendor_proyecto_varchar'))
            ->addColumn('value_id', Table::TYPE_INTEGER, null, ['identity' => true, 'primary' => true])
            ->addColumn('entity_id', Table::TYPE_INTEGER, null, ['unsigned' => true, 'nullable' => false])
            ->addColumn('attribute_id', Table::TYPE_SMALLINT, null, ['unsigned' => true, 'nullable' => false])
            ->addColumn('value', Table::TYPE_TEXT, 65536)
            ->addIndex('entity_id', ['entity_id'])
            ->addIndex('attribute_id', ['attribute_id'])
            ->setComment('Valores EAV de texto');

        $setup->getConnection()->createTable($eavTable);

        $setup->endSetup();
    }
}
```

## Repositorio y Contrato de Servicio

```php
<?php
// Api/ProyectoRepositoryInterface.php
namespace Vendor\GestionProyectos\Api;

use Vendor\GestionProyectos\Api\Data\ProyectoInterface;
use Magento\Framework\Api\SearchCriteriaInterface;

interface ProyectoRepositoryInterface
{
    public function save(ProyectoInterface $proyecto): ProyectoInterface;
    public function getById(int $id): ProyectoInterface;
    public function getByCodigo(string $codigo): ProyectoInterface;
    public function delete(ProyectoInterface $proyecto): bool;
    public function getList(SearchCriteriaInterface $searchCriteria): \Magento\Framework\Api\SearchResultsInterface;
}
```

```php
<?php
// Model/ProyectoRepository.php
namespace Vendor\GestionProyectos\Model;

use Vendor\GestionProyectos\Api\ProyectoRepositoryInterface;
use Vendor\GestionProyectos\Api\Data\ProyectoInterface;
use Vendor\GestionProyectos\Api\Data\ProyectoSearchResultsInterface;
use Vendor\GestionProyectos\Api\Data\ProyectoSearchResultsInterfaceFactory;
use Vendor\GestionProyectos\Model\ResourceModel\Proyecto as ResourceModel;
use Vendor\GestionProyectos\Model\ResourceModel\Proyecto\CollectionFactory;
use Magento\Framework\Exception\NoSuchEntityException;
use Magento\Framework\Api\SearchCriteria\CollectionProcessorInterface;

class ProyectoRepository implements ProyectoRepositoryInterface
{
    private ResourceModel $resource;
    private ProyectoFactory $factory;
    private CollectionFactory $collectionFactory;
    private ProyectoSearchResultsInterfaceFactory $searchResultsFactory;
    private CollectionProcessorInterface $collectionProcessor;

    public function __construct(
        ResourceModel $resource,
        ProyectoFactory $factory,
        CollectionFactory $collectionFactory,
        ProyectoSearchResultsInterfaceFactory $searchResultsFactory,
        CollectionProcessorInterface $collectionProcessor
    ) {
        $this->resource = $resource;
        $this->factory = $factory;
        $this->collectionFactory = $collectionFactory;
        $this->searchResultsFactory = $searchResultsFactory;
        $this->collectionProcessor = $collectionProcessor;
    }

    public function save(ProyectoInterface $proyecto): ProyectoInterface
    {
        $this->resource->save($proyecto);
        return $proyecto;
    }

    public function getById(int $id): ProyectoInterface
    {
        $proyecto = $this->factory->create();
        $this->resource->load($proyecto, $id);
        if (!$proyecto->getId()) {
            throw new NoSuchEntityException(__('Proyecto con ID %1 no existe.', $id));
        }
        return $proyecto;
    }

    public function getByCodigo(string $codigo): ProyectoInterface
    {
        $proyecto = $this->factory->create();
        $this->resource->load($proyecto, $codigo, 'codigo');
        if (!$proyecto->getId()) {
            throw new NoSuchEntityException(__('Proyecto con código %1 no existe.', $codigo));
        }
        return $proyecto;
    }

    public function delete(ProyectoInterface $proyecto): bool
    {
        return $this->resource->delete($proyecto);
    }

    public function getList(SearchCriteriaInterface $searchCriteria): SearchResultsInterface
    {
        $collection = $this->collectionFactory->create();
        $this->collectionProcessor->process($searchCriteria, $collection);

        $searchResults = $this->searchResultsFactory->create();
        $searchResults->setSearchCriteria($searchCriteria);
        $searchResults->setItems($collection->getItems());
        $searchResults->setTotalCount($collection->getSize());

        return $searchResults;
    }
}
```

## Plugin (Interceptor)

```php
<?php
// Plugin/ProductPlugin.php
namespace Vendor\GestionProyectos\Plugin;

use Magento\Catalog\Api\ProductRepositoryInterface;
use Magento\Catalog\Api\Data\ProductInterface;
use Vendor\GestionProyectos\Model\ResourceModel\Proyecto\CollectionFactory;
use Psr\Log\LoggerInterface;

class ProductPlugin
{
    private CollectionFactory $proyectoCollectionFactory;
    private LoggerInterface $logger;

    public function __construct(
        CollectionFactory $proyectoCollectionFactory,
        LoggerInterface $logger
    ) {
        $this->proyectoCollectionFactory = $proyectoCollectionFactory;
        $this->logger = $logger;
    }

    // After plugin: enriquecer producto con datos de proyecto
    public function afterGet(
        ProductRepositoryInterface $subject,
        ProductInterface $product
    ): ProductInterface {
        $sku = $product->getSku();

        $proyectos = $this->proyectoCollectionFactory->create()
            ->addFieldToFilter('codigo', ['like' => "%{$sku}%"]);

        if ($proyectos->getSize() > 0) {
            $proyecto = $proyectos->getFirstItem();
            $product->setData('proyecto_nombre', $proyecto->getNombre());
            $product->setData('proyecto_presupuesto', $proyecto->getPresupuesto());
        }

        return $product;
    }
}
```

## REST API en Magento

```xml
<?xml version="1.0"?>
<!-- etc/webapi.xml -->
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Webapi:etc/webapi.xsd">
    <route method="GET" url="/V1/proyectos/:id">
        <service class="Vendor\GestionProyectos\Api\ProyectoRepositoryInterface"
                 method="getById"/>
        <resources>
            <resource ref="Vendor_GestionProyectos::proyectos"/>
        </resources>
    </route>
    <route method="GET" url="/V1/proyectos">
        <service class="Vendor\GestionProyectos\Api\ProyectoRepositoryInterface"
                 method="getList"/>
        <resources>
            <resource ref="Vendor_GestionProyectos::proyectos"/>
        </resources>
    </route>
    <route method="POST" url="/V1/proyectos">
        <service class="Vendor\GestionProyectos\Api\ProyectoRepositoryInterface"
                 method="save"/>
        <resources>
            <resource ref="Vendor_GestionProyectos::proyectos"/>
        </resources>
    </route>
</routes>
```

```php
<?php
// etc/acl.xml
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Acl/etc/acl.xsd">
    <acl>
        <resources>
            <resource id="Magento_Backend::admin">
                <resource id="Vendor_GestionProyectos::proyectos"
                          title="Gestión de Proyectos"
                          sortOrder="10" />
                <resource id="Vendor_GestionProyectos::proyectos_manage"
                          title="Administrar proyectos"
                          sortOrder="20" />
            </resource>
        </resources>
    </acl>
</config>
```

## Observers y Eventos

```php
<?php
// etc/events.xml
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Event/etc/events.xsd">
    <event name="sales_order_place_after">
        <observer name="proyectos_after_order"
                  instance="Vendor\GestionProyectos\Observer\AfterOrderPlace"
                  shared="false" />
    </event>
</config>
```

```php
<?php
// Observer/AfterOrderPlace.php
namespace Vendor\GestionProyectos\Observer;

use Magento\Framework\Event\ObserverInterface;
use Magento\Framework\Event\Observer;
use Vendor\GestionProyectos\Model\ProyectoFactory;
use Psr\Log\LoggerInterface;

class AfterOrderPlace implements ObserverInterface
{
    private ProyectoFactory $proyectoFactory;
    private LoggerInterface $logger;

    public function __construct(ProyectoFactory $proyectoFactory, LoggerInterface $logger)
    {
        $this->proyectoFactory = $proyectoFactory;
        $this->logger = $logger;
    }

    public function execute(Observer $observer)
    {
        $order = $observer->getEvent()->getOrder();

        try {
            $proyecto = $this->proyectoFactory->create();
            $proyecto->setData([
                'codigo'     => 'ORD-' . $order->getIncrementId(),
                'nombre'     => 'Proyecto para pedido ' . $order->getIncrementId(),
                'presupuesto' => $order->getGrandTotal(),
                'estado'     => 'nuevo',
                'customer_id' => $order->getCustomerId()
            ]);
            $proyecto->save();

            $this->logger->info('Proyecto creado desde pedido', [
                'order_id' => $order->getId(),
                'proyecto_id' => $proyecto->getId()
            ]);
        } catch (\Exception $e) {
            $this->logger->error('Error creando proyecto desde pedido: ' . $e->getMessage());
        }
    }
}
```

## CLI de Magento

```bash
# Instalación
bin/magento setup:install \
  --base-url=https://mystore.com \
  --db-host=localhost \
  --db-name=magento \
  --db-user=root \
  --db-password=secret \
  --admin-firstname=Admin \
  --admin-lastname=User \
  --admin-email=admin@example.com \
  --admin-user=admin \
  --admin-password=admin123 \
  --language=es_ES \
  --currency=EUR \
  --timezone=Europe/Madrid

# Gestión de módulos
bin/magento module:status
bin/magento module:enable Vendor_GestionProyectos
bin/magento setup:upgrade
bin/magento setup:di:compile

# Cache
bin/magento cache:clean
bin/magento cache:flush
bin/magento cache:enable

# Modo de ejecución
bin/magento deploy:mode:set developer
bin/magento deploy:mode:set production

# Reindexación
bin/magento indexer:reindex
bin/magento indexer:status

# Creación de administrador
bin/magento admin:user:create \
  --admin-user=admin2 \
  --admin-password=pass123 \
  --admin-email=admin2@example.com \
  --admin-firstname=Admin2 \
  --admin-lastname=User2
```

## Buenas Prácticas

1. **Service Contracts** — Siempre programar contra interfaces, nunca clases concretas.
2. **Plugins vs. Observers** — Preferir plugins sobre observers para extender funcionalidad existente.
3. **EAV** — Usar tablas planas para alto rendimiento; EAV solo cuando los atributos son dinámicos.
4. **Caché** — Implementar caché de bloque, Varnish (full page cache) y Redis para sesiones.
5. **Colas** — Usar RabbitMQ para procesos pesados (envío de emails, generación de PDFs).
6. **Rendering** — Considerar Hyvä Themes o PWA Studio para mejorar tiempos de carga.
7. **Seguridad** — Validar siempre datos de entrada, usar ACL y escapar salidas en templates.
8. **Testing** — Escribir tests de integración con PHPUnit y tests de aceptación con MFTF.
9. **Git** — Mantener módulos en repositorios separados, usar Composer satis para distribución.
