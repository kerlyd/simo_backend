const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../db/pool');

// ─── POST /api/auth/register ───────────────────────────
async function register(req, res) {
  const { nombre, email, password, cedula, telefono, direccion } = req.body;

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
      `INSERT INTO usuario (nombre, email, password, cedula, telefono, direccion, rol)
       VALUES ($1, $2, $3, $4, $5, $6, 'reciclador')
       RETURNING id, nombre, email, cedula, telefono, direccion, puntos_verdes, rol, created_at`,
      [nombre, email, hash, cedula, telefono || null, direccion || null]
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

module.exports = { register, login };
