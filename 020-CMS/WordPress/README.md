# WordPress — CMS Más Utilizado del Mundo

## Visión General

WordPress comenzó en 2003 como un fork de b2/cafelog. Actualmente impulsa más del 43% de todos los sitios web. Escrito en PHP con MySQL/MariaDB, ofrece una arquitectura de plugins y temas que lo hace extremadamente extensible. Desde la versión 5.0+ incluye el editor Gutenberg (React) y ha evolucionado hacia un CMS de propósito general y headless.

## Arquitectura Técnica

```
┌──────────────────────────────────────────────────┐
│            WordPress Frontend / Headless          │
│  Temas PHP · Gutenberg (React) · REST API        │
├──────────────────────────────────────────────────┤
│          WordPress Core (PHP 8.x)                 │
│  WP_Query · Hooks (Actions/Filter) · Cron        │
├──────────────────────────────────────────────────┤
│            MySQL / MariaDB                        │
│  wp_posts · wp_postmeta · wp_options · wp_users  │
└──────────────────────────────────────────────────┘
```

## Estructura de Base de Datos

```sql
-- Tablas principales de WordPress

-- wp_posts: Contenido principal (posts, pages, revisions, attachments)
CREATE TABLE wp_posts (
  ID BIGINT UNSIGNED AUTO_INCREMENT,
  post_author BIGINT UNSIGNED DEFAULT 0,
  post_date DATETIME DEFAULT '0000-00-00 00:00:00',
  post_date_gmt DATETIME DEFAULT '0000-00-00 00:00:00',
  post_content LONGTEXT,
  post_title TEXT,
  post_status VARCHAR(20) DEFAULT 'publish',
  post_type VARCHAR(20) DEFAULT 'post',
  comment_status VARCHAR(20) DEFAULT 'open',
  guid VARCHAR(255),
  menu_order INT DEFAULT 0,
  post_mime_type VARCHAR(100),
  PRIMARY KEY (ID),
  KEY post_type (post_type, post_status, post_date)
);

-- wp_postmeta: Metadatos flexibles (EAV)
CREATE TABLE wp_postmeta (
  meta_id BIGINT UNSIGNED AUTO_INCREMENT,
  post_id BIGINT UNSIGNED DEFAULT 0,
  meta_key VARCHAR(255),
  meta_value LONGTEXT,
  PRIMARY KEY (meta_id),
  KEY post_id (post_id),
  KEY meta_key (meta_key)
);

-- wp_options: Configuración del sitio
CREATE TABLE wp_options (
  option_id BIGINT UNSIGNED AUTO_INCREMENT,
  option_name VARCHAR(191) DEFAULT '',
  option_value LONGTEXT,
  autoload VARCHAR(20) DEFAULT 'yes',
  PRIMARY KEY (option_id),
  UNIQUE KEY option_name (option_name)
);
```

## Sistema de Hooks — Actions y Filters

```php
<?php
// === ACTIONS ===

// Registrar un Custom Post Type
add_action('init', function () {
    register_post_type('proyecto', [
        'labels' => [
            'name'          => 'Proyectos',
            'singular_name' => 'Proyecto',
            'add_new_item'  => 'Añadir nuevo proyecto',
        ],
        'public'       => true,
        'has_archive'  => true,
        'menu_icon'    => 'dashicons-portfolio',
        'supports'     => ['title', 'editor', 'thumbnail', 'custom-fields'],
        'show_in_rest' => true, // Habilita Gutenberg y REST API
        'rewrite'      => ['slug' => 'proyectos'],
    ]);
});

// Añadir meta box personalizado
add_action('add_meta_boxes', function () {
    add_meta_box(
        'datos_proyecto',
        'Datos del Proyecto',
        function ($post) {
            $presupuesto = get_post_meta($post->ID, '_presupuesto', true);
            $cliente     = get_post_meta($post->ID, '_cliente', true);
            ?>
            <p>
                <label>Presupuesto (EUR):</label>
                <input type="number" name="presupuesto"
                       value="<?= esc_attr($presupuesto) ?>" step="0.01" />
            </p>
            <p>
                <label>Cliente:</label>
                <input type="text" name="cliente"
                       value="<?= esc_attr($cliente) ?>" />
            </p>
            <?php
        },
        'proyecto', 'normal', 'high'
    );
});

// Guardar meta box
add_action('save_post_proyecto', function ($post_id) {
    if (defined('DOING_AUTOSAVE') && DOING_AUTOSAVE) return;
    if (!current_user_can('edit_post', $post_id)) return;

    if (isset($_POST['presupuesto'])) {
        update_post_meta($post_id, '_presupuesto',
            sanitize_text_field($_POST['presupuesto']));
    }
    if (isset($_POST['cliente'])) {
        update_post_meta($post_id, '_cliente',
            sanitize_text_field($_POST['cliente']));
    }
});

// === FILTERS ===

// Modificar el excerpt
add_filter('excerpt_length', function () {
    return 30;
});

add_filter('excerpt_more', function () {
    return '... leer más';
});

// Añadir clases al body
add_filter('body_class', function ($classes) {
    if (is_singular('proyecto')) {
        $classes[] = 'single-proyecto';
    }
    return $classes;
});
```

## WP_Query — Consultas Avanzadas

```php
<?php
// Query personalizada con múltiples parámetros
$args = [
    'post_type'      => 'proyecto',
    'posts_per_page' => 10,
    'paged'          => get_query_var('paged') ?: 1,
    'meta_query'     => [
        'relation' => 'AND',
        [
            'key'     => '_presupuesto',
            'value'   => 100000,
            'type'    => 'NUMERIC',
            'compare' => '>=',
        ],
        [
            'key'     => '_cliente',
            'value'   => '',
            'compare' => '!=',
        ],
    ],
    'tax_query' => [
        [
            'taxonomy' => 'categoria_proyecto',
            'field'    => 'slug',
            'terms'    => ['tecnologia', 'innovacion'],
            'operator' => 'IN',
        ],
    ],
    'orderby'  => 'meta_value_num',
    'meta_key' => '_presupuesto',
    'order'    => 'DESC',
];

$proyectos = new WP_Query($args);

if ($proyectos->have_posts()):
    while ($proyectos->have_posts()): $proyectos->the_post(); ?>
        <article id="post-<?php the_ID(); ?>">
            <h2><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2>
            <div><?php the_excerpt(); ?></div>
        </article>
    <?php endwhile;

    // Paginación
    echo paginate_links([
        'total'   => $proyectos->max_num_pages,
        'current' => max(1, get_query_var('paged')),
    ]);
endif;
wp_reset_postdata();
```

## REST API de WordPress

```python
import requests

WP_URL = "https://mislio.com/wp-json/wp/v2"

# Obtener posts con filtros
response = requests.get(f"{WP_URL}/proyecto", params={
    "per_page": 20,
    "page": 1,
    "meta_key": "_presupuesto",
    "meta_type": "NUMERIC",
    "orderby": "meta_value_num",
    "order": "desc",
    "_embed": "wp:featuredmedia"
})
proyectos = response.json()

for proyecto in proyectos:
    print(f"- {proyecto['title']['rendered']}: "
          f"${proyecto['meta']['_presupuesto']}")

# Crear un post via REST
from requests.auth import HTTPBasicAuth

auth = HTTPBasicAuth('user', 'app_password')
data = {
    "title": "Nuevo Proyecto",
    "content": "<!-- wp:paragraph --><p>Descripción del proyecto.</p><!-- /wp:paragraph -->",
    "status": "draft",
    "meta": {
        "_presupuesto": 250000,
        "_cliente": "TechCorp"
    }
}
resp = requests.post(f"{WP_URL}/proyecto", json=data, auth=auth)
print(resp.status_code, resp.json().get("id"))
```

## Desarrollo de Plugins

```php
<?php
/**
 * Plugin Name: SEO Avanzado
 * Plugin URI:  https://mislio.com/plugins/seo-avanzado
 * Description: Añade meta tags Open Graph y JSON-LD personalizados.
 * Version:     1.0.0
 * Author:      AI Knowledge Engine
 * License:     GPL-2.0+
 * Text Domain: seo-avanzado
 */

// Evitar acceso directo
if (!defined('ABSPATH')) exit;

// Registrar activación/desactivación
register_activation_hook(__FILE__, function () {
    add_option('seo_avanzado_default_image', '');
});

// Añadir meta tags Open Graph al head
add_action('wp_head', function () {
    if (!is_single()) return;
    global $post;

    $image = get_the_post_thumbnail_url($post->ID, 'large')
           ?: get_option('seo_avanzado_default_image');
    ?>
    <meta property="og:title" content="<?= esc_attr(get_the_title()) ?>" />
    <meta property="og:description"
          content="<?= esc_attr(get_the_excerpt()) ?>" />
    <meta property="og:image" content="<?= esc_url($image) ?>" />
    <meta property="og:type" content="article" />
    <meta property="og:locale" content="es_ES" />
    <?php
});

// JSON-LD Schema
add_action('wp_footer', function () {
    if (!is_singular('proyecto')) return;
    global $post;

    $schema = [
        '@context' => 'https://schema.org',
        '@type'    => 'Project',
        'name'     => get_the_title(),
        'description' => get_the_excerpt(),
        'url'      => get_permalink(),
        'funder'   => [
            '@type' => 'Organization',
            'name'  => get_post_meta($post->ID, '_cliente', true),
        ],
    ];
    echo '<script type="application/ld+json">'
         . json_encode($schema, JSON_UNESCAPED_UNICODE)
         . '</script>';
});

// Añadir página de settings
add_action('admin_menu', function () {
    add_options_page(
        'SEO Avanzado', 'SEO Avanzado', 'manage_options',
        'seo-avanzado', function () {
            ?>
            <div class="wrap">
                <h1>SEO Avanzado</h1>
                <form method="post" action="options.php">
                    <?php settings_fields('seo_avanzado_group'); ?>
                    <table class="form-table">
                        <tr>
                            <th>Imagen por defecto</th>
                            <td>
                                <input type="url" name="seo_avanzado_default_image"
                                       value="<?= get_option('seo_avanzado_default_image') ?>"
                                       class="regular-text" />
                            </td>
                        </tr>
                    </table>
                    <?php submit_button(); ?>
                </form>
            </div>
            <?php
        }
    );
});
```

## WordPress como Headless CMS

```javascript
// Frontend con Next.js consumiendo WP REST API
async function getStaticProps() {
    const res = await fetch(
        'https://cms.misitio.com/wp-json/wp/v2/proyecto?_embed&per_page=50'
    );
    const proyectos = await res.json();

    return {
        props: {
            proyectos: proyectos.map(post => ({
                id: post.id,
                title: post.title.rendered,
                excerpt: post.excerpt.rendered,
                image: post._embedded?.['wp:featuredmedia']?.[0]?.source_url,
                slug: post.slug,
                meta: post.meta
            }))
        },
        revalidate: 3600
    };
}
```

## WP-CLI — Línea de Comandos

```bash
# Instalación
wp core download --locale=es_ES
wp config create --dbname=wp --dbuser=root --dbpass=secret
wp db create
wp core install --url=localhost --title="Mi Sitio" \
  --admin_user=admin --admin_password=secret --admin_email=admin@example.com

# Gestión de contenido
wp post create --post_type=proyecto --post_title="Proyecto Demo" \
  --meta='{"_presupuesto": 50000}'
wp post list --post_type=proyecto --format=json

# Gestión de usuarios
wp user create editor editor@example.com --role=editor

# Plugins y temas
wp plugin install woocommerce elementor --activate
wp theme install twentytwentyfour --activate

# Cache y optimización
wp rewrite flush
wp cache flush
wp transient delete --all
```

## Buenas Prácticas

1. **Seguridad** — Mantener core, plugins y temas actualizados. Usar `wp-config.php` con claves seguras.
2. **Rendimiento** — Implementar caché de página (Redis/Memcached), CDN y optimización de imágenes.
3. **Escalabilidad** — Separar base de datos (RDS), usar read replicas y balanceador de carga.
4. **Código** — Seguir estándares WPCS (WordPress Coding Standards) y PHPDoc.
5. **Gutenberg** — Desarrollar bloques nativos con `register_block_type` en lugar de shortcodes.
6. **Testing** — Usar WP_Mock (unit) y WP_Test Suite (integración) para plugins.
7. **Backup** — Automatizar backups de base de datos y `wp-content/uploads`.
