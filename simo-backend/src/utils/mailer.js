const nodemailer = require('nodemailer');

// Configuración de Gmail ULTRA-COMPATIBLE para Railway
const transporter = nodemailer.createTransport({
  host: '74.125.141.108', // IP directa de smtp.gmail.com (IPv4) para evitar fallos de red
  port: 587,
  secure: false,
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASS,
  },
  tls: {
    rejectUnauthorized: false,
    servername: 'smtp.gmail.com' // Necesario al usar la IP directa
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
