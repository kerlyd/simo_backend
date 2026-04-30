const pool = require('./simo-backend/src/db/pool');

async function update() {
  try {
    await pool.query("UPDATE notificacion SET mensaje = 'Has sumado 800 puntos verdes a tu cuenta por reciclar tu Laptop. ¡Sigue así!' WHERE titulo = '¡Reciclaje Exitoso!' AND mensaje NOT LIKE '%Laptop%' AND mensaje NOT LIKE '%Batería%'");
    console.log('Updated');
  } catch (err) {
    console.error(err);
  } finally {
    process.exit(0);
  }
}
update();
