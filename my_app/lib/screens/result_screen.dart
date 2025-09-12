
// import 'package:flutter/material.dart';
// import '../models/sample.dart';
// import 'map_screen.dart';

// class ResultScreen extends StatelessWidget {
//   final double latitude;
//   final double longitude;
//   final bool isSafe;
//   final Sample sample;

//   const ResultScreen({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//     required this.isSafe,
//     required this.sample,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Result')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('ID: ${sample.id ?? "N/A"}'),
//             Text('Timestamp: ${sample.timestamp}'),
//             Text('Latitude: ${latitude.toStringAsFixed(5)}'),
//             Text('Longitude: ${longitude.toStringAsFixed(5)}'),
//             const SizedBox(height: 12),
//             Text('HEI: ${sample.hei.toStringAsFixed(3)}'),
//             Text('HPI: ${sample.hpi.toStringAsFixed(3)}'),
//             const SizedBox(height: 12),
//             Text('Classification: ${sample.classification.toUpperCase()}'),
//             const SizedBox(height: 20),
//             Expanded(
//               child: MapScreen(
//                 latitude: latitude,
//                 longitude: longitude,
//                 isSafe: isSafe,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/sample.dart';

class ResultScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final bool isSafe;
  final Sample sample;

  const ResultScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.isSafe,
    required this.sample,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng point = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${sample.id ?? "N/A"}'),
            Text('Timestamp: ${sample.timestamp}'),
            Text('Latitude: ${latitude.toStringAsFixed(5)}'),
            Text('Longitude: ${longitude.toStringAsFixed(5)}'),
            const SizedBox(height: 12),
            Text('HEI: ${sample.hei.toStringAsFixed(3)}'),
            Text('HPI: ${sample.hpi.toStringAsFixed(3)}'),
            const SizedBox(height: 12),
            Text('Classification: ${sample.classification.toUpperCase()}'),
            const SizedBox(height: 20),
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: point,
                  initialZoom: 12.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.location_on,
                          color: isSafe ? Colors.green : Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
