const https = require('https');

const data = JSON.stringify({
  email: 'test@example.com'
});

const options = {
  hostname: 'simobackend-production.up.railway.app',
  port: 443,
  path: '/api/auth/recuperar',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': data.length
  }
};

const req = https.request(options, (res) => {
  let body = '';
  res.on('data', (d) => {
    body += d;
  });
  res.on('end', () => {
    console.log('STATUS:', res.statusCode);
    console.log('BODY:', body);
  });
});

req.on('error', (e) => {
  console.error('ERROR:', e.message);
});

req.write(data);
req.end();
