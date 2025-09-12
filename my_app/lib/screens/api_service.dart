// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../config.dart';
// import '../models/sample.dart';

// class ApiService {
//   static Future<bool> syncSample(Sample sample) async {
//     final url = Uri.parse('$BASE_URL/samples');
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(sample.toJson()), // Add a toJson() in Sample model
//       );

//       if (response.statusCode == 200) {
//         print("✅ Sample synced successfully");
//         return true;
//       } else {
//         print("❌ Sync failed: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print("❌ Error syncing: $e");
//       return false;
//     }
//   }
// }
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../models/sample.dart';

class ApiService {
  // Send sample (POST)
  static Future<bool> sendSample(Sample sample) async {
    final url = Uri.parse('$BASE_URL/samples');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(sample.toJson()),
      );

      if (response.statusCode == 200) {
        print("✅ Sample sent successfully: ${response.body}");
        return true;
      } else {
        print("❌ Send failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error sending sample: $e");
      return false;
    }
  }

  // Fetch all samples (GET)
  static Future<List<Sample>> fetchSamples() async {
    final url = Uri.parse('$BASE_URL/samples');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Sample.fromJson(item)).toList();
      } else {
        print("❌ Fetch failed: ${response.body}");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching samples: $e");
      return [];
    }
  }
}
