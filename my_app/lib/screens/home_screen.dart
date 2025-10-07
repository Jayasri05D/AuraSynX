
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/file_parser.dart';
// import '../services/compute.dart';
// import '../services/db_helper.dart';
// import '../models/sample.dart';
// import 'result_screen.dart';
// import 'result_hub.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();

//   Map<String, double>? parsedData;
//   String? pickedFileName;
//   bool isProcessing = false;
//   Sample? currentSample;

//   Future<void> _pickFile() async {
//     setState(() {
//       parsedData = null;
//       pickedFileName = null;
//       currentSample = null;
//     });

//     final map = await FileParser.pickAndParseFile();
//     if (map == null || map.isEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('No data parsed')));
//       return;
//     }

//     setState(() {
//       parsedData = map;
//       pickedFileName = 'File selected';
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Parsed ${map.length} metals from file')),
//     );
//   }

//   Future<void> _submit() async {
//     if (parsedData == null) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Please select a file')));
//       return;
//     }

//     setState(() => isProcessing = true);

//     try {
//       final compute = Provider.of<ComputeService>(context, listen: false);
//       final hei = compute.computeHEI(parsedData!);
//       final hpi = compute.computeHPI(parsedData!);
//       final classification = compute.classifyByHEI(hei);

//       final latText = _latCtrl.text.trim();
//       final lonText = _lonCtrl.text.trim();
//       final double? lat = latText.isEmpty ? null : double.tryParse(latText);
//       final double? lon = lonText.isEmpty ? null : double.tryParse(lonText);

//       final sample = Sample(
//         timestamp: compute.timestampNow(),
//         latitude: lat,
//         longitude: lon,
//         rawData: parsedData!,
//         hei: hei,
//         hpi: hpi,
//         classification: classification,
//         syncStatus: 'pending',
//       );

//       await DBHelper.instance.insertSample(sample);

//       setState(() {
//         currentSample = sample;
//       });

//       // Navigate to single-result screen
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (_) => ResultScreen(sample: sample)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error processing file: $e')));
//     } finally {
//       setState(() => isProcessing = false);
//     }
//   }

//   @override
//   void dispose() {
//     _latCtrl.dispose();
//     _lonCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AQUAMATRIX'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Scrollable content
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Latitude / Longitude input
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _latCtrl,
//                             keyboardType: const TextInputType.numberWithOptions(
//                                 decimal: true),
//                             decoration: const InputDecoration(
//                               labelText: 'Latitude',
//                               hintText: 'e.g. 11.0168',
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: TextField(
//                             controller: _lonCtrl,
//                             keyboardType: const TextInputType.numberWithOptions(
//                                 decimal: true),
//                             decoration: const InputDecoration(
//                               labelText: 'Longitude',
//                               hintText: 'e.g. 76.9558',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     // File picker
//                     Row(
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: isProcessing ? null : _pickFile,
//                           icon: const Icon(Icons.attach_file),
//                           label: const Text('Add a file'),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(pickedFileName ?? 'No file selected'),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     // Submit button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: isProcessing ? null : _submit,
//                         child: isProcessing
//                             ? const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                     strokeWidth: 2),
//                               )
//                             : const Text('Submit'),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Quick preview of parsed data
//                     if (parsedData != null) ...[
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text('Parsed values (preview):',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         height: 120,
//                         child: ListView(
//                           children: parsedData!.entries
//                               .map((e) => Text('${e.key} : ${e.value}'))
//                               .toList(),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // RESULT HUB BUTTON (always enabled)
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   if (currentSample != null) {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (_) => ResultHub(sample: currentSample!),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('No sample available yet')),
//                     );
//                   }
//                 },
//                 icon: const Icon(Icons.dashboard),
//                 label: const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   child:
//                       Text('Go to Result Hub', style: TextStyle(fontSize: 18)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//with no ui
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/file_parser.dart';
// import '../services/compute.dart';
// import '../services/db_helper.dart';
// import '../models/sample.dart';
// import 'result_screen.dart';
// import 'result_hub.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _lonCtrl = TextEditingController();

//   Map<String, double>? parsedData;
//   String? pickedFileName;
//   bool isProcessing = false;
//   Sample? currentSample;

//   Future<void> _pickFile() async {
//     setState(() {
//       parsedData = null;
//       pickedFileName = null;
//       currentSample = null;
//     });

//     final map = await FileParser.pickAndParseFile();
//     if (map == null || map.isEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('No data parsed')));
//       return;
//     }

//     setState(() {
//       parsedData = map;
//       pickedFileName = 'File selected';
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Parsed ${map.length} metals from file')),
//     );
//   }

//   Future<void> _submit() async {
//     if (parsedData == null) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Please select a file')));
//       return;
//     }

//     setState(() => isProcessing = true);

//     try {
//       final compute = Provider.of<ComputeService>(context, listen: false);
//       final hei = compute.computeHEI(parsedData!);
//       final hpi = compute.computeHPI(parsedData!);
//       final classification = compute.classifyByHEI(hei);

//       final latText = _latCtrl.text.trim();
//       final lonText = _lonCtrl.text.trim();
//       final double? lat = latText.isEmpty ? null : double.tryParse(latText);
//       final double? lon = lonText.isEmpty ? null : double.tryParse(lonText);

//       final sample = Sample(
//         timestamp: compute.timestampNow(),
//         latitude: lat,
//         longitude: lon,
//         rawData: parsedData!,
//         hei: hei,
//         hpi: hpi,
//         classification: classification,
//         syncStatus: 'pending',
//       );

//       await DBHelper.instance.insertSample(sample);

//       setState(() {
//         currentSample = sample;
//       });

//       // Navigate to single-result screen
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (_) => ResultScreen(sample: sample)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error processing file: $e')));
//     } finally {
//       setState(() => isProcessing = false);
//     }
//   }

//   @override
//   void dispose() {
//     _latCtrl.dispose();
//     _lonCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AQUAMATRIX'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Scrollable content
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Latitude / Longitude input
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _latCtrl,
//                             keyboardType: const TextInputType.numberWithOptions(
//                                 decimal: true),
//                             decoration: const InputDecoration(
//                               labelText: 'Latitude',
//                               hintText: 'e.g. 11.0168',
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: TextField(
//                             controller: _lonCtrl,
//                             keyboardType: const TextInputType.numberWithOptions(
//                                 decimal: true),
//                             decoration: const InputDecoration(
//                               labelText: 'Longitude',
//                               hintText: 'e.g. 76.9558',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     // File picker
//                     Row(
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: isProcessing ? null : _pickFile,
//                           icon: const Icon(Icons.attach_file),
//                           label: const Text('Add a file'),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(pickedFileName ?? 'No file selected'),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     // Submit button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: isProcessing ? null : _submit,
//                         child: isProcessing
//                             ? const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                     strokeWidth: 2),
//                               )
//                             : const Text('Submit'),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Quick preview of parsed data
//                     if (parsedData != null) ...[
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text('Parsed values (preview):',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         height: 120,
//                         child: ListView(
//                           children: parsedData!.entries
//                               .map((e) => Text('${e.key} : ${e.value}'))
//                               .toList(),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // RESULT HUB BUTTON (always enabled)
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => ResultHub(sample: currentSample),
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.dashboard),
//                 label: const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   child:
//                       Text('Go to Result Hub', style: TextStyle(fontSize: 18)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/file_parser.dart';
import '../services/compute.dart';
import '../services/db_helper.dart';
import '../models/sample.dart';
import 'result_screen.dart';
import 'result_hub.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _latCtrl = TextEditingController();
  final TextEditingController _lonCtrl = TextEditingController();

  Map<String, double>? parsedData;
  String? pickedFileName;
  bool isProcessing = false;
  Sample? currentSample;

  Future<void> _pickFile() async {
    setState(() {
      parsedData = null;
      pickedFileName = null;
      currentSample = null;
    });

    final map = await FileParser.pickAndParseFile();
    if (map == null || map.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data parsed')),
      );
      return;
    }

    setState(() {
      parsedData = map;
      pickedFileName = 'File selected';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Parsed ${map.length} metals from file')),
    );
  }

  Future<void> _submit() async {
    if (parsedData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file')),
      );
      return;
    }

    setState(() => isProcessing = true);

    try {
      final compute = Provider.of<ComputeService>(context, listen: false);
      final hei = compute.computeHEI(parsedData!);
      final hpi = compute.computeHPI(parsedData!);
      final classification = compute.classifyByHEI(hei);

      final latText = _latCtrl.text.trim();
      final lonText = _lonCtrl.text.trim();
      final double? lat = latText.isEmpty ? null : double.tryParse(latText);
      final double? lon = lonText.isEmpty ? null : double.tryParse(lonText);

      final sample = Sample(
        timestamp: compute.timestampNow(),
        latitude: lat,
        longitude: lon,
        rawData: parsedData!,
        hei: hei,
        hpi: hpi,
        classification: classification,
        syncStatus: 'pending',
      );

      await DBHelper.instance.insertSample(sample);

      setState(() {
        currentSample = sample;    
      });

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultScreen(sample: sample)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing file: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  void dispose() {
    _latCtrl.dispose();
    _lonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Updated color palette
    const deepBlue = Color(0xFF1E3A8A); // primary
    const white = Color(0xFFFFFFFF); // background
    const coolGrey = Color(0xFF6B7280); // text/icons
    const aquaTeal = Color(0xFF14B8A6); // highlight

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text(
          '🌊 AQUAMATRIX',
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: deepBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // LOCATION INPUT
                    Card(
                      color: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: coolGrey, width: 0.5),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "📍 Location Info",
                              style: TextStyle(
                                color: deepBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _latCtrl,
                                    style: const TextStyle(color: deepBlue),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(decimal: true),
                                    decoration: InputDecoration(
                                      labelText: 'Latitude',
                                      hintText: 'e.g. 11.0168',
                                      labelStyle: const TextStyle(color: coolGrey),
                                      hintStyle: const TextStyle(color: coolGrey),
                                      prefixIcon: const Icon(Icons.place, color: aquaTeal),
                                      filled: true,
                                      fillColor: white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: aquaTeal),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: aquaTeal, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _lonCtrl,
                                    style: const TextStyle(color: deepBlue),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(decimal: true),
                                    decoration: InputDecoration(
                                      labelText: 'Longitude',
                                      hintText: 'e.g. 76.9558',
                                      labelStyle: const TextStyle(color: coolGrey),
                                      hintStyle: const TextStyle(color: coolGrey),
                                      prefixIcon: const Icon(Icons.place, color: aquaTeal),
                                      filled: true,
                                      fillColor: white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: aquaTeal),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: aquaTeal, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // FILE UPLOAD
                    Card(
                      color: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: coolGrey, width: 0.5),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "📂 File Upload",
                              style: TextStyle(
                                color: deepBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: aquaTeal,
                                    foregroundColor: white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                  onPressed: isProcessing ? null : _pickFile,
                                  icon: const Icon(Icons.attach_file),
                                  label: const Text('Add a file'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    pickedFileName ?? 'No file selected',
                                    style: TextStyle(
                                      color: pickedFileName == null ? coolGrey : deepBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // SUBMIT
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: aquaTeal,
                          foregroundColor: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: isProcessing ? null : _submit,
                        child: isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: white,
                                ),
                              )
                            : const Text(
                                '🚀 Submit',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PARSED DATA PREVIEW
                    if (parsedData != null) ...[
                      Card(
                        color: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: coolGrey, width: 0.5),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "🔍 Parsed values (preview):",
                                style: TextStyle(
                                  color: deepBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 120,
                                child: ListView(
                                  children: parsedData!.entries
                                      .map((e) => Text(
                                            '${e.key} : ${e.value.toStringAsFixed(3)}',
                                            style: const TextStyle(color: deepBlue),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // RESULT HUB
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: deepBlue,
                  foregroundColor: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ResultHub(sample: currentSample),
                    ),
                  );
                },
                icon: const Icon(Icons.dashboard, size: 22),
                label: const Text(
                  'Go to Result Hub',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
