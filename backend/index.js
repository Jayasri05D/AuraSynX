
// const express = require('express');
// const pool = require('./db');   // ✅ Import the pool
// const app = express();
// const port = 3000;

// app.use(express.json());

// // Test route
// app.get('/', (req, res) => {
//   res.send('Backend is running!');
// });

// // Fetch samples
// app.get('/samples', async (req, res) => {
//   try {
//     const [results] = await pool.query('SELECT * FROM samples'); // ✅ async/await
//     res.json(results);
//   } catch (err) {
//     console.error("DB error:", err);
//     res.status(500).send("Database error");
//   }
// });

// app.listen(port, () => {
//   console.log(`🚀 Server running at http://localhost:${port}`);
// });

//second time
// const express = require('express');
// const app = express();
// const port = 3000;

// const pool = require('./db'); // import db.js

// app.use(express.json()); // ✅ allow JSON body parsing

// // Test route
// app.get('/', (req, res) => {
//   res.send('Backend is running!');
// });

// // 📌 POST route → insert new sample
// app.post('/samples', async (req, res) => {
//   try {
//     const { timestamp, latitude, longitude, rawData, hei, hpi, classification, syncStatus } = req.body;

//     const [result] = await pool.query(
//       `INSERT INTO samples (timestamp, latitude, longitude, rawData, hei, hpi, classification, syncStatus)
//        VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
//       [timestamp, latitude, longitude, JSON.stringify(rawData), hei, hpi, classification, syncStatus]
//     );

//     res.status(200).json({ message: 'Sample inserted', id: result.insertId });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: 'Database insert failed' });
//   }
// });

// // 📌 GET route → fetch all samples
// app.get('/samples', async (req, res) => {
//   try {
//     const [rows] = await pool.query('SELECT * FROM samples');
//     res.json(rows);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: 'Database fetch failed' });
//   }
// });

// app.listen(port, () => {
//   console.log(`Server running at http://localhost:${port}`);
// });

// const express = require('express');
// const cors = require('cors'); // <-- Import cors
// const app = express();
// const port = 3000;

// // Middleware
// app.use(cors()); // <-- Allow all origins
// app.use(express.json()); // <-- Parse JSON request bodies

// const db = require('./db'); // your db connection

// app.get('/', (req, res) => {
//   res.send('Backend is running!');
// });

// app.get('/samples', async (req, res) => {
//   try {
//     const [rows] = await db.query('SELECT * FROM samples');
//     res.json(rows);
//   } catch (e) {
//     res.status(500).send(e.toString());
//   }
// });

// app.post('/samples', async (req, res) => {
//   try {
//     const data = req.body;
//     console.log("Received:", data);
//     const result = await db.query(
//       'INSERT INTO samples (timestamp, latitude, longitude, rawData, hei, hpi, classification, syncStatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
//       [
//         data.timestamp,
//         data.latitude,
//         data.longitude,
//         JSON.stringify(data.rawData),
//         data.hei,
//         data.hpi,
//         data.classification,
//         data.syncStatus
//       ]
//     );
//     res.status(200).json({ success: true, id: result[0].insertId });
//   } catch (e) {
//     res.status(500).send(e.toString());
//   }
// });

// app.listen(port, () => {
//   console.log(`Server running at http://localhost:${port}`);
// });

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
    await pool.query(createTableSQL);
    console.log('✅ Table ensured');
  } catch (err) {
    console.error("❌ Error ensuring table:", err.message);
  }
}

init();
