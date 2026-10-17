import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class HealthAndBiometricsCards extends StatelessWidget {
  final VoidCallback? onHealthTap;
  final VoidCallback? onBiometricsTap;

  const HealthAndBiometricsCards({
    super.key,
    this.onHealthTap,
    this.onBiometricsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              icon: Icons.favorite_rounded,
              iconColor: const Color(0xFFEF4444),
              title: 'Health History',
              subtitle: 'Conditions & notes',
              onTap: onHealthTap ?? () {},
            ),
          ),
          SizedBox(width: 12.w),
          // 2. كارت القياسات الحيوية (Biometric Data)
          Expanded(
            child: _buildActionCard(
              icon: Icons.monitor_heart_rounded,
              iconColor: primary, // الأزرق الأساسي
              title: 'Biometric Data',
              subtitle: 'Body metrics & logs',
              onTap: onBiometricsTap ?? () {},
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت مساعدة لبناء كل كارت
  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: cardColor, // أبيض
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // دائرة الأيقونة
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20.s),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.s,
                  color: grey.withOpacity(0.6),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.s,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.s,
                color: grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
