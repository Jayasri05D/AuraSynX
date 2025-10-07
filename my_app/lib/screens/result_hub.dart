// // lib/screens/result_hub.dart
// import 'package:flutter/material.dart';
// import '../models/sample.dart';
// import 'hpi_result_screen.dart';
// import 'hei_result_screen.dart';
// import 'map_screen.dart'; // your existing MapScreen

// class ResultHub extends StatelessWidget {
//   final Sample sample;
//   const ResultHub({super.key, required this.sample});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Results Hub'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Quick summary at top (optional)
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
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => HPIResultScreen(sample: sample),
//                           ),
//                         );
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
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => HEIResultScreen(sample: sample),
//                           ),
//                         );
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
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const MapScreen()),
//                         );
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

//             // optional: go back to the single-result screen
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Back to result'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/screens/result_hub.dart
// import 'package:flutter/material.dart';
// import '../models/sample.dart';
// import 'hpi_result_screen.dart';
// import 'hei_result_screen.dart';
// import 'map_screen.dart';

// class ResultHub extends StatelessWidget {
//   final Sample? sample; // optional sample
//   const ResultHub({super.key, this.sample});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Results Hub'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Optional summary card
//             if (sample != null)
//               Card(
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Timestamp: ${sample!.timestamp}'),
//                       Text('HEI: ${sample!.hei.toStringAsFixed(3)}'),
//                       Text('HPI: ${sample!.hpi.toStringAsFixed(3)}'),
//                       Text('Classification: ${sample!.classification}'),
//                     ],
//                   ),
//                 ),
//               ),

//             if (sample != null) const SizedBox(height: 24),

//             // Buttons
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // HPI Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => HPIResultScreen(
//                               sample: sample ??
//                                   Sample.empty(), // fallback sample if null
//                             ),
//                           ),
//                         );
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         child: Text('HPI', style: TextStyle(fontSize: 18)),
//                       ),
//                     ),     
//                   ),
//                   const SizedBox(height: 12),

//                   // HEI Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => HEIResultScreen(
//                               sample: sample ?? Sample.empty(),
//                             ),
//                           ),
//                         );
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         child: Text('HEI', style: TextStyle(fontSize: 18)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Map Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => const MapScreen(),
//                           ),
//                         );
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

//             // Back Button
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Back'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../models/sample.dart';
import 'hpi_result_screen.dart';
import 'hei_result_screen.dart';
import 'map_screen.dart';

class ResultHub extends StatelessWidget {
  final Sample? sample; // optional sample
  const ResultHub({super.key, this.sample});

  @override
  Widget build(BuildContext context) {
    // 🎨 Theme colors
    const deepBlue = Color(0xFF1E3A8A);
    const white = Color(0xFFFFFFFF);
    const coolGrey = Color(0xFF6B7280);
    const aquaTeal = Color(0xFF14B8A6);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text(
          'Results Hub',
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: deepBlue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Optional summary card
            if (sample != null)
              Card(
                color: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: coolGrey, width: 0.5),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Timestamp: ${sample!.timestamp}',
                        style: TextStyle(color: deepBlue),
                      ),
                      Text(
                        'HEI: ${sample!.hei.toStringAsFixed(3)}',
                        style: TextStyle(color: deepBlue),
                      ),
                      Text(
                        'HPI: ${sample!.hpi.toStringAsFixed(3)}',
                        style: TextStyle(color: deepBlue),
                      ),
                      Text(
                        'Classification: ${sample!.classification}',
                        style: TextStyle(color: deepBlue),
                      ),
                    ],
                  ),
                ),
              ),

            if (sample != null) const SizedBox(height: 24),

            // Buttons
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // HPI Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: aquaTeal,
                        foregroundColor: white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HPIResultScreen(
                              sample: sample ?? Sample.empty(),
                            ),
                          ),
                        );
                      },
                      child: const Text('HPI', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // HEI Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: aquaTeal,
                        foregroundColor: white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HEIResultScreen(
                              sample: sample ?? Sample.empty(),
                            ),
                          ),
                        );
                      },
                      child: const Text('HEI', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Map Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepBlue,
                        foregroundColor: white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MapScreen()),
                        );
                      },
                      child: const Text('Map', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Back Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: deepBlue),
                  foregroundColor: deepBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

