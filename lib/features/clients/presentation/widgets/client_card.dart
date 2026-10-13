import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class ClientCard extends StatelessWidget {
  final String name;
  final String programName;
  final String status;
  final double progress; // من 0.0 إلى 1.0 (مثلاً 0.68 تعني 68%)
  final String? photoUrl;
  final VoidCallback? onTap;
  const ClientCard({
    super.key,
    required this.name,
    required this.programName,
    required this.status,
    required this.progress,
    this.photoUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status.toLowerCase() == 'active' || status == 'فعال';
    final Color statusColor = isActive
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. الصورة الشخصية للمتدرب
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withOpacity(0.08),
                image: (photoUrl != null && photoUrl!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(photoUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (photoUrl == null || photoUrl!.isEmpty)
                  ? Icon(
                      Icons.person_outline_rounded,
                      color: primary,
                      size: 24.s,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            // 2. العمود الأوسط: البيانات والإنجاز
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // أ. الاسم + نقطة الحالة
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14.s,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // نقطة الحالة
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 10.s,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // ب. اسم البرنامج والنشاط
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center_rounded,
                        size: 13.s,
                        color: grey,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          programName,
                          style: TextStyle(fontSize: 11.s, color: grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: grey.withOpacity(0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isActive ? const Color(0xFF10B981) : primary,
                            ),
                            minHeight: 5.h,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 10.s,
                          fontWeight: FontWeight.bold,
                          color: grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // 3. سهم التنقل
            Icon(
              Icons.chevron_right_rounded,
              color: grey.withOpacity(0.6),
              size: 22.s,
            ),
          ],
        ),
      ),
    );
  }
}
