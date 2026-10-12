import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/home/domain/entities/coach_profile.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_profile_cubit.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachProfileCard extends StatelessWidget {
  const CoachProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachProfileCubit, CoachProfileState>(
      builder: (context, state) {
        if (state.isLoading || state.status == CoachProfileStatus.initial) {
          return _buildMessageCard(
            child: const Center(child: CircularProgressIndicator()),
            height: 150,
          );
        }

        if (state.status == CoachProfileStatus.failure) {
          return _buildMessageCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'Unable to load coach information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontSize: 13.s),
                ),
                SizedBox(height: 8.h),
                TextButton.icon(
                  onPressed: () => context.read<CoachProfileCubit>().load(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ],
            ),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return _buildMessageCard(
            child: const Text('Coach information is unavailable.'),
          );
        }

        return _buildProfileCard(context, profile);
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, CoachProfile profile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 55.w,
            height: 55.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: backgroundColor, width: 1.w),
              image: (profile.photoUrl != null && profile.photoUrl!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(profile.photoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (profile.photoUrl == null || profile.photoUrl!.isEmpty)
                ? ClipOval(
                    child: Image.asset(
                      'assets/image/splash.jpg',
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
          ),

          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الاسم الكامل + شارة التوثيق
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.fullName,
                        style: TextStyle(
                          fontSize: 22.s,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Icon(Icons.verified, size: 16.s, color: primary),
                  ],
                ),
                SizedBox(height: 5.h),
                // المسمى الوظيفي
                Text(
                  profile.workStatus ?? 'Fitness Coach',
                  style: TextStyle(
                    fontSize: 14.s,
                    color: const Color.fromARGB(255, 78, 189, 82),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 45.h,
            width: 1.w,
            color: grey.withOpacity(0.3),
            margin: EdgeInsets.symmetric(horizontal: 20.w),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 20.h),
              if (profile.username != null) ...[
                Text(
                  '${profile.username}',
                  style: TextStyle(
                    fontSize: 11.s,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),

                SizedBox(height: 4.h),

                // الشارات (نعرض أسماء الفروع الخاصة بالمدرب كـ Tags)
                Wrap(
                  spacing: 4.w,
                  runSpacing: 4.h,
                  children: profile.branches.isNotEmpty
                      ? profile.branches
                            .map((branch) => _buildTag(branch.name))
                            .toList()
                      : [_buildTag('Endurance')],
                ),
                SizedBox(height: 10.h),
              ],
            ],
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }

  Widget _buildMessageCard({required Widget child, double? height}) {
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.all(18.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: child,
    );
  }

  Widget _buildTag(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on_outlined, size: 14.s, color: grey),
        SizedBox(width: 4.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.s,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
