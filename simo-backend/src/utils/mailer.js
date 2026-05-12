/**
 * Envía un correo electrónico usando el Puente de Google Apps Script
 * Esto evita los bloqueos de puertos SMTP de Railway.
 */
async function enviarCorreo(to, subject, html) {
  const bridgeUrl = 'https://script.google.com/macros/s/AKfycbxqt9hneOkHvLHPj_Yxlh_egEJZWfibC1-UTHyq_tyb9tXZexOxCGe647KmnYPqvyxIlQ/exec';

  try {
    console.log('Enviando correo a través del Puente de Gmail...');
    
    const response = await fetch(bridgeUrl, {
      method: 'POST',
      body: JSON.stringify({
        to: to,
        subject: subject,
        html: html
      }),
      headers: {
        'Content-Type': 'application/json'
      },
      // Redirect follow es necesario para Apps Script
      redirect: 'follow'
    });

    const result = await response.text();
    console.log('Resultado del Puente de Gmail:', result);
    return result;
  } catch (error) {
    console.error('Error en el Puente de Gmail:', error);
    throw error;
  }
}

module.exports = { enviarCorreo };
