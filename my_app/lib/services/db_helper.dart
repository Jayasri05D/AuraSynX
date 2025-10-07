// // import 'dart:convert';
// // import 'package:path/path.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:sqflite/sqflite.dart';
// // import '../models/sample.dart';


// // class DBHelper {
// // DBHelper._privateConstructor();
// // static final DBHelper instance = DBHelper._privateConstructor();
// // static Database? _db;


// // Future<void> init() async {
// // if (_db != null) return;
// // final documentsDirectory = await getApplicationDocumentsDirectory();
// // final path = join(documentsDirectory.path, 'hei_hpi.db');
// // _db = await openDatabase(path, version: 1, onCreate: _onCreate);
// // }


// // Future _onCreate(Database db, int version) async {
// // await db.execute('''
// // CREATE TABLE samples (
// // id INTEGER PRIMARY KEY AUTOINCREMENT,
// // timestamp TEXT,
// // latitude REAL,
// // longitude REAL,
// // raw_data TEXT,
// // hei REAL,
// // hpi REAL,
// // classification TEXT,
// // sync_status TEXT,
// // server_id INTEGER
// // );
// // ''');
// // }


// // Future<int> insertSample(Sample s) async {
// // final db = _db!;
// // return await db.insert('samples', s.toMap());
// // }


// // Future<List<Sample>> fetchAll() async {
// // final db = _db!;
// // final rows = await db.query('samples', orderBy: 'id DESC');
// // return rows.map((r) => Sample.fromMap(r)).toList();
// // }


// // Future<List<Sample>> fetchPending() async {
// // final db = _db!;
// // final rows = await db.query('samples', where: 'sync_status = ?', whereArgs: ['pending']);
// // return rows.map((r) => Sample.fromMap(r)).toList();
// // }


// // Future<int> markSynced(int id, int serverId) async {
// // final db = _db!;
// // return await db.update('samples', {'sync_status': 'synced', 'server_id': serverId}, where: 'id = ?', whereArgs: [id]);
// // }
// // }

// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/sample.dart';

// class DBHelper {
//   DBHelper._privateConstructor();
//   static final DBHelper instance = DBHelper._privateConstructor();

//   late Box _box;

//   // Initialize Hive box
//   Future<void> init() async {
//     // Hive.initFlutter() should be called in main.dart
//     _box = await Hive.openBox('samples');
//   }

//   // Insert sample
//   Future<void> insertSample(Sample s) async {
//     // Add timestamp if not already set
//     final now = DateTime.now();
//     s.timestamp ??= now.toIso8601String();

//     // Use timestamp as key
//     await _box.put(now.millisecondsSinceEpoch.toString(), s.toMap());
//   }

//   // Fetch all samples (latest first)
//   List<Sample> fetchAll() {
//     return _box.values
//         .map((v) => Sample.fromMap(Map<String, dynamic>.from(v)))
//         .toList()
//       ..sort((a, b) => b.timestamp!.compareTo(a.timestamp!)); // latest first
//   }

//   // Fetch pending samples (for sync)
//   List<Sample> fetchPending() {
//     return _box.values
//         .map((v) => Sample.fromMap(Map<String, dynamic>.from(v)))
//         .where((s) => s.syncStatus == 'pending')
//         .toList();
//   }

//   // Mark a sample as synced
//   Future<void> markSynced(String key, int serverId) async {
//     final data = Map<String, dynamic>.from(_box.get(key));
//     data['sync_status'] = 'synced';
//     data['server_id'] = serverId;
//     await _box.put(key, data);
//   }
// }
// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/sample.dart';

// class DBHelper {
//   DBHelper._privateConstructor();
//   static final DBHelper instance = DBHelper._privateConstructor();

//   late Box _box;

//   Future<void> init() async {
//     await Hive.initFlutter();
//     _box = await Hive.openBox('samples');
//   }

//   /// Insert sample and return its key
//   Future<String> insertSample(Sample s) async {
//     final key = DateTime.now().millisecondsSinceEpoch.toString();
//     await _box.put(key, s.toMap());
//     return key;
//   }

//   /// Fetch all samples
//   List<Sample> fetchAll() {
//     return _box.values
//         .map((v) => Sample.fromMap(Map<String, dynamic>.from(v)))
//         .toList()
//       ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
//   }

//   /// Fetch pending samples
//   List<Sample> fetchPending() {
//     return _box.values
//         .map((v) => Sample.fromMap(Map<String, dynamic>.from(v)))
//         .where((s) => s.syncStatus == 'pending')
//         .toList();
//   }

//   /// Mark a sample as synced
//   Future<void> markSynced(String key, int serverId) async {
//     final data = Map<String, dynamic>.from(_box.get(key));
//     data['syncStatus'] = 'synced';
//     data['serverId'] = serverId;
//     await _box.put(key, data);
//   }

//   /// Fetch by key
//   Sample? fetchByKey(String key) {
//     final data = _box.get(key);
//     if (data == null) return null;
//     return Sample.fromMap(Map<String, dynamic>.from(data));
//   }
// }
import 'package:hive_flutter/hive_flutter.dart';
import '../models/sample.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static const String _boxName = 'samples';
  late Box<Sample> _box;

  /// Initialize Hive and open the box safely
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapter if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SampleAdapter());
    }

    // Open the box only if not already open
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box<Sample>(_boxName);
    } else {
      _box = await Hive.openBox<Sample>(_boxName);
    }
  }

  /// Insert a sample
  Future<String> insertSample(Sample s) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await _box.put(key, s);
    return key;
  }

  /// Fetch all samples, sorted by timestamp (latest first)
  List<Sample> fetchAll() {
    return _box.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Fetch pending samples
  List<Sample> fetchPending() {
    return _box.values.where((s) => s.syncStatus == 'pending').toList();
  }

  /// Mark a sample as synced
  Future<void> markSynced(String key, int serverId) async {
    final sample = _box.get(key);
    if (sample != null) {
      sample.syncStatus = 'synced';
      sample.serverId = serverId;
      await sample.save(); // Save the updated object
    }
  }

  /// Fetch by key
  Sample? fetchByKey(String key) {
    return _box.get(key);
  }
}
