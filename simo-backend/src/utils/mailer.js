const nodemailer = require('nodemailer');

// Configuración de Gmail con Nodemailer
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASS, // La contraseña de aplicación de 16 letras
  },
});

/**
 * Envía un correo electrónico usando Gmail
 */
async function enviarCorreo(to, subject, html) {
  const mailOptions = {
    from: `"SIMÖ" <${process.env.GMAIL_USER}>`,
    to: to,
    subject: subject,
    html: html,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log('Correo enviado correctamente (Gmail):', info.messageId);
    return info;
  } catch (error) {
    console.error('Error detallado de Gmail:', error);
    throw error;
  }
}

module.exports = { enviarCorreo };
