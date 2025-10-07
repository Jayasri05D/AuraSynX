
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/db_helper.dart';
import '../models/sample.dart';

class MapResultScreen extends StatefulWidget {
  const MapResultScreen({super.key});

  @override
  State<MapResultScreen> createState() => _MapResultScreenState();
}

class _MapResultScreenState extends State<MapResultScreen> {
  List<Sample> samples = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadLocalSamples();
  }

  Future<void> _loadLocalSamples() async {
    final all = await DBHelper.instance.fetchAll();
    setState(() {
      samples = all;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Map')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final defaultCenter = samples.isNotEmpty &&
            samples.first.latitude != null &&
            samples.first.longitude != null
        ? LatLng(samples.first.latitude!, samples.first.longitude!)
        : const LatLng(11.0, 77.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: defaultCenter,
          initialZoom: 6,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: samples
                .where((s) => s.latitude != null && s.longitude != null)
                .map((s) => Marker(
                      point: LatLng(s.latitude!, s.longitude!),
                      width: 50,
                      height: 50,
                      child: Tooltip(
                        message:
                            'HEI: ${s.hei}, HPI: ${s.hpi}\n${s.classification}',
                        child: Icon(
                          Icons.location_on,
                          color: s.classification.toLowerCase() == 'safe'
                              ? Colors.green
                              : Colors.red,
                          size: 36,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
