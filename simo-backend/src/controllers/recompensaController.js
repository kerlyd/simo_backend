const pool = require('../db/pool');

// ─── GET /api/recompensas ──────────────────────────────
async function getRecompensas(req, res) {
  try {
    const resultado = await pool.query(
      `SELECT id, nombre, descripcion, puntos_requeridos, activo
       FROM recompensa
       WHERE activo = true
       ORDER BY puntos_requeridos ASC`
    );
    res.json({ recompensas: resultado.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

// ─── POST /api/recompensas/:id/canjear ────────────────
async function canjearRecompensa(req, res) {
  const { id } = req.params;

  try {
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // Obtener puntos del usuario y la recompensa
      const usuarioResult = await client.query('SELECT puntos_verdes FROM usuario WHERE id = $1', [req.usuario.id]);
      const recompensaResult = await client.query('SELECT * FROM recompensa WHERE id = $1 AND activo = true', [id]);

      if (recompensaResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ error: 'Recompensa no encontrada' });
      }

      const puntosUsuario = usuarioResult.rows[0].puntos_verdes;
      const recompensa = recompensaResult.rows[0];

      // Verificar si tiene suficientes puntos
      if (puntosUsuario < recompensa.puntos_requeridos) {
        await client.query('ROLLBACK');
        return res.status(400).json({
          error: 'Puntos insuficientes',
          puntos_actuales: puntosUsuario,
          puntos_requeridos: recompensa.puntos_requeridos,
        });
      }

      // Registrar el canje
      const canjeResult = await client.query(
        `INSERT INTO canje_recompensa (usuario_id, recompensa_id, estado)
         VALUES ($1, $2, 'completado')
         RETURNING *`,
        [req.usuario.id, id]
      );

      // Descontar puntos
      await client.query(
        `UPDATE usuario SET puntos_verdes = puntos_verdes - $1 WHERE id = $2`,
        [recompensa.puntos_requeridos, req.usuario.id]
      );

      // Crear notificacion de canje
      await client.query(
        `INSERT INTO notificacion (usuario_id, titulo, mensaje) VALUES ($1, $2, $3)`,
        [req.usuario.id, '¡Canje Exitoso!', `Has canjeado tu recompensa: ${recompensa.nombre} por ${recompensa.puntos_requeridos} puntos.`]
      );

      await client.query('COMMIT');

      res.status(201).json({
        mensaje: '¡Recompensa canjeada exitosamente!',
        canje: canjeResult.rows[0],
      });
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

module.exports = { getRecompensas, canjearRecompensa };
