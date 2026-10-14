import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  // للتحكم بفتح وإغلاق الكارت
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor, // خلفية بيضاء من ملف constant
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
          // 1. شريط العنوان التفاعلي (عند الضغط عليه يفتح أو يغلق)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: primary,
                        size: 20.s,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 15.s,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: grey,
                  size: 24.s,
                ),
              ],
            ),
          ),

          // 2. الحقول تظهر فقط عندما يكون الكارت مفتوحاً
          if (_isExpanded) ...[
            SizedBox(height: 16.h),
            Divider(color: grey.withOpacity(0.15), height: 1),
            SizedBox(height: 16.h),

            // السطر الأول: Name & Age
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Full Name',
                    value: 'Ahmad Khaled',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildFormField(label: 'Age', value: '25'),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // السطر الثاني: Date of Birth & Gender
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Date of Birth',
                    value: '12/01/2000',
                    suffixIcon: Icons.calendar_today_outlined,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildFormField(
                    label: 'Gender',
                    value: 'Male',
                    suffixIcon: Icons.keyboard_arrow_down_rounded,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // السطر الثالث: Height & Weight
            Row(
              children: [
                Expanded(
                  child: _buildFormField(label: 'Height', value: '178 cm'),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildFormField(label: 'Weight', value: '75 kg'),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // السطر الرابع: Weight Target & Date of Start
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Weight Target',
                    value: '70 kg',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildFormField(
                    label: 'Date of Start',
                    value: '01/05/2024',
                    suffixIcon: Icons.calendar_today_outlined,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // دالة مساعدة مخصصة لرسم الحقول المربعة بأناقة
  Widget _buildFormField({
    required String label,
    required String value,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.s,
            fontWeight: FontWeight.w500,
            color: grey,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: grey.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.s,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              if (suffixIcon != null) Icon(suffixIcon, size: 16.s, color: grey),
            ],
          ),
        ),
      ],
    );
  }
}
