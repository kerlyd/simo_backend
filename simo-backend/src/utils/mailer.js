const nodemailer = require('nodemailer');

// Configuración de Gmail FORZANDO IPv4 (family: 4) para evitar errores en Railway
const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 587,
  secure: false,
  family: 4, // <--- ESTO OBLIGA A USAR IPv4 Y EVITA EL ERROR ENETUNREACH
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASS,
  },
  tls: {
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
    console.log('Correo enviado correctamente (Gmail IPv4):', info.messageId);
    return info;
  } catch (error) {
    console.error('Error detallado de Gmail:', error);
    throw error;
  }
}

module.exports = { enviarCorreo };
