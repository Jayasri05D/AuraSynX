
// import 'package:flutter/material.dart';
// import '../models/sample.dart';

// class ResultPage extends StatelessWidget {
//   final Sample sample;

//   const ResultPage({super.key, required this.sample});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Result'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Summary
//             Card(
//               elevation: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Timestamp: ${sample.timestamp}'),
//                     Text('HEI: ${sample.hei.toStringAsFixed(3)}'),
//                     Text('HPI: ${sample.hpi.toStringAsFixed(3)}'),
//                     Text('Classification: ${sample.classification}'),
//                     if (sample.latitude != null && sample.longitude != null)
//                       Text(
//                           'Location: ${sample.latitude}, ${sample.longitude}'),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Buttons: HPI / HEI / MAP
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context)
//                             .pushNamed('/hpi', arguments: {'sample': sample});
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         child: Text('HPI', style: TextStyle(fontSize: 18)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context)
//                             .pushNamed('/hei', arguments: {'sample': sample});
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         child: Text('HEI', style: TextStyle(fontSize: 18)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).pushNamed('/mapresult');
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         child: Text('Map', style: TextStyle(fontSize: 18)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Optional: Download summary (placeholder for step 2)
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       content: Text(
//                           'Download will be implemented in step 2 (CSV/PDF/Excel)')));
//                 },
//                 child: const Text('Download result'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import '../models/sample.dart';

// class ResultScreen extends StatefulWidget {
//   final List<Sample> samples;
//   final String resultType; // "HPI" or "HEI"

//   const ResultScreen({
//     super.key,
//     required this.samples,
//     required this.resultType,
//   });

//   @override
//   State<ResultScreen> createState() => _ResultScreenState();
// }

// class _ResultScreenState extends State<ResultScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();
//   final TextEditingController _cityCtrl = TextEditingController();

//   double? filteredValue;
//   bool isDownloading = false;

//   void _filterByLatLon() {
//     final lat = double.tryParse(_latCtrl.text.trim());
//     final lon = double.tryParse(_lonCtrl.text.trim());

//     if (lat == null || lon == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter valid latitude & longitude')),
//       );
//       return;
//     }

//     // Find first matching sample
//     final sample = widget.samples.firstWhere(
//       (s) => s.latitude == lat && s.longitude == lon,
//       orElse: () => Sample.empty(),
//     );

//     if (sample.id == null) {
//       setState(() => filteredValue = null);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No sample found for this location')),
//       );
//       return;
//     }

//     setState(() {
//       filteredValue =
//           widget.resultType == "HPI" ? sample.hpi : sample.hei;
//     });
//   }

//   void _filterByCity() async {
//     final city = _cityCtrl.text.trim();
//     if (city.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter a city or state name')),
//       );
//       return;
//     }

//     // TODO: call backend with city/state → fetch values
//     // For now, just show placeholder
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Fetching data for $city (not implemented yet)')),
//     );
//   }

//   Future<void> _downloadResult() async {
//     setState(() => isDownloading = true);

//     await Future.delayed(const Duration(seconds: 2)); // simulate download

//     setState(() => isDownloading = false);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Download complete!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Result - ${widget.resultType}"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             const Text("Search by Latitude & Longitude",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _latCtrl,
//                     keyboardType:
//                         const TextInputType.numberWithOptions(decimal: true),
//                     decoration: const InputDecoration(labelText: "Latitude"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextField(
//                     controller: _lonCtrl,
//                     keyboardType:
//                         const TextInputType.numberWithOptions(decimal: true),
//                     decoration: const InputDecoration(labelText: "Longitude"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _filterByLatLon,
//               child: const Text("Get Result"),
//             ),

//             if (filteredValue != null) ...[
//               const SizedBox(height: 12),
//               Text(
//                 "${widget.resultType} value: $filteredValue",
//                 style: const TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               ElevatedButton.icon(
//                 onPressed: isDownloading ? null : _downloadResult,
//                 icon: const Icon(Icons.download),
//                 label: isDownloading
//                     ? const SizedBox(
//                         height: 18,
//                         width: 18,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : const Text("Download Result"),
//               ),
//             ],

//             const Divider(height: 32),

//             const Text("Search by City / State",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _cityCtrl,
//               decoration: const InputDecoration(
//                 labelText: "Enter City / State name",
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _filterByCity,
//               child: const Text("Get Result by City/State"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/screens/result_screen.dart
// import 'package:flutter/material.dart';
// import '../models/sample.dart';
// import 'result_hub.dart';

// class ResultScreen extends StatelessWidget {
//   final Sample sample;

//   const ResultScreen({super.key, required this.sample});

//   @override
//   Widget build(BuildContext context) {
//     final bool hasLocation = sample.latitude != null && sample.longitude != null;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Result'),
//         actions: [
//           // Top-right button that opens the hub with the three buttons
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => ResultHub(sample: sample)),
//               );
//             },
//             child: const Text(
//               'Results',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Card(
//               elevation: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Timestamp: ${sample.timestamp}'),
//                     const SizedBox(height: 6),
//                     if (hasLocation)
//                       Text(
//                           'Location: ${sample.latitude!.toStringAsFixed(5)}, ${sample.longitude!.toStringAsFixed(5)}'),
//                     const SizedBox(height: 6),
//                     Text('HEI: ${sample.hei.toStringAsFixed(3)}'),
//                     Text('HPI: ${sample.hpi.toStringAsFixed(3)}'),
//                     const SizedBox(height: 6),
//                     Text('Classification: ${sample.classification.toUpperCase()}'),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             const Text('Raw values:', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: sample.rawData.entries
//                       .map((e) => Text('${e.key} : ${e.value}'))
//                       .toList(),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Optional: quick actions (send to server / save / download)
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Send to server (not implemented)')),
//                       );
//                     },
//                     icon: const Icon(Icons.cloud_upload),
//                     label: const Text('Send to server'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/sample.dart';
import '../services/sync_manager.dart';
import 'result_hub.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ResultScreen extends StatelessWidget {
  final Sample sample;

  const ResultScreen({super.key, required this.sample});

  /// Save sample locally (Hive offline-first)
  Future<void> saveSample(Sample sample) async {
    final box = Hive.box<Sample>('samples');

    // Avoid duplicates if needed
    if (!box.values.any((s) => s.timestamp == sample.timestamp)) {
      await box.add(sample);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasLocation = sample.latitude != null && sample.longitude != null;

    // Save sample locally as soon as the screen is built
    saveSample(sample);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ResultHub(sample: sample)),
              );
            },
            child: const Text(
              'Results',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Timestamp: ${sample.timestamp}'),
                    const SizedBox(height: 6),
                    if (hasLocation)
                      Text(
                        'Location: ${sample.latitude!.toStringAsFixed(5)}, ${sample.longitude!.toStringAsFixed(5)}',
                      ),
                    const SizedBox(height: 6),
                    Text('HEI: ${sample.hei.toStringAsFixed(3)}'),
                    Text('HPI: ${sample.hpi.toStringAsFixed(3)}'),
                    const SizedBox(height: 6),
                    Text('Classification: ${sample.classification.toUpperCase()}'),
                    const SizedBox(height: 6),
                    Text('Sync status: ${sample.syncStatus.toUpperCase()}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text('Raw values:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sample.rawData.entries
                      .map((e) => Text('${e.key} : ${e.value}'))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
