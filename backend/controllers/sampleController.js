

// const Sample = require('../models/sampleModel');

// // ✅ Get all samples (optionally filter by lat/lon via query params)
// exports.getAllSamples = async (req, res) => {
//   try {
//     const { lat, lon } = req.query;

//     if (lat && lon) {
//       const rows = await Sample.findByLatLon(parseFloat(lat), parseFloat(lon));
//       return res.json({ success: true, data: rows });
//     }

//     const rows = await Sample.findAll();
//     res.json({ success: true, data: rows });

//   } catch (e) {
//     console.error(e);
//     res.status(500).json({ error: 'Error fetching samples' });
//   }
// };

// // ✅ Get sample by lat/lon (POST body)
// exports.getByLatLon = async (req, res) => {
//   try {
//     const { lat, lon } = req.body;

//     if (lat === undefined || lon === undefined) {
//       return res.status(400).json({ error: 'Latitude and longitude required' });
//     }

//     const rows = await Sample.findByLatLon(parseFloat(lat), parseFloat(lon));

//     if (rows.length > 0) {
//       res.json({ success: true, data: rows });
//     } else {
//       res.json({ success: false, message: 'No data found for given coordinates' });
//     }

//   } catch (e) {
//     console.error(e);
//     res.status(500).json({ error: 'Error fetching by lat/lon' });
//   }
// };

// // ✅ Create a new sample
// exports.createSample = async (req, res) => {
//   try {
//     const { timestamp, latitude, longitude, rawData, hei, hpi, classification, syncStatus } = req.body;

//     if (latitude === undefined || longitude === undefined || !timestamp) {
//       return res.status(400).json({ error: 'Timestamp, latitude, and longitude are required' });
//     }

//     const id = await Sample.create({
//       timestamp,
//       latitude: parseFloat(latitude),
//       longitude: parseFloat(longitude),
//       rawData: rawData || {},
//       hei: hei || 0,
//       hpi: hpi || 0,
//       classification: classification || 'unknown',
//       syncStatus: syncStatus || 'pending'
//     });

//     res.status(201).json({ success: true, message: 'Sample created', id });

//   } catch (e) {
//     console.error(e);
//     res.status(500).json({ error: 'Error creating sample' });
//   }
// };

//second
// const Sample = require('../models/sampleModel');
// const axios = require('axios');

// // 🔹 Reverse geocode helper
// async function getDistrictState(lat, lon) {
//   try {
//     const url = `https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json`;
//     const res = await axios.get(url, { headers: { "User-Agent": "my-app" } });
//     const address = res.data.address || {};
//     return {
//       district: address.county || null,
//       state: address.state || null
//     };
//   } catch (error) {
//     console.error("Reverse geocoding failed:", error.message);
//     return { district: null, state: null };
//   }
// }

// // ✅ Create a new sample
// exports.createSample = async (req, res) => {
//   try {
//     const { timestamp, latitude, longitude, rawData, hei, hpi, classification, syncStatus } = req.body;
//     if (!latitude || !longitude || !timestamp) {
//       return res.status(400).json({ error: 'Timestamp, latitude, and longitude are required' });
//     }

//     const { district, state } = await getDistrictState(latitude, longitude);

//     const id = await Sample.create({
//       timestamp,
//       latitude: parseFloat(latitude),
//       longitude: parseFloat(longitude),
//       rawData: rawData || {},
//       hei: hei || 0,
//       hpi: hpi || 0,
//       classification: classification || 'unknown',
//       syncStatus: syncStatus || 'pending',
//       district,
//       state
//     });

//     res.status(201).json({ success: true, message: 'Sample created', id, district, state });
//   } catch (e) {
//     console.error(e);
//     res.status(500).json({ error: 'Error creating sample' });
//   }
// };

// // ✅ Get all samples
// exports.getAllSamples = async (req, res) => {
//   try {
//     const rows = await Sample.findAll();
//     res.json({ success: true, data: rows });
//   } catch (e) {
//     console.error(e);
//     res.status(500).json({ error: 'Error fetching samples' });
//   }
// };

// // ✅ Get sample by lat/lon (POST body)
// exports.getByLatLon = async (req, res) => {
//   try {
//     const { lat, lon } = req.body;
//     if (!lat || !lon) return res.status(400).json({ error: 'Latitude and longitude required' });
//     const rows = await Sample.findByLatLon(parseFloat(lat), parseFloat(lon));
//     if (rows.length > 0) res.json({ success: true, data: rows });
//     else res.json({ success: false, message: 'No data found for given coordinates' });
//   } catch (e) {
//     console.error(e);
//     res.status(500).json({ error: 'Error fetching by lat/lon' });
//   }
// };

// // ✅ Get average HPI by district/state
// // exports.getByCityOrState = async (req, res) => {
// //   try {
// //     const { lat, lon } = req.query;
// //     if (!lat || !lon) return res.status(400).json({ error: 'Latitude and longitude required' });

// //     const { district, state } = await getDistrictState(lat, lon);
// //     const data = await Sample.findByCityOrState(district, state);

// //     res.json({ success: true, district, state, avgHPI: data.avgHPI });
// //   } catch (e) {
// //     console.error(e);
// //     res.status(500).json({ error: 'Error fetching average HPI' });
// //   }
// // };

// // ✅ Get samples (by lat/lon → reverse geocode OR direct city/state)
// exports.getByCityOrState = async (req, res) => {
//   try {
//     const { lat, lon, city, state } = req.query;

//     let districtName, stateName;

//     if (lat && lon) {
//       // Case 1: Use reverse geocoding
//       const { district, state: stateFromCoords } = await getDistrictState(lat, lon);
//       districtName = district;
//       stateName = stateFromCoords;
//     } else if (city || state) {
//       // Case 2: Use provided city/state directly
//       districtName = city || null;
//       stateName = state || null;
//     } else {
//       return res.status(400).json({
//         error: 'Provide either lat/lon or city/state'
//       });
//     }

//     const data = await Sample.findByCityOrState(districtName, stateName);

//     if (!data || data.length === 0) {
//       return res.json({
//         success: false,
//         message: 'No records found',
//         district: districtName,
//         state: stateName
//       });
//     }

//     res.json({
//       success: true,
//       district: districtName,
//       state: stateName,
//       results: data
//     });
//   } catch (e) {
//     console.error(e);
//     res.status(500).json({ error: 'Error fetching city/state data' });
//   }
// };

const Sample = require('../models/sampleModel');
const axios = require('axios');

// 🔹 Reverse geocode helper
async function getDistrictState(lat, lon) {
  try {
    const url = `https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json`;
    const res = await axios.get(url, { headers: { "User-Agent": "my-app" } });
    const address = res.data.address || {};
    return {
      district: address.county || null,
      state: address.state || null
    };
  } catch (error) {
    console.error("Reverse geocoding failed:", error.message);
    return { district: null, state: null };
  }
}

// ✅ Create a new sample
exports.createSample = async (req, res) => {
  try {
    const { timestamp, latitude, longitude, rawData, hei, hpi, classification, syncStatus } = req.body;
    if (!latitude || !longitude || !timestamp) {
      return res.status(400).json({ error: 'Timestamp, latitude, and longitude are required' });
    }

    const { district, state } = await getDistrictState(latitude, longitude);

    const id = await Sample.create({
      timestamp,
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude),
      rawData: rawData || {},
      hei: hei || 0,
      hpi: hpi || 0,
      classification: classification || 'unknown',
      syncStatus: syncStatus || 'pending',
      district,
      state
    });

    res.status(201).json({ success: true, message: 'Sample created', id, district, state });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error creating sample' });
  }
};

// ✅ Get all samples
exports.getAllSamples = async (req, res) => {
  try {
    const rows = await Sample.findAll();
    res.json({ success: true, data: rows });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error fetching samples' });
  }
};

// ✅ Get sample by lat/lon (POST body)
exports.getByLatLon = async (req, res) => {
  try {
    const { lat, lon } = req.body;
    if (!lat || !lon) {
      return res.status(400).json({ error: 'Latitude and longitude required' });
    }

    const rows = await Sample.findByLatLon(parseFloat(lat), parseFloat(lon));

    if (rows.length > 0) {
      res.json({ success: true, data: rows });
    } else {
      res.json({ success: false, message: 'No data found for given coordinates' });
    }
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error fetching by lat/lon' });
  }
};

// ✅ Get samples (by lat/lon → reverse geocode OR direct city/state)
exports.getByCityOrState = async (req, res) => {
  try {
    const { lat, lon, city, state } = req.query;

    let districtName, stateName;

    if (lat && lon) {
      // Case 1: Use reverse geocoding
      const { district, state: stateFromCoords } = await getDistrictState(lat, lon);
      districtName = district;
      stateName = stateFromCoords;
    } else if (city || state) {
      // Case 2: Use provided city/state directly
      districtName = city || null;
      stateName = state || null;
    } else {
      return res.status(400).json({
        error: 'Provide either lat/lon or city/state'
      });
    }

    const { rows, avgHPI } = await Sample.findByCityOrState(districtName, stateName);

    if (!rows || rows.length === 0) {
      return res.json({
        success: false,
        message: 'No records found',
        district: districtName,
        state: stateName
      });
    }

    res.json({
      success: true,
      district: districtName,
      state: stateName,
      avgHPI,
      samples: rows
    });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error fetching city/state data' });
  }
};
