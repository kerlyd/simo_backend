require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { verificarToken } = require('./middlewares/auth');
const {
  authRouter,
  usuarioRouter,
  dispositivoRouter,
  puntosRouter,
  solicitudRouter,
  recompensaRouter,
  notificacionRouter,
} = require('./routes/index');

const app = express();

// ── Middlewares globales ──────────────────────────────
app.use(cors());
app.use(express.json());

// ── Rutas públicas (sin token) ────────────────────────
app.use('/api/auth', authRouter);

// ── Rutas protegidas (requieren token JWT) ────────────
app.use('/api/usuario',         verificarToken, usuarioRouter);
app.use('/api/dispositivos',    verificarToken, dispositivoRouter);
app.use('/api/puntos-reciclaje',verificarToken, puntosRouter);
app.use('/api/solicitudes',     verificarToken, solicitudRouter);
app.use('/api/recompensas',     verificarToken, recompensaRouter);
app.use('/api/notificaciones',  verificarToken, notificacionRouter);

// ── Ruta de salud ─────────────────────────────────────
app.get('/', (req, res) => {
  res.json({ mensaje: '🌱 SIMÖ API funcionando correctamente' });
});

// ── Iniciar servidor ──────────────────────────────────
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 SIMÖ Backend corriendo en http://192.168.1.4:${PORT}`);
  console.log(`📋 Endpoints disponibles:`);
  console.log(`   POST /api/auth/register`);
  console.log(`   POST /api/auth/login`);
  console.log(`   GET  /api/usuario/me`);
  console.log(`   PUT  /api/usuario/me`);
  console.log(`   GET  /api/dispositivos/tipos`);
  console.log(`   GET  /api/puntos-reciclaje`);
  console.log(`   POST /api/solicitudes`);
  console.log(`   GET  /api/solicitudes`);
  console.log(`   GET  /api/solicitudes/:id`);
  console.log(`   DELETE /api/solicitudes/:id`);
  console.log(`   GET  /api/recompensas`);
  console.log(`   POST /api/recompensas/:id/canjear`);
  console.log(`   GET  /api/notificaciones`);
});
