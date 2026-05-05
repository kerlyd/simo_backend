# 🌱 SIMÖ Backend — Node.js + Express + PostgreSQL

## Estructura
```
simo-backend/
├── src/
│   ├── index.js                        ← Entrada principal
│   ├── db/pool.js                      ← Conexión PostgreSQL
│   ├── middlewares/auth.js             ← Verificación JWT
│   ├── routes/index.js                 ← Todas las rutas
│   └── controllers/
│       ├── authController.js           ← Login y registro
│       ├── usuarioController.js        ← Perfil
│       ├── dispositivoController.js    ← Tipos de dispositivo
│       ├── puntoReciclajeController.js ← Puntos de reciclaje
│       ├── solicitudController.js      ← Solicitudes
│       ├── recompensaController.js     ← Recompensas y canje
│       └── notificacionController.js   ← Notificaciones
├── .env                                ← Variables de entorno
└── package.json
```

## Instalación y arranque

### 1. Instalar Node.js
https://nodejs.org (versión LTS)

### 2. Instalar dependencias
```bash
cd simo-backend
npm install
```

### 3. Configurar .env
```env
DB_PASSWORD=tu_contraseña_de_postgres
JWT_SECRET=cualquier_texto_largo_y_secreto
```

### 4. Correr el servidor
```bash
npm run dev
```

---

## Endpoints completos

### Públicos (sin token)
| Método | Ruta | Body |
|--------|------|------|
| POST | `/api/auth/register` | nombre, email, password, cedula |
| POST | `/api/auth/login` | email, password |

### Protegidos (Header: `Authorization: Bearer <token>`)
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/usuario/me` | Perfil del usuario |
| PUT | `/api/usuario/me` | Actualizar perfil |
| GET | `/api/dispositivos/tipos` | Tipos de dispositivo |
| GET | `/api/puntos-reciclaje` | Puntos activos |
| POST | `/api/solicitudes` | Crear solicitud |
| GET | `/api/solicitudes` | Historial de solicitudes |
| GET | `/api/solicitudes/:id` | Ver solicitud |
| DELETE | `/api/solicitudes/:id` | Cancelar solicitud |
| GET | `/api/recompensas` | Listar recompensas |
| POST | `/api/recompensas/:id/canjear` | Canjear recompensa |
| GET | `/api/notificaciones` | Ver notificaciones |
| PUT | `/api/notificaciones/:id/leer` | Marcar como leída |

---

## Conexión con Flutter (Dio)

```dart
// En tu datasource, la baseUrl es:
// Emulador Android  → http://10.0.2.2:3000
// Celular físico    → http://IP_DE_TU_PC:3000
// Producción        → https://tu-dominio.com

final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000'));

// Agregar token en cada petición
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  },
));
```
