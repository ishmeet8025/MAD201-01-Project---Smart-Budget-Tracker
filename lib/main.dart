import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/splash_screen.dart';
import 'utils/shared_prefs_helper.dart';
import 'db/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await DBHelper.init(); // initialize Hive DB
  await SharedPrefsHelper.initPrefs(); // init SharedPreferences

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = SharedPrefsHelper.getTheme();

  void _toggleTheme(bool val) {
    setState(() => _isDark = val);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Budget Tracker Lite',
      debugShowCheckedModeBanner: false,
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: const SplashScreen(), // Start with SplashScreen
    );
  }
}
