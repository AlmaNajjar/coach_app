import 'package:coach_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoachApp());
}

class CoachApp extends StatelessWidget {
  const CoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
