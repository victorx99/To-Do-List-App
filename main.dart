// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task.dart';
import 'intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // New Slate & Electric Blue Palette
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Color.blue,
          surface: Color.white,
          primaryContainer: const Color(0xFFD1E2FF),
        ),
        fontFamily: 'SF Pro',
      ),
      home: const IntroScreen(),
    );
  }
}