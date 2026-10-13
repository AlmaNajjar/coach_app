import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/clients/presentation/screen/clients_screen.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_bottom_nav_bar.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_home_header.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_profile_card.dart';
import 'package:coach_app/features/home/presentation/widgets/coach_stats_section.dart';
import 'package:coach_app/features/home/presentation/widgets/week_calendar_card.dart';
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
  DateTime _selectedDate = DateTime.now();

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    // TODO: لاحقاً بتجيب جلسات هاد اليوم من الـ Cubit، مثلاً:
    // context.read<CoachSessionsCubit>().loadByDate(date);
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return BlocProvider(
      create: (_) => getIt<CoachProfileCubit>()..load(),
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: CoachBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
        body: _currentIndex == 1
            ? const ClientsScreen()
            : Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/image/splash_ground.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    bottom: false,
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
                          SizedBox(height: 16.h),
                          WeekCalendarCard(
                            initialDate: _selectedDate,
                            onDateSelected: _onDateSelected,
                          ),
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
