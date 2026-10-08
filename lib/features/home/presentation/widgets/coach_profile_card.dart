import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class CoachProfileCard extends StatelessWidget {
  const CoachProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                Container(
                  width: 55.w,
                  height: 55.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: backgroundColor, width: 1.w),
                    image: const DecorationImage(
                      image: AssetImage("assets/image/splash.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Coach Name',
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
                      Text(
                        'Fitness Coach',
                        style: TextStyle(
                          fontSize: 12.s,
                          color: grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              Icons.star_rounded,
                              size: 14.s,
                              color: const Color(0xFFFBBF24),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '4.9',
                            style: TextStyle(
                              fontSize: 11.s,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            ' (128 reviews)',
                            style: TextStyle(fontSize: 10.s, color: grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      Wrap(
                        spacing: 4.w,
                        runSpacing: 4.h,
                        children: [
                          _buildTag('Strength'),
                          _buildTag('Endurance'),
                          _buildTag('Fat Loss'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 90.h,
            width: 1.w,
            color: grey.withOpacity(0.2),
            margin: EdgeInsets.symmetric(horizontal: 8.w),
          ),

          Expanded(
            flex: 3,
            child: Text(
              '" Small steps\nevery day lead\nto big results. "',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.s,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: grey,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 9.s,
          fontWeight: FontWeight.w500,
          color: primary,
        ),
      ),
    );
  }
}
