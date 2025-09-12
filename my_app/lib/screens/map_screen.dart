
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class MapScreen extends StatelessWidget {
//   final double latitude;
//   final double longitude;
//   final bool isSafe; // true = green, false = red

//   const MapScreen({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//     required this.isSafe,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final LatLng point = LatLng(latitude, longitude);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Map Result')),
//       body: FlutterMap(
//         options: MapOptions(
//           initialCenter: point,
//           initialZoom: 10.0,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: const ['a', 'b', 'c'],
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: point,
//                 width: 50,
//                 height: 50,
//                 child: Icon(
//                   Icons.location_on,
//                   color: isSafe ? Colors.red : Colors.green,
//                   size: 40,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }       
// }


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/sample.dart';
import '../screens/api_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Sample> samples = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSamples();
  }

  Future<void> _fetchSamples() async {
    try {
      final fetched = await ApiService.fetchSamples();
      setState(() {
        samples = fetched;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching samples: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Samples Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSamples,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(11.0, 77.0), // default center
                initialZoom: 6.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: samples
                      .where((s) => s.latitude != null && s.longitude != null)
                      .map(
                        (s) => Marker(
                          point: LatLng(s.latitude!, s.longitude!),
                          width: 50,
                          height: 50,
                          child: Tooltip(
                            message: 'HEI: ${s.hei}, HPI: ${s.hpi}',
                           child: Icon(
  Icons.location_on,
  color: (s.classification.toLowerCase() == 'safe')
      ? Colors.green
      : Colors.red,
  size: 40,
),

                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
    );
  }
}
