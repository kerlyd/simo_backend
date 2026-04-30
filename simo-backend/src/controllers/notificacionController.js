const pool = require('../db/pool');

// ─── GET /api/notificaciones ───────────────────────────
async function getNotificaciones(req, res) {
  try {
    const resultado = await pool.query(
      `SELECT id, titulo, mensaje, leido, fecha_envio
       FROM notificacion
       WHERE usuario_id = $1
       ORDER BY fecha_envio DESC`,
      [req.usuario.id]
    );

    res.json({ notificaciones: resultado.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

// ─── PUT /api/notificaciones/:id/leer ─────────────────
async function marcarLeida(req, res) {
  const { id } = req.params;

  try {
    await pool.query(
      `UPDATE notificacion SET leido = true WHERE id = $1 AND usuario_id = $2`,
      [id, req.usuario.id]
    );

    res.json({ mensaje: 'Notificación marcada como leída' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

module.exports = { getNotificaciones, marcarLeida };
