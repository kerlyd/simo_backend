const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../db/pool');
const { enviarCorreo } = require('../utils/mailer');

// ─── Configuración de Correo (Gmail) ────────────────────────
// Se maneja a través de src/utils/mailer.js

// ─── POST /api/auth/register ───────────────────────────
async function register(req, res) {
  const { nombre, email, password, cedula, telefono, direccion, genero } = req.body;

  if (!nombre || !email || !password || !cedula) {
    return res.status(400).json({ error: 'nombre, email, password y cedula son obligatorios' });
  }

  try {
    // Verificar si el email o el nombre ya existen
    const existe = await pool.query(
      'SELECT id FROM usuario WHERE email = $1 OR nombre = $2',
      [email, nombre]
    );

    if (existe.rows.length > 0) {
      const u = existe.rows[0];
      if (u.email === email) {
        return res.status(409).json({ error: 'El email ya está registrado' });
      }
      return res.status(409).json({ error: 'El nombre de usuario ya está registrado' });
    }

    const hash = await bcrypt.hash(password, 10);

    const resultado = await pool.query(
      `INSERT INTO usuario (nombre, email, password, cedula, telefono, direccion, rol, genero)
       VALUES ($1, $2, $3, $4, $5, $6, 'reciclador', $7)
       RETURNING id, nombre, email, cedula, telefono, direccion, puntos_verdes, rol, genero, created_at`,
      [nombre, email, hash, cedula, telefono || null, direccion || null, genero || 'hombre']
    );

    const usuario = resultado.rows[0];
    const token = jwt.sign(
      { id: usuario.id, email: usuario.email, rol: usuario.rol },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    res.status(201).json({ token, usuario });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

// ─── POST /api/auth/login ──────────────────────────────
async function login(req, res) {
  const { nombre, password } = req.body;

  if (!nombre || !password) {
    return res.status(400).json({ error: 'nombre y password son obligatorios' });
  }

  try {
    const resultado = await pool.query('SELECT * FROM usuario WHERE nombre = $1', [nombre]);

    if (resultado.rows.length === 0) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    const usuario = resultado.rows[0];
    const passwordValido = await bcrypt.compare(password, usuario.password);

    if (!passwordValido) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    const token = jwt.sign(
      { id: usuario.id, email: usuario.email, rol: usuario.rol },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    const { password: _, ...usuarioSinPassword } = usuario;

    res.json({ token, usuario: usuarioSinPassword });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

// ─── POST /api/auth/recuperar ──────────────────────────
// Verifica que el email exista, genera un token de reset y envía el correo
async function recuperarPassword(req, res) {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ error: 'El correo electrónico es obligatorio' });
  }

  try {
    // Verificar que el usuario exista con ese email
    const resultado = await pool.query(
      'SELECT id, nombre FROM usuario WHERE email = $1',
      [email]
    );

    if (resultado.rows.length === 0) {
      // Por seguridad respondemos igual aunque no exista
      return res.json({ message: 'Si ese correo está registrado, recibirás un enlace.' });
    }

    const usuario = resultado.rows[0];

    // Generar token JWT de corta duración (15 minutos) para el reset
    const resetToken = jwt.sign(
      { id: usuario.id, tipo: 'reset' },
      process.env.JWT_SECRET,
      { expiresIn: '15m' }
    );

    // URL pública del backend (ajusta si tu servidor tiene otra IP/dominio)
    const BASE_URL = process.env.BASE_URL || `http://192.168.1.4:${process.env.PORT || 3000}`;
    const enlace = `${BASE_URL}/api/auth/reset-redirect?token=${resetToken}`;

    // Enviar el correo con Gmail (Nodemailer)
    try {
      await enviarCorreo(
        email,
        '🔑 Recupera tu contraseña en SIMÖ',
        `
        <div style="font-family: Arial, sans-serif; max-width: 480px; margin: 0 auto; padding: 24px; background: #f7f4ec; border-radius: 12px;">
          <h1 style="color: #db007f; text-align: center; font-size: 28px; margin-bottom: 8px;">SIMÖ</h1>
          <h2 style="color: #333; text-align: center; font-size: 20px;">Recupera tu contraseña</h2>
          <p style="color: #555; font-size: 15px;">Hola <strong>${usuario.nombre}</strong>,</p>
          <p style="color: #555; font-size: 15px;">Recibimos una solicitud para restablecer tu contraseña. Toca el botón para continuar:</p>
          <div style="text-align: center; margin: 32px 0;">
            <a href="${enlace}" style="background: #db007f; color: white; padding: 14px 32px; border-radius: 10px; text-decoration: none; font-size: 16px; font-weight: bold;">
              Restablecer contraseña
            </a>
          </div>
          <p style="color: #888; font-size: 13px; text-align: center;">Este enlace expira en <strong>15 minutos</strong>.</p>
          <p style="color: #888; font-size: 13px; text-align: center;">Si no solicitaste esto, puedes ignorar este correo.</p>
        </div>
      `
      );
    } catch (mailError) {
      console.error('Error enviando el correo:', mailError);
      throw mailError;
    }

    res.json({ message: 'Si ese correo está registrado, recibirás un enlace.' });
  } catch (err) {
    console.error('Error en recuperarPassword:', err);
    res.status(500).json({ error: 'Error al procesar la solicitud' });
  }
}

// ─── GET /api/auth/reset-redirect ─────────────────────
// Redirige al deep link de la app con el token
function resetRedirect(req, res) {
  const { token } = req.query;

  if (!token) {
    return res.status(400).send(`
      <html><body style="font-family:Arial;text-align:center;padding:40px">
        <h2 style="color:#db007f">Enlace inválido</h2>
        <p>El enlace de recuperación no es válido o ha expirado.</p>
      </body></html>
    `);
  }

  // Verificar que el token sea válido antes de redirigir
  try {
    jwt.verify(token, process.env.JWT_SECRET);
  } catch (err) {
    return res.status(400).send(`
      <html><body style="font-family:Arial;text-align:center;padding:40px">
        <h2 style="color:#db007f">Enlace expirado</h2>
        <p>Este enlace ha expirado o ya fue utilizado. Solicita uno nuevo desde la app.</p>
      </body></html>
    `);
  }

  // Redirigir al deep link de la app Flutter
  const deepLink = `simo://reset-password?token=${token}`;
  res.redirect(deepLink);
}

// ─── POST /api/auth/reset-password ────────────────────
// Valida el token y actualiza la contraseña en la BD
async function resetPassword(req, res) {
  const { token, newPassword } = req.body;

  if (!token || !newPassword) {
    return res.status(400).json({ error: 'token y newPassword son obligatorios' });
  }

  if (newPassword.length < 6) {
    return res.status(400).json({ error: 'La contraseña debe tener al menos 6 caracteres' });
  }

  try {
    // Verificar y decodificar el token
    let payload;
    try {
      payload = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
      return res.status(401).json({ error: 'El enlace ha expirado o no es válido. Solicita uno nuevo.' });
    }

    if (payload.tipo !== 'reset') {
      return res.status(401).json({ error: 'Token inválido' });
    }

    // Hashear la nueva contraseña
    const hash = await bcrypt.hash(newPassword, 10);

    // Actualizar en la BD
    const resultado = await pool.query(
      'UPDATE usuario SET password = $1 WHERE id = $2 RETURNING id, nombre, email',
      [hash, payload.id]
    );

    if (resultado.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json({ message: 'Contraseña actualizada correctamente' });
  } catch (err) {
    console.error('Error en resetPassword:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}

module.exports = { register, login, recuperarPassword, resetRedirect, resetPassword };
