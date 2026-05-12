const SibApiV3Sdk = require('@getbrevo/brevo');

/**
 * Envía un correo electrónico usando Brevo
 */
async function enviarCorreo(to, subject, html) {
  let apiInstance = new SibApiV3Sdk.TransactionalEmailsApi();

  // Configuración de la API Key
  apiInstance.setApiKey(SibApiV3Sdk.TransactionalEmailsApiApiKeys.apiKey, process.env.BREVO_API_KEY);

  let sendSmtpEmail = new SibApiV3Sdk.SendSmtpEmail();

  sendSmtpEmail.subject = subject;
  sendSmtpEmail.htmlContent = html;
  sendSmtpEmail.sender = { name: "SIMÖ", email: "simoappoficina@gmail.com" };
  sendSmtpEmail.to = [{ email: to }];

  try {
    const data = await apiInstance.sendTransacEmail(sendSmtpEmail);
    console.log('Correo enviado correctamente (Brevo):', data.response.statusCode);
    return data;
  } catch (error) {
    // Esto nos dará más detalle en los logs de Railway
    console.error('Error detallado de Brevo:', error.response ? error.response.body : error);
    throw error;
  }
}

module.exports = { enviarCorreo };
