import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const CoachApp());
}

class CoachApp extends StatelessWidget {
  const CoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: getIt<GlobalKey<NavigatorState>>(),
      home: SplashScreen(),
    );
  }
}
