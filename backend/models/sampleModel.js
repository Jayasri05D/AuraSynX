// const pool = require('../db');

// const Sample = {
//   findByLatLon: async (lat, lon) => {
//     const [rows] = await pool.query(
//       'SELECT * FROM samples WHERE latitude = ? AND longitude = ?',
//       [lat, lon]
//     );
//     return rows;
//   },

//   findByCityOrState: async (city, state) => {
//     const [rows] = await pool.query(
//       'SELECT AVG(hpi) as avgHPI FROM samples WHERE city = ? OR state = ?',
//       [city, state]
//     );
//     return rows[0];
//   }
// };

// module.exports = Sample;

// sampleModel.js
// const pool = require('../db');

// const Sample = {
//   create: async (data) => {
//     const [result] = await pool.query(
//       `INSERT INTO samples 
//        (timestamp, latitude, longitude, rawData, hei, hpi, classification, syncStatus, district, state) 
//        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
//       [
//         data.timestamp,
//         data.latitude,
//         data.longitude,
//         JSON.stringify(data.rawData),
//         data.hei,
//         data.hpi,
//         data.classification,
//         data.syncStatus,
//         data.district || null,
//         data.state || null
//       ]
//     );
//     return result.insertId;
//   },

//   findAll: async () => {
//     const [rows] = await pool.query('SELECT * FROM samples');
//     return rows;
//   },

//   findByLatLon: async (lat, lon) => {
//     const [rows] = await pool.query(
//       'SELECT * FROM samples WHERE latitude = ? AND longitude = ?',
//       [lat, lon]
//     );
//     return rows;
//   },

//   findByCityOrState: async (district, state) => {
//     const [rows] = await pool.query(
//       'SELECT AVG(hpi) as avgHPI FROM samples WHERE district = ? OR state = ?',
//       [district, state]
//     );
//     return rows[0];
//   }
// };

// module.exports = Sample;
const pool = require('../db');

const Sample = {
  // 🔹 Create new record
  create: async (data) => {
    const [result] = await pool.query(
      `INSERT INTO samples 
       (timestamp, latitude, longitude, rawData, hei, hpi, classification, syncStatus, district, state) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        data.timestamp,
        data.latitude,
        data.longitude,
        JSON.stringify(data.rawData),
        data.hei,
        data.hpi,
        data.classification,
        data.syncStatus,
        data.district || null,
        data.state || null
      ]
    );
    return result.insertId;
  },

  // 🔹 Get all records
  findAll: async () => {
    const [rows] = await pool.query('SELECT * FROM samples');
    return rows;
  },

  // 🔹 Find by exact latitude & longitude
  findByLatLon: async (lat, lon) => {
    const [rows] = await pool.query(
      'SELECT * FROM samples WHERE latitude = ? AND longitude = ?',
      [lat, lon]
    );
    return rows;
  },

  // 🔹 Find by district/state (returns rows + average HPI)
  findByCityOrState: async (district, state) => {
    let query = 'SELECT * FROM samples WHERE 1=1';
    const params = [];

    if (district) {
      query += ' AND district = ?';
      params.push(district);
    }
    if (state) {
      query += ' AND state = ?';
      params.push(state);
    }

    // Get all matching rows
    const [rows] = await pool.query(query, params);

    // Default avgHPI null if no rows
    let avgHPI = null;
    if (rows.length > 0) {
      let avgQuery = 'SELECT AVG(hpi) AS avgHPI FROM samples WHERE 1=1';
      const avgParams = [];

      if (district) {
        avgQuery += ' AND district = ?';
        avgParams.push(district);
      }
      if (state) {
        avgQuery += ' AND state = ?';
        avgParams.push(state);
      }

      const [avgResult] = await pool.query(avgQuery, avgParams);
      avgHPI = avgResult[0]?.avgHPI || null;
    }

    return { rows, avgHPI };
  }
};

module.exports = Sample;
