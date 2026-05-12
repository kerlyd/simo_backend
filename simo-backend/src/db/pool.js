const { Pool } = require('pg');
require('dotenv').config();

const poolConfig = process.env.DATABASE_URL
  ? {
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false }
  }
  : {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
  };

const pool = new Pool(poolConfig);

pool.connect()
  .then(async (client) => {
    console.log('✅ Conectado a PostgreSQL — reciclaje_app');
    try {
      await client.query('ALTER TABLE usuario ADD COLUMN IF NOT EXISTS genero VARCHAR(20) DEFAULT \'hombre\'');
      console.log('📊 Esquema de base de datos verificado (columna genero)');
    } finally {
      client.release();
    }
  })
  .catch(err => console.error('❌ Error conectando a PostgreSQL:', err.message));

module.exports = pool;