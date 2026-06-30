# React Native — Aplicaciones Móviles con JavaScript/TypeScript

## Descripción General

React Native (Meta/Facebook) compila a componentes nativos reales (UIViews en iOS, Views en Android) mediante un **bridge** asíncrono entre JS y el hilo nativo. La nueva arquitectura usa **Fabric** (renderizador) + **TurboModules** (módulos nativos perezosos) para comunicación síncrona.

---

## Principios

- **Learn once, write anywhere**: React → móvil, web, escritorio.
- **Componentes nativos**: `<View>`, `<Text>`, `<FlatList>` → widgets nativos.
- **Fast Refresh**: Recarga instantánea preservando estado.
- **Code Push**: Actualización OTA (CodePush, EAS Update).

---

## Componentes Básicos

```tsx
import { View, Text, FlatList, TouchableOpacity, StyleSheet } from 'react-native';

interface Usuario { id: string; nombre: string; email: string; }

export default function ListaUsuarios({ usuarios }: { usuarios: Usuario[] }) {
  return (
    <View style={s.container}>
      <FlatList data={usuarios} keyExtractor={(u) => u.id}
        renderItem={({ item }) => (
          <TouchableOpacity style={s.card}>
            <Text style={s.nombre}>{item.nombre}</Text>
            <Text style={s.email}>{item.email}</Text>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}
const s = StyleSheet.create({ container: { flex: 1, padding: 16, backgroundColor: '#f5f5f5' }, card: { backgroundColor: '#fff', padding: 16, borderRadius: 8, marginBottom: 8, elevation: 2 }, nombre: { fontSize: 18, fontWeight: '600' }, email: { fontSize: 14, color: '#666' } });
```

---

## Navegación (React Navigation)

```tsx
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
type RootStack = { Home: undefined; Detail: { id: string } };
const Stack = createNativeStackNavigator<RootStack>();
// navigation.navigate('Detail', { id: '42' });
```

---

## Estado Global

### Context API

```tsx
const AuthContext = createContext<{ user: Usuario | null; login: (email: string, pass: string) => Promise<void> }>(null!);
export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<Usuario | null>(null);
  const login = async (email: string, pass: string) => { const r = await api.login(email, pass); setUser(r.user); };
  return <AuthContext.Provider value={{ user, login }}>{children}</AuthContext.Provider>;
}
```

### Redux Toolkit

```tsx
const usuarioSlice = createSlice({ name: 'usuario', initialState: { lista: [] as Usuario[], loading: false }, reducers: {}, extraReducers: (b) => { b.addCase(fetchUsuarios.fulfilled, (s, a) => { s.lista = a.payload; s.loading = false; }); } });
```

---

## Networking

```tsx
const api = axios.create({ baseURL: 'https://api.ejemplo.com', timeout: 10000 });
api.interceptors.request.use((c) => { const t = store.getState().auth.token; if (t) c.headers.Authorization = `Bearer ${t}`; return c; });
```

---

## APIs Nativas

```tsx
import { Platform, PermissionsAndroid } from 'react-native';
import Geolocation from '@react-native-community/geolocation';

export async function getPosition() {
  if (Platform.OS === 'android') await PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION);
  return new Promise((resolve, reject) => Geolocation.getCurrentPosition(
    (p) => resolve({ lat: p.coords.latitude, lng: p.coords.longitude }),
    (e) => reject(e), { enableHighAccuracy: true, timeout: 15000 }
  ));
}
```

---

## TurboModules

```kotlin
@ReactMethod fun getBatteryLevel(promise: Promise) {
    val m = reactApplicationContext.getSystemService(BATTERY_SERVICE) as BatteryManager
    promise.resolve(m.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY))
}
```

```tsx
const { BatteryModule } = NativeModules; const level = await BatteryModule.getBatteryLevel();
```

---

## Animaciones

```tsx
// Animated API
const opacity = useRef(new Animated.Value(0)).current;
useEffect(() => { Animated.timing(opacity, { toValue: 1, duration: 500, useNativeDriver: true }).start(); }, []);
return <Animated.View style={{ opacity }}>{children}</Animated.View>;

// Reanimated (moderno)
const offset = useSharedValue(0);
const style = useAnimatedStyle(() => ({ transform: [{ translateX: withSpring(offset.value * 255) }] }));
```

---

## Testing

```tsx
test('botón responde al clic', () => {
  const onPress = jest.fn();
  const { getByText } = render(<Button title="Presionar" onPress={onPress} />);
  fireEvent.press(getByText('Presionar')); expect(onPress).toHaveBeenCalled();
});
```

---

## Compilación

```bash
npx react-native build-android --mode=release     # Android
npx react-native build-ios --configuration=Release  # iOS
eas build --platform all --profile production        # Expo
```

---

## Expo

Framework acelerador con EAS Build (nube), EAS Update (OTA), Expo Go (test sin compilar), 100+ APIs pre-integradas.

```bash
npx create-expo-app@latest MiApp && cd MiApp && npx expo start
```

---

## Referencias

- [React Native Docs](https://reactnative.dev/docs)
- [Expo Docs](https://docs.expo.dev)
