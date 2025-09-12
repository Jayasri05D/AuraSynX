
//third attempt
// import 'package:flutter/material.dart';
// import '../services/file_parser.dart';
// import '../services/compute.dart';
// import '../services/db_helper.dart';
// import '../models/sample.dart';
// import '../screens/api_service.dart'; // <-- Import your ApiService
// import 'map_screen.dart';
// import '../screens/preview_screen.dart';
// import '../screens/result_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController latController = TextEditingController();
//   final TextEditingController longController = TextEditingController();

//   @override
//   void dispose() {
//     latController.dispose();
//     longController.dispose();
//     super.dispose();
//   }

//   Future<void> pickFile() async {
//     try {
//       final map = await FileParser.pickAndParseFile();
//       if (map == null) return;
//       print('✅ Parsed RawData Map: $map');

//       final double hei = ComputeService().computeHEI(map);
//       final double hpi = ComputeService().computeHPI(map);
//       final String classification = ComputeService().classifyByHEI(hei);

//       final double lat = double.tryParse(latController.text) ?? 11.0;
//       final double lon = double.tryParse(longController.text) ?? 77.0;

//       const standards = {"Pb": 0.01, "Cd": 0.003, "As": 0.01};
//       bool isSafe = map.entries.every((e) =>
//           standards[e.key] == null || e.value <= standards[e.key]!);

//       final sample = Sample(
//         timestamp: DateTime.now().toIso8601String(),
//         latitude: lat,
//         longitude: lon,
//         rawData: map,
//         hei: hei,
//         hpi: hpi,
//         classification: classification,
//         syncStatus: 'pending',
//       );

//       // Save to local Hive DB
//       final key = await DBHelper.instance.insertSample(sample);
//       final savedSample = sample.copyWith(id: int.tryParse(key));

//       if (!mounted) return;

//       // 🔹 Send the sample to backend
//       bool sent = await ApiService.sendSample(savedSample);
//       if (sent) {
//         print('✅ Sample successfully sent to backend!');
//       } else {
//         print('❌ Failed to send sample to backend');
//       }

//       // Navigate to PreviewScreen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => PreviewScreen(
//             sample: savedSample,
//             onProceed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ResultScreen(
//                     latitude: lat,
//                     longitude: lon,
//                     isSafe: isSafe,
//                     sample: savedSample,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking file: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('HEI / HPI - Home')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: latController,
//               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Latitude (optional)'),
//             ),
//             TextField(
//               controller: longController,
//               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Longitude (optional)'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: pickFile,
//               child: const Text('Pick CSV / XLSX / PDF'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//new way to fetch the dAta from the backend

// import 'package:flutter/material.dart';
// import '../services/file_parser.dart';
// import '../services/compute.dart';
// import '../services/db_helper.dart';
// import '../models/sample.dart';
// import '../screens/api_service.dart'; // Make sure this is imported
// import 'map_screen.dart';
// import '../screens/preview_screen.dart';
// import '../screens/result_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController latController = TextEditingController();
//   final TextEditingController longController = TextEditingController();

//   List<Sample> fetchedSamples = []; // Store samples from backend

//   @override
//   void dispose() {
//     latController.dispose();
//     longController.dispose();
//     super.dispose();
//   }

//   Future<void> pickFile() async {
//     try {
//       final map = await FileParser.pickAndParseFile();
//       if (map == null) return;

//       final double hei = ComputeService().computeHEI(map);
//       final double hpi = ComputeService().computeHPI(map);
//       final String classification = ComputeService().classifyByHEI(hei);

//       final double lat = double.tryParse(latController.text) ?? 11.0;
//       final double lon = double.tryParse(longController.text) ?? 77.0;

//       const standards = {"Pb": 0.01, "Cd": 0.003, "As": 0.01};
//       bool isSafe = map.entries.every((e) =>
//           standards[e.key] == null || e.value <= standards[e.key]!);

//       final sample = Sample(
//         timestamp: DateTime.now().toIso8601String(),
//         latitude: lat,
//         longitude: lon,
//         rawData: map,
//         hei: hei,
//         hpi: hpi,
//         classification: classification,
//         syncStatus: 'pending',
//       );

//       // Save to local Hive DB
//       final key = await DBHelper.instance.insertSample(sample);
//       final savedSample = sample.copyWith(id: int.tryParse(key));

//       if (!mounted) return;

//       // Send the sample to backend
//       bool sent = await ApiService.sendSample(savedSample);
//       print(sent ? '✅ Sample sent to backend' : '❌ Failed to send sample');

//       // Navigate to PreviewScreen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => PreviewScreen(
//             sample: savedSample,
//             onProceed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ResultScreen(
//                     latitude: lat,
//                     longitude: lon,
//                     isSafe: isSafe,
//                     sample: savedSample,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking file: $e')),
//       );
//     }
//   }

//   // 🔹 New method: Fetch all samples from backend
//   Future<void> fetchAllSamples() async {
//     try {
//       List<Sample> samples = await ApiService.fetchSamples();
//       setState(() {
//         fetchedSamples = samples;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching samples: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('HEI / HPI - Home')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: latController,
//               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Latitude (optional)'),
//             ),
//             TextField(
//               controller: longController,
//               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Longitude (optional)'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: pickFile,
//               child: const Text('Pick CSV / XLSX / PDF'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: fetchAllSamples,
//               child: const Text('Fetch All Samples from Backend'),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: fetchedSamples.isEmpty
//                   ? const Center(child: Text('No samples fetched yet'))
//                   : ListView.builder(
//                       itemCount: fetchedSamples.length,
//                       itemBuilder: (context, index) {
//                         final sample = fetchedSamples[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 4),
//                           child: ListTile(
//                             title: Text('Sample ID: ${sample.id ?? 'N/A'}'),
//                             subtitle: Text(
//                               'HEI: ${sample.hei}, HPI: ${sample.hpi}, Class: ${sample.classification}',
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/file_parser.dart';
import '../services/compute.dart';
import '../services/db_helper.dart';
import '../models/sample.dart';
import '../screens/api_service.dart';
import 'map_screen.dart';
import '../screens/preview_screen.dart';
import '../screens/result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  List<Sample> fetchedSamples = []; // Store samples from backend

  @override
  void dispose() {
    latController.dispose();
    longController.dispose();
    super.dispose();
  }

  Future<void> pickFile() async {
    try {
      final map = await FileParser.pickAndParseFile();
      if (map == null) return;

      final double hei = ComputeService().computeHEI(map);
      final double hpi = ComputeService().computeHPI(map);
      final String classification = ComputeService().classifyByHEI(hei);

      final double lat = double.tryParse(latController.text) ?? 11.0;
      final double lon = double.tryParse(longController.text) ?? 77.0;

      const standards = {"Pb": 0.01, "Cd": 0.003, "As": 0.01};
      bool isSafe = map.entries.every((e) =>
          standards[e.key] == null || e.value <= standards[e.key]!);

      final sample = Sample(
        timestamp: DateTime.now().toIso8601String(),
        latitude: lat,
        longitude: lon,
        rawData: map,
        hei: hei,
        hpi: hpi,
        classification: classification,
        syncStatus: 'pending',
      );

      // Save to local Hive DB
      final key = await DBHelper.instance.insertSample(sample);
      final savedSample = sample.copyWith(id: int.tryParse(key));

      if (!mounted) return;

      // Send the sample to backend
      bool sent = await ApiService.sendSample(savedSample);
      print(sent ? '✅ Sample sent to backend' : '❌ Failed to send sample');

      // Navigate to PreviewScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(
            sample: savedSample,
            onProceed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultScreen(
                    latitude: lat,
                    longitude: lon,
                    isSafe: isSafe,
                    sample: savedSample,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  // 🔹 Fetch all samples from backend
  Future<void> fetchAllSamples() async {
    try {
      List<Sample> samples = await ApiService.fetchSamples();
      setState(() {
        fetchedSamples = samples;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching samples: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HEI / HPI - Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: latController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Latitude (optional)'),
            ),
            TextField(
              controller: longController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Longitude (optional)'),
            ),
            const SizedBox(height: 16),

            // Upload File
            ElevatedButton(
              onPressed: pickFile,
              child: const Text('Pick CSV / XLSX / PDF'),
            ),
            const SizedBox(height: 16),

            // Fetch Samples
            ElevatedButton(
              onPressed: fetchAllSamples,
              child: const Text('Fetch All Samples from Backend'),
            ),
            const SizedBox(height: 16),

            // 🌍 Show Map with All Samples
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MapScreen()),
                );
              },
              child: const Text('View All Samples on Map'),
            ),
            const SizedBox(height: 16),

            // List of fetched samples
            Expanded(
              child: fetchedSamples.isEmpty
                  ? const Center(child: Text('No samples fetched yet'))
                  : ListView.builder(
                      itemCount: fetchedSamples.length,
                      itemBuilder: (context, index) {
                        final sample = fetchedSamples[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text('Sample ID: ${sample.id ?? 'N/A'}'),
                            subtitle: Text(
                              'HEI: ${sample.hei}, HPI: ${sample.hpi}, Class: ${sample.classification}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

