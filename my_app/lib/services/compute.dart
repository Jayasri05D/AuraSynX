// import 'package:intl/intl.dart';

// final Map<String, double> standards = {
//   'Pb': 0.01, 'Cd': 0.003, 'Cr': 0.05, 'Cu': 2.0,
//   'Zn': 3.0, 'Ni': 0.02, 'Fe': 0.3, 'Mn': 0.1, 'As': 0.01,
// };

// class ComputeService {
//   double computeHEI(Map<String, double> sample) {
//     double sum = 0.0;
//     for (final k in sample.keys) {
//       if (standards.containsKey(k) && standards[k]! > 0) {
//         sum += sample[k]! / standards[k]!;
//       }
//     }
//     return sum;
//   }

//   double computeHPI(Map<String, double> sample) {
//     double numerator = 0.0;
//     double denom = 0.0;
//     final double ideal = 0.0;
//     for (final k in sample.keys) {
//       if (!standards.containsKey(k)) continue;
//       final Mi = sample[k]!;
//       final Si = standards[k]!;
//       if (Si == 0) continue;
//       final Qi = ((Mi - ideal) / (Si - ideal)) * 100.0;
//       final Wi = 1.0 / Si;
//       numerator += Wi * Qi;
//       denom += Wi;
//     }
//     if (denom == 0) return 0.0;
//     return numerator / denom;
//   }

//   String classifyByHEI(double hei) {
//     if (hei < 10) return 'safe';
//     if (hei < 20) return 'moderate';
//     return 'unsafe';
//   }

//   String classifyByHPI(double hpi) {
//     if (hpi <= 100) return 'safe';
//     return 'unsafe';
//   }

//   String timestampNow() => DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
// }
import 'package:intl/intl.dart';

/// Standard limits for metals (uppercase keys)
final Map<String, double> standards = {
  'PB': 0.01,
  'CD': 0.003,
  'CR': 0.05,
  'CU': 2.0,
  'ZN': 3.0,
  'NI': 0.02,
  'FE': 0.3,
  'MN': 0.1,
  'AS': 0.01,
};

class ComputeService {
  /// Compute Heavy Metal Evaluation Index (HEI)
  double computeHEI(Map<String, double> sample) {
    double sum = 0.0;
    for (final k in sample.keys) {
      final key = k.toUpperCase(); // normalize
      if (standards.containsKey(key) && standards[key]! > 0) {
        sum += sample[k]! / standards[key]!;
      }
    }
    return sum;
  }
 
  /// Compute Heavy Metal Pollution Index (HPI)
  double computeHPI(Map<String, double> sample) {
    double numerator = 0.0;
    double denom = 0.0;
    final double ideal = 0.0;

    for (final k in sample.keys) {
      final key = k.toUpperCase();
      if (!standards.containsKey(key)) continue;

      final Mi = sample[k]!;
      final Si = standards[key]!;
      if (Si == 0) continue;

      final Qi = ((Mi - ideal) / (Si - ideal)) * 100.0;
      final Wi = 1.0 / Si;

      numerator += Wi * Qi;
      denom += Wi;
    }

    if (denom == 0) return 0.0;
    return numerator / denom;
  }

  /// Classification based on HEI
  String classifyByHEI(double hei) {
    if (hei < 10) return 'safe';
    if (hei < 20) return 'moderate';
    return 'unsafe';
  }

  /// Classification based on HPI
  String classifyByHPI(double hpi) {
    if (hpi <= 100) return 'safe';
    return 'unsafe';
  }

  /// Current timestamp as string
  String timestampNow() =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}
