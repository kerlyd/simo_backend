const pool = require('../db/pool');

// ─── GET /api/puntos-reciclaje ─────────────────────────
async function getPuntos(req, res) {
  try {
    const resultado = await pool.query(
      `SELECT id, nombre, direccion, latitud, longitud, activo
       FROM punto_reciclaje
       WHERE activo = true
       ORDER BY nombre`
    );
    res.json({ puntos: resultado.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

module.exports = { getPuntos };
