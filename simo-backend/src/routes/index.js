// ─── Auth ──────────────────────────────────────────────
const express = require('express');
const authRouter = express.Router();
const { register, login, recuperarPassword, resetRedirect, resetPassword } = require('../controllers/authController');
authRouter.post('/register', register);
authRouter.post('/login', login);
authRouter.post('/recuperar', recuperarPassword);
authRouter.get('/reset-redirect', resetRedirect);
authRouter.post('/reset-password', resetPassword);

// ─── Usuario ───────────────────────────────────────────
const usuarioRouter = express.Router();
const { getMe, updateMe } = require('../controllers/usuarioController');
usuarioRouter.get('/me', getMe);
usuarioRouter.put('/me', updateMe);

// ─── Dispositivos ──────────────────────────────────────
const dispositivoRouter = express.Router();
const { getTipos } = require('../controllers/dispositivoController');
dispositivoRouter.get('/tipos', getTipos);

// ─── Puntos de reciclaje ───────────────────────────────
const puntosRouter = express.Router();
const { getPuntos } = require('../controllers/puntoReciclajeController');
puntosRouter.get('/', getPuntos);

// ─── Solicitudes ───────────────────────────────────────
const solicitudRouter = express.Router();
const { crearSolicitud, getSolicitud, cancelarSolicitud, getHistorial, completarSolicitud } = require('../controllers/solicitudController');
solicitudRouter.post('/', crearSolicitud);
solicitudRouter.get('/', getHistorial);
solicitudRouter.get('/:id', getSolicitud);
solicitudRouter.delete('/:id', cancelarSolicitud);
solicitudRouter.put('/:id/completar', completarSolicitud);

// ─── Recompensas ───────────────────────────────────────
const recompensaRouter = express.Router();
const { getRecompensas, canjearRecompensa } = require('../controllers/recompensaController');
recompensaRouter.get('/', getRecompensas);
recompensaRouter.post('/:id/canjear', canjearRecompensa);

// ─── Notificaciones ────────────────────────────────────
const notificacionRouter = express.Router();
const { getNotificaciones, marcarLeida } = require('../controllers/notificacionController');
notificacionRouter.get('/', getNotificaciones);
notificacionRouter.put('/:id/leer', marcarLeida);

module.exports = {
  authRouter,
  usuarioRouter,
  dispositivoRouter,
  puntosRouter,
  solicitudRouter,
  recompensaRouter,
  notificacionRouter,
};
