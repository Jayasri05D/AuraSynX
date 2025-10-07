

// const pool = require('./db');

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

//   try {
//     const [result] = await pool.query(createTableSQL);
//     console.log('✅ Table ensured:', result.warningStatus === 0 ? "OK" : "Warning");
//   } catch (err) {
//     console.error("❌ Error ensuring table:", err.message);
//   }
// }

// init();


// const express = require('express');
// const cors = require('cors');
// const dotenv = require('dotenv');
// const sampleRoutes = require('./routes/sampleRoutes');

// dotenv.config();
// const app = express();

// app.use(cors());
// app.use(express.json());

// app.get('/', (req, res) => res.send('Backend is running!'));
// app.use('/samples', sampleRoutes);

// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));


const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const sampleRoutes = require('./routes/sampleRoutes');

dotenv.config();
const app = express();

// Enable CORS for all origins (Flutter Web needs this)
app.use(cors());
app.use(express.json());

// Test route
app.get('/', (req, res) => res.send('Backend is running!'));

// Routes
app.use('/samples', sampleRoutes);

// Use 0.0.0.0 so it’s accessible on LAN (not just localhost)
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server running at http://localhost:${PORT}`);
});
