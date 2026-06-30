# PWA — Progressive Web Applications

## Descripción General

Una **Progressive Web Application** es una aplicación web que ofrece experiencia similar a nativa: **instalable**, **offline**, con acceso a APIs del dispositivo. Construida con tecnologías web estándar: HTML, CSS, JavaScript.

---

## Requisitos Técnicos

1. **HTTPS obligatorio**.
2. **Service Worker** registrado y funcional.
3. **Manifest JSON**.
4. **Responsive**.
5. **Cross-browser**.

---

## Web App Manifest

```json
{
  "name": "Mi App PWA",
  "short_name": "PWA App",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2563eb",
  "icons": [{ "src": "/icons/icon-192x192.png", "sizes": "192x192", "type": "image/png", "purpose": "any maskable" }]
}
```

```html
<link rel="manifest" href="/manifest.json">
<meta name="apple-mobile-web-app-capable" content="yes">
<link rel="apple-touch-icon" href="/icons/icon-192x192.png">
```

---

## Service Workers — Ciclo de Vida

```
Installing → Installed (Waiting) → Activating → Activated → Terminated
```

### Registro

```javascript
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js', { scope: '/' })
    .then(reg => { console.log('SW registrado:', reg.scope); })
    .catch(err => console.error('Error SW:', err));
}
```

---

## Estrategias de Caché

### Cache First (Offline-first)

```javascript
const CACHE = 'mi-app-v1';
const URLS = ['/', '/styles.css', '/app.js', '/offline.html'];

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(URLS)));
  self.skipWaiting();
});

self.addEventListener('activate', (e) => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(caches.delete))));
  clients.claim();
});

self.addEventListener('fetch', (e) => {
  e.respondWith(
    caches.match(e.request).then(cached => {
      const fetchP = fetch(e.request).then(r => { if (r.ok) { const c = r.clone(); caches.open(CACHE).then(ca => ca.put(e.request, c)); } return r; });
      return cached || fetchP;
    })
  );
});
```

### Network First

```javascript
e.respondWith(fetch(e.request).then(r => { caches.open(CACHE).then(c => c.put(e.request, r.clone())); return r; }).catch(() => caches.match(e.request)));
```

### Stale While Revalidate

```javascript
e.respondWith(caches.match(e.request).then(cached => { const f = fetch(e.request).then(r => { caches.open(CACHE).then(c => c.put(e.request, r.clone())); return r; }); return cached || f; }));
```

---

## Notificaciones Push

```javascript
// Suscripción
const reg = await navigator.serviceWorker.ready;
const sub = await reg.pushManager.subscribe({ userVisibleOnly: true, applicationServerKey: vapidKey });
await fetch('/api/push/subscribe', { method: 'POST', body: JSON.stringify(sub), headers: { 'Content-Type': 'application/json' } });

// Service Worker
self.addEventListener('push', (e) => {
  const d = e.data?.json() ?? { title: 'Notificación', body: '' };
  e.waitUntil(self.registration.showNotification(d.title, { body: d.body, icon: '/icons/icon-192x192.png', data: { url: d.url } }));
});

self.addEventListener('notificationclick', (e) => { e.notification.close(); if (e.action === 'open') e.waitUntil(clients.openWindow(e.notification.data.url)); });
```

---

## IndexedDB

```javascript
import { openDB } from 'idb';
const db = await openDB('mi-app', 1, { upgrade(db) { db.createObjectStore('usuarios', { keyPath: 'id' }); } });
await db.put('usuarios', { id: 1, nombre: 'Ana' });
const todos = await db.getAll('usuarios');
```

---

## Background Sync

```javascript
// Registrar
const reg = await navigator.serviceWorker.ready; await reg.sync.register('sync-data');

// SW
self.addEventListener('sync', (e) => { if (e.tag === 'sync-data') e.waitUntil(syncData()); });
```

---

## Workbox

```javascript
// workbox-config.js
module.exports = { globDirectory: 'dist/', globPatterns: ['**/*.{html,js,css,png}'], swDest: 'dist/sw.js',
  runtimeCaching: [{ urlPattern: /\/api\//, handler: 'NetworkFirst', options: { cacheName: 'api-cache' } }],
};
```

---

## Limitaciones vs Nativa

| Aspecto | PWA | Nativa |
|---------|-----|--------|
| Bluetooth/NFC | Limitado | Completo |
| Archivos | File System Access API | Acceso completo |
| Almacenamiento | ~80% del disco | Ilimitado |
| Background | Limitado por SO | Background Services |
| Push | Solo visible | Push silencioso |
| iOS | Safari limitado (push desde 16.4+) | Experiencia completa |

---

## Referencias

- [web.dev — PWA](https://web.dev/learn/pwa)
- [MDN — Service Worker API](https://developer.mozilla.org/es/docs/Web/API/Service_Worker_API)
- [Workbox](https://developer.chrome.com/docs/workbox)
