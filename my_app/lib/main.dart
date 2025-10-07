
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/home_screen.dart';
// import 'screens/preview_screen.dart';
// import 'screens/result_screen.dart';
// import 'screens/map_screen.dart';
// import 'services/db_helper.dart';
// import 'services/compute.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'models/sample.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Hive (works on web, mobile, and desktop)
//   await Hive.initFlutter();

//   // Open Hive box for offline storage
//   await Hive.openBox('samples');

//   // Initialize your DBHelper
//   await DBHelper.instance.init();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<ComputeService>(create: (_) => ComputeService()),
//         Provider<DBHelper>(create: (_) => DBHelper.instance),
//       ],
//       child: MaterialApp(
//         title: 'HEI / HPI Groundwater',
//         theme: ThemeData(primarySwatch: Colors.green),
//         initialRoute: '/',
//         onGenerateRoute: (settings) {
//           switch (settings.name) {
//             case '/':
//               return MaterialPageRoute(builder: (_) => HomeScreen());

//             case '/preview':
//               final args = settings.arguments as Map<String, dynamic>;
//               return MaterialPageRoute(
//                 builder: (_) => PreviewScreen(
//                   sample: args['sample'] as Sample,
//                   onProceed: args['onProceed'] as VoidCallback,
//                 ),
//               );

//             case '/result':
//               final args = settings.arguments as Map<String, dynamic>;
//               return MaterialPageRoute(
//                 builder: (_) => ResultScreen(
//                   latitude: args['latitude'] as double,
//                   longitude: args['longitude'] as double,
//                   isSafe: args['isSafe'] as bool,
//                   sample: args['sample'] as Sample,
//                 ),
//               );

//             default:
//               return null;
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/home_screen.dart';
// import 'screens/result_screen.dart';
// import 'screens/hpi_result_screen.dart';
// import 'screens/hei_result_screen.dart';
// import 'screens/map_result_screen.dart';
// import 'services/db_helper.dart';
// import 'services/compute.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'models/sample.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Hive.initFlutter();
//   await Hive.openBox('samples');

//   await DBHelper.instance.init();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<ComputeService>(create: (_) => ComputeService()),
//         Provider<DBHelper>(create: (_) => DBHelper.instance),
//       ],
//       child: MaterialApp(
//         title: 'AQUAMATRIX',
//         theme: ThemeData(primarySwatch: Colors.green),
//         initialRoute: '/',
//         onGenerateRoute: (settings) {
//           final args = settings.arguments;
//           switch (settings.name) {
//             case '/':
//               return MaterialPageRoute(builder: (_) => const HomeScreen());

//             case '/resultPage':
//               final mapArgs = args as Map<String, dynamic>;
//               return MaterialPageRoute(
//                 builder: (_) => ResultPage(sample: mapArgs['sample'] as Sample),
//               );

//             case '/hpi':
//               final mapArgs2 = args as Map<String, dynamic>;
//               return MaterialPageRoute(
//                 builder: (_) =>
//                     HPIResultScreen(sample: mapArgs2['sample'] as Sample),
//               );

//             case '/hei':
//               final mapArgs3 = args as Map<String, dynamic>;
//               return MaterialPageRoute(
//                 builder: (_) =>
//                     HEIResultScreen(sample: mapArgs3['sample'] as Sample),
//               );

//             case '/mapresult':
//               return MaterialPageRoute(builder: (_) => const MapResultScreen());

//             default:
//               return null;
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/home_screen.dart';
// import 'screens/result_screen.dart';
// import 'screens/hpi_result_screen.dart';
// import 'screens/hei_result_screen.dart';
// import 'screens/map_result_screen.dart';
// import 'services/db_helper.dart';
// import 'services/compute.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'models/sample.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // ✅ Initialize Hive for local storage
//   await Hive.initFlutter();
//   await Hive.openBox('samples');

//   // ✅ Initialize your DB helper
//   await DBHelper.instance.init();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<ComputeService>(create: (_) => ComputeService()),
//         Provider<DBHelper>(create: (_) => DBHelper.instance),
//       ],
//       child: MaterialApp(
//         title: 'AQUAMATRIX',
//         theme: ThemeData(primarySwatch: Colors.green),
//         initialRoute: '/',
//         onGenerateRoute: (settings) {
//           final args = settings.arguments;

//           switch (settings.name) {
//             case '/':
//               return MaterialPageRoute(builder: (_) => const HomeScreen());

//             case '/resultPage':
//               final mapArgs = args as Map<String, dynamic>;
//               return MaterialPageRoute(
//                 builder: (_) =>
//                     ResultScreen(sample: mapArgs['sample'] as Sample), // ✅ fixed
//               );

//             case '/hpi':
//               final mapArgs2 = args as Map<String, dynamic>;
//               return MaterialPageRoute(
//                 builder: (_) =>
//                     HPIResultScreen(sample: mapArgs2['sample'] as Sample),
//               );

//             case '/hei':
//               final mapArgs3 = args as Map<String, dynamic>;
//               return MaterialPageRoute(
//                 builder: (_) =>
//                     HEIResultScreen(sample: mapArgs3['sample'] as Sample),
//               );

//             case '/mapresult':
//               return MaterialPageRoute(
//                 builder: (_) => const MapResultScreen(),
//               );

//             default:
//               return null;
//           }
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/hpi_result_screen.dart';
import 'screens/hei_result_screen.dart';
import 'screens/map_result_screen.dart';
import 'services/db_helper.dart';
import 'services/compute.dart';
import 'services/sync_manager.dart'; // ✅ Import SyncManager
import 'package:hive_flutter/hive_flutter.dart';
import 'models/sample.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(SampleAdapter()); // ✅ Register your Hive adapter
  await Hive.openBox<Sample>('samples');

  // ✅ Initialize your DB helper
  await DBHelper.instance.init();

  // ✅ Initialize SyncManager to start autosync
  SyncManager(); // Creates singleton and starts background sync

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ComputeService>(create: (_) => ComputeService()),
        Provider<DBHelper>(create: (_) => DBHelper.instance),
      ],
      child: MaterialApp(
        title: 'AQUAMATRIX',
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          final args = settings.arguments;

          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const HomeScreen());

            case '/resultPage':
              final mapArgs = args as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) =>
                    ResultScreen(sample: mapArgs['sample'] as Sample),
              );

            case '/hpi':
              final mapArgs2 = args as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) =>
                    HPIResultScreen(sample: mapArgs2['sample'] as Sample),
              );

            case '/hei':
              final mapArgs3 = args as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) =>
                    HEIResultScreen(sample: mapArgs3['sample'] as Sample),
              );

            case '/mapresult':
              return MaterialPageRoute(
                builder: (_) => const MapResultScreen(),
              );

            default:
              return null;
          }
        },
      ),
    );
  }
}
