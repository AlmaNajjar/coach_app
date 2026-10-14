import 'package:coach_app/features/clients/presentation/widgets/health_and_biometrics.dart';
import 'package:coach_app/features/clients/presentation/widgets/personal_info_section.dart';
import 'package:coach_app/features/clients/presentation/widgets/trainee_details_app_bar.dart';
import 'package:coach_app/features/clients/presentation/widgets/trainee_header_cart.dart';
import 'package:flutter/material.dart';

class TraineeDetailsScreen extends StatelessWidget {
  const TraineeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FD),

      appBar: TraineeDetailsAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TraineeHeaderCart(),
            PersonalInfoSection(),
            HealthAndBiometricsCards(),
          ],
        ),
      ),
    );
  }
}
