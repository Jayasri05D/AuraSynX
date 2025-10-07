
// import 'dart:convert';
// import 'package:hive/hive.dart';

// part 'sample_hive.g.dart'; // Run build_runner to generate adapter

// @HiveType(typeId: 0)
// class Sample extends HiveObject {
//   @HiveField(0)
//   final int? id;

//   @HiveField(1)
//   final String timestamp;

//   @HiveField(2)
//   final double? latitude;

//   @HiveField(3)
//   final double? longitude;

//   /// Stored in app as Map<String,double>
//   /// For Hive, we save as JSON string
//   @HiveField(4)
//   final Map<String, double> rawData;

//   @HiveField(5)
//   final double hei;

//   @HiveField(6)
//   final double hpi;

//   @HiveField(7)
//   final String classification;

//   @HiveField(8)
//   String syncStatus;

//   @HiveField(9)
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

//   // -------------------------------
//   // ✅ API JSON Conversion
//   // -------------------------------

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'timestamp': timestamp,
//       'latitude': latitude,
//       'longitude': longitude,
//       'rawData': rawData, // send as object
//       'hei': hei,
//       'hpi': hpi,
//       'classification': classification,
//       'syncStatus': syncStatus,
//       'serverId': serverId,
//     };
//   }

//   factory Sample.fromJson(Map<String, dynamic> json) {
//     Map<String, double> parsedRawData = {};

//     if (json['rawData'] != null) {
//       if (json['rawData'] is String) {
//         // Handle stringified JSON
//         final decoded = jsonDecode(json['rawData']);
//         if (decoded is Map) {
//           parsedRawData = decoded.map(
//             (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
//           );
//         }
//       } else if (json['rawData'] is Map) {
//         // Handle already-parsed Map
//         parsedRawData = (json['rawData'] as Map).map(
//           (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
//         );
//       }
//     }

//     return Sample(
//       id: json['id'] as int?,
//       timestamp: json['timestamp'] as String? ??
//           DateTime.now().toIso8601String(),
//       latitude:
//           json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
//       longitude: json['longitude'] != null
//           ? (json['longitude'] as num).toDouble()
//           : null,
//       rawData: parsedRawData,
//       hei: (json['hei'] as num?)?.toDouble() ?? 0.0,
//       hpi: (json['hpi'] as num?)?.toDouble() ?? 0.0,
//       classification: json['classification'] as String? ?? 'Unknown',
//       syncStatus: json['syncStatus'] as String? ?? 'pending',
//       serverId: json['serverId'] as int?,
//     );
//   }

//   // -------------------------------
//   // ✅ Hive Conversion
//   // -------------------------------

//   Map<String, dynamic> toHiveMap() {
//     return {
//       'id': id,
//       'timestamp': timestamp,
//       'latitude': latitude,
//       'longitude': longitude,
//       'rawData': jsonEncode(rawData), // store as String
//       'hei': hei,
//       'hpi': hpi,
//       'classification': classification,
//       'syncStatus': syncStatus,
//       'serverId': serverId,
//     };
//   }

//   factory Sample.fromHiveMap(Map<dynamic, dynamic> map) {
//     Map<String, double> parsedRawData = {};
//     if (map['rawData'] != null) {
//       final decoded = jsonDecode(map['rawData']);
//       if (decoded is Map) {
//         parsedRawData = decoded.map(
//           (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
//         );
//       }
//     }

//     return Sample(
//       id: map['id'] as int?,
//       timestamp: map['timestamp'] as String,
//       latitude:
//           map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
//       longitude: map['longitude'] != null
//           ? (map['longitude'] as num).toDouble()
//           : null,
//       rawData: parsedRawData,
//       hei: (map['hei'] as num?)?.toDouble() ?? 0.0,
//       hpi: (map['hpi'] as num?)?.toDouble() ?? 0.0,
//       classification: map['classification'] as String? ?? 'Unknown',
//       syncStatus: map['syncStatus'] as String? ?? 'pending',
//       serverId: map['serverId'] as int?,
//     );
//   }

//   // -------------------------------
//   // ✅ Utility Helpers
//   // -------------------------------

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

//   factory Sample.empty() {
//     return Sample(
//       timestamp: DateTime.now().toIso8601String(),
//       rawData: {},
//       hei: 0.0,
//       hpi: 0.0,
//       classification: 'N/A',
//       syncStatus: 'none',
//     );
//   }
// }

import 'dart:convert';
import 'package:hive/hive.dart';

part 'sample_hive.g.dart'; // Run build_runner to generate adapter

@HiveType(typeId: 0)
class Sample extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String timestamp;

  @HiveField(2)
  final double? latitude;

  @HiveField(3)
  final double? longitude;

  /// Stored in app as Map<String,double>
  /// For Hive, we save as JSON string
  @HiveField(4)
  final Map<String, double> rawData;

  @HiveField(5)
  final double hei;

  @HiveField(6)
  final double hpi;

  @HiveField(7)
  final String classification;

  @HiveField(8)
  String syncStatus;

  @HiveField(9)
  int? serverId;

  @HiveField(10) // ⭐ NEW
  final String? district;

  @HiveField(11) // ⭐ NEW
  final String? state;

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
    this.district, // ⭐ NEW
    this.state, // ⭐ NEW
  });

  // -------------------------------
  // ✅ API JSON Conversion
  // -------------------------------

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'rawData': rawData, // send as object
      'hei': hei,
      'hpi': hpi,
      'classification': classification,
      'syncStatus': syncStatus,
      'serverId': serverId,
      'district': district, // ⭐ NEW
      'state': state, // ⭐ NEW
    };
  }

  factory Sample.fromJson(Map<String, dynamic> json) {
    Map<String, double> parsedRawData = {};

    if (json['rawData'] != null) {
      if (json['rawData'] is String) {
        // Handle stringified JSON
        final decoded = jsonDecode(json['rawData']);
        if (decoded is Map) {
          parsedRawData = decoded.map(
            (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
          );
        }
      } else if (json['rawData'] is Map) {
        // Handle already-parsed Map
        parsedRawData = (json['rawData'] as Map).map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        );
      }
    }

    return Sample(
      id: json['id'] as int?,
      timestamp: json['timestamp'] as String? ??
          DateTime.now().toIso8601String(),
      latitude:
          json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      rawData: parsedRawData,
      hei: (json['hei'] as num?)?.toDouble() ?? 0.0,
      hpi: (json['hpi'] as num?)?.toDouble() ?? 0.0,
      classification: json['classification'] as String? ?? 'Unknown',
      syncStatus: json['syncStatus'] as String? ?? 'pending',
      serverId: json['serverId'] as int?,
      district: json['district'] as String?, // ⭐ NEW
      state: json['state'] as String?, // ⭐ NEW
    );
  }

  // -------------------------------
  // ✅ Hive Conversion
  // -------------------------------

  Map<String, dynamic> toHiveMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'rawData': jsonEncode(rawData), // store as String
      'hei': hei,
      'hpi': hpi,
      'classification': classification,
      'syncStatus': syncStatus,
      'serverId': serverId,
      'district': district, // ⭐ NEW
      'state': state, // ⭐ NEW
    };
  }

  factory Sample.fromHiveMap(Map<dynamic, dynamic> map) {
    Map<String, double> parsedRawData = {};
    if (map['rawData'] != null) {
      final decoded = jsonDecode(map['rawData']);
      if (decoded is Map) {
        parsedRawData = decoded.map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        );
      }
    }

    return Sample(
      id: map['id'] as int?,
      timestamp: map['timestamp'] as String,
      latitude:
          map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
      rawData: parsedRawData,
      hei: (map['hei'] as num?)?.toDouble() ?? 0.0,
      hpi: (map['hpi'] as num?)?.toDouble() ?? 0.0,
      classification: map['classification'] as String? ?? 'Unknown',
      syncStatus: map['syncStatus'] as String? ?? 'pending',
      serverId: map['serverId'] as int?,
      district: map['district'] as String?, // ⭐ NEW
      state: map['state'] as String?, // ⭐ NEW
    );
  }

  // -------------------------------
  // ✅ Utility Helpers
  // -------------------------------

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
    String? district, // ⭐ NEW
    String? state, // ⭐ NEW
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
      district: district ?? this.district, // ⭐ NEW
      state: state ?? this.state, // ⭐ NEW
    );
  }

  factory Sample.empty() {
    return Sample(
      timestamp: DateTime.now().toIso8601String(),
      rawData: {},
      hei: 0.0,
      hpi: 0.0,
      classification: 'N/A',
      syncStatus: 'none',
      district: null, // ⭐ NEW
      state: null, // ⭐ NEW
    );
  }
}

