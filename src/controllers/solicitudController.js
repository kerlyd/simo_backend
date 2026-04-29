const pool = require('../db/pool');

// ─── POST /api/solicitudes ─────────────────────────────
async function crearSolicitud(req, res) {
  const { dispositivo_tipo_id, punto_reciclaje_id, metodo_entrega } = req.body;

  if (!dispositivo_tipo_id || !punto_reciclaje_id || !metodo_entrega) {
    return res.status(400).json({ error: 'dispositivo_tipo_id, punto_reciclaje_id y metodo_entrega son obligatorios' });
  }

  try {
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // 1. Insertar solicitud
      const resultado = await client.query(
        `INSERT INTO solicitud (usuario_id, dispositivo_tipo_id, punto_reciclaje_id, metodo_entrega, estado)
         VALUES ($1, $2, $3, $4, 'pendiente')
         RETURNING *`,
        [req.usuario.id, dispositivo_tipo_id, punto_reciclaje_id, metodo_entrega]
      );

      // 2. Obtener puntos y nombre del dispositivo
      const dispRes = await client.query(
        'SELECT puntos, nombre FROM dispositivo_tipo WHERE id = $1',
        [dispositivo_tipo_id]
      );

      if (dispRes.rows.length === 0) {
        throw new Error('Tipo de dispositivo no válido');
      }

      const puntosParaSumar = dispRes.rows[0].puntos || 0;
      const nombreDispositivo = dispRes.rows[0].nombre || 'dispositivo';

      // 3. Sumar puntos al usuario
      await client.query(
        'UPDATE usuario SET puntos_verdes = puntos_verdes + $1 WHERE id = $2',
        [puntosParaSumar, req.usuario.id]
      );

      // 4. Crear notificacion
      await client.query(
        `INSERT INTO notificacion (usuario_id, titulo, mensaje) VALUES ($1, $2, $3)`,
        [req.usuario.id, '¡Reciclaje Exitoso!', `Has sumado ${puntosParaSumar} puntos verdes a tu cuenta por reciclar tu ${nombreDispositivo}. ¡Sigue así!`]
      );

      await client.query('COMMIT');
      res.status(201).json({ 
        solicitud: resultado.rows[0],
        puntos_ganados: puntosParaSumar
      });
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor o dispositivo inválido' });
  }
}

// ─── GET /api/solicitudes/:id ──────────────────────────
async function getSolicitud(req, res) {
  const { id } = req.params;

  try {
    const resultado = await pool.query(
      `SELECT s.*, 
              d.nombre as dispositivo_nombre,
              d.puntos,
              p.nombre as punto_nombre,
              p.direccion as punto_direccion
       FROM solicitud s
       JOIN dispositivo_tipo d ON s.dispositivo_tipo_id = d.id
       JOIN punto_reciclaje p ON s.punto_reciclaje_id = p.id
       WHERE s.id = $1 AND s.usuario_id = $2`,
      [id, req.usuario.id]
    );

    if (resultado.rows.length === 0) {
      return res.status(404).json({ error: 'Solicitud no encontrada' });
    }

    res.json({ solicitud: resultado.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

// ─── DELETE /api/solicitudes/:id ───────────────────────
async function cancelarSolicitud(req, res) {
  const { id } = req.params;

  try {
    // Solo se puede cancelar si está en pendiente o enProceso
    const solicitud = await pool.query(
      `SELECT estado FROM solicitud WHERE id = $1 AND usuario_id = $2`,
      [id, req.usuario.id]
    );

    if (solicitud.rows.length === 0) {
      return res.status(404).json({ error: 'Solicitud no encontrada' });
    }

    const estado = solicitud.rows[0].estado;
    if (estado !== 'pendiente' && estado !== 'enProceso') {
      return res.status(400).json({ error: 'Solo puedes cancelar solicitudes en estado pendiente o enProceso' });
    }

    await pool.query(
      `UPDATE solicitud SET estado = 'cancelado' WHERE id = $1`,
      [id]
    );

    res.json({ mensaje: 'Solicitud cancelada exitosamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

// ─── GET /api/solicitudes (historial) ─────────────────
async function getHistorial(req, res) {
  try {
    const resultado = await pool.query(
      `SELECT s.*, 
              d.nombre as dispositivo_nombre,
              d.puntos,
              p.nombre as punto_nombre
       FROM solicitud s
       JOIN dispositivo_tipo d ON s.dispositivo_tipo_id = d.id
       JOIN punto_reciclaje p ON s.punto_reciclaje_id = p.id
       WHERE s.usuario_id = $1
       ORDER BY s.fecha_solicitud DESC`,
      [req.usuario.id]
    );

    res.json({ solicitudes: resultado.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

// ─── PUT /api/solicitudes/:id/completar ──────────────
async function completarSolicitud(req, res) {
  const { id } = req.params;
  try {
    await pool.query(`UPDATE solicitud SET estado = 'completo' WHERE id = $1`, [id]);
    res.json({ mensaje: 'Solicitud completada' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error del servidor' });
  }
}

module.exports = { crearSolicitud, getSolicitud, cancelarSolicitud, getHistorial, completarSolicitud };
