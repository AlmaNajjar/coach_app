import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class CoachHomeHeader extends StatelessWidget {
  const CoachHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNotificationButton(),

            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //  border: Border.all(color: white, width: 1.w),
                boxShadow: [
                  BoxShadow(
                    color: black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage("assets/image/splash.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        Text(
          'Good Morning,',
          style: TextStyle(
            fontSize: 16.s,
            fontWeight: FontWeight.w400,
            color: grey,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              'Coach',
              style: TextStyle(
                fontSize: 26.s,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(width: 8.w),

            Icon(Icons.watch, size: 24.s, color: primary.withOpacity(0.5)),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          'Better People. Stronger Tomorrow.',
          style: TextStyle(
            fontSize: 12.s,
            color: grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

Widget _buildNotificationButton() {
  return Container(
    width: 44.w,
    height: 44.w,
    decoration: BoxDecoration(
      color: white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.notifications_none_rounded, size: 22.s, color: textColor),
        Positioned(
          top: 0.h,
          left: 30.w,
          child: Container(
            width: 7.w,
            height: 7.w,
            decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
          ),
        ),
      ],
    ),
  );
}
