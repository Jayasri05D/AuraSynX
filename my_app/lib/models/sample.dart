// import 'dart:convert';
// class Sample {
//   int? id;
//   String timestamp;          // must not be null
//   double? latitude;
//   double? longitude;
//   Map<String, double> rawData;
//   double hei;
//   double hpi;
//   String classification;
//   String syncStatus;         // default 'pending'
//   int? serverId;

//   Sample({
//     this.id,
//     required this.timestamp,
//     this.latitude,
//     this.longitude,
//     required this.rawData,
//     required this.hei,
//     required this.hpi,
//     required this.classification,
//     this.syncStatus = 'pending',
//     this.serverId,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'timestamp': timestamp,
//       'latitude': latitude,
//       'longitude': longitude,
//       'rawData': jsonEncode(rawData), // encode Map to string
//       'hei': hei,
//       'hpi': hpi,
//       'classification': classification,
//       'syncStatus': syncStatus,
//       'serverId': serverId,
//     };
//   }

//   factory Sample.fromMap(Map<String, dynamic> m) {
//     return Sample(
//       id: m['id'] as int?,
//       timestamp: m['timestamp'] as String? ?? DateTime.now().toIso8601String(),
//       latitude: m['latitude'] != null ? (m['latitude'] as num).toDouble() : null,
//       longitude: m['longitude'] != null ? (m['longitude'] as num).toDouble() : null,
//       rawData: m['rawData'] != null
//           ? Map<String, double>.from(
//               (jsonDecode(m['rawData']) as Map).map(
//                 (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
//               ),
//             )
//           : {},
//       hei: (m['hei'] as num?)?.toDouble() ?? 0.9,
//       hpi: (m['hpi'] as num?)?.toDouble() ?? 0.0,
//       classification: m['classification'] as String? ?? 'Unknown',
//       syncStatus: m['syncStatus'] as String? ?? 'pending',
//       serverId: m['serverId'] as int?,
//     );
//   }

//   Sample copyWith({
//     int? id,
//     String? timestamp,
//     double? latitude,
//     double? longitude,
//     Map<String, double>? rawData,
//     double? hei,
//     double? hpi,
//     String? classification,
//     String? syncStatus,
//     int? serverId,
//   }) {
//     return Sample(
//       id: id ?? this.id,
//       timestamp: timestamp ?? this.timestamp,
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//       rawData: rawData ?? this.rawData,
//       hei: hei ?? this.hei,
//       hpi: hpi ?? this.hpi,
//       classification: classification ?? this.classification,
//       syncStatus: syncStatus ?? this.syncStatus,
//       serverId: serverId ?? this.serverId,
//     );
//   }
// }

//second attempt
// import 'dart:convert';

// class Sample {
//   int? id;
//   String timestamp;          // must not be null
//   double? latitude;
//   double? longitude;
//   Map<String, double> rawData;
//   double hei;
//   double hpi;
//   String classification;
//   String syncStatus;         // default 'pending'
//   int? serverId;

//   Sample({
//     this.id,
//     required this.timestamp,
//     this.latitude,
//     this.longitude,
//     required this.rawData,
//     required this.hei,
//     required this.hpi,
//     required this.classification,
//     this.syncStatus = 'pending',
//     this.serverId,
//   });

//   /// Convert Sample object to Map (for Hive or API)
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'timestamp': timestamp,
//       'latitude': latitude,
//       'longitude': longitude,
//       'rawData': jsonEncode(rawData), // Encode Map<String, double> to JSON
//       'hei': hei,
//       'hpi': hpi,
//       'classification': classification,
//       'syncStatus': syncStatus,
//       'serverId': serverId,
//     };
//   }

//   /// Convert Map to Sample object (from Hive or API)
//   factory Sample.fromMap(Map<String, dynamic> map) {
//     return Sample(
//       id: map['id'] as int?,
//       timestamp: map['timestamp'] as String? ?? DateTime.now().toIso8601String(),
//       latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
//       longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
//       rawData: map['rawData'] != null
//           ? Map<String, double>.from(
//               (jsonDecode(map['rawData']) as Map).map(
//                 (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
//               ),
//             )
//           : {},
//       hei: (map['hei'] as num?)?.toDouble() ?? 0.0,
//       hpi: (map['hpi'] as num?)?.toDouble() ?? 0.0,
//       classification: map['classification'] as String? ?? 'Unknown',
//       syncStatus: map['syncStatus'] as String? ?? 'pending',
//       serverId: map['serverId'] as int?,
//     );
//   }

//   /// Convert Sample object to JSON for API
//   Map<String, dynamic> toJson() => toMap();

//   /// Create a copy with optional overrides
//   Sample copyWith({
//     int? id,
//     String? timestamp,
//     double? latitude,
//     double? longitude,
//     Map<String, double>? rawData,
//     double? hei,
//     double? hpi,
//     String? classification,
//     String? syncStatus,
//     int? serverId,
//   }) {
//     return Sample(
//       id: id ?? this.id,
//       timestamp: timestamp ?? this.timestamp,
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//       rawData: rawData ?? this.rawData,
//       hei: hei ?? this.hei,
//       hpi: hpi ?? this.hpi,
//       classification: classification ?? this.classification,
//       syncStatus: syncStatus ?? this.syncStatus,
//       serverId: serverId ?? this.serverId,
//     );
//   }
// }
import 'dart:convert';

class Sample {
  int? id;
  String timestamp;
  double? latitude;
  double? longitude;
  Map<String, double> rawData;
  double hei;
  double hpi;
  String classification;
  String syncStatus;
  int? serverId;

  Sample({
    this.id,
    required this.timestamp,
    this.latitude,
    this.longitude,
    required this.rawData,
    required this.hei,
    required this.hpi,
    required this.classification,
    this.syncStatus = 'pending',
    this.serverId,
  });

  /// Convert Sample object to Map (for Hive or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'rawData': jsonEncode(rawData),
      'hei': hei,
      'hpi': hpi,
      'classification': classification,
      'syncStatus': syncStatus,
      'serverId': serverId,
    };
  }

  /// Convert Map to Sample object
  factory Sample.fromMap(Map<String, dynamic> map) {
    return Sample(
      id: map['id'] as int?,
      timestamp: map['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
      rawData: map['rawData'] != null
          ? Map<String, double>.from(
              (jsonDecode(map['rawData']) as Map).map(
                (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
              ),
            )
          : {},
      hei: (map['hei'] as num?)?.toDouble() ?? 0.0,
      hpi: (map['hpi'] as num?)?.toDouble() ?? 0.0,
      classification: map['classification'] as String? ?? 'Unknown',
      syncStatus: map['syncStatus'] as String? ?? 'pending',
      serverId: map['serverId'] as int?,
    );
  }

  /// ✅ JSON compatibility
  factory Sample.fromJson(Map<String, dynamic> json) => Sample.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  Sample copyWith({
    int? id,
    String? timestamp,
    double? latitude,
    double? longitude,
    Map<String, double>? rawData,
    double? hei,
    double? hpi,
    String? classification,
    String? syncStatus,
    int? serverId,
  }) {
    return Sample(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rawData: rawData ?? this.rawData,
      hei: hei ?? this.hei,
      hpi: hpi ?? this.hpi,
      classification: classification ?? this.classification,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
    );
  }
}
