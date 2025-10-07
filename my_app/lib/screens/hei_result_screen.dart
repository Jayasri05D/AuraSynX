// import 'package:flutter/material.dart';
// import '../models/sample.dart';

// class HEIResultScreen extends StatefulWidget {
//   final Sample sample;
//   const HEIResultScreen({super.key, required this.sample});

//   @override
//   State<HEIResultScreen> createState() => _HEIResultScreenState();
// }

// class _HEIResultScreenState extends State<HEIResultScreen> {
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

//     if (widget.sample.latitude == lat && widget.sample.longitude == lon) {
//       setState(() {
//         resultMessage =
//             'Match found: HEI = ${widget.sample.hei.toStringAsFixed(3)}';
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
//         title: const Text('HEI Result'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('Sample HEI: ${widget.sample.hei.toStringAsFixed(3)}'),
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

// class HEIResultScreen extends StatefulWidget {
//   final Sample sample;
//   const HEIResultScreen({super.key, required this.sample});

//   @override
//   State<HEIResultScreen> createState() => _HEIResultScreenState();
// }

// class _HEIResultScreenState extends State<HEIResultScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();
//   final TextEditingController _cityCtrl = TextEditingController();

//   String? resultMessage;

//   // 👉 Change this URL to match your backend
//   final String backendBaseUrl = "http://10.223.107.180:3000"; // for Android emulator

//   Future<String> fetchByLatLon(double lat, double lon) async {
//     try {
//       final uri = Uri.parse('$backendBaseUrl/samples?lat=$lat&lon=$lon');
//       final res = await http.get(uri);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         if (data['success']) {
//           return 'Match found from DB: HEI = ${data['hei'].toStringAsFixed(3)}';
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
//           return 'Avg HEI for $city = ${data['hei'].toStringAsFixed(3)}';
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
//             'Local match found: HEI = ${widget.sample.hei.toStringAsFixed(3)}';
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
//         title: const Text('HEI Result'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('Sample HEI: ${widget.sample.hei.toStringAsFixed(3)}'),
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

// class HEIResultScreen extends StatefulWidget {
//   final Sample sample;
//   const HEIResultScreen({super.key, required this.sample});

//   @override
//   State<HEIResultScreen> createState() => _HEIResultScreenState();
// }

// class _HEIResultScreenState extends State<HEIResultScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();
//   final TextEditingController _cityCtrl = TextEditingController();

//   String? resultMessage;

//   // 👉 Change this URL if needed (for emulator use 10.0.2.2 instead of localhost)
//   final String backendBaseUrl = "http://10.223.107.180:3000";

//   /// 🔹 Utility to safely format doubles
//   String _formatDouble(dynamic value, {int digits = 3}) {
//     if (value == null) return "No data";
//     if (value is num) return value.toDouble().toStringAsFixed(digits);
//     return value.toString();
//   }

//   /// 🔹 Fetch HEI by latitude/longitude
//   Future<String> fetchByLatLon(double lat, double lon) async {
//     try {
//       final uri = Uri.parse('$backendBaseUrl/samples?lat=$lat&lon=$lon');
//       final res = await http.get(uri);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         debugPrint("Lat/Lon response: $data");

//         if (data['success'] == true) {
//           final hei = data['hei'] ?? data['avgHei'];
//           return "📍 Match found from DB\nHEI = ${_formatDouble(hei)}";
//         } else {
//           return data['message'] ?? "No data found";
//         }
//       } else {
//         return "❌ Error: ${res.statusCode}";
//       }
//     } catch (e) {
//       return "⚠️ Failed to fetch from server: $e";
//     }
//   }

//   /// 🔹 Fetch aggregated HEI by city/state
//   Future<String> fetchByCity(String city) async {
//     try {
//       final uri = Uri.parse('$backendBaseUrl/samples/city-state?name=$city');
//       final res = await http.get(uri);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         debugPrint("City response: $data");

//         if (data['success'] == true) {
//           final hei = data['hei'] ?? data['avgHei'];
//           return "📍 $city\nAvg HEI = ${_formatDouble(hei)}";
//         } else {
//           return data['message'] ?? "No data found";
//         }
//       } else {
//         return "❌ Error: ${res.statusCode}";
//       }
//     } catch (e) {
//       return "⚠️ Failed to fetch from server: $e";
//     }
//   }

//   /// 🔹 Handle Lat/Lon button
//   void _getByLatLon() async {
//     final lat = double.tryParse(_latCtrl.text.trim());
//     final lon = double.tryParse(_lonCtrl.text.trim());

//     if (lat == null || lon == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter valid latitude and longitude')),
//       );
//       return;
//     }

//     if (widget.sample.latitude == lat && widget.sample.longitude == lon) {
//       setState(() {
//         resultMessage =
//             "✅ Local match\nHEI = ${_formatDouble(widget.sample.hei)}";
//       });
//     } else {
//       final msg = await fetchByLatLon(lat, lon);
//       setState(() => resultMessage = msg);
//     }
//   }

//   /// 🔹 Handle City/State button
//   void _getByCityState() async {
//     final city = _cityCtrl.text.trim();
//     if (city.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter a city/state')),
//       );
//       return;
//     }

//     final msg = await fetchByCity(city);
//     setState(() => resultMessage = msg);
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
//       appBar: AppBar(title: const Text('HEI Result')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text("Sample HEI: ${_formatDouble(widget.sample.hei)}"),
//             const SizedBox(height: 16),

//             // ✅ Lat/Lon section
//             TextField(
//               controller: _latCtrl,
//               keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: "Latitude"),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _lonCtrl,
//               keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: "Longitude"),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _getByLatLon,
//               child: const Text("Get by Lat/Lon"),
//             ),

//             const SizedBox(height: 16),
//             const Divider(),

//             // ✅ City/State section
//             TextField(
//               controller: _cityCtrl,
//               decoration: const InputDecoration(
//                 labelText: "Enter City or State",
//                 hintText: "e.g. Coimbatore, Tamil Nadu",
//               ),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _getByCityState,
//               child: const Text("Get by City/State (aggregate)"),
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

// class HEIResultScreen extends StatefulWidget {
//   final Sample sample;
//   const HEIResultScreen({super.key, required this.sample});

//   @override
//   State<HEIResultScreen> createState() => _HEIResultScreenState();
// }

// class _HEIResultScreenState extends State<HEIResultScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();
//   final TextEditingController _cityCtrl = TextEditingController();

//   String? resultMessage;

//   // 👉 Update this if running on emulator (use 10.0.2.2 for localhost)
//   final String backendBaseUrl = "http://10.223.107.180:3000";

//   /// 🔹 Format double values safely
//   String _formatDouble(dynamic value, {int digits = 3}) {
//     if (value == null) return "No data";
//     if (value is num) return value.toDouble().toStringAsFixed(digits);
//     return value.toString();
//   }

//   /// 🔹 Fetch HEI by latitude/longitude
//   Future<String> fetchByLatLon(double lat, double lon) async {
//     try {
//       final uri = Uri.parse("$backendBaseUrl/samples?lat=$lat&lon=$lon");
//       final res = await http.get(uri);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         debugPrint("Lat/Lon response: $data");

//         if (data['success'] == true) {
//           // Backend may return direct hei, avgHei, or inside data[]
//           final hei = data['hei'] ??
//               data['avgHei'] ??
//               (data['data'] != null && data['data'].isNotEmpty
//                   ? data['data'][0]['hei']
//                   : null);

//           return "📍 Match found from DB\nHEI = ${_formatDouble(hei)}";
//         } else {
//           return data['message'] ?? "No data found";
//         }
//       } else {
//         return "❌ Error: ${res.statusCode}";
//       }
//     } catch (e) {
//       return "⚠️ Failed to fetch from server: $e";
//     }
//   }

//   /// 🔹 Fetch aggregated HEI by city/state
//   Future<String> fetchByCity(String city) async {
//     try {
//       final uri = Uri.parse("$backendBaseUrl/samples/city-state?name=$city");
//       final res = await http.get(uri);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         debugPrint("City response: $data");

//         if (data['success'] == true) {
//           final hei = data['hei'] ??
//               data['avgHei'] ??
//               (data['data'] != null ? data['data']['avgHei'] : null);

//           return "📍 $city\nAvg HEI = ${_formatDouble(hei)}";
//         } else {
//           return data['message'] ?? "No data found";
//         }
//       } else {
//         return "❌ Error: ${res.statusCode}";
//       }
//     } catch (e) {
//       return "⚠️ Failed to fetch from server: $e";
//     }
//   }

//   /// 🔹 Handle Lat/Lon button
//   void _getByLatLon() async {
//     final lat = double.tryParse(_latCtrl.text.trim());
//     final lon = double.tryParse(_lonCtrl.text.trim());

//     if (lat == null || lon == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Enter valid latitude and longitude")),
//       );
//       return;
//     }

//     if (widget.sample.latitude == lat && widget.sample.longitude == lon) {
//       setState(() {
//         resultMessage =
//             "✅ Local match\nHEI = ${_formatDouble(widget.sample.hei)}";
//       });
//     } else {
//       final msg = await fetchByLatLon(lat, lon);
//       setState(() => resultMessage = msg);
//     }
//   }

//   /// 🔹 Handle City/State button
//   void _getByCityState() async {
//     final city = _cityCtrl.text.trim();
//     if (city.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Enter a city/state")),
//       );
//       return;
//     }

//     final msg = await fetchByCity(city);
//     setState(() => resultMessage = msg);
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
//       appBar: AppBar(title: const Text("HEI Result")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text("Sample HEI: ${_formatDouble(widget.sample.hei)}"),
//             const SizedBox(height: 16),

//             // ✅ Lat/Lon section
//             TextField(
//               controller: _latCtrl,
//               keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: "Latitude"),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _lonCtrl,
//               keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: "Longitude"),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _getByLatLon,
//               child: const Text("Get by Lat/Lon"),
//             ),

//             const SizedBox(height: 16),
//             const Divider(),

//             // ✅ City/State section
//             TextField(
//               controller: _cityCtrl,
//               decoration: const InputDecoration(
//                 labelText: "Enter City or State",
//                 hintText: "e.g. Coimbatore, Tamil Nadu",
//               ),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _getByCityState,
//               child: const Text("Get by City/State (aggregate)"),
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
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/sample.dart';

class HEIResultScreen extends StatefulWidget {
  final Sample sample;
  const HEIResultScreen({super.key, required this.sample});

  @override
  State<HEIResultScreen> createState() => _HEIResultScreenState();
}

class _HEIResultScreenState extends State<HEIResultScreen> {
  final TextEditingController _latCtrl = TextEditingController();
  final TextEditingController _lonCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();

  String? resultMessage;
  final String backendBaseUrl = "http://10.103.230.180:3000";

  String _formatDouble(dynamic value, {int digits = 3}) {
    if (value == null) return "No data";
    if (value is num) return value.toDouble().toStringAsFixed(digits);
    return value.toString();
  }

  Future<String> fetchByLatLon(double lat, double lon) async {
    try {
      final uri = Uri.parse("$backendBaseUrl/samples?lat=$lat&lon=$lon");
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final hei = data['hei'] ??
            data['avgHei'] ??
            (data['data'] != null && data['data'].isNotEmpty
                ? data['data'][0]['hei']
                : null);
        return hei != null
            ? "📍 Match found from DB\nHEI = ${_formatDouble(hei)}"
            : "No HEI data found";
      } else {
        return "❌ Error: ${res.statusCode}";
      }
    } catch (e) {
      return "⚠️ Failed to fetch from server: $e";
    }
  }

  Future<String> fetchByCity(String city) async {
    try {
      final uri = Uri.parse("$backendBaseUrl/samples/city-state?name=$city");
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final hei = data['hei'] ??
            data['avgHei'] ??
            (data['data'] != null ? data['data']['avgHei'] : null);
        return hei != null
            ? "📍 $city\nAvg HEI = ${_formatDouble(hei)}"
            : "No HEI data found for $city";
      } else {
        return "❌ Error: ${res.statusCode}";
      }
    } catch (e) {
      return "⚠️ Failed to fetch from server: $e";
    }
  }

  void _getByLatLon() async {
    final lat = double.tryParse(_latCtrl.text.trim());
    final lon = double.tryParse(_lonCtrl.text.trim());

    if (lat == null || lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid latitude and longitude")),
      );
      return;
    }

    if (widget.sample.latitude == lat && widget.sample.longitude == lon) {
      setState(() {
        resultMessage =
            "✅ Local match\nHEI = ${_formatDouble(widget.sample.hei)}";
      });
    } else {
      final msg = await fetchByLatLon(lat, lon);
      setState(() => resultMessage = msg);
    }
  }

  void _getByCityState() async {
    final city = _cityCtrl.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a city/state")),
      );
      return;
    }

    final msg = await fetchByCity(city);
    setState(() => resultMessage = msg);
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
    const aquaTeal = Color(0xFF14B8A6);
    const white = Color(0xFFFFFFFF);
    const coolGrey = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('HEI Result', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryBlue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: coolGrey, width: 0.5)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Sample HEI: ${_formatDouble(widget.sample.hei)}",
                  style: TextStyle(fontSize: 16, color: primaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _latCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Latitude",
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
                labelText: "Longitude",
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _getByLatLon,
                child: const Text('Get by Lat/Lon', style: TextStyle(fontSize: 16, color: white)),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            TextField(
              controller: _cityCtrl,
              decoration: InputDecoration(
                labelText: "Enter City or State",
                hintText: "e.g. Coimbatore, Tamil Nadu",
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _getByCityState,
                child: const Text('Get by City/State', style: TextStyle(fontSize: 16, color: white)),
              ),
            ),
            const SizedBox(height: 16),
            if (resultMessage != null)
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: coolGrey, width: 0.5)),
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
