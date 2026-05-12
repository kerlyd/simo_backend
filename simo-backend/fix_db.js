const { Client } = require('pg');
require('dotenv').config();

async function fixDatabase() {
  const configs = [
    { connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false } },
    { connectionString: process.env.DATABASE_URL, ssl: false }
  ];

  for (const config of configs) {
    const client = new Client(config);
    try {
      console.log(`Intentando conectar (${config.ssl ? 'con SSL' : 'sin SSL'})...`);
      await client.connect();
      console.log('Conectado con éxito.');
      
      await client.query(`
        ALTER TABLE usuario ADD COLUMN IF NOT EXISTS genero VARCHAR(20) DEFAULT 'hombre';
      `);
      
      console.log('¡Columna genero asegurada!');
      await client.end();
      return;
    } catch (err) {
      console.log('Fallo este intento:', err.message);
      await client.end();
    }
  }
  console.error('No se pudo conectar de ninguna forma. Verifica tu DATABASE_URL en el .env');
}

fixDatabase();
