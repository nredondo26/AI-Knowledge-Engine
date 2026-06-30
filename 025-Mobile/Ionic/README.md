# Ionic — Apps Híbridas con Web Technologies

## Descripción General

Ionic es un framework de código abierto para construir aplicaciones móviles y de escritorio usando tecnologías web (HTML, CSS, JavaScript/TypeScript). Se integra con Angular, React y Vue. Usa **Capacitor** (sucesor de Cordova) como capa nativa para acceso a APIs del dispositivo.

---

## Arquitectura

- **UI Framework**: Componentes nativos estilizados (Ionic UI).
- **WebView**: Renderizado en WKWebView (iOS) o WebView (Android).
- **Capacitor**: Bridge nativo para cámara, GPS, archivos, etc.
- **Build Tool**: Vite / Angular CLI / react-scripts.

---

## Instalación y Creación

```bash
npm install -g @ionic/cli
ionic start MiApp tabs --type=angular
ionic start MiApp blank --type=react
ionic start MiApp sidemenu --type=vue

cd MiApp
ionic serve  # Desarrollo en navegador
```

---

## Componentes Básicos (Angular)

```typescript
// home.page.ts
import { Component } from '@angular/core';
import { AlertController } from '@ionic/angular';

@Component({
  selector: 'app-home',
  template: `
    <ion-header>
      <ion-toolbar color="primary">
        <ion-title>Mi App Ionic</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content class="ion-padding">
      <ion-card>
        <ion-card-header>
          <ion-card-title>Bienvenido</ion-card-title>
        </ion-card-header>
        <ion-card-content>
          <p>Esta es una app creada con Ionic + Angular.</p>
          <ion-button expand="block" (click)="mostrarAlerta()">
            <ion-icon name="alert-circle" slot="start"></ion-icon>
            Presióname
          </ion-button>
        </ion-card-content>
      </ion-card>
    </ion-content>
  `
})
export class HomePage {
  constructor(private alertCtrl: AlertController) {}

  async mostrarAlerta() {
    const alert = await this.alertCtrl.create({
      header: '¡Hola!',
      message: 'Has presionado el botón.',
      buttons: ['OK']
    });
    await alert.present();
  }
}
```

---

## Navegación y Rutas

```typescript
// Angular
const routes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', loadChildren: () => import('./home/home.module').then(m => m.HomePageModule) },
  { path: 'detail/:id', loadChildren: () => import('./detail/detail.module').then(m => m.DetailPageModule) },
];
```

```tsx
// React
<IonReactRouter>
  <IonRouterOutlet>
    <Route path="/home" component={Home} exact />
    <Route path="/detail/:id" component={Detail} />
  </IonRouterOutlet>
</IonReactRouter>
```

---

## Acceso a APIs Nativas con Capacitor

```typescript
import { Camera, CameraResultType } from '@capacitor/camera';
import { Geolocation } from '@capacitor/geolocation';
import { Share } from '@capacitor/share';
import { PushNotifications } from '@capacitor/push-notifications';

// Cámara
async function tomarFoto() {
  const image = await Camera.getPhoto({
    quality: 90,
    allowEditing: true,
    resultType: CameraResultType.Uri
  });
  return image.webPath;
}

// GPS
async function obtenerPosicion() {
  const pos = await Geolocation.getCurrentPosition();
  return { lat: pos.coords.latitude, lng: pos.coords.longitude };
}

// Compartir
async function compartir(texto: string) {
  await Share.share({ title: 'Mi App', text: texto, url: 'https://ejemplo.com' });
}
```

---

## Plugins de Capacitor

```bash
npm install @capacitor/camera @capacitor/geolocation @capacitor/filesystem
npx cap sync
npx cap open android
npx cap open ios
```

```typescript
import { Filesystem, Directory } from '@capacitor/filesystem';

async function guardarArchivo(nombre: string, data: string) {
  await Filesystem.writeFile({
    path: nombre,
    data,
    directory: Directory.Data
  });
}
```

---

## Almacenamiento Local

```typescript
// @capacitor/storage (clave-valor)
import { Storage } from '@capacitor/storage';

await Storage.set({ key: 'token', value: 'abc123' });
const { value } = await Storage.get({ key: 'token' });

// Ionic Storage (SQLite-based)
import { Storage as IonicStorage } from '@ionic/storage';
const store = new IonicStorage();
await store.set('usuario', { id: 1, nombre: 'Ana' });
const usuario = await store.get('usuario');
```

---

## State Management

```typescript
// NgRx en Angular
@Injectable()
export class AuthEffects {
  login$ = createEffect(() => this.actions$.pipe(
    ofType(AuthActions.login),
    switchMap(({ email, password }) =>
      this.authService.login(email, password).pipe(
        map(user => AuthActions.loginSuccess({ user })),
        catchError(error => of(AuthActions.loginFailure({ error })))
      )
    )
  ));
}
```

---

## Compilación Nativa

```bash
# Web (PWA)
ionic build --prod

# Android
ionic build android --release
npx cap copy android
npx cap open android

# iOS
ionic build ios --release
npx cap copy ios
npx cap open ios
```

---

## Pruebas (Playwright + Web)

```typescript
test('navegación funciona', async ({ page }) => {
  await page.goto('http://localhost:8100');
  await page.click('ion-tab-button[tab="profile"]');
  await expect(page.locator('ion-title')).toHaveText('Perfil');
});
```

---

## Mejores Prácticas

1. **Capacitor** sobre Cordova (más moderno, mejor rendimiento).
2. **Lazy loading** de módulos/páginas para reducir tamaño inicial.
3. **Virtual Scroll** (`ion-virtual-scroll`) para listas largas.
4. **Theming**: Usar variables CSS de Ionic para branding.
5. **Offline**: Ionic Storage + Capacitor Filesystem para datos locales.

---

## Referencias

- [Ionic Documentation](https://ionicframework.com/docs)
- [Capacitor Plugins](https://capacitorjs.com/docs/plugins)
- [Ionic Forum](https://forum.ionicframework.com)
