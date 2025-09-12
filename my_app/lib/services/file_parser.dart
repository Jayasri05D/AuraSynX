// import 'dart:io' show File; // Only for non-web
// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
// import 'package:csv/csv.dart';
// import 'package:excel/excel.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// class FileParser {
//   // Picks and parses file. Returns Map<metal, value>
//   static Future<Map<String, double>?> pickAndParseFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv', 'xlsx', 'xls', 'pdf'],
//       withData: true, // Important for web support
//     );
//     if (result == null) return null;

//     final file = result.files.single;
//     final ext = file.extension?.toLowerCase();

//     if (ext == 'csv') {
//       final content = file.bytes != null
//           ? String.fromCharCodes(file.bytes!)
//           : await File(file.path!).readAsString();
//       return parseCsv(content);
//     } else if (ext == 'xlsx' || ext == 'xls') {
//       final bytes = file.bytes ?? await File(file.path!).readAsBytes();
//       final excel = Excel.decodeBytes(bytes);
//       return parseExcel(excel);
//     } else if (ext == 'pdf') {
//       final bytes = file.bytes ?? await File(file.path!).readAsBytes();
//       return parseFromPdfBytes(bytes);
//     }
//     return null;
//   }

//   static Map<String, double> parseCsv(String content) {
//     final rows = const CsvToListConverter().convert(content);
//     final map = <String, double>{};
//     for (var r in rows.skip(1)) {
//       if (r.isEmpty) continue;
//       final key = r[0].toString().trim();
//       final val = double.tryParse(r[1].toString()) ?? 0.0;
//       if (key.isNotEmpty) map[key] = val;
//     }
//     return map;
//   }

//   static Map<String, double> parseExcel(Excel excel) {
//     final sheet = excel.tables[excel.tables.keys.first]!;
//     final map = <String, double>{};
//     for (int r = 1; r < sheet.maxRows; r++) {
//       final row = sheet.row(r);
//       if (row.isEmpty) continue;
//       final key = row[0]?.value?.toString() ?? '';
//       final val = double.tryParse(
//               row.length > 1 ? row[1]?.value.toString() ?? '0' : '0') ??
//           0.0;
//       if (key.isNotEmpty) map[key] = val;
//     }
//     return map;
//   }

//   static Map<String, double> parseFromPdfBytes(Uint8List bytes) {
//     final document = PdfDocument(inputBytes: bytes);
//     final extractor = PdfTextExtractor(document);
//     final text = extractor.extractText();
//     document.dispose();

//     final map = <String, double>{};
//     final regex = RegExp(r'([A-Za-z]{1,3})[:\s]+([\d\.Ee-]+)');
//     for (final m in regex.allMatches(text)) {
//       final metal = m.group(1)!;
//       final val = double.tryParse(m.group(2)!) ?? 0.0;
//       map[metal] = val;
//     }
//     return map;
//   }
// }


// import 'dart:typed_data';
// import 'dart:io' show File; // Only for non-web
// import 'package:file_picker/file_picker.dart';
// import 'package:csv/csv.dart';
// import 'package:excel/excel.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// class FileParser {
//   /// Picks a file (CSV, XLSX, XLS, PDF) and parses it into Map<metal, value>
//   static Future<Map<String, double>?> pickAndParseFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv', 'xlsx', 'xls', 'pdf'],
//       withData: true, // required for web
//     );

//     if (result == null) return null;

//     final file = result.files.single;
//     final ext = file.extension?.toLowerCase();

//     if (ext == 'csv') {
//       final content = file.bytes != null
//           ? String.fromCharCodes(file.bytes!)
//           : await File(file.path!).readAsString();
//       return parseCsv(content);
//     } else if (ext == 'xlsx' || ext == 'xls') {
//       final bytes = file.bytes ?? await File(file.path!).readAsBytes();
//       final excel = Excel.decodeBytes(bytes);
//       return parseExcel(excel);
//     } else if (ext == 'pdf') {
//       final bytes = file.bytes ?? await File(file.path!).readAsBytes();
//       return parseFromPdfBytes(bytes);
//     }

//     return null;
//   }

//   /// Parse CSV content into Map<metal, value>
//   static Map<String, double> parseCsv(String content) {
//     final rows = const CsvToListConverter().convert(content);
//     final map = <String, double>{};

//     for (var r in rows.skip(1)) {
//       if (r.isEmpty) continue;
//       final key = r[0].toString().trim().toUpperCase(); // normalize key
//       final val = double.tryParse(r[1].toString()) ?? 0.0;
//       if (key.isNotEmpty) map[key] = val;
//     }

//     return map;
//   }

//   /// Parse Excel file into Map<metal, value>
//   static Map<String, double> parseExcel(Excel excel) {
//     final sheet = excel.tables[excel.tables.keys.first]!;
//     final map = <String, double>{};

//     for (int r = 1; r < sheet.maxRows; r++) {
//       final row = sheet.row(r);
//       if (row.isEmpty) continue;
//       final key = (row[0]?.value?.toString() ?? '').trim().toUpperCase();
//       final val = double.tryParse(
//               row.length > 1 ? row[1]?.value.toString() ?? '0' : '0') ??
//           0.0;
//       if (key.isNotEmpty) map[key] = val;
//     }

//     return map;
//   }

//   /// Parse PDF file into Map<metal, value>
//   static Map<String, double> parseFromPdfBytes(Uint8List bytes) {
//     final document = PdfDocument(inputBytes: bytes);
//     final extractor = PdfTextExtractor(document);
//     final text = extractor.extractText();
//     document.dispose();

//     final map = <String, double>{};
//     final regex = RegExp(r'([A-Za-z]{1,3})[:\s]+([\d\.Ee-]+)');

//     for (final m in regex.allMatches(text)) {
//       final metal = m.group(1)!.toUpperCase(); // normalize key
//       final val = double.tryParse(m.group(2)!) ?? 0.0;
//       map[metal] = val;
//     }

//     return map;
//   }
// }

// import 'dart:typed_data';
// import 'dart:io' show File; // Only for non-web
// import 'package:file_picker/file_picker.dart';
// import 'package:csv/csv.dart';
// import 'package:excel/excel.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// class FileParser {
//   /// Picks a file (CSV, XLSX, XLS, PDF) and parses it into Map<metal, value>
//   static Future<Map<String, double>?> pickAndParseFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv', 'xlsx', 'xls', 'pdf'],
//       withData: true, // required for web
//     );

//     if (result == null) 
//     {
//           print("❌ No file selected");
//       return null;
//     }
  
//     final file = result.files.single;
//     final ext = file.extension?.toLowerCase();

//     if (ext == 'csv') {
//       final content = file.bytes != null
//           ? String.fromCharCodes(file.bytes!)
//           : await File(file.path!).readAsString();
//       return parseCsv(content);
//     } else if (ext == 'xlsx' || ext == 'xls') {
//       final bytes = file.bytes ?? await File(file.path!).readAsBytes();
//       final excel = Excel.decodeBytes(bytes);
//       return parseExcel(excel);
//     } else if (ext == 'pdf') {
//       final bytes = file.bytes ?? await File(file.path!).readAsBytes();
//       return parseFromPdfBytes(bytes);
//     }

//     return null;
//   }

//   /// Helper: Safely parse a double from any input
//   static double parseDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is num) return value.toDouble();
//     if (value is String) return double.tryParse(value.replaceAll(',', '').trim()) ?? 0.0;
//     return 0.0;
//   }

//   /// Parse CSV content into Map<metal, value>
//   static Map<String, double> parseCsv(String content) {
//     final rows = const CsvToListConverter().convert(content);
//     final map = <String, double>{};

//     for (var r in rows.skip(1)) {
//       if (r.isEmpty || r[0] == null) continue;
//       final key = r[0].toString().trim().toUpperCase();
//       final val = parseDouble(r.length > 1 ? r[1] : 0);
//       if (key.isNotEmpty) map[key] = val;
//     }

//     return map;
//   }

//   /// Parse Excel file into Map<metal, value>
//   static Map<String, double> parseExcel(Excel excel) {
//     final sheet = excel.tables[excel.tables.keys.first]!;
//     final map = <String, double>{};

//     for (int r = 1; r < sheet.maxRows; r++) {
//       final row = sheet.row(r);
//       if (row.isEmpty) continue;
//       final key = (row[0]?.value?.toString() ?? '').trim().toUpperCase();
//       final val = parseDouble(row.length > 1 ? row[1]?.value : 0);
//       if (key.isNotEmpty) map[key] = val;
//     }

//     return map;
//   }

//   /// Parse PDF file into Map<metal, value>
//   static Map<String, double> parseFromPdfBytes(Uint8List bytes) {
//     final document = PdfDocument(inputBytes: bytes);
//     final extractor = PdfTextExtractor(document);
//     final text = extractor.extractText();
//     document.dispose();
//    print("📂 Raw PDF text:\n$text"); // 👈 Debug
//     final map = <String, double>{};
//     final regex = RegExp(r'([A-Za-z]{1,3})\s*[:\-]?\s*([\d\.Ee-]+)');

//     for (final m in regex.allMatches(text)) {
//       final metal = m.group(1)!.toUpperCase();
//       final val = parseDouble(m.group(2));
//       print("📂 Raw PDF text:\n$text"); // 👈 Debug
//       map[metal] = val;
//     }
//        print("✅ Final PDF Map: $map"); // 👈 Debug
//     return map;
//   }
// }
import 'dart:typed_data';
import 'dart:io' show File; // Only for non-web
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FileParser {
  // ✅ Standards (optional, can be used later for HPI/HEI calc)
  static const Map<String, double> standards = {
    "Pb": 0.01,
    "Cd": 0.003,
    "As": 0.01,
  };

  // ✅ Column mappings (normalize names)
  static const Map<String, String> columnMappings = {
    "lead": "Pb",
    "lead (pb)": "Pb",
    "pb": "Pb",
    "cadmium": "Cd",
    "cadmium (cd)": "Cd",
    "cd": "Cd",
    "arsenic": "As",
    "arsenic (as)": "As",
    "as": "As",
  };

  /// Picks a file and parses it into Map<metal, value>
  static Future<Map<String, double>?> pickAndParseFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls', 'pdf'],
      withData: true,
    );

    if (result == null) {
      print("❌ No file selected");
      return null;
    }

    final file = result.files.single;
    final ext = file.extension?.toLowerCase();

    try {
      if (ext == 'csv') {
        final content = file.bytes != null
            ? String.fromCharCodes(file.bytes!)
            : await File(file.path!).readAsString();
        return parseCsv(content);
      } else if (ext == 'xlsx' || ext == 'xls') {
        final bytes = file.bytes ?? await File(file.path!).readAsBytes();
        final excel = Excel.decodeBytes(bytes);
        return parseExcel(excel);
      } else if (ext == 'pdf') {
        final bytes = file.bytes ?? await File(file.path!).readAsBytes();
        return parseFromPdfBytes(bytes);
      }
    } catch (e) {
      print("❌ Parsing failed: $e");
    }

    return null;
  }

  /// Safely parse a double
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '').trim()) ?? 0.0;
    }
    return 0.0;
  }

  /// Normalize column/metal names
  static String normalizeKey(String raw) {
    final key = raw.trim().toLowerCase();
    return columnMappings[key] ?? raw.trim().toUpperCase();
  }

  // /// Parse CSV into Map
  // static Map<String, double> parseCsv(String content) {
  //   final rows = const CsvToListConverter().convert(content);
  //   final map = <String, double>{};

  //   for (var r in rows.skip(1)) {
  //     if (r.isEmpty || r[0] == null) continue;
  //     final key = normalizeKey(r[0].toString());
  //     final val = parseDouble(r.length > 1 ? r[1] : 0);
  //     if (key.isNotEmpty) map[key] = val;
  //   }

  //   print("✅ Parsed CSV Map: $map");
  //   return map;
  // }

  // /// Parse Excel into Map
  // static Map<String, double> parseExcel(Excel excel) {
  //   final sheet = excel.tables[excel.tables.keys.first]!;
  //   final map = <String, double>{};

  //   for (int r = 1; r < sheet.maxRows; r++) {
  //     final row = sheet.row(r);
  //     if (row.isEmpty) continue;
  //     final key = normalizeKey(row[0]?.value?.toString() ?? '');
  //     final val = parseDouble(row.length > 1 ? row[1]?.value : 0);
  //     if (key.isNotEmpty) map[key] = val;
  //   }

  //   print("✅ Parsed Excel Map: $map");
  //   return map;
  // }

/// Parse CSV into Map
static Map<String, double> parseCsv(String content) {
  final rows = const CsvToListConverter().convert(content);
  final map = <String, double>{};

  if (rows.isEmpty) return map;

  // Case 1: First row = keys, second row = values
  if (rows.length > 1) {
    for (int i = 0; i < rows[0].length; i++) {
      final key = normalizeKey(rows[0][i].toString());
      final val = parseDouble(rows[1][i]);
      if (key.isNotEmpty) map[key] = val;
    }
  }

  // Case 2: File structured as [Metal, Value] per row
  else {
    for (var r in rows.skip(1)) {
      if (r.isEmpty || r[0] == null) continue;
      final key = normalizeKey(r[0].toString());
      final val = parseDouble(r.length > 1 ? r[1] : 0);
      if (key.isNotEmpty) map[key] = val;
    }
  }

  print("✅ Parsed CSV Map: $map");
  return map;
}

/// Parse Excel into Map
static Map<String, double> parseExcel(Excel excel) {
  final sheet = excel.tables[excel.tables.keys.first]!;
  final map = <String, double>{};

  if (sheet.maxRows < 2) return map;

  // Case 1: First row headers, second row values
  final headerRow = sheet.row(0);
  final valueRow = sheet.row(1);

  for (int i = 0; i < headerRow.length; i++) {
    final key = normalizeKey(headerRow[i]?.value?.toString() ?? '');
    final val = parseDouble(i < valueRow.length ? valueRow[i]?.value : 0);
    if (key.isNotEmpty) map[key] = val;
  }

  print("✅ Parsed Excel Map: $map");
  return map;
}


  /// Parse PDF into Map (regex based)
  static Map<String, double> parseFromPdfBytes(Uint8List bytes) {
    final document = PdfDocument(inputBytes: bytes);
    final extractor = PdfTextExtractor(document);
    final text = extractor.extractText();
    document.dispose();

    print("📂 Raw PDF text:\n$text");

    final map = <String, double>{};

    // Regex: match "Lead = 0.02", "Pb: 0.03", etc
    final patterns = {
      "Pb": RegExp(r"(?:Pb|Lead)[^\d]{0,10}([\d\.]+)", caseSensitive: false),
      "Cd": RegExp(r"(?:Cd|Cadmium)[^\d]{0,10}([\d\.]+)", caseSensitive: false),
      "As": RegExp(r"(?:As|Arsenic)[^\d]{0,10}([\d\.]+)", caseSensitive: false),
    };

    patterns.forEach((metal, regex) {
      final match = regex.firstMatch(text);
      if (match != null) {
        map[metal] = parseDouble(match.group(1));
      }
    });

    print("✅ Final PDF Map: $map");
    return map;
  }
}

