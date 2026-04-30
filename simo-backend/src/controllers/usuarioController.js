const pool = require('../db/pool');

// ─── GET /api/usuario/me ───────────────────────────────
async function getMe(req, res) {
  try {
    const resultado = await pool.query(
      `SELECT id, nombre, email, cedula, telefono, direccion, puntos_verdes, rol, created_at
       FROM usuario WHERE id = $1`,
      [req.usuario.id]
    );

    if (resultado.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json({ usuario: resultado.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

// ─── PUT /api/usuario/me ───────────────────────────────
async function updateMe(req, res) {
  const { nombre, telefono, direccion } = req.body;

  try {
    const resultado = await pool.query(
      `UPDATE usuario
       SET nombre    = COALESCE($1, nombre),
           telefono  = COALESCE($2, telefono),
           direccion = COALESCE($3, direccion)
       WHERE id = $4
       RETURNING id, nombre, email, cedula, telefono, direccion, puntos_verdes, rol`,
      [nombre, telefono, direccion, req.usuario.id]
    );

    res.json({ usuario: resultado.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

module.exports = { getMe, updateMe };
