// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:provider/provider.dart';
// // import '../services/compute.dart';
// // import '../models/sample.dart';
// // import '../services/db_helper.dart';


// // class PreviewScreen extends StatelessWidget {
// // const PreviewScreen({super.key});


// // @override
// // Widget build(BuildContext context) {
// // final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
// // final Map<String, double> parsed = Map<String, double>.from(args['parsed'] as Map);
// // final lat = (args['lat'] ?? '') as String;
// // final long = (args['long'] ?? '') as String;


// // return Scaffold(
// // appBar: AppBar(title: const Text('Preview Parsed Data')),
// // body: Padding(
// // padding: const EdgeInsets.all(12.0),
// // child: Column(
// // crossAxisAlignment: CrossAxisAlignment.stretch,
// // children: [
// // Expanded(
// // child: ListView(
// // children: parsed.entries.map((e) => ListTile(
// // title: Text(e.key),
// // trailing: Text(e.value.toString()),
// // )).toList(),
// // ),
// // ),
// // ElevatedButton(
// // onPressed: () async {
// // final compute = Provider.of<ComputeService>(context, listen: false);
// // final hei = compute.computeHEI(parsed);
// // final hpi = compute.computeHPI(parsed);
// // final heiClass = compute.classifyByHEI(hei);
// // final hpiClass = compute.classifyByHPI(hpi);
// // final classification = (hpiClass == 'unsafe' || heiClass == 'unsafe') ? 'unsafe' : ((heiClass == 'moderate' || hpiClass == 'safe') ? 'moderate' : 'safe');


// // final sample = Sample(
// // timestamp: compute.timestampNow(),
// // latitude: double.tryParse(lat) ?? 0.0,
// // longitude: double.tryParse(long) ?? 0.0,
// // rawData: parsed,
// // hei: hei,
// // hpi: hpi,
// // classification: classification,
// // );


// // // save to db
// // final db = Provider.of<DBHelper>(context, listen: false);
// // final id = await db.insertSample(sample);


// // // go to result page
// // Navigator.pushReplacementNamed(context, '/result', arguments: {'sampleId': id});
// // },
// // child: const Text('Compute & Save Locally'),
// // ),
// // ],
// // ),
// // ),
// // );
// // }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/compute.dart';
// import '../services/db_helper.dart';
// import '../models/sample.dart';

// class PreviewScreen extends StatelessWidget {
//   const PreviewScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Receive arguments from HomeScreen
//     final args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     final Map<String, double> parsed =
//         Map<String, double>.from(args['parsed'] as Map);
//     final latStr = args['lat'] as String? ?? '';
//     final longStr = args['long'] as String? ?? '';

//     // Parse latitude and longitude safely
//     final lat = double.tryParse(latStr) ?? 0.0;
//     final long = double.tryParse(longStr) ?? 0.0;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Preview Parsed Data')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: ListView(
//                 children: parsed.entries
//                     .map((e) => ListTile(
//                           title: Text(e.key),
//                           trailing: Text(e.value.toString()),
//                         ))
//                     .toList(),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   final compute =
//                       Provider.of<ComputeService>(context, listen: false);
//                   final hei = compute.computeHEI(parsed);
//                   final hpi = compute.computeHPI(parsed);
//                   final heiClass = compute.classifyByHEI(hei);
//                   final hpiClass = compute.classifyByHPI(hpi);
//                   final classification = (hpiClass == 'unsafe' ||
//                           heiClass == 'unsafe')
//                       ? 'unsafe'
//                       : ((heiClass == 'moderate' || hpiClass == 'safe')
//                           ? 'moderate'
//                           : 'safe');

//                   final sample = Sample(
//                     timestamp: compute.timestampNow(),
//                     latitude: lat,
//                     longitude: long,
//                     rawData: parsed,
//                     hei: hei,
//                     hpi: hpi,
//                     classification: classification,
//                   );

//                   // Save to Hive DB
//                   final db = Provider.of<DBHelper>(context, listen: false);
//                   await db.insertSample(sample);

//                   // Navigate to result screen using timestamp as unique id
//                   Navigator.pushReplacementNamed(context, '/result',
//                       arguments: {'sampleId': sample.timestamp});
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//               child: const Text('Compute & Save Locally'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import '../models/sample.dart';

// class PreviewScreen extends StatelessWidget {
//   const PreviewScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final sample = ModalRoute.of(context)!.settings.arguments as Sample;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Preview")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("HEI: ${sample.hei.toStringAsFixed(3)}"),
//             Text("HPI: ${sample.hpi.toStringAsFixed(3)}"),
//             Text("Classification: ${sample.classification}"),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/result', arguments: sample);
//               },
//               child: const Text("View Result"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../models/sample.dart';

class PreviewScreen extends StatelessWidget {
  final Sample sample; // receive sample as a parameter
  final VoidCallback onProceed; // callback when user presses "View Result"

  const PreviewScreen({
    super.key,
    required this.sample,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("HEI: ${sample.hei.toStringAsFixed(3)}"),
            Text("HPI: ${sample.hpi.toStringAsFixed(3)}"),
            Text("Classification: ${sample.classification}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onProceed, // call the passed callback
              child: const Text("View Result"),
            ),
          ],
        ),
      ),
    );
  }
}
