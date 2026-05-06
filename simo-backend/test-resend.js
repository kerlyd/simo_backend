/**
 * test-resend.js
 * Prueba el envío real de correo con Resend + el token JWT de reset.
 * Ejecutar: node test-resend.js tu_correo@ejemplo.com
 */
require('dotenv').config();
const { Resend } = require('resend');
const jwt = require('jsonwebtoken');

const resend = new Resend(process.env.RESEND_API_KEY);
const JWT_SECRET = process.env.JWT_SECRET || 'clave_secreta_de_prueba_simo_2026';
const BASE_URL   = process.env.BASE_URL || 'http://192.168.1.4:3000';

async function main() {
  const emailDestino = process.argv[2];
  if (!emailDestino) {
    console.error('\n❌ Uso: node test-resend.js tu_correo@ejemplo.com\n');
    process.exit(1);
  }

  console.log('\n══════════════════════════════════════════════════');
  console.log('  🧪 PRUEBA REAL con Resend — Recuperación SIMÖ');
  console.log('══════════════════════════════════════════════════\n');

  // Generar token JWT de prueba
  const resetToken = jwt.sign(
    { id: 99, tipo: 'reset' },
    JWT_SECRET,
    { expiresIn: '15m' }
  );

  const enlace = `${BASE_URL}/api/auth/reset-redirect?token=${resetToken}`;

  console.log(`📧 Enviando correo a: ${emailDestino}`);
  console.log(`🔑 Token generado: ${resetToken.substring(0, 40)}...`);

  const { data, error } = await resend.emails.send({
    from: 'SIMÖ <onboarding@resend.dev>',
    to: emailDestino,
    subject: '🔑 Recupera tu contraseña en SIMÖ',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 480px; margin: 0 auto; padding: 24px; background: #f7f4ec; border-radius: 12px;">
        <h1 style="color: #db007f; text-align: center; font-size: 28px; margin-bottom: 8px;">SIMÖ</h1>
        <h2 style="color: #333; text-align: center; font-size: 20px;">Recupera tu contraseña</h2>
        <p style="color: #555; font-size: 15px;">Hola <strong>UsuarioPrueba</strong>,</p>
        <p style="color: #555; font-size: 15px;">Recibimos una solicitud para restablecer tu contraseña. Toca el botón para continuar:</p>
        <div style="text-align: center; margin: 32px 0;">
          <a href="${enlace}" style="background: #db007f; color: white; padding: 14px 32px; border-radius: 10px; text-decoration: none; font-size: 16px; font-weight: bold;">
            Restablecer contraseña
          </a>
        </div>
        <p style="color: #888; font-size: 13px; text-align: center;">Este enlace expira en <strong>15 minutos</strong>.</p>
        <p style="color: #888; font-size: 13px; text-align: center;">Si no solicitaste esto, puedes ignorar este correo.</p>
      </div>
    `,
  });

  if (error) {
    console.error('\n❌ Error al enviar:', error);
    return;
  }

  console.log('\n✅ ¡Correo enviado exitosamente!');
  console.log(`   ID del mensaje: ${data.id}`);
  console.log('\n📬 Revisa tu bandeja de entrada (o spam).');
  console.log('   Al hacer clic en el botón del correo, el backend te redirigirá a:');
  console.log(`   simo://reset-password?token=<TOKEN>\n`);
}

main().catch(err => console.error('Error inesperado:', err));
