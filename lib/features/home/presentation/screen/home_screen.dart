import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_bottom_nav_bar.dart'; // ← عدّل المسار حسب مكان الملف
import 'package:coach_app/features/home/presentation/widgets/coach_home_header.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_profile_card.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_profile_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);

    // TODO: اربط التنقل بشاشاتك، مثال:
    // switch (index) {
    //   case 1: Navigator.pushNamed(context, '/clients'); break;
    //   case 2: Navigator.pushNamed(context, '/schedule'); break;
    //   case 3: Navigator.pushNamed(context, '/account'); break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return BlocProvider(
      create: (_) => getIt<CoachProfileCubit>()..load(),
      child: Scaffold(
        extendBody: true, // عشان الخلفية والمحتوى يمتدوا خلف البار الزجاجي
        bottomNavigationBar: CoachBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
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
              bottom: false, // البار بيهتم بالـ bottom inset لحاله
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 130.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoachHomeHeader(),
                    SizedBox(height: 16.h),
                    CoachProfileCard(),
                    SizedBox(height: 16.h),
                    CoachStatsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}