// const express = require('express');
// const router = express.Router();
// const sampleController = require('../controllers/sampleController');

// router.get('/', sampleController.getAllSamples);
// router.post('/', sampleController.createSample);
// router.post('/by-latlon', sampleController.getByLatLon);
// router.get('/by-location', sampleController.getByCityOrState);

// module.exports = router;
const express = require('express');
const router = express.Router();
const sampleController = require('../controllers/sampleController');

router.get('/', sampleController.getAllSamples);
router.post('/', sampleController.createSample);
router.post('/by-latlon', sampleController.getByLatLon);
router.get('/by-location', sampleController.getByCityOrState);

module.exports = router;
