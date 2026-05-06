/**
 * test-recuperacion.js
 * 
 * Script de prueba del flujo completo de recuperación de contraseña.
 * Usa Ethereal (SMTP falso de Nodemailer) y simula la BD con datos en memoria.
 * No requiere PostgreSQL ni Gmail reales.
 * 
 * Ejecutar con: node test-recuperacion.js
 */

const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');

// ── Configuración de prueba ───────────────────────────────
const JWT_SECRET = 'clave_secreta_de_prueba_simo_2026';
const BASE_URL   = 'http://192.168.1.4:3000';

// ── Base de datos simulada en memoria ────────────────────
const usuariosFalsos = [
  {
    id: 1,
    nombre: 'UsuarioPrueba',
    email: 'usuario@test.com',
    password: bcrypt.hashSync('password123', 10),
  },
];

function buscarPorEmail(email) {
  return usuariosFalsos.find(u => u.email === email) || null;
}

function actualizarPassword(id, hashNuevo) {
  const u = usuariosFalsos.find(u => u.id === id);
  if (u) u.password = hashNuevo;
  return u;
}

// ── Helpers ───────────────────────────────────────────────
function generarResetToken(userId) {
  return jwt.sign({ id: userId, tipo: 'reset' }, JWT_SECRET, { expiresIn: '15m' });
}

function verificarResetToken(token) {
  return jwt.verify(token, JWT_SECRET);
}

// ── PRUEBA ────────────────────────────────────────────────
async function correrPrueba() {
  console.log('\n═══════════════════════════════════════════════');
  console.log('   🧪 PRUEBA: Recuperación de contraseña SIMÖ');
  console.log('═══════════════════════════════════════════════\n');

  // ── PASO 1: Crear cuenta Ethereal (SMTP de prueba) ─────
  console.log('📧 PASO 1: Creando cuenta de correo de prueba (Ethereal)...');
  const cuentaPrueba = await nodemailer.createTestAccount();
  console.log(`   ✅ Cuenta creada: ${cuentaPrueba.user}`);

  const transporter = nodemailer.createTransport({
    host: 'smtp.ethereal.email',
    port: 587,
    secure: false,
    auth: {
      user: cuentaPrueba.user,
      pass: cuentaPrueba.pass,
    },
  });

  // ── PASO 2: Simular POST /api/auth/recuperar ───────────
  const emailDelUsuario = 'usuario@test.com';
  console.log(`\n🔍 PASO 2: Buscando usuario con email "${emailDelUsuario}"...`);

  const usuario = buscarPorEmail(emailDelUsuario);
  if (!usuario) {
    console.log('   ❌ Usuario no encontrado en la BD');
    return;
  }
  console.log(`   ✅ Usuario encontrado: ${usuario.nombre} (id=${usuario.id})`);

  // ── PASO 3: Generar token JWT de reset ────────────────
  console.log('\n🔑 PASO 3: Generando token JWT de recuperación (válido 15 min)...');
  const resetToken = generarResetToken(usuario.id);
  console.log(`   ✅ Token generado: ${resetToken.substring(0, 40)}...`);

  const enlace = `${BASE_URL}/api/auth/reset-redirect?token=${resetToken}`;
  const deepLink = `simo://reset-password?token=${resetToken}`;

  // ── PASO 4: Enviar correo con Ethereal ───────────────
  console.log('\n📨 PASO 4: Enviando correo de recuperación...');
  const info = await transporter.sendMail({
    from: '"SIMÖ App" <simo@test.com>',
    to: emailDelUsuario,
    subject: '🔑 Recupera tu contraseña en SIMÖ',
    html: `
      <div style="font-family:Arial;max-width:480px;padding:24px;background:#f7f4ec;border-radius:12px;">
        <h1 style="color:#db007f;text-align:center">SIMÖ</h1>
        <p>Hola <strong>${usuario.nombre}</strong>,</p>
        <p>Toca el botón para restablecer tu contraseña:</p>
        <div style="text-align:center;margin:24px 0">
          <a href="${enlace}" style="background:#db007f;color:white;padding:14px 32px;border-radius:10px;text-decoration:none;font-weight:bold">
            Restablecer contraseña
          </a>
        </div>
        <p style="color:#888;font-size:13px;text-align:center">Expira en 15 minutos.</p>
      </div>
    `,
  });

  const urlPreview = nodemailer.getTestMessageUrl(info);
  console.log(`   ✅ Correo enviado exitosamente`);
  console.log(`   📬 Ver correo en el navegador: ${urlPreview}`);

  // ── PASO 5: Simular GET /api/auth/reset-redirect ──────
  console.log('\n🔗 PASO 5: Simulando clic en el enlace del correo...');
  try {
    const payload = verificarResetToken(resetToken);
    console.log(`   ✅ Token válido. UserId: ${payload.id}, Tipo: ${payload.tipo}`);
    console.log(`   ✅ La app recibiría el deep link: ${deepLink.substring(0, 60)}...`);
  } catch (err) {
    console.log(`   ❌ Token inválido: ${err.message}`);
    return;
  }

  // ── PASO 6: Simular POST /api/auth/reset-password ─────
  const nuevaPassword = 'NuevaPassword456';
  console.log(`\n🔐 PASO 6: Cambiando contraseña a "${nuevaPassword}"...`);

  let payload2;
  try {
    payload2 = verificarResetToken(resetToken);
    if (payload2.tipo !== 'reset') throw new Error('Tipo de token incorrecto');
  } catch (err) {
    console.log(`   ❌ Token rechazado: ${err.message}`);
    return;
  }

  const hashNuevo = await bcrypt.hash(nuevaPassword, 10);
  const usuarioActualizado = actualizarPassword(payload2.id, hashNuevo);
  console.log(`   ✅ Contraseña actualizada en BD para: ${usuarioActualizado.nombre}`);

  // ── PASO 7: Verificar que la nueva contraseña funciona
  console.log('\n✔️  PASO 7: Verificando que la nueva contraseña funciona en login...');
  const loginOk = await bcrypt.compare(nuevaPassword, usuarioActualizado.password);
  const loginViejo = await bcrypt.compare('password123', usuarioActualizado.password);
  console.log(`   Login con nueva contraseña "${nuevaPassword}": ${loginOk ? '✅ OK' : '❌ FALLO'}`);
  console.log(`   Login con contraseña antigua "password123": ${loginViejo ? '❌ FALLO (debería ser rechazada)' : '✅ Rechazada correctamente'}`);

  // ── RESULTADO FINAL ───────────────────────────────────
  console.log('\n═══════════════════════════════════════════════');
  if (loginOk && !loginViejo) {
    console.log('   🎉 TODAS LAS PRUEBAS PASARON EXITOSAMENTE');
  } else {
    console.log('   ❌ ALGUNAS PRUEBAS FALLARON');
  }
  console.log('═══════════════════════════════════════════════');
  console.log('\n📬 Abre esta URL para ver el correo enviado:');
  console.log(`   ${urlPreview}\n`);
}

correrPrueba().catch(err => {
  console.error('\n❌ Error durante la prueba:', err.message);
});
