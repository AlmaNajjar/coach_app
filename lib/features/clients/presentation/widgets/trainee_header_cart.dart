import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class TraineeHeaderCart extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final String? phone;
  final String? status;
  final String? endDate;
  final String? startDate;
  final int sessionsAllocated;
  final int sessionsConsumed;

  const TraineeHeaderCart({
    super.key,
    required this.name,
    this.photoUrl,
    this.phone,
    this.status,
    this.endDate,
    this.startDate,
    this.sessionsAllocated = 0,
    this.sessionsConsumed = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // المحتوى الأساسي
          Column(
            children: [
              // 1. الصورة والاسم والشارة
              Row(
                children: [
                  CircleAvatar(
                    radius: 34.r,
                    backgroundColor: Colors.transparent,
                    backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                        ? NetworkImage(photoUrl!)
                        : const AssetImage('assets/image/femele.jpg')
                              as ImageProvider,
                  ),

                  SizedBox(width: 14.w),

                  // الاسم والشارة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.s,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF3FC),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            status ?? 'Trainee',
                            style: TextStyle(
                              color: primary,
                              fontSize: 11.s,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),
              Divider(color: Colors.grey.withOpacity(0.12), height: 1),
              SizedBox(height: 12.h),

              // 2. العناصر السفلية (الهاتف، تاريخ الانتهاء، الحالة)
              // 2. العناصر السفلية: الهاتف، تاريخ البداية، تاريخ النهاية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoItem(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: phone != null && phone!.isNotEmpty ? phone! : '—',
                  ),
                  Container(
                    height: 24.h,
                    width: 1,
                    color: Colors.grey.withOpacity(0.15),
                  ),
                  _InfoItem(
                    icon: Icons.play_circle_outline_rounded,
                    label: 'Start Date',
                    value: startDate != null && startDate!.isNotEmpty
                        ? startDate!
                        : '—',
                  ),
                  Container(
                    height: 24.h,
                    width: 1,
                    color: Colors.grey.withOpacity(0.15),
                  ),
                  _InfoItem(
                    icon: Icons.flag_outlined,
                    label: 'End Date',
                    value: endDate != null && endDate!.isNotEmpty
                        ? endDate!
                        : '—',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF3FC),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 16.s, color: const Color(0xFF3B8FE3)),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.s,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.s,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
