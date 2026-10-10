import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_home_header.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_profile_card.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_profile_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return BlocProvider(
      create: (_) => getIt<CoachProfileCubit>()..load(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/image/splash_ground.jpg",
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoachHomeHeader(),
                    SizedBox(height: 16.h),
                    CoachProfileCard(),
                    SizedBox(height: 16),
                  ],
                ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CoachHomeHeader(),
                  SizedBox(height: 16.h),
                  CoachProfileCard(),
                  SizedBox(height: 16),
                  CoachStatsSection(),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
