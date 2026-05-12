const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function addGenero() {
  try {
    console.log('Añadiendo columna genero...');
    await pool.query('ALTER TABLE usuario ADD COLUMN IF NOT EXISTS genero VARCHAR(20) DEFAULT \'hombre\'');
    console.log('¡Columna añadida con éxito!');
  } catch (err) {
    console.error('Error:', err);
  } finally {
    await pool.end();
  }
}

addGenero();
