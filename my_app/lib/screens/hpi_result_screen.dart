// import 'package:flutter/material.dart';
// import '../models/sample.dart';

// class HPIResultScreen extends StatefulWidget {
//   final Sample sample;
//   const HPIResultScreen({super.key, required this.sample});

//   @override
//   State<HPIResultScreen> createState() => _HPIResultScreenState();
// }

// class _HPIResultScreenState extends State<HPIResultScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();
//   final TextEditingController _cityCtrl = TextEditingController();

//   String? resultMessage;

//   void _getByLatLon() {
//     final lat = double.tryParse(_latCtrl.text.trim());
//     final lon = double.tryParse(_lonCtrl.text.trim());
//     if (lat == null || lon == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Enter valid latitude and longitude')));
//       return;
//     }

//     // Very basic: if coordinates match the sample, show it. In step 2 we'll query DB/server.
//     if (widget.sample.latitude == lat && widget.sample.longitude == lon) {
//       setState(() {
//         resultMessage =
//             'Match found: HPI = ${widget.sample.hpi.toStringAsFixed(3)}';
//       });
//     } else {
//       setState(() {
//         resultMessage = 'No exact match found locally. (Will query DB next)';
//       });
//     }
//   }

//   void _getByCityState() {
//     final city = _cityCtrl.text.trim();
//     if (city.isEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Enter a city/state')));
//       return;
//     }

//     setState(() {
//       resultMessage =
//           'City/State search for "$city" will be implemented in step 2.';
//     });
//   }

//   @override
//   void dispose() {
//     _latCtrl.dispose();
//     _lonCtrl.dispose();
//     _cityCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('HPI Result'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('Sample HPI: ${widget.sample.hpi.toStringAsFixed(3)}'),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _latCtrl,
//               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Latitude'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _lonCtrl,
//               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Longitude'),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _getByLatLon,
//               child: const Text('Get by Lat/Lon'),
//             ),
//             const SizedBox(height: 16),
//             const Divider(),
//             TextField(
//               controller: _cityCtrl,
//               decoration: const InputDecoration(
//                 labelText: 'Enter City or State',
//                 hintText: 'e.g. Coimbatore, Tamil Nadu',
//               ),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//                 onPressed: _getByCityState,
//                 child: const Text('Get by City/State (aggregate)')),
//             const SizedBox(height: 16),
//             if (resultMessage != null)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(resultMessage!),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../models/sample.dart';

// class HPIResultScreen extends StatefulWidget {
//   final Sample sample;
//   const HPIResultScreen({super.key, required this.sample});

//   @override
//   State<HPIResultScreen> createState() => _HPIResultScreenState();
// }

// class _HPIResultScreenState extends State<HPIResultScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();
//   final TextEditingController _cityCtrl = TextEditingController();

//   String? resultMessage;

//   // 👉 Change this to your backend URL
//   final String backendBaseUrl = "http://10.223.107.180:3000"; // for Android emulator

//   Future<String> fetchByLatLon(double lat, double lon) async {
//     try {
//       final uri = Uri.parse('$backendBaseUrl/samples?lat=$lat&lon=$lon');
//       final res = await http.get(uri);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         if (data['success']) {
//           return 'Match found from DB: HPI = ${data['hpi'].toStringAsFixed(3)}';
//         } else {
//           return data['message'];
//         }
//       } else {
//         return 'Error: ${res.statusCode}';
//       }
//     } catch (e) {
//       return 'Failed to fetch from server: $e';
//     }
//   }

//   Future<String> fetchByCity(String city) async {
//     try {
//       final uri = Uri.parse('$backendBaseUrl/sample/city?city=$city');
//       final res = await http.get(uri);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         if (data['success']) {
//           return 'Avg HPI for $city = ${data['hpi'].toStringAsFixed(3)}';
//         } else {
//           return data['message'];
//         }
//       } else {
//         return 'Error: ${res.statusCode}';
//       }
//     } catch (e) {
//       return 'Failed to fetch from server: $e';
//     }
//   }

//   void _getByLatLon() async {
//     final lat = double.tryParse(_latCtrl.text.trim());
//     final lon = double.tryParse(_lonCtrl.text.trim());
//     if (lat == null || lon == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter valid latitude and longitude')),
//       );
//       return;
//     }

//     // First check if local sample matches
//     if (widget.sample.latitude == lat && widget.sample.longitude == lon) {
//       setState(() {
//         resultMessage =
//             'Local match found: HPI = ${widget.sample.hpi.toStringAsFixed(3)}';
//       });
//     } else {
//       // Otherwise query backend
//       final msg = await fetchByLatLon(lat, lon);
//       setState(() {
//         resultMessage = msg;
//       });
//     }
//   }

//   void _getByCityState() async {
//     final city = _cityCtrl.text.trim();
//     if (city.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter a city/state')),
//       );
//       return;
//     }

//     final msg = await fetchByCity(city);
//     setState(() {
//       resultMessage = msg;
//     });
//   }

//   @override
//   void dispose() {
//     _latCtrl.dispose();
//     _lonCtrl.dispose();
//     _cityCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('HPI Result'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('Sample HPI: ${widget.sample.hpi.toStringAsFixed(3)}'),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _latCtrl,
//               keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Latitude'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _lonCtrl,
//               keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Longitude'),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _getByLatLon,
//               child: const Text('Get by Lat/Lon'),
//             ),
//             const SizedBox(height: 16),
//             const Divider(),
//             TextField(
//               controller: _cityCtrl,
//               decoration: const InputDecoration(
//                 labelText: 'Enter City or State',
//                 hintText: 'e.g. Coimbatore, Tamil Nadu',
//               ),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _getByCityState,
//               child: const Text('Get by City/State (aggregate)'),
//             ),
//             const SizedBox(height: 16),
//             if (resultMessage != null)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(
//                     resultMessage!,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../models/sample.dart';

// class HPIResultScreen extends StatefulWidget {
//   final Sample sample;
//   const HPIResultScreen({super.key, required this.sample});

//   @override
//   State<HPIResultScreen> createState() => _HPIResultScreenState();
// }

// class _HPIResultScreenState extends State<HPIResultScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();
//   final TextEditingController _cityCtrl = TextEditingController();

//   String? resultMessage;

//   // 👉 Change this to your backend URL
//   final String backendBaseUrl = "http://10.223.107.180:3000"; // for Android emulator

//   Future<String> fetchByLatLon(double lat, double lon) async {
//     try {
//       final uri = Uri.parse('$backendBaseUrl/samples?lat=$lat&lon=$lon');
//       final res = await http.get(uri);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         if (data['success']) {
//           // ✅ backend returns { success:true, data:[{hpi:..}] }
//           if (data['data'] != null && data['data'].isNotEmpty) {
//             final hpi = (data['data'][0]['hpi'] as num).toDouble();
//             return 'Match found from DB: HPI = ${hpi.toStringAsFixed(3)}';
//           } else {
//             return 'No record found for given Lat/Lon';
//           }
//         } else {
//           return data['message'] ?? 'No data';
//         }
//       } else {
//         return 'Error: ${res.statusCode}';
//       }
//     } catch (e) {
//       return 'Failed to fetch from server: $e';
//     }
//   }

//   Future<String> fetchByCity(String city) async {
//     try {
//       final uri = Uri.parse('$backendBaseUrl/sample/city?city=$city');
//       final res = await http.get(uri);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         if (data['success']) {
//           // ✅ backend returns { success:true, avgHPI:.. }
//           final hpiValue = data['avgHPI'];
//           if (hpiValue != null) {
//             final hpi = (hpiValue as num).toDouble();
//             return 'Avg HPI for $city = ${hpi.toStringAsFixed(3)}';
//           } else {
//             return 'No HPI data for $city';
//           }
//         } else {
//           return data['message'] ?? 'No data';
//         }
//       } else {
//         return 'Error: ${res.statusCode}';
//       }
//     } catch (e) {
//       return 'Failed to fetch from server: $e';
//     }
//   }

//   void _getByLatLon() async {
//     final lat = double.tryParse(_latCtrl.text.trim());
//     final lon = double.tryParse(_lonCtrl.text.trim());
//     if (lat == null || lon == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter valid latitude and longitude')),
//       );
//       return;
//     }

//     // First check if local sample matches
//     if (widget.sample.latitude == lat && widget.sample.longitude == lon) {
//       setState(() {
//         resultMessage =
//             'Local match found: HPI = ${widget.sample.hpi.toStringAsFixed(3)}';
//       });
//     } else {
//       // Otherwise query backend
//       final msg = await fetchByLatLon(lat, lon);
//       setState(() {
//         resultMessage = msg;
//       });
//     }
//   }

//   void _getByCityState() async {
//     final city = _cityCtrl.text.trim();
//     if (city.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter a city/state')),
//       );
//       return;
//     }

//     final msg = await fetchByCity(city);
//     setState(() {
//       resultMessage = msg;
//     });
//   }

//   @override
//   void dispose() {
//     _latCtrl.dispose();
//     _lonCtrl.dispose();
//     _cityCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('HPI Result'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('Sample HPI: ${widget.sample.hpi.toStringAsFixed(3)}'),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _latCtrl,
//               keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Latitude'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _lonCtrl,
//               keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Longitude'),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _getByLatLon,
//               child: const Text('Get by Lat/Lon'),
//             ),
//             const SizedBox(height: 16),
//             const Divider(),
//             TextField(
//               controller: _cityCtrl,
//               decoration: const InputDecoration(
//                 labelText: 'Enter City or State',
//                 hintText: 'e.g. Coimbatore, Tamil Nadu',
//               ),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _getByCityState,
//               child: const Text('Get by City/State (aggregate)'),
//             ),
//             const SizedBox(height: 16),
//             if (resultMessage != null)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(
//                     resultMessage!,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../models/sample.dart';

// class HPIResultScreen extends StatefulWidget {
//   final Sample sample;
//   const HPIResultScreen({super.key, required this.sample});

//   @override
//   State<HPIResultScreen> createState() => _HPIResultScreenState();
// }

// class _HPIResultScreenState extends State<HPIResultScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();
//   final TextEditingController _cityCtrl = TextEditingController();

//   String? resultMessage;
//   final String backendBaseUrl = "http://10.223.107.180:3000";

//   String _formatDoubleOrNoData(dynamic v, {int digits = 3}) {
//     if (v == null) return "No data";
//     if (v is num) return v.toDouble().toStringAsFixed(digits);
//     // try parse if string numeric
//     final parsed = double.tryParse(v.toString());
//     return parsed != null ? parsed.toStringAsFixed(digits) : v.toString();
//   }

//   /// Try to extract an average HPI from multiple possible server response shapes.
//   double? _extractAvgHpi(Map<String, dynamic> data) {
//     // 1) { success: true, avgHPI: 84.2 }
//     if (data.containsKey('avgHPI') && data['avgHPI'] != null) {
//       final v = data['avgHPI'];
//       if (v is num) return v.toDouble();
//       return double.tryParse(v.toString());
//     }
//     // 2) { success: true, hei/heiValue ... } (fallback)
//     if (data.containsKey('hei') && data['hei'] != null) {
//       final v = data['hei'];
//       if (v is num) return v.toDouble();
//       return double.tryParse(v.toString());
//     }
//     // 3) { success: true, data: [ { hpi: 84.2 }, ... ] }
//     if (data.containsKey('data') && data['data'] is List && data['data'].isNotEmpty) {
//       final first = data['data'][0];
//       if (first is Map && first.containsKey('hpi')) {
//         final v = first['hpi'];
//         if (v is num) return v.toDouble();
//         return double.tryParse(v.toString());
//       }
//     }
//     // 4) { success: true, samples: [ {hpi:...} ], avgHPI:... }
//     if (data.containsKey('samples') && data['samples'] is List && data['samples'].isNotEmpty) {
//       final first = data['samples'][0];
//       if (first is Map && first.containsKey('hpi')) {
//         final v = first['hpi'];
//         if (v is num) return v.toDouble();
//         return double.tryParse(v.toString());
//       }
//     }
//     // 5) { success: true, results: { avgHPI: ... } }
//     if (data.containsKey('results') && data['results'] is Map) {
//       final r = data['results'];
//       if (r.containsKey('avgHPI')) {
//         final v = r['avgHPI'];
//         if (v is num) return v.toDouble();
//         return double.tryParse(v.toString());
//       }
//     }
//     return null;
//   }

//   /// Primary: try the known working endpoint first, then fallbacks.
//   Future<String> fetchByLocation(double lat, double lon) async {
//     final attempts = <Future<http.Response> Function()>[
//       // Attempt 1: the endpoint that worked previously (GET /samples?lat=&lon=)
//       () => http.get(Uri.parse('$backendBaseUrl/samples?lat=$lat&lon=$lon')),
//       // Attempt 2: fallback GET path you used earlier (by-location)
//       () => http.get(Uri.parse('$backendBaseUrl/samples/by-location?lat=$lat&lon=$lon')),
//       // Attempt 3: fallback GET /by-latlon (if your server uses different)
//       () => http.get(Uri.parse('$backendBaseUrl/samples/by-latlon?lat=$lat&lon=$lon')),
//       // Attempt 4: fallback POST /by-latlon (some backends expect POST)
//       () => http.post(Uri.parse('$backendBaseUrl/samples/by-latlon'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({'lat': lat, 'lon': lon})),
//     ];

//     for (final attempt in attempts) {
//       try {
//         final res = await attempt();
//         print('[HPI] tried ${res.request?.url} => status ${res.statusCode}');
//         print('[HPI] body: ${res.body}');
//         if (res.statusCode != 200) continue;

//         final Map<String, dynamic> data = jsonDecode(res.body);
//         if (data['success'] == true) {
//           // try to extract avgHPI
//           final avg = _extractAvgHpi(data);
//           if (avg != null) {
//             final district = data['district'] ?? (data['samples'] is List && data['samples'].isNotEmpty ? data['samples'][0]['district'] : null) ?? "Unknown";
//             final state = data['state'] ?? (data['samples'] is List && data['samples'].isNotEmpty ? data['samples'][0]['state'] : null) ?? "Unknown";
//             return "📍 Location: $district, $state\n📊 Avg HPI: ${_formatDoubleOrNoData(avg)}";
//           }

//           // If success true but avg missing, maybe API returned rows in 'data' but hpi missing
//           if (data.containsKey('data') && data['data'] is List && data['data'].isNotEmpty) {
//             final row = data['data'][0];
//             if (row is Map && row.containsKey('hpi')) {
//               final hpi = row['hpi'];
//               return "📊 HPI (raw row) = ${_formatDoubleOrNoData(hpi)}";
//             }
//           }

//           // try results.avgHPI
//           if (data.containsKey('results') && data['results'] is Map && data['results']['avgHPI'] != null) {
//             return "📊 Avg HPI: ${_formatDoubleOrNoData(data['results']['avgHPI'])}";
//           }

//           return data['message'] ?? data['error'] ?? 'Success but no HPI found';
//         } else {
//           // Not success: check message
//           final msg = data['message'] ?? data['error'] ?? 'No data found';
//           // but continue attempts only if server returned 404/empty; otherwise return message
//           // if message indicates no records found, keep trying other endpoints
//           if (msg.toString().toLowerCase().contains('no record') || msg.toString().toLowerCase().contains('no records')) {
//             // try next attempt
//             continue;
//           }
//           return msg;
//         }
//       } catch (e) {
//         print('[HPI] request failed: $e');
//         // try next attempt
//         continue;
//       }
//     }

//     return 'No data found (tried multiple endpoints). Check server routes & DB.';
//   }

//   Future<String> fetchByCityState(String cityOrState) async {
//     final attempts = <Future<http.Response> Function()>[
//       () => http.get(Uri.parse('$backendBaseUrl/sample/city?city=$cityOrState')), // older working
//       () => http.get(Uri.parse('$backendBaseUrl/samples/city-state?name=$cityOrState')),
//       () => http.get(Uri.parse('$backendBaseUrl/samples/byCityOrState?city=$cityOrState&state=$cityOrState')),
//       () => http.get(Uri.parse('$backendBaseUrl/samples/city-state?city=$cityOrState&state=$cityOrState')),
//     ];

//     for (final attempt in attempts) {
//       try {
//         final res = await attempt();
//         print('[HPI-city] tried ${res.request?.url} => status ${res.statusCode}');
//         print('[HPI-city] body: ${res.body}');
//         if (res.statusCode != 200) continue;
//         final Map<String, dynamic> data = jsonDecode(res.body);
//         if (data['success'] == true) {
//           final avg = _extractAvgHpi(data);
//           if (avg != null) {
//             return "📍 $cityOrState\n📊 Avg HPI: ${_formatDoubleOrNoData(avg)}";
//           }
//           // If server returned samples array, compute average locally as last resort
//           if (data.containsKey('samples') && data['samples'] is List && data['samples'].isNotEmpty) {
//             final List samples = data['samples'];
//             final nums = samples.where((s) => s is Map && s['hpi'] != null).map((s) => (s['hpi'] as num).toDouble()).toList();
//             if (nums.isNotEmpty) {
//               final avgVal = nums.reduce((a, b) => a + b) / nums.length;
//               return "📍 $cityOrState\n📊 Avg HPI (computed) = ${_formatDoubleOrNoData(avgVal)}";
//             }
//           }
//           return data['message'] ?? 'No HPI found for $cityOrState';
//         } else {
//           final msg = data['message'] ?? data['error'] ?? 'No data';
//           if (msg.toString().toLowerCase().contains('no record') || msg.toString().toLowerCase().contains('no records')) {
//             continue;
//           }
//           return msg;
//         }
//       } catch (e) {
//         print('[HPI-city] request failure: $e');
//         continue;
//       }
//     }

//     return 'No data found for $cityOrState (tried multiple endpoints).';
//   }

//   void _getByLatLon() async {
//     final lat = double.tryParse(_latCtrl.text.trim());
//     final lon = double.tryParse(_lonCtrl.text.trim());
//     if (lat == null || lon == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid latitude and longitude')));
//       return;
//     }

//     if (widget.sample.latitude == lat && widget.sample.longitude == lon) {
//       setState(() {
//         resultMessage = '✅ Local match: HPI = ${_formatDoubleOrNoData(widget.sample.hpi)}';
//       });
//       return;
//     }

//     setState(() {
//       resultMessage = 'Searching...';
//     });

//     final msg = await fetchByLocation(lat, lon);
//     setState(() {
//       resultMessage = msg;
//     });
//   }

//   void _getByCityState() async {
//     final name = _cityCtrl.text.trim();
//     if (name.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a city or state name')));
//       return;
//     }
//     setState(() {
//       resultMessage = 'Searching...';
//     });
//     final msg = await fetchByCityState(name);
//     setState(() {
//       resultMessage = msg;
//     });
//   }

//   @override
//   void dispose() {
//     _latCtrl.dispose();
//     _lonCtrl.dispose();
//     _cityCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('HPI Result')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('Sample HPI: ${_formatDoubleOrNoData(widget.sample.hpi)}'),
//             const SizedBox(height: 16),
//             TextField(controller: _latCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Latitude')),
//             const SizedBox(height: 8),
//             TextField(controller: _lonCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Longitude')),
//             const SizedBox(height: 12),
//             ElevatedButton(onPressed: _getByLatLon, child: const Text('Get by Lat/Lon')),
//             const SizedBox(height: 16),
//             const Divider(),
//             TextField(controller: _cityCtrl, decoration: const InputDecoration(labelText: 'Enter City or State', hintText: 'e.g. Coimbatore or Tamil Nadu')),
//             const SizedBox(height: 8),
//             ElevatedButton(onPressed: _getByCityState, child: const Text('Get by City/State')),
//             const SizedBox(height: 16),
//             if (resultMessage != null)
//               Card(child: Padding(padding: const EdgeInsets.all(12.0), child: Text(resultMessage!, style: const TextStyle(fontSize: 16)))),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/sample.dart';

class HPIResultScreen extends StatefulWidget {
  final Sample sample;
  const HPIResultScreen({super.key, required this.sample});

  @override
  State<HPIResultScreen> createState() => _HPIResultScreenState();
}

class _HPIResultScreenState extends State<HPIResultScreen> {
  final TextEditingController _latCtrl = TextEditingController();
  final TextEditingController _lonCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();

  String? resultMessage;
  final String backendBaseUrl = "http://10.103.230.180:3000";

  String _formatDoubleOrNoData(dynamic v, {int digits = 3}) {
    if (v == null) return "No data";
    if (v is num) return v.toDouble().toStringAsFixed(digits);
    final parsed = double.tryParse(v.toString());
    return parsed != null ? parsed.toStringAsFixed(digits) : v.toString();
  }

  double? _extractAvgHpi(Map<String, dynamic> data) {
    if (data.containsKey('avgHPI') && data['avgHPI'] != null) {
      final v = data['avgHPI'];
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }
    if (data.containsKey('data') && data['data'] is List && data['data'].isNotEmpty) {
      final first = data['data'][0];
      if (first is Map && first.containsKey('hpi')) {
        final v = first['hpi'];
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString());
      }
    }
    if (data.containsKey('samples') && data['samples'] is List && data['samples'].isNotEmpty) {
      final first = data['samples'][0];
      if (first is Map && first.containsKey('hpi')) {
        final v = first['hpi'];
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString());
      }
    }
    if (data.containsKey('results') && data['results'] is Map) {
      final r = data['results'];
      if (r.containsKey('avgHPI')) {
        final v = r['avgHPI'];
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString());
      }
    }
    return null;
  }

  // Future<String> fetchByLocation(double lat, double lon) async {
  //   final attempts = <Future<http.Response> Function()>[
  //     () => http.get(Uri.parse('$backendBaseUrl/samples?lat=$lat&lon=$lon')),
  //     () => http.get(Uri.parse('$backendBaseUrl/samples/by-location?lat=$lat&lon=$lon')),
  //     () => http.get(Uri.parse('$backendBaseUrl/samples/by-latlon?lat=$lat&lon=$lon')),
  //     () => http.post(Uri.parse('$backendBaseUrl/samples/by-latlon'),
  //         headers: {'Content-Type': 'application/json'},
  //         body: jsonEncode({'lat': lat, 'lon': lon})),
  //   ];

  //   for (final attempt in attempts) {
  //     try {
  //       final res = await attempt();
  //       if (res.statusCode != 200) continue;
  //       final Map<String, dynamic> data = jsonDecode(res.body);
  //       if (data['success'] == true) {
  //         final avg = _extractAvgHpi(data);
  //         if (avg != null) {
  //           final district = data['district'] ??
  //               (data['samples'] is List && data['samples'].isNotEmpty
  //                   ? data['samples'][0]['district']
  //                   : null) ??
  //               "Unknown";
  //           final state = data['state'] ??
  //               (data['samples'] is List && data['samples'].isNotEmpty
  //                   ? data['samples'][0]['state']
  //                   : null) ??
  //               "Unknown";
  //           return "📍 Location: $district, $state\n📊 Avg HPI: ${_formatDoubleOrNoData(avg)}";
  //         }
  //         return data['message'] ?? 'Success but no HPI found';
  //       }
  //     } catch (_) {
  //       continue;
  //     }
  //   }
  //   return 'No data found (tried multiple endpoints). Check server routes & DB.';
  // }
  Future<String> fetchByLocation(double lat, double lon) async {
  final attempts = <Future<http.Response> Function()>[
    () => http.get(Uri.parse('$backendBaseUrl/samples?lat=$lat&lon=$lon')),
    () => http.get(Uri.parse('$backendBaseUrl/samples/by-location?lat=$lat&lon=$lon')),
    () => http.get(Uri.parse('$backendBaseUrl/samples/by-latlon?lat=$lat&lon=$lon')),
    () => http.post(
          Uri.parse('$backendBaseUrl/samples/by-latlon'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'lat': lat, 'lon': lon}),
        ),
  ];

  for (final attempt in attempts) {
    try {
      final res = await attempt();
      if (res.statusCode != 200) continue;

      final Map<String, dynamic> data = jsonDecode(res.body);
      if (data['success'] == true && data['samples'] is List) {
        final samples = data['samples'] as List;
        if (samples.isEmpty) return "No data found for these coordinates";

        // Extract all HPI values
        final hpiValues = samples
            .map((s) => s['hpi'] != null ? _formatDoubleOrNoData(s['hpi']) : "No data")
            .toList();

        final district = samples[0]['district'] ?? "Unknown";
        final state = samples[0]['state'] ?? "Unknown";

        // Option 1: Show all HPI values
        return "📍 Location: $district, $state\n📊 HPI values: ${hpiValues.join(', ')}";

        // Option 2: Or show average HPI instead
        // final numericHpis = samples
        //     .where((s) => s['hpi'] != null)
        //     .map((s) => (s['hpi'] as num).toDouble())
        //     .toList();
        // final avg = numericHpis.reduce((a, b) => a + b) / numericHpis.length;
        // return "📍 Location: $district, $state\n📊 Avg HPI: ${_formatDoubleOrNoData(avg)}";
      }

      if (data['message'] != null) return data['message'];
    } catch (_) {
      continue;
    }
  }

  return 'No data found (tried multiple endpoints). Check server routes & DB.';
}

   Future<String> fetchByCityState(String name) async {
    try {
      final uri = Uri.parse('$backendBaseUrl/samples/by-location?state=$name');
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true) {
          final avg = _extractAvgHpi(data);
          return "📍 $name\n📊 Avg HPI: ${_formatDoubleOrNoData(avg)}";
        } else {
          return data['message'] ?? 'No data found';
        }
      } else {
        return "Error: ${res.statusCode}";
      }
    } catch (e) {
      return "Failed to fetch: $e";
    }
  }

  void _getByLatLon() async {
    final lat = double.tryParse(_latCtrl.text.trim());
    final lon = double.tryParse(_lonCtrl.text.trim());
    if (lat == null || lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid latitude and longitude')));
      return;
    }

    if (widget.sample.latitude == lat && widget.sample.longitude == lon) {
      setState(() {
        resultMessage = '✅ Local match: HPI = ${_formatDoubleOrNoData(widget.sample.hpi)}';
      });
      return;
    }

    setState(() {
      resultMessage = 'Searching...';
    });

    final msg = await fetchByLocation(lat, lon);
    setState(() {
      resultMessage = msg;
    });
  }
  void _getByCityState() async {
    final name = _cityCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a city or state name')));
      return;
    }

    setState(() {
      resultMessage = 'Searching...';
    });

    final msg = await fetchByCityState(name);
    setState(() {
      resultMessage = msg;
    });
  }
  @override
  void dispose() {
    _latCtrl.dispose();
    _lonCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF3B5BA1); // lighter blue
    const white = Color(0xFFFFFFFF);
    const coolGrey = Color(0xFF6B7280);
    const aquaTeal = Color(0xFF14B8A6);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('HPI Result', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryBlue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: coolGrey, width: 0.5),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Sample HPI: ${_formatDoubleOrNoData(widget.sample.hpi)}',
                  style: TextStyle(fontSize: 16, color: primaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _latCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Latitude',
                labelStyle: TextStyle(color: coolGrey),
                prefixIcon: Icon(Icons.place, color: aquaTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: aquaTeal, width: 2)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lonCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Longitude',
                labelStyle: TextStyle(color: coolGrey),
                prefixIcon: Icon(Icons.place, color: aquaTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: aquaTeal, width: 2)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: aquaTeal,
                  foregroundColor: white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _getByLatLon,
                child: const Text('Get by Lat/Lon', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            TextField(
              controller: _cityCtrl,
              decoration: InputDecoration(
                labelText: 'Enter City or State',
                hintText: 'e.g. Coimbatore or Tamil Nadu',
                labelStyle: TextStyle(color: coolGrey),
                prefixIcon: Icon(Icons.location_city, color: aquaTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: aquaTeal, width: 2)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: aquaTeal,
                  foregroundColor: white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _getByCityState,
                child: const Text('Get by City/State', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            if (resultMessage != null)
              Card(
                color: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: coolGrey, width: 0.5),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(resultMessage!, style: TextStyle(fontSize: 16, color: primaryBlue)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
