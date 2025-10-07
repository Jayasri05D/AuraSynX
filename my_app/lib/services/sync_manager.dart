import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
//import 'sample_hive.dart';
import '../models/sample.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal() {
    _startSync();
  }

  void _startSync() {
    Timer.periodic(const Duration(seconds: 10), (_) => _trySync());
  }

  Future<void> _trySync() async {
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return;

    final box = Hive.box<Sample>('samples');
    for (var sample in box.values) {
      if (sample.syncStatus == 'pending') {
        try {
          final response = await http.post(
            Uri.parse('http://10.223.107.180:3000/samples'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'timestamp': sample.timestamp,
              'latitude': sample.latitude,
              'longitude': sample.longitude,
              'hei': sample.hei,
              'hpi': sample.hpi,
              'classification': sample.classification,
              'rawData': sample.rawData,
            }),
          );
          if (response.statusCode == 200) {
            sample.syncStatus = 'synced';
            await sample.save();
          }
        } catch (_) {
          // leave it as pending for next try
        }
      }
    }
  }
}
