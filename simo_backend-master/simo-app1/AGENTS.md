# SIMÖ — Guía para Agentes de IA

> **App:** SIMÖ — Reciclaje de dispositivos electrónicos en Medellín  
> **Stack:** Flutter 3.x · Riverpod · Dio · go_router · get_it · dartz  
> **Arquitectura:** Clean Architecture (sin features)  
> **Plataformas:** iOS y Android  

---

## ¿Qué hace esta app?

El usuario registra dispositivos electrónicos que quiere reciclar, elige un punto de reciclaje, y gana puntos verdes que puede canjear por recompensas. El flujo principal es:

```
Registrarse → Login → Elegir dispositivo → Elegir destino
→ Confirmar solicitud → Entregar → Ganar puntos → Canjear recompensa
```

Hay dos roles, pero el MVP solo implementa **RECICLADOR**. El rol **ALIADO_RECOLECTOR** es para versiones futuras.

---

## Estructura del proyecto

```
lib/
├── main.dart                  # Punto de entrada de la app
├── injection_container.dart   # Registro de dependencias con get_it
├── domain/
│   ├── entities/              # Clases Dart puras
│   ├── usecases/              # Una clase por acción
│   ├── repositories/          # Interfaces (abstract class)
│   └── failures/              # Clases de error
├── data/
│   ├── models/                # Entities + fromJson/toJson
│   ├── datasources/           # Llamadas HTTP con Dio
│   └── repositories/         # Implementación concreta
└── ui/
    ├── screens/               # Pantallas completas
    ├── providers/             # Notifiers de Riverpod
    └── widgets/               # Widgets reutilizables
```

---

## ¿Para qué sirve cada carpeta?

### `domain/` — El corazón de la app
Es Dart puro. No depende de Flutter, Dio, ni ningún paquete externo. Aquí vive la lógica de negocio.

**`entities/`** — Representan los datos principales de la app. Son clases simples sin `fromJson` ni `toJson`.

Ejemplos:
```dart
// usuario_entity.dart
class UsuarioEntity {
  final int id;
  final String nombre;
  final String email;
  final String cedula;
  final String telefono;
  final String direccion;
  final int puntosVerdes;

  const UsuarioEntity({
    required this.id,
    required this.nombre,
    required this.email,
    required this.cedula,
    required this.telefono,
    required this.direccion,
    required this.puntosVerdes,
  });
}
```

Entities principales:
- `usuario_entity.dart`
- `solicitud_entity.dart`
- `recompensa_entity.dart`
- `punto_reciclaje_entity.dart`
- `notificacion_entity.dart`

**`usecases/`** — Una clase por cada acción. Cada use case hace exactamente una sola cosa y retorna `Either<Failure, T>`.

```dart
// login_usecase.dart
class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<Either<Failure, UsuarioEntity>> call(String email, String password) {
    return _repo.login(email, password);
  }
}
```

Use cases principales:
- `login_usecase.dart`
- `register_usecase.dart`
- `get_recompensas_usecase.dart`
- `canjear_recompensa_usecase.dart`
- `crear_solicitud_usecase.dart`
- `cancelar_solicitud_usecase.dart`
- `get_notificaciones_usecase.dart`
- `get_historial_usecase.dart`
- `get_usuario_usecase.dart`
- `update_usuario_usecase.dart`

**`repositories/`** — Son interfaces (abstract class) que definen qué puede hacer cada repositorio. No tienen implementación.

```dart
// auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, UsuarioEntity>> login(String email, String password);
  Future<Either<Failure, UsuarioEntity>> register(RegisterParams params);
  Future<Either<Failure, void>> logout();
}
```

Repositories principales:
- `auth_repository.dart`
- `solicitud_repository.dart`
- `recompensa_repository.dart`
- `usuario_repository.dart`
- `notificacion_repository.dart`

**`failures/`** — Las clases de error de la app.

```dart
// failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure        extends Failure { const ServerFailure(super.message); }
class NetworkFailure       extends Failure { const NetworkFailure(super.message); }
class CacheFailure         extends Failure { const CacheFailure(super.message); }
class UnauthorizedFailure  extends Failure { const UnauthorizedFailure(super.message); }
class PuntosInsuficientesFailure extends Failure { const PuntosInsuficientesFailure(super.message); }
```

---

### `data/` — Obtención de datos
Aquí vive todo lo que tiene que ver con el backend y el almacenamiento local.

**`models/`** — Extienden las entities y agregan `fromJson`/`toJson` para convertir las respuestas del backend.

```dart
// usuario_model.dart
class UsuarioModel extends UsuarioEntity {
  const UsuarioModel({
    required super.id,
    required super.nombre,
    required super.email,
    required super.cedula,
    required super.telefono,
    required super.direccion,
    required super.puntosVerdes,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      cedula: json['cedula'],
      telefono: json['telefono'],
      direccion: json['direccion'],
      puntosVerdes: json['puntosVerdes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'email': email,
    'cedula': cedula,
    'telefono': telefono,
    'direccion': direccion,
    'puntosVerdes': puntosVerdes,
  };
}
```

**`datasources/`** — Hacen las llamadas HTTP con Dio. Es el único lugar que habla directamente con el backend.

```dart
// auth_remote_datasource.dart
abstract class AuthRemoteDataSource {
  Future<UsuarioModel> login(String email, String password);
  Future<UsuarioModel> register(RegisterParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UsuarioModel> login(String email, String password) async {
    final response = await _dio.post('/api/auth/login', data: {
      'email': email,
      'password': password,
    });
    return UsuarioModel.fromJson(response.data);
  }
}
```

**`repositories/`** — Implementación concreta de los repositorios definidos en `domain/`.

```dart
// auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UsuarioEntity>> login(String email, String password) async {
    try {
      final result = await _dataSource.login(email, password);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

### `ui/` — Lo que ve el usuario
Esta carpeta es responsabilidad del equipo de Crossmedia.

**`screens/`** — Pantallas completas de la app.

Pantallas principales:
- `splash_screen.dart`
- `onboarding_screen.dart`
- `rol_selection_screen.dart`
- `login_screen.dart`
- `register_screen.dart`
- `home_screen.dart`
- `opciones_screen.dart`
- `confirmar_solicitud_screen.dart`
- `detalle_solicitud_screen.dart`
- `canjear_screen.dart`
- `notificaciones_screen.dart`
- `historial_screen.dart`
- `usuario_screen.dart`
- `editar_info_screen.dart`

**`widgets/`** — Widgets reutilizables en varias pantallas.

Widgets principales:
- `simo_button.dart` — botón magenta principal
- `simo_header.dart` — header con logo y puntos
- `simo_bottom_nav.dart` — barra de navegación inferior
- `modal_confirmacion.dart` — modal de confirmación
- `estado_badge.dart` — badge de estado (amarillo/verde/rojo)
- `metodo_entrega_badge.dart` — badge "Lo recogemos" / "Lo llevas tú"
- `dispositivo_icon_card.dart` — card con ícono de dispositivo

**`providers/`** — Notifiers de Riverpod que conectan la UI con los usecases.

```dart
// auth_notifier.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await sl<LoginUseCase>()(email, password);
    state = result.fold(
      (failure) => AuthState.error(failure.message),
      (usuario) => AuthState.authenticated(usuario),
    );
  }
}
```

Providers principales:
- `auth_notifier.dart`
- `solicitud_notifier.dart`
- `recompensa_notifier.dart`
- `usuario_notifier.dart`
- `notificacion_notifier.dart`

---

## Colores y tipografía

| Nombre | Hex | Dónde se usa |
|---|---|---|
| `simoMagenta` | `#D8006B` | Primario: headers, botones, textos destacados |
| `simoAmarillo` | `#F5B800` | Puntos, badges activos, botón Confirmar |
| `simoAzul` | `#2D4EA2` | Fondos de pantallas internas |
| `simoCrudo` | `#F7F4EC` | Fondo de cards, Login, Registro |
| `simoVerde` | `#3AAA35` | Estado completo, impacto ambiental |
| `simoRojo` | `#E8003D` | Cancelar, solicitud cancelada |

**Tipografía:** Nunito. Títulos en bold magenta, cuerpo en oscuro sobre crudo.

---

## Navegación

Archivo: `lib/main.dart` o `lib/router.dart`

| Ruta | Pantalla | Acceso |
|---|---|---|
| `/` | SplashScreen | Público |
| `/onboarding` | OnboardingScreen | Público |
| `/rol` | RolSelectionScreen | Público |
| `/login` | LoginScreen | Público |
| `/register` | RegisterScreen | Público |
| `/home` | HomeScreen | Solo RECICLADOR |
| `/opciones` | OpcionesScreen | Solo RECICLADOR |
| `/opciones/confirmar` | ConfirmarSolicitudScreen | Solo RECICLADOR |
| `/canjear` | CanjearScreen | Solo RECICLADOR |
| `/notificaciones` | NotificacionesScreen | Solo RECICLADOR |
| `/usuario` | UsuarioScreen | Solo RECICLADOR |
| `/usuario/editar` | EditarInfoScreen | Solo RECICLADOR |

**Bottom nav bar:** Inicio · Opciones · Canjear · Usuario

---

## Reglas que siempre debes respetar

| Regla | Por qué |
|---|---|
| Las entities son Dart puro | No pueden tener `fromJson` ni depender de Dio o Flutter |
| Un use case = una sola acción | `LoginUseCase` solo hace login |
| Todos los use cases retornan `Either<Failure, T>` | Manejo de errores consistente |
| Un Notifier solo usa sus propios use cases | No mezclar lógica entre módulos |
| Solo `datasources/` habla con el backend | Ninguna otra capa hace llamadas HTTP |
| Archivos en snake_case, clases en PascalCase | Convenio de Flutter |

---

## Reglas de negocio críticas

| Regla | Descripción |
|---|---|
| Canje bloqueado | Solo se puede canjear si `puntosVerdes >= puntosRequeridos` |
| Confirmación obligatoria | Siempre mostrar modal antes de crear solicitud o canjear |
| Puntos diferidos | Los puntos se acumulan solo cuando el punto confirma la recepción |
| Cancelación condicional | Solo cancelar si la solicitud está en estado `pendiente` o `enProceso` |
| Botón Reciclar | Solo activo después de seleccionar un tipo de dispositivo |
| Color de estado | Amarillo = en proceso · Verde = completo · Rojo = cancelado |

---

## Endpoints del backend

| Método | Ruta | Descripción |
|---|---|---|
| POST | `/api/auth/login` | Iniciar sesión |
| POST | `/api/auth/register` | Registrarse |
| GET | `/api/usuario/me` | Obtener perfil |
| PUT | `/api/usuario/me` | Actualizar perfil |
| GET | `/api/dispositivos/tipos` | Tipos de dispositivo |
| GET | `/api/puntos-reciclaje` | Puntos de reciclaje |
| POST | `/api/solicitudes` | Crear solicitud |
| GET | `/api/solicitudes/:id` | Ver solicitud |
| DELETE | `/api/solicitudes/:id` | Cancelar solicitud |
| GET | `/api/recompensas` | Listar recompensas |
| POST | `/api/recompensas/:id/canjear` | Canjear recompensa |
| GET | `/api/notificaciones` | Ver notificaciones |

---

## Dependencias principales (pubspec.yaml)

```yaml
dependencies:
  flutter_riverpod:     ^2.4.0   # Estado
  riverpod_annotation:  ^2.3.0
  dio:                  ^5.4.0   # HTTP
  go_router:            ^13.0.0  # Navegación
  get_it:               ^7.6.0   # Inyección de dependencias
  dartz:                ^0.10.1  # Either / manejo de errores
  freezed_annotation:   ^2.4.0   # Modelos inmutables
  shared_preferences:   ^2.2.2   # Storage local (JWT)
  firebase_messaging:   ^14.7.0  # Notificaciones push
  google_fonts:         ^6.1.0   # Fuente Nunito
  intl:                 ^0.19.0  # Fechas
```

---

*SIMÖ — AGENTS.md · Arquitectura Limpia · Sprint 1 MVP*
