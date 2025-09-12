// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/home_screen.dart';
// import 'screens/preview_screen.dart';
// import 'screens/result_screen.dart';
// import 'screens/map_screen.dart';
// import 'services/db_helper.dart';
// import 'services/compute.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Hive (works on web, mobile, and desktop)
//   await Hive.initFlutter();

//   // Open Hive box for offline storage
//   await Hive.openBox('samples');

//   // Initialize your DBHelper
//   await DBHelper.instance.init();

//   runApp(MyApp());
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
//         routes: {
//           '/': (context) => HomeScreen(), // removed const
//           '/preview': (context) => PreviewScreen(),
//           '/result': (context) => ResultScreen(),
//           //'/map': (context) => MapScreen(),
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/preview_screen.dart';
import 'screens/result_screen.dart';
import 'screens/map_screen.dart';
import 'services/db_helper.dart';
import 'services/compute.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/sample.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (works on web, mobile, and desktop)
  await Hive.initFlutter();

  // Open Hive box for offline storage
  await Hive.openBox('samples');

  // Initialize your DBHelper
  await DBHelper.instance.init();

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
        title: 'HEI / HPI Groundwater',
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => HomeScreen());

            case '/preview':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => PreviewScreen(
                  sample: args['sample'] as Sample,
                  onProceed: args['onProceed'] as VoidCallback,
                ),
              );

            case '/result':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => ResultScreen(
                  latitude: args['latitude'] as double,
                  longitude: args['longitude'] as double,
                  isSafe: args['isSafe'] as bool,
                  sample: args['sample'] as Sample,
                ),
              );

            default:
              return null;
          }
        },
      ),
    );
  }
}

