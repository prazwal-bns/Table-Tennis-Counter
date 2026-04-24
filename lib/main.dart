import 'package:flutter/material.dart';
import 'package:table_tennis_counter/screens/home_screen.dart';

/// App entry point.
void main() {
  runApp(const TableTennisApp());
}

/// Root app widget with global theme configuration.
class TableTennisApp extends StatelessWidget {
  const TableTennisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Tennis Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D9488)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
