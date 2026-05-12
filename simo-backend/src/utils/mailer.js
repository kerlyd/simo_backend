const { Resend } = require('resend');

// Usamos Resend por API (HTTP) porque Railway bloquea los puertos de correo (SMTP)
// Usaremos la API KEY de Resend que ya tenías o una de prueba
const resend = new Resend(process.env.RESEND_API_KEY || 're_dYLJ8m8h_CwDTvYJHsd4knTikDhnCtLg2');

/**
 * Envía un correo electrónico usando la API de Resend
 */
async function enviarCorreo(to, subject, html) {
  try {
    console.log('Solicitando envío a Resend API...');
    const data = await resend.emails.send({
      from: 'SIMÖ <onboarding@resend.dev>', // Dominio de prueba de Resend que SIEMPRE funciona
      to: to,
      subject: subject,
      html: html,
    });
    
    console.log('Respuesta de Resend:', data);
    return data;
  } catch (error) {
    console.error('Error detallado de Resend API:', error);
    throw error;
  }
}

module.exports = { enviarCorreo };
