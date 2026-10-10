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
          Expanded(
            flex: 6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المدرب من الـ API أو صورة بديلة
                Container(
                  width: 55.w,
                  height: 55.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: backgroundColor, width: 1.w),
                    image:
                        (profile.photoUrl != null &&
                            profile.photoUrl!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(profile.photoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (profile.photoUrl == null || profile.photoUrl!.isEmpty)
                      ? Icon(Icons.person, color: grey, size: 28.s)
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
                                fontSize: 15.s,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.verified, size: 16.s, color: primary),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // المسمى الوظيفي
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          profile.workStatus ?? 'Fitness Coach',
                          style: TextStyle(
                            fontSize: 14.s,
                            color: const Color.fromARGB(255, 78, 189, 82),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // 1. سنوات الخبرة + الجنس
                      Row(
                        children: [
                          Icon(
                            Icons.workspace_premium_outlined,
                            size: 14.s,
                            color: const Color(0xFFF59E0B), // لون برتقالي ذهبي
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${profile.experienceYears ?? 0} سنوات خبرة',
                            style: TextStyle(
                              fontSize: 11.s,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // 2. رقم الهاتف
                      if (profile.phone != null &&
                          profile.phone!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 12.s,
                              color: primary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              profile.phone!,
                              style: TextStyle(
                                fontSize: 13.s,
                                color: grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: 8.h),

                      // الشارات (نعرض أسماء الفروع الخاصة بالمدرب كـ Tags)
                      Wrap(
                        spacing: 4.w,
                        runSpacing: 4.h,
                        children: profile.branches.isNotEmpty
                            ? profile.branches
                                  .map((branch) => _buildTag(branch.name))
                                  .toList()
                            : [
                                _buildTag('Strength'),
                                _buildTag('Endurance'),
                                _buildTag('Fitness'),
                              ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. خط فاصل عمودي
          Container(
            height: 90.h,
            width: 1.w,
            color: grey.withOpacity(0.2),
            margin: EdgeInsets.symmetric(horizontal: 8.w),
          ),

          // 3. الجزء الأيمن: دائرة نسبة العمولة
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 52.w,
                  height: 52.w,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 4.w,
                        valueColor: AlwaysStoppedAnimation<Color>(grey),
                      ),
                      // قوس النسبة الفعلي بلون التطبيق الأساسي
                      CircularProgressIndicator(
                        value: ((profile.privateCommissionRate ?? 0) / 100)
                            .clamp(0.0, 1.0),
                        strokeWidth: 4.w,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          primary.withOpacity(0.6),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Text(
                          '${profile.privateCommissionRate?.toInt() ?? 0}%',
                          style: TextStyle(
                            fontSize: 12.s,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'عمولة التدريب',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.s,
                    color: grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
      mainAxisSize: MainAxisSize.min, // ليأخذ حجم الأيقونة والنص فقط
      children: [
        Icon(
          Icons.location_on_outlined, // أيقونة الفرع / الموقع
          size: 14.s,
          color: primary,
        ),
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
