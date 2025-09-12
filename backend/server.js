// const mysql = require('mysql2/promise');
// require('dotenv').config();

// const pool = mysql.createPool({
//   host: process.env.DB_HOST,
//   port: Number(process.env.DB_PORT),
//   user: process.env.DB_USER,
//   password: process.env.DB_PASSWORD,
//   database: process.env.DB_NAME,
// });

// // Use async/await
// async function init() {
//   const createTableSQL = `
//     CREATE TABLE IF NOT EXISTS samples (
//       id INT AUTO_INCREMENT PRIMARY KEY,
//       timestamp VARCHAR(50),
//       latitude DOUBLE,
//       longitude DOUBLE,
//       rawData JSON,
//       hei DOUBLE,
//       hpi DOUBLE,
//       classification VARCHAR(20),
//       syncStatus VARCHAR(20)
//     )
//   `;
  
//   // ✅ Correct way to run query with promise pool
//   const [result] = await pool.query(createTableSQL);
//   console.log('Table ensured:', result);
// }

// init();
const pool = require('./db');

async function init() {
  const createTableSQL = `
    CREATE TABLE IF NOT EXISTS samples (
      id INT AUTO_INCREMENT PRIMARY KEY,
      timestamp VARCHAR(50),
      latitude DOUBLE,
      longitude DOUBLE,
      rawData JSON,
      hei DOUBLE,
      hpi DOUBLE,
      classification VARCHAR(20),
      syncStatus VARCHAR(20)
    )
  `;

  try {
    const [result] = await pool.query(createTableSQL);
    console.log('✅ Table ensured:', result.warningStatus === 0 ? "OK" : "Warning");
  } catch (err) {
    console.error("❌ Error ensuring table:", err.message);
  }
}

init();
