import 'package:flutter/material.dart';
import 'package:ml_workshop/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machine Learning Workshop',
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black)
        )
      ),
      home: const MainScreen(),
    );
  }
}