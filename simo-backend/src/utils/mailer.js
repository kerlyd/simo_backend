const { TransactionalEmailsApi, SendSmtpEmail, TransactionalEmailsApiApiKeys } = require('@getbrevo/brevo');

/**
 * Envía un correo electrónico usando Brevo (v5)
 */
async function enviarCorreo(to, subject, html) {
  const apiInstance = new TransactionalEmailsApi();
  
  // Configuración de la API Key
  apiInstance.setApiKey(TransactionalEmailsApiApiKeys.apiKey, process.env.BREVO_API_KEY);

  const sendSmtpEmail = new SendSmtpEmail();

  sendSmtpEmail.subject = subject;
  sendSmtpEmail.htmlContent = html;
  sendSmtpEmail.sender = { name: "SIMÖ", email: "simoappoficina@gmail.com" };
  sendSmtpEmail.to = [{ email: to }];

  try {
    const data = await apiInstance.sendTransacEmail(sendSmtpEmail);
    console.log('Correo enviado correctamente (Brevo):', data.body.messageId);
    return data;
  } catch (error) {
    console.error('Error detallado de Brevo:', error.response ? error.response.body : error);
    throw error;
  }
}

module.exports = { enviarCorreo };
