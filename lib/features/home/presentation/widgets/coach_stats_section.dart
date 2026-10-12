import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_profile_cubit.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachStatsSection extends StatelessWidget {
  const CoachStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachProfileCubit, CoachProfileState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.group_outlined,
                title: 'Total Subscribers',
                value: '${state.profile?.totalSubscribers ?? 0}',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _StatCard(
                icon: Icons.timer_outlined,
                title: 'Expiring Soon',
                value: '${state.expiringSoonCount}',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8.w,
            bottom: -8.h,
            child: Icon(
              Icons.water,
              size: 44.s,
              color: primary.withOpacity(0.07),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22.s, color: primary),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.s,
                        fontWeight: FontWeight.w500,
                        color: grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 22.s,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
