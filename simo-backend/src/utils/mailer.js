const nodemailer = require('nodemailer');

// Configuración de Gmail más robusta para evitar errores de red en la nube
const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 587,
  secure: false, // false para puerto 587
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASS,
  },
  tls: {
    // Esto ayuda si hay problemas con IPv6 o certificados en el servidor
    rejectUnauthorized: false
  }
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
    console.log('Correo enviado correctamente (Gmail 587):', info.messageId);
    return info;
  } catch (error) {
    console.error('Error detallado de Gmail:', error);
    throw error;
  }
}

module.exports = { enviarCorreo };
