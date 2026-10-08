import 'package:coach_app/core/helper/local_storage.dart';
import 'package:coach_app/core/networking/dio_factory.dart';
import 'package:coach_app/features/auth/presentation/screens/log_in_screen.dart';
import 'package:flutter/material.dart';

class CoachHomeScreen extends StatelessWidget {
  const CoachHomeScreen({super.key});

  Future<void> _logOut(BuildContext context) async {
    await LocalStorage.clearData('token');
    await LocalStorage.clearData('token_type');
    await LocalStorage.clearData('user_data');
    DioFactory.clearTokenFromHeader();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LogInScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: AppBar(
        title: const Text('Coach'),
        backgroundColor: const Color(0xFFF0F7FF),
        actions: [
          IconButton(
            tooltip: 'Log out',
            onPressed: () => _logOut(context),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fitness_center_rounded,
                size: 56,
                color: Color(0xFF388FC7),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome back, Coach',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF173B59),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your coaching dashboard will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF658196), fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
