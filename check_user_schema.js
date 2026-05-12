const pool = require('./simo-backend/src/db/pool');

async function checkUserSchema() {
  try {
    const res = await pool.query(`
      SELECT column_name, data_type 
      FROM information_schema.columns 
      WHERE table_name = 'usuario';
    `);
    console.log('--- Usuario Table Schema ---');
    console.table(res.rows);
  } catch (err) {
    console.error(err);
  } finally {
    process.exit(0);
  }
}

checkUserSchema();
