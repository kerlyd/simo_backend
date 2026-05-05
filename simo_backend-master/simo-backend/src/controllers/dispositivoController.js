const pool = require('../db/pool');

// ─── GET /api/dispositivos/tipos ───────────────────────
async function getTipos(req, res) {
  try {
    const resultado = await pool.query(
      'SELECT id, nombre, descripcion, puntos FROM dispositivo_tipo ORDER BY nombre'
    );
    res.json({ tipos: resultado.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

module.exports = { getTipos };
