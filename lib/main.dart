import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WeatherApp());
}

/// Main application widget
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const HomeScreen(),
    );
  }
}
